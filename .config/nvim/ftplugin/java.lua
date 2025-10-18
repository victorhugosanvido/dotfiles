local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = '/home/vsanvido/Documents/1-Configurations/3-Eclipse/' .. project_name
local home = os.getenv('HOME');
local config = {
    cmd = {
        home .. '/.sdkman/candidates/java/21.0.7-tem/bin/java', -- or '/path/to/java21_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',

        '-jar', home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',
        '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
                        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                        -- Must point to the                      Change to one of `linux`, `win` or `mac`
                        -- eclipse.jdt.ls installation            Depending on your system.


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', workspace_dir
    },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
        bundles = {
            vim.fn.glob(home .. "/Documents/1-Configurations/0-Drivers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
        }
    },
}


config['on_attach'] = function(client, bufnr)
    require('jdtls').setup_dap({ hotcodereplace = 'auto '})
end

require('jdtls').start_or_attach(config)
