Return-Path: <kvm+bounces-66611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 746B1CD8ABF
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 10:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E93403001636
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 09:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A39328B6F;
	Tue, 23 Dec 2025 09:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LdRKGntj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56D72D6E52;
	Tue, 23 Dec 2025 09:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766483879; cv=none; b=uAG2Ik4++qphY3LJSQ5Z7mkP2OQzDTv/vlxSBP4H1j8h6PD83KjPhrJ6ZANZVznLGyXypvATGDawi9KlqwyD59BowrdGJNjFnx1SN7EWGoIfZFA99GCKhr9p2EgY4zFmR+9lVdoF00mOPe9IfwKpAbkFfi+H8N6TLCBFEJ/s17w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766483879; c=relaxed/simple;
	bh=li38tDDKOJ3EltzV7moOMq1O3hO6ZqGEJWJpWr6SbvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f61JWWE99aRTkP0R+kZqvfqlAjjRbCWBpsAvcVZ+Ta1xj7qFfHR7eVi4T8/T4Q8Y9HO73BwmMEJWz1cvX0gXAkkm4p+ftwvWAzfsu09taIzUxJ3fZ3Ol4wrnQZlgN1usr7IfS+Fvgwy7OhglNIdF2HbYWX849YnlzOUvRnoGyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LdRKGntj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766483878; x=1798019878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=li38tDDKOJ3EltzV7moOMq1O3hO6ZqGEJWJpWr6SbvA=;
  b=LdRKGntj12WI/8NuT5cFiXcne8V900KceQROLzMbnl7ohUqmU8xoh9h3
   zvtXSbKG3mUo+iW/B/HfQFDqHthNWzNDvwWGlp6gWD0FM9/aYg/NDoDc6
   HfaynOuOYRaTX+VAoJv4Ate914nFp5NeWsFbHaq4XFoYIHZx+0t0pJa9+
   OzG4dhgtQjvnxOidnewA7U56WCY67XZ86vcR+RbpXwQ7eEEGS1d9M3ltL
   PsF2ZqmIJ2LxAdAVZU8E6TjZn3gvflNhU9KB4pxDjqVowG8tm3YIUrpfI
   a9bEgdzELtGKE6ifKPmztCaJN6sWMAvn94BFphN1DyAyI8CdhuVDvFGLV
   A==;
X-CSE-ConnectionGUID: EXHOkxgBRISsrI3tohJZ0Q==
X-CSE-MsgGUID: OsjoQ2tuQHGIeQytdSmeZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="78965627"
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="78965627"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 01:57:57 -0800
X-CSE-ConnectionGUID: v6HblnuRQ5ugKDdIOd1x2Q==
X-CSE-MsgGUID: iiHTl//USQq0q/QbcQBwdg==
X-ExtLoop1: 1
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 23 Dec 2025 01:57:55 -0800
Date: Tue, 23 Dec 2025 17:41:28 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 05/26] mm: Add __free() support for __free_page()
Message-ID: <aUpjyGA32vdWkWrh@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-6-yilun.xu@linux.intel.com>
 <20251219112220.00003adc@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219112220.00003adc@huawei.com>

On Fri, Dec 19, 2025 at 11:22:20AM +0000, Jonathan Cameron wrote:
> On Mon, 17 Nov 2025 10:22:49 +0800
> Xu Yilun <yilun.xu@linux.intel.com> wrote:
> 
> > Allow for the declaration of struct page * variables that trigger
> > __free_page() when they go out of scope.
> > 
> > Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Sorry I will drop this patch on v2 cause I'll use

  kzalloc(PAGE_SIZE, ...) for all single page allocation in this series.

Thanks,
Yilun

