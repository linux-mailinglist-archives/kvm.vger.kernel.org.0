Return-Path: <kvm+bounces-32328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB039D5669
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 00:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F51A282C53
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 23:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20021DDC08;
	Thu, 21 Nov 2024 23:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZOWJMhrR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784A119F410;
	Thu, 21 Nov 2024 23:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732233024; cv=none; b=ulCo5KrSVfyebnOYcPzoBB9RNS5Svjk6ocRJ1OH1zlHXoJ2N6gTOJhRI+mKYR3YvrGv8TWRdKkdmaSRTEln2NPWItq5RSh7k68qfcBBoyLBuZEPfc9zoRc36OdSfg/lyW95NYRI2EMtvFeN9YoeDfgJyvhp6h+J0UL0x08aCS2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732233024; c=relaxed/simple;
	bh=wiQ3p9Hy32GNbdHS2hhBxtvP/6k5Uun92yZjmgVUWmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAZH9N+8mSXSLomlmdlgdK56aOIvWR/wBfSpXs+TxLpIIwB3VJattN65gLS6Pyz5oAz0AZ39K+7kGFvbNztCqRyJfm8RFiEJ2z+M2hQ3keXXwPDb/0/PFtMPdWB9MhkpoVX/KYC2MH3jDJEfZbyeNPLsxtZVGvnyduEXeh9cnmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZOWJMhrR; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732233022; x=1763769022;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wiQ3p9Hy32GNbdHS2hhBxtvP/6k5Uun92yZjmgVUWmg=;
  b=ZOWJMhrRCKKJllLspavdmzuBVwjLGbBUc4F/rpAwjdLX0ZIzeT/agQgn
   F2Z3mQlXarNoWRhTYVEUeL3rR18Y2MbCU9hBvlFiD8vkMlbbJEPMoVr3k
   Br6b2MRTc+kIw8Q0jD1Q3C9rnZKO3yO/e8opj7BiXWOe1M4+q0LkxHrDk
   iIH0/ZQSqcqo0Z1Zv3LGZzGl7ZapYqQU6cmIkQ4gzhcUYo6seAjGaZ5ya
   b6gz7hrJVWsxsZPgq2r5WZJdd8nKX1QnYw3HB8Gq8eZAn0NcYlnlwd6CP
   Sfd6YvnYXJM1rh1pFWH93WEjmlR68k2lAvOddWxOHjv1qZj2sph4wY8C/
   g==;
X-CSE-ConnectionGUID: oGSCv17aRNOgUzrrxaBPZw==
X-CSE-MsgGUID: bfg3RHggS2yPKPzuAfMpBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32517445"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="32517445"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 15:50:21 -0800
X-CSE-ConnectionGUID: gpeJGlLQT0a/eGWV8JLnrg==
X-CSE-MsgGUID: HWs9T5+hTAunZANnW+guGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="113692973"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 15:50:21 -0800
Date: Thu, 21 Nov 2024 15:50:20 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"nikunj@amd.com" <nikunj@amd.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio
 to change
Message-ID: <Zz/HPBEFe0Nwgu5Z@ls.amr.corp.intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
 <86d3e586314037e90c7425e344432ba21d511a26.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86d3e586314037e90c7425e344432ba21d511a26.camel@intel.com>

On Mon, Oct 14, 2024 at 03:48:03PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Sat, 2024-10-12 at 00:55 -0700, Isaku Yamahata wrote:
> > Problem
> > The current x86 KVM implementation conflicts with protected TSC because the
> > VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
> > logic to change/adjust the TSC offset/multiplier somehow.
> > 
> > Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
> > offset/multiplier, the TSC timer interrupts is injected to the guest at the
> > wrong time if the KVM TSC offset is different from what the TDX module
> > determined.
> > 
> > Originally this issue was found by cyclic test of rt-test [1] as the
> > latency in TDX case is worse than VMX value + TDX SEAMCALL overhead.  It
> > turned out that the KVM TSC offset is different from what the TDX module
> > determines.
> > 
> > Solution
> > The solution is to keep the KVM TSC offset/multiplier the same as the value
> > of the TDX module somehow.  Possible solutions are as follows.
> > - Skip the logic
> >   Ignore (or don't call related functions) the request to change the TSC
> >   offset/multiplier.
> >   Pros
> >   - Logically clean.  This is similar to the guest_protected case.
> >   Cons
> >   - Needs to identify the call sites.
> > 
> > - Revert the change at the hooks after TSC adjustment
> >   x86 KVM defines the vendor hooks when TSC offset/multiplier are
> >   changed.  The callback can revert the change.
> >   Pros
> >   - We don't need to care about the logic to change the TSC
> >     offset/multiplier.
> >   Cons:
> >   - Hacky to revert the KVM x86 common code logic.
> > 
> > Choose the first one.  With this patch series, SEV-SNP secure TSC can be
> > supported.
> > 
> > [1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
> > 
> > Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> IIUC this problem was reported by Marcelo and he tested these patches and found
> that they did *not* resolve his issue? But offline you mentioned that you
> reproduced a similar seeming bug on your end that *was* resolved by these
> patches.

That's right. The first experimental patch didn't, but this patch does.
(At least I belive so. Marcelo, please jump in if I'm wrong.)


> If I got that right, I would think we should figure out Marcelo's
> problem before fixing this upstream. If it only affects out-of-tree TDX code we
> can take more time and not thrash the code as it gets untangled further.

Ok.  This patch affects TDX code (and potentially SEV-SNP secure TSC host code.)
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

