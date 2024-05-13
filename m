Return-Path: <kvm+bounces-17351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2C68C4853
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B010B2120E
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 20:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08AC8004F;
	Mon, 13 May 2024 20:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qh2KbS+i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283A11DA24;
	Mon, 13 May 2024 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715632724; cv=none; b=ayvZ4WQ5WyBGMYKu3rGoE3U878Apx1jAvIi/mrc8Zufe9Wkek1NubLxI9MwpiMSsK2RSTm35XXLVIAie5B8v/EuxKkgvkbPTlNmGZOM619Ty/kusq/f5b5WOYGmA5UvGQlzPVgDu5jFuHte6LDPdSTuk64HPPh+PDMUDDDY2wwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715632724; c=relaxed/simple;
	bh=QbhhRTYOI2vg+p7o11+oe+NFacNKUaoVU7Oa8Khfwjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUkxskIYW8nkLbuq2br17BurZlJo2dfQt01k2QnGhn1BwdFT8V2AUErq0rzSF5CZqB3Q4/0hpoSZJAS6hO/Gvi/iLnLlnBlXDPxeblNYL2Up3MF0tLqO+oLEG5h0ZU1mIxuB4VaMY+WAsGH0Ca7vrJIhMGHY1Mt4ZCpeVG74A1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qh2KbS+i; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715632722; x=1747168722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=QbhhRTYOI2vg+p7o11+oe+NFacNKUaoVU7Oa8Khfwjo=;
  b=Qh2KbS+iP8og4WtnVdMRV/fvs6bcmSDE0FErndI6sZXh6l1chTC8zsg2
   oq8kvf72tS9NXCJZqdG8lShaBfnI5E3xEOYUvJy4pq1xlMXa7sK+f6CkH
   98Z1ESi6wGP7CV76pgfXRfb9GO7g0RAoEar9guhWhVafkhtMuxjomXM8z
   zNUJPT3TbJL8CD638x/ix5QTGsK0rfOGKhw1GrOFDz+ZwuNoBkExroH3p
   DiZTpV9QfJyPzE+zy5bb9GXcHs3d9cYlRvcb2QyiI4fevrwiZK617J0kR
   3tVT6WFUacDzVkIOlaNU2IQJ6Xcd9kb3W7WODnQGPNEFUXCIlUviPAiYj
   A==;
X-CSE-ConnectionGUID: Znq0Zj9BTZSXqoIEQyZpCA==
X-CSE-MsgGUID: fO8mXY5oS6SqxmjKKXiD4Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="11443959"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="11443959"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 13:38:41 -0700
X-CSE-ConnectionGUID: fsxa21CaQ6+416ND+iF+Dw==
X-CSE-MsgGUID: +1HvBkbbRliBpfPAleBnvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="35144881"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 13:38:41 -0700
Date: Mon, 13 May 2024 13:38:39 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, seanjc@google.com, michael.roth@amd.com,
	isaku.yamahata@intel.com, thomas.lendacky@amd.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 02/21] KVM: Allow page-sized MMU caches to be initialized
 with custom 64-bit values
Message-ID: <20240513203839.GA168153@ls.amr.corp.intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-3-pbonzini@redhat.com>
 <6bd61607-9491-4517-8fc8-8d61d9416cab@linux.intel.com>
 <4d0d9f64-4cc4-4c1e-ba27-ff70c9827570@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d0d9f64-4cc4-4c1e-ba27-ff70c9827570@linux.intel.com>

On Tue, Mar 26, 2024 at 11:56:35PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> On 3/5/2024 2:55 PM, Binbin Wu wrote:
> > 
> > 
> > On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > > 
> > > Add support to MMU caches for initializing a page with a custom 64-bit
> > > value, e.g. to pre-fill an entire page table with non-zero PTE values.
> > > The functionality will be used by x86 to support Intel's TDX, which
> > > needs
> > > to set bit 63 in all non-present PTEs in order to prevent !PRESENT page
> > > faults from getting reflected into the guest (Intel's EPT Violation #VE
> > > architecture made the less than brilliant decision of having the per-PTE
> > > behavior be opt-out instead of opt-in).
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Message-Id: <5919f685f109a1b0ebc6bd8fc4536ee94bcc172d.1705965635.git.isaku.yamahata@intel.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >   include/linux/kvm_types.h |  1 +
> > >   virt/kvm/kvm_main.c       | 16 ++++++++++++++--
> > >   2 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > 
> > > 
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index d93f6522b2c3..827ecc0b7e10 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -86,6 +86,7 @@ struct gfn_to_pfn_cache {
> > >   struct kvm_mmu_memory_cache {
> > >       gfp_t gfp_zero;
> > >       gfp_t gfp_custom;
> > > +    u64 init_value;
> > >       struct kmem_cache *kmem_cache;
> > >       int capacity;
> > >       int nobjs;
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 9c99c9373a3e..c9828feb7a1c 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> > >   static inline void *mmu_memory_cache_alloc_obj(struct
> > > kvm_mmu_memory_cache *mc,
> > >                              gfp_t gfp_flags)
> > >   {
> > > +    void *page;
> > > +
> > >       gfp_flags |= mc->gfp_zero;
> > >         if (mc->kmem_cache)
> > >           return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> > > -    else
> > > -        return (void *)__get_free_page(gfp_flags);
> > > +
> > > +    page = (void *)__get_free_page(gfp_flags);
> > > +    if (page && mc->init_value)
> > > +        memset64(page, mc->init_value, PAGE_SIZE /
> > > sizeof(mc->init_value));
> 
> Do we need a static_assert() to make sure mc->init_value is 64bit?

That's overkill because EPT entry is defined as 64bit and KVM uses u64 for it
uniformly.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

