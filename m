Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AC15E7659
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 10:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiIWI61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 04:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiIWI6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 04:58:19 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ACA12CC91;
        Fri, 23 Sep 2022 01:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663923498; x=1695459498;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ye5IuAR2ki3nZDcfAggkXges9D5ud5Vzu0DnBXM27XE=;
  b=CjGgPMSToqfbife3YmkmgtpOMqHn183PF5WF5jE+DxqL8CKvHJrGTz7e
   7Kq+h0NG+miD3PcaQM5/A1lLeHVydaYYjQ0WJw64zOW+2CQVahnfGhuSr
   /iwOxGWz6PjsZeVXdxyu0sTNUAryvfUzDlZ7IWaG9eXFpcIbvAQzuwIm+
   hDvzIULqWBAId0/JH6indQF+Hun4Wz6TfxB8R96F56TqSa17b7UEWOCwf
   GBUA6sdyHC/85KtrPN6z2MPHeeChIeBEDq5rp17l9WZKq/8lXUj9yEMYH
   Ok5/eWxTjfLweIXhH1EeDebUy1u8pJd05pcAwCVIXCWa1VqZ/+mK3Mn8X
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="287664024"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="287664024"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 01:58:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="650880234"
Received: from spr.sh.intel.com ([10.239.53.122])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 01:58:14 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jon@nutanix.com,
        kevin.tian@intel.com
Cc:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification when CPU is in host
Date:   Fri, 23 Sep 2022 16:58:06 +0800
Message-Id: <20220923085806.384344-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Set PID.SN right after VM exits and clear it before VM entry to minimize
the chance of hardware issuing PINs to a CPU when it's in host.

Also honour PID.SN bit in vmx_deliver_posted_interrupt().

Opportunistically clean up vmx_vcpu_pi_put(); when a vCPU is preempted,
it is pointless to update PID.NV to wakeup vector since notification is
anyway suppressed. And since PID.SN should be already set for running
vCPUs, so, don't set it again for preempted vCPUs.

When IPI virtualization is enabled, this patch increases "perf bench" [*]
by 6.56%, and PIN count in 1 second drops from tens of thousands to
hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
VM-exit round-trip latency.

[*] test cmd: perf bench sched pipe -T. Note that we change the source
code to pin two threads to two different vCPUs so that it can reproduce
stable results.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
RFC: I am not sure whether the benefits outweighs the extra VM-exit cost.

Changes in v2 (addressed comments from Kevin):
- measure/estimate the impact to non-IPC-intensive cases
- don't tie PID.SN to vcpu->mode. Instead, clear PID.SN
  right before VM-entry and set it after VM-exit.
- use !pi_is_pir_empty() in pi_enable_wakeup_handler() to
  check if any interrupt was posted after clearing SN.
- clean up vmx_vcpu_pi_put(). See comments above.

 arch/x86/kvm/lapic.c           |  2 ++
 arch/x86/kvm/vmx/posted_intr.c | 55 +++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.c         | 34 ++++++++++++++++++++-
 3 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..a9f27c6ce937 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -128,7 +128,9 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 }
 
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
+EXPORT_SYMBOL_GPL(apic_hw_disabled);
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
+EXPORT_SYMBOL_GPL(apic_sw_disabled);
 
 static inline int apic_enabled(struct kvm_lapic *apic)
 {
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 1b56c5e5c9fb..9cec3dd88f75 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -70,12 +70,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 * needs to be changed.
 	 */
 	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
-		/*
-		 * Clear SN if it was set due to being preempted.  Again, do
-		 * this even if there is no assigned device for simplicity.
-		 */
-		if (pi_test_and_clear_sn(pi_desc))
-			goto after_clear_sn;
 		return;
 	}
 
@@ -101,11 +95,16 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		new.control = old.control;
 
 		/*
-		 * Clear SN (as above) and refresh the destination APIC ID to
-		 * handle task migration (@cpu != vcpu->cpu).
+		 * Set SN and refresh the destination APIC ID to handle
+		 * task migration (@cpu != vcpu->cpu).
+		 *
+		 * SN is cleared when a vCPU goes to blocked state so that
+		 * the blocked vCPU can be waken up on receiving a
+		 * notification. For a running/runnable vCPU, such
+		 * notifications are useless. Set SN bit to suppress them.
 		 */
 		new.ndst = dest;
-		new.sn = 0;
+		new.sn = 1;
 
 		/*
 		 * Restore the notification vector; in the blocking case, the
@@ -115,19 +114,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -155,13 +141,15 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
-	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
-
 	old.control = READ_ONCE(pi_desc->control);
 	do {
-		/* set 'NV' to 'wakeup vector' */
+		/*
+		 * set 'NV' to 'wakeup vector' and clear SN bit so that
+		 * the blocked vCPU can be waken up on receiving interrupts.
+		 */
 		new.control = old.control;
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
+		new.sn = 0;
 	} while (pi_try_set_control(pi_desc, &old.control, new.control));
 
 	/*
@@ -172,8 +160,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	 * enabled until it is safe to call try_to_wake_up() on the task being
 	 * scheduled out).
 	 */
-	if (pi_test_on(&new))
+	if (!pi_is_pir_empty(pi_desc)) {
+		pi_set_on(pi_desc);
 		apic->send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
+	}
 
 	local_irq_restore(flags);
 }
@@ -193,21 +183,12 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
 
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
+	if (!vcpu->preempted && kvm_vcpu_is_blocking(vcpu) &&
+	    !vmx_interrupt_blocked(vcpu))
 		pi_enable_wakeup_handler(vcpu);
-
-	/*
-	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
-	 * as blocking and preempted, e.g. if it's preempted between setting
-	 * its wait state and manually scheduling out.
-	 */
-	if (vcpu->preempted)
-		pi_set_sn(pi_desc);
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..949fb80eca3d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4186,6 +4186,9 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
 		return 0;
 
+	if (pi_test_sn(&vmx->pi_desc))
+		return 0;
+
 	/* If a previous notification has sent the IPI, nothing to do.  */
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
@@ -6706,7 +6709,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
 		return -EIO;
 
-	if (pi_test_on(&vmx->pi_desc)) {
+	if (pi_test_on(&vmx->pi_desc) || pi_test_sn(&vmx->pi_desc)) {
 		pi_clear_on(&vmx->pi_desc);
 		/*
 		 * IOMMU can write to PID.ON, so the barrier matters even on UP.
@@ -7187,11 +7190,40 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
 
+	/* do this even if apicv is disabled for simplicity */
+	if (kvm_lapic_enabled(vcpu)) {
+		pi_clear_sn(&vmx->pi_desc);
+		/*
+		 * Clear SN before reading the bitmap.  The VT-d firmware
+		 * writes the bitmap and reads SN atomically (5.2.3 in the
+		 * spec), so it doesn't really have a memory barrier that
+		 * pairs with this, but we cannot do that and we need one.
+		 */
+		smp_mb__after_atomic();
+
+		if (!pi_is_pir_empty(&vmx->pi_desc)) {
+			pi_set_on(&vmx->pi_desc);
+			apic->send_IPI_self(POSTED_INTR_VECTOR);
+		}
+	}
+
 	kvm_wait_lapic_expire(vcpu);
 
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
 
+	/*
+	 * Suppress notification right after VM exits to minimize the
+	 * window where VT-d or remote CPU may send a useless notification
+	 * when posting interrupts to a VM. Note that the notification is
+	 * useless because KVM syncs pending interrupts in PID.IRR to vAPIC
+	 * IRR before VM entry.
+
+	 * do this even if apicv is disabled for simplicity.
+	 */
+	if (kvm_lapic_enabled(vcpu))
+		pi_set_sn(&vmx->pi_desc);
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs)) {
 		current_evmcs->hv_clean_fields |=

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.25.1

