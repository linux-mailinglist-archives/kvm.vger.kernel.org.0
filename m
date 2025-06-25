Return-Path: <kvm+bounces-50750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8766DAE8F32
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7308D189EF64
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 20:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17C72DA761;
	Wed, 25 Jun 2025 20:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jNauB1Do"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A401FE47B;
	Wed, 25 Jun 2025 20:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750882148; cv=none; b=E9fJNEadGYoPCHrzXWOGLOLyEZYfccjlYcL6Q2TAk83Nu3G6UIIwlga6xoij4GssTfXCjHzEGD6WpHnqmy7GLDG5D8N2dBHA/avyt9jofr6pv99Anx+Tf9Y8JJ7WZTlVNFsBnRYxWlXIoZ8P4VPKBD14J6GGaDJQOvNJjH0W8+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750882148; c=relaxed/simple;
	bh=yCQMyv1rM/wdIbMx8xZFRx+DIuzMkvTWKdxqeBf4UyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFXkDiaG+vMoG4qEFJGjzH9Q9ebxluEk6C2tpD1NE58GmzSzjJLci0JWSnOHbjvLWOPi8B/k4eiaowBQNO/pcSGbuLTDJw0gzpymnVX7tW2Bt2VZPzxhf8fCKGrr3NwN/4tzSSz4LgKuP78hufj+en+tpkz3E10aq4PMO51c+kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jNauB1Do; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750882147; x=1782418147;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yCQMyv1rM/wdIbMx8xZFRx+DIuzMkvTWKdxqeBf4UyA=;
  b=jNauB1DoF4u0q0+il1+Rl3tkPBjDLbu2oYeGOokmh9pkLYu1P9oiBshv
   RHuk4GmXxN5dHj3jApGTGLxy/RPBEVGvhnvlUkDKDUl06BwLdQM5VZK6W
   EmskkJT/GI+hnd7yol0Ov+972oX1RwmshOTcYCPJa89h8D60pj/7Dum9M
   PfiFxtIkLACy++m89MWIbHvxYcVpdf4XoCKsAH22pRTILwB/F1duUpNzw
   pXPMgVmAiemwwjD3l3fj72l7yjITMeTH3kzGSCM9m8mqlqGhNvQX2tXqX
   kauUwWxEQWwfIsU2ve1NIbcpG+mykMmVL8nCcWRynRXJedpOm3sfltXJE
   A==;
X-CSE-ConnectionGUID: Y/UruGtXQnOQ4uJpDXrkEw==
X-CSE-MsgGUID: TvewSh9+RFGqxOSIu8zgJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="55792093"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="55792093"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 13:09:06 -0700
X-CSE-ConnectionGUID: +xAXj1vcQKS8Y549GIYwsQ==
X-CSE-MsgGUID: bxxKTzrhRNmC2Sa5iuQI7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="156703049"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.244]) ([10.125.108.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 13:09:05 -0700
Message-ID: <a49c523c-0c9e-47c6-ae2a-c84ff19f6717@intel.com>
Date: Wed, 25 Jun 2025 13:09:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Chao Gao <chao.gao@intel.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, dave.hansen@linux.intel.com,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com,
 yan.y.zhao@intel.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
 <aEeaJH1KqZ38tgKi@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aEeaJH1KqZ38tgKi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/9/25 19:36, Chao Gao wrote:
>> +static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
>> +{
>> +	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
>> +		struct page *page = alloc_page(GFP_KERNEL);
>> +		if (!page)
>> +			goto fail;
> 
> this goto isn't needed. it is used only once. so we can just free the pages and
> return -ENOMEM here.

<shrug>

There's no rule saying that gotos need to be used more than once. It's
idiomatic kernel C to use a goto as an error landing site. In fact, I
*prefer* this because it lets me read the main, non-error-case flow
through the function. Then, at my leisure, I can review the error handling.

This is also, IMNHO, less error-prone to someone adding code and doing a
plain return without freeing the pages.

Third, the goto keeps the indentation down.

So, the suggestion here is well intended, but I think it's flawed in
multiple ways. If you write your code this way (free of one-use gotos),
I won't complain too much. But if you suggest other folks get rid of the
gotos, I'm not super happy.

So, Kirill, do it whatever way you want.

But, Chao, please don't keep suggesting things like this at least in
junk I've got to merge.

>> +	if (tdx_hpa_range_not_free(err))
>> +		return 1;
> 
> I think this needs a comment for the return values 0/1/-EIO above the function.

You and I are in full agreement that this series is gloriously
unencumbered by comments at this point.

