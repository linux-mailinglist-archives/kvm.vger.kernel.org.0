Return-Path: <kvm+bounces-63192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F116C5C3BE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BAC114F1BED
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED0B303A03;
	Fri, 14 Nov 2025 09:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oDUFCbRq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673713019AB;
	Fri, 14 Nov 2025 09:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111654; cv=none; b=HypBJDdBV/Pg051M295XHQP85ERW5lPvwsCxyuDQ6XL75XjE3ma7OvLv686FvPE+5nVggp3ydnK92POPSjYUyk7Cz1z2DhboGhYvmoMQeE0eWvf0iK0ktZvmw6LejnX9G8K3MHeK9O6pFDmG6e9Ds3IktK0x6CezfZ8BAoaiaj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111654; c=relaxed/simple;
	bh=7cbUTy8lrEsWe5MpAWrFPwUzRXOUxrth7itvq6u3B08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X+a4Zfs0Tnmuw9hiYVH3+0dRQtMu5g2XN/F4zxBotMd++fcaUuEYiKo1HcGDJWTmlYQGkxPYXr4RMMiTuOFx/TvMWBN63JbE+oTlgfR4CU45ssXy1qm/bjAScy3zjmF+ZzXxnzM/3150HwDjS4cFTFc1fVAyjk11rp3IvqZzEM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oDUFCbRq; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763111652; x=1794647652;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7cbUTy8lrEsWe5MpAWrFPwUzRXOUxrth7itvq6u3B08=;
  b=oDUFCbRqumMZLYplYXdyAxWcdMKaiH6+v4HgOLhhKytaGO+dZvW5uM+i
   xMC3uYkv+2i0FCglpRhWB61OIwaO96DjnoJCcbCCQYYLTaqJJcchN+S0/
   3cawVuuLxKnkO5G+QAQbDR4Yq41MEyG44d/COg1A6z4JzH+DvYTObXhOK
   u8Cv3MTcy3S4lxtk71D5GKp4v1jWEiuxwA1wE20yEHMMm3YlQiTn7HyGO
   gluUW/jPrers3sOGNtnLE70wx6IAGOaaQ29gfi7nwMeN/0FSr3MYERNSG
   S8VB6tEhCbkX6RPTDGoQjc4Gb4yQgJUp+bAQFBh1Tbbx0drRgzcCFpAfH
   g==;
X-CSE-ConnectionGUID: es7X5tZ1QoqcplhLmaLK4g==
X-CSE-MsgGUID: YSBsW/WgQlijowzABLhTRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76664657"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="76664657"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:14:12 -0800
X-CSE-ConnectionGUID: w78KuXluTuOddILF5kGKkg==
X-CSE-MsgGUID: PYVACaR/QJG6hYnJ1ajaIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="220387082"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.55]) ([10.124.241.55])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:14:06 -0800
Message-ID: <9bcd2857-e688-49e7-b3c9-7fa4bbf0b3e7@linux.intel.com>
Date: Fri, 14 Nov 2025 17:14:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
To: Yan Zhao <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>,
 "Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
 <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
 "michael.roth@amd.com" <michael.roth@amd.com>,
 "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Peng, Chao P" <chao.p.peng@intel.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "kas@kernel.org" <kas@kernel.org>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Miao, Jun" <jun.miao@intel.com>,
 "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094149.4467-1-yan.y.zhao@intel.com>
 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
 <fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com>
 <aRRAFhw11Dwcw7RG@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aRRAFhw11Dwcw7RG@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/12/2025 4:06 PM, Yan Zhao wrote:
> On Tue, Nov 11, 2025 at 05:15:22PM +0800, Huang, Kai wrote:
>> On Mon, 2025-09-01 at 17:08 +0800, Yan Zhao wrote:
>>>>> Do not handle TDX_INTERRUPTED_RESTARTABLE because SEAMCALL
>>>>> TDH_MEM_PAGE_DEMOTE does not check interrupts (including NMIs) for basic
>>>>> TDX (with or without Dynamic PAMT).
>>>> The cover letter mentions that there is a new TDX module in planning, which
>>>> disables the interrupt checking. I guess TDX module would need to have a
>>>> interface to report the change, KVM then decides to enable huge page support or
>>>> not for TDs?
>>> Yes. But I guess detecting TDX module version or if it supports certain feature
>>> is a generic problem. e.g., certain versions of TDX module have bugs in
>>> zero-step mitigation and may block vCPU entering.
>>>
>>> So, maybe it deserves a separate series?
>> Looking at the spec (TDX module ABI spec 348551-007US), is it enumerated via
>> TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY?
> Yes. I checked the unreleased TDX module code that enumerates this bit (starting
> from version TDX_1.5.28.00.972). TDH.MEM.PAGE.DEMOTE will not return
> TDX_INTERRUPTED_RESTARTABLE for L1 VMs.

According to the content pasted by Kai below, it just says there will be no
TDX_INTERRUPTED_RESTARTABLE for TDH.MEM.PAGE.DEMOTE if no L2 VMs.

KVM doesn't support TD partition yet, just for clarification,  what if the
demotion is for L1 VM, but there are L2 VMs configured?


>
>>    5.4.25.3.9.
>>
>>    Interruptibility
>>
>>    If the TD is not partitioned (i.e., it has been configured with no L2
>>    VMs), and the TDX Module enumerates
>>    TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY as 1, TDH.MEM.PAGE.DEMOTE
>>    is not interruptible.
>>
>> So if the decision is to not use 2M page when TDH_MEM_PAGE_DEMOTE can return
>> TDX_INTERRUPTED_RESTARTABLE, maybe we can just check this enumeration in
>> fault handler and always make mapping level as 4K?
> Thanks for this info! I think this is a very good idea and the right direction.
> If no objection, I'll update the code in this way.
>
>
>


