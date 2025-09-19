Return-Path: <kvm+bounces-58236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6701CB8B811
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A13E07B7B61
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633B52E092B;
	Fri, 19 Sep 2025 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FskW+/5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C175E2DCC1C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321199; cv=none; b=SOMyPzv1lwjBErAikOLe7aULRG/5SIMhAjYr1ew+Jy5wWFhUkDJ7z6yxe/T5BtzgUIQgoNy7RHgJcniBpvaiBMOGm8UfDC53oJIxV5KusYwanpSv57EI/mh3KPm/jwGcRQ0QVrQICcOQx+O7zhNITEjbvi7iydCCglrZ/YQs3wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321199; c=relaxed/simple;
	bh=SUbk9rvQ5iSbOyrSbqe2IoTOG4vNnWYJ/8YngPPf7Nw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JBjWZr8zl7gIJtv4t30+tmhNcZ4OszVoyyHI6B2ei+koZW9Q7jRAJKPoJg806LjkbUCCpnl5Xi7I2Fsu+eHPTBA4dJ1cPqMKZ4zCsEywA/1j6S89BhfYdsO8xoAsHKqrnMnEh7tvvumkjN46ZpEAwnGy3g1Z6Nfw8kFOLp1RZ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FskW+/5M; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaeba9abaso3431543a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321197; x=1758925997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+JcaMt2ydOaiLW5D8ASKub/1/NSATOOQH1xnCAbO6Bg=;
        b=FskW+/5Mathq1U3ycsGVUUc5Pt1uD2k8V9Q3buttgrSsab1LkxU2D2Y1dd4iHeC6lu
         OTMcIVk//xsFndJqskC3DIo1LDU3s/vUo//aNGnoKCC4HFvFJDQvDABTAhgtn8j2dYeN
         jkXuDKKg1vtUCiV1Wk7yz7Vr5Z6QgUDOfGMpdrG0S1akrpfuuappuDoe/ZbSmnGRg3pN
         ARyYnHOmqD0hcRRigd0UosGeaV9mOnrRUOWfY68omfT2CHaPFqxRakxqjHCClLnF+Lc9
         e05QwdYakgRmLZpmZN2DTt0/IFE/4N3IlEHDFz21tSCddOiMJlQbKVzgDEF+2X7sp6cx
         XE0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321197; x=1758925997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+JcaMt2ydOaiLW5D8ASKub/1/NSATOOQH1xnCAbO6Bg=;
        b=jNU46uqnjW6H1d6lQU6WXtxyM6C/G5Pmf1rzfWW3wF/lz3rJdj2nW9aisVSHt3F7sa
         SNNTG+2lfK05sl+Qc8NnJmQMzCK2zthxnGjTvvEMf9GUuJivI6QQYfzObfdEzdrJG7Sf
         bAOrs+zOUSUncVXtCi6DePq3MSFh37z2l6VwBStlDCCNkf15Q6Ry86Dd9wCac2wwRscL
         /HoBoUHVkixnYLMobvNY1XWNlD7/mdkGnb5drY1QgThCUkRBpUG6psibr+fU6cJI0fRm
         fA1dwpAAB6iFLsAxqaKakA4Yhfn1rBNTesoXkvyQVtmlCWaMZ8LOG5K5My6CYZ7F79om
         qy3Q==
X-Gm-Message-State: AOJu0Yx4zKIqstoCRg62kLcZFiRZJS0/4jc0f5MzdCQtP4+zn0wEQxIh
	iPJMKDu5TBSSVyr9iQugS84Qyn+NJFs1TpsSz3kVcFHMPHoD7ZK1BzNiN6s0gkxVlqa0G8aVWR3
	36rfHFg==
X-Google-Smtp-Source: AGHT+IFcB1z7KUVsuS7swIC4I2jvCN0WHziOqZKe6uLi8biGmkCTogAah3rUQYFyuFlbCrcLz4kefzfXt5w=
X-Received: from pjp3.prod.google.com ([2002:a17:90b:55c3:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50:b0:32e:749d:fcb6
 with SMTP id 98e67ed59e1d1-33097ff646dmr6029665a91.12.1758321197100; Fri, 19
 Sep 2025 15:33:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:15 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-9-seanjc@google.com>
Subject: [PATCH v16 08/51] KVM: x86: Initialize kvm_caps.supported_xss
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
XSAVES is supported. host_xss contains the host supported xstate feature
bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
enabled XSS feature bits, the resulting value represents the supervisor
xstates that are available to guest and are backed by host FPU framework
for swapping {guest,host} XSAVE-managed registers/MSRs.

[sean: relocate and enhance comment about PT / XSS[8] ]

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c87ed216f72a..3e66d8c5000a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -217,6 +217,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+/*
+ * Note, KVM supports exposing PT to the guest, but does not support context
+ * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
+ * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
+ * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
+ */
+#define KVM_SUPPORTED_XSS     0
+
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
@@ -3986,11 +3994,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_XSS:
 		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return KVM_MSR_RET_UNSUPPORTED;
-		/*
-		 * KVM supports exposing PT to the guest, but does not support
-		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
-		 * XSAVES/XRSTORS to save/restore PT MSRs.
-		 */
+
 		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
 		if (vcpu->arch.ia32_xss == data)
@@ -9822,14 +9826,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
+		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
+	}
+
 	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
 	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
 
 	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
-
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-- 
2.51.0.470.ga7dc726c21-goog


