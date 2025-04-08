Return-Path: <kvm+bounces-42880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA93A7F2BA
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 04:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C28F7A69E8
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 02:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A44E22B5B6;
	Tue,  8 Apr 2025 02:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l3mnttzD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64431DA23;
	Tue,  8 Apr 2025 02:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744079728; cv=none; b=btsHLX+Mg5jJqfW+M9BSoUiRsZDm+6xJrIgf3BT+zWt7p5+aTWVlzzhkIeYhIN8lsz8RppvbERZmHUAqiBcV6rWngQllIIrhAMqkgYCO4oDsoUk+wogtd4oteO8BDHSUEIOq9j4sGjycYwfBMR0zuxLojnBKb0iMLNEmy+6FE4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744079728; c=relaxed/simple;
	bh=u82h16VKOc/J1DXRbaqcMJDgeUklt2IOYgZZUyak8c8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ryswx+qB8Lh+lezulOAJJieEdQW9kgXEFdX1OG6swRnlodveFLVfM9eI4Rv3AFJlgKAuToqt81kLbtHtc24GpfEUMc1cQ5JsTj/geVxd3ndxebfLjbjeDzNtz1f3WG/7yf+M+kK1S9X+8gl9khyaF3CK8iXB2xlNvIUuu5kXiak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l3mnttzD; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744079727; x=1775615727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u82h16VKOc/J1DXRbaqcMJDgeUklt2IOYgZZUyak8c8=;
  b=l3mnttzDkhVuUmuQAjat213gHDU91UpoQ8b/gxz389SRDaJZSG8yZLtA
   SL3ZuBe1r7aB3q5v3CGCpBSWWBmnPB+d2ov0piymM3S0Y9EDiqCbWTsWH
   xjnpfTYvVLgh7EAgF0F2HcUEvWCKLVuEmFiQhgTolvGxQREjof4B1WR/Q
   OXquB08ZHN+hCtcPOYw7zU4V7D80B0+NcQKB5LYWIwEFRdsjSSvAJRitP
   gGYo4RDWkefWlBOntwTkGUo0jAyVy7ArZ+t4JuECCdG252YKel9ZAY71U
   XnWNQ4sq2VXxHrNa1LXHhXWnRiin34fbroXd/9olOJY/6qDf0y8ySIUwh
   w==;
X-CSE-ConnectionGUID: xohwPv59SFmebp1l1ykdrQ==
X-CSE-MsgGUID: 1NgL11pMQAGrnEwUzgvnOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="62895130"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="62895130"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 19:35:26 -0700
X-CSE-ConnectionGUID: TF58ctc0Tj+nT4Zhst7rcw==
X-CSE-MsgGUID: TWTWb4BUSIaSpYQPljN4+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="133101777"
Received: from yijiemei-mobl.ccr.corp.intel.com (HELO [10.238.2.108]) ([10.238.2.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 19:35:23 -0700
Message-ID: <ac936ff2-7a47-42b8-b144-cf54eb05274b@linux.intel.com>
Date: Tue, 8 Apr 2025 10:35:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
 <45674f2bb8c7bb09f0f3a29d7c4fb9bdc14b22d7.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <45674f2bb8c7bb09f0f3a29d7c4fb9bdc14b22d7.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/3/2025 6:00 AM, Huang, Kai wrote:
>>>> +via the same buffer. The 'ret' field represents the return value.
>>>>
>>> return value of the GetQuote TDVMCALL?
>> Yes, thereturn code of the GetQuote TDVMCALL.
>>>> The userspace
>>>> +should update the return value before resuming the vCPU according to TDX GHCI
>>>> +spec.
>>>>
>>> I don't quite follow.  Why userspace should "update" the return value?
>> Because only userspace knows whether the request has been queued successfully.
>>
>> According to GHCI, TDG.VP.VMCALL<GetQuote> API allows one TD to issue multiple
>> requests. This is implementation specific as to how many concurrent requests
>> are allowed.  The TD should be able to handle TDG.VP.VMCALL_RETRY if it chooses
>> to issue multiple requests simultaneously.
>> So the userspace may set the return code as TDG.VP.VMCALL_RETRY.
> OK.  How about just say:
>
> The 'ret' field represents the return value of the GetQuote request.  KVM only
> bridges the request to userspace VMM after sanity checks, and the userspace VMM
> is responsible for setting up the return value since only userspace knows
> whether the request has been queued successfully or not.
>
This looks good to me.
Regarding the sanity checks, I would appreciate inputs from others.



