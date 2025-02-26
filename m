Return-Path: <kvm+bounces-39360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A65FA46B6B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301E818897EB
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9A2256C62;
	Wed, 26 Feb 2025 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a7JpSAiz"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB9E21B192
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599489; cv=none; b=X3SSAwrjv3nSGW2d8Pcy+LVHMvLMdB5FhPvIQ7Ma0airdVNyIFWMSbKxNG53FJeczmVNMeezXj3MeIE3Bu+08fvJjN9ssth96oIO6i4eQp5uUnyo5oX2kYYgTk+o6McGUz6/eJVuxqIYtG1d7KKxAoTpsQfSaVKx3rIcmh+HGwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599489; c=relaxed/simple;
	bh=HPx5he7R5CNJ8mm6HEOg600FCFZgd4hCSDOVZ2Urmgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdMNoaM4HJQEVG9uxyeWYagSIyUkp+awXIryjHNz8k+1mbdPUN7CAaFtJQoSqjv2jLSLrP6NU5zykSUpGALlaMAHUnU2O9+82UqbVgO+lJJU66MDDcFBb6Pbkce5ZuN6mXGt092FvBqSlY1q97YyU00uQ5cflg/nETbSRMHgiOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a7JpSAiz; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 26 Feb 2025 19:51:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740599474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ivu+nGK60AA1jaOvyRimH7ilHI4XPYOE1OskE9W6xZc=;
	b=a7JpSAizvZ+acqtTt9FpwIcXbH7MdlxrsO2gEAq5DEaZqSmB29gWcM9QRAZQu9fatdws6y
	GVR0Enoizo0yw6zKGHPE5KY/rG2FwRno1G4bfDLTBTMdvnDvE3Ckx2yTMcP3yopMW3ad6R
	ZXAYpQzVMM8yfUnKr5t1Ad0s74V+678=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Patrick Bellasi <derkling@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	David Kaplan <David.Kaplan@amd.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <Z79wrLx3kJCxweuy@google.com>
References: <20250226184540.2250357-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226184540.2250357-1-derkling@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 26, 2025 at 06:45:40PM +0000, Patrick Bellasi wrote:
> > On Tue, Feb 18, 2025 at 02:42:57PM +0000, Patrick Bellasi wrote:
> > > Maybe a small improvement we could add on top is to have a separate and
> > > dedicated cmdline option?
> > > 
> > > Indeed, with `X86_FEATURE_SRSO_USER_KERNEL_NO` we are not effectively using an
> > > IBPB on VM-Exit anymore. Something like the diff down below?
> > 
> > Except that I don't see the point of this yet one more cmdline option. Our
> > mitigations options space is a nightmare. Why do we want to add another one?
> 
> The changelog of the following patch provides the motivations.
> 
> Do you think something like the following self contained change can be added on
> top of your change?
> 
> Best,
> Patrick
> 
> ---
> From 62bd6151cdb5f8e3322d8c91166cf89b6ed9f5b6 Mon Sep 17 00:00:00 2001
> From: Patrick Bellasi <derkling@google.com>
> Date: Mon, 24 Feb 2025 17:41:30 +0000
> Subject: [PATCH] x86/bugs: Add explicit BP_SPEC_REDUCE cmdline
> 
> Some AMD CPUs are vulnerable to SRSO only limited to the Guest->Host
> attack vector. When no command line options are specified, the default
> SRSO mitigation on these CPUs is "safe-ret", which is optimized to use
> "ibpb-vmexit". A further optimization, introduced in [1], replaces IBPB
> on VM-Exits with the more efficient BP_SPEC_REDUCE mitigation when the
> CPU reports X86_FEATURE_SRSO_BP_SPEC_REDUCE support.
> 
> The current implementation in bugs.c automatically selects the best
> mitigation for a CPU when no command line options are provided. However,
> it lacks the ability to explicitly choose between IBPB and
> BP_SPEC_REDUCE.
> In some scenarios it could be interesting to mitigate SRSO only when the
> low overhead of BP_SPEC_REDUCE is available, without overwise falling
> back to an IBPB at each VM-Exit.

To add more details about this, we are using ASI as our main mitigation
for SRSO. However, it's likely that bp-spec-reduce is cheaper, so we
basically want to always use bp-spec-reduce if available, if not, we
don't want the ibpb-on-vmexit or safe-ret as they are a lot more
expensive than ASI.

So we want the cmdline option to basically say only use bp-spec-reduce
if it's available, but don't fallback if it isn't. On the other hand we
are enlighting ASI to skip mitigating SRSO if
X86_FEATURE_SRSO_BP_SPEC_REDUCE is enabled

> More in general, an explicit control is valuable for testing,
> benchmarking, and comparing the behavior and overhead of IBPB versus
> BP_SPEC_REDUCE.
> 
> Add a new kernel cmdline option to explicitly select BP_SPEC_REDUCE.
> Do that with a minimal change that does not affect the current SafeRET
> "fallback logic". Do warn when reduced speculation is required but the
> support not available and properly report the vulnerability reason.
> 
> [1] https://lore.kernel.org/lkml/20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local/
> 
> Signed-off-by: Patrick Bellasi <derkling@google.com>
> ---
>  arch/x86/kernel/cpu/bugs.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 7fafd98368b91..2d785b2ca4e2e 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -2523,6 +2523,7 @@ enum srso_mitigation {
>  	SRSO_MITIGATION_IBPB,
>  	SRSO_MITIGATION_IBPB_ON_VMEXIT,
>  	SRSO_MITIGATION_BP_SPEC_REDUCE,
> +	SRSO_MITIGATION_BP_SPEC_REDUCE_NA,
>  };
> 
>  enum srso_mitigation_cmd {
> @@ -2531,6 +2532,7 @@ enum srso_mitigation_cmd {
>  	SRSO_CMD_SAFE_RET,
>  	SRSO_CMD_IBPB,
>  	SRSO_CMD_IBPB_ON_VMEXIT,
> +	SRSO_CMD_BP_SPEC_REDUCE,
>  };
> 
>  static const char * const srso_strings[] = {
> @@ -2542,6 +2544,7 @@ static const char * const srso_strings[] = {
>  	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
>  	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
>  	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation",
> +	[SRSO_MITIGATION_BP_SPEC_REDUCE_NA]	= "Vulnerable: Reduced Speculation, not available",
>  };
> 
>  static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
> @@ -2562,6 +2565,8 @@ static int __init srso_parse_cmdline(char *str)
>  		srso_cmd = SRSO_CMD_IBPB;
>  	else if (!strcmp(str, "ibpb-vmexit"))
>  		srso_cmd = SRSO_CMD_IBPB_ON_VMEXIT;
> +	else if (!strcmp(str, "bp-spec-reduce"))
> +		srso_cmd = SRSO_CMD_BP_SPEC_REDUCE;
>  	else
>  		pr_err("Ignoring unknown SRSO option (%s).", str);
> 
> @@ -2672,12 +2677,8 @@ static void __init srso_select_mitigation(void)
> 
>  ibpb_on_vmexit:
>  	case SRSO_CMD_IBPB_ON_VMEXIT:
> -		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> -			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
> -			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
> -			break;
> -		}
> -
> +		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> +			goto bp_spec_reduce;
>  		if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
>  			if (has_microcode) {
>  				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
> @@ -2694,6 +2695,17 @@ static void __init srso_select_mitigation(void)
>  			pr_err("WARNING: kernel not compiled with MITIGATION_IBPB_ENTRY.\n");
>  		}
>  		break;
> +
> +	case SRSO_CMD_BP_SPEC_REDUCE:
> +		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
> +bp_spec_reduce:

We can put this label above 'case SRSO_CMD_BP_SPEC_REDUCE' for
consistency with the ibpb_on_vmexit label. The
X86_FEATURE_SRSO_BP_SPEC_REDUCE check will be repeated but it shouldn't
matter in practice and the compiler will probably optimize it anyway.

> +			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
> +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
> +			break;
> +		} else {
> +			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE_NA;

Why do we need SRSO_MITIGATION_BP_SPEC_REDUCE_NA? It seems like in other
cases, if some requirements are not met, we just leave srso_mitigation
set SRSO_MITIGATION_NONE.

> +			pr_warn("BP_SPEC_REDUCE not supported!\n");
> +		}
>  	default:
>  		break;
>  	}
> --
> 2.48.1.711.g2feabab25a-goog

