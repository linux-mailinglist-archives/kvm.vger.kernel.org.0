Return-Path: <kvm+bounces-59024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5EDBAA412
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FA6B7A1A50
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8FF228CBC;
	Mon, 29 Sep 2025 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kdu4Kyjl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F405D515;
	Mon, 29 Sep 2025 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759169301; cv=none; b=cp0dD1CS8h5cfsSbANBkgUTfw+bF6q7XT7sXAOT2HfY1oZrcYI5IuMjMIgrntVzjMbuO0ozW/kqEBbqyqeINIMdfl0fmMgvb1mY1aEAhLfuP6zB9U9sOOe5GMcldDJoSfN/InGDbXnEubqhXoyj/kSsObo671u2hMJMdixaVdHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759169301; c=relaxed/simple;
	bh=q7CThi1aWbsxB7vnD8/Oe4G64PlXMpl8kXaSOAxluZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tS62lJl7WGGtyNSElc8hCkmo1aTfJQBVY4nW6uoXlToFfBx0lyLfM+x/8kBzIWzzhc4WKiIxbhMUZSnyO/BTKeO2+vV7xr3lByJawSrRwMfdVROEkex+i9Enx/W6X5N8LwalFp+AqMOUElvaE70jTrO0XPVYdCKmSlCRusNQAbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kdu4Kyjl; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759169299; x=1790705299;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q7CThi1aWbsxB7vnD8/Oe4G64PlXMpl8kXaSOAxluZ0=;
  b=kdu4Kyjl8ngCwMcF1v0mjzGvDrxT4U51UWXemVX86aqa6V455XnKfpdO
   ZVhj0VCsjVBsIilpJkuaNhPCHy7Klqtj2QJuLkD0ZPJSmAYk1oe5pIh+V
   +n70SCIAoWm7ZzDxlLg7NaVqaTVWEOSarSDsNuzx8DGX23EHBHATaxFau
   xSXgydPNHrVfvm4dOld0NTfp/j342n4W27btWXzputDKfXo8ABby5yDxG
   pyuS8Sm8xtrTdH9HeabpHI3lLQidFRooNgn+Ftka348MntVidU+IVTGfJ
   eNPkpxN+nIkbH8KSKyWeO+I9EKyhcgnqmz3u8YPP//qYomOVjipiwsVFy
   w==;
X-CSE-ConnectionGUID: V+/CvjRgR8Oww7o/t4COLw==
X-CSE-MsgGUID: jGJEWlhzT9KwLoDsZgZ7OQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="72096550"
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="72096550"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 11:08:19 -0700
X-CSE-ConnectionGUID: 4MbS3nkYQqOUZPVk6dk2QA==
X-CSE-MsgGUID: Giq89lMvQY2z3OPwW3TbIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="178727131"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.105]) ([10.125.109.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 11:08:18 -0700
Message-ID: <c0590dca-13a6-4173-9b82-3604d26ce0c7@intel.com>
Date: Mon, 29 Sep 2025 11:08:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] x86/virt/tdx: Allocate reference counters for
 PAMT memory
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-6-rick.p.edgecombe@intel.com>
 <47f8b553-1cb0-4fb0-993b-affd4468475e@linux.intel.com>
 <c8b69a9c5709d8bc482ce724f23da01e8d151727.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c8b69a9c5709d8bc482ce724f23da01e8d151727.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/29/25 10:41, Edgecombe, Rick P wrote:
> On Tue, 2025-09-23 at 15:45 +0800, Binbin Wu wrote:
>>> +/*
>>> + * Allocate PAMT reference counters for all physical memory.
>>> + *
>>> + * It consumes 2MiB for every 1TiB of physical memory.
>>> + */
>>> +static int init_pamt_metadata(void)
>>> +{
>>> +	size_t size = max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
>> Is there guarantee that max_pfn is PTRS_PER_PTE aligned?
>> If not, it should be rounded up.
> Vmalloc() should handle it?

vmalloc() will, for instance, round up to 2 pages if you ask for 4097
bytes in 'size'. But that's not the problem. The 'size' calculation
itself is the problem.

You need exactly 2 MiB for every 1 TiB of memory, so let's say we have:

	max_pfn = 1<<28

(where 28 == 40-PAGE_SIZE) then size would be *exactly* 1<<21 (2 MiB).
Right?

But what if:

	max_pfn = (1<<28) + 1

Then size needs to be one more page. Right? But what would the code do?

