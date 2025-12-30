Return-Path: <kvm+bounces-66854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8EECEAA38
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:56:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 500943010294
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 20:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF3A2FD1C1;
	Tue, 30 Dec 2025 20:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aji2ts3G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22262E8DFD
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767128205; cv=none; b=Dsb2+xsGm+RFptKHJNtl+7yq5u7AoQ7xn4XAfr4gzkHBOmvXDYrwwoT3+ujEl5lo4C6w5LrDBO/61jJmoUns/a436ffyXHpZ6AfkCzRPUg3/smcgkSXxBTJ77cdvEH5eqal05Os67ithxGBHF6Ua3bSlY9zi5fhR76lVkzFdDCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767128205; c=relaxed/simple;
	bh=Zpti2DE8NLjjGFX7QkWgyP3/8trcS9RnFliaTJhMRTY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Q/OuCtVkM0DiUv/Ov0iz7aONKUEdhjfFV96EIQ1VEFtnS5iz2By7hTkAayydkMzyY25wZBUAzd6oQnHb76NpyCeW1kCNaOziFFBFtEMmYojzwifXK3PwBFU8Zm2Puw3YVsqPhSxSi8U7owlixp5wpZuHbRw8SHpJ09Rq/w6KEak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aji2ts3G; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c240728e2aso21695362b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 12:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767128203; x=1767733003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DRabemupLF66hH0SwZ7ZSRwpDtdLTil/3jaPkZaQB7o=;
        b=aji2ts3GhG7yuHt66nPSk1iY2jORzWlSmHZp3PumsDcBs8BBeOlxVTwRcqXbzM6wBv
         x5b7hRAE+9DD+D4RGWZDXrPF+iX3rgq2xGy3ZJemCLWhelv1esgvSG9FjY8XPeduUfp4
         Caf8Z155hoFkgxEm1+f/e6efNKXZS6nJuIT1LD3KVT8GA5QENRupI1oc9bZ++gPvOOxU
         yaopOAStO+e6UxXa44pPMj7r/AX8ncG7ThoadzBXrct4rN6tLVOeg2qhDtGUOCr47mwQ
         YZFF8ZB8IVL+S9shaidrEeMkvdPVQ5+zF13XYJ9FNAaLKCgQ8sEVr/y0Rcxz3qXLRZbg
         Iaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767128203; x=1767733003;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DRabemupLF66hH0SwZ7ZSRwpDtdLTil/3jaPkZaQB7o=;
        b=vONF7V28bdbzQMCf7F1vXtprhYQzsAPdCLijnblWTODHfQpFOG59//EZk08nfYqfxH
         Mz2q/v21veouJLW2vrntNw8ke6rBjHOyobohA08F1uUR+X8zPooxaUGx1yR/3MYhHVyN
         E9Jw+7ZkMqvtxpSh0Fr/Ut4wleocELij5AwRCEvmiBZEg2l4DIEPat3iWoWaaSfu6Oh7
         qB3cTOMKr97W8D3Ar4cojNWCnMnBHdM80dfVIloonwr/lVSQ9yXn2JP0zRMzdq+qJz5P
         9WzaQCWmyJCV71CKqi5htM2m0C9MRASXg+cvA5jDTfZidDm5NwK94GYnowDTTOuzAA5v
         lVWA==
X-Gm-Message-State: AOJu0YxqUL5ecEm0Mkor+wpHOCa4qJPtoXpVDVoWPq3bkMpLCMIli/xY
	n9agas2YiVQI5GqEiV5yYpXUgP3A3yDasaPjNuau6W1DR8BInMToUCL0Wk6IaPArjaRE/98eRjg
	WCJwJAQ==
X-Google-Smtp-Source: AGHT+IEX1PqvWuWghUFfljNmHndzHQxhOTfzYiMCKX2gYau/+FcPOnzEAXLj2mcgonFc2H2/No2Y4aDmEU8=
X-Received: from pflb16.prod.google.com ([2002:a05:6a00:a90:b0:7b0:e3d3:f040])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:278e:b0:7f6:fd3b:caa6
 with SMTP id d2e1a72fcca58-7ff648e960dmr27916022b3a.19.1767128203055; Tue, 30
 Dec 2025 12:56:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 12:56:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230205641.4092235-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend KVM's restriction on CPUID and feature MSR changes to disallow
updates while L2 is active in addition to rejecting updates after the vCPU
has run at least once.  Like post-run vCPU model updates, attempting to
react to model changes while L2 is active is practically infeasible, e.g.
KVM would need to do _something_ in response to impossible situations where
userspace has a removed a feature that was consumed as parted of nested
VM-Enter.

In practice, disallowing vCPU model changes while L2 is active is largely
uninteresting, as the only way for L2 to be active without the vCPU having
run at least once is if userspace stuffed state via KVM_SET_NESTED_STATE.
And because KVM_SET_NESTED_STATE can't put the vCPU into L2 without
userspace first defining the vCPU model, e.g. to enable SVM/VMX, modifying
the vCPU model while L2 is active would require deliberately setting the
vCPU model, then loading nested state, and then changing the model.  I.e.
no sane VMM should run afoul of the new restriction, and any VMM that does
encounter problems has likely been running a broken setup for a long time.

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 19 +++++++++++--------
 arch/x86/kvm/mmu/mmu.c |  6 +-----
 arch/x86/kvm/pmu.c     |  2 +-
 arch/x86/kvm/x86.c     | 13 +++++++------
 arch/x86/kvm/x86.h     |  4 ++--
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..f37331ad3ad8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -534,17 +534,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	BUILD_BUG_ON(sizeof(vcpu_caps) != sizeof(vcpu->arch.cpu_caps));
 
 	/*
-	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
-	 * the core vCPU model on the fly. It would've been better to forbid any
-	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
-	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN or
+	 * while L2 is active, as MAXPHYADDR, GBPAGES support, AMD reserved bit
+	 * behavior, etc. aren't tracked in kvm_mmu_page_role, and L2 state
+	 * can't be adjusted (without breaking L2 in some way).  As a result,
+	 * KVM may reuse SPs/SPTEs and/or run L2 with bad/misconfigured state.
+	 *
+	 * In practice, no sane VMM mucks with the core vCPU model on the fly.
+	 * It would've been better to forbid any KVM_SET_CPUID{,2} calls after
+	 * KVM_RUN or KVM_SET_NESTED_STATE altogether, but unfortunately some
+	 * VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
-	if (kvm_vcpu_has_run(vcpu)) {
+	if (!kvm_can_set_cpuid_and_feature_msrs(vcpu)) {
 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
 		if (r)
 			goto err;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02c450686b4a..f17324546900 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6031,11 +6031,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
 	kvm_mmu_reset_context(vcpu);
 
-	/*
-	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
-	 * kvm_arch_vcpu_ioctl().
-	 */
-	KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm);
+	KVM_BUG_ON(!kvm_can_set_cpuid_and_feature_msrs(vcpu), vcpu->kvm);
 }
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 487ad19a236e..ff20b4102173 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -853,7 +853,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
+	if (KVM_BUG_ON(!kvm_can_set_cpuid_and_feature_msrs(vcpu), vcpu->kvm))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..211d8c24a4b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2314,13 +2314,14 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	u64 val;
 
 	/*
-	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
-	 * not support modifying the guest vCPU model on the fly, e.g. changing
-	 * the nVMX capabilities while L2 is running is nonsensical.  Allow
-	 * writes of the same value, e.g. to allow userspace to blindly stuff
-	 * all MSRs when emulating RESET.
+	 * Reject writes to immutable feature MSRs if the vCPU model is frozen,
+	 * as KVM doesn't support modifying the guest vCPU model on the fly,
+	 * e.g. changing the VMX capabilities MSRs while L2 is active is
+	 * nonsensical.  Allow writes of the same value, e.g. so that userspace
+	 * can blindly stuff all MSRs when emulating RESET.
 	 */
-	if (kvm_vcpu_has_run(vcpu) && kvm_is_immutable_feature_msr(index) &&
+	if (!kvm_can_set_cpuid_and_feature_msrs(vcpu) &&
+	    kvm_is_immutable_feature_msr(index) &&
 	    (do_get_msr(vcpu, index, &val) || *data != val))
 		return -EINVAL;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..9084e0dfa15c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -172,9 +172,9 @@ static inline void kvm_nested_vmexit_handle_ibrs(struct kvm_vcpu *vcpu)
 		indirect_branch_prediction_barrier();
 }
 
-static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
+static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.last_vmentry_cpu != -1;
+	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
 }
 
 static inline void kvm_set_mp_state(struct kvm_vcpu *vcpu, int mp_state)

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.351.gbe84eed79e-goog


