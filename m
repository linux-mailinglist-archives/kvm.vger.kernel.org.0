Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA03539119B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 09:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhEZH4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 03:56:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:32259 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhEZH4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 03:56:18 -0400
IronPort-SDR: iTmoIPfQMq/5ummyGniLQzfMScKRBD+7dvtXQKWLugT+B3LKU8ozmrFONkTGVFh4Fx4eXUwbDh
 cdXjz8PB/CqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="182049407"
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="182049407"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 00:54:28 -0700
IronPort-SDR: 1eDK10l4aELIeN+e7qSF++9Ypk821KL2VW5dlFw7M+S5sV4oFNOL/GUJ6THLMWqdrq16tEHfLY
 TNHwFZgOmtRg==
X-IronPort-AV: E=Sophos;i="5.82,330,1613462400"; 
   d="scan'208";a="476818609"
Received: from unknown (HELO [10.238.130.158]) ([10.238.130.158])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 00:54:26 -0700
Subject: Re: [PATCH RFC 7/7] kvm: x86: AMX XCR0 support for guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-8-jing2.liu@linux.intel.com>
 <YKwgdBTqiyuItL6b@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <43eb3317-4101-0786-57f4-f35e7ec094eb@linux.intel.com>
Date:   Wed, 26 May 2021 15:54:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YKwgdBTqiyuItL6b@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2021 5:53 AM, Sean Christopherson wrote:
> On Sun, Feb 07, 2021, Jing Liu wrote:
>> Two XCR0 bits are defined for AMX to support XSAVE mechanism.
>> Bit 17 is for tilecfg and bit 18 is for tiledata.
> This fails to explain why they must be set in tandem.
The spec says,
"executing the XSETBV instruction causes a general-protection fault 
(#GP) if ECX=0
and EAX[17] ≠ EAX[18] (XTILECFG and XTILEDATA must be enabled together). 
This
implies that the value of XCR0[17:18] is always either 00b or 11b."

I can add more to changelog if this is reasonable.
>   Out of curisoity, assuming
> they do indeed need to be set/cleared as a pair, what's the point of having two
> separate bits?
What I can see is to separate different states and mirror by XFD which 
can set
bits separately.

Thanks,
Jing

>
>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index bfbde877221e..f1c5893dee18 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -189,7 +189,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>>   #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
>>   				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
>>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>> -				| XFEATURE_MASK_PKRU)
>> +				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>>   
>>   u64 __read_mostly host_efer;
>>   EXPORT_SYMBOL_GPL(host_efer);
>> @@ -946,6 +946,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>>   		if ((xcr0 & XFEATURE_MASK_AVX512) != XFEATURE_MASK_AVX512)
>>   			return 1;
>>   	}
>> +
>> +	if (xcr0 & XFEATURE_MASK_XTILE) {
>> +		if ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE)
>> +			return 1;
>> +	}
>> +
>>   	vcpu->arch.xcr0 = xcr0;
>>   
>>   	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
>> -- 
>> 2.18.4
>>

