Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F67AF3D7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 03:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfIKBLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 21:11:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:17515 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbfIKBLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 21:11:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 18:11:43 -0700
X-IronPort-AV: E=Sophos;i="5.64,491,1559545200"; 
   d="scan'208";a="189521258"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 10 Sep 2019 18:11:41 -0700
Subject: Re: [PATCH v2 1/2] KVM: CPUID: Check limit first when emulating CPUID
 instruction
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>
References: <20190910102742.47729-1-xiaoyao.li@intel.com>
 <20190910102742.47729-2-xiaoyao.li@intel.com>
 <CALMp9eRUW_N8uaJm8Mz-fkmNE=qpd5=FpKyKahQx4RiCKOLZKA@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <0c92b31d-ea09-faeb-d032-811b22e73721@intel.com>
Date:   Wed, 11 Sep 2019 09:11:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRUW_N8uaJm8Mz-fkmNE=qpd5=FpKyKahQx4RiCKOLZKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/2019 1:00 AM, Jim Mattson wrote:
> On Tue, Sep 10, 2019 at 3:42 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> When limit checking is required, it should be executed first, which is
>> consistent with the CPUID specification.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> v2:
>>    - correctly set entry_found in no limit checking case.
>>
>> ---
>>   arch/x86/kvm/cpuid.c | 51 ++++++++++++++++++++++++++------------------
>>   1 file changed, 30 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 22c2720cd948..67fa44ab87af 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -952,23 +952,36 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>>   EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
>>
>>   /*
>> - * If no match is found, check whether we exceed the vCPU's limit
>> - * and return the content of the highest valid _standard_ leaf instead.
>> - * This is to satisfy the CPUID specification.
>> + * Based on CPUID specification, if leaf number exceeds the vCPU's limit,
>> + * it should return the content of the highest valid _standard_ leaf instead.
>> + * Note: *found is set true only means the queried leaf number doesn't exceed
>> + * the maximum leaf number of basic or extented leaf.
> 
> Nit: "extented" should be "extended."
> 
> A more serious problem is that the CPUID specification you quote is
> Intel's specification. AMD CPUs return zeroes in EAX, EBX, ECX, and
> EDX for all undefined leaves, whatever the input value for EAX. This
> code is supposed to be vendor-agnostic, right?
> 

I checked the AMD spec and I didn't find the statement about "AMD CPUs 
return zeroes in EAX, EBX, ECX, and EDX for all undefined leaves". I 
don't have AMD machine at hand so that I can't test it to verify it.

Assume what you said about AMD CPUs is true, then the current codes in 
KVM makes AMD guest act as Intel CPU that returns the highest valid 
standard leaf if input value of EAX exceeds the limit.

Anyway, I find we cannot check the limit first for guest, otherwise the 
leaves 0x4000XXXX will be not readable. So please just ignore this patch.
