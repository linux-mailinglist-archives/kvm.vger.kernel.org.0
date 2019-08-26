Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2104A9C947
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfHZGVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:54 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34993 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729725AbfHZGVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so9963127pgv.2;
        Sun, 25 Aug 2019 23:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/ZFwrCleNJ92m7DMel1cTd9BzXwNczRmQVnLibwjoPs=;
        b=nI5ZUlHiUZgqlEJQnkHg2X/R8OKaBWAJEs1s781gVvWbFe/nA/cS5halOBOj5/l72c
         JH8i6YOCMAOKGDrFpNDpFXQn7aIJGG4qYOkfIILiyLJmLXSj6sS6xw834v3v20q4y5yQ
         INV22GElW+3gn5kTSVQrLiTAvPJN6J4IAzQ5rvqd4CFjsiehdz+SMjOJCDAj74gTQzuA
         ncxmcZZpdTf5aszveV7tpFWn1c2JNZIIwJS5mmx93SlahkGyQeQpFdcsOvMqXw2upJXy
         wua0yHWyx/cL27131IX/3X7VPcGsEJ8pzlKivEXbXJGnEF1pwFhZqPGVWK/SOyGS9D5M
         T1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/ZFwrCleNJ92m7DMel1cTd9BzXwNczRmQVnLibwjoPs=;
        b=XBbXoUwSeaDHOnL4nez7557o2kg42gxUjem/RfQYmmhwYGOj1c84rCsUl3ccIQtchE
         EAC3gAQAM4/8fpyWiwqqK0N8P9Gos6uN4Gu7T2S5p+cWAbDIDhga4V1Gxs+wuWHkvxJ/
         6L1ssrSGYulUJ3tUYeiqDjM9HM4GrOBlw1pyemEmKy4/6DUfe4+MzArceoe2+hSchhGE
         aQ7VgmPHjMSE9XuLv1TehJyGnGTwKDFeoZZJLE3BaU7xn0aE74EPZarTuwys3VFpI6LE
         0n5x16QN4jtXGJZvmsJz68qg5X+75s5y0Per1PYQ9/ufSAwl2O+nLCdPLnt+n122kc1I
         Z1ZA==
X-Gm-Message-State: APjAAAV6tGV6sF3V0DfEOVYY+ykNmF7T4JNenaXI3bDE33UalVq1mNnR
        LJAhO0bIlHMku3YFmDiFAzcRe5U2BDU=
X-Google-Smtp-Source: APXvYqwpTMGTcIg7Hg0u9QZca4esZxYHPcJK8X6zthBnDy4BYkMvP0Zn7gY2zqWts1jO2YVZJUoxnw==
X-Received: by 2002:a63:484a:: with SMTP id x10mr14864879pgk.430.1566800512518;
        Sun, 25 Aug 2019 23:21:52 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:52 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 15/23] KVM: PPC: Book3S HV: Store lpcr and hdec_exp in the vcpu struct
Date:   Mon, 26 Aug 2019 16:21:01 +1000
Message-Id: <20190826062109.7573-16-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running a single vcpu with kvmhv_run_single_vcpu() the lpcr and
hypervisor decrementer expiry are passed as function arguments. When
running a vcore with kvmppc_run_vcpu() the lpcr is taken from the vcore
and there is no need to consider the hypervisor decrementer expiry as it
only applies when running a nested guest.

These fields will need to be accessed in the guest entry path in
book3s_hv_rmhandlers.S when running a nested hpt (hash page table)
guest. To allow for this store the lpcr and hdec_exp in the vcpu struct.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |  3 +--
 arch/powerpc/include/asm/kvm_host.h   |  2 ++
 arch/powerpc/kvm/book3s_hv.c          | 40 +++++++++++++++++------------------
 arch/powerpc/kvm/book3s_hv_nested.c   | 10 ++++-----
 4 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 40218e81b75f..e1dc1872e453 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -314,8 +314,7 @@ void kvmhv_set_ptbl_entry(unsigned int lpid, u64 dw0, u64 dw1);
 void kvmhv_release_all_nested(struct kvm *kvm);
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu);
 long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu);
-int kvmhv_run_single_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu,
-			  u64 time_limit, unsigned long lpcr);
+int kvmhv_run_single_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu);
 void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr);
 void kvmhv_save_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp);
 void kvmhv_restore_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index bad09c213be6..b092701951ee 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -793,10 +793,12 @@ struct kvm_vcpu_arch {
 
 	u32 online;
 
+	unsigned long lpcr;
 	/* For support of nested guests */
 	struct kvm_nested_guest *nested;
 	u32 nested_vcpu_id;
 	gpa_t nested_io_gpr;
+	u64 hdec_exp;
 #endif
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index be72bc6b4cd5..8407071d5e22 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3429,8 +3429,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 /*
  * Handle making the H_ENTER_NESTED hcall if we're pseries.
  */
-static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
-				     unsigned long lpcr)
+static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit)
 {
 	/* call our hypervisor to load up HV regs and go */
 	struct hv_guest_state hvregs;
@@ -3454,7 +3453,7 @@ static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
 	host_psscr = mfspr(SPRN_PSSCR_PR);
 	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
 	kvmhv_save_hv_regs(vcpu, &hvregs);
-	hvregs.lpcr = lpcr;
+	hvregs.lpcr = vcpu->arch.lpcr;
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
 	if (vcpu->arch.nested) {
 		hvregs.lpid = vcpu->arch.nested->shadow_lpid;
@@ -3536,8 +3535,7 @@ static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
  * CPU_FTR_HVMODE is set. This is only used for radix guests, however that
  * radix guest may be a direct guest of this hypervisor or a nested guest.
  */
-static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
-				     unsigned long lpcr)
+static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	s64 hdec;
@@ -3594,7 +3592,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	mtspr(SPRN_LPCR, lpcr);
+	mtspr(SPRN_LPCR, vcpu->arch.lpcr);
 	isync();
 
 	kvmppc_xive_push_vcpu(vcpu);
@@ -3666,8 +3664,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
  * Virtual-mode guest entry for POWER9 and later when the host and
  * guest are both using the radix MMU.  The LPIDR has already been set.
  */
-int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
-			 unsigned long lpcr)
+int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	unsigned long host_dscr = mfspr(SPRN_DSCR);
@@ -3675,7 +3672,7 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	unsigned long host_iamr = mfspr(SPRN_IAMR);
 	unsigned long host_amr = mfspr(SPRN_AMR);
 	s64 dec;
-	u64 tb;
+	u64 tb, time_limit;
 	int trap, save_pmu;
 
 	dec = mfspr(SPRN_DEC);
@@ -3683,8 +3680,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (dec < 512)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	local_paca->kvm_hstate.dec_expires = dec + tb;
-	if (local_paca->kvm_hstate.dec_expires < time_limit)
-		time_limit = local_paca->kvm_hstate.dec_expires;
+	time_limit = min_t(u64, local_paca->kvm_hstate.dec_expires,
+				vcpu->arch.hdec_exp);
 
 	vcpu->arch.ceded = 0;
 
@@ -3736,15 +3733,16 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
 
 	if (kvmhv_on_pseries()) {
-		trap = kvmhv_pseries_enter_guest(vcpu, time_limit, lpcr);
+		trap = kvmhv_pseries_enter_guest(vcpu, time_limit);
 	} else {
-		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit);
 	}
 
 	if (kvm_is_radix(vcpu->kvm))
 		vcpu->arch.slb_max = 0;
 	dec = mfspr(SPRN_DEC);
-	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+	/* Sign extend if not using large decrementer */
+	if (!(vcpu->arch.lpcr & LPCR_LD))
 		dec = (s32) dec;
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
@@ -4145,9 +4143,7 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	return vcpu->arch.ret;
 }
 
-int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
-			  struct kvm_vcpu *vcpu, u64 time_limit,
-			  unsigned long lpcr)
+int kvmhv_run_single_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	int trap, r, pcpu;
 	int srcu_idx, lpid;
@@ -4206,7 +4202,7 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 		}
 		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
 			     &vcpu->arch.pending_exceptions))
-			lpcr |= LPCR_MER;
+			vcpu->arch.lpcr |= LPCR_MER;
 	} else if (vcpu->arch.pending_exceptions ||
 		   vcpu->arch.doorbell_request ||
 		   xive_interrupt_pending(vcpu)) {
@@ -4242,7 +4238,7 @@ int kvmhv_run_single_vcpu(struct kvm_run *kvm_run,
 	/* Tell lockdep that we're about to enable interrupts */
 	trace_hardirqs_on();
 
-	trap = kvmhv_p9_guest_entry(vcpu, time_limit, lpcr);
+	trap = kvmhv_p9_guest_entry(vcpu);
 	vcpu->arch.trap = trap;
 
 	trace_hardirqs_off();
@@ -4399,6 +4395,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
+		/* update vcpu->arch.lpcr in case a previous loop modified it */
+		vcpu->arch.lpcr = vcpu->arch.vcore->lpcr;
+		vcpu->arch.hdec_exp = ~(u64)0;
 		/*
 		 * The early POWER9 chips that can't mix radix and HPT threads
 		 * on the same core also need the workaround for the problem
@@ -4412,8 +4411,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		if (kvmhv_on_pseries() || (kvm->arch.threads_indep &&
 					   kvm_is_radix(kvm) &&
 					   !no_mixing_hpt_and_radix))
-			r = kvmhv_run_single_vcpu(run, vcpu, ~(u64)0,
-						  vcpu->arch.vcore->lpcr);
+			r = kvmhv_run_single_vcpu(run, vcpu);
 		else
 			r = kvmppc_run_vcpu(run, vcpu);
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 883f8896ed60..f80491e9ff97 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -267,7 +267,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	struct guest_slb *l2_slb = NULL, *saved_l1_slb = NULL;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 hv_ptr, regs_ptr, slb_ptr = 0UL;
-	u64 hdec_exp;
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
 	u64 mask;
 	unsigned long lpcr;
@@ -357,7 +356,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	}
 
 	/* convert TB values/offsets to host (L0) values */
-	hdec_exp = l2_hv.hdec_expiry - vc->tb_offset;
+	vcpu->arch.hdec_exp = l2_hv.hdec_expiry - vc->tb_offset;
 	vc->tb_offset += l2_hv.tb_offset;
 
 	/* set L1 state to L2 state */
@@ -377,14 +376,15 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
 	do {
-		if (mftb() >= hdec_exp) {
+		if (mftb() >= vcpu->arch.hdec_exp) {
 			vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
 			r = RESUME_HOST;
 			break;
 		}
+		/* update vcpu->arch.lpcr in case a previous loop modified it */
+		vcpu->arch.lpcr = lpcr;
 		if (radix)
-			r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu,
-						  hdec_exp, lpcr);
+			r = kvmhv_run_single_vcpu(vcpu->arch.kvm_run, vcpu);
 		else
 			r = RESUME_HOST; /* XXX TODO hpt entry path */
 	} while (is_kvmppc_resume_guest(r));
-- 
2.13.6

