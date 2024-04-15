Return-Path: <kvm+bounces-14621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8C28A47EB
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C6BD1C21761
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F76101F2;
	Mon, 15 Apr 2024 06:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YlJpUejI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7E9F4F1
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713161845; cv=none; b=BL4myros98lLdLGq/qTkHk7gFar4zI7OgzqDARQlHD80iLtLiYLp7adu9UHuX0nvoHUQ5U04aCzjGRorRhDlsH4GH3bP0IA6LKDGOtthKoHy1oVm2xjpqvY13vMrxHYXLl9SC79fS7FHPQ8EM7rw3wp7WphIk5xe8O4c0fvTsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713161845; c=relaxed/simple;
	bh=+CWlU/PUCnePB+sx0zuS7kVFDQrlRdMuqfUpBg6GL64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sjBJcJwg42Pni83/5HpNK6AOSGl1fM20byivruDaXT+JxiqFNJg5ndMWqAYvDMGBuINWcEqktVIg69ZgQEThVBMEbe4Tz9M0feiwI6GicRvwUcfX7ZF4JyVao0gwfAcvI2VUAT/wOIFpyvrkGDYG2jcMvpKWvuktYEey90fIinY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YlJpUejI; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713161843; x=1744697843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+CWlU/PUCnePB+sx0zuS7kVFDQrlRdMuqfUpBg6GL64=;
  b=YlJpUejIyG6TaKkTWi47WitFTro40Bi2a9KqeDHwQ0YFbNuKmrwWPpld
   vWOYq+SEhZUvNTlZn/rqH4BOK8uIXPMiD3qgW6JjWLXTZejx7utUtl1tr
   By4C0hQ1IsjAikodjOTVbtUj5xCudOXN+aPRNiVHH9mJk0Xp0PP1S1zoX
   Um07X9RkDlc+VY3t2kKAgrnXCnEchVnkBrAO2RKKwpxQCL2+Q/KCvwUOD
   +VRgDnUC+J2Tspq1JcCnuNsYadgkhJnfxdELy2grM06ymArYDjBUP4YSU
   BDi0nYg8/5RXAyb+77T5MewzVUIxiH5tjhymzyJcI16R394rcXafxcivn
   w==;
X-CSE-ConnectionGUID: BVs0ewmYToCM6hcbFT/efA==
X-CSE-MsgGUID: PTwZhd3PS7aSR2ybJ38Xog==
X-IronPort-AV: E=McAfee;i="6600,9927,11044"; a="8389879"
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="8389879"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 23:17:23 -0700
X-CSE-ConnectionGUID: SV0cWM/mRGSylRePaVODfA==
X-CSE-MsgGUID: Mv/R1fOfQgGpNIfkFw9hrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,202,1708416000"; 
   d="scan'208";a="21877335"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2024 23:17:21 -0700
Message-ID: <627a61bf-de07-43a7-bb4a-9539673674b2@intel.com>
Date: Mon, 15 Apr 2024 14:17:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] kvm/cpuid: set proper GuestPhysBits in
 CPUID.0x80000008
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20240313125844.912415-1-kraxel@redhat.com>
 <171270475472.1589311.9359836741269321589.b4-ty@google.com>
 <afbe8c9a-19f9-42e8-a440-2e98271a4ce6@intel.com>
 <ZhlXzbL66Xzn2t_a@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZhlXzbL66Xzn2t_a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/2024 11:48 PM, Sean Christopherson wrote:
> On Fri, Apr 12, 2024, Xiaoyao Li wrote:
>> On 4/10/2024 8:19 AM, Sean Christopherson wrote:
>>> On Wed, 13 Mar 2024 13:58:41 +0100, Gerd Hoffmann wrote:
>>>> Use the GuestPhysBits field (EAX[23:16]) to communicate the max
>>>> addressable GPA to the guest.  Typically this is identical to the max
>>>> effective GPA, except in case the CPU supports MAXPHYADDR > 48 but does
>>>> not support 5-level TDP.
>>>>
>>>> See commit messages and source code comments for details.
>>>>
>>>> [...]
>>>
>>> Applied to kvm-x86 misc, with massaged changelogs to be more verbose when
>>> describing the impact of each change, e.g. to call out that patch 2 isn't an
>>> urgent fix because guest firmware can simply limit itself to using GPAs that
>>> can be addressed with 4-level paging.
>>>
>>> I also tagged patch 1 for stable@, as KVM-on-KVM will do the wrong thing when
>>> patch 2 lands, i.e. KVM will incorrectly advertise the addressable MAXPHYADDR
>>> as the raw/real MAXPHYADDR.
>>
>> you mean old KVM on new KVM?
> 
> Yep.
> 
>> As far as I see, it seems no harm. e.g., if the userspace and L0 KVM have
>> the new implementation. On Intel SRF platform, L1 KVM sees EAX[23:16]=48,
>> EAX[7:0]=52. And when L1 KVM is old, it reports EAX[7:0] = 48 to L1
>> userspace.
> 
> Yep.
> 
>> right, 48 is not the raw/real MAXPHYADDR. But I think there is not statement
>> on KVM that CPUID.0x8000_0008.EAX[7:0] of KVM_GET_SUPPORTED_CPUID reports
>> the raw/real MAXPHYADDR.
> 
> If we go deep enough, it becomes a functional problem.  It's not even _that_
> ridiculous/contrived :-)
> 
> L1 KVM is still aware that the real MAXPHYADDR=52, and so there are no immediate
> issues with reserved bits at that level.
> 
> But L1 userspace will unintentionally configure L2 with CPUID.0x8000_0008.EAX[7:0]=48,
> and so L2 KVM will incorrectly think bits 51:48 are reserved.  If both L0 and L1
> are using TDP, neither L0 nor L1 will intercept #PF.  And because L1 userspace
> was told MAXPHYADDR=48, it won't know that KVM needs to be configured with
> allow_smaller_maxphyaddr=true in order for the setup to function correctly.

In this case, a) L1 userspace was told by L1 KVM that MAXPHYADDR = 48 
via KVM_GET_SUPPORTED_CPUID. But b) L1 userspace gets MAXPHYADDR = 52 by 
executing CPUID itself.

So if L1 userspace decides to configure MAXPHYADDR to 48 for L2, 
according to a). It is supposed to check if KVM is configured with 
allow_smaller_maxphyaddr=y. Otherwise, it cannot expect it works 
function correctly.

> If L2 runs an L3, and does not use EPT, L2 will think it can generate a RSVD #PF
> to accelerate emulated MMIO.  The GPA with bits 51:48!=0 created by L2 generates
> an EPT violation in L1.  Because L1 doesn't have allow_smaller_maxphyaddr, L1
> installs an EPT mapping for the wrong GPA (effectively drops bits 51:48), and
> L3 hangs because L1 will keep doing nothing on the resulting EPT violation (L1
> thinks there's already a valid mapping).
> 
> With patch 1 and the OVMF fixes backported, L1 KVM will enumerate MAXPHYADDR=52,
> L1 userspace creates L2 with MAXPHYADDR=52, and L2 OVMF restricts its mappings to
> bits 47:0.
> 
> At least, I think that's what will happen.


