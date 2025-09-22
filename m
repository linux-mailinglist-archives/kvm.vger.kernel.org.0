Return-Path: <kvm+bounces-58407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2806B929E7
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7767D2A6A1A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FEA31A548;
	Mon, 22 Sep 2025 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="daB55+mO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3E42D660E
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758566447; cv=none; b=AcCoSSy6boASZliWRYulNLSBCL4HJBYvB4KUvPdmT0CNgrgtJ07gmQXZkzB2e5yS3KB87WvNVkzW3VJadzTGy+MPY1zyEugqs24sWwmQlguaW0i8zs5Wsc1mcVI5eh30HFO2b5xkk3z51gJosVjWnsL1oJJzhWmwDBaYkW/ZZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758566447; c=relaxed/simple;
	bh=oL+tjGEjCx+DungbPRqtqWY+Bvy/FUFDIUhNXSSXPdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=K+hcFKAzId4BA3xhJQkm9Gv0KGv62o0YSVRQdVtN+vak/dEM7aXcTZw4K5kSiPJOJu96nm9Hr9Wunn9tbKdzusP7ieiVp71SJaqgl8gsOJOpc18zX2Lh+toFixs7NGR8E6wPgnPvph1xDYJHxSskRBrHRf+qMpptNjT75CikiSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=daB55+mO; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-277f0ea6fc6so29802925ad.2
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 11:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758566445; x=1759171245; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2g+uqmGp8UqqFSnciCEsE7/IvKeQBbZzkyhr37tLjQQ=;
        b=daB55+mOVBZ3LBOpm8hfnKqEOYbW1L9iC1Q9ne9Wo6bxfJKIZqqrGAgljT4ACEcR83
         kxLWlkEgCutDqLQoDzBxtW1mgbQp52fm4n4yjxNSgnrThmJ3G7Pjf/n38TpnaP+EoZi1
         mFDfXPOrbK7zyekgVC1Dz+ep+d50JKEv9JgnKppTxcFDsOjzWA3RF5KDAO3x0G89Vykg
         p8Ulw81/xaKW7kMI1rhPEOel9GOWcBy2nw+tXbxF07VOwiH++XeLK6++ZnJbWB8K8j9S
         aroqTe2qsF1XKJxKcfInaYSebI/ino/qUyhHy5z8amkBCTmNQbF2Ayoco8Ehw/y7QxL+
         x3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758566445; x=1759171245;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2g+uqmGp8UqqFSnciCEsE7/IvKeQBbZzkyhr37tLjQQ=;
        b=vGoRCQJoXe4XvBe1/xi8kY5qTI0n1WrhulgA7kGl0kqRTAAVexhp/JChj8ZuhhGHIp
         xqIzcJuCIKwAd/6DWwi3E7KoVWjrRcUqSKTFdVTn2UMiXWqCDUA1sz34vsbD83YU38bF
         LmhPMJYFDpnXJ4laAgfehRurr9yTTTLBMhy6G3dNJdLDa5e4jQ6GTitCEvypwkOXqkzU
         1WSVcD4danaVaEwaYAsN4rLRhGV3J/yTPaFVWdUJ0kSPTVP7EcDbSUZ9jU9yiGjtxXz0
         BgIO/odMQ0Nf6qL54eYuuKJbmV9No6j6TeSsNoDoTnwcpRkrr1whEiCw5RKKAimFLIlT
         8KOw==
X-Forwarded-Encrypted: i=1; AJvYcCVQ7UbeGtMCqlX+7AS2IfjZsut9eGBSfXVQEl+xi+ydaDq9GIFvRk/Z7YLPjlZhvKyFh6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlPmYB5aI691qWbj/UIna2Uq0tEmIF7BqU4frQiL1wrZvSJ9wv
	jdknRn4ePr1TIKmYdV22FgiqtFFiOdIiaExnr9ICrR7j+hOL5liL0dV9U5RmXj+ovcDESsEQfU1
	wT8tIFw==
X-Google-Smtp-Source: AGHT+IG8AJXCXqqteTHbv63gCe2YIdww7X4Pp8Azv5gP83ckdpBJVYckBL5t0qlaEwEW4HEBQCPr1/3s4n8=
X-Received: from pjbmf6.prod.google.com ([2002:a17:90b:1846:b0:32e:bd90:3e11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e550:b0:272:2bf1:6a21
 with SMTP id d9443c01a7336-2722bf16e99mr125937715ad.14.1758566445452; Mon, 22
 Sep 2025 11:40:45 -0700 (PDT)
Date: Mon, 22 Sep 2025 11:40:43 -0700
In-Reply-To: <20250919223258.1604852-28-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-28-seanjc@google.com>
Message-ID: <aNGYKwtO7PgDpxxi@google.com>
Subject: Re: [PATCH v16 27/51] KVM: x86: Disable support for IBT and SHSTK if
 allow_smaller_maxphyaddr is true
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 19, 2025, Sean Christopherson wrote:
> Make IBT and SHSTK virtualization mutually exclusive with "officially"
> supporting setups with guest.MAXPHYADDR < host.MAXPHYADDR, i.e. if the
> allow_smaller_maxphyaddr module param is set.  Running a guest with a
> smaller MAXPHYADDR requires intercepting #PF, and can also trigger
> emulation of arbitrary instructions.  Intercepting and reacting to #PFs
> doesn't play nice with SHSTK, as KVM's MMU hasn't been taught to handle
> Shadow Stack accesses, and emulating arbitrary instructions doesn't play
> nice with IBT or SHSTK, as KVM's emulator doesn't handle the various side
> effects, e.g. doesn't enforce end-branch markers or model Shadow Stack
> updates.
> 
> Note, hiding IBT and SHSTK based solely on allow_smaller_maxphyaddr is
> overkill, as allow_smaller_maxphyaddr is only problematic if the guest is
> actually configured to have a smaller MAXPHYADDR.  However, KVM's ABI
> doesn't provide a way to express that IBT and SHSTK may break if enabled
> in conjunction with guest.MAXPHYADDR < host.MAXPHYADDR.  I.e. the
> alternative is to do nothing in KVM and instead update documentation and
> hope KVM users are thorough readers.  Go with the conservative-but-correct
> approach; worst case scenario, this restriction can be dropped if there's
> a strong use case for enabling CET on hosts with allow_smaller_maxphyaddr.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 499c86bd457e..b5c4cb13630c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -963,6 +963,16 @@ void kvm_set_cpu_caps(void)
>  	if (!tdp_enabled)
>  		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>  
> +	/*
> +	 * Disable support for IBT and SHSTK if KVM is configured to emulate
> +	 * accesses to reserved GPAs, as KVM's emulator doesn't support IBT or
> +	 * SHSTK, nor does KVM handle Shadow Stack #PFs (see above).
> +	 */
> +	if (allow_smaller_maxphyaddr) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +	}

Ugh, testing fail.  F(IBT) is initialized in CPUID_7_EDX, clearing IBT here has
no effect.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b861a88083e1..d290dbc96831 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -964,16 +964,6 @@ void kvm_set_cpu_caps(void)
        if (!tdp_enabled)
                kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 
-       /*
-        * Disable support for IBT and SHSTK if KVM is configured to emulate
-        * accesses to reserved GPAs, as KVM's emulator doesn't support IBT or
-        * SHSTK, nor does KVM handle Shadow Stack #PFs (see above).
-        */
-       if (allow_smaller_maxphyaddr) {
-               kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
-               kvm_cpu_cap_clear(X86_FEATURE_IBT);
-       }
-
        kvm_cpu_cap_init(CPUID_7_EDX,
                F(AVX512_4VNNIW),
                F(AVX512_4FMAPS),
@@ -994,6 +984,16 @@ void kvm_set_cpu_caps(void)
                F(IBT),
        );
 
+       /*
+        * Disable support for IBT and SHSTK if KVM is configured to emulate
+        * accesses to reserved GPAs, as KVM's emulator doesn't support IBT or
+        * SHSTK, nor does KVM handle Shadow Stack #PFs (see above).
+        */
+       if (allow_smaller_maxphyaddr) {
+               kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+               kvm_cpu_cap_clear(X86_FEATURE_IBT);
+       }
+
        if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
            boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
            boot_cpu_has(X86_FEATURE_AMD_IBRS))

> +
>  	kvm_cpu_cap_init(CPUID_7_EDX,
>  		F(AVX512_4VNNIW),
>  		F(AVX512_4FMAPS),
> -- 
> 2.51.0.470.ga7dc726c21-goog
> 

