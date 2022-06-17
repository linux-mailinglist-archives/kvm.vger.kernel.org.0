Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E2D54FB77
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 18:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382736AbiFQQvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382897AbiFQQvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 12:51:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB32658E79;
        Fri, 17 Jun 2022 09:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655484602; x=1687020602;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zQS/FHBe/xvbUhzuffrSKUw2wu4SEZ9837E6Yr3LE3Y=;
  b=colkhA1mwpG7qYdoioWSxkKuATNj286C0ZGgCRMxZ9NuBzg1bMoHhdw6
   8UPWqkS9Z5Ww6pF8fWcYN02cQqBjyUFBq6A8ibS3o5gQa/ADgJCi1Joma
   W6WfcsjiOtpX2EwiAMFXWx+H+wn2kxmOYTsb0pJRLBTBLlL1hsMXpTl5F
   4yVeehgIVizk24j3v4FbOVgH7y6bb2uhsYOVNH5t0DUhzLD0/LCfohPXU
   3cfEKvntcl7fnCWkT5Yv7osugtdqkpe1hA7oYjrre29rvm3jq3rK/LMbh
   g7b7fl0cjzjnt5Kg9Ede8zkhDJP/UXrKG+y3M+Koz0jRHEdxJKlLSKGhN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="365830199"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="365830199"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 04:46:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="642003930"
Received: from spr.sh.intel.com ([10.239.53.118])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 04:46:53 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: x86/vmx: Suppress posted interrupt notification when CPU is in host
Date:   Fri, 17 Jun 2022 19:46:41 +0800
Message-Id: <20220617114641.146243-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

When IPI virtualization is enabled, this patch increases "perf bench" [*]
by 4% from 8.12 us/ops to 7.80 us/ops.

[*] test cmd: perf bench sched pipe -T. Note that we change the source
code to pin two threads to two different vCPUs so that it can reproduce
stable results.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 28 ++--------------------------
 arch/x86/kvm/vmx/vmx.c         | 24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 237a1f40f939..a0458f72df99 100644
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
 
@@ -99,12 +93,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
 
-		/*
-		 * Clear SN (as above) and refresh the destination APIC ID to
-		 * handle task migration (@cpu != vcpu->cpu).
-		 */
 		new.ndst = dest;
-		new.sn = 0;
+		new.sn = 1;
 
 		/*
 		 * Restore the notification vector; in the blocking case, the
@@ -114,19 +104,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	} while (pi_try_set_control(pi_desc, old.control, new.control));
 
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
@@ -154,13 +131,12 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
-	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
-
 	do {
 		old.control = new.control = READ_ONCE(pi_desc->control);
 
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
+		new.sn = 0;
 	} while (pi_try_set_control(pi_desc, old.control, new.control));
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a3c5504601a8..fa915b1680eb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4036,6 +4036,9 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
 		return 0;
 
+	if (pi_test_sn(&vmx->pi_desc))
+		return 0;
+
 	/* If a previous notification has sent the IPI, nothing to do.  */
 	if (pi_test_and_set_on(&vmx->pi_desc))
 		return 0;
@@ -6520,8 +6523,17 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
 		return -EIO;
 
-	if (pi_test_on(&vmx->pi_desc)) {
+	if (pi_test_on(&vmx->pi_desc) || pi_test_sn(&vmx->pi_desc)) {
 		pi_clear_on(&vmx->pi_desc);
+
+		/*
+		 * IN_GUEST_MODE means we are about to enter vCPU. Allow
+		 * PIN (posted interrupt notification) to deliver is key
+		 * to interrupt posting. Clear PID.SN.
+		 */
+		if (vcpu->mode == IN_GUEST_MODE)
+			pi_clear_sn(&vmx->pi_desc);
+
 		/*
 		 * IOMMU can write to PID.ON, so the barrier matters even on UP.
 		 * But on x86 this is just a compiler barrier anyway.
@@ -6976,6 +6988,16 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, vmx);
 
+	/*
+	 * Suppress notification right after VM exits to minimize the
+	 * window where VT-d or remote CPU may send a useless notification
+	 * when posting interrupts to a VM. Note that the notification is
+	 * useless because KVM syncs pending interrupts in PID.IRR to vAPIC
+	 * IRR before VM entry.
+	 */
+	if (kvm_vcpu_apicv_active(vcpu))
+		pi_set_sn(&vmx->pi_desc);
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
-- 
2.25.1

