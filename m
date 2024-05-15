Return-Path: <kvm+bounces-17412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F4D8C5EA1
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41DEB1C21280
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650BFA945;
	Wed, 15 May 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aGUcSoil"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2285779C0;
	Wed, 15 May 2024 01:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715735018; cv=none; b=BUb/6TphZv4pVR0p91kiay9WtE3tnnhxx9NroN9KFlNPqHS5R+q7aUNtZbjI74/s30iZAYE//4/rYBO/ZpKSEMHtD5cDWClH2sW1uzvoFh2yRq9rUUzKvzzOSsSjaDbhFhep73z0LqOcSiJiYR1fAtgeoTPTPbAPfuQch6TOTjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715735018; c=relaxed/simple;
	bh=4OiZUesDpK8HfNBqjTK3RKtPsh+bnPrU9/H8cPvHkNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sH+HD3Uqv/LAEWFsp+CLL1aSFaLGyAG104MyTDKpbqsWk/pzqzPjnhiA9sDcHErJf+r26ubYfnEl5qxa8RFO/j7uszwEkMs/vna4ky1ES16f2PXn512NVOOQgexC1waETnmUJYdvXbyX+fXSeb+Be9Wfxp/1ASGmjzqbBdp6Bno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aGUcSoil; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715735017; x=1747271017;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4OiZUesDpK8HfNBqjTK3RKtPsh+bnPrU9/H8cPvHkNE=;
  b=aGUcSoilxLafHBKcOxG2BCCws99GVmGfheGQee659kcaBKn08KqtuIli
   SDEugsPNK1kykWTA+1Q4QaqEGUtyreyb8tvfUXhj72GNNkXhb0/UlWKm4
   G07vIuvofKAyqLVBRSEFLyKBMdHpyr40Aj8iGwaf31b3eybr2VCToHm7z
   Xq0zRamb1FDqrDfDHPEYNmC182i/KRG99HWw7bOmJYb5/onUHDbO6yM+L
   lHRH2RnaFWWmjQBdNxKUj7lr/iYLWi4YuPMmresWRb/HOSKgbZxIAq2gh
   4PmgG2OcrJlj9QMRB/s7O6+CQDtS0v+yj+Ceu7yp/Ud4icfX/HUZgVqjn
   Q==;
X-CSE-ConnectionGUID: o2hJodJQTpm2RRVi7pEJDw==
X-CSE-MsgGUID: TZazJeUfTYWSE1CGkg84rA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11528259"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11528259"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:03:37 -0700
X-CSE-ConnectionGUID: 8PJ0ghk5Rkul+sctAQYXbw==
X-CSE-MsgGUID: qR+Z0+MjQuW//hsf0CSO8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30902292"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:03:34 -0700
Message-ID: <f6a9553b-517d-4ac4-a23c-96e2b885c828@intel.com>
Date: Wed, 15 May 2024 09:03:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/17] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-5-pbonzini@redhat.com>
 <3b6bc6ac-276f-4a83-8972-68b98db672c7@intel.com>
 <ZkJOb4zJJnOAYnTi@google.com>
 <55d00dc8-bfa3-4cf2-9c6a-1d81e5cfd7b3@intel.com>
 <ZkOEC3PbSmutUdsq@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZkOEC3PbSmutUdsq@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/2024 11:32 PM, Sean Christopherson wrote:
> On Tue, May 14, 2024, Xiaoyao Li wrote:
>> On 5/14/2024 1:31 AM, Sean Christopherson wrote:
>>> On Mon, May 13, 2024, Xiaoyao Li wrote:
>>>> On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
>>>>> +#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS)
>>>>>     #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>>>>>     				 PFERR_WRITE_MASK |		\
>>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>>> index c72a2033ca96..5562d693880a 100644
>>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>>> @@ -4502,6 +4502,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>>>>>     		return -EFAULT;
>>>>>     #endif
>>>>> +	/* Ensure the above sanity check also covers KVM-defined flags. */
>>>>
>>>> 1. There is no sanity check above related to KVM-defined flags yet. It has
>>>> to be after Patch 6.
>>>
>>> Ya, it's not just the comment, the entire changelog expects this patch to land
>>> after patch 6.
>>>>
>>>> 2. I somehow cannot parse the comment properly, though I know it's to ensure
>>>> KVM-defined PFERR_SYNTHETIC_MASK not contain any bit below 32-bits.
>>>
>>> Hmm, how about this?
>>>
>>> 	/*
>>> 	 * Ensure that the above sanity check on hardware error code bits 63:32
>>> 	 * also prevents false positives on KVM-defined flags.
>>> 	 */
>>>
>>
>> Maybe it's just myself inability, I still cannot interpret it well.
>>
>> Can't we put it above the sanity check of error code, and just with a
>> comment like
>>
>> 	/*
>>   	 * Ensure KVM-defined flags not occupied any bits below 32-bits,
>>         * that are used by hardware.
> 
> This is somewhat misleading, as hardware does use bits 63:32 (for #NPF), just not
> for #PF error codes.  And the reason I'm using rather indirect wording is that
> KVM _could_ define synthetic flags in bits 31:0, there's simply a higher probability
> of needing to reshuffle bit numbers due to a conflict with a future feature.
> 
> Is this better?  I think it captures what you're looking for, while hopefully also
> capturing that staying out of bits 31:0 isn't a hard requirement.

yeah, it looks better!

> 	/*
> 	 * Restrict KVM-defined flags to bits 63:32 so that it's impossible for
> 	 * them to conflict with #PF error codes, which are limited to 32 bits.
> 	 */


