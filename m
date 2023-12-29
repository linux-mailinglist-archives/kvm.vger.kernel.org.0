Return-Path: <kvm+bounces-5317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 488A281FCF9
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 05:21:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5A611F22C04
	for <lists+kvm@lfdr.de>; Fri, 29 Dec 2023 04:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020C123AF;
	Fri, 29 Dec 2023 04:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hwEuCGuG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E221FA8;
	Fri, 29 Dec 2023 04:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703823665; x=1735359665;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=bCk1WmPQGNe7VSwvo3KzDGGlaLdYm0gwge09YznPONI=;
  b=hwEuCGuG+hbLU/WbK8Goo6Ia0hJ05zQ5hsdpIqhMd3Xa453MnuarUlYD
   DXO6Q2MREo/X3UoYhjv5fOBF/Tvyx9owFV+/KFPGIR8o1dSx/zUJcX1Vm
   +YL8ga7dhYpvkh6y4rW832PPpzM3oCtQrq8TbGAJLgXTMPW1GotM/aESE
   D5G1WRuuOCzpZ52xAw9p0xMdVOvnh6OdyT5PajS2t9V0K54+OU3Vqkyyu
   tzMmROucTTa6d93MRM83+4HFqz9fE8/m8XDv0rDjmiUvPL3aKnzcF9eCM
   37e8pBN6Y1wbXaV4g93PYGHPMZBiNCOtQ7fi1ARYDuvz5BBTI6zywpgOA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10937"; a="482801277"
X-IronPort-AV: E=Sophos;i="6.04,314,1695711600"; 
   d="scan'208";a="482801277"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 20:21:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10937"; a="728502480"
X-IronPort-AV: E=Sophos;i="6.04,314,1695711600"; 
   d="scan'208";a="728502480"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2023 20:21:01 -0800
Message-ID: <7e614fab-8f91-4a91-bfbf-1b02b9f12cdb@intel.com>
Date: Fri, 29 Dec 2023 12:20:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] KVM: x86/hyperv: Calculate APIC bus frequency for
 hyper-v
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: isaku.yamahata@gmail.com
References: <cover.1702974319.git.isaku.yamahata@intel.com>
 <ecd345619fdddfe48f375160c90322754cec9096.1702974319.git.isaku.yamahata@intel.com>
 <09cec4fd-2d79-4925-bb2b-7814032fdda3@intel.com>
In-Reply-To: <09cec4fd-2d79-4925-bb2b-7814032fdda3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/21/2023 1:26 PM, Xiaoyao Li wrote:
> On 12/19/2023 4:34 PM, Isaku Yamahata wrote:
>> Remove APIC_BUS_FREUQNCY and calculate it based on APIC bus cycles per 
>> NS.
>> APIC_BUS_FREUQNCY is used only for HV_X64_MSR_APIC_FREQUENCY.  The MSR is
>> not frequently read, calculate it every time.
>>
>> In order to make APIC bus frequency configurable, we need to make make 
>> two
> 
> two 'make', please drop one.

With this and other typos pointed by Maxim fixed.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>> related constants into variables.  APIC_BUS_FREUQNCY and 
>> APIC_BUS_CYCLE_NS.
>> One can be calculated from the other.
>>     APIC_BUS_CYCLES_NS = 1000 * 1000 * 1000 / APIC_BUS_FREQUENCY.
>> By removing APIC_BUS_FREQUENCY, we need to track only single variable
>> instead of two.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>> Changes v3:
>> - Newly added according to Maxim Levistsky suggestion.
>> ---
>>   arch/x86/kvm/hyperv.c | 2 +-
>>   arch/x86/kvm/lapic.h  | 1 -
>>   2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 238afd7335e4..a40ca2fef58c 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1687,7 +1687,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, 
>> u32 msr, u64 *pdata,
>>           data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
>>           break;
>>       case HV_X64_MSR_APIC_FREQUENCY:
>> -        data = APIC_BUS_FREQUENCY;
>> +        data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
>>           break;
>>       default:
>>           kvm_pr_unimpl_rdmsr(vcpu, msr);
>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>> index 0a0ea4b5dd8c..a20cb006b6c8 100644
>> --- a/arch/x86/kvm/lapic.h
>> +++ b/arch/x86/kvm/lapic.h
>> @@ -17,7 +17,6 @@
>>   #define APIC_DEST_MASK            0x800
>>   #define APIC_BUS_CYCLE_NS       1
>> -#define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
>>   #define APIC_BROADCAST            0xFF
>>   #define X2APIC_BROADCAST        0xFFFFFFFFul
> 
> 


