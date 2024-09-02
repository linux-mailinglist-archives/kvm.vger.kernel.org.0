Return-Path: <kvm+bounces-25661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CAB96831C
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 11:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F5131C22587
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFAC1C4EEB;
	Mon,  2 Sep 2024 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HxN6a4K8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BD41C2DB4;
	Mon,  2 Sep 2024 09:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725268977; cv=none; b=ShnKSKyMbAcBBvhg8tzFt5bhBHc7Yyj97bR2AvLolEDe1DpcaQqPGD5JvfXi+alP3jCtEbRqynFLb5kaWj/+jWZIqMFdyhzMDct8Jrb4Tltby7rW/DgOEacDfEpSqdsnwyEvnDVbQEUG/+OJ/Gx6bVrcYcbrRFISgmTCaTekzas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725268977; c=relaxed/simple;
	bh=VZ8OdXN/IOYSuq/x5xY1eTO72fQw8fjegXdeCILRuyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlSOzGE4HjBDuSHDHsxpjiGklAW+cjwF0qnrCNxHMneQT4j07by5JcTZ4F1gyRXkKjOpcdYlRohdmnBY9Xv2/FElhhvN/dfG4s4gyOzr0NQ8h6gyPTsfJCNMd9ikgfkNUPKX1imSB2uLC+c6pzagr9908jXuAI3iP4TaGU2sAss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HxN6a4K8; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725268975; x=1756804975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VZ8OdXN/IOYSuq/x5xY1eTO72fQw8fjegXdeCILRuyA=;
  b=HxN6a4K85MwG+WlUMpbjlZjWouQ2jz2zKnNdZCP9KHUnXBsi0geqS2DR
   IdyDLaamP3sITqxnFI98FtYHb2s0yTbX5A6rkAq+s4kWPiwoDkwxsnSAN
   tzeXcFG1uPFXY1306y60FjbpzIbbJWKZnA9XOMvbpw5L5zEl/Ubd6DoA8
   PtLsYJkayvIrAO/rJxKqiNOZnuFIf3oW4ujOEZY0991thw76P8AXvXJDf
   OJuKfD2wauzcDfFhFzvVh+MZAZop1NQxzNNbE92Rjs3KJGh1Pxi68yN5S
   fWajBosSCwhQUfzxJEvKVrzVXhfXAaidMW4eryU4ZsSwO20wRJ0mmwiEU
   g==;
X-CSE-ConnectionGUID: aCI3kz4FRLWWZDMVGsfiBQ==
X-CSE-MsgGUID: aL+YJ3rsSmSdOI5g+SN7Kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23649348"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23649348"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 02:22:55 -0700
X-CSE-ConnectionGUID: YYpNXTnnS8io8W/naGh2sQ==
X-CSE-MsgGUID: plyfOy16RkO8CD6qidMJZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="68942886"
Received: from lbogdanm-mobl3.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.223])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 02:22:50 -0700
Date: Mon, 2 Sep 2024 12:22:44 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <ZtWD5G0ZUp5Ui1Zp@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
 <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>

On Mon, Aug 19, 2024 at 06:09:06PM +0300, Nikolay Borisov wrote:
> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > +static u64 ____tdx_reclaim_page(hpa_t pa, u64 *rcx, u64 *rdx, u64 *r8)
> 
> Just inline this into its sole caller. Yes each specific function is rather
> small but if you have to go through several levels of indirection then
> there's no point in splitting it...

Makes sense, will do a patch for this.

> > +static inline u8 tdx_sysinfo_nr_tdcs_pages(void)
> > +{
> > +	return tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
> > +}
> 
> Just add a nr_tdcs_pages to struct tdx_sysinfo_td_ctrl and claculate this
> value in get_tdx_td_ctrl() rather than having this long-named non-sense.
> This value can't be calculated at compiletime anyway.

The struct tdx_sysinfo_td_ctrl is defined in the TDX module API json files.
Probably best to add nr_tdcs_pages to struct kvm_tdx.

> > +void tdx_vm_free(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	u64 err;
> > +	int i;
> > +
> > +	/*
> > +	 * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
> > +	 * heavily with TDX module.  Give up freeing TD pages.  As the function
> > +	 * already warned, don't warn it again.
> > +	 */
> > +	if (is_hkid_assigned(kvm_tdx))
> > +		return;
> > +
> > +	if (kvm_tdx->tdcs_pa) {
> > +		for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> > +			if (!kvm_tdx->tdcs_pa[i])
> > +				continue;
> > +
> > +			tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);
> > +		}
> > +		kfree(kvm_tdx->tdcs_pa);
> > +		kvm_tdx->tdcs_pa = NULL;
> > +	}
> > +
> > +	if (!kvm_tdx->tdr_pa)
> > +		return;
> 
> Use is_td_created() helper. Also isn't this check redundant since you've
> already executed is_hkid_assigned() and if the VM is not properly created
> i.e __tdx_td_init() has failed for whatever reason then the is_hkid_assigned
> check will also fail?

On the error path __tdx_td_init() calls tdx_mmu_release_hkid().

I'll do a patch to change to use is_td_created(). The error path is a bit
hard to follow so likely needs some more patches :)

Regards,

Tony

