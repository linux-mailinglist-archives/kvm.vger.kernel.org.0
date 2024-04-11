Return-Path: <kvm+bounces-14266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E414B8A186D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 139BC1C2360B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4D417592;
	Thu, 11 Apr 2024 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b0uoEBIw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A18C14F61;
	Thu, 11 Apr 2024 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712848588; cv=none; b=g/oGY3gdyxZSQKTM5rAgDGq5W8U75vqNcryxxuKna10ZHSzS+eD0FG0v2Xk2/adG50N2zSpbkm6vs9j5EROAGCbvPaUvHGZOM1e59KqqSIXRdtHw1tHNeuIXMZA+6JngMgfZ9l2rLyQpwIog4ccQqA2xNDJ/bU3+0pU2pU+xBhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712848588; c=relaxed/simple;
	bh=lVC9B1IxKNezJlsW9o1nTkrk+HcRCjDg79ZgiyQJjWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BnwXBPdYS0Tp0c4pbbAJDPq9whEua5HwAUSrfP4KkYQqvExv/dAZ1vgOY5nazVpkW7Zjtwc8rkMwgAn3YoimG7ITBWXeX0UHEtHwk7f5R5PLcdKqf8h1g1Q1yMXlo84DMhJrReClUJDm9e0qNJnuRIYEGRLtWbVnNvoaFbWNMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b0uoEBIw; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712848586; x=1744384586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lVC9B1IxKNezJlsW9o1nTkrk+HcRCjDg79ZgiyQJjWM=;
  b=b0uoEBIwDxosro6wO1mJMXDsrzPYp/YClmmXKUJj6+Utuc7zhoz7rsNE
   BtV1cWDmWYzyt8srbn4f+SMSD2QKSnAmmqgMFp1L6n8SAYmEJRD4/GgsI
   +gShWzNiw160O5XpUK2gH6Rm7gwayy43mN5GmMbHlkNFWnXCu2RZLuTzv
   NpuvASUYN0OBh7d+yKwr4I767pvGhqPCd9yQ1B2uJKgdZ64o6G7BfThI1
   52Kl8W0h7SeAOnnwGYr8MrjtE02P59slJGGq7hUkxUGbvAom+yMTIrIlK
   2TNIAU+3vowTyAdbzwTsA1dAnuWXg6zESbDEmpiJqyMaxXKGUbrJW+cG9
   w==;
X-CSE-ConnectionGUID: ALYiUuGoTjqWAfYmmhaxPA==
X-CSE-MsgGUID: H3mMwBL/TKaQt+n6Y+YFww==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8123111"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8123111"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:16:25 -0700
X-CSE-ConnectionGUID: V5RbhwPNR2SR5w/fw0G6Xg==
X-CSE-MsgGUID: pgvLL74GRxOGz//JyPY66A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="21522233"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 08:16:22 -0700
Message-ID: <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
Date: Thu, 11 Apr 2024 23:16:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
To: Sean Christopherson <seanjc@google.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "srutherford@google.com" <srutherford@google.com>,
 "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Wei W Wang <wei.w.wang@intel.com>
References: <ZhQ8UCf40UeGyfE_@google.com>
 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
 <ZhRxWxRLbnrqwQYw@google.com>
 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
 <ZhSb28hHoyJ55-ga@google.com>
 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
 <ZhVdh4afvTPq5ssx@google.com>
 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
 <ZhVsHVqaff7AKagu@google.com>
 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
 <ZhfyNLKsTBUOI7Vp@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZhfyNLKsTBUOI7Vp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/11/2024 10:22 PM, Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Rick P Edgecombe wrote:
>> On Tue, 2024-04-09 at 09:26 -0700, Sean Christopherson wrote:
>>>> Haha, if this is the confusion, I see why you reacted that way to "JSON".
>>>> That would be quite the curious choice for a TDX module API.
>>>>
>>>> So it is easy to convert it to a C struct and embed it in KVM. It's just not
>>>> that useful because it will not necessarily be valid for future TDX modules.
>>>
>>> No, I don't want to embed anything in KVM, that's the exact same as hardcoding
>>> crud into KVM, which is what I want to avoid.  I want to be able to roll out a
>>> new TDX module with any kernel changes, and I want userspace to be able to
>>> assert
>>> that, for a given TDX module, the effective guest CPUID configuration aligns
>>> with
>>> userspace's desired the vCPU model, i.e. that the value of fixed bits match up
>>> with the guest CPUID that userspace wants to define.
>>>
>>> Maybe that just means converting the JSON file into some binary format that
>>> the
>>> kernel can already parse.  But I want Intel to commit to providing that
>>> metadata
>>> along with every TDX module.
>>
>> Oof. It turns out in one of the JSON files there is a description of a different
>> interface (TDX module runtime interface) that provides a way to read CPUID data
>> that is configured in a TD, including fixed bits. It works like:
>> 1. VMM queries which CPUID bits are directly configurable.
>> 2. VMM provides directly configurable CPUID bits, along with XFAM and
>> ATTRIBUTES, via TDH.MNG.INIT. (KVM_TDX_INIT_VM)
>> 3. Then VMM can use this other interface via TDH.MNG.RD, to query the resulting
>> values of specific CPUID leafs.
>>
>> This does not provide a way to query the fixed bits specifically, it tells you
>> what ended up getting configuring in a specific TD, which includes the fixed
>> bits and anything else. So we need to do KVM_TDX_INIT_VM before KVM_SET_CPUID in
>> order to have something to check against. But there was discussion of
>> KVM_SET_CPUID on CPU0 having the CPUID state to pass to KVM_TDX_INIT_VM. So that
>> would need to be sorted.
>>
>> If we pass the directly configurable values with KVM_TDX_INIT_VM, like we do
>> today, then the data provided by this interface should allow us to check
>> consistency between KVM_SET_CPUID and the actual configured TD CPUID behavior.
> 
> I think it would be a good (optional?) sanity check, e.g. KVM_BUG_ON() if the
> post-KVM_TDX_INIT_VM CPUID set doesn't match KVM's internal data.  But that alone
> provides a terrible experience for userspace.
> 
>   - The VMM would still need to hardcode knowledge of fixed bits, without a way
>     to do a sanity check of its own.

Maybe we can do it this way to avoid hardcode:

1. KVM can get the configurable CPUID bits from TDX module with 
TDH.SYS.RD (they are the old info of TD_SYSINFO.CPUID_CONFIG[]), and 
report them to userspace;

2. userspace configures the configurable CPUID bits and pass them to KVM 
to init TD.

3. After TD is initialized via TDH.MNG.INIT, KVM can get a full CPUID 
list of TD via TDH.MNG.RD. KVM provides interface to report the full 
CPUID list to userspace.

4. Userspace can sanity check the full CPUID list.
    - the configurable bits reported in #1 should be what they have been 
configured;
    - the dynamic bits and other special bits will be checked case by case;
    - the rest bits should be fixed. If the value is not what user 
wants, userspace prints error to user and stop.

Does it sounds reasonable?

>   - Lack of a sanity check means the VMM can't fail VM creation early.
> 
>   - KVM_SET_CPUID2 doesn't have a way to inform userspace _which_ CPUID bits are
>     "bad".
> 
>   - Neither userspace nor KVM can programming detect when bits are fixed vs.
>     flexible.  E.g. it's not impossible that userspace would want to do X if a
>     feature is fixed, but Y if it's flexible.

flexible (configurable) bits is known to VMM (KVM and userspace) because 
TDX module has interface to report them. So we can treat a bit as fixed 
if it is not reported in the flexible group. (of course the dynamic bits 
are special and excluded.)

