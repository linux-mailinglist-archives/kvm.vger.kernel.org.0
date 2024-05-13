Return-Path: <kvm+bounces-17352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9248C487A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E816B22ABA
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 20:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D404782485;
	Mon, 13 May 2024 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cXe+QG05"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0F03A1A2;
	Mon, 13 May 2024 20:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715633495; cv=none; b=qmnBzdHxOBXVnhxT6DX67SGXrM127owc0DKFF3xDCWxx5Q2896yUxvnB5aLFGQskCZHaCwhcE4rHf52NYC4TirnKXc+I/K9bjQWqQhxVC9YfkKIYRi1+8TD6s/K7UV/JDX+HAs3AvvIZVNNo3u2E8xgwP1LBtkzM9YI+l0vkpjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715633495; c=relaxed/simple;
	bh=x1s6uZWdvm+KEY3Apexxgf5pQTfniOCvOTs3jXtO7wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POcBw1CJ4kMq9sjzvqAgv/bV8M5XMsb671hTwCMiYdTsLYT1GxQgJ4i6YsVnd/B4p+HPBWP0KuvI+qPjMzjEjyd3t/qFXBU9H310+lj43IMj/gAI6c9WcpI8koJUFkPkEfLDX3V9SBol3zBJ0bCp8xhl9b4V3yQM+WTMcXWbdbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cXe+QG05; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715633494; x=1747169494;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=x1s6uZWdvm+KEY3Apexxgf5pQTfniOCvOTs3jXtO7wk=;
  b=cXe+QG055mFNENquv+Xl0X+iKRgQSphPMIVyb/+k9AoZQUP8z+MOjHZI
   XB04Ev7y70tvjij9VHctHNdHBIutCjSsY+2XYmTYZdhtzny9TR9vZIL8t
   R6bo7v2s/EDDZuSZ0ZNMSmU24/AaohoSvtQlmf5KNvgRKG7THoMs1oLke
   PGWOG7HV2LLhC+KE/q+RDAoTliR8QaF8UOmo4HbbyqX7cjKC4OfszX3lr
   Eo9dUa7KMW+y/j+3WL3ojyd4dkf9Vj5mhb7bPbT+KKGi53dfkTkF6smdw
   Pzw5e36hdZBfzyDJGX4xlICuT0s65lzAtZV3zGtwNQ5LFSSJgGEtBufRs
   g==;
X-CSE-ConnectionGUID: NZR/EfZaRLiWtyLQzKjIeQ==
X-CSE-MsgGUID: iLedArpxR1aPYndKjsV2NA==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="22737126"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="22737126"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 13:51:33 -0700
X-CSE-ConnectionGUID: cCQB5xTpQYC76ith1YZAwQ==
X-CSE-MsgGUID: WExAGTfLQSyd0xOustYf6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="34896296"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 13:51:32 -0700
Date: Mon, 13 May 2024 13:51:32 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, seanjc@google.com, michael.roth@amd.com,
	isaku.yamahata@intel.com, thomas.lendacky@amd.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 02/21] KVM: Allow page-sized MMU caches to be initialized
 with custom 64-bit values
Message-ID: <20240513205132.GB168153@ls.amr.corp.intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-3-pbonzini@redhat.com>
 <6bd61607-9491-4517-8fc8-8d61d9416cab@linux.intel.com>
 <4d0d9f64-4cc4-4c1e-ba27-ff70c9827570@linux.intel.com>
 <20240513203839.GA168153@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240513203839.GA168153@ls.amr.corp.intel.com>

On Mon, May 13, 2024 at 01:38:39PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> > > > index 9c99c9373a3e..c9828feb7a1c 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -401,12 +401,17 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
> > > >   static inline void *mmu_memory_cache_alloc_obj(struct
> > > > kvm_mmu_memory_cache *mc,
> > > >                              gfp_t gfp_flags)
> > > >   {
> > > > +    void *page;
> > > > +
> > > >       gfp_flags |= mc->gfp_zero;
> > > >         if (mc->kmem_cache)
> > > >           return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
> > > > -    else
> > > > -        return (void *)__get_free_page(gfp_flags);
> > > > +
> > > > +    page = (void *)__get_free_page(gfp_flags);
> > > > +    if (page && mc->init_value)
> > > > +        memset64(page, mc->init_value, PAGE_SIZE /
> > > > sizeof(mc->init_value));
> > 
> > Do we need a static_assert() to make sure mc->init_value is 64bit?
> 
> That's overkill because EPT entry is defined as 64bit and KVM uses u64 for it
> uniformly.

Oops, I picked the wrong mail to reply. Sorry for noise.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

