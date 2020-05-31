Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF6B1E9504
	for <lists+kvm@lfdr.de>; Sun, 31 May 2020 04:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgEaCfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 22:35:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:7620 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgEaCfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 22:35:14 -0400
IronPort-SDR: iPxGty4gnTrW/8QXIObF1KKfYlsBrHVOl2Y413xPSuysKAudmlw6oczm1mba3/JPA8Q/StDs65
 Nmn7hsoXuSBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2020 19:35:13 -0700
IronPort-SDR: DZNxe8pLkGVb6mjZO2e67FfDjThh81wnbJzcKqrkM4GkqH4lRFQUpXruDvCseti5oTRHSfth78
 PQl6DwB+atlg==
X-IronPort-AV: E=Sophos;i="5.73,455,1583222400"; 
   d="scan'208";a="443875232"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.175.168]) ([10.249.175.168])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2020 19:35:10 -0700
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIXVt2NV0gS1ZNOiBYODY6IHN1cHBvcnQg?=
 =?UTF-8?Q?APERF/MPERF_registers?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
References: <1590813353-11775-1-git-send-email-lirongqing@baidu.com>
 <3f931ecf-7f1c-c178-d18c-46beadd1d313@intel.com>
 <e7ccee7dc30e4d1e8dcb8a002d6a6ed2@baidu.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <9c870a06-ee46-5c9d-11c0-602aeb18c83d@intel.com>
Date:   Sun, 31 May 2020 10:35:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <e7ccee7dc30e4d1e8dcb8a002d6a6ed2@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/2020 10:08 AM, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Xiaoyao Li [mailto:xiaoyao.li@intel.com]
>> 发送时间: 2020年5月30日 18:40
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; x86@kernel.org; hpa@zytor.com; bp@alien8.de;
>> mingo@redhat.com; tglx@linutronix.de; jmattson@google.com;
>> wanpengli@tencent.com; vkuznets@redhat.com;
>> sean.j.christopherson@intel.com; pbonzini@redhat.com;
>> wei.huang2@amd.com
>> 主题: Re: [PATCH][v5] KVM: X86: support APERF/MPERF registers
>>
>> On 5/30/2020 12:35 PM, Li RongQing wrote:
>>> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo, this is
>>> confused to user when turbo is enable, and aperf/mperf can be used to
>>> show current cpu frequency after 7d5905dc14a
>>> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
>>> so guest should support aperf/mperf capability
>>>
>>> This patch implements aperf/mperf by three mode: none, software
>>> emulation, and pass-through
>>>
>>> None: default mode, guest does not support aperf/mperf
>>>
>>> Software emulation: the period of aperf/mperf in guest mode are
>>> accumulated as emulated value
>>>
>>> Pass-though: it is only suitable for KVM_HINTS_REALTIME, Because that
>>> hint guarantees we have a 1:1 vCPU:CPU binding and guaranteed no
>>> over-commit.
>>>
>>> And a per-VM capability is added to configure aperfmperf mode
>>>
>>
>> [...]
>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c index
>>> cd708b0b460a..c960dda4251b 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -122,6 +122,14 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>>>    					   MSR_IA32_MISC_ENABLE_MWAIT);
>>>    	}
>>>
>>> +	best = kvm_find_cpuid_entry(vcpu, 6, 0);
>>> +	if (best) {
>>> +		if (guest_has_aperfmperf(vcpu->kvm) &&
>>> +			boot_cpu_has(X86_FEATURE_APERFMPERF))
>>> +			best->ecx |= 1;
>>> +		else
>>> +			best->ecx &= ~1;
>>> +	}
>>
>> In my understanding, KVM allows userspace to set a CPUID feature bit for
>> guest even if hardware doesn't support the feature.
>>
>> So what makes X86_FEATURE_APERFMPERF different here? Is there any
>> concern I miss?
>>
>> -Xiaoyao
> 
> Whether software emulation for aperf/mperf or pass-through depends on host cpu aperf/mperf feature.
>   
> Software emulation: the period of aperf/mperf in guest mode are accumulated as emulated value
> 

I know it that you want to ensure the correctness of exposure of 
aperf/mperf.

But there are so many features other than aperf/mperf that KVM reports 
the supported settings of them through KVM_GET_SUPPORTED_CPUID, but 
doesn't check nor force the correctness of userspace input. i.e., KVM 
allows userspace to set bogus CPUID settings as long as it doesn't break 
KVM (host kernel).

Indeed, bogus CPUID settings more than likely breaks the guest. But it's 
not KVM's fault. KVM just do what userspace wants.

IMO, If we really want to ensure the correctness of userspace provided 
CPUID settings, we need to return ERROR to userspace instead of fixing 
it siliently.

- Xiaoyao
