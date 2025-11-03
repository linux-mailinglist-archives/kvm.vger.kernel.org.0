Return-Path: <kvm+bounces-61912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1901FC2E08C
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 21:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CC551898A18
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 20:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0492C159F;
	Mon,  3 Nov 2025 20:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bb/TTmzo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D661DFE26;
	Mon,  3 Nov 2025 20:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762201873; cv=none; b=cSlLzl4mq//yJaeIfkXevgh2quFlVDYUl9q7hSTljLuIZkn+ly4Ri4hmeM1pipglBzqzoehvzobORiD4TY/syja8Hj09jjYQT6GXw2PrJjqlbsqQZLxx+V9NawmXV75va1NjGPAM7JlwIK6cXasCA7U/uJJSkErNLcQ7FWToG+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762201873; c=relaxed/simple;
	bh=v778Iea2GSy92KicvT65BGxZD8ysspDSIEJ0F6r/wbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lTjq3TdnH5kooXbCmrCLeAInLfngHzaaddQ9SQ3z70VFnTjy3nrIkMqybYf/Dh7WpS/LKT+Pn58RP+KVKCj5nDFausS7L7djZUuC4phHzGcZ5UQak/qhm5jZrtLyccmDvv7jQZVwVapoIsNmREcqLSuJ/OmKp1mRuD9D4sHJ2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bb/TTmzo; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762201871; x=1793737871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v778Iea2GSy92KicvT65BGxZD8ysspDSIEJ0F6r/wbE=;
  b=Bb/TTmzoDfXjtD38mvJKZmLzbaGvw1ugLtyX8oW59BEj01Kx1BTftWcP
   K3TO1HBj/qDgsj/lYZrHnFAUcaUu84XQS/IqLmKxRn+WshAQOAeRNTfrn
   NKQiqimdQSxBq4RDfDd3i0uu+WXLZZnt4d0xoOxCORNbxpXVyV9oEzQ5i
   CMQNvuxBFcPH2k9NPbifG2Cywb5QLWVcbnxsM3zjGADZmUNKJ2AP/O/dO
   Co5iWvse/r1LkL/tEWpDCFzBGZMilr1M3QDphUOBrEcpXNIfxnOhpN9Bh
   Xsh1tkxLw+k5O609UT5DLExM+qc8+bXhlPZy76ZRP1CwZIZa0yB1UPGFb
   g==;
X-CSE-ConnectionGUID: Wz/kq1kfSeS6dwJDzwQ/QQ==
X-CSE-MsgGUID: UeI7TeS7RT67KLaiziinGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="66900503"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="66900503"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 12:31:10 -0800
X-CSE-ConnectionGUID: gIAn2H+fR0Wp+9aQN2ul0Q==
X-CSE-MsgGUID: qLqgZrNJSpCz9OoHkpnIyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186253820"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.129]) ([10.125.110.129])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 12:31:11 -0800
Message-ID: <b808c532-44aa-47a0-8fb8-2bdf5b27c3e4@intel.com>
Date: Mon, 3 Nov 2025 12:31:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 David Kaplan <david.kaplan@amd.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/27/25 16:43, Pawan Gupta wrote:
> IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> indirect branch isolation between guest and host userspace. But, a guest
> could still poison the branch history.

This is missing a wee bit of background about how branch history and
indirect branch prediction are involved in VMSCAPE.

> To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> the branch history between guest and userspace. Add cmdline option
> 'vmscape=on' that automatically selects the appropriate mitigation based
> on the CPU.

Is "=on" the right thing here as opposed to "=auto"? What you have here
doesn't actually turn VMSCAPE mitigation on for 'vmscape=on'.

>  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
>  Documentation/admin-guide/kernel-parameters.txt |  4 +-
>  arch/x86/include/asm/cpufeatures.h              |  1 +
>  arch/x86/include/asm/entry-common.h             | 12 +++---
>  arch/x86/include/asm/nospec-branch.h            |  2 +-
>  arch/x86/kernel/cpu/bugs.c                      | 53 ++++++++++++++++++-------
>  arch/x86/kvm/x86.c                              |  5 ++-
>  7 files changed, 61 insertions(+), 24 deletions(-)

I think I'd rather this be three or four or five more patches.

The rename:

> -DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
> +DECLARE_PER_CPU(bool, x86_predictor_flush_exit_to_user);

could be alone by itself.

So could the additional command-line override and its documentation.
(whatever it gets named).

...
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..3d547c3eab4e3290de3eee8e89f21587fee34931 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -499,6 +499,7 @@
>  #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
>  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
>  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
> +#define X86_FEATURE_CLEAR_BHB_EXIT_TO_USER (21*32+17) /* Clear branch history on exit-to-userspace, see VMSCAPE bug */

X86_FEATURE flags are cheap, but they're not infinite. Is this worth two
of these? It actually makes the code actively worse. (See below).

> diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
> index ce3eb6d5fdf9f2dba59b7bad24afbfafc8c36918..b629e85c33aa7387042cce60040b8a493e3e6d46 100644
> --- a/arch/x86/include/asm/entry-common.h
> +++ b/arch/x86/include/asm/entry-common.h
> @@ -94,11 +94,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
>  	 */
>  	choose_random_kstack_offset(rdtsc());
>  
> -	/* Avoid unnecessary reads of 'x86_ibpb_exit_to_user' */
> -	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
> -	    this_cpu_read(x86_ibpb_exit_to_user)) {
> -		indirect_branch_prediction_barrier();
> -		this_cpu_write(x86_ibpb_exit_to_user, false);
> +	if (unlikely(this_cpu_read(x86_predictor_flush_exit_to_user))) {
> +		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
> +			indirect_branch_prediction_barrier();
> +		if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
> +			clear_bhb_long_loop();
> +
> +		this_cpu_write(x86_predictor_flush_exit_to_user, false);
>  	}
>  }

One (mildly) nice thing about the old code was that it could avoid
reading 'x86_predictor_flush_exit_to_user' in the unaffected case.

Also, how does the code generation end up looking here? Each
cpu_feature_enabled() has an alternative, and
indirect_branch_prediction_barrier() has another one. Are we generating
alternatives that can't even possibly happen? For instance, could we
ever have system with X86_FEATURE_IBPB_EXIT_TO_USER but *not*
X86_FEATURE_IBPB?

Let's say this was:

        if (cpu_feature_enabled(X86_FEATURE_FOO_EXIT_TO_USER) &&
            this_cpu_read(x86_ibpb_exit_to_user)) {
		static_call(clear_branch_history);
                this_cpu_write(x86_ibpb_exit_to_user, false);
        }

And the static_call() was assigned to either clear_bhb_long_loop() or
write_ibpb(). I suspect the code generation would be nicer and it would
eliminate one reason for having two X86_FEATUREs.


>  static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
> @@ -3221,6 +3222,8 @@ static int __init vmscape_parse_cmdline(char *str)
>  	} else if (!strcmp(str, "force")) {
>  		setup_force_cpu_bug(X86_BUG_VMSCAPE);
>  		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> +	} else if (!strcmp(str, "on")) {
> +		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
>  	} else {
>  		pr_err("Ignoring unknown vmscape=%s option.\n", str);
>  	}

Yeah, it's goofy that =on sets ..._AUTO.

> @@ -3231,18 +3234,35 @@ early_param("vmscape", vmscape_parse_cmdline);
>  
>  static void __init vmscape_select_mitigation(void)
>  {
> -	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
> -	    !boot_cpu_has(X86_FEATURE_IBPB)) {
> +	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
>  		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>  		return;
>  	}
>  
> -	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
> -		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
> -			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
> -		else
> -			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> +	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO &&
> +	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
> +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> +
> +	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER &&
> +	    !boot_cpu_has(X86_FEATURE_IBPB)) {
> +		pr_err("IBPB not supported, switching to AUTO select\n");
> +		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
>  	}
> +
> +	if (vmscape_mitigation != VMSCAPE_MITIGATION_AUTO)
> +		return;
> +
> +	/*
> +	 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
> +	 * clear sequence. These CPUs are only vulnerable to the BHI variant
> +	 * of the VMSCAPE attack and does not require an IBPB flush.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
> +		vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
> +	else if (boot_cpu_has(X86_FEATURE_IBPB))
> +		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
> +	else
> +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>  }

Yeah, there are a *lot* of logic changes there. Any simplifications by
breaking this up would be appreciated.

>  static void __init vmscape_update_mitigation(void)
> @@ -3261,6 +3281,8 @@ static void __init vmscape_apply_mitigation(void)
>  {
>  	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
>  		setup_force_cpu_cap(X86_FEATURE_IBPB_EXIT_TO_USER);
> +	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER)
> +		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER);
>  }

Yeah, so in that scheme I was talking about a minute ago, this could be
where you do a static_call_update() instead of setting individual
feature bits.


