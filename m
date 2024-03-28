Return-Path: <kvm+bounces-12925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7B588F476
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3533DB21A5B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050AA1D540;
	Thu, 28 Mar 2024 01:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cuFJ6C9o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8B3C0B;
	Thu, 28 Mar 2024 01:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711588913; cv=none; b=oKJBo2IBHSqSOdm1pdQDwVfPdudwNpuGCS7f/zRpwS0cSg7A3RC7zgnNgwj6Mnjb19X18BqaA2dYuVg60hjHLYQkR4/AqHZEWoDFNfp8hDw0vj6QKUXdyghwecY19vNXzCAJxMb55yTl44/Q++0Zzaft+dymdX/QJnJ/taIWtKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711588913; c=relaxed/simple;
	bh=P1ANYkv4/eSdWDeayIuhcvpAVvlwgWmzRcbjn9LrGUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dWQxZO3CZDl74V7ii9NkDPQeLM2mew2n4JeaChA1Z/Kd96JagQjTJVLYMTwXPE1nj8FA4kCAbclZorkJQOwo0COZPM6Pb5RZjBdCBAENw/aBb1PTC/+CAAN33g74jK8GUDMj0FaLdeJRwuBvRMldTTII+ltDGqyNSD8ExVQG7Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cuFJ6C9o; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711588911; x=1743124911;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P1ANYkv4/eSdWDeayIuhcvpAVvlwgWmzRcbjn9LrGUQ=;
  b=cuFJ6C9o+HETCa0y3ZZnQeYKuRbZrK9tlW2DpbKeiHirTBOOJpwb6bl0
   FPkLHhIhSCFC3wkcjiXHRnC953vmPuPDFuAAqAcpJLve6RD730i/O2Hi8
   GMdXFrIV754fVkdCeVZ3j480XIWOf9iOISezmQQWk2kfeN3NffHYaPxWv
   gDoVLo4IzN7lntdHOIGH7zFvzy7KwWafyO620GOoj6Lo9NUKgVSamyMQO
   CF2IbGn3u6Ec9CcGigQPSYHQJwg2/8mWWKaIa5oPl6HhE34iDgjlsXubE
   8cwr41MDeLuHbGRajxR+tDP0bdf5LdwGHw217oMLpZcVYKLWdlbFaLbec
   w==;
X-CSE-ConnectionGUID: xBQhAKsPQGm3McfGTNXosw==
X-CSE-MsgGUID: xbjBWN9MSfyRLUeJyCMKJw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6585521"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6585521"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:21:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16880943"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.242.198]) ([10.125.242.198])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:21:46 -0700
Message-ID: <54c4cf46-3c65-4ef7-86c3-09da39470017@linux.intel.com>
Date: Thu, 28 Mar 2024 09:21:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 01/11] x86: pmu: Remove duplicate code
 in pmu_init()
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
 <20240103031409.2504051-2-dapeng1.mi@linux.intel.com>
 <b961254e-f556-4186-91e2-76f312604e53@intel.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <b961254e-f556-4186-91e2-76f312604e53@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/28/2024 9:19 AM, Yang, Weijiang wrote:
> On 1/3/2024 11:13 AM, Dapeng Mi wrote:
>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>
>> There are totally same code in pmu_init() helper, remove the duplicate
>> code.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>
> Jim has already added RB tag for this patch in v2, you may add it here.

Oh, missed it. Thanks for reminding.

>
>> ---
>>   lib/x86/pmu.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
>> index 0f2afd650bc9..d06e94553024 100644
>> --- a/lib/x86/pmu.c
>> +++ b/lib/x86/pmu.c
>> @@ -16,11 +16,6 @@ void pmu_init(void)
>>               pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
>>           }
>>   -        if (pmu.version > 1) {
>> -            pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
>> -            pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
>> -        }
>> -
>>           pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
>>           pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
>>           pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
>

