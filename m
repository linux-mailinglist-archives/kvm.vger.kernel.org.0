Return-Path: <kvm+bounces-9954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 105A4867F61
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 417621C29B1F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E42212EBC4;
	Mon, 26 Feb 2024 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GSKACibp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD912CD8E;
	Mon, 26 Feb 2024 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708970113; cv=none; b=BvVUXUwCLNR8cI8GnuysSAPTRc2S8bNfW7jQQOhhmMtY1bRHJ+CmJOiifEkrjbU9ZKPuGisfYGifOXq/ftYTs+GEL9fDoughfnSTKRZhmZDIageYLYL8PwNogu88iZVFOaZd2/JDxUqL4XYN5sheQBBxwbSqQGpqGQwLllh6uVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708970113; c=relaxed/simple;
	bh=JKV0S93Mg+rTphHewtKghez0jM7ATvfjQeqI+0P17dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AW/avJ94FOeOFyF9spcWAWbkzNjixfxI9bPA/12i0rDhiPac2HDP4AtvIpajsOwy7qaydtDC/AZKL5uxVFt4B+i7yKHibCGtvV+m1zOE6kT+JguNCzaZHzItgq2CZkYMYyKDl3gjeGcbuGMQBxosEX/+cVVSNurJUZRFD1aADbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GSKACibp; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708970111; x=1740506111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=JKV0S93Mg+rTphHewtKghez0jM7ATvfjQeqI+0P17dg=;
  b=GSKACibpyk+6yKFj+9+CSU9x+xqZwgNPVf33jgmON/x2DXzUShB3kdeW
   WA7E2l8ktdRyA1qN2snn6Beu15w98IO0GaaixDTIW8ehApzqHOMN5khu2
   CJOw3wgGoNe8PhKgHXo7eQCxf5KPHK2wJbOdcPZR7rn45NNsITwDH07Td
   nhe4BIrhyEeeNvjymY5J/u6fig7Dp7ImYHvIFmbqnUXhG8c2V0n9TJHOo
   Bf9NC4YODiMVWYiCIOzMtw1hwqjShAwQH4FGJ2gaKyd5OFdD50SLp/Y+J
   qMz+wgLE1x2tJjPAI5LgWSaA1eWoBrXI/RurX8tFyMfMeanU/hWa/Ii7W
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3145661"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3145661"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 09:55:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6951848"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 09:55:11 -0800
Date: Mon, 26 Feb 2024 09:55:10 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 040/121] KVM: x86/mmu: Disallow fast page fault on
 private GPA
Message-ID: <20240226175510.GC177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfYP4n12HOSx5XsibA==hmPCVe9hHZFTsJTTxBHA5pffwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYP4n12HOSx5XsibA==hmPCVe9hHZFTsJTTxBHA5pffwA@mail.gmail.com>

On Mon, Feb 12, 2024 at 06:01:54PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Tue, Jan 23, 2024 at 12:55 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
> > access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
> > doesn't make sense.  Disallow fast page fault on private GPA.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b2924bd9b668..54d4c8f1ba68 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3339,8 +3339,16 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
> >         return RET_PF_CONTINUE;
> >  }
> >
> > -static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
> > +static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
> >  {
> > +       /*
> > +        * TDX private mapping doesn't support fast page fault because the EPT
> > +        * entry is read/written with TDX SEAMCALLs instead of direct memory
> > +        * access.
> > +        */
> > +       if (kvm_is_private_gpa(kvm, fault->addr))
> > +               return false;
> 
> I think this does not apply to SNP? If so, it would be better to check
> the SPTE against the shared-page mask inside the do...while loop.

No, this won't apply to SNP. Let me update the patch corresponding in v19.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

