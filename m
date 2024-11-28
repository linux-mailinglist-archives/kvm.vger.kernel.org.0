Return-Path: <kvm+bounces-32677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 052ED9DB0F9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86A35B2228A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF0D1AA1CE;
	Thu, 28 Nov 2024 01:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QOAbczJO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B0C84A5E
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757719; cv=none; b=KF4BqaJVNMEwBdUyj/2ufluU8pQapa/Q3lb0nFlR7x52NSxXUPZYtwKcuFftqWm8noTbZEXqAdBrO5fWRB6DNG/aKn6ynwdy+6jI30sb1qDjU1T/hztltOESZ1zNbQdgoTMNWtjh1Uh9drXcqcBs0yN/qe9Kewywh4u/+Odt+Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757719; c=relaxed/simple;
	bh=03vFd+gOroODh8C9T2sGp7JBfixgtUjep2ou9I0cgFo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W7CLFKcU6ASWND/2fxK++akkE5Y4tUYP57FVloild7xiePbQIQuLB4abspA+HX4riKuO8gdmj7RWltzXU6EorQ9vKJTFkkXhuo4UiyXAg5KeJS6slepjo0NMScGB8imzXbXGSIiCuW1J7PwF9irHXjvqiazn4TFautk3LKReFJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QOAbczJO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3c9178f6so359902a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757717; x=1733362517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aTsYQpwTexwHG3yKKxJkIwGG0dvQpQ9Ljw6Jssadn/0=;
        b=QOAbczJO1zMG+O0cl5abqtQwBU1I1kQeGDIjle4GWkCNfDpfXx4kx8mnJ6DOJ3/v/B
         jtjPY+60JF4IOEj8gRQotixdmfjLWoOocsF4AqWbpt5ye4k8g4NngjNx1QlwbLIuWOGy
         nXoT8NKyMPo4fcZQJVYP2mQByYIwAJES5h5BLjx80o0s0H1UJ4/w3cgH3I+qtbZxf/Yn
         MXjldkOzsomeenaNKZWo9Ugc027qWnb2wd+H6LfEPMpQrBcIadE8Nu7u4aAJ8mMbKT8O
         GThTYtSjKRO15DCDfBvj7CDTtI7UpjDzcphSikcZNrZuIsUGzgnb/r/yBdZqN9fQ+w2D
         DZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757717; x=1733362517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aTsYQpwTexwHG3yKKxJkIwGG0dvQpQ9Ljw6Jssadn/0=;
        b=ZbjqqWCdPLDJ+gXamwTUzdKHqBSE1rhzmyGJmZ+a9zUjZOtr1+G6o52ziHOumeqoYk
         TNkZeByyMHa4F65BcdCqnwA+ZLfdUnvJrIR3hdree9qAwzIvhmj9e9ttwjEMebvddemC
         2IDGRmYFFeiDGOc81PuO+9DPeATtUW8toIDu3pGSgYrzg3o5njNVtFEno87CZYQPb/V3
         xsQjWEq4dD+83idDbzaogrM5CnkAqYUEqLtUnlVcVTDfdkOhVOC1rDqahGywggsEiwAd
         W2R/YTBtSnfwAPyWtkInd/Dt3fFBYXk6lxz/XcunmLsiBxzejGa1SVJuUOeW4upmzQce
         GX1w==
X-Gm-Message-State: AOJu0Yy4f2zsRelqK8aRQeTRM6BOXC16+DqDnUAXquGKRjA470iiBhes
	jAkw9d8vo+HNFmqBrtc1DNbi+ir9y5gAFAath9u5aKurzRjo76CABrGiFReFxsVBzYTVzFveAWa
	pLg==
X-Google-Smtp-Source: AGHT+IF25yaZO9df1NGjMlKWj48Yvt3nBDt+80lXZmbLiOO/wECyYSxbM3ry8GaNmjsPc3OIt081rI5FNF4=
X-Received: from pjbnd11.prod.google.com ([2002:a17:90b:4ccb:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3947:b0:2ea:61de:38ef
 with SMTP id 98e67ed59e1d1-2ee097bf33dmr5685347a91.28.1732757717375; Wed, 27
 Nov 2024 17:35:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:53 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-27-seanjc@google.com>
Subject: [PATCH v3 26/57] KVM: x86: Handle kernel- and KVM-defined CPUID words
 in a single helper
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

Merge kvm_cpu_cap_init() and kvm_cpu_cap_init_kvm_defined() into a single
helper.  The only advantage of separating the two was to make it somewhat
obvious that KVM directly initializes the KVM-defined words, whereas using
a common helper will allow for hardening both kernel- and KVM-defined
CPUID words without needing copy+paste.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 46 +++++++++++++++-----------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ddff0c7c78b9..73e756d097e4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -602,37 +602,23 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
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
 #define F feature_bit
 
 /* Scattered Flag - For features that are scattered by cpufeatures.h. */
@@ -843,7 +829,7 @@ void kvm_set_cpu_caps(void)
 		F(LAM)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
+	kvm_cpu_cap_init(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) |
 		F(AVX_NE_CONVERT) |
 		F(AMX_COMPLEX) |
@@ -852,7 +838,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX10)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
+	kvm_cpu_cap_init(CPUID_7_2_EDX,
 		F(INTEL_PSFD) |
 		F(IPRED_CTRL) |
 		F(RRSBA_CTRL) |
@@ -869,13 +855,13 @@ void kvm_set_cpu_caps(void)
 		X86_64_F(XFD)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
+	kvm_cpu_cap_init(CPUID_12_EAX,
 		SF(SGX1) |
 		SF(SGX2) |
 		SF(SGX_EDECCSSA)
 	);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_24_0_EBX,
+	kvm_cpu_cap_init(CPUID_24_0_EBX,
 		F(AVX10_128) |
 		F(AVX10_256) |
 		F(AVX10_512)
@@ -938,7 +924,7 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
+	kvm_cpu_cap_init(CPUID_8000_0007_EDX,
 		SF(CONSTANT_TSC)
 	);
 
@@ -1012,7 +998,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
 
-	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
+	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
 		F(PERFMON_V2)
 	);
 
-- 
2.47.0.338.g60cca15819-goog


