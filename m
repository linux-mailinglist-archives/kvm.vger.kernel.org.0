Return-Path: <kvm+bounces-11513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A41877C32
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4B92B20A6A
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E97134C9;
	Mon, 11 Mar 2024 09:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8UrsZl3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320D712E4A
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710147794; cv=none; b=MnxYmMnrKVSOxZn18PkvmPyRPHxaau65o0K2XM6C3bEgXcwM1ZpeR3d8ohIQ5XPG0kqmx6NRLMgAuzrkZDE4jAKaN0E9vvjY6D44lLCrEyWOr6wTHijP1gf0lVgKTiWivLlJLBOIbGrJ5BeNlT73hGY4ae2Y9vllrh4lqcsfsBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710147794; c=relaxed/simple;
	bh=MvbBDzNtZdKOo0U/flo4h6NM7ejkTqnXNce/6zUN2ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jn+ea/W7ODHBMlWhCkgxvBH+cVeCQ4XXEf+Q1o6LXkVWkbOH8NXWY9pL3H0yBn+YrbhKQbXL8Lbd8vUz/Yy2zbzfEcNKI/DfpT4G9kFXeQ3ep8L7ToyoMxaiMmZ/5iewxf/f9cnqy3QgwhWYwZY/q2k+1QdoxLclIrnKf3SzF30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8UrsZl3; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710147792; x=1741683792;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MvbBDzNtZdKOo0U/flo4h6NM7ejkTqnXNce/6zUN2ag=;
  b=R8UrsZl36f0ZBHinHI6/OSiN9TaGYgC0HYSduYqj3CzqS3Z7XKMvXYoa
   BjCHVQ/rB0abHWL/gmhQxxvHZkYYRov6DKcb4GV+2JdJFLkoVcqPcVLFq
   iqTd9nbQCddFu7Tt5GTIlms9dAd9jcuboXWALubxGWrYB3VSQ5XwL85HW
   fz18KiiKZ2INVbYp2uikuPTi6SGhp4KXq1vATe+T9dxdxDapaNOkeDki7
   dMAQP1TN9hCZK5I6TMiXnLrL+Tzz1/AsWtw7VxpmbJhxfS5qdy2groP0+
   mBeMeQVV/VqcqrVEvEVqo5VomK7Mi2YCqnwIvRk5RnYlEnkmtSSZdHtgj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4721615"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="4721615"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 02:03:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="42087839"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 02:03:05 -0700
Message-ID: <164e9fe1-c89d-4354-a7f7-a565c624934e@intel.com>
Date: Mon, 11 Mar 2024 17:03:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/21] i386/cpu: Use APIC ID info to encode cache topo
 in CPUID[4]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Robert Hoo <robert.hu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-7-zhao1.liu@linux.intel.com>
 <c88ee253-f212-4aa7-9db9-e90a99a9a1e3@intel.com> <Ze23y7UzGxnsyo6O@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Ze23y7UzGxnsyo6O@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/2024 9:38 PM, Zhao Liu wrote:
> Hi Xiaoyao,
> 
>>>                case 3: /* L3 cache info */
>>> -                die_offset = apicid_die_offset(&topo_info);
>>>                    if (cpu->enable_l3_cache) {
>>> +                    addressable_threads_width = apicid_die_offset(&topo_info);
>>
>> Please get rid of the local variable @addressable_threads_width.
>>
>> It is truly confusing.
> 
> There're several reasons for this:
> 
> 1. This commit is trying to use APIC ID topology layout to decode 2
> cache topology fields in CPUID[4], CPUID.04H:EAX[bits 25:14] and
> CPUID.04H:EAX[bits 31:26]. When there's a addressable_cores_width to map
> to CPUID.04H:EAX[bits 31:26], it's more clear to also map
> CPUID.04H:EAX[bits 25:14] to another variable.

I don't dislike using a variable. I dislike the name of that variable 
since it's misleading

> 2. All these 2 variables are temporary in this commit, and they will be
> replaed by 2 helpers in follow-up cleanup of this series.

you mean patch 20?

I don't see how removing the local variable @addressable_threads_width 
conflicts with patch 20. As a con, it introduces code churn.

> 3. Similarly, to make it easier to clean up later with the helper and
> for more people to review, it's neater to explicitly indicate the
> CPUID.04H:EAX[bits 25:14] with a variable here.

If you do want keeping the variable. Please add a comment above it to 
explain the meaning.

> 4. I call this field as addressable_threads_width since it's "Maximum
> number of addressable IDs for logical processors sharing this cache".
> 
> Its own name is long, but given the length, only individual words could
> be selected as names.
> 
> TBH, "addressable" deserves more emphasis than "sharing". The former
> emphasizes the fact that the number of threads chosen here is based on
> the APIC ID layout and does not necessarily correspond to actual threads.
> 
> Therefore, this variable is needed here.
> 
> Thanks,
> Zhao
> 


