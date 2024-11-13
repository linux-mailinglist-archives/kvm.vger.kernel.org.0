Return-Path: <kvm+bounces-31806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 593C39C7D51
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A1C5284331
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE0C207204;
	Wed, 13 Nov 2024 21:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mKkhmwDq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5C32064E9;
	Wed, 13 Nov 2024 21:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731532107; cv=none; b=JcgyE76MrBcGNlP4idCQd1B7RDQf2Z3CZlZXBkY0oNgjjULxIfhx4sfBalklCtaY1KhnbQH6mLfIXx4T71LKDHmwFNLPGq9is1Lv3OImdgKC7+Q3F+Nq5KQjZ3UmJ1+JRqIdGoVQNI8E27McQEzFOpXLPSl55yvxgrojGQ6rdx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731532107; c=relaxed/simple;
	bh=cvdwnx7NqJv45aohmea/u4F7NAdmBdqQNMMu7T5ROkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9jGFZv/vLfdja6HOgT6ctqvxdQauo7wjY6AT18krsi/jxVIbcPR87B+Mhise3J0r7RreWewJocic3jdzcdhFbYQTV838x4dz2sBw03eRzXA9jZnTP1065j/lduxzrtdXgUedMqTwl33Al2x6Hi/PcRvVhh7UDrfoblPQnD6rV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mKkhmwDq; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731532106; x=1763068106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cvdwnx7NqJv45aohmea/u4F7NAdmBdqQNMMu7T5ROkk=;
  b=mKkhmwDqWmhPkWrfef3vqDTxjy8U8JoYj4LeGcf3+afmE47bTihUbl48
   aAxbc8DSFtu8NiH2QG+nCOw0QyXHYMx6XQezPkjdIpMPYjz9FNvShl0oU
   4hxvxmnRFRaxP3+6d+pFCsCSbieSd7Ht8DKjU2OHJPAUF6iZrjHJtFcYT
   cq0JevLp6ON0sA7lOtANBwHK60joU9lnKeEw1KD7Zeu+Wf4Z8b+OwAOgz
   pUQ69IuqAKpTXtxaWoqP50PWCEEFLAs9ibprGMO/rrcjxJi6yPw1X5s40
   KAE1372qyFqKCE8uiu9x+G3M1dhG/Yn64u/oUMigW8SyF69KeE0R4z6pR
   g==;
X-CSE-ConnectionGUID: XnFeFiALST6n+mshGPdHrg==
X-CSE-MsgGUID: n7VYQmtcSXu5lgY912wD+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31553209"
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="31553209"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:08:25 -0800
X-CSE-ConnectionGUID: 7KrIu2dmTeSwJk/FlT2D8g==
X-CSE-MsgGUID: 0WO4fQx7QtCkf+yRLav87Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92911383"
Received: from kkkuntal-desk3 (HELO [10.124.220.196]) ([10.124.220.196])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 13:08:24 -0800
Message-ID: <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
Date: Wed, 13 Nov 2024 13:08:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 12:51, Edgecombe, Rick P wrote:
> However, some future user of TDH.PHYMEM.PAGE.RECLAIM might want to do something
> else where the enums could add code clarity. But this goes down the road of
> building things that are not needed today.

Here's why the current code is a bit suboptimal:

> +/* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
> +static int __tdx_reclaim_page(hpa_t pa)
> +{
...
> +	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
> +		err = tdh_phymem_page_reclaim(pa, &rcx, &rdx, &r8);
...
> +out:
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, rcx, rdx, r8);
> +		return -EIO;
> +	}
> +	return 0;
> +}

Let's say I see the error get spit out on the console.  I can't make any
sense out of it from this spot.  I need to go over to the TDX docs or
tdh_phymem_page_reclaim() to look at the *comment* to figure out what
these the registers are named.

The code as proposed has zero self-documenting properties.  It's
actually completely non-self-documenting.  It isn't _any_ better for
readability than just doing:

	struct tdx_module_args args = {};

	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
		args.rcx = pa;
		err = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
		...
	}

	pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err,
			args.rcx, args.rdx, args.r8);

Also, this is also showing a lack of naming discipline where things are
named.  The first argument is 'pa' in here but 'page' on the other side:

> +u64 tdh_phymem_page_reclaim(u64 page, u64 *rcx, u64 *rdx, u64 *r8)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = page,

I can't tell you how many recompiles it's cost me when I got lazy about
physical addr vs. virtual addr vs. struct page vs. pfn.

So, yeah, I'd rather not export seamcall_ret(), but I'd rather do that
than have a layer of abstraction that's adding little value while it
also brings obfuscation.

