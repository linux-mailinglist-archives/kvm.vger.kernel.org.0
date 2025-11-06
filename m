Return-Path: <kvm+bounces-62245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48840C3DE00
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 00:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A6F73A5F0F
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 23:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D17350A3A;
	Thu,  6 Nov 2025 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="StwribzF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F962EBDD6;
	Thu,  6 Nov 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472465; cv=none; b=paOZEfgiKNHdRlvYb8BfjWwzFyC9hXHTwzEgM6D8s5b+cCWyfNqykeDA8wL2rUnx4VinFbZCMhRszCeZRFfzJ0+JQsbwhzH/hPeMTjeSinWAfEozNMpNaIEjL8qK//DxoPhUWoWLAPWbyI+g+3YNq44K5Yhosq1/O/+kq7v+cHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472465; c=relaxed/simple;
	bh=m7IwhM/JVsofJPnzNF9rHIXw+lW6+tvKLrZu9897zjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blXxZikyTgxTnwnCRrVRlk8dxQmKN0Eq8bFJKv47XcLOWi+2BlsHFVC38K0sCfgXiIDu9SO+p6oGmSOtCuFGfsKYvgRKWOYv+5NZTsd3L4Tw0ImL4DtNVq1GXmxyH8MHUcZlcyMe9CJdx00cVtBk5SWJAETx1TJfu/Jp0Dg6utU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=StwribzF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762472463; x=1794008463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m7IwhM/JVsofJPnzNF9rHIXw+lW6+tvKLrZu9897zjY=;
  b=StwribzFegwCo1iSC5iaIcZJLs6x4CiA7c2CRjOqMQK1srJrqwGIMW99
   tgt4mDpnHrhguDQZP1ylav4eE+0eWwl65tYHgy17Agi6bbfKnjs7uGF/S
   Cpp2orYWedUM/m6bQDn8L08JMbTkpnz2T9bVEeCxtzfSM9DNbhME5jLFF
   gGP3ye/hvrI63z/7I1ebXuuhHU+OGLr1aURbq7B7yDXoXk6/U5pTIEbQw
   b5DqCnia4uGJiVC7UCOB7oK/x/+trBjI1gEpGb0b1MA4IUj751FIpMjZX
   bOR+I+Q4g/LH9AnFfMyPNFiLEcEt8wS/95Hxa6UClBR4HE5kBp9puwzmH
   A==;
X-CSE-ConnectionGUID: W/9omFCjRhGF3WiEPE8cGA==
X-CSE-MsgGUID: fg2JQZAuSsalE1NrOS4AaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="63634265"
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="63634265"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 15:41:01 -0800
X-CSE-ConnectionGUID: gb5HyUiuQtKGBDXfL9dTNQ==
X-CSE-MsgGUID: B7tZYuwMSoiySzlwvqeTKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,285,1754982000"; 
   d="scan'208";a="188330869"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO desk) ([10.124.221.253])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 15:41:01 -0800
Date: Thu, 6 Nov 2025 15:40:55 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
Message-ID: <20251106234055.ftahbvqxrfzjwr6t@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
 <b808c532-44aa-47a0-8fb8-2bdf5b27c3e4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b808c532-44aa-47a0-8fb8-2bdf5b27c3e4@intel.com>

[ I drafted the reply this this email earlier, but forgot to send it, sorry. ]

On Mon, Nov 03, 2025 at 12:31:09PM -0800, Dave Hansen wrote:
> On 10/27/25 16:43, Pawan Gupta wrote:
> > IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
> > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > indirect branch isolation between guest and host userspace. But, a guest
> > could still poison the branch history.
> 
> This is missing a wee bit of background about how branch history and
> indirect branch prediction are involved in VMSCAPE.

Adding more background to this.

> > To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> > the branch history between guest and userspace. Add cmdline option
> > 'vmscape=on' that automatically selects the appropriate mitigation based
> > on the CPU.
> 
> Is "=on" the right thing here as opposed to "=auto"?

v1 had it as =auto, David Kaplan made a point that for attack vector controls
"auto" means "defer to attack vector controls":

  https://lore.kernel.org/all/LV3PR12MB9265B1C6D9D36408539B68B9941EA@LV3PR12MB9265.namprd12.prod.outlook.com/

  "Maybe a better solution instead is to add a new option 'vmscape=on'.

  If we look at the other most recently added bugs like TSA and ITS, neither
  have an explicit 'auto' cmdline option.  But they do have 'on' cmdline
  options.

  The difference between 'auto' and 'on' is that 'auto' defers to the attack
  vector controls while 'on' means 'enable this mitigation if the CPU is
  vulnerable' (as opposed to 'force' which will enable it even if not
  vulnerable).

  An explicit 'vmscape=on' could give users an option to ensure the
  mitigation is used (regardless of attack vectors) and could choose the best
  mitigation (BHB clear if available, otherwise IBPB).

  I'd still advise users to not specify any option here unless they know what
  they're doing.  But an 'on' option would arguably be more consistent with
  the other recent bugs and maybe meets the needs you're after?"

> What you have here doesn't actually turn VMSCAPE mitigation on for
> 'vmscape=on'.

It picks between BHB-clear and IBPB, but it still turns 'on' the
mitigation. Maybe I am misunderstanding you?

> >  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 ++++
> >  Documentation/admin-guide/kernel-parameters.txt |  4 +-
> >  arch/x86/include/asm/cpufeatures.h              |  1 +
> >  arch/x86/include/asm/entry-common.h             | 12 +++---
> >  arch/x86/include/asm/nospec-branch.h            |  2 +-
> >  arch/x86/kernel/cpu/bugs.c                      | 53 ++++++++++++++++++-------
> >  arch/x86/kvm/x86.c                              |  5 ++-
> >  7 files changed, 61 insertions(+), 24 deletions(-)
> 
> I think I'd rather this be three or four or five more patches.
>
> The rename:
> 
> > -DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
> > +DECLARE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
> 
> could be alone by itself.
> 
> So could the additional command-line override and its documentation.
> (whatever it gets named).

On it.

> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..3d547c3eab4e3290de3eee8e89f21587fee34931 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -499,6 +499,7 @@
> >  #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
> >  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
> >  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
> > +#define X86_FEATURE_CLEAR_BHB_EXIT_TO_USER (21*32+17) /* Clear branch history on exit-to-userspace, see VMSCAPE bug */
> 
> X86_FEATURE flags are cheap, but they're not infinite. Is this worth two
> of these? It actually makes the code actively worse. (See below).
>
> > diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
> > index ce3eb6d5fdf9f2dba59b7bad24afbfafc8c36918..b629e85c33aa7387042cce60040b8a493e3e6d46 100644
> > --- a/arch/x86/include/asm/entry-common.h
> > +++ b/arch/x86/include/asm/entry-common.h
> > @@ -94,11 +94,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
> >  	 */
> >  	choose_random_kstack_offset(rdtsc());
> >  
> > -	/* Avoid unnecessary reads of 'x86_ibpb_exit_to_user' */
> > -	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
> > -	    this_cpu_read(x86_ibpb_exit_to_user)) {
> > -		indirect_branch_prediction_barrier();
> > -		this_cpu_write(x86_ibpb_exit_to_user, false);
> > +	if (unlikely(this_cpu_read(x86_predictor_flush_exit_to_user))) {
> > +		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
> > +			indirect_branch_prediction_barrier();
> > +		if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
> > +			clear_bhb_long_loop();
> > +
> > +		this_cpu_write(x86_predictor_flush_exit_to_user, false);
> >  	}
> >  }
> 
> One (mildly) nice thing about the old code was that it could avoid
> reading 'x86_predictor_flush_exit_to_user' in the unaffected case.

Yes.

> Also, how does the code generation end up looking here? Each
> cpu_feature_enabled() has an alternative, and
> indirect_branch_prediction_barrier() has another one. Are we generating
> alternatives that can't even possibly happen? For instance, could we
> ever have system with X86_FEATURE_IBPB_EXIT_TO_USER but *not*
> X86_FEATURE_IBPB?

No, without IBPB X86_FEATURE_IBPB_EXIT_TO_USER won't be set. As you
suggested below, static_call() can call write_ibpb() directly in this case.

> Let's say this was:
> 
>         if (cpu_feature_enabled(X86_FEATURE_FOO_EXIT_TO_USER) &&

With static_call() we could also live without X86_FEATURE_FOO_EXIT_TO_USER,
but ...

>             this_cpu_read(x86_ibpb_exit_to_user)) {

... it has a slight drawback that we read this always.

> 		static_call(clear_branch_history);
>                 this_cpu_write(x86_ibpb_exit_to_user, false);
>         }
> 
> And the static_call() was assigned to either clear_bhb_long_loop() or
> write_ibpb(). I suspect the code generation would be nicer and it would
> eliminate one reason for having two X86_FEATUREs.

Agree.

> >  static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
> > @@ -3221,6 +3222,8 @@ static int __init vmscape_parse_cmdline(char *str)
> >  	} else if (!strcmp(str, "force")) {
> >  		setup_force_cpu_bug(X86_BUG_VMSCAPE);
> >  		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> > +	} else if (!strcmp(str, "on")) {
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> >  	} else {
> >  		pr_err("Ignoring unknown vmscape=%s option.\n", str);
> >  	}
> 
> Yeah, it's goofy that =on sets ..._AUTO.

Yes, we can go back to =auto. David, I hope it is not too big of a problem
with attack vector controls?

> > @@ -3231,18 +3234,35 @@ early_param("vmscape", vmscape_parse_cmdline);
> >  
> >  static void __init vmscape_select_mitigation(void)
> >  {
> > -	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
> > -	    !boot_cpu_has(X86_FEATURE_IBPB)) {
> > +	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
> >  		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> >  		return;
> >  	}
> >  
> > -	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
> > -		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
> > -			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
> > -		else
> > -			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> > +	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO &&
> > +	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> > +
> > +	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER &&
> > +	    !boot_cpu_has(X86_FEATURE_IBPB)) {
> > +		pr_err("IBPB not supported, switching to AUTO select\n");
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> >  	}
> > +
> > +	if (vmscape_mitigation != VMSCAPE_MITIGATION_AUTO)
> > +		return;
> > +
> > +	/*
> > +	 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
> > +	 * clear sequence. These CPUs are only vulnerable to the BHI variant
> > +	 * of the VMSCAPE attack and does not require an IBPB flush.
> > +	 */
> > +	if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
> > +	else if (boot_cpu_has(X86_FEATURE_IBPB))
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
> > +	else
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> >  }
> 
> Yeah, there are a *lot* of logic changes there. Any simplifications by
> breaking this up would be appreciated.

Into multiple patches, I guess? Will do.

> >  static void __init vmscape_update_mitigation(void)
> > @@ -3261,6 +3281,8 @@ static void __init vmscape_apply_mitigation(void)
> >  {
> >  	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
> >  		setup_force_cpu_cap(X86_FEATURE_IBPB_EXIT_TO_USER);
> > +	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER)
> > +		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER);
> >  }
> 
> Yeah, so in that scheme I was talking about a minute ago, this could be
> where you do a static_call_update() instead of setting individual
> feature bits.

Yes, and we can avoid both IBPB_EXIT_TO_USER and CLEAR_BHB_EXIT_TO_USER
feature flags.

