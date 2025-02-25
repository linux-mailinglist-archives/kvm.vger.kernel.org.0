Return-Path: <kvm+bounces-39098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC67A43899
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 10:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECB521612CF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 09:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F171260A35;
	Tue, 25 Feb 2025 08:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T2WH+og7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EDE17F7
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 08:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473961; cv=none; b=J9uHMXBU3blnyTAnMVZervUeXz/h7dgD2mwMqI84YYy3pAuxfxNdTchMzDoUU0GFzxO+JYT0i2jjKZHh+exKi9LISr/aNQapPDR7ZAhY7JQkyWen8401t8PbpkKrG/R4P9LYLnqaxZz//U93W68Ib3VSmvM+x7ywyieNEZgFezU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473961; c=relaxed/simple;
	bh=3hFp0w9TkaXMLYZrzh0OCU8rpuvN6ak09O3UKp4MH3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QtB4EnW9c/5542xT4sOWc/+2HT2S74y7g+iDA3sLlfnGzaFVs+cWCgZS6gFYz86i1kWaX+P4vkc2ZuIT6STzzUFoAOT/PTdM+zYf6RzuJkoCE0Wr23s2qyX+gijtXZfUyu0byNpOdVu5ksT1o7LfvTT2R/QSQxcg6rzPVbRiPSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T2WH+og7; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740473957; x=1772009957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3hFp0w9TkaXMLYZrzh0OCU8rpuvN6ak09O3UKp4MH3E=;
  b=T2WH+og7PXt/V34kXoXonsTeitm4roenukKECGhTiA2Rvc/DaOyBj0S5
   Rfc0BoZEEAFM7CyJTY63gVFlnLkBvrnZHhKsK8ciuLaFWVwhACFFOZ71h
   KtXIwfcCwmCSk4hnJ5tNyp8xd9+crs0LUwvFJIVxx8Lpz56f0CKXfnz3j
   D48nF++k4QbB6qXetdFhN3YF3TaOxC2jOZrHsK3K33acmXSetHJbqfx1F
   VWuLLVgSPMUgjOry1mtRDxAnmRz8ZCV2oUaH8rauK+AoYWbKdmCEAoSip
   BQCAcZLN2cBTyzbDESTNDnKOAvc3ZhetOpby7RkFNSDLlWY3xIA9F3qyx
   A==;
X-CSE-ConnectionGUID: ZYErOrfpS8mwNI9n40cUaA==
X-CSE-MsgGUID: dLYRHHQhQ2mXPVLjE/Q9Jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="41524933"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="41524933"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 00:59:16 -0800
X-CSE-ConnectionGUID: e/mlfnbsQxaOc6uYbdXHhQ==
X-CSE-MsgGUID: vrgv+H7RS5GI+jCCUnlI3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116181922"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 00:59:12 -0800
Message-ID: <f4549022-8304-4838-9482-aa19769f8c19@intel.com>
Date: Tue, 25 Feb 2025 16:59:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/52] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: armbru@redhat.com, berrange@redhat.com, chenhuacai@kernel.org,
 eblake@redhat.com, imammedo@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
 mtosatti@redhat.com, pbonzini@redhat.com, peter.maydell@linaro.org,
 philmd@linaro.org, qemu-devel@nongnu.org, rick.p.edgecombe@intel.com,
 zhao1.liu@intel.com
References: <08bf7f3061459af5f05fabf0d3796b77d8034587.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <08bf7f3061459af5f05fabf0d3796b77d8034587.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/2025 3:21 AM, Francesco Lavra wrote:
> On Fri, 24 Jan 2025 08:20:01 -0500, Xiaoyao Li wrote:
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index 4ff94860815d..bd212abab865 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -10,17 +10,122 @@
>>    */
>>   
>>   #include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "qapi/error.h"
>>   #include "qom/object_interfaces.h"
>>   
>>   #include "hw/i386/x86.h"
>>   #include "kvm_i386.h"
>>   #include "tdx.h"
>>   
>> +static struct kvm_tdx_capabilities *tdx_caps;
> 
> Instead of a static variable, this should be a member of the TdxGuest
> struct.

I don't think so.

tdx_caps is reported from KVM, which indicates what XFAM/Attributes and 
configurable CPUID bits that can be configured for a TD under the KVM.

It's not the specific properties of the TD.

So I would keep it as it.

