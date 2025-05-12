Return-Path: <kvm+bounces-46159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36984AB3407
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAF0318903B6
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB62C256C85;
	Mon, 12 May 2025 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vg6gsGJu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F52225E45B;
	Mon, 12 May 2025 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747043519; cv=none; b=UBoTeSuVifRAjDnDClfN6Tdm4M90V7sSG7GR0eA5bmVop+KQnjRJXW7iw0iRNHgtGsCRL+/PTCwrzigLXbTJV2Fh/FSYouimWsSVLCyrvxqoLMcJEKVXCov7WrN9d7/YKgCezulGa6s28yk58NxFHiU7JJVWsaOF8h2ynmN4RZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747043519; c=relaxed/simple;
	bh=U3kxLmaDBcWPNdS1y4a7XxYkkLg/GskUTuCnO6Vos5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a50Cvohdy3jn1iu8kcy06EPXvmo5wrlhcMV71fhA/vhZ6Ol0r/pvwYoKZqeA8ZKYV9B77R0I89bPQEpaiZ/ls36Y3IrDFzA/fUDVQUOd6MOr0+3PuANR/sBNwjMWGwn+MsXXx6VLP0bi2JvWmz0uFX8ygJwTbx5Q+3JAdNcNdEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vg6gsGJu; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747043518; x=1778579518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U3kxLmaDBcWPNdS1y4a7XxYkkLg/GskUTuCnO6Vos5s=;
  b=Vg6gsGJuLBGiTKaod3mRqMckhIhM5KogdGk9N0xaBv29OKr4noPM9laW
   WAB4tSUcc1Q63l/M4OyfHiW7N7MLxbbknmaMkMwWnKybSECMiRIWrxA8m
   2IZmR4fsvaeYtPiQnNRG6GSDorMj85NSeVgVyYPLCT95TQUWMxtFgaPje
   kMLn21ZkWDm/HB03gMOv2s8RD3u1cEAcMb99m62yh7Id0irrvyLiXYylB
   efg3ZKXCbB9lq+Gkz+641BUCcjC6buNSKmn4SZDy9QSEmKvWiAvBC/4l4
   +qiT6tKDm0heaR4kcD5X3SlSKJDP8dYMIWNQywP9RQ/9q4wgUv/7hlnSa
   w==;
X-CSE-ConnectionGUID: yG93X6ndRmulVzmYhzNn2A==
X-CSE-MsgGUID: HvyzQq5uT4S3CkG7iIx5dA==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="71342365"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="71342365"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 02:51:57 -0700
X-CSE-ConnectionGUID: eHyUUIPORjuruCP9ICVHDw==
X-CSE-MsgGUID: bjL+nvhISpKnSQut+bya9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="160569513"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 12 May 2025 02:51:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id C445819D; Mon, 12 May 2025 12:51:46 +0300 (EEST)
Date: Mon, 12 May 2025 12:51:46 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Message-ID: <mfimpdavswvvwot6kosmfgkg2grnbv4fkw3lsonytpcoiiso7v@n6e5mjxo4ewo>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
 <aB3QUKanj5KajTs9@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB3QUKanj5KajTs9@intel.com>

On Fri, May 09, 2025 at 05:52:16PM +0800, Chao Gao wrote:
> >+static int init_pamt_metadata(void)
> >+{
> >+	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> >+	struct vm_struct *area;
> >+
> >+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> >+		return 0;
> >+
> >+	/*
> >+	 * Reserve vmalloc range for PAMT reference counters. It covers all
> >+	 * physical address space up to max_pfn. It is going to be populated
> >+	 * from init_tdmr() only for present memory that available for TDX use.
> >+	 */
> >+	area = get_vm_area(size, VM_IOREMAP);
> >+	if (!area)
> >+		return -ENOMEM;
> >+
> >+	pamt_refcounts = area->addr;
> >+	return 0;
> >+}
> >+
> >+static void free_pamt_metadata(void)
> >+{
> >+	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
> >+
> 
> Shouldn't the free path also be gated by tdx_supports_dynamic_pamt()?

True. Missed this.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

