Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3879C5EDB8C
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 13:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiI1LQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiI1LQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 07:16:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C121E3F5;
        Wed, 28 Sep 2022 04:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664363775; x=1695899775;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RcV3KPaazn2PIACe0R35bRBuj62DXeZ44n4EJfQs478=;
  b=RAxOLvracK06MiujofVWHZ9TRBE7u9sMGkIhTkajvd8m9/4Tad7hPFye
   q/7RiaECO8Ncy4/z1BhQeheea2bsJlsQSE6p+arEzULlIbzIhlJwVW9O7
   DLZcbVrc+bTNYKxlGzOqjVxaD3HuijHuoAIWbEDsgqrzZ5wT7tztBju8/
   TLTEzilAW5MQ6eHh6nEWar9nHcYfBQPdNq8CgQVF/NsGtlnSoKSMYnqxo
   SHoH7mdrqFMpxrXtEoAQ7Me9WmkdnO1FXtMY1B9cGp6LrEhhaAK2Ny+za
   O10YQ+sJSvzliIQfN75NDsHUeAUQuK8+AchvrqMJ/mZ1gEwUu7yWwFPEY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="303057526"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="303057526"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 04:16:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="710934394"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="710934394"
Received: from spr.sh.intel.com ([10.239.53.122])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 04:16:11 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jon@nutanix.com,
        kevin.tian@intel.com, seanjc@google.com
Cc:     Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3] KVM: x86/vmx: Suppress posted interrupt notification when CPU is in host
Date:   Wed, 28 Sep 2022 19:16:03 +0800
Message-Id: <20220928111604.180284-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PIN (Posted interrupt notification) is useless to host as KVM always syncs
pending guest interrupts in PID to guest's vAPIC before each VM entry. In
fact, Sending PINs to a CPU running in host will lead to additional
overhead due to interrupt handling.

Currently, software path, vmx_deliver_posted_interrupt(), is optimized to
issue PINs only if target vCPU is in IN_GUEST_MODE. But hardware paths
(VT-d and Intel IPI virtualization) aren't optimized.

Suppress notification unless notification is necessary (when vCPU is
blocked or running in guest). Specifically, set PID.SN when kvm sets
OUTSIDE_GUEST_MODE and vCPUs wake up from blocking, and clear PID.SN when
kvm sets IN_GUEST_MODE and vCPUs starts to block. Also, don't toggle PID.SN
at any other places, e.g., vmx_vcpu_pi_load().

To allow x86 common code to toggle SN bit when kvm sets vcpu->mode,
a new kvm_x86_ops is added.

When IPI virtualization is enabled, this patch increases "perf bench" [*]
by 8.10%, and PIN count in 1 second drops from tens of thousands to
tens. But cpuid loop test shows this patch causes 0.94% overhead in
VM-exit round-trip latency.

[*] test cmd: perf bench sched pipe -T. Note that we change the source
code to pin two threads to two different vCPUs so that it can reproduce
stable results.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
Changes in v3:
 - add a dedicated hook to toggle SN
 - clear/set SN when kvm sets IN/OUTSIDE_GUEST_MODE
 - use kvm_arch_vcpu_{un}blocking instead of vcpu_put/load to set/clear SN
   for blocked vCPUs
 - recollect perf data and update the figures in commit message

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/posted_intr.c     | 63 +++++++++++++++++-------------
 arch/x86/kvm/vmx/posted_intr.h     |  1 +
 arch/x86/kvm/vmx/vmx.c             | 22 ++++++++++-
 arch/x86/kvm/x86.c                 | 20 ++++++++++
 6 files changed, 80 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 51f777071584..a2d77302d7a8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -86,6 +86,7 @@ KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
 KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
+KVM_X86_OP_OPTIONAL(pi_suppress_notification)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..66d67b198021 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1543,6 +1543,7 @@ struct kvm_x86_ops {
 	void (*deliver_interrupt)(struct kvm_lapic *apic, int delivery_mode,
 				  int trig_mode, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
+	void (*pi_suppress_notification)(struct kvm_vcpu *vcpu, bool suppress);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 1b56c5e5c9fb..ae1794a213d7 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -48,6 +48,38 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
 	return 0;
 }
 
+/*
+ * Toggle Suppress Notification (SN) bit in PID.
+ *
+ * Note that after clearing SN, the check of PIR and setting ON bit
+ * ensure pending IRQs in PIR are not ignored.
+ */
+void vmx_pi_suppress_notification(struct kvm_vcpu *vcpu, bool suppress)
+{
+	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+
+	if (suppress) {
+		pi_set_sn(pi_desc);
+	} else {
+		pi_clear_sn(pi_desc);
+		/*
+		 * Clear SN before reading the bitmap.  The VT-d firmware
+		 * writes the bitmap and reads SN atomically (5.2.3 in the
+		 * spec), so it doesn't really have a memory barrier that
+		 * pairs with this, but we cannot do that and we need one.
+		 */
+		smp_mb__after_atomic();
+
+		/*
+		 * ON may be out of sync with PIR. Set ON if there are
+		 * pending IRQs in PIR to ensure subsequent
+		 * ->sync_pir_to_irr() won't leave the pending IRQs behind.
+		 */
+		if (!pi_test_on(pi_desc) && !pi_is_pir_empty(pi_desc))
+			pi_set_on(pi_desc);
+	}
+}
+
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
@@ -69,15 +101,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * full update can be skipped as neither the vector nor the destination
 	 * needs to be changed.
 	 */
-	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
-		/*
-		 * Clear SN if it was set due to being preempted.  Again, do
-		 * this even if there is no assigned device for simplicity.
-		 */
-		if (pi_test_and_clear_sn(pi_desc))
-			goto after_clear_sn;
+	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu)
 		return;
-	}
 
 	local_irq_save(flags);
 
@@ -101,11 +126,10 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		new.control = old.control;
 
 		/*
-		 * Clear SN (as above) and refresh the destination APIC ID to
-		 * handle task migration (@cpu != vcpu->cpu).
+		 * Refresh the destination APIC ID to handle task migration
+		 * (@cpu != vcpu->cpu).
 		 */
 		new.ndst = dest;
-		new.sn = 0;
 
 		/*
 		 * Restore the notification vector; in the blocking case, the
@@ -115,19 +139,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	} while (pi_try_set_control(pi_desc, &old.control, new.control));
 
 	local_irq_restore(flags);
-
-after_clear_sn:
-
-	/*
-	 * Clear SN before reading the bitmap.  The VT-d firmware
-	 * writes the bitmap and reads SN atomically (5.2.3 in the
-	 * spec), so it doesn't really have a memory barrier that
-	 * pairs with this, but we cannot do that and we need one.
-	 */
-	smp_mb__after_atomic();
-
-	if (!pi_is_pir_empty(pi_desc))
-		pi_set_on(pi_desc);
 }
 
 static bool vmx_can_use_vtd_pi(struct kvm *kvm)
@@ -193,8 +204,6 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
 
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
@@ -207,7 +216,7 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	 * its wait state and manually scheduling out.
 	 */
 	if (vcpu->preempted)
-		pi_set_sn(pi_desc);
+		vmx_pi_suppress_notification(vcpu, true);
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 26992076552e..9232b87bf63e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -102,5 +102,6 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
 void vmx_pi_start_assignment(struct kvm *kvm);
+void vmx_pi_suppress_notification(struct kvm_vcpu *vcpu, bool suppress);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..084894c50b64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6697,6 +6697,16 @@ static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 		vmx_set_rvi(max_irr);
 }
 
+static void vmx_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+	vmx_pi_suppress_notification(vcpu, false);
+}
+
+static void vmx_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	vmx_pi_suppress_notification(vcpu, true);
+}
+
 static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6706,7 +6716,14 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
 		return -EIO;
 
-	if (pi_test_on(&vmx->pi_desc)) {
+	/*
+	 * Check PIR if ON=1 || SN=1. This is required to avoid breaking
+	 * halt-polling (and other call sites with SN=1). Notification
+	 * during halt-polling is undesired. But VT-d engine and IPI
+	 * virtualization don't set ON if SN=1. To ensure KVM can detect
+	 * pending IRQs in time, check PIR as well if SN=1.
+	 */
+	if (pi_test_on(&vmx->pi_desc) || pi_test_sn(&vmx->pi_desc)) {
 		pi_clear_on(&vmx->pi_desc);
 		/*
 		 * IOMMU can write to PID.ON, so the barrier matters even on UP.
@@ -8030,6 +8047,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
+	.vcpu_blocking = vmx_vcpu_blocking,
+	.vcpu_unblocking = vmx_vcpu_unblocking,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
@@ -8089,6 +8108,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
+	.pi_suppress_notification = vmx_pi_suppress_notification,
 	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..ce744e840423 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10426,6 +10426,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	/* Store vcpu->apicv_active before vcpu->mode.  */
 	smp_store_release(&vcpu->mode, IN_GUEST_MODE);
+	/*
+	 * Notification are necessary to trigger the delivery of posted
+	 * IRQs when vCPU is running in guest. Enable notification before
+	 * guest entry.
+	 *
+	 * Do this even if apicv is disabled for simplicity.
+	 */
+	if (kvm_lapic_enabled(vcpu))
+		static_call_cond(kvm_x86_pi_suppress_notification)(vcpu, false);
 
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
@@ -10538,6 +10547,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
+	/*
+	 * Suppress notification when CPU is OUTSIDE_GUEST_MODE to avoid
+	 * wasting time on handling interrupts. A notification to host/kvm
+	 * just indicates some interrupts are posted for a vCPU. Since KVM
+	 * always syncs pending interrupts in PIR to vAPIC IRR before guest
+	 * entry (in ->sync_pir_to_irr()), notification isn't needed.
+	 *
+	 * Do this even if apicv is disabled for simplicity.
+	 */
+	if (kvm_lapic_enabled(vcpu))
+		static_call_cond(kvm_x86_pi_suppress_notification)(vcpu, true);
 
 	/*
 	 * Sync xfd before calling handle_exit_irqoff() which may

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.25.1

