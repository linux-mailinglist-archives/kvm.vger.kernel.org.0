Return-Path: <kvm+bounces-8477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DA884FC9E
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 20:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99B2A1F26067
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5065E84A48;
	Fri,  9 Feb 2024 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eW3LHiaJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D659A84A29;
	Fri,  9 Feb 2024 19:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707505566; cv=none; b=OX+A+CmJ7o3FNIERSUmnSGtUNPJTDNbLkrZfAGvcHHeUKwumMCXws4d/DSsEn3B8qTieuQP58Tyh2ftLt5llnQDFltoXBaCnQ+v9dsFVlQMJkluHkJaMYbSPpMe09fCwKKeg0Epys81XMuno+dq26aKeiZYoEQgZQ2HNUxHKgWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707505566; c=relaxed/simple;
	bh=uH5jVE0MECW4NZxWlW2VDnG/UXQKh57bJcefzW5uzZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmwF1sNcSZ1PHckf8Xo1obnnemX27UMqfA7x8ARLdVh8YM8j3pqpbtZ+ssQ+haJjHNPECzSGhqWQfdX85Npgam18wQRgPsaN8+CgPHkJyK+LTrY3uNTXIQh6zq1Fl6LCMYt1YsiW8XkYGOWUgL6eupZ5Fi9wDT8BMqZKjxHhDXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eW3LHiaJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707505565; x=1739041565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uH5jVE0MECW4NZxWlW2VDnG/UXQKh57bJcefzW5uzZY=;
  b=eW3LHiaJi7abuANvCgilfBOBSCuwgvgerTAvOvGIgFBhQDkKJqrCPOrP
   OtnkIR7p2CrVFa/MimkJSl6nJqYWZEhlMYxx8jobPGTR+mrTsxgvsy4R3
   etzOSjS2Z6EXbn5WpZnYRxzknLMW2/jGcg4lgPeVrKXB2D6N+XpGkciw9
   Zmpxqvlp7cVRU6CUxjrt1AKKyvOhpn5HE3+lLvLi2T+YBFl6CnWN10pGB
   ar69gQl1BEkIjIXR1v0/WaEIM0ltbi8H0GoXagLU0c1xlBCb1nxPbrDHd
   amjsL0tJfTBSjWjdN36mHqy4+sF8TVBKYsBbxNdZWnhq3tUHYCraYjR59
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="1392462"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="1392462"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 11:06:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="6661651"
Received: from karenaba-mobl1.amr.corp.intel.com (HELO desk) ([10.209.64.107])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 11:06:02 -0800
Date: Fri, 9 Feb 2024 11:06:02 -0800
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
Message-ID: <20240209190602.skqahxhgbdc5b2ax@desk>
References: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
 <20240204-delay-verw-v7-1-59be2d704cb2@linux.intel.com>
 <20240209172843.GUZcZgy7EktXgKZQoc@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240209172843.GUZcZgy7EktXgKZQoc@fat_crate.local>

On Fri, Feb 09, 2024 at 06:28:43PM +0100, Borislav Petkov wrote:
> On Sun, Feb 04, 2024 at 11:18:59PM -0800, Pawan Gupta wrote:
> >  .popsection
> > +
> > +/*
> > + * Defines the VERW operand that is disguised as entry code so that
> 
> "Define..."
> 
> > + * it can be referenced with KPTI enabled. This ensures VERW can be
> 
> "Ensure..."
> 
> But committer can fix those.
> 
> > + * used late in exit-to-user path after page tables are switched.
> > + */
> > +.pushsection .entry.text, "ax"
> > +
> > +.align L1_CACHE_BYTES, 0xcc
> > +SYM_CODE_START_NOALIGN(mds_verw_sel)
> > +	UNWIND_HINT_UNDEFINED
> > +	ANNOTATE_NOENDBR
> > +	.word __KERNEL_DS
> > +.align L1_CACHE_BYTES, 0xcc
> > +SYM_CODE_END(mds_verw_sel);
> > +/* For KVM */
> > +EXPORT_SYMBOL_GPL(mds_verw_sel);
> > +
> > +.popsection
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index fdf723b6f6d0..2b62cdd8dd12 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -95,7 +95,7 @@
> >  #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
> >  #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
> >  #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* AMD Last Branch Record Extension Version 2 */
> > -/* FREE, was #define X86_FEATURE_LFENCE_RDTSC		( 3*32+18) "" LFENCE synchronizes RDTSC */
> > +#define X86_FEATURE_CLEAR_CPU_BUF	( 3*32+18) /* "" Clear CPU buffers using VERW */
> >  #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
> >  #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
> >  #define X86_FEATURE_ALWAYS		( 3*32+21) /* "" Always-present feature */
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 262e65539f83..ec85dfe67123 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -315,6 +315,21 @@
> >  #endif
> >  .endm
> >  
> > +/*
> > + * Macros to execute VERW instruction that mitigate transient data sampling
> > + * attacks such as MDS. On affected systems a microcode update overloaded VERW
> > + * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
> > + *
> > + * Note: Only the memory operand variant of VERW clears the CPU buffers.
> > + */
> > +.macro EXEC_VERW
> 
> I think I asked this already:

Sorry I can't seem to find that on lore.
(Though, there was a comment on avoiding the macro alltogether, to which
I replied that it complicates 32-bit.)

> Why isn't this called simply "VERW"?
>
> There's no better name as this is basically the insn itself...

Agree.

> > +	verw _ASM_RIP(mds_verw_sel)

But, in this case the instruction needs a special operand, and the build
fails with the macro name VERW:

  AS      arch/x86/entry/entry.o
  AS      arch/x86/entry/entry_64.o
arch/x86/entry/entry_64.S: Assembler messages:
arch/x86/entry/entry_64.S:164: Error: too many positional arguments
arch/x86/entry/entry_64.S:577: Error: too many positional arguments
arch/x86/entry/entry_64.S:728: Error: too many positional arguments
arch/x86/entry/entry_64.S:1479: Error: too many positional arguments
make[4]: *** [scripts/Makefile.build:361: arch/x86/entry/entry_64.o] Error 1
make[3]: *** [scripts/Makefile.build:481: arch/x86/entry] Error 2
make[2]: *** [scripts/Makefile.build:481: arch/x86] Error 2

> > +.endm

Perhaps s/EXEC_VERW/_VERW/ ?

Thanks for the review.

