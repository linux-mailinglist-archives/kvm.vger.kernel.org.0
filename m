Return-Path: <kvm+bounces-17675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2338C8B77
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC57C1F28B47
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA421150999;
	Fri, 17 May 2024 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ix1DwjJO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C839014F119
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967630; cv=none; b=a/q35qboMLDxUTMpu3OzYLK36S1ALSZfVFj34dM3/KO6ZwyTfn8zWlGoJzJx8bU2WoL5PanrW2dNtqQzvZShb8w9qw1df4q+PdrCo/QbPgsi0bC9kmegIzpvp1/nC1SRAZS/OKeQxGb91H3QkXucroCRJpEHDcOeZwlkrFCHW/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967630; c=relaxed/simple;
	bh=wWIigWH75I8A7NtCSPNqBEenhjFRXun0UIOqrvSwPfo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rCGZqEtoM6DAuo2Vi9p62Lp2IiLTaw/vBI7UBntMCM+bB23hCIcxsCOryVyvlogsfXsb33mIOn6/+js0tbRVPS0OYuzAuLQRyyF+5u574SXSdDKeQFmIHwffwuKYCrloeiqGjgWzdlI+/YRP33eMFCLfGL5Zca47SC5sc/gLbrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ix1DwjJO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be325413eso116838227b3.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967628; x=1716572428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yZo8Omcfrrzpm7znpVQTWfAM28fGARZSq2t82c2wUfM=;
        b=Ix1DwjJOp/AOI+3ytVL36QXRf46yHUtn0svCUVFLNH0pI7kAYHi/zCsmVDf5HexpeB
         PvQizOruYskb/un9e4enmM1+b0D0iV99Ru27GyhKj8+fQPZK9ifX9YdfrMgusLFnP63o
         pcCSxkFaUin6H4HFLK+Uudu9SUXkdA1MJt2QLyCTjH7yC+tQ/tfJYT/PyrjaDmCz2yh1
         nBzei4oE4UkCdiyt1cdyxSrT5FBVsZ0/oyrVwzYjZFlrBD2x02CPmkcGwIV9AxG838Zh
         jetWlKrgW1WPSLRKnh3SpnJQHqlbEy+HIHpJsUP8gWHwBVXHxE0sbOhaQozS9ryRuq8h
         MP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967628; x=1716572428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZo8Omcfrrzpm7znpVQTWfAM28fGARZSq2t82c2wUfM=;
        b=VsRmIn2wIIc5ijjC2JLASnEW9YHPROoZgCKtzEulZWOAemsqqib2AGmup+yU7t99fI
         N4uPUT2HEUGgZ1DQrd9+VImv1PJBuWbhNtRbkWTD46dWVthGlhjPpvRa5MmPXaNbIxh2
         aAU+fhPtoJ4xPNvm0Q10AXjJRt1vUvNrcSt2izbV6EIwmfPgLIcQmDg9bvO7wLAA6SyI
         muFk8no5SbljZXyZ2RCBWUTpk83AENT1sEcpVWLS3vKFtnwpId6f7eeompTv093XcmZk
         lLyd+Uj8R7fw/PADq8iwhiLlLJEb3h5gdC0TQmltxcsDBZI7/4NcAYndGRoGO8ryHU2F
         EO7w==
X-Gm-Message-State: AOJu0Yz0Ww46Seh56xv7JVyPhHDD2xZLqqt0UTtDztuLMAvWPuy6s8KG
	UEFMh1l3BaoC+X8LAqVHmgJ+wabpG+eAQJmYizp0c1iJXJebsmcGD1tVsaoKgsU5Q4KZpZ3mQOz
	dFg==
X-Google-Smtp-Source: AGHT+IErnULWLvILCBjnTrXVL9PyiWGQZnQCSwAUGyZ1aK9Rbwm+50UcADhp8VCYOA0V8XNmFTeFhShr9kc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:dd44:0:b0:61b:ebf1:77a with SMTP id
 00721157ae682-620991623a6mr52732597b3.0.1715967627900; Fri, 17 May 2024
 10:40:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:00 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-24-seanjc@google.com>
Subject: [PATCH v2 23/49] KVM: x86: Handle kernel- and KVM-defined CPUID words
 in a single helper
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Merge kvm_cpu_cap_init() and kvm_cpu_cap_init_kvm_defined() into a single
helper.  The only advantage of separating the two was to make it somewhat
obvious that KVM directly initializes the KVM-defined words, whereas using
a common helper will allow for hardening both kernel- and KVM-defined
CPUID words without needing copy+paste.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f2bd2f5c4ea3..8efffd48cdf1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -622,37 +622,23 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
 	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
-/* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
-static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
+static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
 
-	reverse_cpuid_check(leaf);
+	/*
+	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
+	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
+	 * and only authority.
+	 */
+	if (leaf < NCAPINTS)
+		kvm_cpu_caps[leaf] &= mask;
+	else
+		kvm_cpu_caps[leaf] = mask;
 
 	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
 }
 
-static __always_inline
-void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
-{
-	/* Use kvm_cpu_cap_init for leafs that aren't KVM-only. */
-	BUILD_BUG_ON(leaf < NCAPINTS);
-
-	kvm_cpu_caps[leaf] = mask;
-
-	__kvm_cpu_cap_mask(leaf);
-}
-
-static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
-{
-	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
-	BUILD_BUG_ON(leaf >= NCAPINTS);
-
-	kvm_cpu_caps[leaf] &= mask;
-
-	__kvm_cpu_cap_mask(leaf);
-}
-
 void kvm_set_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
@@ -740,12 +726,12 @@ void kvm_set_cpu_caps(void)
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
+	kvm_cpu_cap_init(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
 		F(AMX_COMPLEX)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
+	kvm_cpu_cap_init(CPUID_7_2_EDX,
 		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
 		F(BHI_CTRL) | F(MCDT_NO)
 	);
@@ -755,7 +741,7 @@ void kvm_set_cpu_caps(void)
 		X86_64_F(XFD)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
+	kvm_cpu_cap_init(CPUID_12_EAX,
 		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
 	);
 
@@ -781,7 +767,7 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
+	kvm_cpu_cap_init(CPUID_8000_0007_EDX,
 		SF(CONSTANT_TSC)
 	);
 
@@ -835,7 +821,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
+	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
 		F(PERFMON_V2)
 	);
 
-- 
2.45.0.215.g3402c0e53f-goog


