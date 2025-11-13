Return-Path: <kvm+bounces-63066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA90FC5A6D1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2510F4E9678
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71614328630;
	Thu, 13 Nov 2025 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lUNlLu+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCAC328259
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074595; cv=none; b=N1fXNqHNJQdS5Y4JuYXB9O8CZkmJdDBQX25bWuYhzXmCC6mZBByMcKuVZuiSoJx4DQjBtBtmPSnBfL3/2AcMZUZG2Am5T96y/40+V5lxWWR+/WpbuZprhEvPkcyK44dHTmoW0h9eZj7ey4jUyDman42gG9JZVlsOg8RSu5i2nLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074595; c=relaxed/simple;
	bh=nXwgs7YC0LiuNXWTz4iE60qbMFkvolkxQM+YKYIzQlw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lBgaXEIq+sa5/YHK0dTNoW+KleXksDS7v6/z8946vrEDi8F7LrhDVR0eA+oSqFuX82Ii6YqldnGVwiBPn+FY2neRSmHBZYcXk3zg9aDDPwa1OQxygxuItvLSCf3zHGVtdhykEa8RutcKhSIIWx0/esAEsjiQcdXdGYc+zBWDPR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lUNlLu+h; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2958c80fcabso35481015ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074593; x=1763679393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CFaed3xQWUAcBYMaUt6HihcqYzlaPmtpnemkzp18gZ0=;
        b=lUNlLu+hdRYCoZVZgS+G68cGmrUfG3ekWuUASrTRmSz5nhTWb28ZDb9MPdpjsanXaT
         TalNYmfp0EuZgetElPxQd+mlRwoyTLTPFGaZ0Zol01lLxlQvfmBG8et5VPa64X5Ut1Lf
         tJehIA4Q5ThxdrhTSIcg42+aLlhRbgG4UHP9t4+s4IvBabqw0qunrXVGhyQilNjCcDfq
         o/TLj/Jqz+mc5T0RQo+hKrvqxGk1QIHdOp6rsa5W8cD9Ada6DqRK7OWFToejRStt48w/
         9ZkL7RkxrszZGqYG1cdduK4sjI+7vqt1eNh4AWAi9lFZ+ZQRGpzOC7eBUGUjUxcKsd8K
         Yv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074593; x=1763679393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CFaed3xQWUAcBYMaUt6HihcqYzlaPmtpnemkzp18gZ0=;
        b=Gkt7xNrLyjZf76lvTq2cg5NZt2HwJjX+/axV+tX++/aF46wWKOwbBHxYui+art3PYO
         MF6cz6SZdSuuSAysvbUNlRDUarx/3emvLDB80rHduXUY5B/nrLIcljgeC5YhphKKnjvs
         q6ErxJJM+dbiCSdf/O6ijh4aQm+jCrFmRxuvIvfCHW4o9ats6mHbLwNdUfDWvJXTbGpy
         4sXMDwDa6le0vZ3vl92OXKUhrddXcFuOEaG/YMWG5kl24C6o2BOglnPxIdwvXufeHl90
         CQ4sF4NnE8nO8FffWBKSuU+gAuJTYkVmzDFWi00XsWtlp5k/stb8KQrraF1oE5x+XyqN
         qDKA==
X-Gm-Message-State: AOJu0YxBrleP+FpYqtQcmxDjTT12Vey6XZZH+KLU2CndQc6crqMgyTcp
	E62vfE25oLK6AVB2NK5CJpkmIjYcLXdfBD0XHpxdxsRoUNISp/4uz+oEyjyWuQoXax0r1SfVYG2
	ZOcmmug==
X-Google-Smtp-Source: AGHT+IEcrzaNJQufxlW40Sp3VWWox0Ok4kOufZZG1NpP6gqSUezvSr1DIEaBEs4ZT20+btmiUcbM2j0csjE=
X-Received: from plpn11.prod.google.com ([2002:a17:902:968b:b0:297:eb04:dff7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e80a:b0:295:8662:6a4e
 with SMTP id d9443c01a7336-2986a75739dmr6698255ad.47.1763074593310; Thu, 13
 Nov 2025 14:56:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:15 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: SVM: Add a helper to detect VMRUN failures
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
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
index ba0f11c68372..8070e20ed5a7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1134,7 +1134,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
 	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
 
-	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
+	if (svm_is_vmrun_failure(vmcb12->control.exit_code))
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
index 7ea034ee6b6c..52b759408853 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3530,7 +3530,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			return 1;
 	}
 
-	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
+	if (svm_is_vmrun_failure(svm->vmcb->control.exit_code)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
 			= svm->vmcb->control.exit_code;
@@ -4302,7 +4302,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
-		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
+		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
                         ++vcpu->stat.nested_run;
 
 		svm->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 253a8dca412c..6b35925e3a33 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -426,6 +426,11 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
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
2.52.0.rc1.455.g30608eb744-goog


