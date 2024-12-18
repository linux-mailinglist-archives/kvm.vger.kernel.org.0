Return-Path: <kvm+bounces-34030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A629F5E32
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 06:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31ACF7A25EC
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 05:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D02153808;
	Wed, 18 Dec 2024 05:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c2kGuL+h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCF96026A;
	Wed, 18 Dec 2024 05:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734498564; cv=none; b=MrgLYbyLbMz9I8ygcOngg5Q1268aBNjh6yxtqHef9cS3AD3dFFbglCYFwctzUUuj+zDvNM23SRQkjudnWVS9WREdJP7aMEGfd05DL64knFVYyI+ukB6A3uS0YFGQ1LDClaL+0b9/dOwWB7qrh8h33mWSd0VzM1dwaXP1IH43P3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734498564; c=relaxed/simple;
	bh=LF1BvL5APEXR/Vq1F+OYGrBroEZEjlB5dri92/wjmXs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hJwEdHaGwzo44NLqNibrAS/QCCaYhBargimyjjc1oFIcgj4C1n7r5hB85vO/qNg8WjWFXW3DFH+XiVIuOIiPLrEGlsjLLoZDW2wu3zpMLzeKwb23/02SbJ7DVvyMVUNAm6XVtX1BRWjy5/U1q7V3MrQQeNluIiqB8UzSrg8lvw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c2kGuL+h; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734498562; x=1766034562;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=LF1BvL5APEXR/Vq1F+OYGrBroEZEjlB5dri92/wjmXs=;
  b=c2kGuL+hLqe0BYH9PyFKJi3T2d7IndZ4JyjYbO5V5tBJDJH/8rw7udNZ
   Ds0MScJIi8fr2QLChwij6FVXTKt7RyIXzuzKaZ9N26gToyOYr71aue0ot
   9jAECvy1szMr0wx5xEyaQZtv4iYW9WcEXxiMXv8OaZHzOrrIjvsV/JHf3
   cuan1UZskjeMUXnED/GAJybhAKOYO0Md4gPVNbQsPnTEvL5d3SimxVBds
   TAU0E5yW2GWs3Z4x9QEDOfSHOYZt8kg36owDhZloH2rGxM3uEg2pevn6m
   Y29ccPUgP0VZXbRjPPfZEt2VxpgBf5fMavuu/35Z6u3wLdFStQlF9+21i
   g==;
X-CSE-ConnectionGUID: P3+D2p5+SHqv61opUryATw==
X-CSE-MsgGUID: uJRfg40JTvW2pyYz8BMn9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11289"; a="38895108"
X-IronPort-AV: E=Sophos;i="6.12,243,1728975600"; 
   d="scan'208";a="38895108"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 21:09:22 -0800
X-CSE-ConnectionGUID: lPLDNuxNShCy5bOD1i/Fsg==
X-CSE-MsgGUID: 5jZhzAMpRniMmDP6plIb6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101885146"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 21:09:19 -0800
Message-ID: <377a2e4f-91bf-4156-86e4-feaddf90113e@linux.intel.com>
Date: Wed, 18 Dec 2024 13:09:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <d3adecc6-b2b9-42ba-8c0f-bd66407e61f0@intel.com>
 <692aacc1-809f-449d-8f67-8e8e7ede8c8d@linux.intel.com>
 <edc7f1f3-e498-44cc-aa3c-994d3f290e01@intel.com>
 <fc0306fe-8a78-4024-9b67-0f8cb9f7450a@linux.intel.com>
Content-Language: en-US
In-Reply-To: <fc0306fe-8a78-4024-9b67-0f8cb9f7450a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 12/18/2024 9:38 AM, Binbin Wu wrote:
>
>
>
> On 12/16/2024 2:03 PM, Xiaoyao Li wrote:
>> On 12/16/2024 9:08 AM, Binbin Wu wrote:
>>>
>>>
>>>
>>> On 12/13/2024 5:32 PM, Xiaoyao Li wrote:
>>>> On 12/1/2024 11:53 AM, Binbin Wu wrote:
>>>>
>>> [...]
>>>>> +
>>>>> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +    struct vcpu_tdx * tdx = to_tdx(vcpu);
>>>>> +    u64 gpa = tdvmcall_a0_read(vcpu);
>>>>
>>>> We can use kvm_r12_read() directly, which is more intuitive. And we can drop the MACRO for a0/a1/a2/a3 accessors in patch 022.
>>> I am neutral about it.
>>>
>>
>> a0, a1, a2, a3, are the name convention for KVM's hypercall. It makes sense when serving as the parameters to __kvm_emulate_hypercall().
>>
>> However, now __kvm_emulate_hypercall() is made to a MACRO and we don't need the temp variable like a0 = kvm_xx_read().
>>
>> For TDVMCALL leafs other than normal KVM hypercalls, they are all TDX specific and defined in TDX GHCI spec, a0/a1/a2/a3 makes no sense for them.
> OK, make sense.
>
> Thanks!
>
>
I will leave it as it is for now.

There is an RFC proposal from Hunter about using descriptively named parameters
https://lore.kernel.org/all/fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com/

It can wait until there is a final conclusion.

