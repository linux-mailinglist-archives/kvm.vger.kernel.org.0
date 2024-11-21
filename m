Return-Path: <kvm+bounces-32296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641AC9D5305
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2469828157E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EAD1E048E;
	Thu, 21 Nov 2024 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3K4c32M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE651DFDB9
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215216; cv=none; b=KsWfIk5A2ZN6g6q+YBShZLGZMBTmVZS+AePXmjPNqqORe1zhG7xAiq4Kid8b5DQE0IQ+PXQWu/kFe3CIQrP6LM2/tEDNlSHYAzPWqgQso3aWYNwVT7PjkaGqGV4fCWxDSUE8orl75CWVvCEOTiAPrWNeE1y31V5iYZqoPgLW6QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215216; c=relaxed/simple;
	bh=L6KbIt0/KvcQN/tGAQPm9b6wAl1wm8uAx55r4uF0rZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dd0wMBXQu999xBhX/iweyZ4U3V48tYr2heIW9E0S95e8bcF1N0TdL5LkgWWvPQ8MbzUVgsEzg7Jo3+oL9M/dzVWtbmDMlBKppvawu/50zkCayhS//TT9sR1qEe6Gf16knelrSpsKrKby9Eo3rJOGY/sIQzb05+0bWWLjDezWKKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r3K4c32M; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e4fa3eaafso1329098b3a.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215213; x=1732820013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=75cN6vpBl6q0bt4xLEE0VfpR783T6++jzGxWUcLySKo=;
        b=r3K4c32MGrz6TbefEF5gp/p19YI32WDiHN1Fqrmkx1eBLI3kReN8jzdn3L3J6n0E4v
         JQtBE3AgCLXKU9/+WX8PXrGZWzPs8B49YSPLoKUT8HtYMCJQfshHpN/GMRbkECq+cosu
         zN8KAPW6Z7oDH7g5FhebYtJ51n0UkxlhwAXhEomExpprX0etKR1cGjHgVAwhgPYZZxiA
         2ZNCkIE6fnDqnxbZhWR9Dz2UilFu4kZnJSlOvIHCbJOPH5Dhpj07sGLfMLTQVGh7KvLR
         OXTPfC+zjPsG9LjMkyFd5aQalcpRE/yhQSidxGFzmLOgfKEqqc17a+5bO21O2FvtdiXW
         oBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215213; x=1732820013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75cN6vpBl6q0bt4xLEE0VfpR783T6++jzGxWUcLySKo=;
        b=bb0/jQbvJtnqT/7tcNULO15oS6bMHMJKMZpPgsrcJRaWZ0v2G+Mj2fX6m4r1GD7K48
         A2IoriJEjNKGLcbshlvSf/zAxBADMXOYtaVHsYprhdr7hVZauviTBOYWnpjWT+sdazL9
         d7QtqArfj+Fsp+AXSkOAwTrvUNLmWfgLY1GEEcpHG3eGDTOcHGCpAhKw/gwAsDExJYPb
         FvytQg2dyZrGpQyb6SRsaTZXcUtNDsc84Z6/mZ8aboaCakrlTub6TtrRVG1MIq8fZNKl
         exlLwPg14DpQSMmq8z9jGMSKdy1K4nZdwMgONQV/4FF7J8WANne/ge48Yu1fRbsc1KOI
         fGnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnp0Xp+PLdhc1NJ7bfcEA3EmT1x3I1RpLIDMtQRT+1pS4Gb96gRa8SVHNAfLHk9U3iETU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/dDga+4F9djbNmq58z+0O9ctEdQs7kQXqHWqcAeOxnrM2BN1o
	o8DV27+gwULhfYNuPONtDJrkxNmX6wDZOZk4SjWHSLUk9X+ryrzBN5GrAB1uGnWuSJjIJaN7Jt/
	x7h9fNg==
X-Google-Smtp-Source: AGHT+IHP6COYTNf6/JtdvUV7mQ9ms/6tBN3oxJUtYpsMH+h3z77LegfOxWfKvjQWoDLBqbCVlZHxViw6Xo6D
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a62:e811:0:b0:724:daf0:e060 with SMTP id
 d2e1a72fcca58-724df3c0f18mr40b3a.1.1732215212841; Thu, 21 Nov 2024 10:53:32
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:01 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-10-mizhang@google.com>
Subject: [RFC PATCH 09/22] KVM: x86: Introduce KVM_X86_FEATURE_APERFMPERF
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

The APERFMPERF feature bit appears in CPUID.6H:ECX[0], but is exposed to
Linux via X86_FEATURE_APERFMPERF in a Linux-defined feature word. To
enable KVM's reverse CPUID functionality for this feature, define a KVM
feature word matching the hardware CPUID leaf that contains the APERFMPERF
bit.

This patch only adds the feature definition - enabling and advertising
the feature to guests will be handled in later patches.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/reverse_cpuid.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 0d17d6b706396..d12e5d9ab2251 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -18,6 +18,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_8000_0022_EAX,
 	CPUID_7_2_EDX,
 	CPUID_24_0_EBX,
+	CPUID_6_ECX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -42,6 +43,9 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* Intel-defined sub-features, CPUID level 0x00000006 (ECX) */
+#define KVM_X86_FEATURE_APERFMPERF	KVM_X86_FEATURE(CPUID_6_ECX, 0)
+
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
@@ -98,6 +102,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
+	[CPUID_6_ECX]         = {         6, 0, CPUID_ECX},
 };
 
 /*
@@ -135,6 +140,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	KVM_X86_TRANSLATE_FEATURE(SGX_EDECCSSA);
 	KVM_X86_TRANSLATE_FEATURE(CONSTANT_TSC);
 	KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
+	KVM_X86_TRANSLATE_FEATURE(APERFMPERF);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
 	KVM_X86_TRANSLATE_FEATURE(BHI_CTRL);
 	default:
-- 
2.47.0.371.ga323438b13-goog


