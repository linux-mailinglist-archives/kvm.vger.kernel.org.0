Return-Path: <kvm+bounces-65317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C41C1CA6530
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 08:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F5FC30D4C42
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 07:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1082F5480;
	Fri,  5 Dec 2025 07:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pcwlUhT1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3C83043CF
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764918409; cv=none; b=Ptjns/by3srw16deOuzJiwWCvsTlxdiTI7ywGrcMb1DkkWkbTEk62QoJij0EPB/Wks1V236iBi4Or+UVECU2UgOQarNXb5KSIj8OJqrwEWNSdC+0KeK34tzFjmPpe/OGpiCPlH38dluR1W0WxUQfLLtOI4JzEuN7W4Q6fvwXmdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764918409; c=relaxed/simple;
	bh=1VodqxX66j/oHx05KohO2S4L41rGfeM3B97rEK6FTYc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AlwntjOy1ihwT/C9Ph4khjiXN5DF5+mxLFgS/UCqR39swbB5PK+fbZ9bWJ1lC5VYxh6A/+U9PWkJ+Q8ZqVy63P5u2DkB30TcV2R3V60ZvIeQMTY2X6LPWCqLNYFKul3/kzsxf9Htl/1jmmJCiUBRq2EgU5t70RJxAnb5vfntE0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pcwlUhT1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e1cf9aedso37953515ad.2
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 23:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764918407; x=1765523207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g6oVxVc8vCqW4iAqdFU6WwmtDYljLhyo5is50SQz9nQ=;
        b=pcwlUhT1IhbThahnUu84dJ8Vw9zGie3B4ZfbCCPXPfUHniT7uHtbWO/AgQW4Ma4Gu/
         gtCbT86wtMS39T8eBqvv6h4GKqMXSDaLZMKZFtrRsaJ7ug+7zuuJq4cKJ+/FM8PGgFAY
         Op5x7Gmb1qMs3oFMWoGNO06bZxrAg3sgGVTb0MonRbtwbaEzHL3FcuFokxuIoidD4oYt
         AVfpVJ0QAUbcMCn0JooPT4Ke0BcXPCdDzE1QoQIHPOZzntAN4CVa+RSp8YH8Ezuez01B
         PDF0CMCjup/CpjCguTllSKqEF8oBqSvdks00bbKA51+mHzbJl/R3IQ5ZALqzuiwSsRkS
         nQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764918407; x=1765523207;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g6oVxVc8vCqW4iAqdFU6WwmtDYljLhyo5is50SQz9nQ=;
        b=H5sabQw43ROjFUISQk8c1U6cEMzHd/z+UrQih6JYQH7X8yaw91sPY0rGWEjJURQwfV
         qOLnirdvDEVcuYw85njSMnzaNL1Jm/0gjb2vSrpTAEnnl2/V3mMPplO7f2dZFxoZ4BKi
         6oVNcb/oIc+07pM8ez/qvm/DlMabm50oowYbo0ZQd0+pbLsa8OGBQyeuEoPUN7h1+wn3
         axf5UAW8ujsi1ks9o7M2xMgIyzJEcGCcPr5S9SEtYKaZugGbBiPDaxEqmwBCTAuZ2iPY
         gwHl73MneALOtLdAKupDyBZ0PtpOvGjxQJ62pcW2ZEi9ZxYjXlrdFN+q7rkWjthpopan
         In4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXBUg53ySEvmIDefT0Qvhrde/RBF+D2Z2n0iX7aSYb8DdUbuDUj+cK3DhHgj2r4WUZCVN8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC2VdnACzGdQPjYyBuNJbI1bZg9we2x+KD6q5g8ZpLHKu0WlRP
	9LVhrmR9rYV6zeAU/ZIyDFJbXTRn2ZMZ7Cr/qhnezgK+GNb2BmSOigd+sPgAwNu2l2y8vptm0eg
	La9LGf3IidHNTtA==
X-Google-Smtp-Source: AGHT+IFL8VQ7UVVkYaRlerlho/OtaOXmQnqXs9MtjrzOfOLkjU0Mc+WRCPbnvwiqQlPj+gGKW2eAEOdoFk/fGw==
X-Received: from pfoo16.prod.google.com ([2002:a05:6a00:1a10:b0:7b0:bc2e:9599])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:218f:b0:351:d6ff:dcf5 with SMTP id adf61e73a8af0-363f5e20251mr10743074637.34.1764918407018;
 Thu, 04 Dec 2025 23:06:47 -0800 (PST)
Date: Fri,  5 Dec 2025 07:06:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205070630.4013452-1-chengkev@google.com>
Subject: [PATCH] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: jmattson@google.com, yosry.ahmed@linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

If a feature is not advertised in the guest's CPUID, prevent L1 from
intercepting the unsupported instructions by clearing the corresponding
intercept in KVM's cached vmcb12.

When an L2 guest executes an instruction that is not advertised to L1,
we expect a #UD exception to be injected by L0. However, the nested svm
exit handler first checks if the instruction intercept is set in vmcb12,
and if so, synthesizes an exit from L2 to L1 instead of a #UD exception.
If a feature is not advertised, the L1 intercept should be ignored.

Calculate the nested intercept mask by checking all instructions that
can be intercepted and are controlled by a CPUID bit. Use this mask when
copying from the vmcb12 to KVM's cached vmcb12 to effectively ignore the
intercept on nested vm exit handling.

Another option is to handle ignoring the L1 intercepts in the nested vm
exit code path, but I've gone with modifying the cached vmcb12 to keep
it simpler.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/nested.c | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c    |  2 ++
 arch/x86/kvm/svm/svm.h    | 14 ++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c81005b245222..f2ade24908b39 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -184,6 +184,33 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	}
 }

+/*
+ * If a feature is not advertised to L1, set the mask bit for the corresponding
+ * vmcb12 intercept.
+ */
+void svm_recalc_nested_intercepts_mask(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	memset(svm->nested.nested_intercept_mask, 0,
+	       sizeof(svm->nested.nested_intercept_mask));
+
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP))
+		set_nested_intercept_mask(&svm->nested, INTERCEPT_RDTSCP);
+
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SKINIT))
+		set_nested_intercept_mask(&svm->nested, INTERCEPT_SKINIT);
+
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
+		set_nested_intercept_mask(&svm->nested, INTERCEPT_XSETBV);
+
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RDPRU))
+		set_nested_intercept_mask(&svm->nested, INTERCEPT_RDPRU);
+
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID))
+		set_nested_intercept_mask(&svm->nested, INTERCEPT_INVPCID);
+}
+
 /*
  * This array (and its actual size) holds the set of offsets (indexing by chunk
  * size) to process when merging vmcb12's MSRPM with vmcb01's MSRPM.  Note, the
@@ -408,10 +435,11 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *to,
 					 struct vmcb_control_area *from)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned int i;

 	for (i = 0; i < MAX_INTERCEPT; i++)
-		to->intercepts[i] = from->intercepts[i];
+		to->intercepts[i] = from->intercepts[i] & ~(svm->nested.nested_intercept_mask[i]);

 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f56c2d895011c..dd02a076077d8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1011,6 +1011,8 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
+
+	svm_recalc_nested_intercepts_mask(vcpu);
 }

 static void svm_recalc_intercepts(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9e151dbdef25d..08779d78c0c27 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -217,6 +217,12 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	/*
+	 * Reserved bitmask for instruction intercepts that should not be set
+	 * by L1 if the feature is not advertised to L1 in guest CPUID.
+	 */
+	u32 nested_intercept_mask[MAX_INTERCEPT];
 };

 struct vcpu_sev_es_state {
@@ -478,6 +484,12 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	recalc_intercepts(svm);
 }

+static inline void set_nested_intercept_mask(struct svm_nested_state *nested, u32 bit)
+{
+	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
+	__set_bit(bit, (unsigned long *)&nested->nested_intercept_mask);
+}
+
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -746,6 +758,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }

+void svm_recalc_nested_intercepts_mask(struct kvm_vcpu *vcpu);
+
 int __init nested_svm_init_msrpm_merge_offsets(void);

 int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
--
2.52.0.223.gf5cc29aaa4-goog


