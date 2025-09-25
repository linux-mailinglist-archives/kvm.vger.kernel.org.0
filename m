Return-Path: <kvm+bounces-58825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0496CBA1B9F
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 00:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4AFD3BD19D
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 22:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF423218B5;
	Thu, 25 Sep 2025 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GvyB9qo4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C58319870;
	Thu, 25 Sep 2025 22:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758837780; cv=none; b=q3TtapKZBNnRod7zueOf2ttDQH1RaP0L/P+G4HyfPrmusiTMUMbmCGyfGDgpOFkcwM583PynYctFZKue77cU4iMKN/7+4JKuxmA5YiYpnY4LdqWk59yQh90sf+OWnX3HBYekpycYPThYOzByTwxnVous9mMVvoNX7yekYhN8tc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758837780; c=relaxed/simple;
	bh=kENjEMfJS4P0fKtr8yOl/LwdTi6bHeEMuxVxAnOTaCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CeVw+cdyfGtDMPMLsm9whmptwZZ+hGddjwl7BHCNeNIBAhcQyFAnI8FOEJe+pGiC8kBeGBijoGFlfh8R0h1MhM28Yb4t/bFh0rvpYuUgOmkD3MSmh9xqv9wMgxGtuBwYSFbyW64NDBU1BivbIbu07jAtwbpYrTg/HROWjDdvPAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GvyB9qo4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758837778; x=1790373778;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kENjEMfJS4P0fKtr8yOl/LwdTi6bHeEMuxVxAnOTaCw=;
  b=GvyB9qo4n69tWoAI9HuaT9/Wmqrl96NRD+i+0Niue3sVnYEUvXswITRN
   G789qUfqJ7jYcL67E74WVe8WMyV1wYUWdj6UBBHoch2pyTmmlgTJscETj
   yKLeYKeTwhynE1SpsZVfFOB1bFS8hrV16ffjBSikMECbI+zntGSe8WOHv
   ToRHjdCyrdnU1SMTDN+eyRVCvX2PfNPNhE6cGCUZY7OTltHMdrQKCFFac
   b99PQBBW1boDoOxH611TF+MG+wOMLFhTouIfeaKTy0U8NejaDP3Y/1HEe
   pi+0ArwmbsZEHSQpY/wGkVlHBxl0zd/xJRzzfvOPkwWu23bt3TARpwCyb
   w==;
X-CSE-ConnectionGUID: +6tPH+1hQMCN//l5T2lZEQ==
X-CSE-MsgGUID: hxsM4aAQTHCBK7AcgtfWDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63802779"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="63802779"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 15:02:57 -0700
X-CSE-ConnectionGUID: c3FBl/1YRFqy+hQ10f+jDw==
X-CSE-MsgGUID: guW1hGW4ScicZ8voTpL6YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="181836387"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.190])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 15:02:57 -0700
Date: Thu, 25 Sep 2025 15:02:51 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Message-ID: <20250925220251.qfn3w6rukhqr4lcs@desk>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
 <LV3PR12MB9265478E85AA940EF6EA4D7D941FA@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV3PR12MB9265478E85AA940EF6EA4D7D941FA@LV3PR12MB9265.namprd12.prod.outlook.com>

On Thu, Sep 25, 2025 at 06:14:54PM +0000, Kaplan, David wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> > -----Original Message-----
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > Sent: Wednesday, September 24, 2025 10:10 PM
> > To: x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; Josh Poimboeuf
> > <jpoimboe@kernel.org>; Kaplan, David <David.Kaplan@amd.com>; Sean
> > Christopherson <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.com>
> > Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Asit Mallick
> > <asit.k.mallick@intel.com>; Tao Zhang <tao1.zhang@intel.com>
> > Subject: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear on exit
> > to userspace
> >
> > Caution: This message originated from an External Source. Use proper caution
> > when opening attachments, clicking links, or responding.
> >
> >
> > IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
> > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > indirect branch isolation between guest and host userspace. But, a guest
> > could still poison the branch history.
> >
> > To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> > the branch history between guest and userspace. Add cmdline option
> > 'vmscape=auto' that automatically selects the appropriate mitigation based
> > on the CPU.
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 +++++
> >  Documentation/admin-guide/kernel-parameters.txt |  4 ++-
> >  arch/x86/include/asm/cpufeatures.h              |  1 +
> >  arch/x86/include/asm/entry-common.h             | 12 ++++---
> >  arch/x86/include/asm/nospec-branch.h            |  2 +-
> >  arch/x86/kernel/cpu/bugs.c                      | 44 ++++++++++++++++++-------
> >  arch/x86/kvm/x86.c                              |  5 +--
> >  7 files changed, 55 insertions(+), 21 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst
> > b/Documentation/admin-guide/hw-vuln/vmscape.rst
> > index
> > d9b9a2b6c114c05a7325e5f3c9d42129339b870b..13ca98f952f97daeb28194c3873e
> > 945b85eda6a1 100644
> > --- a/Documentation/admin-guide/hw-vuln/vmscape.rst
> > +++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
> > @@ -86,6 +86,10 @@ The possible values in this file are:
> >     run a potentially malicious guest and issues an IBPB before the first
> >     exit to userspace after VM-exit.
> >
> > + * 'Mitigation: Clear BHB before exit to userspace':
> > +
> > +   As above conditional BHB clearing mitigation is enabled.
> > +
> >   * 'Mitigation: IBPB on VMEXIT':
> >
> >     IBPB is issued on every VM-exit. This occurs when other mitigations like
> > @@ -108,3 +112,7 @@ The mitigation can be controlled via the ``vmscape=``
> > command line parameter:
> >
> >     Force vulnerability detection and mitigation even on processors that are
> >     not known to be affected.
> > +
> > + * ``vmscape=auto``:
> > +
> > +   Choose the mitigation based on the VMSCAPE variant the CPU is affected by.
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt
> > b/Documentation/admin-guide/kernel-parameters.txt
> > index
> > 5a7a83c411e9c526f8df6d28beb4c784aec3cac9..4596bfcb401f1a89d2dc5ed8c44c8
> > 3628c9c5dfe 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -8048,9 +8048,11 @@
> >
> >                         off             - disable the mitigation
> >                         ibpb            - use Indirect Branch Prediction Barrier
> > -                                         (IBPB) mitigation (default)
> > +                                         (IBPB) mitigation
> >                         force           - force vulnerability detection even on
> >                                           unaffected processors
> > +                       auto            - (default) automatically select IBPB
> > +                                         or BHB clear mitigation based on CPU
> 
> Many of the other bugs (like srso, l1tf, bhi, etc.) do not have explicit
> 'auto' options as 'auto' is implied by the lack of an explicit option.
> Is there really value in creating an explicit 'auto' option here?

Hmm, so to get the BHB clear mitigation do we advise the users to remove
the vmscape= parameter? That feels a bit weird to me. Also, with
CONFIG_MITIGATION_VMSCAPE=n a user can get IBPB mitigation with
vmscape=ibpb, but there is not way to get the BHB clear mitigation.

> >  u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
> >
> > @@ -3270,13 +3269,15 @@ enum vmscape_mitigations {
> >         VMSCAPE_MITIGATION_AUTO,
> >         VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
> >         VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
> > +       VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
> >  };
> >
> >  static const char * const vmscape_strings[] = {
> > -       [VMSCAPE_MITIGATION_NONE]               = "Vulnerable",
> > +       [VMSCAPE_MITIGATION_NONE]                       = "Vulnerable",
> >         /* [VMSCAPE_MITIGATION_AUTO] */
> > -       [VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]  = "Mitigation: IBPB
> > before exit to userspace",
> > -       [VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]     = "Mitigation: IBPB on
> > VMEXIT",
> > +       [VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]          = "Mitigation: IBPB
> > before exit to userspace",
> > +       [VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]             = "Mitigation: IBPB on
> > VMEXIT",
> > +       [VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]     = "Mitigation:
> > Clear BHB before exit to userspace",
> >  };
> >
> >  static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
> > @@ -3294,6 +3295,8 @@ static int __init vmscape_parse_cmdline(char *str)
> >         } else if (!strcmp(str, "force")) {
> >                 setup_force_cpu_bug(X86_BUG_VMSCAPE);
> >                 vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> > +       } else if (!strcmp(str, "auto")) {
> > +               vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> >         } else {
> >                 pr_err("Ignoring unknown vmscape=%s option.\n", str);
> >         }
> > @@ -3304,14 +3307,28 @@ early_param("vmscape", vmscape_parse_cmdline);
> >
> >  static void __init vmscape_select_mitigation(void)
> >  {
> > -       if (cpu_mitigations_off() ||
> > -           !boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
> > -           !boot_cpu_has(X86_FEATURE_IBPB)) {
> > +       if (cpu_mitigations_off() || !boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
> >                 vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> >                 return;
> >         }
> 
> It looks like this patch is based on a tree without vmscape attack vector
> support, I think you may want to rebase on top of that since it reworked
> some of this function.

Yes, it is based on upstream. I will rebase it once we are close to a final
version. I tend to base my patches on upstream to avoid any issues when tip
branches get rebased.

> > -       if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO)
> > +       if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER
> > &&
> > +           !boot_cpu_has(X86_FEATURE_IBPB)) {
> > +               pr_err("IBPB not supported, switching to AUTO select\n");
> > +               vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> > +       }
> 
> I think there's a bug here in case you (theoretically) had a vulnerable
> CPU that did not have IBPB and did not have BHI_CTRL. In that case, we
> should select VMSCAPE_MITIGATION_NONE as we have no mitigation available.
> But the code below will still re-select IBPB I believe even though there
> is no IBPB.

Yes, you are right. Let me see how to fix that.

