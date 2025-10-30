Return-Path: <kvm+bounces-61515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C1DC21D0C
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C15BF1A6538C
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEA436CE05;
	Thu, 30 Oct 2025 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPjUJc5N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2001F37DA;
	Thu, 30 Oct 2025 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761849847; cv=none; b=ipQMa35/U3urnpPYS989xT4wPWHvQpQlUuPPGq+JtGlUL4URfbYrxZUmDXhx4D6hUo8DHX75/H1C3xkKVfzmq/Q6GXOXXIjnKLPdbxr7UXzpV3AtSOrdYgKFK/xIGAg4a+dcNNC77aSQJlcb7DeHz/tEVr1eoybes1ycr7swgzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761849847; c=relaxed/simple;
	bh=b2/YyhhpEcCX7pH+JIsasIXaCh+uVNODB0DRCV3TVIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWZDOe/wK2K8kJzfinQ5zOTxT5kPIp7guIwfTNAN34dprXtSz0OyYKnYc9TZx02eGqed59I+CJ1HldK4cIWiTCSorc+NYRwNrLNdgpYHp/2rBfLykvIopK9P21pBgaHbeCcXNnjRtSy+azOf6m0S4W5LbMC8Gs9YxcCOruwjyvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPjUJc5N; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761849845; x=1793385845;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b2/YyhhpEcCX7pH+JIsasIXaCh+uVNODB0DRCV3TVIs=;
  b=VPjUJc5N9WFWP4mUoSFtsb6cRdoi7G8BF2EBTVGLfA4ifg31m1Hy/X09
   kkFlD64tT9RPu0aAqrj/HbCqjw8hzqHLEp9T8flx4vsNSDcPLEHA+uehM
   ubg/lTrENWVFYH7Is6rwLJF6t5rDX2OP3eepLkdo296dn/v1FrqndTbl0
   ny70b4yR5TT4ts5FIxfwb0c8j0rYST+/5A/Fb3seMK7wAP9CeAYE7Sw/d
   RO94QEfgB01hCE3ETEMI9nXquqdAUSWs7/exHDj65Ew2rEPe9pFtOYemc
   ZIq0ihbWnvIY2mWHNJtN9PR0k5zgP6m/o5MtPCKmDG1dcaVogmJppvh5F
   Q==;
X-CSE-ConnectionGUID: MKT6BtPBTIuanOJt4oj7pw==
X-CSE-MsgGUID: YMQcMCmnRy+Wp7vl4TenlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="67656048"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="67656048"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 11:44:04 -0700
X-CSE-ConnectionGUID: A2sQBI39TjS2bRJYnKTUxA==
X-CSE-MsgGUID: jojEQxFYSdKERSCkmvorkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185239667"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 11:44:03 -0700
Date: Thu, 30 Oct 2025 11:43:54 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 1/3] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251030184354.qwulxmbxkt6thu6b@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com>
 <DDVNNDVOE49L.1F77ZUNBVTR1I@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDVNNDVOE49L.1F77ZUNBVTR1I@google.com>

On Thu, Oct 30, 2025 at 12:28:06PM +0000, Brendan Jackman wrote:
> On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> > TSA mitigation:
> >
> >   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
> >
> > introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> > CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> > (kernel->user also).
> >
> > Make mitigations on Intel consistent with TSA. This would help handling the
> > guest-only mitigations better in future.
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/bugs.c | 9 +++++++--
> >  arch/x86/kvm/vmx/vmenter.S | 3 ++-
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index d7fa03bf51b4517c12cc68e7c441f7589a4983d1..6d00a9ea7b4f28da291114a7a096b26cc129b57e 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -194,7 +194,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
> >  
> >  /*
> >   * Controls CPU Fill buffer clear before VMenter. This is a subset of
> > - * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
> > + * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
> >   * mitigation is required.
> >   */
> 
> So if I understand correctly with this patch the aim is:
> 
> X86_FEATURE_CLEAR_CPU_BUF means verw before exit to usermode
> 
> X86_FEATURE_CLEAR_CPU_BUF_VM means unconditional verw before VM Enter
> 
> cpu_buf_vm_clear[_mmio_only] means verw before VM Enter for
> MMIO-capable guests.

Yup, thats the goal.

> Since this is being cleaned up can we also:
> 
> - Update the definition of X86_FEATURE_CLEAR_CPU_BUF in cpufeatures.h to
>   say what context it applies to (now it's specifically exit to user)
> 
> - Clear up how verw_clear_cpu_buf_mitigation_selected relates to these
>   two flags. Thinking aloud here... it looks like this is set:
> 
>   - If MDS mitigations are on, meaning both flags are set
> 
>   - If TAA mitigations are on, meaning both flags are set
> 
>   - If MMIO mitigations are on, and the CPU has MDS or TAA. In this case
>     both flags are set, but this causality is messier.
> 
>   - If RFDS mitigations are on and supported, meaning both flags are set
> 
>   So if I'm reading this correctly whenever
>   verw_clear_cpu_buf_mitigation_selected we should expect both flags
>   enabled. So I think all that's needed is to add a reference to
>   X86_FEATURE_CLEAR_CPU_BUF_VM to the comment?

Yes. I will update the comment accordingly.

> I think we also need to update the assertion of vmx->disable_fb_clear?

I am not quite sure about the update needed. Could you please clarify?

> Anyway thanks this seems like a very clear improvement to me.

Thanks for the review and suggestions!

