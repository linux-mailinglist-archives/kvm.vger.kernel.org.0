Return-Path: <kvm+bounces-31518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54BE09C456E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A44D283F23
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825F51AAE31;
	Mon, 11 Nov 2024 18:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gza0HCAh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F64C66;
	Mon, 11 Nov 2024 18:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731351433; cv=none; b=PGXX1p1An9/4EvmWzTcT0W8cyUkUlFtVdm8NjMx3An9JrsuMQ4f9s/+D5D3f3CR1hJf40UfRbQsiRDVIklxqxUrY/G3mlUuqVzKDDzsKnwFFVoE+FlAHMD+nvE915oYFy2+H5PHz83p+ZE5qDg7719bkMJ/3de6aaoOnIn4O4qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731351433; c=relaxed/simple;
	bh=CUdqRMF6va/RBZqEIsjEoOVALaWmk9cd0CGaA86pz68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KhEVVnPvvNvf6BncjQN30gvuBqUR35jZrD5z0ZgOOGwN9WJyeqQD+DS67XqVSiEbHATHjeT3O17LaO6w5LDZ12qrh3cqgFtdpCkr/19y7PKA9JF5ic9l0cZk8AR7xZiFKcxjtKJ+bkHy4my+lgywPYvN4XJNilvoTTEM7loZUkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gza0HCAh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731351431; x=1762887431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CUdqRMF6va/RBZqEIsjEoOVALaWmk9cd0CGaA86pz68=;
  b=Gza0HCAhpz3ICOMSivW3PUps4EMaT6F6nIBsNvySKfntmbfCNZLBAcsC
   1/XMGKWvHrU33G2OVKBpEZjLq0ZuJN5ATumfTjwzjV3c5Js1SsCf77toC
   IERnfPFu/Lig9Q77y3JuzSXIJssYynkqkA5xuEyLEfupLhEHoAUMckVhT
   zb7PA8YdfplRqMNMSBRmLkkT5BYWV3AcuuS76gOVP9tB22eQjXjGcT0Js
   R0PgFrQvArPHhNnOQVl0F3+nWtrik1kzI4zD2YYZk3OSJVx7OUrVASdav
   nyjAO9iGnXb8nHvE09y2SxSCqliIPaEPSZQKOzcSy/aGptVFOjiJjyITM
   w==;
X-CSE-ConnectionGUID: J5SxPsyES5+TewMAwdyBJw==
X-CSE-MsgGUID: FMvE8McARwCnJhLvnwimRQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="56562585"
X-IronPort-AV: E=Sophos;i="6.12,145,1728975600"; 
   d="scan'208";a="56562585"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 10:57:10 -0800
X-CSE-ConnectionGUID: qZULbCt9Sxq9bbdlTrKI2w==
X-CSE-MsgGUID: 1N5Qr6EzTU6Q+XpJACtr3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,145,1728975600"; 
   d="scan'208";a="117865995"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.124.223.216]) ([10.124.223.216])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 10:57:09 -0800
Message-ID: <32c73e2c-b4da-4b84-9609-652585fba352@intel.com>
Date: Mon, 11 Nov 2024 10:57:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/3] x86: cpu/bugs: add support for AMD ERAPS
 feature
To: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org
Cc: amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-3-amit@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20241111163913.36139-3-amit@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/24 08:39, Amit Shah wrote:
> Remove explicit RET stuffing / filling on VMEXITs and context
> switches on AMD CPUs with the ERAPS feature (Zen5+).

I'm not a super big fan of how this changelog is constructed.  I
personally really like the "background, problem, solution" form.  This
starts with the solution before even telling us what it is.

> With the Enhanced Return Address Prediction Security feature,  any of
> the following conditions triggers a flush of the RSB (aka RAP in AMD
> manuals) in hardware:
> * context switch (e.g., move to CR3)

IMNHO, context switching is a broader topic that process-to-process
switches.  A user=>kernel thread switch is definitely a context switch,
but doesn't involve a CR3 write.  A user=>user switch in the same mm is
also highly arguable to be a context switch and doesn't involve a CR3
write.  There are userspace threading libraries that do "context switches".

This is further muddled by the very comments you are editing in this
patch like: "unconditionally fill RSB on context switches".

Please be very, very precise in the language that's chosen here.

> * TLB flush
> * some writes to CR4

... and only one of those is relevant for this patch.  Aren't the others
just noise?

> The feature also explicitly tags host and guest addresses in the RSB -
> eliminating the need for explicit flushing of the RSB on VMEXIT.
> 
> [RFC note: We'll wait for the APM to be updated with the real wording,
> but assuming it's going to say the ERAPS feature works the way described
> above, let's continue the discussion re: when the kernel currently calls
> FILL_RETURN_BUFFER, and what dropping it entirely means.
> 
> Dave Hansen pointed out __switch_to_asm fills the RSB each time it's
> called, so let's address the cases there:
> 
> 1. user->kernel switch: Switching from userspace to kernelspace, and
>    then using user-stuffed RSB entries in the kernel is not possible
>    thanks to SMEP.  We can safely drop the FILL_RETURN_BUFFER call for
>    this case.  In fact, this is how the original code was when dwmw2
>    added it originally in c995efd5a.  So while this case currently
>    triggers an RSB flush (and will not after this ERAPS patch), the
>    current flush isn't necessary for AMD systems with SMEP anyway.

This description makes me uneasy.  It basically boils down to, "SMEP
guarantees that the kernel can't consume user-placed RSB entries."

It makes me uneasy because I recall that not holding true on some Intel
CPUs. I believe some CPUs have a partial-width RSB.  Kernel consumption
of a user-placed entry would induce the kernel to speculate to a
*kernel* address so SMEP is rather ineffective.

So, instead of just saying, "SMEP magically fixes everything, trust us",
could we please step through a few of the properties of the hardware and
software that make SMEP effective?

First, I think that you're saying that AMD hardware has a full-width,
precise RSB.  That ensures that speculation always happens back
precisely to the original address, not some weird alias.  Second, ERAPS
guarantees that the the address still has the same stuff mapped there.
Any change to the address space involves either a CR3 write or a TLB
flush, both of which would have flushed any user-placed content in the RSB.

	Aside: Even the kernel-only text poking mm or EFI mm would "just
	work" in this scenario since they have their own mm_structs,
	page tables and root CR3 values.

> 2. user->user or kernel->kernel: If a user->user switch does not result
>    in a CR3 change, it's a different thread in the same process context.
>    That's the same case for kernel->kernel switch.  In this case, the
>    RSB entries are still valid in that context, just not the correct
>    ones in the new thread's context.  It's difficult to imagine this
>    being a security risk.  The current code clearing it, and this patch
>    not doing so for AMD-with-ERAPS, isn't a concern as far as I see.
> ]

The current rules are dirt simple: if the kernel stack gets switched,
the RSB is flushed.  It's kinda hard to have a mismatched stack if it's
never switched in the first place.  That makes the current rules dirt
simple.  The problem (stack switching) is dirt simple to correlate 1:1
with the fix (RSB stuffing).

This patch proposes separating the problem (stack switching) and the
mitigations (implicit new microcode actions).  That's a hell of a lot
more complicated and hardware to audit than the existing rules.  Agreed?

So, how are the rules relaxed?

First, it opens up the case where user threads consume RSB entries from
other threads in the same process. Threads are usually at the same
privilege level.  Instead of using a speculative attack, an attacker
could just read the data directly.  The only place I can imagine this
even remotely being a problem would be if threads were relying on
protection keys to keep secrets from each other.

The kernel consuming RSB entries from another kernel thread seems less
clear.  I disagree with the idea that a valid entry in a given context
is a _safe_ entry though.  Spectre v2 in _general_ involves nasty
speculation to otherwise perfectly safe code. A problematic scenario
would be where kswapd wakes up after waiting for I/O and starts
speculating back along the return path of the userspace thread that
kswapd interrupted. Userspace has some level of control over both stacks
and it doesn't seem super far fetched to think that there could be some
disclosure gadgets in there.

In short: the user-consumes-user-RSB-entry attacks seem fundamentally
improbable because user threads are unlikely to have secrets from each
other.

The kernel-consumes-kernel-RSB-entry attacks seem hard rather than
fundamentally improbable.  I can't even count how many times our "oh
that attack would be too hard to pull off" optimism has gone wrong.

What does that all _mean_?  ERAPS sucks?  Nah.  Maybe we just make sure
that the existing spectre_v2=whatever controls can be used to stop
relying on it if asked.

> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 96b410b1d4e8..f5ee7fc71db5 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -117,6 +117,18 @@
>   * We define a CPP macro such that it can be used from both .S files and
>   * inline assembly. It's possible to do a .macro and then include that
>   * from C via asm(".include <asm/nospec-branch.h>") but let's not go there.
> + *
> + * AMD CPUs with the ERAPS feature may have a larger default RSB.  These CPUs
> + * use the default number of entries on a host, and can optionally (based on
> + * hypervisor setup) use 32 (old) or the new default in a guest.  The number
> + * of default entries is reflected in CPUID 8000_0021:EBX[23:16].
> + *
> + * With the ERAPS feature, RSB filling is not necessary anymore: the RSB is
> + * auto-cleared by hardware on context switches, TLB flushes, or some CR4
> + * writes.  Adapting the value of RSB_CLEAR_LOOPS below for ERAPS would change
> + * it to a runtime variable instead of the current compile-time constant, so
> + * leave it as-is, as this works for both older CPUs, as well as newer ones
> + * with ERAPS.
>   */

This comment feels out of place and noisy to me.  Why the heck would we
need to document the RSB size enumeration here and not use it?

Then this goes on to explain why this patch *didn't* bother to change
RSB_CLEAR_LOOPS.  That seems much more like changelog material than a
code comment to me.

To me, RSB_CLEAR_LOOPS, is for, well, clearing the RSB.  The existing
comments say that some CPUs don't need to clear the RSB.  I don't think
we need further explanation of why one specific CPU doesn't need to
clear the RSB.  The new CPU isn't special.

Something slightly more useful would be to actually read CPUID
8000_0021:EBX[23:16] and compare it to RSB_CLEAR_LOOPS:

void amd_check_rsb_clearing(void)
{
	/*
	 * Systems with both these features off
	 * do not perform RSB clearing:
	 */
	if (!boot_cpu_has(X86_FEATURE_RSB_CTXSW) &&
	    !boot_cpu_has(X86_FEATURE_RSB_VMEXIT))
		return;

	// with actual helpers and mask generation, not this mess:
	rsb_size = (cpuid_ebx(0x80000021) >> 16) & 0xff;

	WARN_ON_ONCE(rsb_size > RSB_CLEAR_LOOPS);
}

That's almost shorter than the proposed comment.

>  #define RETPOLINE_THUNK_SIZE	32
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 0aa629b5537d..02446815b0de 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1818,9 +1818,12 @@ static void __init spectre_v2_select_mitigation(void)
>  	pr_info("%s\n", spectre_v2_strings[mode]);
>  
>  	/*
> -	 * If Spectre v2 protection has been enabled, fill the RSB during a
> -	 * context switch.  In general there are two types of RSB attacks
> -	 * across context switches, for which the CALLs/RETs may be unbalanced.
> +	 * If Spectre v2 protection has been enabled, the RSB needs to be
> +	 * cleared during a context switch.  Either do it in software by
> +	 * filling the RSB, or in hardware via ERAPS.

I'd move this comment about using ERAPS down to the ERAPS check itself.

> +	 * In general there are two types of RSB attacks across context
> +	 * switches, for which the CALLs/RETs may be unbalanced.
>  	 *
>  	 * 1) RSB underflow
>  	 *
> @@ -1848,12 +1851,21 @@ static void __init spectre_v2_select_mitigation(void)
>  	 *    RSB clearing.
>  	 *
>  	 * So to mitigate all cases, unconditionally fill RSB on context
> -	 * switches.
> +	 * switches when ERAPS is not present.
>  	 */
> -	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
> -	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
> +	if (!boot_cpu_has(X86_FEATURE_ERAPS)) {
> +		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
> +		pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
>  
> -	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
> +		/*
> +		 * For guest -> host (or vice versa) RSB poisoning scenarios,
> +		 * determine the mitigation mode here.  With ERAPS, RSB
> +		 * entries are tagged as host or guest - ensuring that neither
> +		 * the host nor the guest have to clear or fill RSB entries to
> +		 * avoid poisoning: skip RSB filling at VMEXIT in that case.
> +		 */
> +		spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
> +	}

This seems to be following a pattern of putting excessive amounts of
very AMD-specific commenting right in the middle of common code.
There's a *HUGE* comment in
spectre_v2_determine_rsb_fill_type_at_vmexit().  Wouldn't this be more
at home there?

>  	/*
>  	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
> @@ -2866,7 +2878,7 @@ static ssize_t spectre_v2_show_state(char *buf)
>  	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
>  		return sysfs_emit(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
>  
> -	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s\n",
> +	return sysfs_emit(buf, "%s%s%s%s%s%s%s%s%s\n",
>  			  spectre_v2_strings[spectre_v2_enabled],
>  			  ibpb_state(),
>  			  boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? "; IBRS_FW" : "",
> @@ -2874,6 +2886,7 @@ static ssize_t spectre_v2_show_state(char *buf)
>  			  boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? "; RSB filling" : "",
>  			  pbrsb_eibrs_state(),
>  			  spectre_bhi_state(),
> +			  boot_cpu_has(X86_FEATURE_ERAPS) ? "; ERAPS hardware RSB flush" : "",
>  			  /* this should always be at the end */
>  			  spectre_v2_module_string());
>  }


