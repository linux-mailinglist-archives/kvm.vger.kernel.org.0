Return-Path: <kvm+bounces-16508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1AA8BADA0
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD95D1C2224A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0243015686B;
	Fri,  3 May 2024 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="YqIvlgiE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-bc0e.mail.infomaniak.ch (smtp-bc0e.mail.infomaniak.ch [45.157.188.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F079215445B
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714742371; cv=none; b=Z5JDsAJ4+2xmFY7P5uo+GUVGz/ep5zGlo2k460tcheBVev/9MCktPnTjz3ewEv3vR/OoupWq6LytB+jVL9eGCi44TLqOeaIw+5ILJXTaxXJ9RKKngMvOeqi30ZCpapBfct/aDaFiSZd98Ez4rBWA4G0kQVu8xjB/TClXfFZQCxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714742371; c=relaxed/simple;
	bh=5C2oJwkaABGy0N3TgDchTsaJRP0NaN1sG1zefdnqG5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyvkXruh3VA8tZ8HLwJMbLMtKmzbyj61kd1pbdX93VETqbEiV22trt3LRsaLHTS47CNVi4Y5ulklBT0Fzv52WQrZDQ3dnZb8yhiFNrQ5ju6bcuKj1JR4PilkMGM4dM7Hip6LRzmQlO0eCHwEyZC5RoiACo+ulf5GIdm28uo6jp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=YqIvlgiE; arc=none smtp.client-ip=45.157.188.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VWBGh4fbkzS3b;
	Fri,  3 May 2024 15:19:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714742364;
	bh=5C2oJwkaABGy0N3TgDchTsaJRP0NaN1sG1zefdnqG5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqIvlgiE19ek2V9SMYQfmDo9Wa87WmiGMnbGB2jn2HxiItp8TNw5d9eeeBTU8LpK3
	 AZT0MKxeoxXmSYrZ0EETcC/IslnkqX1RyIwnBoKBpYfJ00vOsRqigZFHpCXr5dOfgY
	 YVXF5SDClUmkftFfBhN3Uo9dR3fSNJeaCw/yx6WM=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VWBGg5Ql1zZFN;
	Fri,  3 May 2024 15:19:23 +0200 (CEST)
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
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Alexander Graf <graf@amazon.com>,
	Angelina Vu <angelinavu@linux.microsoft.com>,
	Anna Trikalinou <atrikalinou@microsoft.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
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
Subject: [RFC PATCH v3 4/5] heki: Lock guest control registers at the end of guest kernel init
Date: Fri,  3 May 2024 15:19:09 +0200
Message-ID: <20240503131910.307630-5-mic@digikod.net>
In-Reply-To: <20240503131910.307630-1-mic@digikod.net>
References: <20240503131910.307630-1-mic@digikod.net>
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
Link: https://lore.kernel.org/r/20240503131910.307630-5-mic@digikod.net
---

Changes since v2:
* Hide CONFIG_HYPERVISOR_SUPPORTS_HEKI from users.

Changes since v1:
* Shrinked the patch to only manage the CR pinning.
---
 arch/x86/include/asm/x86_init.h  |  1 +
 arch/x86/kernel/cpu/hypervisor.c |  1 +
 arch/x86/kernel/kvm.c            | 56 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/Kconfig             |  1 +
 include/linux/heki.h             | 22 +++++++++++++
 init/main.c                      |  1 +
 virt/heki/Kconfig                |  8 ++++-
 virt/heki/main.c                 | 25 ++++++++++++++
 8 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 6149eabe200f..113998799473 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -128,6 +128,7 @@ struct x86_hyper_init {
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
index 7f0732bc0ccd..a54f2c0d7cd0 100644
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
@@ -999,6 +1000,60 @@ static bool kvm_sev_es_hcall_finish(struct ghcb *ghcb, struct pt_regs *regs)
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
@@ -1007,6 +1062,7 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.init.x2apic_available		= kvm_para_available,
 	.init.msi_ext_dest_id		= kvm_msi_ext_dest_id,
 	.init.init_platform		= kvm_init_platform,
+	.init.init_heki			= kvm_init_heki,
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
 	.runtime.sev_es_hcall_prepare	= kvm_sev_es_hcall_prepare,
 	.runtime.sev_es_hcall_finish	= kvm_sev_es_hcall_finish,
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 0ebdd088f28b..68e0e8d7230a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
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
index bec2c8d939aa..c2dc663ab4b5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1454,6 +1454,7 @@ static int __ref kernel_init(void *unused)
 	exit_boot_config();
 	free_initmem();
 	mark_readonly();
+	heki_late_init();
 
 	/*
 	 * Kernel mappings are now finalized - update the userspace page-table
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 66e73d212856..0c764e342f48 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -8,6 +8,12 @@ config ARCH_SUPPORTS_HEKI
 	# and run with CONFIG_HEKI. That is, it should provide all of the
 	# architecture support required for the HEKI feature.
 
+config HYPERVISOR_SUPPORTS_HEKI
+	bool
+	# A hypervisor should select this when it can successfully build
+	# and run with CONFIG_HEKI. That is, it should provide all of the
+	# hypervisor support required for the Heki feature.
+
 menuconfig HEKI_MENU
 	bool "Virtualization hardening"
 
@@ -15,7 +21,7 @@ if HEKI_MENU
 
 config HEKI
 	bool "Hypervisor Enforced Kernel Integrity (Heki)"
-	depends on ARCH_SUPPORTS_HEKI
+	depends on ARCH_SUPPORTS_HEKI && HYPERVISOR_SUPPORTS_HEKI
 	help
 	  This feature enhances guest virtual machine security by taking
 	  advantage of security features provided by the hypervisor for guests.
diff --git a/virt/heki/main.c b/virt/heki/main.c
index 25c25f5700f7..ef0530a03e09 100644
--- a/virt/heki/main.c
+++ b/virt/heki/main.c
@@ -11,6 +11,7 @@
 #include "common.h"
 
 bool heki_enabled __ro_after_init = true;
+struct heki heki;
 
 /*
  * Must be called after kmem_cache_init().
@@ -22,6 +23,30 @@ __init void heki_early_init(void)
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
2.45.0


