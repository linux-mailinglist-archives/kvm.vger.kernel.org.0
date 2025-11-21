Return-Path: <kvm+bounces-64223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BEBC7B5BD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ECF7335CCA2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBBC2F25F8;
	Fri, 21 Nov 2025 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxsIh2EF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCB42C21CC;
	Fri, 21 Nov 2025 18:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763750516; cv=none; b=dcKaABoGopd0EWC2M0sR2zzqc5jAv4Dvg6cHeOh2rowk/G+r0Zs2a3Y1tLYxt2yIb8Pvr5p3wn/iIHodc1yVRiVn+eK6r3pZXKLpomyLDOq4EJ5wgAsLxSbp+Zr1j2OKxKGHh8uW0A8eDeiB4wLeEWOBzLICiTjz+/iUiWSrDDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763750516; c=relaxed/simple;
	bh=nwmN7R39GDJ2L3/SUroVYPZiBkP9m/MB58zo74SpJxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSf4bEJ1DCgLgU4iI/mScWtOmTUA0NswvcFYNMQ3nCZDWTxrCh6D6+/CcNZfQzgJSoNby2+06o2xA+QAQTBFi4dkbwro/IMy07CATgIbCjFRNmGYvtGkHfaqOkkRweNwXicBlud9tDdgCQ+O8z4JKQVHvHLDGlOCIvnKOvLVU44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nxsIh2EF; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763750514; x=1795286514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nwmN7R39GDJ2L3/SUroVYPZiBkP9m/MB58zo74SpJxU=;
  b=nxsIh2EFAhPoobDF7A8suflGzFmKMk4SrDOGHT7VUsduJBWWFVW8lSpV
   07aJNcQHoPgJ/jZWxCWa0vC6bfHudqxueBMz12JHGTcJY/WqLsSMN+NJ6
   rbehXvRczZSXvknVaq5zWR22WZW95mX2l91s1GWDc0y7VC99drHGNEUqh
   uJ+65tlFbNECRuTVHUjQJHKQLIUBoZnm93ikZCwvd0juZKHk7yu/6hfFM
   8MFM2kn9La94pVGEv7g1qv/2VOiHdncjts/7M9V3cq9s3cktzatuh507y
   6GYv+B2dEFQT2ginusScRFgLpLaKLu9GO/exyPDXy2UpMyLLsAv/5pvHq
   Q==;
X-CSE-ConnectionGUID: fF0WTt98TwS0mfs0e6C3aw==
X-CSE-MsgGUID: fsYvwW+URf+A0dXmQ4wXkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="65891118"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="65891118"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 10:41:53 -0800
X-CSE-ConnectionGUID: EDeE34IvT9GUnp7YFOc+fg==
X-CSE-MsgGUID: ZbxiWgqoQkuqngmf6nM7lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="196898869"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 10:41:53 -0800
Date: Fri, 21 Nov 2025 10:41:48 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 09/11] x86/vmscape: Deploy BHB clearing mitigation
Message-ID: <20251121184148.hi6ye2trohwjm3oe@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
 <5cdca004-5228-4f07-b9b8-901880f59bb7@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cdca004-5228-4f07-b9b8-901880f59bb7@suse.com>

On Fri, Nov 21, 2025 at 04:23:56PM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/20/25 08:19, Pawan Gupta wrote:
> > IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
> > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > indirect branch isolation between guest and host userspace. However, branch
> > history from guest may also influence the indirect branches in host
> > userspace.
> > 
> > To mitigate the BHI aspect, use clear_bhb_loop().
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >   Documentation/admin-guide/hw-vuln/vmscape.rst |  4 ++++
> >   arch/x86/include/asm/nospec-branch.h          |  2 ++
> >   arch/x86/kernel/cpu/bugs.c                    | 30 ++++++++++++++++++++-------
> >   3 files changed, 29 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
> > index d9b9a2b6c114c05a7325e5f3c9d42129339b870b..dc63a0bac03d43d1e295de0791dd6497d101f986 100644
> > --- a/Documentation/admin-guide/hw-vuln/vmscape.rst
> > +++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
> > @@ -86,6 +86,10 @@ The possible values in this file are:
> >      run a potentially malicious guest and issues an IBPB before the first
> >      exit to userspace after VM-exit.
> > + * 'Mitigation: Clear BHB before exit to userspace':
> > +
> > +   As above, conditional BHB clearing mitigation is enabled.
> > +
> >    * 'Mitigation: IBPB on VMEXIT':
> >      IBPB is issued on every VM-exit. This occurs when other mitigations like
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 15a2fa8f2f48a066e102263513eff9537ac1d25f..1e8c26c37dbed4256b35101fb41c0e1eb6ef9272 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -388,6 +388,8 @@ extern void write_ibpb(void);
> >   #ifdef CONFIG_X86_64
> >   extern void clear_bhb_loop(void);
> > +#else
> > +static inline void clear_bhb_loop(void) {}
> >   #endif
> >   extern void (*x86_return_thunk)(void);
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index cbb3341b9a19f835738eda7226323d88b7e41e52..d12c07ccf59479ecf590935607394492c988b2ff 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -109,9 +109,8 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
> >   EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
> >   /*
> > - * Set when the CPU has run a potentially malicious guest. An IBPB will
> > - * be needed to before running userspace. That IBPB will flush the branch
> > - * predictor content.
> > + * Set when the CPU has run a potentially malicious guest. Indicates that a
> > + * branch predictor flush is needed before running userspace.
> >    */
> >   DEFINE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
> >   EXPORT_PER_CPU_SYMBOL_GPL(x86_predictor_flush_exit_to_user);
> > @@ -3200,13 +3199,15 @@ enum vmscape_mitigations {
> >   	VMSCAPE_MITIGATION_AUTO,
> >   	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
> >   	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
> > +	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
> >   };
> >   static const char * const vmscape_strings[] = {
> > -	[VMSCAPE_MITIGATION_NONE]		= "Vulnerable",
> > +	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
> >   	/* [VMSCAPE_MITIGATION_AUTO] */
> > -	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]	= "Mitigation: IBPB before exit to userspace",
> > -	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT",
> > +	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
> > +	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
> > +	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
> >   };
> >   static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
> > @@ -3253,8 +3254,19 @@ static void __init vmscape_select_mitigation(void)
> >   			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> >   		break;
> > +	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
> > +		if (!boot_cpu_has(X86_FEATURE_BHI_CTRL))
> > +			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> > +		break;
> 
> Am I missing something or this case can never execute because
> VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER is only ever set if mitigation is
> VMSCAPE_MITIGATION_AUTO in the below branch? Perhaps just remove it? This
> just shows how confusing the logic for choosing the mitigations has
> become....

The goal was not make any assumptions on what vmscape_parse_cmdline() can
and cannot set. If you feel strongly about it, I can remove this case.

> >   	case VMSCAPE_MITIGATION_AUTO:
> > -		if (boot_cpu_has(X86_FEATURE_IBPB))
> > +		/*
> > +		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
> > +		 * clear sequence. These CPUs are only vulnerable to the BHI variant
> > +		 * of the VMSCAPE attack and does not require an IBPB flush.
> > +		 */
> > +		if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
> > +			vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
> > +		else if (boot_cpu_has(X86_FEATURE_IBPB))
> >   			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
> >   		else
> >   			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> 
> 
> <snip>
> 

