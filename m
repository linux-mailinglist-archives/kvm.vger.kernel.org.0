Return-Path: <kvm+bounces-12624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB6FC88B318
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FB4D1F29C24
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79126FE08;
	Mon, 25 Mar 2024 21:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4Z+9Ajx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7195D8E0;
	Mon, 25 Mar 2024 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711403333; cv=none; b=rjBxv336riJTFnthZDP3ChVEEY3xG7v/uPcMCCJFe9u0OhLwB9obSavzGuRy1qSoi+lw74o3DpQIxgCiePEhIdhDg7N1c8fpfH/wE80YOqJIh5pJ9A4N9IJ5RHMyNJzkiSymIRDXAnLkGduOJl224D2GX+Akb+rITWBRIpy/9e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711403333; c=relaxed/simple;
	bh=eIyEkdLme3YwP3nX80zt2BK9NvuG/TevdkijeZMdiO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUWGrRYQ4rvcvvjvqN3zHABthrG8oKnt9HQUm1Cz04CruoRqWS6pcmjZ5cA2KaqTdphP+7LSKjvikWEmw/8Ba6JDVhXFw/hDDkceQ2HomkOiM6HY++wI3JbEqp0dOfhjEcTDyjotb38Clq1HAhaySGQKPLu9Vi70qSzElEKtDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4Z+9Ajx; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711403331; x=1742939331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eIyEkdLme3YwP3nX80zt2BK9NvuG/TevdkijeZMdiO4=;
  b=e4Z+9AjxlWXbZYeyyBTtPtdkZlnka0GADBY8ucu1BlSmP6sWkz2wVXvq
   Rj8HtvFMkONap0f/7di08dIkH25zcnmKUdGMIJaBSO9n0LHIXjzoLIvTo
   2PlLge+8ujDn5Unr15NepujRW0mtwPnfX/H1cVhcfvRsmJVeWkdzZsiN9
   XFWQHjicYLfQQ+kaC7dzy9dOs4qQzvDEzZOIv3rkHY98j/yNyUDa/5Olw
   tlLG5bY1tCqXrSHBA1uOEa9mMV1ztjtTPEnRDBgMP3VigBeC/sjF+2oOE
   viSvKYpx6Jt52lL09LYybFQQ/cq1euiSoOwTTPQNcXvZHAd/xREbMBCfA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6294608"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6294608"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="38868640"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:48:51 -0700
Date: Mon, 25 Mar 2024 14:48:49 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240325214849.GM2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ba217de2-cdcb-4f50-80cc-c61a0e8255b2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba217de2-cdcb-4f50-80cc-c61a0e8255b2@linux.intel.com>

On Mon, Mar 25, 2024 at 05:58:47PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +static void tdx_clear_page(unsigned long page_pa)
> > +{
> > +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > +	void *page = __va(page_pa);
> > +	unsigned long i;
> > +
> > +	/*
> > +	 * When re-assign one page from old keyid to a new keyid, MOVDIR64B is
> > +	 * required to clear/write the page with new keyid to prevent integrity
> > +	 * error when read on the page with new keyid.
> > +	 *
> > +	 * clflush doesn't flush cache with HKID set.  The cache line could be
> > +	 * poisoned (even without MKTME-i), clear the poison bit.
> > +	 */
> > +	for (i = 0; i < PAGE_SIZE; i += 64)
> > +		movdir64b(page + i, zero_page);
> > +	/*
> > +	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> > +	 * from seeing potentially poisoned cache.
> > +	 */
> > +	__mb();
> 
> Is __wmb() sufficient for this case?

I don't think so because sfence is for other store. Here we care other load.

> > +
> > +static int tdx_do_tdh_mng_key_config(void *param)
> > +{
> > +	hpa_t *tdr_p = param;
> > +	u64 err;
> > +
> > +	do {
> > +		err = tdh_mng_key_config(*tdr_p);
> > +
> > +		/*
> > +		 * If it failed to generate a random key, retry it because this
> > +		 * is typically caused by an entropy error of the CPU's random
> 
> Here you say "typically", is there other cause and is it safe to loop on
> retry?


No as long as I know. the TDX module returns KEY_GENERATION_FAILED only when
rdrnd (or equivalent) failed.  But I don't know the future.

Let's delete "tyepically" because it seems confusing.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

