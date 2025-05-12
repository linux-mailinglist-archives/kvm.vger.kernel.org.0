Return-Path: <kvm+bounces-46161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51BF3AB3418
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55E1B17C8B5
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87D425FA31;
	Mon, 12 May 2025 09:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JyJmDA9w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFD22550C9;
	Mon, 12 May 2025 09:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747043722; cv=none; b=Ny1GfvVzOihn8zxFbw6sCNyr+XEvqYIpSeiyELo8AcGryBP+MStgzj278Lef8UT9CH8X7K5lZcOaKy5EoemjiLXoCGeSU30NP/S9qUutq5g+IgR6NIU4TVgIJqoQgAbhRAbFf/36k/VDvjQQOBNCW8snOoDkB4J+GWD4Nmy9MAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747043722; c=relaxed/simple;
	bh=hqhnstJx2uy9f+VTTs0CnDZAuq5j2171neg9fcKEwOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qPq1HaD5mRmwruMbCBtPIkuff/lsnGJjRGFCoHsKkLFNrXa1iqTCnMwjTTOUcqwulyomhQ8EGmoG2Eo7321DEZWaq2sG+5Ma070PYCihlOMEt/5cEKa2lbRk7FHJcmzyOMl7W0G9AYtj0tdgk0MRBlzpstoBAqb6+wing3C7G0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JyJmDA9w; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747043722; x=1778579722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hqhnstJx2uy9f+VTTs0CnDZAuq5j2171neg9fcKEwOo=;
  b=JyJmDA9warpaiiu0pg4CAdgwl3irftG2vEpryduMkupTiq2b7DAQLG/k
   Cr+pauaJiG097T7+BV4pFuKI2ucsW+2p1xXyKZDTToDmQ+4ngZxmD0MCP
   s8Ogd/TDaX/zc6T++x5KdJXu4OxtrZS2jLnHMNY15mAlZh0Uu0nuESkX3
   8D4qZyL87n+3vR4YnWgjHBZSQtucsXWjEe5u7a7NfF8UhppQs89WK+PKu
   4vTYgSiufi0Xqji6Cvvk9kwSqBCOaaHwXw76vBm+YhoWjXQ+phMn3ihK/
   4UPjyxWVsrrsWrLK99VFJ8Ypo4Dw+8MoqJkq9wlisDwyAp1NVVI8FTkbv
   g==;
X-CSE-ConnectionGUID: EwmJU3GySXCJclgDMZ/2yA==
X-CSE-MsgGUID: bKpELjGTR32fhlJa7eGm0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48908693"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="48908693"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 02:55:21 -0700
X-CSE-ConnectionGUID: K7gbih2JT/aONFtmFvYk7A==
X-CSE-MsgGUID: PmzUTkOURFWqLbQFeudz4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="137349324"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 12 May 2025 02:55:17 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 3A17919D; Mon, 12 May 2025 12:55:16 +0300 (EEST)
Date: Mon, 12 May 2025 12:55:16 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 03/12] x86/virt/tdx: Add wrappers for
 TDH.PHYMEM.PAMT.ADD/REMOVE
Message-ID: <3coaqkcfp7xtpvh2x4kph55qlopupknm7dmzqox6fakzaedhem@a2oysbvbshpm>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-4-kirill.shutemov@linux.intel.com>
 <aB3WWUSESKt9niJV@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB3WWUSESKt9niJV@intel.com>

On Fri, May 09, 2025 at 06:18:01PM +0800, Chao Gao wrote:
> > int tdx_guest_keyid_alloc(void);
> > u32 tdx_get_nr_guest_keyids(void);
> > void tdx_guest_keyid_free(unsigned int keyid);
> >@@ -197,6 +202,9 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
> > u64 tdh_phymem_cache_wb(bool resume);
> > u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
> > u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
> >+u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages);
> >+u64 tdh_phymem_pamt_remove(unsigned long hpa, struct list_head *pamt_pages);
> 
> When these SEAMCALL wrappers were added, Dave requested that a struct page
> be passed in instead of an HPA [*]. Does this apply to
> tdh_phymem_pamt_add/remove()?
> 
> [*]: https://lore.kernel.org/kvm/30d0cef5-82d5-4325-b149-0e99833b8785@intel.com/

hpa here points to a 2M region that pamt_pages covers. We don't have
struct page that represents it. Passing 4k struct page would be
misleading IMO.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

