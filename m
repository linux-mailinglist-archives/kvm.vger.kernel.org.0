Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1316F85B1
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjEEP3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjEEP3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:36 -0400
X-Greylist: delayed 446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 May 2023 08:29:29 PDT
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C735A0
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:29:29 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZDC54NKzMqP0t;
        Fri,  5 May 2023 17:22:03 +0200 (CEST)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZDB71wWzMpt9w;
        Fri,  5 May 2023 17:22:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300123;
        bh=DM23zXDS+uuGwMhWqh31C3FvKal04OOOYj6BCpV8eTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWSKWq8GRjQntbZQyjyc/hcLfD/4e9Eo9VEQ3TyJ15GAj81rIlqRsji0rYWtV6o9s
         DjYkgLxPq6tOCUL7E0ENshFSZ0cXEvowTkLwi08Dmqi/WhYCFJPWohunvkPKWdyymr
         yIWmw5cSKPerfUXYOOtVgs7cuuhvsEWWph9Se7ZE=
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
Subject: [PATCH v1 6/9] KVM: x86: Add Heki hypervisor support
Date:   Fri,  5 May 2023 17:20:43 +0200
Message-Id: <20230505152046.6575-7-mic@digikod.net>
In-Reply-To: <20230505152046.6575-1-mic@digikod.net>
References: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

Each supported hypervisor in x86 implements a struct x86_hyper_init to
define the init functions for the hypervisor.  Define a new init_heki()
entry point in struct x86_hyper_init.  Hypervisors that support Heki
must define this init_heki() function.  Call init_heki() of the chosen
hypervisor in init_hypervisor_platform().

Create a heki_hypervisor structure that each hypervisor can fill
with its data and functions. This will allow the Heki feature to work
in a hypervisor agnostic way.

Declare and initialize a "heki_hypervisor" structure for KVM so KVM can
support Heki.  Define the init_heki() function for KVM.  In init_heki(),
set the hypervisor field in the generic "heki" structure to the KVM
"heki_hypervisor".  After this point, generic Heki code can access the
KVM Heki data and functions.

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
Co-developed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Link: https://lore.kernel.org/r/20230505152046.6575-7-mic@digikod.net
---
 arch/x86/include/asm/x86_init.h  |  2 +
 arch/x86/kernel/cpu/hypervisor.c |  1 +
 arch/x86/kernel/kvm.c            | 72 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/x86_init.c       |  1 +
 arch/x86/kvm/Kconfig             |  1 +
 virt/heki/Kconfig                |  9 +++-
 virt/heki/heki.c                 |  6 ---
 7 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c1c8c581759d..0fc5041a66c6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -119,6 +119,7 @@ struct x86_init_pci {
  * @msi_ext_dest_id:		MSI supports 15-bit APIC IDs
  * @init_mem_mapping:		setup early mappings during init_mem_mapping()
  * @init_after_bootmem:		guest init after boot allocator is finished
+ * @init_heki:			Hypervisor enforced kernel integrity
  */
 struct x86_hyper_init {
 	void (*init_platform)(void);
@@ -127,6 +128,7 @@ struct x86_hyper_init {
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
index 1cceac5984da..e53cebdcf3ac 100644
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
@@ -866,6 +867,45 @@ static void __init kvm_guest_init(void)
 	hardlockup_detector_disable();
 }
 
+#ifdef CONFIG_HEKI
+
+static int kvm_protect_ranges(struct heki_pa_range *ranges, int num_ranges)
+{
+	size_t size;
+	long err;
+
+	WARN_ON(in_interrupt());
+
+	size = sizeof(ranges[0]) * num_ranges;
+	err = kvm_hypercall3(KVM_HC_LOCK_MEM_PAGE_RANGES, __pa(ranges), size, 0);
+	if (WARN(err, "Failed to enforce memory protection: %ld\n", err))
+		return err;
+
+	return 0;
+}
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
+	err = kvm_hypercall2(KVM_HC_LOCK_CR_UPDATE, 0, X86_CR0_WP);
+	if (err)
+		return err;
+
+	cr4 = __read_cr4();
+	err = kvm_hypercall2(KVM_HC_LOCK_CR_UPDATE, 4, cr4 & cr4_pinned_mask);
+	return err;
+}
+
+#endif /* CONFIG_HEKI */
+
 static noinline uint32_t __kvm_cpuid_base(void)
 {
 	if (boot_cpu_data.cpuid_level < 0)
@@ -999,6 +1039,37 @@ static bool kvm_sev_es_hcall_finish(struct ghcb *ghcb, struct pt_regs *regs)
 }
 #endif
 
+#ifdef CONFIG_HEKI
+
+static struct heki_hypervisor kvm_heki_hypervisor = {
+	.protect_ranges = kvm_protect_ranges,
+	.lock_crs = kvm_lock_crs,
+};
+
+static void kvm_init_heki(void)
+{
+	long err;
+
+	if (!kvm_para_available())
+		/* Cannot make KVM hypercalls. */
+		return;
+
+	err = kvm_hypercall3(KVM_HC_LOCK_MEM_PAGE_RANGES, -1, -1, -1);
+	if (err == -KVM_ENOSYS)
+		/* Ignores host. */
+		return;
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
@@ -1007,6 +1078,7 @@ const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.init.x2apic_available		= kvm_para_available,
 	.init.msi_ext_dest_id		= kvm_msi_ext_dest_id,
 	.init.init_platform		= kvm_init_platform,
+	.init.init_heki			= kvm_init_heki,
 #if defined(CONFIG_AMD_MEM_ENCRYPT)
 	.runtime.sev_es_hcall_prepare	= kvm_sev_es_hcall_prepare,
 	.runtime.sev_es_hcall_finish	= kvm_sev_es_hcall_finish,
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ef80d361b463..0a023c24fcdb 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -114,6 +114,7 @@ struct x86_init_ops x86_init __initdata = {
 		.msi_ext_dest_id	= bool_x86_init_noop,
 		.init_mem_mapping	= x86_init_noop,
 		.init_after_bootmem	= x86_init_noop,
+		.init_heki		= x86_init_noop,
 	},
 
 	.acpi = {
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbeaa9ddef59..ba355171ceeb 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,6 +49,7 @@ config KVM
 	select SRCU
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
+	select HYPERVISOR_SUPPORTS_HEKI
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 9858a827fe17..96f18ce03013 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -6,7 +6,7 @@
 config HEKI
 	bool "Hypervisor Enforced Kernel Integrity (Heki)"
 	default y
-	depends on !JUMP_LABEL && ARCH_SUPPORTS_HEKI
+	depends on !JUMP_LABEL && ARCH_SUPPORTS_HEKI && HYPERVISOR_SUPPORTS_HEKI
 	select KVM_EXTERNAL_WRITE_TRACKING if KVM
 	help
 	  This feature enhances guest virtual machine security by taking
@@ -20,3 +20,10 @@ config ARCH_SUPPORTS_HEKI
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
diff --git a/virt/heki/heki.c b/virt/heki/heki.c
index c8cb1b84cceb..142b5dc98a2f 100644
--- a/virt/heki/heki.c
+++ b/virt/heki/heki.c
@@ -91,12 +91,6 @@ void heki_late_init(void)
 		return;
 	}
 
-	/*
-	 * Hypervisor support will be added in the future. When it is, the
-	 * hypervisor will be used to protect guest kernel memory and
-	 * control registers.
-	 */
-
 	if (!hypervisor) {
 		/* This happens for kernels running on bare metal as well. */
 		pr_warn("No hypervisor support\n");
-- 
2.40.1

