Return-Path: <kvm+bounces-12928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 467F788F4A1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:30:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 784D21C2D726
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2FF210EC;
	Thu, 28 Mar 2024 01:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qcz63bWB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90D0200D5;
	Thu, 28 Mar 2024 01:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711589420; cv=none; b=pSTL5P1zNyLZqnBZ6Mlpy6NWfEVTyV4ZEBYtGY2v3k/X4r2GfxtGhSbs7GBw/Jo9y2PmlIUPGDBI9q8IwA/qP06l9bqzeGBFVOe4k8AZ+Q2r0Jjk/skLYWYzrgFYmBvtS5PurQvj+n3idicSH+psa6Xwogn2u7ZvArIFO6sYYxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711589420; c=relaxed/simple;
	bh=5aCurHOHta8QRuhaeNAeu28tMitK//VvdG5YQ9yPLRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CcQe9YMDwxBhTD5ZmhAbcCOTUR73idTvt/m37UFBlhvbFt9u9aK0BKqcTtxC7KRHkBtAU81E7SCMHMEqf7+JyuH5p5X1LkEH/Dtq8GY2hUmYEUKy/FW4dcYXsT9LmpUi5f09khHV/ivND4jv9H7ymWhTbyM9R8uoalfyz5atwAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qcz63bWB; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711589419; x=1743125419;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5aCurHOHta8QRuhaeNAeu28tMitK//VvdG5YQ9yPLRU=;
  b=Qcz63bWBPtmy7lOkscUGrcUQECXgbPvX+Yz31sppPlo4YO8BDsqW0GJT
   nt+iI3bBhVDhfljeYRql7Ql5CFLnRQm5gI+kVv8OPvHYMFuNbvwW3sxSB
   bryATcOyfMuvfKmPouCAHm9ZuKWfglTCYm9W2f2lWK7cdy0HRqrrBu2bN
   H98JYGr/fLhz5oqXqJzlse2jBILHBiNdutO3WR1gS6dgbSmjH98sw8Gft
   zB5Ba5m6AgZCQfgVk8Db01TBqPo6FzIVjCdOqXJI+25BXd7TcA+cjX7rM
   uzmour0+YU/7o9B30RFfozS3m2PTrkakK5aqoo4Hd4ikDLWs4Yoq/hldV
   A==;
X-CSE-ConnectionGUID: dj0kqkB6S5Wm/jj9/XyOaw==
X-CSE-MsgGUID: AuSX9eYQTLKZ/X2D64uq/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10505872"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="10505872"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:30:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21145884"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:30:15 -0700
Message-ID: <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
Date: Thu, 28 Mar 2024 09:30:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
 <hang.yuan@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/2024 9:06 AM, Edgecombe, Rick P wrote:
> On Thu, 2024-03-28 at 08:58 +0800, Xiaoyao Li wrote:
>>> How so? Userspace needs to learn to create a TD first.
>>
>> The current ABI of KVM_EXIT_X86_RDMSR/WRMSR is that userspace itself
>> sets up MSR fitler at first, then it will get such EXIT_REASON when
>> guest accesses the MSRs being filtered.
>>
>> If you want to use this EXIT reason, then you need to enforce userspace
>> setting up the MSR filter. How to enforce?
> 
> I think Isaku's proposal was to let userspace configure it.
> 
> For the sake of conversation, what if we don't enforce it? The downside of not enforcing it is that
> we then need to worry about code paths in KVM the MTRRs would call. But what goes wrong
> functionally? If userspace doesn't fully setup a TD things can go wrong for the TD.
> 
> A plus side of using the MSR filter stuff is it reuses existing functionality.
> 
>>   If not enforce, but exit with
>> KVM_EXIT_X86_RDMSR/WRMSR no matter usersapce sets up MSR filter or not.
>> Then you are trying to introduce divergent behavior in KVM.
> 
> The current ABI of KVM_EXIT_X86_RDMSR when TDs are created is nothing. So I don't see how this is
> any kind of ABI break. If you agree we shouldn't try to support MTRRs, do you have a different exit
> reason or behavior in mind?

Just return error on TDVMCALL of RDMSR/WRMSR on TD's access of MTRR MSRs.

