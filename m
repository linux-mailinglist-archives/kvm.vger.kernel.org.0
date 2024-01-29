Return-Path: <kvm+bounces-7314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 357B083FFF9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 09:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5C9A283A82
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 08:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634E653E1E;
	Mon, 29 Jan 2024 08:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sn8ky+Oy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256353E02
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706516658; cv=none; b=Io+hzBoC7ZCteC4VNQjhQ7qImrALqe7FUo1az0pHpnZm5e/HQSYr/LJ2R/Zfss84PNvgbm3yEBy+UTh5/ipKD+4Jn50aEbY8hF3KBv5vHlybXvYnxiEO9+oJq6/8lZ3ybY69Ngyz8NwabAHHF4yfgN+sGnmlsgTdiXC7ibe+zgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706516658; c=relaxed/simple;
	bh=/ON53993bSHLEULOjszXljPSGFpuzAjJSu8/w2pK7qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gd7K+KJYWlaW5W9uhFSaYGAXmCG8rv0Ng0mwTgXabqDWPD/LlzbROzdXOZmC3z/19e1O5tv6I5shL4lkT3L/EGsdVGsO10KOYJyYhrecUthIAVk0swxj9VEi5yEQjbDchyTBuWvCrJMhEkdRUKkbrknrGYMTmwdRXEzxTUPox58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sn8ky+Oy; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706516657; x=1738052657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ON53993bSHLEULOjszXljPSGFpuzAjJSu8/w2pK7qc=;
  b=Sn8ky+Oy3yprQwQfIUIwNLoToOSL7IFJbRj+m79XS6n9ibtt1+lPmKZu
   xOiqv1zDwSFk8l40R2682ga5R2fxMHLnPMYpC948aG+0mzjhUFSwClJug
   6NbbsGeNfi4FnAZd3iV/T6gGe229xCNymUWCCU7ay71FS9hrFO5GU52X4
   SGKdZ0j20CbV7b6LiWCGA56NgbXzMwIq/ALRIfBH+wya3k9G7/Xr8vFGG
   dLO1uR75LphQgyjKg2kgN3iviD0KlLpKJjH09fv/lYdYdG2OVYZiDRHte
   yusZteTCPe5zIm5mlVELVvdKyc/ECndhbMMvauHPRAnfLn2b1z4Jn7EIm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="9996775"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="9996775"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 00:24:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="3390785"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 00:24:14 -0800
Date: Mon, 29 Jan 2024 16:21:12 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
	yi1.lai@intel.com, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix dirty_log_page_splitting_test as
 page migration
Message-ID: <Zbdf+GSYU+5EGfBL@linux.bj.intel.com>
References: <20240122064053.2825097-1-tao1.su@linux.intel.com>
 <ZbQYlYz5aCPFal5f@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbQYlYz5aCPFal5f@google.com>

On Fri, Jan 26, 2024 at 12:39:49PM -0800, Sean Christopherson wrote:
> +David
> 

[ ... ]

> >  
> >  	/*
> > @@ -192,7 +193,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
> >  	 * memory again, the page counts should be the same as they were
> >  	 * right after initial population of memory.
> >  	 */
> > -	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
> >  	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
> >  	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
> 
> Isn't it possible that something other than guest data could be mapped by THP
> hugepage, and that that hugepage could get shattered between the initial run and
> the re-population run?

Good catch, I found that if the backing source is specified as THP, all hugepages
can also be migrated.

> 
> The test knows (or at least, darn well should know) exactly how much memory is
> being dirty logged.  Rather that rely *only* on before/after heuristics, can't
> we assert that the _delta_, i.e. the number of hugepages that are split, and then
> the number of hugepages that are reconstituted, is greater than or equal to the
> size of the memslots being dirty logged?

Due to page migration, the values of get_page_stats() are not available (including
pages_2m and pages_1g), and dirty logging can only count the pages that have been
split. It may be possible to use the existing guest_num_pages to construct the
following assert condition:

        guest_num_pages <= the number of dirty pages

Do you think this assert condition is correct and enough?

Thanks,
Tao

> 
> >  }
> > 
> > base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
> > -- 
> > 2.34.1
> > 

