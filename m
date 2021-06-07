Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691F039D36F
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 05:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhFGD3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 23:29:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:8805 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhFGD3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 23:29:24 -0400
IronPort-SDR: T5vZiID60OffsMQ8fbszzFfrOOW3zU7cNMUOGFJfpBdqBgFDov+iqtlcAbs7xgO8rqvA4x3Eqz
 XR4juuqpgTgA==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="201533702"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="201533702"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 20:27:32 -0700
IronPort-SDR: f0zcxGY6Beu1vGVBAwafDXW0K8TSGILpbO+Y5iicMziEyiDWuwnj8lW+7e4ilCXA3phTIEWKDF
 V+5kuaNrXKjQ==
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="481365220"
Received: from unknown (HELO [10.238.130.222]) ([10.238.130.222])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 20:27:30 -0700
Subject: Re: [PATCH RFC 1/7] kvm: x86: Expose XFD CPUID to guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-2-jing2.liu@linux.intel.com>
 <YKwbz3zuPhR7u1dw@google.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <bdf18ee9-eac7-7706-6496-94b8c4e4a835@linux.intel.com>
Date:   Mon, 7 Jun 2021 11:27:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YKwbz3zuPhR7u1dw@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2021 5:34 AM, Sean Christopherson wrote:
> I need a formletter for these...
>
> GET_SUPPORTED_CPUID advertises support to userspace, it does not expose anything
> to the guest.
Oh, yes. This is only part of cpuid exposing process. Let me change the 
commit log.
>
> On Sun, Feb 07, 2021, Jing Liu wrote:
>> Intel's Extended Feature Disable (XFD) feature is an extension
>> to the XSAVE feature that allows an operating system to enable
>> a feature while preventing specific user threads from using
>> the feature. A processor that supports XFD enumerates
>> CPUID.(EAX=0DH,ECX=1):EAX[4] as 1.
>>
>> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 83637a2ff605..04a73c395c71 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -437,7 +437,7 @@ void kvm_set_cpu_caps(void)
>>   	);
>>   
>>   	kvm_cpu_cap_mask(CPUID_D_1_EAX,
>> -		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
>> +		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | F(XFD)
> KVM must not advertise support until it actually has said support, i.e. this
> patch needs to go at the end of the series.
>
> Also, adding the kvm_cpu_cap flag in a separate patch isn't strictly required.
> In most cases, I would go so far as to say that if there is additional enabling
> to be done, advertising the feature should be done in the same patch that adds
> the last bits of enabling.  Putting the CPUID stuff in its own patch doesn't
> usually add values, e.g. if there's a bug in the actual support code bisecting
> will point at the wrong patch if userspace conditions its vCPU model on
> GET_SUPPORTED_CPUID.
Got it. Since XFD are separate feature from AMX, when trying to think about
putting CPUID stuff to MSR stuff, current MSR stuff are mainly two 
parts, one is
two MSRs support, another is MSR switches. So it seems not suitable to 
put CPUID
into MSR switch patch?

Thanks,
Jing

>>   	);
>>   
>>   	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
>> -- 
>> 2.18.4
>>

