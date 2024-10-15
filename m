Return-Path: <kvm+bounces-28885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D04E99E9E2
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 14:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4068D1F241F7
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AD521D2C5;
	Tue, 15 Oct 2024 12:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vs9rYX6R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B721D197;
	Tue, 15 Oct 2024 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728995489; cv=none; b=eSaAEoKBDNue569wu1QCxtNzCcstc8ERz5XJ2UsXWFFFqlrL0/2M1wX6DhE6uYgzOVzvWNf4Z2RN8uFkP65Y9m66lf8/D4GiwluOgX6sTNUz2glGmXor2BswxUvxDVYb3faBRup2rQHGTH7jNzV9EDZ+FIUmnCIqZn5dQnzEeuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728995489; c=relaxed/simple;
	bh=ZOxlrJt509wjC1nJz55xql2MixKO7MJNudCJ30CW3xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1SM3NEZ4C5rQYRol9OTECrCKVB+7qcGXsCcEk8KezKCGuuyAA82uHyFiCt24jyF37dnAmeafnsKhafjqVqyEc/OVbMDSKis4xgdhm/TIEVtCKP7dfkz2lUJTWMvxkS3E37ULKOrXUjM+Hp1Msu51o5NkhjxU7WNrFkguUr5iOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vs9rYX6R; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728995488; x=1760531488;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZOxlrJt509wjC1nJz55xql2MixKO7MJNudCJ30CW3xQ=;
  b=Vs9rYX6R9Ef3E0xc/VWtsX6NTHCIB+P6d9JhmOkduwiXFyOMIF8Na+Eb
   23t9iH9sZ5006xGemmpI/CkOrHUMjUWLvdEJSug3jGSCxtlx0e68cukKh
   1izAUhtLYLKOK01OrcFB1KUyLL6lcuM/YQPvEVUO0eeE/FXfNFajL0Gvq
   NHnEe7rIKZFdFF1XArEOtiRi6pbo6gHx7VSTEGaXhz6mYb4PnGIvII+KQ
   OqKNIpqn5CneXtnKIyNfOCMT2Pp5sLGjnO9IesPBCtuEkze0QhvEkyNTu
   oi7+FYm4zAK9St/zpE7hKMKxqIifYShReQ59nfcGAM5b9IgN7K8aNBIhO
   A==;
X-CSE-ConnectionGUID: JOK5u7M0SRGz8OGrzMRIsA==
X-CSE-MsgGUID: UgTayk5SQeqpkr8CrLMiZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28338170"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28338170"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 05:31:27 -0700
X-CSE-ConnectionGUID: blH58R9BQV6FqnOt6osZMA==
X-CSE-MsgGUID: rFIkzRPZRzuxKu1rnhTbVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="108612476"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa001.fm.intel.com with ESMTP; 15 Oct 2024 05:31:24 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 0CD6F316; Tue, 15 Oct 2024 15:31:22 +0300 (EEST)
Date: Tue, 15 Oct 2024 15:31:22 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
Message-ID: <w2jymc2d37lzcdgppyeokmcifnrxlto2om4alopfivbmfhaxpq@lxlez6fsjo7f>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>

On Tue, Oct 15, 2024 at 12:12:51PM +0200, Jürgen Groß wrote:
> On 15.10.24 11:58, Kirill A. Shutemov wrote:
> > AMD SEV-SNP and Intel TDX have limited access to MTRR: either it is not
> > advertised in CPUID or it cannot be programmed (on TDX, due to #VE on
> > CR0.CD clear).
> > 
> > This results in guests using uncached mappings where it shouldn't and
> > pmd/pud_set_huge() failures due to non-uniform memory type reported by
> > mtrr_type_lookup().
> > 
> > Override MTRR state, making it WB by default as the kernel does for
> > Hyper-V guests.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Suggested-by: Binbin Wu <binbin.wu@intel.com>
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >   arch/x86/kernel/kvm.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 263f8aed4e2c..21e9e4845354 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -37,6 +37,7 @@
> >   #include <asm/apic.h>
> >   #include <asm/apicdef.h>
> >   #include <asm/hypervisor.h>
> > +#include <asm/mtrr.h>
> >   #include <asm/tlb.h>
> >   #include <asm/cpuidle_haltpoll.h>
> >   #include <asm/ptrace.h>
> > @@ -980,6 +981,9 @@ static void __init kvm_init_platform(void)
> >   	}
> >   	kvmclock_init();
> >   	x86_platform.apic_post_init = kvm_apic_init;
> > +
> > +	/* Set WB as the default cache mode for SEV-SNP and TDX */
> > +	mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
> 
> Do you really want to do this for _all_ KVM guests?
> 
> I'd expect this call to be conditional on TDX or SEV-SNP.

mtrr_overwrite_state() checks it internally.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

