Return-Path: <kvm+bounces-46162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E71AB3421
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77E3B3B7ACE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D01BE25F972;
	Mon, 12 May 2025 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GrN0c8Wa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F325EF9B;
	Mon, 12 May 2025 09:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747043760; cv=none; b=S40bsU4ZQU75PMcpYd2Kr87D0siHKtQfPYm3m2lWi8T9Mmv934/gKUwEPCKE4nWKqIKZ6lQQx/vFAdg9Vy0EiEcMQChlsxU8l51VwHoTAeREVDRk65yhkS44dcnkxzpNgybt5fwAHxg4zO5a9QvIxGCn2PMlEk9LWmNQmyfJMw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747043760; c=relaxed/simple;
	bh=H15JpCve/uOg7AG6u4IHz17Kkvl9qX3LKOv8nt8A0Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hasqhU8B2Jr71eqXIyu8IsGpGOUcs7LrZEfjgp9RL+ElkkjQrz/jZtKr9vv9LWPwn8tvmnu68c5Y2IaA+IzWiEiPd5SY4xYuX/7hJ4KS3dA0IWXahMZhH0o5jpQJpYQuO29HmVChohhNTLpjVCUmkfEuk6ZfDLduzcWXHeFcYJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GrN0c8Wa; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747043758; x=1778579758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H15JpCve/uOg7AG6u4IHz17Kkvl9qX3LKOv8nt8A0Jc=;
  b=GrN0c8WaDjxVSxoZD+hQFIYvrnfXy551IcUtpvx04ShdseJ+QeFWf93u
   zvnRrGMVw+rt+XFNRkyYB6WCGIbHKbNFokvNRLTX/9hY53KUtvW6YwVd2
   2okf/1H0LThOdfAxhmvgadlFDScchIElMl5kfmgAZHDxOl7nufuIpL04W
   BE3w3N42rOtLdALP/M/loaCM+Ar1HUMEUTZ/s4XYu9ZUUE1kzITl4t3+Q
   +Jy7brq9Xms0AC9r2UBAPSrbI9IM1Oz2D7QDZlFRJNX2ywibTGdceaM90
   GLmt6uMof4Fc9pddp5c5JxGACXDTo7cojb3kOIGmSUIwwn4//UXwURabw
   A==;
X-CSE-ConnectionGUID: Hg42At2LRNqVRlrzdcQPQQ==
X-CSE-MsgGUID: ncFBooY9RLKo44SbwqkQsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48827963"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="48827963"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 02:55:55 -0700
X-CSE-ConnectionGUID: +YZWL2W+QxGi3EkMfaEIBw==
X-CSE-MsgGUID: R8xRixuFRzqkv6hTcmCW9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="137788596"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 12 May 2025 02:55:52 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id C060919D; Mon, 12 May 2025 12:55:50 +0300 (EEST)
Date: Mon, 12 May 2025 12:55:50 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>

On Fri, May 09, 2025 at 09:25:58AM +0800, Yan Zhao wrote:
> On Thu, May 08, 2025 at 04:23:56PM +0300, Kirill A. Shutemov wrote:
> > On Tue, May 06, 2025 at 07:55:17PM +0800, Yan Zhao wrote:
> > > On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> > > > The functions kvm_x86_ops::link_external_spt() and
> > > > kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> > > > When using TDX with Dynamic PAMT enabled, the assigned memory must be
> > > > covered by PAMT.
> > > > 
> > > > The new function kvm_x86_ops::phys_prepare() is called before
> > > > link_external_spt() and set_external_spte() to ensure that the memory is
> > > > ready to be assigned to the virtual machine. In the case of TDX, it
> > > > makes sure that the memory is covered by PAMT.
> > > > 
> > > > kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> > > > is available, allowing the implementation to allocate memory from a
> > > > per-VCPU pool.
> > > > 
> > > Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
> > > Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?
> > 
> > Because the memory pool we allocated from is per-vcpu and we lost access
> > to vcpu by then. And not all callers provide vcpu.
> Maybe we can get vcpu via kvm_get_running_vcpu(), as in [1].
> Then for callers not providing vcpu (where vcpu is NULL), we can use per-KVM
> cache? 

Hm. I was not aware of kvm_get_running_vcpu(). Will play with it, thanks.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

