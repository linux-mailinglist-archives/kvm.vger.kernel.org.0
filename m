Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FF24C0C0D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbiBWF1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238369AbiBWF1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:27:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A8D6C1F1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:23 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso26588090ybs.20
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AJ9oF4MxpZqgNWeQmqV576xo41knbB79umnOaNmXddY=;
        b=gDjBd/x5dYNgFpVj+6AXYinaFyQ0y0nY9xCgZVbh0gj9MDv8hxw/demmgSf5+q0lIl
         f5u9TMyC094RJt+uGxErIIL6jEyzHxyof4Xb7WeyC6uYfiR8WIq5qp+TlkXog/JDvZk7
         2mtgyW1bRYWB4o+N58ElEO1CyDNRbfSatixMLbQR1FnYuk0Gfj5u+Ct8tTOprcSTTI3D
         O9Kk/stLoRds2nPZbzZ/5aJHis4MCrOVxHj7FYqsiO1KWp6tTJxhsj5RQHjcB5DUXElF
         yIJbJ9KqvnvVAuRlFRGpGXt2ubrzQb0wSafap3WMiTiEiFUzbC7xRedGoDqwKzVo3u9S
         eXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AJ9oF4MxpZqgNWeQmqV576xo41knbB79umnOaNmXddY=;
        b=3Kves+PRFfbF06kf4QiDJwpFGuoGKjrLcwsn1yJZnz37bV9CfgykwZ3xilX9fxGcwV
         Isag8D3yrAdhmjxqp/KSkxsVKlJ7J8JI63b1IqDJwv5QnnfAl253b86kJIL8FAFXYgO4
         bdXBPkK8SJ/BoSZvgsbNOTsuIaUiKxgnnJdqe8YWJw/8hWLT/FgIRmquZT8aRbNZWpqA
         RMfLGhYCHwJoqqUO/Yx6Mr9LyLCrRLV+OUoUQO961olwRJdNay1e3D9GsQwc83jYE0+T
         8J6OFsrf3+D79fisfQb9aYTqnqlIpUNGiPoUYOnZYKIDqOaf5Z9DxAHLSxFAi7d0mQOf
         5kEg==
X-Gm-Message-State: AOAM530gZWmT0Gkzwjyaf1alU0RlUCJzlh0C3MnQinqByrqQkmbPGRnH
        K8xOqSE5Y0bXbazMyoPuUZ3GC38oRZyb
X-Google-Smtp-Source: ABdhPJxXcU94ggDYk55LTym0qr5/ST37jyZ7dcNnih2o73ZZ8KtzSOHKd++I3ohJEg/v0wMLNTTLtdFeGJBD
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:3dcb:0:b0:2ca:72dd:904c with SMTP id
 k194-20020a813dcb000000b002ca72dd904cmr28454275ywa.290.1645593914646; Tue, 22
 Feb 2022 21:25:14 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:16 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-41-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 40/47] mm: asi: support for static percpu DEFINE_PER_CPU*_ASI
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ofir Weisse <oweisse@google.com>

Implemented the following PERCPU static declarations:

- DECLARE/DEFINE_PER_CPU_ASI_NOT_SENSITIVE
- DECLARE/DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE
- DECLARE/DEFINE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE
- DECLARE/DEFINE_PER_CPU_PAGE_ALIGNED_ASI_NOT_SENSITIVE

These definitions are also supported in dynamic modules.
To support percpu variables in dynamic modules, we're creating an ASI
pcpu reserved chunk. The reserved size PERCPU_MODULE_RESERVE is now
split between the normal reserved chunk and the ASI one.

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/mm/asi.c                 |  39 +++++++-
 include/asm-generic/percpu.h      |   6 ++
 include/asm-generic/vmlinux.lds.h |   5 +
 include/linux/module.h            |   6 ++
 include/linux/percpu-defs.h       |  39 ++++++++
 include/linux/percpu.h            |   8 +-
 kernel/module-internal.h          |   1 +
 kernel/module.c                   | 154 ++++++++++++++++++++++++++----
 mm/percpu.c                       | 134 ++++++++++++++++++++++----
 9 files changed, 356 insertions(+), 36 deletions(-)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 6c14aa1fc4aa..ba373b461855 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -309,6 +309,32 @@ static int __init set_asi_param(char *str)
 }
 early_param("asi", set_asi_param);
 
+static int asi_map_percpu(struct asi *asi, void *percpu_addr, size_t len)
+{
+       int cpu, err;
+       void *ptr;
+
+       for_each_possible_cpu(cpu) {
+               ptr = per_cpu_ptr(percpu_addr, cpu);
+               err = asi_map(asi, ptr, len);
+               if (err)
+                       return err;
+       }
+
+       return 0;
+}
+
+static void asi_unmap_percpu(struct asi *asi, void *percpu_addr, size_t len)
+{
+       int cpu;
+       void *ptr;
+
+       for_each_possible_cpu(cpu) {
+               ptr = per_cpu_ptr(percpu_addr, cpu);
+               asi_unmap(asi, ptr, len, true);
+       }
+}
+
 /* asi_load_module() is called from layout_and_allocate() in kernel/module.c
  * We map the module and its data in init_mm.asi_pgd[0].
 */
@@ -347,7 +373,13 @@ int asi_load_module(struct module* module)
         if (err)
                 return err;
 
-        return 0;
+	err = asi_map_percpu(ASI_GLOBAL_NONSENSITIVE,
+			     module->percpu_asi,
+			     module->percpu_asi_size );
+        if (err)
+                return err;
+
+       return 0;
 }
 EXPORT_SYMBOL_GPL(asi_load_module);
 
@@ -372,6 +404,9 @@ void asi_unload_module(struct module* module)
                       module->core_layout.once_section_offset,
                       module->core_layout.once_section_size, true);
 
+	asi_unmap_percpu(ASI_GLOBAL_NONSENSITIVE, module->percpu_asi,
+			 module->percpu_asi_size);
+
 }
 
 static int __init asi_global_init(void)
@@ -399,6 +434,8 @@ static int __init asi_global_init(void)
 
 	static_branch_enable(&asi_local_map_initialized);
 
+        pcpu_map_asi_reserved_chunk();
+
 	return 0;
 }
 subsys_initcall(asi_global_init)
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 6432a7fade91..40001b74114f 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -50,6 +50,12 @@ extern void setup_per_cpu_areas(void);
 
 #endif	/* SMP */
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+void __init pcpu_map_asi_reserved_chunk(void);
+#else
+static inline void pcpu_map_asi_reserved_chunk(void) {}
+#endif
+
 #ifndef PER_CPU_BASE_SECTION
 #ifdef CONFIG_SMP
 #define PER_CPU_BASE_SECTION ".data..percpu"
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c769d939c15f..0a931aedc285 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1080,6 +1080,11 @@
 	. = ALIGN(cacheline);						\
 	*(.data..percpu)						\
 	*(.data..percpu..shared_aligned)				\
+        . = ALIGN(PAGE_SIZE);                                           \
+        __per_cpu_asi_start = .;                                        \
+        *(.data..percpu..asi_non_sensitive)                             \
+        . = ALIGN(PAGE_SIZE);                                           \
+        __per_cpu_asi_end = .;                                          \
 	PERCPU_DECRYPTED_SECTION					\
 	__per_cpu_end = .;
 
diff --git a/include/linux/module.h b/include/linux/module.h
index 82267a95f936..d4d020bae171 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -463,6 +463,12 @@ struct module {
 	/* Per-cpu data. */
 	void __percpu *percpu;
 	unsigned int percpu_size;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* Per-cpu data for ASI */
+	void __percpu *percpu_asi;
+	unsigned int percpu_asi_size;
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
 #endif
 	void *noinstr_text_start;
 	unsigned int noinstr_text_size;
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index af1071535de8..5d9fdc93e0fa 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -170,6 +170,45 @@
 
 #define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
 	DEFINE_PER_CPU_SECTION(type, name, "..read_mostly")
+/*
+ * Declaration/definition used for per-CPU variables which for the sake for
+ * address space isolation (ASI) are deemed not sensitive
+ */
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+#define ASI_PERCPU_SECTION "..asi_non_sensitive"
+#else
+#define ASI_PERCPU_SECTION ""
+#endif
+
+#define DECLARE_PER_CPU_ASI_NOT_SENSITIVE(type, name)					\
+	DECLARE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)
+
+#define DECLARE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(type, name)	\
+	DECLARE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)         \
+	____cacheline_aligned_in_smp
+
+#define DECLARE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE(type, name)	        \
+	DECLARE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)         \
+	____cacheline_aligned
+
+#define DECLARE_PER_CPU_PAGE_ALIGNED_ASI_NOT_SENSITIVE(type, name)	\
+	DECLARE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)         \
+	__aligned(PAGE_SIZE)
+
+#define DEFINE_PER_CPU_ASI_NOT_SENSITIVE(type, name)		      	\
+	DEFINE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)
+
+#define DEFINE_PER_CPU_SHARED_ALIGNED_ASI_NOT_SENSITIVE(type, name)	\
+	DEFINE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)          \
+	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_ALIGNED_ASI_NOT_SENSITIVE(type, name)	        \
+	DEFINE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)          \
+	____cacheline_aligned
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED_ASI_NOT_SENSITIVE(type, name)	\
+	DEFINE_PER_CPU_SECTION(type, name, ASI_PERCPU_SECTION)          \
+	__aligned(PAGE_SIZE)
 
 /*
  * Declaration/definition used for per-CPU variables that should be accessed
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ae4004e7957e..a2cc4c32cabd 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -13,7 +13,8 @@
 
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE		(8 << 10)
+/* #define PERCPU_MODULE_RESERVE		(8 << 10) */
+#define PERCPU_MODULE_RESERVE		(16 << 10)
 #else
 #define PERCPU_MODULE_RESERVE		0
 #endif
@@ -123,6 +124,11 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 #endif
 
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align) __alloc_size(1);
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+extern void __percpu *__alloc_reserved_percpu_asi(size_t size, size_t align);
+#endif
+
 extern bool __is_kernel_percpu_address(unsigned long addr, unsigned long *can_addr);
 extern bool is_kernel_percpu_address(unsigned long addr);
 
diff --git a/kernel/module-internal.h b/kernel/module-internal.h
index 33783abc377b..44c05ae06b2c 100644
--- a/kernel/module-internal.h
+++ b/kernel/module-internal.h
@@ -25,6 +25,7 @@ struct load_info {
 #endif
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
+                unsigned int pcpu_asi;
 	} index;
 };
 
diff --git a/kernel/module.c b/kernel/module.c
index d363b8a0ee24..0048b7843903 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -587,6 +587,13 @@ static inline void __percpu *mod_percpu(struct module *mod)
 	return mod->percpu;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static inline void __percpu *mod_percpu_asi(struct module *mod)
+{
+	return mod->percpu_asi;
+}
+#endif
+
 static int percpu_modalloc(struct module *mod, struct load_info *info)
 {
 	Elf_Shdr *pcpusec = &info->sechdrs[info->index.pcpu];
@@ -611,9 +618,34 @@ static int percpu_modalloc(struct module *mod, struct load_info *info)
 	return 0;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static int percpu_asi_modalloc(struct module *mod, struct load_info *info)
+{
+	Elf_Shdr *pcpusec = &info->sechdrs[info->index.pcpu_asi];
+	unsigned long align = pcpusec->sh_addralign;
+
+	if ( !pcpusec->sh_size)
+		return 0;
+
+	mod->percpu_asi = __alloc_reserved_percpu_asi(pcpusec->sh_size, align);
+	if (!mod->percpu_asi) {
+		pr_warn("%s: Could not allocate %lu bytes percpu data\n",
+			mod->name, (unsigned long)pcpusec->sh_size);
+		return -ENOMEM;
+	}
+	mod->percpu_asi_size = pcpusec->sh_size;
+
+	return 0;
+}
+#endif
+
 static void percpu_modfree(struct module *mod)
 {
 	free_percpu(mod->percpu);
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	free_percpu(mod->percpu_asi);
+#endif
 }
 
 static unsigned int find_pcpusec(struct load_info *info)
@@ -621,6 +653,13 @@ static unsigned int find_pcpusec(struct load_info *info)
 	return find_sec(info, ".data..percpu");
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static unsigned int find_pcpusec_asi(struct load_info *info)
+{
+	return find_sec(info, ".data..percpu" ASI_PERCPU_SECTION );
+}
+#endif
+
 static void percpu_modcopy(struct module *mod,
 			   const void *from, unsigned long size)
 {
@@ -630,6 +669,39 @@ static void percpu_modcopy(struct module *mod,
 		memcpy(per_cpu_ptr(mod->percpu, cpu), from, size);
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static void percpu_asi_modcopy(struct module *mod,
+			   const void *from, unsigned long size)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		memcpy(per_cpu_ptr(mod->percpu_asi, cpu), from, size);
+}
+#endif
+
+bool __is_module_percpu_address_helper(unsigned long addr,
+                                       unsigned long *can_addr,
+                                       unsigned int cpu,
+                                       void* percpu_start,
+                                       unsigned int percpu_size)
+{
+        void *start = per_cpu_ptr(percpu_start, cpu);
+        void *va = (void *)addr;
+
+        if (va >= start && va < start + percpu_size) {
+                if (can_addr) {
+                        *can_addr = (unsigned long) (va - start);
+                        *can_addr += (unsigned long)
+                                per_cpu_ptr(percpu_start,
+                                            get_boot_cpu_id());
+                }
+                return true;
+        }
+
+        return false;
+}
+
 bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr)
 {
 	struct module *mod;
@@ -640,22 +712,34 @@ bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr)
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+		if (!mod->percpu_size && !mod->percpu_asi_size)
+			continue;
+#else
 		if (!mod->percpu_size)
 			continue;
+#endif
 		for_each_possible_cpu(cpu) {
-			void *start = per_cpu_ptr(mod->percpu, cpu);
-			void *va = (void *)addr;
-
-			if (va >= start && va < start + mod->percpu_size) {
-				if (can_addr) {
-					*can_addr = (unsigned long) (va - start);
-					*can_addr += (unsigned long)
-						per_cpu_ptr(mod->percpu,
-							    get_boot_cpu_id());
-				}
+                        if (__is_module_percpu_address_helper(addr,
+                                                              can_addr,
+                                                              cpu,
+                                                              mod->percpu,
+                                                              mod->percpu_size)) {
 				preempt_enable();
 				return true;
-			}
+                        }
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+                        if (__is_module_percpu_address_helper(
+                                                        addr,
+                                                        can_addr,
+                                                        cpu,
+                                                        mod->percpu_asi,
+                                                        mod->percpu_asi_size)) {
+				preempt_enable();
+				return true;
+                        }
+#endif
 		}
 	}
 
@@ -2344,6 +2428,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			/* Divert to percpu allocation if a percpu var. */
 			if (sym[i].st_shndx == info->index.pcpu)
 				secbase = (unsigned long)mod_percpu(mod);
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+                        else if (sym[i].st_shndx == info->index.pcpu_asi)
+				secbase = (unsigned long)mod_percpu_asi(mod);
+#endif
 			else
 				secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
 			sym[i].st_value += secbase;
@@ -2664,6 +2752,10 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
 		return 'U';
 	if (sym->st_shndx == SHN_ABS || sym->st_shndx == info->index.pcpu)
 		return 'a';
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        if (sym->st_shndx == info->index.pcpu_asi)
+		return 'a';
+#endif
 	if (sym->st_shndx >= SHN_LORESERVE)
 		return '?';
 	if (sechdrs[sym->st_shndx].sh_flags & SHF_EXECINSTR)
@@ -2691,7 +2783,8 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
 }
 
 static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
-			unsigned int shnum, unsigned int pcpundx)
+			unsigned int shnum, unsigned int pcpundx,
+                        unsigned pcpu_asi_ndx)
 {
 	const Elf_Shdr *sec;
 
@@ -2701,7 +2794,7 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
 		return false;
 
 #ifdef CONFIG_KALLSYMS_ALL
-	if (src->st_shndx == pcpundx)
+	if (src->st_shndx == pcpundx || src->st_shndx == pcpu_asi_ndx )
 		return true;
 #endif
 
@@ -2743,7 +2836,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	for (ndst = i = 0; i < nsrc; i++) {
 		if (i == 0 || is_livepatch_module(mod) ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
-				   info->index.pcpu)) {
+				   info->index.pcpu, info->index.pcpu_asi)) {
 			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
 			ndst++;
 		}
@@ -2807,7 +2900,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 		mod->kallsyms->typetab[i] = elf_type(src + i, info);
 		if (i == 0 || is_livepatch_module(mod) ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
-				   info->index.pcpu)) {
+				   info->index.pcpu, info->index.pcpu_asi)) {
 			mod->core_kallsyms.typetab[ndst] =
 			    mod->kallsyms->typetab[i];
 			dst[ndst] = src[i];
@@ -3289,6 +3382,12 @@ static int setup_load_info(struct load_info *info, int flags)
 
 	info->index.pcpu = find_pcpusec(info);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	info->index.pcpu_asi = find_pcpusec_asi(info);
+#else
+        info->index.pcpu_asi = 0;
+#endif
+
 	return 0;
 }
 
@@ -3629,6 +3728,12 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	/* We will do a special allocation for per-cpu sections later. */
 	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        if (info->index.pcpu_asi)
+               info->sechdrs[info->index.pcpu_asi].sh_flags &=
+                                                    ~(unsigned long)SHF_ALLOC;
+#endif
+
 	/*
 	 * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
 	 * layout_sections() can put it in the right place.
@@ -3700,6 +3805,14 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	percpu_modcopy(mod, (void *)info->sechdrs[info->index.pcpu].sh_addr,
 		       info->sechdrs[info->index.pcpu].sh_size);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* Copy relocated percpu ASI area over. */
+	percpu_asi_modcopy(
+                      mod,
+                      (void *)info->sechdrs[info->index.pcpu_asi].sh_addr,
+		      info->sechdrs[info->index.pcpu_asi].sh_size);
+#endif
+
 	/* Setup kallsyms-specific fields. */
 	add_kallsyms(mod, info);
 
@@ -4094,6 +4207,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	err = percpu_modalloc(mod, info);
 	if (err)
 		goto unlink_mod;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	err = percpu_asi_modalloc(mod, info);
+	if (err)
+		goto unlink_mod;
+#endif
 
 	/* Now module is in final location, initialize linked lists, etc. */
 	err = module_unload_init(mod);
@@ -4183,7 +4301,11 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	/* Get rid of temporary copy. */
 	free_copy(info);
 
-        asi_load_module(mod);
+        err = asi_load_module(mod);
+	/* If the ASI loading failed, it doesn't necessarily mean that the
+	 * module loading failed. We print an error and move on. */
+        if (err)
+                pr_err("ASI: failed loading module %s", mod->name);
 
 	/* Done! */
 	trace_module_load(mod);
diff --git a/mm/percpu.c b/mm/percpu.c
index beaca5adf9d4..3665a5ea71ec 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -169,6 +169,10 @@ struct pcpu_chunk *pcpu_first_chunk __ro_after_init;
  */
 struct pcpu_chunk *pcpu_reserved_chunk __ro_after_init;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+struct pcpu_chunk *pcpu_reserved_nonsensitive_chunk __ro_after_init;
+#endif
+
 DEFINE_SPINLOCK(pcpu_lock);	/* all internal data structures */
 static DEFINE_MUTEX(pcpu_alloc_mutex);	/* chunk create/destroy, [de]pop, map ext */
 
@@ -1621,6 +1625,11 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 	if (pcpu_addr_in_chunk(pcpu_first_chunk, addr))
 		return pcpu_first_chunk;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+	/* is it in the reserved ASI region? */
+	if (pcpu_addr_in_chunk(pcpu_reserved_nonsensitive_chunk, addr))
+		return pcpu_reserved_nonsensitive_chunk;
+#endif
 	/* is it in the reserved region? */
 	if (pcpu_addr_in_chunk(pcpu_reserved_chunk, addr))
 		return pcpu_reserved_chunk;
@@ -1805,23 +1814,37 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 
+#define TRY_ALLOC_FROM_CHUNK(source_chunk, chunk_name)                  \
+do {                                                                    \
+        if (!source_chunk) {                                            \
+                err = chunk_name " chunk not allocated";                \
+                goto fail_unlock;                                       \
+        }                                                               \
+        chunk = source_chunk;                                           \
+                                                                        \
+        off = pcpu_find_block_fit(chunk, bits, bit_align, is_atomic);   \
+        if (off < 0) {                                                  \
+                err = "alloc from " chunk_name " chunk failed";         \
+                goto fail_unlock;                                       \
+        }                                                               \
+                                                                        \
+        off = pcpu_alloc_area(chunk, bits, bit_align, off);             \
+        if (off >= 0)                                                   \
+                goto area_found;                                        \
+                                                                        \
+        err = "alloc from " chunk_name " chunk failed";                 \
+        goto fail_unlock;                                               \
+} while(0)
+
 	/* serve reserved allocations from the reserved chunk if available */
-	if (reserved && pcpu_reserved_chunk) {
-		chunk = pcpu_reserved_chunk;
-
-		off = pcpu_find_block_fit(chunk, bits, bit_align, is_atomic);
-		if (off < 0) {
-			err = "alloc from reserved chunk failed";
-			goto fail_unlock;
-		}
-
-		off = pcpu_alloc_area(chunk, bits, bit_align, off);
-		if (off >= 0)
-			goto area_found;
-
-		err = "alloc from reserved chunk failed";
-		goto fail_unlock;
-	}
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        if (reserved && (gfp & __GFP_GLOBAL_NONSENSITIVE))
+                TRY_ALLOC_FROM_CHUNK(pcpu_reserved_nonsensitive_chunk,
+                                     "reserverved ASI");
+	else
+#endif
+        if (reserved && pcpu_reserved_chunk)
+                TRY_ALLOC_FROM_CHUNK(pcpu_reserved_chunk, "reserved");
 
 restart:
 	/* search through normal chunks */
@@ -1998,6 +2021,14 @@ void __percpu *__alloc_reserved_percpu(size_t size, size_t align)
 	return pcpu_alloc(size, align, true, GFP_KERNEL);
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+void __percpu *__alloc_reserved_percpu_asi(size_t size, size_t align)
+{
+       return pcpu_alloc(size, align, true,
+                          GFP_KERNEL | __GFP_GLOBAL_NONSENSITIVE);
+}
+#endif
+
 /**
  * pcpu_balance_free - manage the amount of free chunks
  * @empty_only: free chunks only if there are no populated pages
@@ -2838,15 +2869,46 @@ void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	 * the dynamic region.
 	 */
 	tmp_addr = (unsigned long)base_addr + static_size;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        /* If ASI is used, split the reserved size between the nonsensitive
+         * chunk and the normal chunk evenly. */
+	map_size = (ai->reserved_size / 2) ?: dyn_size;
+#else
 	map_size = ai->reserved_size ?: dyn_size;
+#endif
 	chunk = pcpu_alloc_first_chunk(tmp_addr, map_size);
 
 	/* init dynamic chunk if necessary */
 	if (ai->reserved_size) {
-		pcpu_reserved_chunk = chunk;
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+          /* TODO: check if ASI was enabled via boot param or static branch */
+          /* We allocated pcpu_reserved_nonsensitive_chunk only if
+           * pcpu_reserved_chunk is used as well. */
+		pcpu_reserved_nonsensitive_chunk = chunk;
+                pcpu_reserved_nonsensitive_chunk->is_asi_nonsensitive = true;
 
+                /* We used the previous chunk as pcpu_reserved_nonsensitive_chunk. Now
+                 * allocate pcpu_reserved_chunk */
+		tmp_addr = (unsigned long)base_addr + static_size +
+			   (ai->reserved_size / 2);
+		map_size = ai->reserved_size / 2;
+                chunk = pcpu_alloc_first_chunk(tmp_addr, map_size);
+#endif
+                /* Whether ASI is enabled or disabled, the end result is the
+                 * same:
+                 * If ASI is enabled, tmp_addr, used for pcpu_first_chunk should
+                 * be after
+                 * 1. pcpu_reserved_nonsensitive_chunk AND
+                 * 2. pcpu_reserved_chunk
+                 * Since we split the reserve size in half, we skip in total the
+                 * whole ai->reserved_size.
+                 * If ASI is disabled, tmp_addr, used for pcpu_first_chunk is
+                 * just after pcpu_reserved_chunk */
 		tmp_addr = (unsigned long)base_addr + static_size +
 			   ai->reserved_size;
+
+                pcpu_reserved_chunk = chunk;
+
 		map_size = dyn_size;
 		chunk = pcpu_alloc_first_chunk(tmp_addr, map_size);
 	}
@@ -3129,7 +3191,6 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				   cpu_distance_fn);
 	if (IS_ERR(ai))
 		return PTR_ERR(ai);
-
 	size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
 	areas_size = PFN_ALIGN(ai->nr_groups * sizeof(void *));
 
@@ -3460,3 +3521,40 @@ static int __init percpu_enable_async(void)
 	return 0;
 }
 subsys_initcall(percpu_enable_async);
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+void __init pcpu_map_asi_reserved_chunk(void)
+{
+        void *start_addr, *end_addr;
+        unsigned long map_start_addr, map_end_addr;
+        struct pcpu_chunk *chunk = pcpu_reserved_nonsensitive_chunk;
+        int err = 0;
+
+        if (!chunk)
+		return;
+
+	start_addr = chunk->base_addr + chunk->start_offset;
+	end_addr = chunk->base_addr + chunk->nr_pages * PAGE_SIZE -
+		   chunk->end_offset;
+
+
+        /* No need in asi_map_percpu, since these addresses are "real". The
+         * chunk has full pages allocated, so we're not worried about leakage of
+         * data caused by start_addr-->end_addr not being page aligned. asi_map,
+         * however, will fail/crash if the addresses are not aligned. */
+        map_start_addr = (unsigned long)start_addr & PAGE_MASK;
+        map_end_addr = PAGE_ALIGN((unsigned long)end_addr);
+
+        pr_err("%s:%d mapping 0x%lx --> 0x%lx",
+               __FUNCTION__, __LINE__, map_start_addr, map_end_addr);
+        err = asi_map(ASI_GLOBAL_NONSENSITIVE,
+                      (void*)map_start_addr, map_end_addr - map_start_addr);
+
+        WARN(err, "Failed mapping percpu reserved chunk into ASI");
+
+        /* If we couldn't map the chuknk into ASI, it is useless. Set the chunk
+         * to NULL, so allocations from it will fail. */
+        if (err)
+              pcpu_reserved_nonsensitive_chunk = NULL;
+}
+#endif
-- 
2.35.1.473.g83b2b277ed-goog

