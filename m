Return-Path: <kvm+bounces-8490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED77384FE93
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CAC0B22932
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 21:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2772F38DED;
	Fri,  9 Feb 2024 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OvaBsloV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B800338DE2;
	Fri,  9 Feb 2024 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707513320; cv=none; b=UcfA5qZii5+mfjiZQNAUGYc+04M+em+2OR3+j6hLDBCLpKPvxLijhnZ28Bhd0H9xO3LQswxsgvY6geeE0mciLxfa8nGXw11Ikn/a8hisseHWoA8Fq2kqtf1K4eJ27II8+KfNFhZZxBMo+/ocEiAlBrNLKNdJ1HcWZA/KFX7tn+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707513320; c=relaxed/simple;
	bh=bLwLDRiLrzzncRfUt2Z3stvU75dWY+MU+xvqYW1SNpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHfEY+8tImKFfsVOqvfit7bNrye46rH3wNCmvDJU9UkVqNDdxAmQA/RfQPFM3s1YsGQo38qhxqgnvBKMAe5h7TM0qYmj0CttSRKVTFTuwUk/TDv1nUU1uDWkuUqu8LIhWjfF4uzw69P64wsGJJmbT8DFbBufYIVQbYezH/FkNrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OvaBsloV; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707513319; x=1739049319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bLwLDRiLrzzncRfUt2Z3stvU75dWY+MU+xvqYW1SNpU=;
  b=OvaBsloVLCE8ixZC+8KKieRUyKdn1TvRdPFvQ3ECZvJhWoFKp2TCrUa/
   7ksNZF4hf3pgN4K5NVopfgjZBFBvCfpAL4WUCfLwsOKRxGpgA3t9uecy9
   4wNgs7hsAaHm1IyjCek0d8A8Xm4pMr+7eYcFkZC8TFw0nQXKQq3UeFhKs
   BcQL0dMyb9z7XZlTbgcvwR0rUqshOXj438Q+JgAWDfS2V6REj2QgJXGbL
   GWdgVMAQt27HMGpXF4F3pKXksGaBRFVsyeRnowD4RtYTQ4RIbaArusKvw
   UuaDShzcIyTyhHBhnCi+fgqv/i0sXFKujTksKDpT0bRr/wgwe2NOL9wa9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="1818608"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="1818608"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 13:15:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="6646939"
Received: from karenaba-mobl1.amr.corp.intel.com (HELO desk) ([10.209.64.107])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 13:15:16 -0800
Date: Fri, 9 Feb 2024 13:15:15 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Alyssa Milburn <alyssa.milburn@intel.com>, stable@kernel.org
Subject: Re: [PATCH  v7 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240209211515.kvpnka7znwkcpokf@desk>
References: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
 <20240204-delay-verw-v7-1-59be2d704cb2@linux.intel.com>
 <20240209172843.GUZcZgy7EktXgKZQoc@fat_crate.local>
 <20240209190602.skqahxhgbdc5b2ax@desk>
 <20240209195704.GEZcaDkMUR560qafaI@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209195704.GEZcaDkMUR560qafaI@fat_crate.local>

On Fri, Feb 09, 2024 at 08:57:04PM +0100, Borislav Petkov wrote:
> On Fri, Feb 09, 2024 at 11:06:02AM -0800, Pawan Gupta wrote:
> > (Though, there was a comment on avoiding the macro alltogether, to which
> > I replied that it complicates 32-bit.)
> 
> Hmm, so this seems to build the respective entry_{32,64}.S TUs fine:
> 
> ---
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index e81cabcb758f..7d1e5fe66495 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -313,12 +313,9 @@
>   *
>   * Note: Only the memory operand variant of VERW clears the CPU buffers.
>   */
> -.macro EXEC_VERW
> -	verw _ASM_RIP(mds_verw_sel)
> -.endm
>  
>  .macro CLEAR_CPU_BUFFERS
> -	ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
> +	ALTERNATIVE "",  __stringify(verw _ASM_RIP(mds_verw_sel)), X86_FEATURE_CLEAR_CPU_BUF
>  .endm

> +.macro CLEAR_CPU_BUFFERS
> +     ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
> +.endm

This works, thanks.

My mistake that I tried your earlier suggestion without playing with it:

  > > +.macro CLEAR_CPU_BUFFERS
  > > +   ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
  > > +.endm
  >
  > Why can't this simply be:
  >
  > .macro CLEAR_CPU_BUFFERS
  >         ALTERNATIVE "", "verw mds_verw_sel(%rip)", X86_FEATURE_CLEAR_CPU_BUF
  > .endm
  >
  > without that silly EXEC_VERW macro?
  >
  > --
  > Regards/Gruss,
  >     Boris.

