Return-Path: <kvm+bounces-1555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0EC7E9501
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D88CCB20AD1
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D0C1D559;
	Mon, 13 Nov 2023 02:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="j5ewNw8U"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CC01B295
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:36 +0000 (UTC)
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [83.166.143.168])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D30319A3
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:29 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCt22fpHzMpvYh;
	Mon, 13 Nov 2023 02:24:10 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCt065wzzMpnPj;
	Mon, 13 Nov 2023 03:24:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842250;
	bh=esVX+RxDYBu/Sf0VJM0uwsUmshvOSuRinJo44ok6d6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5ewNw8U+CG4uLmDWsFmdmmPUPds1RzaRFS3iHpbIedD8bQNFxISwi0x84JEiZJ2I
	 NCDOM4+qkBQaGKfao4tSd+VlnabW4CgD40djzXTwDdf8kQnk1T5bqF0vW0NlssX/dI
	 heNYXTA3TuNjmf/r++0u7uvbsMYZxag0QM+XHVLs=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 04/19] heki: Lock guest control registers at the end of guest kernel init
Date: Sun, 12 Nov 2023 21:23:11 -0500
Message-ID: <20231113022326.24388-5-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

The hypervisor needs to provide some functions to support Heki. These
form the Heki-Hypervisor API.

Define a heki_hypervisor structure to house the API functions. A
hypervisor that supports Heki must instantiate a heki_hypervisor
structure and pass it to the Heki common code. This allows the common
code to access these functions in a hypervisor-agnostic way.

The first function that is implemented is lock_crs() (lock control
registers). That is, certain flags in the control registers are pinned
so that they can never be changed for the lifetime of the guest.

Implement Heki support in the guest:

- Each supported hypervisor in x86 implements a set of functions for the
  guest kernel. Add an init_heki() function to that set.  This function
  initializes Heki-related stuff. Call init_heki() for the detected
  hypervisor in init_hypervisor_platform().

- Implement init_heki() for the guest.

- Implement kvm_lock_crs() in the guest to lock down control registers.
  This function calls a KVM hypercall to do the job.

- Instantiate a heki_hypervisor structure that contains a pointer to
  kvm_lock_crs().

- Pass the heki_hypervisor structure to Heki common code in init_heki().

Implement a heki_late_init() function and call it at the end of kernel
init. This function calls lock_crs(). In other words, control registers
of a guest are locked down at the end of guest kernel init.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---

Changes since v1:
* Shrinked the patch to only manage the CR pinning.
---
 arch/x86/include/asm/x86_init.h  |  1 +
 arch/x86/kernel/cpu/hypervisor.c |  1 +
 arch/x86/kernel/kvm.c            | 56 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/Kconfig             |  1 +
 include/linux/heki.h             | 22 +++++++++++++
 init/main.c                      |  1 +
 virt/heki/Kconfig                |  9 ++++-
 virt/heki/main.c                 | 25 ++++++++++++++
 8 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 5240d88db52a..ff4dfd2f615e 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -127,6 +127,7 @@ struct x86_hyper_init {
 	bool (*msi_ext_dest_id)(void);
 	void (*init_mem_mapping)(void);
 	void (*init_after_bootmem)(void);
+	void (*init_heki)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 553bfbfc3a1b..6085c8129e0c 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -106,4 +106,5 @@ void __init init_hypervisor_platform(void)
 
 	x86_hyper_type = h->type;
 	x86_init.hyper.init_platform();
+	x86_init.hyper.init_heki();
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ab9ee5896c..8349f4ad3bbd 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -29,6 +29,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/cc_platform.h>
 #include <linux/efi.h>
+#include <linux/heki.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -997,6 +998,60 @@ static bool kvm_sev_es_hcall_finish(struct ghcb *ghcb, struct pt_regs *regs)
 }
 #endif
 
+#ifdef CONFIG_HEKI
+
+extern unsigned long cr4_pinned_mask;
+
+/*
+ * TODO: Check SMP policy consistency, e.g. with
+ * this_cpu_read(cpu_tlbstate.cr4)
+ */
+static int kvm_lock_crs(void)
+{
+	unsigned long cr4;
+	int err;
+
+	err = kvm_hypercall3(KVM_HC_LOCK_CR_UPDATE, 0, X86_CR0_WP, 0);
+	if (err)
+		return err;
+
+	cr4 = __read_cr4();
+	err = kvm_hypercall3(KVM_HC_LOCK_CR_UPDATE, 4, cr4 & cr4_pinned_mask,
+			     0);
+	return err;
+}
+
+static struct heki_hypervisor kvm_heki_hypervisor = {
+	.lock_crs = kvm_lock_crs,
+};
+
+static void kvm_init_heki(void)
+{
+	long err;
+
+	if (!kvm_para_available()) {
+		/* Cannot make KVM hypercalls. */
+		return;
+	}
+
+	err = kvm_hypercall3(KVM_HC_LOCK_CR_UPDATE, 0, 0,
+			     KVM_LOCK_CR_UPDATE_VERSION);
+	if (err < 1) {
+		/* Ignores host not supporting at least the first version. */
+		return;
+	}
+
+	heki.hypervisor = &kvm_heki_hypervisor;
+}
+
+#else /* CONFIG_HEKI */
+
+static void kvm_init_heki(void)
+{
+}
+
+#endif /* CONFIG_HEKI */
+
 const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.name				= "KVM",
 	.detect				= kvm_detect,
@@ -1005,6 +1060,7 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.init.x2apic_available		= kvm_para_available,
 	.init.msi_ext_dest_id		= kvm_msi_ext_dest_id,
 	.init.init_platform		= kvm_init_platform,
+	.init.init_heki			= kvm_init_heki,
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
 	.runtime.sev_es_hcall_prepare	= kvm_sev_es_hcall_prepare,
 	.runtime.sev_es_hcall_finish	= kvm_sev_es_hcall_finish,
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8452ed0228cb..7a3b52b7e456 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,6 +49,7 @@ config KVM
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+	select HYPERVISOR_SUPPORTS_HEKI
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/include/linux/heki.h b/include/linux/heki.h
index 4c18d2283392..96ccb17657e5 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -9,6 +9,7 @@
 #define __HEKI_H__
 
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -16,15 +17,36 @@
 
 #ifdef CONFIG_HEKI
 
+/*
+ * A hypervisor that supports Heki will instantiate this structure to
+ * provide hypervisor specific functions for Heki.
+ */
+struct heki_hypervisor {
+	int (*lock_crs)(void); /* Lock control registers. */
+};
+
+/*
+ * If the active hypervisor supports Heki, it will plug its heki_hypervisor
+ * pointer into this heki structure.
+ */
+struct heki {
+	struct heki_hypervisor *hypervisor;
+};
+
+extern struct heki heki;
 extern bool heki_enabled;
 
 void heki_early_init(void);
+void heki_late_init(void);
 
 #else /* !CONFIG_HEKI */
 
 static inline void heki_early_init(void)
 {
 }
+static inline void heki_late_init(void)
+{
+}
 
 #endif /* CONFIG_HEKI */
 
diff --git a/init/main.c b/init/main.c
index 0d28301c5402..f1c998bbb370 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1447,6 +1447,7 @@ static int __ref kernel_init(void *unused)
 	exit_boot_config();
 	free_initmem();
 	mark_readonly();
+	heki_late_init();
 
 	/*
 	 * Kernel mappings are now finalized - update the userspace page-table
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 49695fff6d21..5ea75b595667 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -4,7 +4,7 @@
 
 config HEKI
 	bool "Hypervisor Enforced Kernel Integrity (Heki)"
-	depends on ARCH_SUPPORTS_HEKI
+	depends on ARCH_SUPPORTS_HEKI && HYPERVISOR_SUPPORTS_HEKI
 	help
 	  This feature enhances guest virtual machine security by taking
 	  advantage of security features provided by the hypervisor for guests.
@@ -17,3 +17,10 @@ config ARCH_SUPPORTS_HEKI
 	  An architecture should select this when it can successfully build
 	  and run with CONFIG_HEKI. That is, it should provide all of the
 	  architecture support required for the HEKI feature.
+
+config HYPERVISOR_SUPPORTS_HEKI
+	bool "Hypervisor support for Heki"
+	help
+	  A hypervisor should select this when it can successfully build
+	  and run with CONFIG_HEKI. That is, it should provide all of the
+	  hypervisor support required for the Heki feature.
diff --git a/virt/heki/main.c b/virt/heki/main.c
index f005dd74d586..ff1937e1c946 100644
--- a/virt/heki/main.c
+++ b/virt/heki/main.c
@@ -10,6 +10,7 @@
 #include "common.h"
 
 bool heki_enabled __ro_after_init = true;
+struct heki heki;
 
 /*
  * Must be called after kmem_cache_init().
@@ -21,6 +22,30 @@ __init void heki_early_init(void)
 		return;
 	}
 	pr_warn("Heki is enabled\n");
+
+	if (!heki.hypervisor) {
+		/* This happens for kernels running on bare metal as well. */
+		pr_warn("No support for Heki in the active hypervisor\n");
+		return;
+	}
+	pr_warn("Heki is supported by the active Hypervisor\n");
+}
+
+/*
+ * Must be called after mark_readonly().
+ */
+void heki_late_init(void)
+{
+	struct heki_hypervisor *hypervisor = heki.hypervisor;
+
+	if (!heki_enabled || !heki.hypervisor)
+		return;
+
+	/* Locks control registers so a compromised guest cannot change them. */
+	if (WARN_ON(hypervisor->lock_crs()))
+		return;
+
+	pr_warn("Control registers locked\n");
 }
 
 static int __init heki_parse_config(char *str)
-- 
2.42.1


