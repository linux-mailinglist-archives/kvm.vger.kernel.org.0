Return-Path: <kvm+bounces-48658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C826EAD0238
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 14:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0646A3AEA8B
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 12:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14A428852F;
	Fri,  6 Jun 2025 12:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="mfgoESb3"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F90288538
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749213008; cv=none; b=YfOY1pQ8x68jD4aNonjQMkMVdeI0kwj2k7g1Rr5yL+o21qjl7JriFDc0vftRW5rEhy/Kmsu6nyyoZG7GlTUx40zzP2ElBsJCPcmmAlnL0ALfgyau8AZsvd3yOmZad8TG57bKY45F4X31XEZc3Z+iw6FeGakTUXF4dFq3SG8pJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749213008; c=relaxed/simple;
	bh=iVm4Kj7xAPcMkLZ1t5FYssu4Uu73+2XwKLHIajlift8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHhy9DBQ6NnLokUTCJy3X/zIN9O4HbzhNMMJCtqfanQ9AnZDX6vrpKLb/mV3ovljF5LqZV2yLPmZVweHr0qh5PgFojTggGG5XEjv98mtqY5ytnxAhydCpobcHGc6x4IMNoWFfTqgqXDUdUexI+lmmXlQG+fA0QHJqLWIy5iWFXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=mfgoESb3; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=TP9zixZc6p07lO6UHxKLDUvYWlj6E2NNyB/0TPwLe1M=; b=mfgoESb3+WRUHZj1
	dzcYoyZYdBBx405BSPdW/MHgInHMgRMVO8lnEjhBk1dwoZjCkQ9Li7rjgvlJVCHamfUDkJX9ZssNj
	fc7HmngbrOZski5wk1JdBki6oAXlQQhmj2VKjed1t6SGf7w+8oU1e+sXAGWwnaQGYncVBn/VuiA0t
	q6FjU8MffD2UuwLyBTSuxSC83qqzURvWBAmFpupjJ5SAv7sp+kLqI1/eBqfQlqQv79lIKNdVdFhy0
	bW8R8kwHmqNZbO6P9NdtzakjR/Za6rUozjU4SRxVw29m7yp5+SJbGUSlOM4+YF7XEJD4DECjRb1eR
	P8sgg/kluKluvagVYg==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uNWCk-0082bL-2P;
	Fri, 06 Jun 2025 12:29:50 +0000
Date: Fri, 6 Jun 2025 12:29:50 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, davydov-max@yandex-team.ru
Subject: Re: [PATCH v7 4/6] target/i386: Add couple of feature bits in
 CPUID_Fn80000021_EAX
Message-ID: <aELfPr7snDmIirNk@gallifrey>
References: <cover.1746734284.git.babu.moger@amd.com>
 <a5f6283a59579b09ac345b3f21ecb3b3b2d92451.1746734284.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <a5f6283a59579b09ac345b3f21ecb3b3b2d92451.1746734284.git.babu.moger@amd.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 12:28:21 up 39 days, 20:41,  2 users,  load average: 0.00, 0.01,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Babu Moger (babu.moger@amd.com) wrote:
> Add CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
> MSR_KERNEL_GS_BASE is non-serializing amd PREFETCHI that the indicates
> support for IC prefetch.
> 
> CPUID_Fn80000021_EAX
> Bit    Feature description
> 20     Indicates support for IC prefetch.
> 1      FsGsKernelGsBaseNonSerializing.

I'm curious about this:
  a) Is this new CPUs are non-serialising on that write?
  b) If so, what happens if you run existing kernels/firmware on them?
  c) Bonus migration question; what happens if you live migrate from a host
     that claims to be serialising to one that has the extra non-serialising
     flag but is disabled in the emulated CPU model.

Dave

>        WRMSR to FS_BASE, GS_BASE and KernelGSbase are non-serializing.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 4 ++--
>  target/i386/cpu.h | 4 ++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 98fad3a2f9..741be0eaa8 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1239,12 +1239,12 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>      [FEAT_8000_0021_EAX] = {
>          .type = CPUID_FEATURE_WORD,
>          .feat_names = {
> -            "no-nested-data-bp", NULL, "lfence-always-serializing", NULL,
> +            "no-nested-data-bp", "fs-gs-base-ns", "lfence-always-serializing", NULL,
>              NULL, NULL, "null-sel-clr-base", NULL,
>              "auto-ibrs", NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> +            "prefetchi", NULL, NULL, NULL,
>              "eraps", NULL, NULL, "sbpb",
>              "ibpb-brtype", "srso-no", "srso-user-kernel-no", NULL,
>          },
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 4f8ed8868e..d251e32ae9 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1070,12 +1070,16 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
>  
>  /* Processor ignores nested data breakpoints */
>  #define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP            (1U << 0)
> +/* WRMSR to FS_BASE, GS_BASE, or KERNEL_GS_BASE is non-serializing */
> +#define CPUID_8000_0021_EAX_FS_GS_BASE_NS                (1U << 1)
>  /* LFENCE is always serializing */
>  #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
>  /* Null Selector Clears Base */
>  #define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE            (1U << 6)
>  /* Automatic IBRS */
>  #define CPUID_8000_0021_EAX_AUTO_IBRS                    (1U << 8)
> +/* Indicates support for IC prefetch */
> +#define CPUID_8000_0021_EAX_PREFETCHI                    (1U << 20)
>  /* Enhanced Return Address Predictor Scurity */
>  #define CPUID_8000_0021_EAX_ERAPS                        (1U << 24)
>  /* Selective Branch Predictor Barrier */
> -- 
> 2.34.1
> 
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

