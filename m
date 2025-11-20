Return-Path: <kvm+bounces-63885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D84C75866
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C97134E1DCB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F9B36BCFD;
	Thu, 20 Nov 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d97pGvKd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84735C186;
	Thu, 20 Nov 2025 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657770; cv=none; b=l4vJw8mQU/OtU+mMJEhHbrgXpnkgcp+s/0M6KkGItMn+cjjXnDTcR0XNFthiEdek/c3ZoYpGBI6gup5OH9yxrFOUr8qrf2CXQ8fgG9Qf8trP0gB0hIUE+eeVa3m6CdXChGGAa3wb+i/i1sxkKU3BZJVCMVPv57DP5Gt/XCPt8eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657770; c=relaxed/simple;
	bh=/0LygHJxHBH6QwfmRXqiHUnQ98vuSqjE+kOP663ZLgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZ0FGGqSgFeE2pvqt1KNpl6exe9Aj3nIkeqaCPVIx50hVPLjSTd3Xoa/TYlLdb394oHBNsPdg63tkbVRjXeRqK15ObelJAbyNNMyNPjH3vxuwb7aIewxqmnaiOUuoJipTJdGYbeuR+jwg1x8TksehMOHaBWYg7ptWKopciZsrWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d97pGvKd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763657769; x=1795193769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/0LygHJxHBH6QwfmRXqiHUnQ98vuSqjE+kOP663ZLgE=;
  b=d97pGvKdEkTFn5NErcuXo1cjUYgwSflFNjW5qKXh/c3NgXGqTsjXjOWm
   NDP6WX3fOR8zxorMZmvU4l/iJJecI7vcnhZCYgkD75F8VLRZRSibQGmI2
   0mKhBh4e3y7DKZ6cuT0GQda4nZN2BsYTM4ouQxjUflhOnIyxN0fHAapge
   Ul8QCIDa+wUfJj3lBpkuUGwoBSqEMCzL/8oyhl3ecokIME0Q2Zies0voV
   ehXU9YoKZ13NczEzY4oYOJGVzVSqYhEn1VjH4KSKqgYLOziMHS3r3IBgG
   7gl8+lr47IUqqfl5N1jL7oGP801xaRwF9tzL/Rw5fNDQk3TtLS5JQ79B1
   Q==;
X-CSE-ConnectionGUID: jF1qhexVSqyMzicy/B6R/g==
X-CSE-MsgGUID: +oG+FCA+SwqT18ilpMV6cQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="68344392"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="68344392"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 08:56:07 -0800
X-CSE-ConnectionGUID: BaU91eVcR/KM04vjeIx7AA==
X-CSE-MsgGUID: u3M1M/YzT36l4mTse/9rsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="195896805"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 08:56:06 -0800
Date: Thu, 20 Nov 2025 08:56:00 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 01/11] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
Message-ID: <20251120165600.tpxvntu6rv7c34xd@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-1-1adad4e69ddc@linux.intel.com>
 <abe6849b-4bed-4ffc-ae48-7bda3ab0c996@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abe6849b-4bed-4ffc-ae48-7bda3ab0c996@suse.com>

On Thu, Nov 20, 2025 at 06:15:32PM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/20/25 08:17, Pawan Gupta wrote:
> > Currently, BHB clearing sequence is followed by an LFENCE to prevent
> > transient execution of subsequent indirect branches prematurely. However,
> > LFENCE barrier could be unnecessary in certain cases. For example, when
> > kernel is using BHI_DIS_S mitigation, and BHB clearing is only needed for
> > userspace. In such cases, LFENCE is redundant because ring transitions
> > would provide the necessary serialization.
> > 
> > Below is a quick recap of BHI mitigation options:
> > 
> >    On Alder Lake and newer
> > 
> >    - BHI_DIS_S: Hardware control to mitigate BHI in ring0. This has low
> >                 performance overhead.
> >    - Long loop: Alternatively, longer version of BHB clearing sequence
> > 	       on older processors can be used to mitigate BHI. This
> > 	       is not yet implemented in Linux.
> 
> I find this description of the Long loop on "ALder lake and newer" somewhat
> confusing, as you are also referring "older processors". Shouldn't the
> longer sequence bet moved under "On older CPUs" heading? Or perhaps it must
> be expanded to say that the long sequence could work on Alder Lake and newer
> CPUs as well as on older cpus?

Ya, it needs to be rephrased. Would dropping "on older processors" help?

    - Long loop: Alternatively, longer version of BHB clearing sequence
		 can be used to mitigate BHI. This is not yet implemented
		 in Linux.

> > 
> >    On older CPUs
> > 
> >    - Short loop: Clears BHB at kernel entry and VMexit.

And also talk about "Long loop" effectiveness here:

    On older CPUs

    - Short loop: Clears BHB at kernel entry and VMexit. The "Long loop"
		  is effective on older CPUs as well, but should be avoided
		  because of unnecessary overhead.
> <snip>

