Return-Path: <kvm+bounces-50819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E636AE99ED
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 11:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB0CC3AFD6B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B862BEFFD;
	Thu, 26 Jun 2025 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZRBT229D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5998929C35F;
	Thu, 26 Jun 2025 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750929962; cv=none; b=gUnZKxbIGDCp/2wiRS0B2Ld11POKUvhWAaQomxwYhy4nCvxGUXLmkdzt3PvviT2KdqayzXqS5zKULC281BKi1lqn8nXJTgvCq44EwyOsmsVxH9YjDxVqCoVHtcvLit3yTLHcrRMRSD9ccq1l+hOBFe2ifU2xL9NmGuvThewnakc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750929962; c=relaxed/simple;
	bh=A/CEx477K3LlyVUW20pN2gjB1RVa27uz7N3H7Xae94g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YW/ThyBUOWHgIVGeic0i0S3Saz2REDoTRZ4v1mIMFkujxLXCpTyI56+MDHftnZx8frRXATJ3/nqO5poV/khUr1gwn4eDbkpI3RsqUoAc+rspdcRTDLyu6kq1H/j3UAy9oFUjGYZw/zogA+WjUgx1JrCYRYRdY1gP8iri5fJ2LOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZRBT229D; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750929961; x=1782465961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A/CEx477K3LlyVUW20pN2gjB1RVa27uz7N3H7Xae94g=;
  b=ZRBT229DhSXkPoLOdWlSK4HLI2cxwsCAlkMoxW2yHTyWWb8NtOxWGbTN
   A4F5Sn45KE8zq4AnI1OsZJks+Bd+NUAHp50+sJJNBf5qh31/aqsaTu2ui
   Oyf/DFcHT/Zpez1OFvPxkkNB+KZhODNb6u1QaggdEaHi5qN2OFf+OMXJa
   46PUKpeyMqaZcr14yO+MgyOWKDONLERo7xBs2X87y4a6ljRAs14vi3iUG
   KAguOBFrrYJpZ2SNp++ytJ3V8tGXKZWapOE5qxG+YHEg1/LSobkgRHjG/
   R2c5ojp5Yx3frstRiheKf+ErP9sfMDiL9LG8R8CD0dOCb4rceprFNExpC
   Q==;
X-CSE-ConnectionGUID: 6QnXSmtLT+OJNCUIhDDavQ==
X-CSE-MsgGUID: zRwLBmV6Sq2gyjdWgIEqUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="70648820"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="70648820"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 02:26:01 -0700
X-CSE-ConnectionGUID: ceBA2M4yQme6XKoN5U9fSw==
X-CSE-MsgGUID: n20N+WilQXeThZKjmSdySQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="156500523"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa003.fm.intel.com with ESMTP; 26 Jun 2025 02:25:57 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id D5B2121E; Thu, 26 Jun 2025 12:25:55 +0300 (EEST)
Date: Thu, 26 Jun 2025 12:25:55 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <x2cuthbn54u2bqxr7sr2pt2zalvuhd3kpovrgzx42xp23wq6mw@pnvgcxs5zm45>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
 <c3f77974-f1d6-4a22-bd1d-2678427a9fb1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3f77974-f1d6-4a22-bd1d-2678427a9fb1@intel.com>

On Wed, Jun 25, 2025 at 11:06:16AM -0700, Dave Hansen wrote:
> >  /*
> >   * Locate a NUMA node which should hold the allocation of the @tdmr
> >   * PAMT.  This node will have some memory covered by the TDMR.  The
> > @@ -522,7 +534,16 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
> >  	 * and the total PAMT size.
> >  	 */
> >  	tdmr_pamt_size = 0;
> > -	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
> > +	pgsz = TDX_PS_4K;
> > +
> > +	/* With Dynamic PAMT, PAMT_4K is replaced with a bitmap */
> > +	if (tdx_supports_dynamic_pamt(&tdx_sysinfo)) {
> > +		pamt_size[pgsz] = tdmr_get_pamt_bitmap_sz(tdmr);
> > +		tdmr_pamt_size += pamt_size[pgsz];
> > +		pgsz++;
> > +	}
> 
> This is the wrong place to do this.
> 
> Hide it in tdmr_get_pamt_sz(). Don't inject it in the main code flow
> here and complicate the for loop.

Okay, makes sense.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

