Return-Path: <kvm+bounces-7869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 340BB847B8A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 22:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D94B71F27CF8
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 21:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AD883A1C;
	Fri,  2 Feb 2024 21:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OKgdLLSG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5ED83A03;
	Fri,  2 Feb 2024 21:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706909497; cv=none; b=m9leEEsqZeBLTKhtZKRw9XnxildElhpPpOYJc1Yz80/DnxYh7MagB5kSD25Vpnky20DECKGDEH6EPgevKYsrjwmKgGml5Pc1CHG9KhL6xQrwxhlPMEdO8dECpZbzwdDHRFR5WUtLIe4lZXaUfM48nZwXjHNLSHudEb3nBjACLe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706909497; c=relaxed/simple;
	bh=e/jtn8sn44EpFq31C7CYmB+SiierH0OvgSrhIK/xiS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KG3gGPtCxCkpv/gGEvyx6UId8wyTw1Km0w/sZw22YfAfIdx2mMzpAuijdZYl+dipoIT0qpDvOC+duW5ZcrD9sXrzif3l0sp9U4sVAn7/Z7J4Gieq2BED8EvmKA9N/dWH+c4j6dyMdQ3Wg3eMTH34St21iYhkdY0SGh4m2n/4Pj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OKgdLLSG; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706909496; x=1738445496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e/jtn8sn44EpFq31C7CYmB+SiierH0OvgSrhIK/xiS4=;
  b=OKgdLLSGYbzT8o94fCo7cSVgzI3lU9DYBgmv0Icw9nvaEijRHRzVxiLj
   ZIzMAT4GbTvObt5Xte+MlsAprBNjRywiQFrdOt+NXu0PSdno+Vyv36Qkn
   0MY+ikNlzhF1KD7/lCwGvAFHmLOoXWFnwOSsqX0zGPSqXmPkRmX8aHyC7
   IEEcmXIbgyiIsN+BrJ82xNOBx4s3KvN7jKkjSUTBhpmcokqEG5X4D6sI/
   0sI83L0CuNG0E3iYCKpW3B4FxYEOjdx/3LCOJX3mljcHwdUJ9NdBOuQMK
   9VFAEdLeqawxTCfpLmJ5rsGpD46tS2U+3FB7h6GfkL749fmxVMXsID658
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="143422"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="143422"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 13:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="481566"
Received: from shannonw-mobl2.amr.corp.intel.com (HELO desk) ([10.209.74.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 13:31:34 -0800
Date: Fri, 2 Feb 2024 13:31:32 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v6 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240202213132.kvdyz3dqqkzw7gox@desk>
References: <20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com>
 <20240123-delay-verw-v6-1-a8206baca7d3@linux.intel.com>
 <20240202032909.exegdxpgyndlkn2n@treble>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202032909.exegdxpgyndlkn2n@treble>

On Thu, Feb 01, 2024 at 07:29:09PM -0800, Josh Poimboeuf wrote:
> On Tue, Jan 23, 2024 at 11:41:01PM -0800, Pawan Gupta wrote:
> > index 4af140cf5719..79a7e81b9458 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -308,10 +308,10 @@
> >  #define X86_FEATURE_SMBA		(11*32+21) /* "" Slow Memory Bandwidth Allocation */
> >  #define X86_FEATURE_BMEC		(11*32+22) /* "" Bandwidth Monitoring Event Configuration */
> >  #define X86_FEATURE_USER_SHSTK		(11*32+23) /* Shadow stack support for user mode applications */
> > -
> >  #define X86_FEATURE_SRSO		(11*32+24) /* "" AMD BTB untrain RETs */
> >  #define X86_FEATURE_SRSO_ALIAS		(11*32+25) /* "" AMD BTB untrain RETs through aliasing */
> >  #define X86_FEATURE_IBPB_ON_VMEXIT	(11*32+26) /* "" Issue an IBPB only on VMEXIT */
> > +#define X86_FEATURE_CLEAR_CPU_BUF	(11*32+27) /* "" Clear CPU buffers using VERW */
> 
> This will need to be rebased.  And the "11*32" level is now full in
> Linus' tree, so this will presumably need to go to a different "level".

Yes, will send a new rebased version.

