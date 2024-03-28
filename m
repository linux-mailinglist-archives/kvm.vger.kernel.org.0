Return-Path: <kvm+bounces-12995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16DB888FCA1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C05E51F25B73
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062277BAF7;
	Thu, 28 Mar 2024 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7mAlx9I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B9A28DD2;
	Thu, 28 Mar 2024 10:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711620747; cv=none; b=hTaxagQV1SqeO+HKBFN6Zbp1q3LDf3OseA3sThiFFd58uKr/LAfoDeT1t5D+bFNJbVmiyuiixNeNzVOEDH0xlQQat3fpiloDlaSyOJH6Q4RecLuEYAopUoM76h0PKzhfSNxkZ5Gpwjg3eFNFDJKbyRzLzhbz4w5GbLAGsObMLRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711620747; c=relaxed/simple;
	bh=IBseJtEVdKixpDWmfRv1vc/DdeQwRLSFWGuoAtvnUDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YexmdMQQ1sCEPGlBglIHzCewK1wbC/VZ0M06eVMUPZPyJ48tRD7BA+Xue/TqCkPRp9UoqtH/FAfqgPix9opiz3aATHu8R3AniAIRp0O9HrnDWi3GX44NppT9L3Amf7AenwbTTbNIDOLx45EDv2ch32h+uF/m+ERrQJa0ftW1p34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7mAlx9I; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711620746; x=1743156746;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IBseJtEVdKixpDWmfRv1vc/DdeQwRLSFWGuoAtvnUDQ=;
  b=l7mAlx9I4CtpiIN2QBxbWcdUzr9rfX7b/o7KtsYwD37sUt9MUtakKM2Z
   gWhYOFabTRJzi7squ0KUvoIKo5t0lprB+T72AOxP3FOwiUOoxr2phNU2/
   6Ox2FHqKGuvxxiDtQhsbcM6+P1s25DRwnGp4sZDnIP5BL3/wjP/uWj3oC
   0nU1gCyEMlh9oF1FHXG4uCuhXseIRNjj1jSytFmbNkpQ4gAvbHjo5pwzb
   eWyGQUj9wKFeFcJITNCrt1ATaxxv/i4P9d+6iAJ3J+dlz/LTHNboKGp8S
   i4cWSfy7FNYrUS/Y8s0VjQYoKrgEQbqC7pCOmVoIN5Gc55hjLI2NE6ufC
   A==;
X-CSE-ConnectionGUID: /1qk2lJMTv2kKaoK8fvzTw==
X-CSE-MsgGUID: OhtSu4EhRvmXBXrNid1ZhQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="18199784"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="18199784"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 03:12:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="47586339"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 03:12:22 -0700
Message-ID: <97b5d746-2f65-4063-a33a-5556421fa481@linux.intel.com>
Date: Thu, 28 Mar 2024 18:12:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 06/11] x86: pmu: Remove blank line and
 redundant space
Content-Language: en-US
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Zhenyu Wang <zhenyuw@linux.intel.com>,
 "Zhang, Xiong Y" <xiong.y.zhang@intel.com>,
 Mingwei Zhang <mizhang@google.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, "Mi, Dapeng1" <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-7-dapeng1.mi@linux.intel.com>
 <359fe9cf-d12b-4f75-8cae-7ce830ec76d9@intel.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <359fe9cf-d12b-4f75-8cae-7ce830ec76d9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/28/2024 9:23 AM, Yang, Weijiang wrote:
> On 1/3/2024 11:14 AM, Dapeng Mi wrote:
>> code style changes.
>>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   x86/pmu.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index a2c64a1ce95b..46bed66c5c9f 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -207,8 +207,7 @@ static noinline void __measure(pmu_counter_t 
>> *evt, uint64_t count)
>>   static bool verify_event(uint64_t count, struct pmu_event *e)
>>   {
>>       // printf("%d <= %ld <= %d\n", e->min, count, e->max);
>> -    return count >= e->min  && count <= e->max;
>> -
>> +    return count >= e->min && count <= e->max;
>
> I don't think it's necessary to fix the nit in a separate patch, just 
> squash it in some patch with
> "Opportunistically ...."

Not sure this, I was always required to use a separate patch to refactor 
the code style faults by reviewers. It looks a unwritten rule for Linux.


>
>>   }
>>     static bool verify_counter(pmu_counter_t *cnt)
>

