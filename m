Return-Path: <kvm+bounces-43405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A46CA8B33F
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99BB51905DEB
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 08:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1CA22FF2D;
	Wed, 16 Apr 2025 08:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOi4r1D9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D00012CD96
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 08:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744791460; cv=none; b=I8adnVKoWxu9DFCd2Q71gdP8w+nUMtY1t6tsfJ4CtN5K6t2J9yP8zqm4P70jU12EzYuSjySDjthFgFizTkAahkeigvFytIJ69a5MjQJW05jaf2+mNMUxZxVyXLRwIvYbrld2JnmC+eV+NZyY77St6Ojlpw0PsoIanqubPIDU2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744791460; c=relaxed/simple;
	bh=L8NvFQCdlJUp/6uJoWj6yMFzx+igvTzyuYbhBvkmkrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXysN4y58CNu/SVGDo9KErhmXFFLC58VNHPR5/OeiX//CuEAn+J+nNTXbLL4I3ewXaoh1QA8zGqyZEHWC0/r1mZhpgkIFjkl7xTxIdnAHUOq0y7U4uVmsHRvMd0O9mt62aSBk6LMjZD3C5QpPGwpgPkcYvxfnMv6PIgc7rgBF9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HOi4r1D9; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744791458; x=1776327458;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L8NvFQCdlJUp/6uJoWj6yMFzx+igvTzyuYbhBvkmkrQ=;
  b=HOi4r1D9W4LPtomYIyJRyyre/ZeJOLWdplDEjdiBdg1kSHnUy2rmp0To
   3Zfyw+kTvtmLnr7VrjJMFB3GJ2V1Zkpxb3mjHOgX32s3Xi9pzmSfgODTQ
   N7g+eBRWjFBQ+4uuUvdkoQABjrLy56WdDvBoLBzFrH3ekHmojidlzdPh4
   LDjZ3kpOpcBbhmQP5dsEGYz1IBsoKfXm3k6Xw0xgBXSiXErt/wtIlZGfd
   pA6JgGOCGfyeANQWgjqP614G4YN9s5iiB5sGdwFRS2xnb+mTMxk+l9L+N
   U6f5xgeF4NhOGg3bVoXp0Q1SD+jUdRxWK8q3EC7ouFPU6GoN1B1I6h7Ku
   A==;
X-CSE-ConnectionGUID: z1bp/DITQzCzIpNJAVKkDQ==
X-CSE-MsgGUID: yc44QXRSRNitYWG5QOq4NA==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="46416913"
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="46416913"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 01:17:37 -0700
X-CSE-ConnectionGUID: sqQIBIPXSgCFn0oht0TD8A==
X-CSE-MsgGUID: Y+Vs40CMRmWbXe4IspPIGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="130897585"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2025 01:17:31 -0700
Message-ID: <42f59e7f-8353-461b-9c7a-d333083ba791@linux.intel.com>
Date: Wed, 16 Apr 2025 16:17:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Ewan Hai <ewanhai-oc@zhaoxin.com>, Zhao Liu <zhao1.liu@intel.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, pbonzini@redhat.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
 khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai@zhaoxin.com, cobechen@zhaoxin.com, louisqi@zhaoxin.com,
 liamni@zhaoxin.com, frankzhu@zhaoxin.com, silviazhao@zhaoxin.com,
 yeeli@zhaoxin.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
 <84653627-3a20-44fd-8955-a19264bd2348@oracle.com>
 <e3a64575-ab1f-4b6f-a91d-37a862715742@zhaoxin.com>
 <a94487ab-b06d-4df4-92d8-feceeeaf5ec3@oracle.com>
 <65a6e617-8dd8-46ee-b867-931148985e79@zhaoxin.com>
 <Z/OSEw+yJkN89aDG@intel.com>
 <94e8451f-1b44-4e22-8e3f-378c8490cf00@zhaoxin.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <94e8451f-1b44-4e22-8e3f-378c8490cf00@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/7/2025 5:33 PM, Ewan Hai wrote:
>
> On 4/7/25 4:51 PM, Zhao Liu wrote:
>
>> On Tue, Apr 01, 2025 at 11:35:49AM +0800, Ewan Hai wrote:
>>> Date: Tue, 1 Apr 2025 11:35:49 +0800
>>> From: Ewan Hai <ewanhai-oc@zhaoxin.com>
>>> Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers
>>>   during VM reset
>>>
>>>>> [2] As mentioned in [1], QEMU always sets the vCPU's vendor to match the host's
>>>>> vendor
>>>>> when acceleration (KVM or HVF) is enabled. Therefore, if users want to emulate a
>>>>> Zhaoxin CPU on an Intel host, the vendor must be set manually.Furthermore,
>>>>> should we display a warning to users who enable both vPMU and KVM acceleration
>>>>> but do not manually set the guest vendor when it differs from the host vendor?
>>>> Maybe not? Sometimes I emulate AMD on Intel host, while vendor is still the
>>>> default :)
>>> Okay, handling this situation can be rather complex, so let's keep it
>>> simple. I have added a dedicated function to capture the intended behavior
>>> for potential future reference.
>>>
>>> Anyway, Thanks for taking Zhaoxin's situation into account, regardless.
>>>
>> Thanks for your code example!!
>>
>> Zhaoxin implements perfmon v2, so I think checking the vendor might be
>> overly complicated. If a check is needed, it seems more reasonable to
>> check the perfmon version rather than the vendor, similar to how avx10
>> version is checked in x86_cpu_filter_features().
>>
>> I understand Ewan's concern is that if an Intel guest requires a higher
>> perfmon version that the Zhaoxin host doesn't support, there could be
>> issues (although I think this situation doesn't currently exist in KVM-QEMU,
>> one reason is QEMU uses the pmu_version in 0xa queried from KVM directly,
>> which means QEMU currently doesn't support custom pmu_version).
> Yeah, that's exactly what I was concerned about.
> Thanks for clearing that up!
>
> perfmon_version is a great idea --- I might add it as a property to the QEMU 
> vCPU template in the future, so it can adjust based on user input and host support.
> Can't promise a timeline yet, but it's definitely something I'll keep in mind.

I'm wondering if there are real user cases that sets a lower PMU version
than host PMU version (live migration on different HW platforms?). In
theory, the higher PMU version should fully back compatible with lower PMU
version, but it's not always true in reality. One example is that the
Anythread bit introduced in v3 is dropped in PMU v5 on Intel processors.
This causes some difficulties to support PMU version 3/4 on host with PMU
version 5+. Different PMU versions between host and guest could cause
similar issues on other platforms.

Currently KVM supported highest PMU version is v2. We plan to support
higher PMU version for Intel processors on top of mediated vPMU. If guest
sets pmu version to 3/4 on host with PMU version 5+, the Anythread bit
would be marked as reserved,


