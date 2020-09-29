Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A527BDA7
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 09:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgI2HMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 03:12:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:20106 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2HMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 03:12:55 -0400
IronPort-SDR: IVWzppD5QEhMVi5n7uQijGUkr3jTTHyQCWCKniAyqo6jjCmUS68p3xiBiAkm3EMt0y6xbJ7eC3
 t1LJPiRUwpfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162195086"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="162195086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 00:12:53 -0700
IronPort-SDR: 0ySBwsUG68XnKbWqOBdUmTSRn9SB7cEtAZMYwQGOcRbkU6/JRXs/b3cuyZK9RBWPFtdgS1OMQu
 TqF6Dsq//ZZw==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="338510317"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.187]) ([10.238.4.187])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 00:12:50 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH v13 02/10] KVM: x86/vmx: Make vmx_set_intercept_for_msr()
 non-static and expose it
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200726153229.27149-1-like.xu@linux.intel.com>
 <20200726153229.27149-4-like.xu@linux.intel.com>
 <20200929031342.GD31514@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <4639bb31-1b65-91d3-52b6-f95bf8311d39@intel.com>
Date:   Tue, 29 Sep 2020 15:12:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929031342.GD31514@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2020/9/29 11:13, Sean Christopherson wrote:
> On Sun, Jul 26, 2020 at 11:32:21PM +0800, Like Xu wrote:
>> It's reasonable to call vmx_set_intercept_for_msr() in other vmx-specific
>> files (e.g. pmu_intel.c), so expose it without semantic changes hopefully.
> I suppose it's reasonable, but you still need to state what is actually
> going to use it.

Sure, I will add more here that
one of its usage is to pass through LBR-related msrs later.

>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 4 ++--
>>   arch/x86/kvm/vmx/vmx.h | 2 ++
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index dcde73a230c6..162c668d58f5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3772,8 +3772,8 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
>>   	}
>>   }
>>   
>> -static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
>> -			     			      u32 msr, int type, bool value)
>> +__always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
>> +					 u32 msr, int type, bool value)
>>   {
>>   	if (value)
>>   		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>> index 0d06951e607c..08c850596cfc 100644
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -356,6 +356,8 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
>>   int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
>>   int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>>   			      struct x86_exception *e);
>> +void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
>> +			      u32 msr, int type, bool value);
> This completely defeats the purpose of __always_inline.
My motivation is to use vmx_set_intercept_for_msr() in pmu_intel.c,
which helps to extract pmu-specific code from vmx.c

I assume modern compilers will still make it inline even in this way,
or do you have a better solution for this?

Please let me if you have more comments on the patch series.

Thanks,
Like Xu
>
>>   
>>   #define POSTED_INTR_ON  0
>>   #define POSTED_INTR_SN  1
>> -- 
>> 2.21.3
>>

