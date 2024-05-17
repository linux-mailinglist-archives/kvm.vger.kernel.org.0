Return-Path: <kvm+bounces-17700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4888B8C8BB2
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2EB31F26584
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB15515B128;
	Fri, 17 May 2024 17:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S446AXtj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B67158DA5
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967677; cv=none; b=NbG27b6wU4D+sZzyjgs1HRmnh7XLX1Da/yAxLWmQpuvFaf1F+FVGAVyzdTjs2nriyVeewNEnMTbnfgsR/IGna86pFB+FsWrXKHB9LdrgFWvcP43Bg3FjohfwqGLUvnTK8Y8kstP3OMBQexfT/Sw8d0EiX3vCMMq0i37xH0+b/Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967677; c=relaxed/simple;
	bh=HOXpaaWb4URCLOevzhjfgICuW5P1mMzaORgDJr4eCpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ukFHwEZLwpMtqJZUNywoszi8Px3+CFYPpnYlczO+YNbkbG3DYIKwHuTL6kSugbMBe4M4VSIrC3IGoNhLzVabBAYgR0/Ky4rIKnb51Xcqhhp2dHi92b+64s6yLaehSGsepXjmGA7rGgF1Jefst1xMk67Djj1f8Gv5WjiBVaeEL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S446AXtj; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de603db5d6aso16976236276.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967675; x=1716572475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=umZiPbHCtUl8z62f2qPaeJm6haB1mlYCdYyI3+ZdsyU=;
        b=S446AXtjAgp9yV4YKEtnS2cjs4YAEtI49VxxQbizc2tTTO2w605C6RnwNciJNQDhFB
         6Xctv6OMD7BOWAeo514/RgH/vO0NkpSxHQBRzoHpf/Wbz2wnRKsbxLUgSMr9/BM37/bo
         csQrGgxGqKGtyVcZ9BJ5FVW+9DHJNLBCjyJEgQ4pWS4ERfkfbqUF3iCXdM/jp91lCrKS
         zIETkGNHT7rCR4Rk+YuSLt/AHkVc0LQ+lyjorL5hNZfYNJZpCtLwXDzXL6YNN+BW1QzN
         pX5kAds46djjM+GRy0haxQmziiheeykgPg7X7Fe6P9SRZagtUft4bNjGZfTHuqQbZJwz
         2Tvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967675; x=1716572475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umZiPbHCtUl8z62f2qPaeJm6haB1mlYCdYyI3+ZdsyU=;
        b=YhIfa/ot6xej5zRUxpqICiURDkOAFFnLc64nElGOFhRnka9NBj/+nr556za7Lk2RRT
         eX+rwwS/0cxQ0U3tSUrUpfv6Pt2WRkW5PuJqh0Jcey4iUSz/lXIfsR3C5YQKsRouDDQV
         xLKkzYPTrcnf3FqT66iIsv2V+sExYXgKiohz7b/x82/BmR4ccY9W2SCuYFYX6X3pZoSr
         rMmK8sMRw4VQtJtEX1u37+zC2OTXeiJz7RM+AbBOvQjL5RQ64gSqicHeHa0qlzMRjeHR
         RsornULI4gNdvywbY8nqVfimmHiekPOGebyOuXnsKfzjxpEzE/tV3eEn97Bo879UbDKO
         aM1w==
X-Gm-Message-State: AOJu0Yz4NhFyrOkAKRbcAXgLAR+3nYB4Ks6CITJ58V9oZbX/+geUA9Cr
	QB5kAdZjUVyE1+CEL/akiynpNvzDTVYcvj3aXrL/iC+RaNUmQLruyhQ/JEGZ3aP+XgLH9Nwqykd
	QxQ==
X-Google-Smtp-Source: AGHT+IEPEqbWQHead2/pqOJL8nUxVfuxKMTJB//+1VN8NOCh7DLAMpZPdi73AneodpvlwKjwt0xMHo7GzOw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d8d4:0:b0:de4:e042:eee9 with SMTP id
 3f1490d57ef6-dee4f2e9594mr5191794276.6.1715967674621; Fri, 17 May 2024
 10:41:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:25 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-49-seanjc@google.com>
Subject: [PATCH v2 48/49] KVM: x86: Add a macro for features that are
 synthesized into boot_cpu_data
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add yet another CPUID macro, this time for features that the host kernel
synthesizes into boot_cpu_data, i.e. that the kernel force sets even in
situations where the feature isn't reported by CPUID.  Thanks to the
macro shenanigans of kvm_cpu_cap_init(), such features can now be handled
in the core CPUID framework, i.e. don't need to be handled out-of-band and
thus without as many guardrails.

Adding a dedicated macro also helps document what's going on, e.g. the
calls to kvm_cpu_cap_check_and_set() are very confusing unless the reader
knows exactly how kvm_cpu_cap_init() generates kvm_cpu_caps (and even
then, it's far from obvious).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0130e0677387..0e64a6332052 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -106,6 +106,17 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	F(name);						\
 })
 
+/*
+ * Synthesized Feature - For features that are synthesized into boot_cpu_data,
+ * i.e. may not be present in the raw CPUID, but can still be advertised to
+ * userspace.  Primarily used for mitigation related feature flags.
+ */
+#define SYN_F(name)						\
+({								\
+	kvm_cpu_cap_synthesized |= F(name);			\
+	F(name);						\
+})
+
 /*
  * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
  * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
@@ -727,13 +738,15 @@ do {									\
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
 	u32 kvm_cpu_cap_emulated = 0;					\
+	u32 kvm_cpu_cap_synthesized = 0;				\
 									\
 	if (leaf < NCAPINTS)						\
 		kvm_cpu_caps[leaf] &= (mask);				\
 	else								\
 		kvm_cpu_caps[leaf] = (mask);				\
 									\
-	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
+	kvm_cpu_caps[leaf] &= (raw_cpuid_get(cpuid) |			\
+			       kvm_cpu_cap_synthesized);		\
 	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
 } while (0)
 
@@ -913,13 +926,10 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
-		F(WRMSR_XX_BASE_NS)
+		F(WRMSR_XX_BASE_NS) | SYN_F(SBPB) | SYN_F(IBPB_BRTYPE) |
+		SYN_F(SRSO_NO)
 	);
 
-	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
-	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
-	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
-
 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
 		F(PERFMON_V2)
 	);
-- 
2.45.0.215.g3402c0e53f-goog


