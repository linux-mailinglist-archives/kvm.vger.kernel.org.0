Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A338E1A3792
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgDIP5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:57:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:9697 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbgDIP5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:57:22 -0400
IronPort-SDR: BRK6bWVW8Dh7sc4nlbyoYE+bWwiKaFqdxP3ZkRYORiTrqFLp05G3dKkw18ulZyCBJAljzZZWKb
 q62Hd+MKUsBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 08:57:22 -0700
IronPort-SDR: blQbU53+GtmcOXJtW/GJlWhGhV1wM5miOffoVTFEYYqvCD4K2ggqRsEGD+nd1Y3Ud4JrBvUD6S
 T8ESsk29G5nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="275864254"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.170.160]) ([10.249.170.160])
  by fmsmga004.fm.intel.com with ESMTP; 09 Apr 2020 08:57:21 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20200409114926.1407442-1-ubizjak@gmail.com>
 <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
 <CAFULd4awe3Y1xXW+umWsjE69i2Fv0R5=0V0SveqnxjVQ2ijY1g@mail.gmail.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <e9f20978-b21c-f62b-5746-4498a08dcc34@intel.com>
Date:   Thu, 9 Apr 2020 23:57:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4awe3Y1xXW+umWsjE69i2Fv0R5=0V0SveqnxjVQ2ijY1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/4/9 23:27, Uros Bizjak wrote:
> On Thu, Apr 9, 2020 at 5:11 PM Xu, Like <like.xu@intel.com> wrote:
>> Hi Bizjak,
>>
>> On 2020/4/9 19:49, Uros Bizjak wrote:
>>> The function returns no value.
>>>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Fixes: 199cd1d7b534 ("KVM: SVM: Split svm_vcpu_run inline assembly to separate file")
>>> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
>>> ---
>>>    arch/x86/kvm/svm/svm.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 2be5bbae3a40..061d19e69c73 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3276,7 +3276,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>>>        svm_complete_interrupts(svm);
>>>    }
>>>
>>> -bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>> Just curious if __svm_vcpu_run() will fail to enter SVM guest mode,
>> and a return value could indicate that nothing went wrong rather than
>> blindly keeping silent.
> vmload, vmrun and vmsave do not return anything in flags or registers,
> so we can't detect anything at this point, modulo exception that is
> handled below the respective instruction.
If we check the __vmx_vcpu_run(), we have something like:

     /* VM-Fail.  Out-of-line to avoid a taken Jcc after VM-Exit. */
2:    mov $1, %eax
     jmp 1b

so do we need it in the __svm_vcpu_run() or why not ?
>
> BTW: the change by itself does not change the generated code, the fake
> return value from __svm_vcpu_run is already ignored. So, the change is
> mostly cosmetic.
Yes, the generated code is not affected and the change is reasonable.
>
> Uros.

