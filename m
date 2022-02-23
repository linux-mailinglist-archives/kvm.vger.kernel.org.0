Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06D24C0C11
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbiBWF1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238417AbiBWF0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:53 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648E66B092
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:20 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so26694300ybg.8
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KXrCYGgvo83JEgYfSU2xPmsuGvCpoOVuzDhVbsTzD0I=;
        b=peKSlY/Xr61DvdFpVmXc37FMKYnl+vkSCRtwe1UF1UGbHZ0v3cMEdZbiKKvXTZ5GbO
         laOcMzhj8sBkgNnt1mc4a0NZR0hCQ3gPAdN/2qIaNw43JOyvktEB0Y0rn3QcamgO9gZ8
         7DbNXkvTjq6TGSgTmAj628OIdjZHlZYdFsABsewAF21y3xPSWYsHQAWzziaNW39gFRL5
         yWxZv0skPs5ax5wbHVY8sW6jeIPlZLUx/HQpjPftWbdPu83nt4wFjKis+ce33NEw7HrY
         03O9DgYBb/75g6K+v8UjyCDA3xzr7E/F2srmJjBiOtEMdOtKjPJnG/mlJ872cZ/zgYG/
         2wwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KXrCYGgvo83JEgYfSU2xPmsuGvCpoOVuzDhVbsTzD0I=;
        b=7lKvnq9hoNdNTQrUft9jZcMPAyZLXr8Vunu98Aw9GRiyPt4e3QPEdV26eZYkMGZB3I
         NchGQ5AjQBG6KD8etXoM26Ql4LX5OvZalCq2AZjvYpp49pw1JWltp4uLayaEy/6BS3NH
         tFhxOpOZ3AouKe90YugIhRKAsMf4AANCBnPp3DbonBDpQMOJ5lQDMKhWffOG6NHRPH93
         mBOULNQMoC6tRz0XI5EDAccw3MYUe4644MiYLRGm4dW09lSZM2m9COlDuW5eemqfMUcm
         6XMXT8hohoIV2pPw74nL9J0eH7lDwbBd/OSQOeVbZQDpHB0mUCPT2CfyNBsAl5RZaPmU
         +DNw==
X-Gm-Message-State: AOAM532aAHElHExnnWB2aooow9N5loRssGITB3tR5afbhDfyKRgy1cwP
        SI+4xSHDsvAaio6YukvL5+ggCo02BC1K
X-Google-Smtp-Source: ABdhPJyZfLfl11T/5CrHmveifdlj9QKZBHoh8PI3AMF6sP4DdsodfKmQ8jHyUSfS7xsGTotzIsjTTydYzCuX
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:c607:0:b0:2cb:a34a:355c with SMTP id
 l7-20020a81c607000000b002cba34a355cmr27125747ywi.487.1645593910227; Tue, 22
 Feb 2022 21:25:10 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:14 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-39-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 38/47] mm: asi: ASI annotation support for dynamic modules.
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

Adding support for use of ASI static variable annotations in dynamic
modules:
- __asi_not_sensitive and
- __asi_not_sensitive_readmostly

Per module, we now have the following offsets:

1. asi_section_offset/size - which should be mapped into asi global pool
2. asi_readmostly_section/size - same as above, for read mostly data;
3. once_section_offset/size - is considered asi non-sensitive

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/include/asm/asi.h |  3 ++
 arch/x86/mm/asi.c          | 66 ++++++++++++++++++++++++++++++++++++++
 include/asm-generic/asi.h  |  3 ++
 include/linux/module.h     |  9 ++++++
 kernel/module.c            | 58 +++++++++++++++++++++++++++++++++
 5 files changed, 139 insertions(+)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 6dd9c7c8a2b8..d43f6aadffee 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -98,6 +98,9 @@ static inline void asi_init_thread_state(struct thread_struct *thread)
 	thread->intr_nest_depth = 0;
 }
 
+int asi_load_module(struct module* module);
+void asi_unload_module(struct module* module);
+
 static inline void asi_set_target_unrestricted(void)
 {
 	if (static_cpu_has(X86_FEATURE_ASI)) {
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 9b1bd005f343..6c14aa1fc4aa 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -5,6 +5,7 @@
 #include <linux/memcontrol.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include <asm/asi.h>
 #include <asm/pgalloc.h>
@@ -308,6 +309,71 @@ static int __init set_asi_param(char *str)
 }
 early_param("asi", set_asi_param);
 
+/* asi_load_module() is called from layout_and_allocate() in kernel/module.c
+ * We map the module and its data in init_mm.asi_pgd[0].
+*/
+int asi_load_module(struct module* module)
+{
+        int err = 0;
+
+        /* Map the cod/text */
+        err = asi_map(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base,
+                      module->core_layout.ro_after_init_size );
+        if (err)
+                return err;
+
+        /* Map global variables annotated as non-sensitive for ASI */
+        err = asi_map(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base +
+                      module->core_layout.asi_section_offset,
+                      module->core_layout.asi_section_size );
+        if (err)
+                return err;
+
+        /* Map global variables annotated as non-sensitive for ASI */
+        err = asi_map(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base +
+                      module->core_layout.asi_readmostly_section_offset,
+                      module->core_layout.asi_readmostly_section_size);
+        if (err)
+                return err;
+
+        /* Map .data.once section as well */
+        err = asi_map(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base +
+                      module->core_layout.once_section_offset,
+                      module->core_layout.once_section_size );
+        if (err)
+                return err;
+
+        return 0;
+}
+EXPORT_SYMBOL_GPL(asi_load_module);
+
+void asi_unload_module(struct module* module)
+{
+        asi_unmap(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base,
+                      module->core_layout.ro_after_init_size, true);
+
+        asi_unmap(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base +
+                      module->core_layout.asi_section_offset,
+                      module->core_layout.asi_section_size, true);
+
+        asi_unmap(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base +
+                      module->core_layout.asi_readmostly_section_offset,
+                      module->core_layout.asi_readmostly_section_size, true);
+
+        asi_unmap(ASI_GLOBAL_NONSENSITIVE,
+                      module->core_layout.base +
+                      module->core_layout.once_section_offset,
+                      module->core_layout.once_section_size, true);
+
+}
+
 static int __init asi_global_init(void)
 {
 	uint i, n;
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index d9082267a5dd..2763cb1a974c 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -120,6 +120,7 @@ void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
 
 #define static_asi_enabled() false
 
+static inline int asi_load_module(struct module* module) {return 0;}
 
 /* IMPORTANT: Any modification to the name here should also be applied to
  * include/asm-generic/vmlinux.lds.h */
@@ -127,6 +128,8 @@ void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
 #define __asi_not_sensitive
 #define __asi_not_sensitive_readmostly
 
+static inline void asi_unload_module(struct module* module) { }
+
 #endif  /* !_ASSEMBLY_ */
 
 #endif /* !CONFIG_ADDRESS_SPACE_ISOLATION */
diff --git a/include/linux/module.h b/include/linux/module.h
index c9f1200b2312..82267a95f936 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -336,6 +336,15 @@ struct module_layout {
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 	struct mod_tree_node mtn;
 #endif
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        unsigned int asi_section_offset;
+        unsigned int asi_section_size;
+        unsigned int asi_readmostly_section_offset;
+        unsigned int asi_readmostly_section_size;
+        unsigned int once_section_offset;
+        unsigned int once_section_size;
+#endif
 };
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
diff --git a/kernel/module.c b/kernel/module.c
index 84a9141a5e15..d363b8a0ee24 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2159,6 +2159,8 @@ static void free_module(struct module *mod)
 {
 	trace_module_free(mod);
 
+	asi_unload_module(mod);
+
 	mod_sysfs_teardown(mod);
 
 	/*
@@ -2416,6 +2418,31 @@ static bool module_init_layout_section(const char *sname)
 	return module_init_section(sname);
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static void asi_record_sections_layout(struct module *mod,
+                                       const char *sname,
+                                       Elf_Shdr *s)
+{
+        if (strstarts(sname, ASI_NON_SENSITIVE_READ_MOSTLY_SECTION_NAME)) {
+                mod->core_layout.asi_readmostly_section_offset = s->sh_entsize;
+                mod->core_layout.asi_readmostly_section_size   = s->sh_size;
+        }
+        else if (strstarts(sname, ASI_NON_SENSITIVE_SECTION_NAME)) {
+                mod->core_layout.asi_section_offset = s->sh_entsize;
+                mod->core_layout.asi_section_size   = s->sh_size;
+        }
+        if (strstarts(sname, ".data.once")) {
+                mod->core_layout.once_section_offset = s->sh_entsize;
+                mod->core_layout.once_section_size   = s->sh_size;
+        }
+}
+#else
+static void asi_record_sections_layout(struct module *mod,
+                                       const char *sname,
+                                       Elf_Shdr *s)
+{}
+#endif
+
 /*
  * Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
  * might -- code, read-only data, read-write data, small data.  Tally
@@ -2453,6 +2480,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			    || module_init_layout_section(sname))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_layout.size, s, i);
+                        asi_record_sections_layout(mod, sname, s);
 			pr_debug("\t%s\n", sname);
 		}
 		switch (m) {
@@ -3558,6 +3586,25 @@ static bool blacklisted(const char *module_name)
 }
 core_param(module_blacklist, module_blacklist, charp, 0400);
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+static void asi_fix_section_size_and_alignment(struct load_info *info,
+                                               char *section_to_fix)
+{
+	unsigned int ndx = find_sec(info, section_to_fix );
+	if (!ndx)
+                return;
+
+        info->sechdrs[ndx].sh_addralign = PAGE_SIZE;
+        info->sechdrs[ndx].sh_size =
+            ALIGN( info->sechdrs[ndx].sh_size, PAGE_SIZE );
+}
+#else
+static inline void asi_fix_section_size_and_alignment(struct load_info *info,
+                                               char *section_to_fix)
+{}
+#endif
+
+
 static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	struct module *mod;
@@ -3600,6 +3647,15 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	if (ndx)
 		info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+        /* These are sections we will want to map into an ASI page-table. We
+         * therefore need these sections to be aligned to a PAGE_SIZE */
+        asi_fix_section_size_and_alignment(info, ASI_NON_SENSITIVE_SECTION_NAME);
+        asi_fix_section_size_and_alignment(info,
+                                           ASI_NON_SENSITIVE_READ_MOSTLY_SECTION_NAME);
+        asi_fix_section_size_and_alignment(info, ".data.once");
+#endif
+
 	/*
 	 * Determine total sizes, and put offsets in sh_entsize.  For now
 	 * this is done generically; there doesn't appear to be any
@@ -4127,6 +4183,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	/* Get rid of temporary copy. */
 	free_copy(info);
 
+        asi_load_module(mod);
+
 	/* Done! */
 	trace_module_load(mod);
 
-- 
2.35.1.473.g83b2b277ed-goog

