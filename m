Return-Path: <kvm+bounces-70336-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKhKJvKyhGk54wMAu9opvQ
	(envelope-from <kvm+bounces-70336-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:10:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A93C3F4725
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AAD0C300404E
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 15:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0D1421F09;
	Thu,  5 Feb 2026 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nv1IWv04"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87FB421A0F
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770304220; cv=none; b=uS+5/jTi2+hxCRlPjiE0xCBrVrhIWqlQ8wYVIBzZIny+Lr4BIfhbv+wBxKlLJJHRRzmTN4foC5a8PCD7q3ebAMU7bx4rZKjHX+DBJGR8nJ4qhJnc9wnNRVf/GvapHKM9RanootgHhXFF+SMkDGUvNW0SRuHL+XAXUGcPw1bq1u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770304220; c=relaxed/simple;
	bh=BwOFmVSqhfoo7kYURulhKFQoB/w2QMbJsVWrs0RUVtw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mlganV4KXE6Q06aGWn8E3kiRHB9prX1+g1qUR9rkJjdRL8kGSk9Nk+hNBUZxOdDbf4O+efI+ou6uc80L3JFd/MyrVrOQW4oSaXnlsOAlMhLLJBSBocGh64LKOHULi8OdD0sb0/qA/VE0QE2Dle+fxF/1cy0xFgaSguqOnA4M/fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nv1IWv04; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c337cde7e40so653080a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 07:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770304220; x=1770909020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1c2B7fdvhgQjjTsMYaP+n7bHKu8afl2tyODY1J/PVKc=;
        b=Nv1IWv04Phcu9qeZhRCX9EmA+RX2GWfhP7fPmi5jKzLt7mLRqMaw9xvVxnfNKLHWOE
         2wQyzCs97+jtrBiBL7ddKmQzWACoSVPP6vW1Kml1ay76XNZfWTi4TC08RTuFMf27Lvvr
         PTLF51NHZZx3FNfkVp1OQPdlg88AADAWSjvA7g64EQ62xfeWw5k//KgoEVcNKDGFKs9F
         Q3VlqAaeLDkjDQQlvupa9sIQ1xXITXRf4En1dlTyCEz1sj2LaCbXhvb7YYy0CcjY8ZE7
         OxytKeaunnsDZWH1iUZvn6xth/eRqorlyBz5FLuJZiJuH1WmCZuwyW1Oh9cEROWRohuf
         qxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770304220; x=1770909020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1c2B7fdvhgQjjTsMYaP+n7bHKu8afl2tyODY1J/PVKc=;
        b=MMvWspGIBujIXiBioFzs3K/36uVgTvckoB6lF4PBsKWUe4imn95A167klH+Dga55vI
         dW1b6hDbyCNiCAej2VWJy1nyjVBIlBYbU2pYy/SKt6T4R+u+xU1fz2/hh+dI1lfSN363
         cR2xW/P/fEOh8clbshabpJU4sltrBmxJhhFWKzoo501N6/TMtxzhNLum7eVqLGyZFKmx
         HG+TUEPvb3So/0Z1MujfixmAIJv0WB6WGwCl0bVtodFDHVzm7ieAgXagbVgn1ppeZXP/
         Ty+806eWKlD2zCit7AzZPqyKxn9OQ02p1l63tJgn1hgvUCQE8sFU0C17vnkhBejgPYeQ
         xjFw==
X-Forwarded-Encrypted: i=1; AJvYcCU48FS2C0ZbkvtfhyHmNinxlxHWoDis2jc50vupXXmzXfsGdh5lAYvgFUznichnneqtbUE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhzK1UHIZzVsA2ln7ggJ3jdIWe8l7oUCIpI1oKOw4u24ufDPqP
	HRSg7e5aqcQoUB6NjapRtY6C1vzOxQgg38WcxAgl1tCFiPXKj7Lxu6ES9cIXY53lK31EKh5Ho3Y
	kckj57w==
X-Received: from pgkm5.prod.google.com ([2002:a63:ed45:0:b0:c61:39de:93a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e083:b0:38b:d9b0:e943
 with SMTP id adf61e73a8af0-393723b73b4mr5998274637.38.1770304219960; Thu, 05
 Feb 2026 07:10:19 -0800 (PST)
Date: Thu, 5 Feb 2026 07:10:17 -0800
In-Reply-To: <20260205042105.1224126-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205042105.1224126-1-nikunj@amd.com>
Message-ID: <aYSy2fgLe8FaxxQy@google.com>
Subject: Re: [PATCH] x86/cpufeatures: Add AVX512 Bit Matrix Multiply (BMM) and
 Bit reversal support
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, bp@alien8.de, x86@kernel.org, babu.moger@amd.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-70336-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: A93C3F4725
X-Rspamd-Action: no action

KVM: x86: Advertise AVX512 Bit Matrix Multiply (BMM) to userspace

Because the primary focus of the change is quite clearly to add KVM support,
not to simply define the feature flag.

On Thu, Feb 05, 2026, Nikunj A Dadhania wrote:
> Add support for AVX512 Bit Matrix Multiply (BMM) and Bit Reversal
> instructions, a feature that enables bit matrix multiply operations and
> bit reversal, which is exposed via CPUID leaf 0x80000021_EAX[23].
> 
> Expose the support to guests when available by including it in the CPUID

Advertise to userspace.  The VMM decides whether or not to enumerate features to
guests.

> leaf 0x80000021_EAX feature list.
> 
> While at it, reorder PREFETCHI to match the bit position order in CPUID
> leaf 0x80000021_EAX for better organization.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
> 
> AMD64 Bit Matrix Multiply and Bit Reversal Instructions
> Publication #69192 Revision: 1.00
> Issue Date: January 2026
> 
> https://docs.amd.com/v/u/en-US/69192-PUB
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index c3b53beb1300..2f1583c4bdc0 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -472,6 +472,7 @@
>  #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
>  
>  #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
> +#define X86_FEATURE_AVX512_BMM		(20*32+23) /* AVX512 Bit Matrix Multiply instructions */
>  #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>  #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 88a5426674a1..b36e8f10f509 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1218,11 +1218,12 @@ void kvm_set_cpu_caps(void)
>  		F(NULL_SEL_CLR_BASE),
>  		/* UpperAddressIgnore */
>  		F(AUTOIBRS),
> -		F(PREFETCHI),
>  		EMULATED_F(NO_SMM_CTL_MSR),
>  		/* PrefetchCtlMsr */
>  		/* GpOnUserCpuid */
>  		/* EPSF */
> +		F(PREFETCHI),
> +		F(AVX512_BMM),
>  		SYNTHESIZED_F(SBPB),
>  		SYNTHESIZED_F(IBPB_BRTYPE),
>  		SYNTHESIZED_F(SRSO_NO),
> 
> base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
> -- 
> 2.48.1
> 

