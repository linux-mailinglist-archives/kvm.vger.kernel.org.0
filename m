Return-Path: <kvm+bounces-31169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A67A39C0F2D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91A41C24533
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED84218315;
	Thu,  7 Nov 2024 19:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwuntsgj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8D7216447;
	Thu,  7 Nov 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731008458; cv=none; b=jF+05wWTFPcWsJbu4ghFoD3DGhF5gfHEefsN76sdEN/H9n33snljZyTwKxT/rc7CTrR1eZHxRhGa5u58+p9HX58aJ7IwB392EtEmeS3E/zrXRVo0sL6fARJk7zS3+5zOdyrTkxHjxzptPqniHz6m+CDyMlKDwA1+bPDL0YeoG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731008458; c=relaxed/simple;
	bh=ZiLvEMXcWk3EnlXkmWOiJoDNigYaUUBGA9qbxDSnzUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJVVEiVjcwGG95wGUk7TmC7ku1n/bGIU9eDy4tZuxZ02RJcppjzvVw54Uk04GGHyVZO8OzCaPL3MZbUbX3qVa5m51kKv8yZKXGvvw870Af55HZtOtYZqDPck/Jdv1ZDcI5YlasNu38OBXbrfNOZwa670IHdnynxiAT75t93zALE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwuntsgj; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731008457; x=1762544457;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZiLvEMXcWk3EnlXkmWOiJoDNigYaUUBGA9qbxDSnzUE=;
  b=bwuntsgj9UZyy4AaDRUAjNxbrAcuQvCW2UERFgHG9vWNE2SMjuF80ikw
   OKfxb6nvscUevrjVffqQcgbVrBgXfDQ4pFtUaRYJU8R2rEHt4TZU95PYZ
   0Mn/pqIqy7oqDFKqswbCtBVbicEX1dszt6Y3cMafwsbh8Y+OX9Nq3jCF3
   HLOWQ9I9flBBKf60M3pdYfiCFbKks7a1kmYUu+4anuoea7bSeNaezbiMN
   c2B/SkDRTCUTyP2+VGyaJt1lJHqTvIZTj2UQNldC5SN9F5xQkY6uXs9Zw
   xjQTe/mQzaPn5SYpcr/b6c2e5r5Wy68Xd7r8sJD+yTjw9QP2sD3eAdr4g
   w==;
X-CSE-ConnectionGUID: 2gGnNH1ZRZe96viWLuEeRA==
X-CSE-MsgGUID: 1qhrpANWS+eE8KRsAIjFyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="56271328"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="56271328"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 11:40:56 -0800
X-CSE-ConnectionGUID: 8diFUQnRTBqpJudeHxV87g==
X-CSE-MsgGUID: yb097d/eQf2HXs6Mu1tSfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="84728163"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 11:40:56 -0800
Received: from [10.212.68.83] (kliang2-mobl1.ccr.corp.intel.com [10.212.68.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 5A72420B5705;
	Thu,  7 Nov 2024 11:40:51 -0800 (PST)
Message-ID: <393bbcf0-aebd-450c-ad0b-e6140f1272b4@linux.intel.com>
Date: Thu, 7 Nov 2024 14:40:50 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/5] x86: perf: Refactor misc flag assignments
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20241107190336.2963882-1-coltonlewis@google.com>
 <20241107190336.2963882-5-coltonlewis@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241107190336.2963882-5-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-11-07 2:03 p.m., Colton Lewis wrote:
> Break the assignment logic for misc flags into their own respective
> functions to reduce the complexity of the nested logic.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Acked-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan
>  arch/x86/events/core.c            | 32 +++++++++++++++++++++++--------
>  arch/x86/include/asm/perf_event.h |  2 ++
>  2 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index d19e939f3998..9fdc5fa22c66 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -3011,16 +3011,35 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
>  	return regs->ip + code_segment_base(regs);
>  }
>  
> +static unsigned long common_misc_flags(struct pt_regs *regs)
> +{
> +	if (regs->flags & PERF_EFLAGS_EXACT)
> +		return PERF_RECORD_MISC_EXACT_IP;
> +
> +	return 0;
> +}
> +
> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> +{
> +	unsigned long guest_state = perf_guest_state();
> +	unsigned long flags = common_misc_flags(regs);
> +
> +	if (!(guest_state & PERF_GUEST_ACTIVE))
> +		return flags;
> +
> +	if (guest_state & PERF_GUEST_USER)
> +		return flags & PERF_RECORD_MISC_GUEST_USER;
> +	else
> +		return flags & PERF_RECORD_MISC_GUEST_KERNEL;
> +}
> +
>  unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  {
>  	unsigned int guest_state = perf_guest_state();
> -	int misc = 0;
> +	unsigned long misc = common_misc_flags(regs);
>  
>  	if (guest_state) {
> -		if (guest_state & PERF_GUEST_USER)
> -			misc |= PERF_RECORD_MISC_GUEST_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> +		misc |= perf_arch_guest_misc_flags(regs);
>  	} else {
>  		if (user_mode(regs))
>  			misc |= PERF_RECORD_MISC_USER;
> @@ -3028,9 +3047,6 @@ unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  			misc |= PERF_RECORD_MISC_KERNEL;
>  	}
>  
> -	if (regs->flags & PERF_EFLAGS_EXACT)
> -		misc |= PERF_RECORD_MISC_EXACT_IP;
> -
>  	return misc;
>  }
>  
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index feb87bf3d2e9..d95f902acc52 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -538,7 +538,9 @@ struct x86_perf_regs {
>  
>  extern unsigned long perf_arch_instruction_pointer(struct pt_regs *regs);
>  extern unsigned long perf_arch_misc_flags(struct pt_regs *regs);
> +extern unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs);
>  #define perf_arch_misc_flags(regs)	perf_arch_misc_flags(regs)
> +#define perf_arch_guest_misc_flags(regs)	perf_arch_guest_misc_flags(regs)
>  
>  #include <asm/stacktrace.h>
>  


