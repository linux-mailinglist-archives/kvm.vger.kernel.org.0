Return-Path: <kvm+bounces-23304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D147F9487ED
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 05:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 909282816D3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 03:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3538C6F073;
	Tue,  6 Aug 2024 03:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjthtiup"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9FA184D;
	Tue,  6 Aug 2024 03:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722915100; cv=none; b=pZHOKe74l57jsfpaQa+FST5dkDoJfrbkzhhQDgbsIPaVd7VEB2+XtG9MhkQBt3ozKC/pqH8sEm0Wq8pXZ362MzvM1BW7QfaqhJEo4KCxO7ENaHQ0a0zj4IUSHVe7fp1dfZyA6iP/Zy23hknK7pWp2TqlI1DqplcIeL4jHySJ7PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722915100; c=relaxed/simple;
	bh=ixRvpBut5AMgVS30pczTl4SUQmbCW1wL6KZmMhwmNIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUp2Qc+AOEPHaNFoe7o0SvgYr41fvjWDrSNBwhJ8wiBcoxPz0pIKlfPcunyyWGfr8KV+CSEN8Vq4tK17/fFXgOQyQlJCLhPk7depd/bv1Ck6C9XRNm6ocBebxtpJHuD11PqukwHH5GIRl1FeLXQdJg3pLEdX2XFzxi6gK5p9q3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjthtiup; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722915099; x=1754451099;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ixRvpBut5AMgVS30pczTl4SUQmbCW1wL6KZmMhwmNIU=;
  b=hjthtiupM+H+8LgBZk3TsQGYQEL+y8pZMGh7abVa/Jgpa8iEDxRJG1ah
   7YxGcP2obCmOknqSCEz3RICTHOoPRAwSB/GsrXzLt8MgO6UNYOTHvWAef
   sl+/UCAsp2WNSKLwCVjkE4hUtUuL3na4YIe8N3YNy3uap+xpQjnEOLKz2
   KwoOzcRmlf/ZgS83sG3Dh3+NcgUSgKhHC5aGvzWCrjmlID4GyOyNe8fXy
   N6WYGh5m9ZodRHwLGEo7aFOU7Ph1xzWqCBHYTa/HO/O+0B4xhkFeo3xog
   NFqzbfnMhM8bn0tLthPioQ0NDVAajzZ4UL25cfIqNh44hPENSsXV+RTo3
   A==;
X-CSE-ConnectionGUID: BjEYBLdpSfqbXoVwI2CJag==
X-CSE-MsgGUID: HA5JzkmyTjOmjlB7rEnN3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="21057422"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="21057422"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 20:31:38 -0700
X-CSE-ConnectionGUID: jaes8beITLaae12znXclMA==
X-CSE-MsgGUID: uhPQagcFTAekYXOGCXS8LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="61001216"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa004.fm.intel.com with ESMTP; 05 Aug 2024 20:31:36 -0700
Date: Tue, 6 Aug 2024 11:31:35 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/9] KVM: x86/mmu: Free up A/D bits in FROZEN_SPTE
Message-ID: <20240806033135.c76lyedxxmhjaux5@yy-desk-7060>
References: <20240801183453.57199-1-seanjc@google.com>
 <20240801183453.57199-6-seanjc@google.com>
 <20240805072013.i3ib4h7eadlzzglm@yy-desk-7060>
 <ZrFPcJvYMpv8BH30@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrFPcJvYMpv8BH30@google.com>
User-Agent: NeoMutt/20171215

On Mon, Aug 05, 2024 at 03:17:20PM -0700, Sean Christopherson wrote:
> On Mon, Aug 05, 2024, Yuan Yao wrote:
> > On Thu, Aug 01, 2024 at 11:34:49AM -0700, Sean Christopherson wrote:
> > > Remove all flavors of A/D bits from FROZEN_SPTE so that KVM can keep A/D
> > > bits set in SPTEs that are frozen, without getting false positives.
> > >
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/spte.h | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > > index ba7ff1dfbeb2..d403ecdfcb8e 100644
> > > --- a/arch/x86/kvm/mmu/spte.h
> > > +++ b/arch/x86/kvm/mmu/spte.h
> > > @@ -216,15 +216,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> > >   * should not modify the SPTE.
> > >   *
> > >   * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
> > > - * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
> > > - * vulnerability.
> > > + * both AMD and Intel CPUs, doesn't set any A/D bits, and doesn't set PFN bits,
> > > + * i.e. doesn't create a L1TF vulnerability.
> > >   *
> > >   * Only used by the TDP MMU.
> > >   */
> > > -#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> > > +#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x498ULL)
> >
> > Question:
> > Why bit3 and bit4 also changed from 0 to 1 ?
>
> Purely so that more bits are set, i.e. so that KVM doesn't rely on one or two
> bits to identify frozen SPTEs.

Thanks for your explanation!

Please consider add this into the commit log, it explains
the reason of why some non A/D bits are selected.

>
> > They're not part of AD bits fro EPT and CR3 page table/AMD NPT
>
> This is very delibreate.  The A/D bits need to be '0' in the FROZEN, i.e. bits
> 5,6, 8, and 9 must not be set in FROZEN_SPTE.
>
> >
> > EPT: Abit:8 Dbit:9
> > CR3: Abit:5 Dbit:6

