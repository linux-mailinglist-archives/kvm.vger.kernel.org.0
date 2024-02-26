Return-Path: <kvm+bounces-9968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B47868054
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A51ED1C23366
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B378F12F59F;
	Mon, 26 Feb 2024 19:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KE66Pesh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C2B12C815;
	Mon, 26 Feb 2024 19:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974185; cv=none; b=tP30+/8G/HaRhbjpYCpoRuOT8UU/Hxiv+JgdSUNobde8wIXy259orjIpiVE4Pf2CzuD7Oh+W7e5oLPuG0rmkGm6SG9yyzUouu+HSnoJlaOxD7XTyTNT9oqxh48G7jpHi0nifVkVJOAprlwvT4piJPGy96nMQM+tWcjkBd9aHL5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974185; c=relaxed/simple;
	bh=Bn5ZICiOrzowTp93LG/Tvy9uAU1imSLSi4jPVGHq5JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INAqKv/xNsSHklQfzT4xfHUNenLkJpQxOtzzOGR78/QHobtMV3RZ3PYMeHqJInuiRCynIvAGoe4yvXvOzKGG0zFBVTCJGBTeg05NgFu2jK2qW5HthnKIBnBl8AW2SziYmedVa/n71hcyKOI3gqAGe6W3WpFQrjQj0ONruVR1rS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KE66Pesh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708974184; x=1740510184;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bn5ZICiOrzowTp93LG/Tvy9uAU1imSLSi4jPVGHq5JI=;
  b=KE66PeshzluR3kM7eciTSwExtBVszZFR551J+lNfg6qSX6Bqvxt9JMfn
   ekGYaoxJcnEnL5s/rSk/UUuZiPW0fAxlhowI/jxuDKrVIuICTOXdaDLYk
   pbpeUtY4lXRBfjuJQVLdfSrRs2qSoVn5NIRbTSw2mMca5xGaer7wA6wdP
   BgizpE6Vexteo9iNLkBjFmURk65229haBykK/OjX4wvPXFDdb01jUBsVZ
   12m4AnJSuehHftPjkRG4KIYLxp+wOWLiLIOECMJ8M/ZFkUtYkjdnhkKUU
   skPEelhxEA9SH1lLX1aaRqy9eq2uU5U+8CvgDoChAGiMF4bxVLzUr3zfy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14720135"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="14720135"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:03:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6911024"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:03:02 -0800
Date: Mon, 26 Feb 2024 11:03:01 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 039/121] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <20240226190301.GN177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <229a18434e5d83f45b1fcd7bf1544d79db1becb6.1705965635.git.isaku.yamahata@intel.com>
 <05db1988-fad8-458a-8132-7dbe0f1a3ffa@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05db1988-fad8-458a-8132-7dbe0f1a3ffa@linux.intel.com>

On Sun, Jan 28, 2024 at 09:50:16PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 02a466de2991..318135daf685 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -74,10 +74,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
> >   	u64 spte = generation_mmio_spte_mask(gen);
> >   	u64 gpa = gfn << PAGE_SHIFT;
> > -	WARN_ON_ONCE(!shadow_mmio_value);
> > +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
> >   	access &= shadow_mmio_access_mask;
> > -	spte |= shadow_mmio_value | access;
> > +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
> >   	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
> >   	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
> >   		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> > @@ -411,6 +411,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
> > +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
> > +{
> 
> Is it better to do some check on the mmio_value and warns if the value
> is illegal?

I don't think so because the only caller is kvm_mmu_set_mmio_spte_value(kvm, 0)
in tdx_vm_init().  I don't expect other caller.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

