Return-Path: <kvm+bounces-72946-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WDFnChHdqWm4GgEAu9opvQ
	(envelope-from <kvm+bounces-72946-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:44:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C205217B3B
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CEE1D300FEE3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738D03E51C5;
	Thu,  5 Mar 2026 19:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v3OUFcy9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE6630FC1E
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739835; cv=none; b=eyeekS3BwdKt9xdxpGuNvy6t8Jg7rrljvBNgtjk2y1znGA30SFPrgavbUhYnpb/ck/W5qX+Kj11P7E0Sww0vdDI5xNwxWbLZmh0raInItXU1wa3sHB5GMWoF+WfV/7ZAlqTxKxmXvW2HiUNzyQiW+FIu6WDIDUionnJpMoF5vX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739835; c=relaxed/simple;
	bh=HG5rO2nnXqY26lbnxyGN5VnAS3H5bd7yT/jvo5ZejQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WxQ6vNBveRiFwBEQ6eOIIWu1reSpyZ8d6lUmSMpdPG9SgR384sjLX0uLdZDU6TKW1khbhrTI9wYDPqFpo6VXFRTBUYarrXLl2eqvCNy6jWbymyfJvBAzFg+pZrcJAz/tANyRqP3H3/DaaBKNfF69rRx7u0VZ87ewT+1O59ibW4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v3OUFcy9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c738f71723aso625150a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772739833; x=1773344633; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hL24BBwwYB9gngfzKn9+xIPG81YzSOls3xYPhRZvEhE=;
        b=v3OUFcy9cwu+B1I8Aua9gEzn0z6+sik5nR9oivDJ1vrSYMjWG/MM0QBWjskuL3j1CC
         puf8lcLHhAVVwSuQCTMxf56dgClDV55hw6G5CwPHfSoWBWHJAAQJUl1jFW9vT4G+7rI3
         SkvlLzMMHdaB+bTWupDv2EdmAd+E3D6OZL+bEOZsAoRj61bwn181QfuOk9UtAB7ry/w/
         FOUTcHbQOUTWYxVhrWLVjV3FHepw2PxGr14RVvx3V/XbJvzfHcCIZpUQr9NzKQf6nRJi
         KZ2Cwe2sd4fTgK7o8h4lhkdmsfO0Qi0ZAskS2TARrTth05Yrncdlfm/9YtUBo21HFdak
         HQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772739833; x=1773344633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hL24BBwwYB9gngfzKn9+xIPG81YzSOls3xYPhRZvEhE=;
        b=iWo7FujZsa4KoAnj8E1od1TY+tw9ssT+AWaH5BiqUYX7rRsl3jMrl1TSVwGWZ2jCHR
         6RzO1fIRcGmruxHbIDVcMK9eI0rnEx5806BDYVWncYmt/RryYJS/6BZJcYGMBFcwgDu7
         2MsAlEwI2fCdq7nCvU91vrypo04yuYi9BeKspgHBjghHPkZ+m4vLqmkDk5zBN3cRuG1y
         cK5k5ERgeyC3W75eYLuJTSSHvy7TKUKjZ0a5YZoc0uOx80dbExt9HAPcolnVjasIJCs4
         YjA2rnysoGzqgDrpa6Nt1dt0oTYZK5NyN1EgkO2si1d7M7za8NTPvC7s0s5/23EdXXHc
         M9nA==
X-Forwarded-Encrypted: i=1; AJvYcCVOgRYiRcNXqDtXc49u4ICmLmf2+PKoHQ5I8012yS71f7ZZLRLH6Rzs6bKhZ/a7PVUrFeg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH/7MzMajMrcxXyc8F3m6VUDotOrObH7jepNIs118/irUF5nQq
	7yvLo9slaWJvm1wtKkTM68T/S74ndFG0CgaAD5cbR7WFyEI3ywlyRm8jkfrYqNggDaudKXpnySU
	g9fgU/A==
X-Received: from pgbcp10.prod.google.com ([2002:a05:6a02:400a:b0:c6e:1b27:7693])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:670a:b0:395:c42b:9f12
 with SMTP id adf61e73a8af0-39854aa5102mr633972637.55.1772739833008; Thu, 05
 Mar 2026 11:43:53 -0800 (PST)
Date: Thu, 5 Mar 2026 11:43:51 -0800
In-Reply-To: <20260305110519.308860-1-ewanhai-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260305110519.308860-1-ewanhai-oc@zhaoxin.com>
Message-ID: <aanc9xtztj5cYFvk@google.com>
Subject: Re: [PATCH] KVM: x86: Add KVM-only CPUID.0xC0000001:EDX feature bits
From: Sean Christopherson <seanjc@google.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: pbonzini@redhat.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, cobechen@zhaoxin.com, 
	tonywwang@zhaoxin.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 3C205217B3B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72946-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, Ewan Hai wrote:
> Per Paolo's suggestion, add the missing CPUID.0xC0000001:EDX feature
> bits as KVM-only X86_FEATURE_* definitions, so KVM can expose them to
> userspace before they are added to the generic cpufeatures definitions.
> 
> Wire the new bits into kvm_set_cpu_caps() for CPUID_C000_0001_EDX.
> 
> As a result, KVM_GET_SUPPORTED_CPUID reports these bits according to
> host capability, allowing VMMs to advertise only host-supported
> features to guests.

There needs to be a _lot_ more documentation explaining what these features are,
and most importantly why it's safe/sane for KVM to advertise support to userspace
without any corresponding code changes in KVM.

The _EN flags in particular suggest some amount of emulation is required.

The patch also needs to be split up into related feature bundles (or invididual
patches if each and every feature flag represents a completely independent feature).

> Link: https://lore.kernel.org/all/b3632083-f8ff-4127-a488-05a2c7acf1ad@redhat.com/
> Signed-off-by: Ewan Hai <ewanhai-oc@zhaoxin.com>
> ---
>  arch/x86/kvm/cpuid.c         | 14 ++++++++++++++
>  arch/x86/kvm/reverse_cpuid.h | 19 +++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 88a5426674a1..529705079904 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1242,8 +1242,12 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
>  
>  	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
> +		F(SM2),
> +		F(SM2_EN),
>  		F(XSTORE),
>  		F(XSTORE_EN),
> +		F(CCS),
> +		F(CCS_EN),
>  		F(XCRYPT),
>  		F(XCRYPT_EN),
>  		F(ACE2),
> @@ -1252,6 +1256,16 @@ void kvm_set_cpu_caps(void)
>  		F(PHE_EN),
>  		F(PMM),
>  		F(PMM_EN),
> +		F(PARALLAX),
> +		F(PARALLAX_EN),
> +		F(TM3),
> +		F(TM3_EN),
> +		F(RNG2),
> +		F(RNG2_EN),
> +		F(PHE2),
> +		F(PHE2_EN),
> +		F(RSA),
> +		F(RSA_EN),
>  	);
>  
>  	/*
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index 81b4a7acf72e..33e6a2755c84 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -59,6 +59,25 @@
>  #define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
>  #define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
>  
> +/*
> + * Zhaoxin/Centaur-defined CPUID level 0xC0000001 (EDX) features that are
> + * currently KVM-only and not defined in cpufeatures.h.
> + */
> +#define X86_FEATURE_SM2             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 0)
> +#define X86_FEATURE_SM2_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 1)
> +#define X86_FEATURE_CCS             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 4)
> +#define X86_FEATURE_CCS_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 5)
> +#define X86_FEATURE_PARALLAX        KVM_X86_FEATURE(CPUID_C000_0001_EDX, 16)
> +#define X86_FEATURE_PARALLAX_EN     KVM_X86_FEATURE(CPUID_C000_0001_EDX, 17)
> +#define X86_FEATURE_TM3             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 20)
> +#define X86_FEATURE_TM3_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 21)
> +#define X86_FEATURE_RNG2            KVM_X86_FEATURE(CPUID_C000_0001_EDX, 22)
> +#define X86_FEATURE_RNG2_EN         KVM_X86_FEATURE(CPUID_C000_0001_EDX, 23)
> +#define X86_FEATURE_PHE2            KVM_X86_FEATURE(CPUID_C000_0001_EDX, 25)
> +#define X86_FEATURE_PHE2_EN         KVM_X86_FEATURE(CPUID_C000_0001_EDX, 26)
> +#define X86_FEATURE_RSA             KVM_X86_FEATURE(CPUID_C000_0001_EDX, 27)
> +#define X86_FEATURE_RSA_EN          KVM_X86_FEATURE(CPUID_C000_0001_EDX, 28)
> +
>  struct cpuid_reg {
>  	u32 function;
>  	u32 index;
> -- 
> 2.34.1
> 

