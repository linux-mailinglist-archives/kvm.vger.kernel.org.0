Return-Path: <kvm+bounces-26849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0473E9786DD
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C1B61F25A76
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B34084D29;
	Fri, 13 Sep 2024 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E1iGZQw6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4311EEE4;
	Fri, 13 Sep 2024 17:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248819; cv=none; b=Fqa/8PBMFH7YZ/lAei+r1w6ilJBCXbPAyKC4CLnzXVQCwBO2SSmwp8GfpyCh3/A/FQDX2s4ZVlce8wIY5qRvcdTNJ6SuydDk8Df0nMx0iCRFB4HOdPqJsgYlSPPlK0xdMM+GRQZys+aQh4NkRNJyqzXibmCKYeUlZYGyfVNvSNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248819; c=relaxed/simple;
	bh=9c+3Sprtb3LUjHMbj19tnQkWfJ6bZ8unBcJ3UA4Owvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSrbJmzGgwfTtyMKbyn+0yyprl03N21HuvaUcxOCp7mSIo8SANNEYEZBnqMN2el64vC5syTyZgkcYVf5C+aNH8UM+c+y3oZZyuRf6e4njVoVOa7/6jfwUWN3PWZGNUj9XP1oHy7MTJRMJTEJizxbU8enoE08uxUm+eaFMXyX1hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E1iGZQw6; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726248817; x=1757784817;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9c+3Sprtb3LUjHMbj19tnQkWfJ6bZ8unBcJ3UA4Owvw=;
  b=E1iGZQw6DzYhChsL6G1XnCK3OABmUFasf0GoUyIGUoyp1onieKHan5+0
   cIJsljmsdqJ7A9kLo/fRy4sWy6iadsV40Bi5dphfLcY7e62WTvFZiM3YO
   6r7neZTHfe0GV2rx7XAM3U+Pg4qlBjKSe3Xi7ZlUUPxrsNUwJ6PjUIl42
   mTcH0PeU1X7r1/1qOI0tiFGb2c7O7AAmpCR6mAtFwJgtDjA+frzB7WNqL
   MkAhwUATdjikjC/Yb05wrFQUNVSjdXlNO+9LprNCZndjK3Ua2MsdTTuni
   pNtD7i7Xslc1B2NUdY/Rq+tMupHW+gacLGU2BWC94deVQ6Pk62VXAmfrT
   A==;
X-CSE-ConnectionGUID: d9F8O0JDQdG8zZdV1BAX7w==
X-CSE-MsgGUID: hUjnuYaERdO9cCZrG2RGXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="25309584"
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="25309584"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 10:33:36 -0700
X-CSE-ConnectionGUID: y29oZL4IT32DU+Oys4CVUg==
X-CSE-MsgGUID: Gj1dYRYSRe68ECZ3RkJW5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="67987717"
Received: from tbrumzie-mobl2.amr.corp.intel.com (HELO desk) ([10.125.147.158])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 10:33:35 -0700
Date: Fri, 13 Sep 2024 10:33:23 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Message-ID: <20240913173323.6guq4p2h4z7ulgr3@desk>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
 <20240912162440.be23sgv5v5ojtf3q@desk>
 <ZuPNmOLJPJsPlufA@intel.com>
 <3244950F-0422-49AD-812D-DE536DAF5D7E@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3244950F-0422-49AD-812D-DE536DAF5D7E@nutanix.com>

On Fri, Sep 13, 2024 at 03:51:01PM +0000, Jon Kohler wrote:
> 
> 
> > On Sep 13, 2024, at 1:28 AM, Chao Gao <chao.gao@intel.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Thu, Sep 12, 2024 at 09:24:40AM -0700, Pawan Gupta wrote:
> >> On Thu, Sep 12, 2024 at 03:44:38PM +0000, Jon Kohler wrote:
> >>>> It is only worth implementing the long sequence in VMEXIT_ONLY mode if it is
> >>>> significantly better than toggling the MSR.
> >>> 
> >>> Thanks for the pointer! I hadn’t seen that second sequence. I’ll do measurements on
> >>> three cases and come back with data from an SPR system.
> >>> 1. as-is (wrmsr on entry and exit)
> >>> 2. Short sequence (as a baseline)
> >>> 3. Long sequence
> >> 
> 
> Pawan,
> 
> Thanks for the pointer to the long sequence. I've tested it along with 
> Listing 3 (TSX Abort sequence) using KUT tscdeadline_immed test. TSX 
> abort sequence performs better unless BHI mitigation is off or 
> host/guest spec_ctrl values match, avoiding WRMSR toggling. Having the
> values match the DIS_S value is easier said than done across a fleet
> that is already using eIBRS heavily.
> 
> Test System:
> - Intel Xeon Gold 6442Y, microcode 0x2b0005c0
> - Linux 6.6.34 + patches, qemu 8.2
> - KVM Unit Tests @ latest (17f6f2fd) with tscdeadline_immed + edits:
> - Toggle spec ctrl before test in main()
> - Use cpu type SapphireRapids-v2
> 
> Test string:
> TESTNAME=vmexit_tscdeadline_immed TIMEOUT=90s MACHINE= ACCEL= taskset -c 26 ./x86/run x86/vmexit.flat \
> -smp 1 -cpu SapphireRapids-v2,+x2apic,+tsc-deadline -append tscdeadline_immed |grep tscdeadline
> 
> Test Results:
> 1. spectre_bhi=on, host spec_ctrl=1025, guest spec_ctrl=1: tscdeadline_immed 3878 (WRMSR toggling)
> 2. spectre_bhi=on, host spec_ctrl=1025, guest spec_ctrl=1025: tscdeadline_immed 3153 (no WRMSR toggling)
> 3. spectre_bhi=vmexit, BHB long sequence, host/guest spec_ctrl=1: tscdeadline_immed 3629 (still better than test 1, penalty only on exit)
> 4. spectre_bhi=vmexit, TSX abort sequence, host/guest spec_ctrl=1: tscdeadline_immed 3294 (best general purpose performance)

This looks promising.

> 5. spectre_bhi=vmexit, TSX abort sequence, host spec_ctrl=1, guest spec_ctrl=1025: tscdeadline_immed 4011 (needs optimization)

Once QEMU adds support for exposing BHI_CTRL, this is a very likely
scenario. To optimize this, host needs to have BHI_DIS_S set. We also need
to account for the case where some guests set BHI_DIS_S and others dont.

> In short, there is a significant speedup to be had here.
> 
> As for test 5, honest that is somewhat invalid because it would be
> dependent on the VMM user space showing BHI_CTRL.

Right.

> QEMU as an example does not do that, so even with latest qemu and latest
> kernel, guests will still use BHB loop even on SPR++ today, and they
> could use the TSX loop with this proposed change if the VMM exposes RTM
> feature.

I did not know that QEMU does not expose CPUID.BHI_CTRL. Chao, could you
please help getting this feature exposed in QEMU?

> I'm happy to post a V2 patch with my TSX changes, or take any other
> suggestions here.

With CPUID.BHI_CTRL exposed to guests, this:

> 2. spectre_bhi=on, host spec_ctrl=1025, guest spec_ctrl=1025: tscdeadline_immed 3153 (no WRMSR toggling)

will be the most common case, which is also the best performing. Isn't it
better to aim for this?

