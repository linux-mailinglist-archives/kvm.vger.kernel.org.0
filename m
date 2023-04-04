Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10636D5E2B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbjDDKyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbjDDKxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:53:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2164F3C3B;
        Tue,  4 Apr 2023 03:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605585; x=1712141585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LezTItrOTBDG2aixpyZh+BhRRHCKfV9D1LBlf5QDBQY=;
  b=DOIUiUS3mwyDkhmG5fJijIlg/v7euWt8hv0cPIjjxmbbervbvuCEyURU
   XMWimbqns9lS/j0mEj0s/3jD8CX7xb9jjuXz59kB8mH6D6dZYmZOeSSsg
   QYEjKjfDPfzkgxY8k1vaGWr2khOjiE73egoE5GdvVk9ljq1SCdKPAalKf
   Np0YUJ+27tcPPl60UydY9mQ+wYDOBLUB508TXh31/Ot4jzQaexd1gL7oF
   FzbfmJSHO0d2BJgozik46aWoiicFsb6Ti3GCwA349fJe6lgB+Z2TTGnov
   ilu8KRWBBhVGqN7vmuQF0zr2a1AURPGSH59qGhGeTYTiKf7MAj7biwmaF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330733957"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330733957"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597789"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597789"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:53:00 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 04/33] x86/traps: add install_system_interrupt_handler()
Date:   Tue,  4 Apr 2023 03:26:47 -0700
Message-Id: <20230404102716.1795-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some kernel components install system interrupt handlers into the IDT,
and we need to do the same for system_interrupt_handlers. A new function
install_system_interrupt_handler() is added to install a system interrupt
handler into both the IDT and system_interrupt_handlers.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h     |  2 ++
 arch/x86/kernel/cpu/acrn.c       |  7 +++++--
 arch/x86/kernel/cpu/mshyperv.c   | 22 ++++++++++++++--------
 arch/x86/kernel/kvm.c            |  4 +++-
 arch/x86/kernel/traps.c          | 10 ++++++++++
 drivers/xen/events/events_base.c |  5 ++++-
 6 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 28c8ba5fd81c..46f5e4e2a346 100644
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
index f1197366a97d..c102c9192cbb 100644
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
@@ -491,19 +492,24 @@ static void __init ms_hyperv_init_platform(void)
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
index 1cceac5984da..5c684df6de7a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -829,7 +829,9 @@ static void __init kvm_guest_init(void)
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
 		static_branch_enable(&kvm_async_pf_enabled);
-		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
+		install_system_interrupt_handler(HYPERVISOR_CALLBACK_VECTOR,
+						 asm_sysvec_kvm_asyncpf_interrupt,
+						 sysvec_kvm_asyncpf_interrupt);
 	}
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2cbe7e7e8b96..12072e2af4a6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1513,6 +1513,16 @@ static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
 
 #endif /* CONFIG_X86_64 */
 
+void __init install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr)
+{
+	BUG_ON(n < FIRST_SYSTEM_VECTOR);
+
+#ifdef CONFIG_X86_64
+	system_interrupt_handlers[n - FIRST_SYSTEM_VECTOR] = (system_interrupt_handler)addr;
+#endif
+	alloc_intr_gate(n, asm_addr);
+}
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index c7715f8bd452..cf1a5ca3bf62 100644
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
@@ -2249,7 +2250,9 @@ static __init void xen_alloc_callback_vector(void)
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

