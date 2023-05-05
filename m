Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2E6F85B6
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjEEP3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbjEEP3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:38 -0400
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [IPv6:2001:1600:4:17::190c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1BE14E51
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:29:30 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZD81Wj3zMqHLq;
        Fri,  5 May 2023 17:22:00 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZD73gl0zMpxBk;
        Fri,  5 May 2023 17:21:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300120;
        bh=lpToIjkPWA0duCR50VLguq+aftI5CkhRhLIM9+Y09DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFJPl8PCpV0TqwQBoPoSGHQX+/8+SSuy0c9K2NPBDqUtmLq0QmGY7FWD3HryhaVm/
         17tCkfTiTGYBupyQ9RSGCsspEYrGNJuhBEUcpQDTrOdzsDu04Esrk+DE1xaHkpmpk1
         MM8P5jZUL4ILscFaudbqPEsff1UIBvirPP3WnImg=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v1 3/9] virt: Implement Heki common code
Date:   Fri,  5 May 2023 17:20:40 +0200
Message-Id: <20230505152046.6575-4-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

Hypervisor Enforced Kernel Integrity (Heki) is a feature that will use
the hypervisor to enhance guest virtual machine security.

Configuration
=============

Define the config variables for the feature. This feature depends on
support from the architecture as well as the hypervisor.

Enabling HEKI
=============

Define a kernel command line parameter "heki" to turn the feature on or
off. By default, Heki is on.

Feature initialization
======================

The linker script, vmlinux.lds.S, defines a number of sections that are
loaded in kernel memory. Each of these sections has its own permissions.
For instance, .text has HEKI_ATTR_MEM_EXEC | HEKI_ATTR_MEM_NOWRITE, and
.rodata has HEKI_ATTR_MEM_NOWRITE.

Define an architecture specific init function, heki_arch_init(). In this
function, collect the ranges of all of the sections. These sections will
be protected in the host page table with their respective permissions so
that even if the guest kernel is compromised, their permissions cannot
be changed.

Define heki_early_init() to initialize the feature. For now, this
function just checks if the feature is enabled and calls
heki_arch_init().

Define heki_late_init() that protects the sections in the host page
table. This needs hypervisor support which will be introduced in the
future.  This function is called at the end of kernel init.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Link: https://lore.kernel.org/r/20230505152046.6575-4-mic@digikod.net
---
 Kconfig                         |   2 +
 arch/x86/Kconfig                |   1 +
 arch/x86/include/asm/sections.h |   4 +
 arch/x86/kernel/setup.c         |  49 ++++++++++++
 include/linux/heki.h            |  90 +++++++++++++++++++++
 init/main.c                     |   3 +
 virt/Makefile                   |   1 +
 virt/heki/Kconfig               |  22 ++++++
 virt/heki/Makefile              |   3 +
 virt/heki/heki.c                | 135 ++++++++++++++++++++++++++++++++
 10 files changed, 310 insertions(+)
 create mode 100644 include/linux/heki.h
 create mode 100644 virt/heki/Kconfig
 create mode 100644 virt/heki/Makefile
 create mode 100644 virt/heki/heki.c

diff --git a/Kconfig b/Kconfig
index 745bc773f567..0c844d9bcb03 100644
--- a/Kconfig
+++ b/Kconfig
@@ -29,4 +29,6 @@ source "lib/Kconfig"
 
 source "lib/Kconfig.debug"
 
+source "virt/heki/Kconfig"
+
 source "Documentation/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3604074a878b..5cf5a7a97811 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -297,6 +297,7 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
+	select ARCH_SUPPORTS_HEKI		if X86_64
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
index a6e8373a5170..42ef1e33b8a5 100644
--- a/arch/x86/include/asm/sections.h
+++ b/arch/x86/include/asm/sections.h
@@ -18,6 +18,10 @@ extern char __end_of_kernel_reserve[];
 
 extern unsigned long _brk_start, _brk_end;
 
+extern int __start_orc_unwind_ip[], __stop_orc_unwind_ip[];
+extern struct orc_entry __start_orc_unwind[], __stop_orc_unwind[];
+extern unsigned int orc_lookup[], orc_lookup_end[];
+
 static inline bool arch_is_kernel_initmem_freed(unsigned long addr)
 {
 	/*
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 88188549647c..f0ddaf24ab63 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -11,6 +11,7 @@
 #include <linux/dma-map-ops.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
+#include <linux/heki.h>
 #include <linux/ima.h>
 #include <linux/init_ohci1394_dma.h>
 #include <linux/initrd.h>
@@ -850,6 +851,54 @@ static void __init x86_report_nx(void)
 	}
 }
 
+#ifdef CONFIG_HEKI
+
+/*
+ * Gather all of the statically defined sections so heki_late_init() can
+ * protect these sections in the host page table.
+ *
+ * The sections are defined under "SECTIONS" in vmlinux.lds.S
+ * Keep this array in sync with SECTIONS.
+ */
+struct heki_va_range __initdata heki_va_ranges[] = {
+	{
+		.va_start = _stext,
+		.va_end = _etext,
+		.attributes = HEKI_ATTR_MEM_NOWRITE | HEKI_ATTR_MEM_EXEC,
+	},
+	{
+		.va_start = __start_rodata,
+		.va_end = __end_rodata,
+		.attributes = HEKI_ATTR_MEM_NOWRITE,
+	},
+#ifdef CONFIG_UNWINDER_ORC
+	{
+		.va_start = __start_orc_unwind_ip,
+		.va_end = __stop_orc_unwind_ip,
+		.attributes = HEKI_ATTR_MEM_NOWRITE,
+	},
+	{
+		.va_start = __start_orc_unwind,
+		.va_end = __stop_orc_unwind,
+		.attributes = HEKI_ATTR_MEM_NOWRITE,
+	},
+	{
+		.va_start = orc_lookup,
+		.va_end = orc_lookup_end,
+		.attributes = HEKI_ATTR_MEM_NOWRITE,
+	},
+#endif /* CONFIG_UNWINDER_ORC */
+};
+
+void __init heki_arch_init(void)
+{
+	heki.num_static_ranges = ARRAY_SIZE(heki_va_ranges);
+	heki.static_ranges =
+		heki_alloc_pa_ranges(heki_va_ranges, heki.num_static_ranges);
+}
+
+#endif /* CONFIG_HEKI */
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
diff --git a/include/linux/heki.h b/include/linux/heki.h
new file mode 100644
index 000000000000..e4a3192ba687
--- /dev/null
+++ b/include/linux/heki.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Headers
+ *
+ * Copyright © 2023 Microsoft Corporation
+ */
+
+#ifndef __HEKI_H__
+#define __HEKI_H__
+
+#ifdef CONFIG_HEKI
+
+#include <linux/kvm_types.h>
+
+/* Heki attributes for memory pages. */
+/* clang-format off */
+#define HEKI_ATTR_MEM_NOWRITE		(1ULL << 0)
+#define HEKI_ATTR_MEM_EXEC		(1ULL << 1)
+/* clang-format on */
+
+/*
+ * heki_va_range is used to specify a virtual address range within the kernel
+ * address space along with their attributes.
+ */
+struct heki_va_range {
+	void *va_start;
+	void *va_end;
+	u64 attributes;
+};
+
+/*
+ * heki_pa_range is passed to the VMM or hypervisor so it can be processed by
+ * the VMM or the hypervisor based on range attributes. Examples of ranges:
+ *
+ *	- a range whose permissions need to be set in the host page table
+ *	- a range that contains information needed for authentication
+ *
+ * When an array of these is passed to the Hypervisor or VMM, the array
+ * must be in physically contiguous memory.
+ */
+struct heki_pa_range {
+	gfn_t gfn_start;
+	gfn_t gfn_end;
+	u64 attributes;
+};
+
+/*
+ * A hypervisor that supports Heki will instantiate this structure to
+ * provide hypervisor specific functions for Heki.
+ */
+struct heki_hypervisor {
+	int (*protect_ranges)(struct heki_pa_range *ranges, int num_ranges);
+	int (*lock_crs)(void);
+};
+
+/*
+ * If the architecture supports Heki, it will initialize static_ranges in
+ * early boot.
+ *
+ * If the active hypervisor supports Heki, it will plug its heki_hypervisor
+ * pointer into this heki structure.
+ */
+struct heki {
+	struct heki_pa_range *static_ranges;
+	int num_static_ranges;
+	struct heki_hypervisor *hypervisor;
+};
+
+extern struct heki heki;
+
+void heki_early_init(void);
+void heki_arch_init(void);
+void heki_late_init(void);
+
+struct heki_pa_range *heki_alloc_pa_ranges(struct heki_va_range *va_ranges,
+					   int num_ranges);
+void heki_free_pa_ranges(struct heki_pa_range *pa_ranges, int num_ranges);
+
+#else /* !CONFIG_HEKI */
+
+static inline void heki_early_init(void)
+{
+}
+static inline void heki_late_init(void)
+{
+}
+
+#endif /* CONFIG_HEKI */
+
+#endif /* __HEKI_H__ */
diff --git a/init/main.c b/init/main.c
index e1c3911d7c70..8649dbb07f18 100644
--- a/init/main.c
+++ b/init/main.c
@@ -102,6 +102,7 @@
 #include <linux/stackdepot.h>
 #include <linux/randomize_kstack.h>
 #include <net/net_namespace.h>
+#include <linux/heki.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -999,6 +1000,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	sort_main_extable();
 	trap_init();
 	mm_init();
+	heki_early_init();
 	poking_init();
 	ftrace_init();
 
@@ -1530,6 +1532,7 @@ static int __ref kernel_init(void *unused)
 	exit_boot_config();
 	free_initmem();
 	mark_readonly();
+	heki_late_init();
 
 	/*
 	 * Kernel mappings are now finalized - update the userspace page-table
diff --git a/virt/Makefile b/virt/Makefile
index 1cfea9436af9..4550dc624466 100644
--- a/virt/Makefile
+++ b/virt/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y	+= lib/
+obj-$(CONFIG_HEKI) += heki/
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
new file mode 100644
index 000000000000..9858a827fe17
--- /dev/null
+++ b/virt/heki/Kconfig
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Hypervisor Enforced Kernel Integrity (HEKI)
+#
+
+config HEKI
+	bool "Hypervisor Enforced Kernel Integrity (Heki)"
+	default y
+	depends on !JUMP_LABEL && ARCH_SUPPORTS_HEKI
+	select KVM_EXTERNAL_WRITE_TRACKING if KVM
+	help
+	  This feature enhances guest virtual machine security by taking
+	  advantage of security features provided by the hypervisor for guests.
+	  This feature is helpful in maintaining guest virtual machine security
+	  even after the guest kernel has been compromised.
+
+config ARCH_SUPPORTS_HEKI
+	bool "Architecture support for HEKI"
+	help
+	  An architecture should select this when it can successfully build
+	  and run with CONFIG_HEKI. That is, it should provide all of the
+	  architecture support required for the HEKI feature.
diff --git a/virt/heki/Makefile b/virt/heki/Makefile
new file mode 100644
index 000000000000..2bc2061c9dfc
--- /dev/null
+++ b/virt/heki/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-y += heki.o
diff --git a/virt/heki/heki.c b/virt/heki/heki.c
new file mode 100644
index 000000000000..c8cb1b84cceb
--- /dev/null
+++ b/virt/heki/heki.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Common code
+ *
+ * Copyright © 2023 Microsoft Corporation
+ */
+
+#include <linux/cache.h>
+#include <linux/heki.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "heki-guest: " fmt
+
+static bool heki_enabled __ro_after_init = true;
+
+struct heki heki = {};
+
+struct heki_pa_range *heki_alloc_pa_ranges(struct heki_va_range *va_ranges,
+					   int num_ranges)
+{
+	struct heki_pa_range *pa_ranges, *pa_range;
+	struct heki_va_range *va_range;
+	u64 attributes;
+	size_t size;
+	int i;
+
+	size = PAGE_ALIGN(sizeof(struct heki_pa_range) * num_ranges);
+	pa_ranges = alloc_pages_exact(size, GFP_KERNEL);
+	if (!pa_ranges)
+		return NULL;
+
+	for (i = 0; i < num_ranges; i++) {
+		va_range = &va_ranges[i];
+		pa_range = &pa_ranges[i];
+
+		pa_range->gfn_start = PFN_DOWN(__pa_symbol(va_range->va_start));
+		pa_range->gfn_end = PFN_UP(__pa_symbol(va_range->va_end)) - 1;
+		pa_range->attributes = va_range->attributes;
+
+		/*
+		 * WARNING:
+		 * Leaks addresses, should only be kept for development.
+		 */
+		attributes = pa_range->attributes;
+		pr_warn("Configuring GFN 0x%llx-0x%llx with %s\n",
+			pa_range->gfn_start, pa_range->gfn_end,
+			(attributes & HEKI_ATTR_MEM_NOWRITE) ? "[nowrite]" :
+							       "");
+	}
+
+	return pa_ranges;
+}
+
+void heki_free_pa_ranges(struct heki_pa_range *pa_ranges, int num_ranges)
+{
+	size_t size;
+
+	size = PAGE_ALIGN(sizeof(struct heki_pa_range) * num_ranges);
+	free_pages_exact(pa_ranges, size);
+}
+
+void __init heki_early_init(void)
+{
+	if (!heki_enabled) {
+		pr_warn("Disabled\n");
+		return;
+	}
+	pr_warn("Enabled\n");
+
+	heki_arch_init();
+}
+
+void heki_late_init(void)
+{
+	struct heki_hypervisor *hypervisor = heki.hypervisor;
+	int ret;
+
+	if (!heki_enabled)
+		return;
+
+	if (!heki.static_ranges) {
+		pr_warn("Architecture did not initialize static ranges\n");
+		return;
+	}
+
+	/*
+	 * Hypervisor support will be added in the future. When it is, the
+	 * hypervisor will be used to protect guest kernel memory and
+	 * control registers.
+	 */
+
+	if (!hypervisor) {
+		/* This happens for kernels running on bare metal as well. */
+		pr_warn("No hypervisor support\n");
+		goto out;
+	}
+
+	/* Protects statically defined sections in the host page table. */
+	ret = hypervisor->protect_ranges(heki.static_ranges,
+					 heki.num_static_ranges);
+	if (WARN(ret, "Failed to protect static sections: %d\n", ret))
+		goto out;
+	pr_warn("Static sections protected\n");
+
+	/*
+	 * Locks control registers so a compromised guest cannot change
+	 * them.
+	 */
+	ret = hypervisor->lock_crs();
+	if (WARN(ret, "Failed to lock control registers: %d\n", ret))
+		goto out;
+	pr_warn("Control registers locked\n");
+
+out:
+	heki_free_pa_ranges(heki.static_ranges, heki.num_static_ranges);
+	heki.static_ranges = NULL;
+	heki.num_static_ranges = 0;
+}
+
+static int __init heki_parse_config(char *str)
+{
+	if (strtobool(str, &heki_enabled))
+		pr_warn("Invalid option string for heki: '%s'\n", str);
+	return 1;
+}
+
+__setup("heki=", heki_parse_config);
-- 
2.40.1

