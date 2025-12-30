Return-Path: <kvm+bounces-66858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DE7CEAAF4
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0CE163009F4E
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DD43002B9;
	Tue, 30 Dec 2025 21:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TdMM4Mkm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0EF2F2607
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129234; cv=none; b=jHdegKHDOeC/tfRLfyJqv1rKIjK5MWBYWaUTO2lNwIYFMnSWoz+HrzmcjyWZWZtZQqoTfwEHjVXZrN9+UkA37toX79z4SXQXWutI5e56uUazJUdRZNS15RdSxZeWpZOD9tMIlayU2oucPwFHh6iEI2jaDqJ19Lw+LNuhk1ceui8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129234; c=relaxed/simple;
	bh=C0RT9xfmtmFEbcE2vwzv7EC+1IXAWAUmiIkyGSmxhK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V7eBGqwrOuJefm8sGap4a3sv60+80XNDD8NKcxgbpq0tO9+sFFcobFrN/HMro5voq0YvOMVKEF9yUmf72Dol58lxpAcwWe+mygkw81qqQRWqs52MItw9lylwMpmzM/gs72Z1X6a+bSmJkvnnpMZdJ3v6N4AZvoGkX4f+TksYkio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TdMM4Mkm; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso29245099a91.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129232; x=1767734032; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7wqozHQILfBR+7AGDrYzCeWuem5verec2J4wlm1ug8s=;
        b=TdMM4Mkm4X25WU9tn63WPYvV4ZpEzUTXJsuXTt444BEiDSxoTbLDhOIoqRBNVSLyvV
         SaY7KeOVSMNNdOTWxzZyBjkBjGRdebZayxpxc1X72IA5bIpZqQrsMsFYcxcAprxnETZ0
         6Jzpn84V3c8U0E0cTwoQxIg95ApOUVpaVk2q4DUE+WS+71BC69hIvRoRKqBiJ+vigNfN
         pZxN5qxhdRf666+LJLteKLqumQnEQFECOTG1YO4eXA5uzpo4/vHeFx6i1WHQovmVRoYK
         6a/7FZ+nQqNHOtAqlGl5G2RUgfwRIErSmN3gLy+Vouii9DvDrprcovaKVzntWkKuoM8I
         9Oww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129232; x=1767734032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7wqozHQILfBR+7AGDrYzCeWuem5verec2J4wlm1ug8s=;
        b=gQB20vON4CbVaq44Brsy59UrdmVaxkRCySe3ifFKvUzzcXzEUNjok2e8CQH4YyUqZP
         I7kCWiybwMjAp82I/vS7W1w//AuJOB4XBIEhlpyo5v+3bhsLeHVYsFY+Fi1kxETxQgOK
         w+i5Y5AFUhjmj5AKTelwMFiJahu+3dpWvF4+6Lq7GPJJG0uIEAbpm181Xyd6bEPYjmds
         vxGHwub3jkwXuZvltQIpFik1ShxWF1sYiBRp+kSss2AyURS0NTHAxR7EV6N4gR6flmDW
         ID3VvgMdC8ir+eL1tKfMpozU2vlXJ69Gp7jzPJymDHIoJ7g6N4LznKhZK10mrq173XOF
         rR2A==
X-Gm-Message-State: AOJu0YxAq4YHFI0fxRQ4Mz/aI39UJQdrfaFL6Y0zU25ZOFyYsTRDLgrA
	07/DxR6cIoGEugSUjzUofFFuwAdxnnvUQ6AxULA5ZdA2+mjMO/jKNXLYpqnVYRPqjnCVHjZpD3d
	I7DrOlA==
X-Google-Smtp-Source: AGHT+IFFJm+456D6lf8JwJ1xaSWe0/SdbTVKGZR7AlvWe/wQ/+5VUBL7ZmZTigDPzAcFVXg81Hi1qQTBfRc=
X-Received: from pjee13.prod.google.com ([2002:a17:90b:578d:b0:34a:c87f:a95a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c46:b0:347:5ddd:b2d1
 with SMTP id 98e67ed59e1d1-34e921ccb5cmr30678426a91.27.1767129232376; Tue, 30
 Dec 2025 13:13:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 13:13:40 -0800
In-Reply-To: <20251230211347.4099600-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230211347.4099600-2-seanjc@google.com>
Subject: [PATCH v2 1/8] KVM: SVM: Add a helper to detect VMRUN failures
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a helper to detect VMRUN failures so that KVM can guard against its
own long-standing bug, where KVM neglects to set exitcode[63:32] when
synthesizing a nested VMFAIL_INVALID VM-Exit.  This will allow fixing
KVM's mess of treating exitcode as two separate 32-bit values without
breaking KVM-on-KVM when running on an older, unfixed KVM.

Cc: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++---------
 arch/x86/kvm/svm/svm.c    |  4 ++--
 arch/x86/kvm/svm/svm.h    |  5 +++++
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372..f5bde972a2b1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1134,7 +1134,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
 	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
 
-	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
+	if (!svm_is_vmrun_failure(vmcb12->control.exit_code))
 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
@@ -1425,6 +1425,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	u32 exit_code = svm->vmcb->control.exit_code;
 	int vmexit = NESTED_EXIT_HOST;
 
+	if (svm_is_vmrun_failure(exit_code))
+		return NESTED_EXIT_DONE;
+
 	switch (exit_code) {
 	case SVM_EXIT_MSR:
 		vmexit = nested_svm_exit_handled_msr(svm);
@@ -1432,7 +1435,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 	case SVM_EXIT_IOIO:
 		vmexit = nested_svm_intercept_ioio(svm);
 		break;
-	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
+	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f:
 		/*
 		 * Host-intercepted exceptions have been checked already in
 		 * nested_svm_exit_special.  There is nothing to do here,
@@ -1440,15 +1443,10 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		 */
 		vmexit = NESTED_EXIT_DONE;
 		break;
-	}
-	case SVM_EXIT_ERR: {
-		vmexit = NESTED_EXIT_DONE;
-		break;
-	}
-	default: {
+	default:
 		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
 			vmexit = NESTED_EXIT_DONE;
-	}
+		break;
 	}
 
 	return vmexit;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d..c2ddf2e0aa1a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3540,7 +3540,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			return 1;
 	}
 
-	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
+	if (svm_is_vmrun_failure(svm->vmcb->control.exit_code)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
@@ -4311,7 +4311,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
-		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
+		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
                         ++vcpu->stat.nested_run;
 
 		svm->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d07..0f006793f973 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -424,6 +424,11 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_svm, vcpu);
 }
 
+static inline bool svm_is_vmrun_failure(u64 exit_code)
+{
+	return (u32)exit_code == (u32)SVM_EXIT_ERR;
+}
+
 /*
  * Only the PDPTRs are loaded on demand into the shadow MMU.  All other
  * fields are synchronized on VM-Exit, because accessing the VMCB is cheap.
-- 
2.52.0.351.gbe84eed79e-goog


