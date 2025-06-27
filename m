Return-Path: <kvm+bounces-50992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBFEAEB868
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0CB6642B23
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02BD82D979E;
	Fri, 27 Jun 2025 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qj4zAGp1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D6264FBB;
	Fri, 27 Jun 2025 13:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751029461; cv=none; b=L3sbU+23nb+dEXwmQs6Om/B3455vzmGmOsJRNtn3VCFHhuCIbXCIRDsDzVC+u4HibaWDvqmoJthDq/Uy854VkS7Ew2a+rfEzzF/Aoyc2adtbzQ428RRrpAjdqkMZiMDCDgEKX7YtY4zxuDtiDWmmyxI6ypDKz7dv0ulv2LUy9Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751029461; c=relaxed/simple;
	bh=XzX4psFBvnYR6QHI3Kw1ucRawOE+xlOc/dM9jXgI1bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUbcQU6KzXp8TqxyAcx/Lo7ApwUFaSBb+T1S5556dqsBCg3ewwT6VBk6CxCavWcBEd6zLDlhRUQWEffFozQE51kCGtzvkqqTsblBDEvtkrtalgHVwNfNR9GrnozcOVkchV6KuhtyqcEr1tZ3UyOYvudG5PkY9z1LaOLj6Ar931c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qj4zAGp1; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751029459; x=1782565459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XzX4psFBvnYR6QHI3Kw1ucRawOE+xlOc/dM9jXgI1bU=;
  b=Qj4zAGp1nkz4s5S6kAIIP4UqFpVrUt6AJXZetUhU1KQY03w86Tdk+Bpx
   hljB+ArUX5eRHBj5/BP+iXcm5Q95t4K6F7FCyqRLXZN0IR+gj9DXRfQo8
   /2MqY/C0plAkOiRfXTYFyEPupx6Xxgt47LyY7SZPPGsQN/k2ASAfyYDC2
   Fl0nKghJnlbhSSSRc0k5ZpXVXrfdhkSNC25VkyZKOxaYDc747LQVX85hL
   JOOtA6U3xCJEA5hbFbUOeqTbqfiazAILvHiok+2hm1mXpoPA/5Jju3J0n
   UJyPb6rCA/Orqu93SLYoZSAOkUcwojl3K2XZjMf6Jen2+yDDWDMfV+9YJ
   g==;
X-CSE-ConnectionGUID: 6zWTJDa9SluUqD+NdnUTig==
X-CSE-MsgGUID: s5wI5y4OQFar0KX95jYu9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="70773961"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="70773961"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 06:04:02 -0700
X-CSE-ConnectionGUID: ldfBJ5F6RAmcS7Go8ORzNA==
X-CSE-MsgGUID: L9DsV3rAT+Wj/YlqbN+IEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="183836732"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa002.jf.intel.com with ESMTP; 27 Jun 2025 06:03:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 01F626A; Fri, 27 Jun 2025 16:03:56 +0300 (EEST)
Date: Fri, 27 Jun 2025 16:03:56 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <g5akv7uwsdrvs3j4wsj2xmc3fpdlyudj5sjuhw62m3f4yjsxse@nrne5miazbx4>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
 <dba2841f-0725-4b58-b633-650201c053b4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dba2841f-0725-4b58-b633-650201c053b4@intel.com>

On Fri, Jun 27, 2025 at 10:49:34AM +0300, Adrian Hunter wrote:
> On 09/06/2025 22:13, Kirill A. Shutemov wrote:
> > +static void tdx_pamt_put(struct page *page, enum pg_level level)
> > +{
> > +	unsigned long hpa = page_to_phys(page);
> > +	atomic_t *pamt_refcount;
> > +	LIST_HEAD(pamt_pages);
> > +	u64 err;
> > +
> > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > +		return;
> > +
> > +	if (level != PG_LEVEL_4K)
> > +		return;
> > +
> > +	hpa = ALIGN_DOWN(hpa, PMD_SIZE);
> > +
> > +	pamt_refcount = tdx_get_pamt_refcount(hpa);
> > +	if (!atomic_dec_and_test(pamt_refcount))
> > +		return;
> > +
> > +	scoped_guard(spinlock, &pamt_lock) {
> > +		/* Lost race against tdx_pamt_add()? */
> > +		if (atomic_read(pamt_refcount) != 0)
> > +			return;
> > +
> > +		err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
> > +
> > +		if (err) {
> > +			atomic_inc(pamt_refcount);
> > +			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", err);
> > +			return;
> > +		}
> > +	}
> > +
> 
> Won't any pages that have been used need to be cleared
> before being freed.

Good point. I missed that.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

