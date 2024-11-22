Return-Path: <kvm+bounces-32380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DD89D63AF
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 19:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61173282AC0
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 18:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8551DF98E;
	Fri, 22 Nov 2024 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BDg+Gqmf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE570809;
	Fri, 22 Nov 2024 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732298665; cv=none; b=c+kqg4GlvKvnEvzEPo1ImF4dgruLSR3ryhE4m/JcaWjc1FErJ5aHN3jucPgynr6IFOj1XCb2ymOqCtje0qhTwM4avf38ogZWn74z39D+MNSVrFKn42aQj2wo1X1LK726dY8+DFMfqyf2OkmKd/aE4TwH3P+lvg+2laDGC5uAzFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732298665; c=relaxed/simple;
	bh=5fdyHu+mVj81YDXP9szqeZG7VAo7sEaZDDuoEAjH5Zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kskOI6anJMPKEY7JrATBsyXRlLcvM9BzRzTDJlJx4BWqFzmYwymvWDVI4PMX3ZsTiGLNKAfNLTM8BT4mjD7vuYcPDJdcHrC1xnKzE6PZ721+UXDsxPpHbkprPXa0L19KZKU4JCv6SpzDG5+CNNDNTGYW0cZMftzsm+Ch2ceXjPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BDg+Gqmf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732298664; x=1763834664;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5fdyHu+mVj81YDXP9szqeZG7VAo7sEaZDDuoEAjH5Zc=;
  b=BDg+Gqmf88HKcvahbChsOq55SFSlliBX7JYhC6rubujqM/sw0es1yJ0N
   0ZRnNSQGNh5qGlUIpPQ5UZJ3/fpMU4mvvjvNG6+eWNB8+Ohznz2WM8E95
   dGdlTfnUFn24OzE4tP6+thg7/2NkTVE07sfM922+gQFpOCyfNDR+x4Qa7
   Wsqcd9uRVBVGUS1PcdkfZhFOOlnnIVE7GJVyQ2nA1bn9mNUkaTcrJH4tq
   gHKn7ydsks3zYzo4/nv94ay88nWoUIytgbXWExPF+MrVk/O4HXMwBGEZ2
   edeOX6VAMliP20c9PPZ+PaLZwrtAOcbL19f+iecNJA3gcA2SbSWOgcJQQ
   A==;
X-CSE-ConnectionGUID: WZycwU88R/q1GbRDyuL8Dw==
X-CSE-MsgGUID: LzAuAvQdQZCjhadOgGavGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="43528543"
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="43528543"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 10:04:08 -0800
X-CSE-ConnectionGUID: OWtiQNibR46e3oQ+kvB95A==
X-CSE-MsgGUID: GdN/y0T+TrqpvMi2L9/Cbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="95730016"
Received: from bjrankin-mobl3.amr.corp.intel.com (HELO [10.124.220.110]) ([10.124.220.110])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 10:04:08 -0800
Message-ID: <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
Date: Fri, 22 Nov 2024 10:04:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com, seanjc@google.com
Cc: isaku.yamahata@gmail.com, kai.huang@intel.com,
 linux-kernel@vger.kernel.org, tony.lindgren@linux.intel.com,
 xiaoyao.li@intel.com, yan.y.zhao@intel.com, x86@kernel.org,
 adrian.hunter@intel.com, Isaku Yamahata <isaku.yamahata@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Yuan Yao <yuan.yao@intel.com>
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
 <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20241115202028.1585487-2-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/24 12:20, Rick Edgecombe wrote:
> +struct tdx_td {
> +	hpa_t tdr;
> +	hpa_t *tdcs;
> +};

This is a step in the right direction because it gives the wrappers some
more type safety.

But an hpa_t is _barely_ better than a u64.  If the 'tdr' is a page,
then it needs to be _stored_ as a page:

	struct page *tdr_page;

Also, please don't forget to spell these things out:

	/* TD root structure: */
	struct page *tdr_page;

And the tdcs is an array of pages, right?  So it should be:

	struct page **tdcs_pages;

Or heck, I _think_ it can theoretically be defined as a variable-length
array:

	struct page *tdcs_pages[];

and use the helpers that we have for that.

Putting it all together, you would have this:

struct tdx_td {
	/* TD root structure: */
	struct page *tdr_page;

	int tdcs_nr_pages;
	/* TD control structure: */
	struct page *tdcs_pages[];
};

That's *MUCH* harder to misuse.  It's 100% obvious that you have a
single page, plus a variable-length array of pages.  This is all from
just looking at the structure definition.

You know that 'tdr' is not just some random physical address.  It's a
whole physical page.  It's page-aligned.  It was allocated, from the
allocator.  It doesn't point to special memory.

Ditto for "hpa_t *tdcs".  It's not obvious from the data structure that
it's an array or if it's an array how it got allocated or how large it is.

