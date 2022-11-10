Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B99623BFD
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiKJGja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbiKJGjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:39:22 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3688F13E24;
        Wed,  9 Nov 2022 22:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668062361; x=1699598361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=brgRBFcFOhRItxFd22b/yhKeQsd3gT3Cd/ce66ahZHI=;
  b=AgjBGFIzlpG14pNGJcn2poDcpr0QU70mu+SAO612DY5cQkJPQ02MQ0nC
   NDwpUu56r87XXIRXfd66GhVItOBL5o0S92FcSz0dYBf3ttQTYJScLpH3+
   6JNYsVgg6SGGuDOJEmjpvZHr81sLnKF6XAm8030C7z9/MEA46bY6guWsW
   7fbHvRfoQilPXWMchGkQPsNRvtRHonXUlUfdIIwaluOOSklcz6cd+52Zw
   WZniAdqB8iBWbjnaPA+ljGfdFmHDBOr154u7hmaFbDP0NWxPdiNUh9dXJ
   ZK7xZNz7wbXd4OH/VXK8ZMdCSGX6Xth3q1fUcI/NMquYAD8Z0boeVIaj5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="375474003"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="375474003"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="588057224"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="588057224"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga003.jf.intel.com with ESMTP; 09 Nov 2022 22:39:19 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [RESEND PATCH 3/6] x86/traps: add install_system_interrupt_handler()
Date:   Wed,  9 Nov 2022 22:15:42 -0800
Message-Id: <20221110061545.1531-4-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110061545.1531-1-xin3.li@intel.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some kernel components install system interrupt handlers into the IDT,
and we need to do the same for system_interrupt_handler_table. A new
function install_system_interrupt_handler() is added to install a system
interrupt handler into both the IDT and system_interrupt_handler_table.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h     |  2 ++
 arch/x86/kernel/cpu/acrn.c       |  7 +++++--
 arch/x86/kernel/cpu/mshyperv.c   | 22 ++++++++++++++--------
 arch/x86/kernel/kvm.c            |  4 +++-
 arch/x86/kernel/traps.c          | 10 +++++++++-
 drivers/xen/events/events_base.c |  5 ++++-
 6 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 3dc63d753bda..89c4233e19db 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -41,6 +41,8 @@ void math_emulate(struct math_emu_info *);
 
 bool fault_in_kernel_space(unsigned long address);
 
+void install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr);
+
 #ifdef CONFIG_VMAP_STACK
 void __noreturn handle_stack_overflow(struct pt_regs *regs,
 				      unsigned long fault_address,
diff --git a/arch/x86/kernel/cpu/acrn.c b/arch/x86/kernel/cpu/acrn.c
index 485441b7f030..9351bf183a9e 100644
--- a/arch/x86/kernel/cpu/acrn.c
+++ b/arch/x86/kernel/cpu/acrn.c
@@ -18,6 +18,7 @@
 #include <asm/hypervisor.h>
 #include <asm/idtentry.h>
 #include <asm/irq_regs.h>
+#include <asm/traps.h>
 
 static u32 __init acrn_detect(void)
 {
@@ -26,8 +27,10 @@ static u32 __init acrn_detect(void)
 
 static void __init acrn_init_platform(void)
 {
-	/* Setup the IDT for ACRN hypervisor callback */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_acrn_hv_callback);
+	/* Install system interrupt handler for ACRN hypervisor callback */
+	install_system_interrupt_handler(HYPERVISOR_CALLBACK_VECTOR,
+					 asm_sysvec_acrn_hv_callback,
+					 sysvec_acrn_hv_callback);
 
 	x86_platform.calibrate_tsc = acrn_get_tsc_khz;
 	x86_platform.calibrate_cpu = acrn_get_tsc_khz;
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 831613959a92..144b4a622188 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -29,6 +29,7 @@
 #include <asm/i8259.h>
 #include <asm/apic.h>
 #include <asm/timer.h>
+#include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/nmi.h>
 #include <clocksource/hyperv_timer.h>
@@ -415,19 +416,24 @@ static void __init ms_hyperv_init_platform(void)
 	 */
 	x86_platform.apic_post_init = hyperv_init;
 	hyperv_setup_mmu_ops();
-	/* Setup the IDT for hypervisor callback */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_hyperv_callback);
 
-	/* Setup the IDT for reenlightenment notifications */
+	/* Install system interrupt handler for hypervisor callback */
+	install_system_interrupt_handler(HYPERVISOR_CALLBACK_VECTOR,
+					 asm_sysvec_hyperv_callback,
+					 sysvec_hyperv_callback);
+
+	/* Install system interrupt handler for reenlightenment notifications */
 	if (ms_hyperv.features & HV_ACCESS_REENLIGHTENMENT) {
-		alloc_intr_gate(HYPERV_REENLIGHTENMENT_VECTOR,
-				asm_sysvec_hyperv_reenlightenment);
+		install_system_interrupt_handler(HYPERV_REENLIGHTENMENT_VECTOR,
+						 asm_sysvec_hyperv_reenlightenment,
+						 sysvec_hyperv_reenlightenment);
 	}
 
-	/* Setup the IDT for stimer0 */
+	/* Install system interrupt handler for stimer0 */
 	if (ms_hyperv.misc_features & HV_STIMER_DIRECT_MODE_AVAILABLE) {
-		alloc_intr_gate(HYPERV_STIMER0_VECTOR,
-				asm_sysvec_hyperv_stimer0);
+		install_system_interrupt_handler(HYPERV_STIMER0_VECTOR,
+						 asm_sysvec_hyperv_stimer0,
+						 sysvec_hyperv_stimer0);
 	}
 
 # ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d4e48b4a438b..b7388ed2a980 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -835,7 +835,9 @@ static void __init kvm_guest_init(void)
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
 		static_branch_enable(&kvm_async_pf_enabled);
-		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
+		install_system_interrupt_handler(HYPERVISOR_CALLBACK_VECTOR,
+						 asm_sysvec_kvm_asyncpf_interrupt,
+						 sysvec_kvm_asyncpf_interrupt);
 	}
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 95dd917ef9ad..9c7826e588bc 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1458,7 +1458,7 @@ DEFINE_IDTENTRY_SW(iret_error)
  * of the arguments provided by the full system_interrupt_handler prototype,
  * the function type cast is safe here.
  */
-const system_interrupt_handler system_interrupt_handler_table[NR_SYSTEM_VECTORS] = {
+system_interrupt_handler system_interrupt_handler_table[NR_SYSTEM_VECTORS] = {
 	[0 ... NR_SYSTEM_VECTORS-1]		= spurious_interrupt,
 #ifdef CONFIG_SMP
 	SYSV(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi),
@@ -1499,6 +1499,14 @@ const system_interrupt_handler system_interrupt_handler_table[NR_SYSTEM_VECTORS]
 
 #undef SYSV
 
+void __init install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr)
+{
+	BUG_ON(n < FIRST_SYSTEM_VECTOR);
+
+	system_interrupt_handler_table[n - FIRST_SYSTEM_VECTOR] = (system_interrupt_handler)addr;
+	alloc_intr_gate(n, asm_addr);
+}
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c443f04aaad7..1a9eaf417acc 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -45,6 +45,7 @@
 #include <asm/irq.h>
 #include <asm/io_apic.h>
 #include <asm/i8259.h>
+#include <asm/traps.h>
 #include <asm/xen/cpuid.h>
 #include <asm/xen/pci.h>
 #endif
@@ -2246,7 +2247,9 @@ static __init void xen_alloc_callback_vector(void)
 		return;
 
 	pr_info("Xen HVM callback vector for event delivery is enabled\n");
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_xen_hvm_callback);
+	install_system_interrupt_handler(HYPERVISOR_CALLBACK_VECTOR,
+					 asm_sysvec_xen_hvm_callback,
+					 sysvec_xen_hvm_callback);
 }
 #else
 void xen_setup_callback_vector(void) {}
-- 
2.34.1

