Return-Path: <kvm+bounces-36954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F24A23877
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 02:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 977A07A3584
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 01:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CD018E20;
	Fri, 31 Jan 2025 01:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TLbjc7d8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320184409
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 01:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738285566; cv=none; b=gxM/hoBTXsMW6ZE2KnkLZkAPMLPidCCDN/WPJ0UsLlx0F8a5R5Nz7mvCogn4DQ4OLuf0YrAik41t0zB4Zox/OSXJDCgkB0GtE9wRJD85T1ARr50abejTmOtNxRGzKHX181mk+VR4qD2/V1Duldm7+n33yBYD+8Cj9F2oh/PsHL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738285566; c=relaxed/simple;
	bh=9jf/1nf6tAlLaTCV6LJ7jR9g3FGayPJbCfATcf783SU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rpEpZfXvDrBNlPXAP2jfaVKitalMCe8/+Cnr+paYsn3lraQDYLPnyo4B2kdUnyEzCa+3LyaAImvmCuYKiySSqZnI1hsin99hT7TAS7DC5nNGMJ6BKdHgtUe7Jy6hMCEP5P5XEP/wfRDSITKtg6E+Qxl9okCPLp6Yxv+8PWWGOd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TLbjc7d8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-218cf85639eso42767715ad.3
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 17:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738285564; x=1738890364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bTNYs099yFFyqnxNpuPISqHSrCDzZ6WUqK+9MhF5wbs=;
        b=TLbjc7d87TeLS6RlN3HkAbeLlWBHyd0sIYW+HXVWqZDMeUxmHMbKiAkDT2OWtCZyXz
         YFV/me68MZM5JkmpaedwWVDhDtASP+o6U1kTQEJn/1exclJmC5G0y7AigX5h7qchv1kp
         RSFiy7fSldiH18zbkRxXdHQWWYiJkFriTuySUcFrHP1bd87PvVKD4QYMn0BR0U2Ykse6
         pPO/mtEOK+yaGdzUbsy4igm8GtakIRaGXX8ivc0w1sJTW6R+PPN0HKQKJ+KIfFgf6JKu
         na2C9ahYfV4rEcPBb3sFeacy5KnKKJ45BVUL7Q9b8E+B2pdku6PzvNY1Ks1e5WQ9jOdY
         +WWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738285564; x=1738890364;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTNYs099yFFyqnxNpuPISqHSrCDzZ6WUqK+9MhF5wbs=;
        b=nMYRp8J1/Dxzvd1cORTm/et/HoLBr7PQdt0tRFZ82Ov4F52wXNjUho04CZfYh3zJnE
         mWWVQnDSXAxq1jin39Gsf8ebbBb3zBNoQQZ7m9PNKl7lCnjIsttfXa2QfRYLa3zuDyTM
         Ft53rg8aegGYZp+ymIEjBD50+O95yZRbyXMzLl1vYtqXFsndGMStG3R+qMzIX93CODdT
         GGUh2/Vifc7IZxDTNaRIceYZNKjPbYhC7QeGWivpemjt5orbUEH9kF5YZUFowZ4bm7xL
         iOc1TzOgLsYfVXKH/45FhX/dD52vSZ0sbsuj+l7cO5JJwGD73B+4HJpZbIzFHZ2VFzwW
         UCqw==
X-Gm-Message-State: AOJu0Yz3rBc3R8VTVqEC6CM0iZm73DpYj7y3jsStADch5lsFEeSJLJzz
	1JWOeeFkHViMbR3ZkGdxp6D+w6mPrUBWt8h78d/IBFp3LzVufCa91lK63dslwTlBgFy/YagiFD9
	bQQ==
X-Google-Smtp-Source: AGHT+IGxiC3tKYAQHqYSiS3fnl5uGLVJ5CIUzG+4EgbzBj0T2X1p5kopc3CLdqk/XuszZgPILyjkbC2F5Vo=
X-Received: from pgbcr6.prod.google.com ([2002:a05:6a02:4106:b0:7fd:5164:d918])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f8f:b0:1eb:34a6:593e
 with SMTP id adf61e73a8af0-1ed7a5c4575mr14718423637.1.1738285564440; Thu, 30
 Jan 2025 17:06:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jan 2025 17:06:01 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250131010601.469904-1-seanjc@google.com>
Subject: [PATCH] KVM: nSVM: Never use L0's PAUSE loop exiting while L2 is running
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Never use L0's (KVM's) PAUSE loop exiting controls while L2 is running,
and instead always configure vmcb02 according to L1's exact capabilities
and desires.

The purpose of intercepting PAUSE after N attempts is to detect when the
vCPU may be stuck waiting on a lock, so that KVM can schedule in a
different vCPU that may be holding said lock.  Barring a very interesting
setup, L1 and L2 do not share locks, and it's extremely unlikely that an
L1 vCPU would hold a spinlock while running L2.  I.e. having a vCPU
executing in L1 yield to a vCPU running in L2 will not allow the L1 vCPU
to make forward progress, and vice versa.

While teaching KVM's "on spin" logic to only yield to other vCPUs in L2 is
doable, in all likelihood it would do more harm than good for most setups.
KVM has limited visibility into which L2 "vCPUs" belong to the same VM,
and thus share a locking domain.  And even if L2 vCPUs are in the same
VM, KVM has no visilibity into L2 vCPU's that are scheduled out by the
L1 hypervisor.

Furthermore, KVM doesn't actually steal PAUSE exits from L1. If L1 is
intercepting PAUSE, KVM will route PAUSE exits to L1, not L0, as
nested_svm_intercept() gives priority to the vmcb12 intercept.  As such,
overriding the count/threshold fields in vmcb02 with vmcb01's values is
nonsensical, as doing so clobbers all the training/learning that has been
done in L1.

Even worse, if L1 is not intercepting PAUSE, i.e. KVM is handling PAUSE
exits, then KVM will adjust the PLE knobs based on L2 behavior, which could
very well be detrimental to L1, e.g. due to essentially poisoning L1 PLE
training with bad data.

And copying the count from vmcb02 to vmcb01 on a nested VM-Exit makes even
less sense, because again, the purpose of PLE is to detect spinning vCPUs.
Whether or not a vCPU is spinning in L2 at the time of a nested VM-Exit
has no relevance as to the behavior of the vCPU when it executes in L1.

The only scenarios where any of this actually works is if at least one
of KVM or L1 is NOT intercepting PAUSE for the guest.  Per the original
changelog, those were the only scenarios considered to be supported.
Disabling KVM's use of PLE makes it so the VM is always in a "supported"
mode.

Last, but certainly not least, using KVM's count/threshold instead of the
values provided by L1 is a blatant violation of the SVM architecture.

Fixes: 74fd41ed16fd ("KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 44 +++++++++++++--------------------------
 arch/x86/kvm/svm/svm.c    |  6 ------
 2 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d77b094d9a4d..9330c15de6b7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -171,6 +171,16 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	if (!intercept_smi)
 		vmcb_clr_intercept(c, INTERCEPT_SMI);
 
+	/*
+	 * Intercept PAUSE if and only if L1 wants to.  KVM intercepts PAUSE so
+	 * that a vCPU that may be spinning waiting for a lock can be scheduled
+	 * out in favor of the vCPU that holds said lock.  KVM doesn't support
+	 * yielding across L2 vCPUs, as KVM has limited visilibity into which
+	 * L2 vCPUs are in the same L2 VM, i.e. may be contending for locks.
+	 */
+	if (!vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE))
+		vmcb_clr_intercept(c, INTERCEPT_PAUSE);
+
 	if (nested_vmcb_needs_vls_intercept(svm)) {
 		/*
 		 * If the virtual VMLOAD/VMSAVE is not enabled for the L2,
@@ -643,8 +653,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	u32 pause_count12;
-	u32 pause_thresh12;
 
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
@@ -736,31 +744,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
-		pause_count12 = svm->nested.ctl.pause_filter_count;
+		vmcb02->control.pause_filter_count = svm->nested.ctl.pause_filter_count;
 	else
-		pause_count12 = 0;
+		vmcb02->control.pause_filter_count = 0;
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PFTHRESHOLD))
-		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
+		vmcb02->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
 	else
-		pause_thresh12 = 0;
-	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
-		/* use guest values since host doesn't intercept PAUSE */
-		vmcb02->control.pause_filter_count = pause_count12;
-		vmcb02->control.pause_filter_thresh = pause_thresh12;
-
-	} else {
-		/* start from host values otherwise */
-		vmcb02->control.pause_filter_count = vmcb01->control.pause_filter_count;
-		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
-
-		/* ... but ensure filtering is disabled if so requested.  */
-		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
-			if (!pause_count12)
-				vmcb02->control.pause_filter_count = 0;
-			if (!pause_thresh12)
-				vmcb02->control.pause_filter_thresh = 0;
-		}
-	}
+		vmcb02->control.pause_filter_thresh = 0;
 
 	nested_svm_transition_tlb_flush(vcpu);
 
@@ -1033,12 +1023,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
-	if (!kvm_pause_in_guest(vcpu->kvm)) {
-		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
-		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
-
-	}
-
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..ad5accc29db8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1079,9 +1079,6 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm))
-		return;
-
 	control->pause_filter_count = __grow_ple_window(old,
 							pause_filter_count,
 							pause_filter_count_grow,
@@ -1100,9 +1097,6 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm))
-		return;
-
 	control->pause_filter_count =
 				__shrink_ple_window(old,
 						    pause_filter_count,

base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1.362.g079036d154-goog


