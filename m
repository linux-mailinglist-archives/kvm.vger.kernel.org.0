Return-Path: <kvm+bounces-32665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEDB9DB0DF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1152E1620D6
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9AB215D5B7;
	Thu, 28 Nov 2024 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="twr2Tlwz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB93154445
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757698; cv=none; b=fIpDFKjIX7gi0zoiQuMtlM8l8KEsbknZaD9nwCe3gEqV7NQv/1EaDHBgvI3mAB86mnJzZIsxXu4RYp4TTVs7D83sUNTOuuF2QXZmSLRK0qtX0bkELBYbgeBFDp2EyaI+TpjTgigLhI2FHnmEGNYUx4Ziqy876hnmH3Y+G6kp6dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757698; c=relaxed/simple;
	bh=7zC5azkES26WfDq3Whxv3so2ietZ4rGRL4pkkJDTXTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FuEwgUw6k+x6BS163JjO7Rs+o/cKOKNaYulPNe1TMti/Anf65low4kPVmNFJ6eY5HlsVrsb199mPq7s84lnSr6BsD2Y7Hwndp+c1r5edNNAaoXWGZCLOcbsQzoKRpZzR5C6l5iJa06Fbr2YaAVChB60E3TLwAKDdorrs7sZNkvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=twr2Tlwz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea5bf5354fso352198a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757697; x=1733362497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/roR1Tq2E8S3SFqc2nnkeKb7VjdwQvlBDUindkJvlFg=;
        b=twr2Tlwzb7VcawOW2OvLME1sgRnCJIMCqhNgCNQO2AnHaq5HyUDA7cKVbLUD4GPApo
         3b79h1zdAlu610uNrEnrP7mQNd7f3Po8sUm1mtbAadg46M7nCI5NkU7C/C3W2O4dQb9r
         yFQP/ix8p02n4P71TxsWumFfm7fel5yxQyJ0Joei8lPcsb+sVG9Iz4d8CYk1qQaCBP3s
         c1qg2weRw3Y2f2ChcKCbhMkycLcaWQCpgeB6ZsXN4JhZFPmwPJCbEgiGCcUyJDvoOENn
         HbBIbWYjX3mxAkOldMje7imUDl3O4/QsCJ+tNT2ruVFFSOdsULJf5IqVSo2Ix1RDxuWZ
         zu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757697; x=1733362497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/roR1Tq2E8S3SFqc2nnkeKb7VjdwQvlBDUindkJvlFg=;
        b=wxG8tZiBXW8wD8WMWyqiZ33yr9UcVLeotcEjFhB7Iz0W0sVIvVgmDrWZnkVLt1E10o
         dy24NVUaAiByeEc5t04JyzReI7egywoMftl3GaQ/yyGfLj7G/Xrt/ebtH/YVEMkhywsC
         W5tKgZuTVsJU/BvrcrUq/97kuAkxZ6DeLqQ3WkPIA0kOUjd1SfBrplUO9CS4P4DChphg
         RiQa9gEzIeK94OlaQDkCbJcoKyuJBwtkYSUkfdre2GP72HQ9mXViPZV8KVFShiXAZVSt
         EJdOG5Q+TPpWTKhSHgzNXv1mPjvmdPIIVvUd6v38EVhRBH0s6iBnAm3wYVlo/iqPfBmy
         QFlw==
X-Gm-Message-State: AOJu0YwUZfUAa9ijuW/NCKkmMVzrPyZXJZR986UsR9JfCYaQ7A/q5F/G
	6Iovrbv81diqnH+Qw6ZFxmpNT6E56cUbA4iEsFFbquO3GN3kWpRNbvp9+N0TUCjAt053bJt4QI9
	tmQ==
X-Google-Smtp-Source: AGHT+IF6wH28m3FYKRZIpAFfWy3k4UMceR/PxneksITg/V4r6c3bKfb6SNvvACyGYnuBjppIhRKxes+QUjM=
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:2e9:2437:ab4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d10:b0:2ea:aa56:4b0
 with SMTP id 98e67ed59e1d1-2ee08e99941mr6405613a91.3.1732757696965; Wed, 27
 Nov 2024 17:34:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:41 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-15-seanjc@google.com>
Subject: [PATCH v3 14/57] KVM: x86: Reject disabling of MWAIT/HLT interception
 when not allowed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT or
HLT exits and KVM previously reported (via KVM_CHECK_EXTENSION) that
disabling the exit(s) is not allowed.  E.g. because MWAIT isn't supported
or the CPU doesn't have an always-running APIC timer, or because KVM is
configured to mitigate cross-thread vulnerabilities.

Cc: Kechen Lu <kechenl@nvidia.com>
Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
Fixes: 6f0f2d5ef895 ("KVM: x86: Mitigate the cross-thread return address predictions bug")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 54 ++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c517d26f2c5b..9b7f8047f896 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4531,6 +4531,20 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static u64 kvm_get_allowed_disable_exits(void)
+{
+	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
+
+	if (!mitigate_smt_rsb) {
+		r |= KVM_X86_DISABLE_EXITS_HLT |
+			KVM_X86_DISABLE_EXITS_CSTATE;
+
+		if (kvm_can_mwait_in_guest())
+			r |= KVM_X86_DISABLE_EXITS_MWAIT;
+	}
+	return r;
+}
+
 #ifdef CONFIG_KVM_HYPERV
 static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 					    struct kvm_cpuid2 __user *cpuid_arg)
@@ -4673,15 +4687,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-		r = KVM_X86_DISABLE_EXITS_PAUSE;
-
-		if (!mitigate_smt_rsb) {
-			r |= KVM_X86_DISABLE_EXITS_HLT |
-			     KVM_X86_DISABLE_EXITS_CSTATE;
-
-			if (kvm_can_mwait_in_guest())
-				r |= KVM_X86_DISABLE_EXITS_MWAIT;
-		}
+		r = kvm_get_allowed_disable_exits();
 		break;
 	case KVM_CAP_X86_SMM:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
@@ -6528,33 +6534,29 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
 			break;
 
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			goto disable_exits_unlock;
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-
 #define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
 		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."
 
-		if (!mitigate_smt_rsb) {
-			if (boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible() &&
-			    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
-				pr_warn_once(SMT_RSB_MSG);
-
-			if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
-			    kvm_can_mwait_in_guest())
-				kvm->arch.mwait_in_guest = true;
-			if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-				kvm->arch.hlt_in_guest = true;
-			if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-				kvm->arch.cstate_in_guest = true;
-		}
+		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
+		    cpu_smt_possible() &&
+		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+			pr_warn_once(SMT_RSB_MSG);
 
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
+			kvm->arch.pause_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
+			kvm->arch.mwait_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
+			kvm->arch.hlt_in_guest = true;
+		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
+			kvm->arch.cstate_in_guest = true;
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
-- 
2.47.0.338.g60cca15819-goog


