Return-Path: <kvm+bounces-10736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26CD186F3A8
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 05:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504F41C20F77
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 04:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5617079D8;
	Sun,  3 Mar 2024 04:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BH6uByEa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B331753BE;
	Sun,  3 Mar 2024 04:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709441493; cv=none; b=Uk9Dng+4FeWaQFtndKlIZfm/HigD55C7JVOVofST0tJGDLX7IFecaqXuUlY7Hll87xMU+zbOWIix4f72exNJyPgN/yaTLYtqRwT3mPHYoeBBMUYx8hWdl9QcjoHPrYdiQWXloEBKwUFNbfpr8f2l+dQa5MZRmpnODYgmFlWUpKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709441493; c=relaxed/simple;
	bh=DiznAYK71m8KjN3kngmKzjZ08qDdBKWha23BeRkoj2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzZG/0e9IDcbemzcUc/ctcAgKMLDawIHLxdU0/eFJkNCnx5shxD2OrmBdRk/NvEXHtpTS37hSFphBs1wfisV83OyWUFGBBgLgeE2tdR8bBt61TvDA16tnClS2oWkzv7XIM19OaYw1e4ibBN11cRdu9OoCBA3e0cHJ1untL4D/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BH6uByEa; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709441492; x=1740977492;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DiznAYK71m8KjN3kngmKzjZ08qDdBKWha23BeRkoj2U=;
  b=BH6uByEalP3xReEcXzs7RGVVqK58iHJnXN5Hkf0I1weTCBB2Q7QqWInB
   c8SnAaSWQSjZmqNOFZfaxjgo3PhxIf6iUTHCUnk1q2Qh1v0jauxlXOGzX
   XTVktWsNSLgBiFHyZ55K7L3U6mbnDY947lbfwtdJDNZFaWoGe2GylDrld
   GmuWLAcA9U29gAtgSGG4EPo9p9dZt8mbpfl6sRiAcsO7a4wYuLXRxcbA6
   SDHsxV4mm6A0CJcvhar+qP1qH0cCpmGQLSGvEabEG+Noui+XlSoZhQtpl
   sZlLsEOF4Yujq0MsBqkZdkucwf5OmUM+C5yKc+I/2mMlELabk6Ltij2k4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11001"; a="7723694"
X-IronPort-AV: E=Sophos;i="6.06,200,1705392000"; 
   d="scan'208";a="7723694"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2024 20:51:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,200,1705392000"; 
   d="scan'208";a="39621421"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 02 Mar 2024 20:51:29 -0800
Date: Sun, 3 Mar 2024 12:47:19 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: Re: [PATCH 11/21] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Message-ID: <ZeQA12SlPPSgLBGG@yilunxu-OptiPlex-7050>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-12-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227232100.478238-12-pbonzini@redhat.com>

On Tue, Feb 27, 2024 at 06:20:50PM -0500, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Refactor tdp_mmu_alloc_sp() and tdp_mmu_init_sp and eliminate
                                  ^
tdp_mmu_init_sp() 

> tdp_mmu_init_child_sp().  Currently tdp_mmu_init_sp() (or
> tdp_mmu_init_child_sp()) sets kvm_mmu_page.role after tdp_mmu_alloc_sp()
> allocating struct kvm_mmu_page and its page table page.  This patch makes
> tdp_mmu_alloc_sp() initialize kvm_mmu_page.role instead of
> tdp_mmu_init_sp().
> 
> To handle private page tables, argument of is_private needs to be passed
> down.  Given that already page level is passed down, it would be cumbersome
> to add one more parameter about sp. Instead replace the level argument with
> union kvm_mmu_page_role.  Thus the number of argument won't be increased

This section is hard to understand. I'm lost at which functions are
mentioned here that took the level argument and should be replaced by
role.

> and more info about sp can be passed down.

My understanding of the change is:

Extra handling is need for Allocation of private page tables, so
earlier caculate the kvm_mmu_page_role for the sp and pass it to
tdp_mmu_alloc_sp().  Since the sp.role could be decided on sp
allocation, in turn remove the role argument for tdp_mmu_init_sp(), also
eliminate the helper tdp_mmu_init_child_sp().

> 
> For private sp, secure page table will be also allocated in addition to
> struct kvm_mmu_page and page table (spt member).  The allocation functions
> (tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know if the
> allocation is for the conventional page table or private page table.  Pass
> union kvm_mmu_role to those functions and initialize role member of struct
        ^

Should be kvm_mmu_page_role

Thanks,
Yilun

