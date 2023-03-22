Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64BD6C49AD
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCVLv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCVLvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:51:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1A6D2E6;
        Wed, 22 Mar 2023 04:51:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D06524B3;
        Wed, 22 Mar 2023 04:52:07 -0700 (PDT)
Received: from [10.57.53.137] (unknown [10.57.53.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2E553F67D;
        Wed, 22 Mar 2023 04:51:20 -0700 (PDT)
Message-ID: <2a944bb7-23d0-7b49-90c2-5bcf8da694b0@arm.com>
Date:   Wed, 22 Mar 2023 11:51:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 15/28] KVM: arm64: Handle realm MMIO emulation
Content-Language: en-GB
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-16-steven.price@arm.com>
 <20230306173751.000026d4@gmail.com>
 <e0354676-e8cf-6ea0-3229-a55d90259f8e@arm.com>
 <20230314174436.0000584d@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230314174436.0000584d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/03/2023 15:44, Zhi Wang wrote:
> On Fri, 10 Mar 2023 15:47:14 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
>> On 06/03/2023 15:37, Zhi Wang wrote:
>>> On Fri, 27 Jan 2023 11:29:19 +0000
>>> Steven Price <steven.price@arm.com> wrote:
>>>   
>>>> MMIO emulation for a realm cannot be done directly with the VM's
>>>> registers as they are protected from the host. However the RMM interface
>>>> provides a structure member for providing the read/written value and  
>>>
>>> More details would be better for helping the review. I can only see the
>>> emulated mmio value from the device model (kvmtool or kvm_io_bus) is put into
>>> the GPRS[0] of the RecEntry object. But the rest of the flow is missing.  
>>
>> The commit message is out of date (sorry about that). A previous version
>> of the spec had a dedicated member for the read/write value, but this
>> was changed to just use GPRS[0] as you've spotted. I'll update the text.
>>
>>> I guess RMM copies the value in the RecEntry.GPRS[0] to the target GPR in the
>>> guest context in RMI_REC_ENTER when seeing RMI_EMULATED_MMIO. This is for
>>> the guest MMIO read path.  
>>
>> Yes, when entering the guest after an (emulatable) read data abort the
>> value in GPRS[0] is loaded from the RecEntry structure into the
>> appropriate register for the guest.
>>
>>> How about the MMIO write path? I don't see where the RecExit.GPRS[0] is loaded
>>> to a varible and returned to the userspace.  
>>
> 
> -----
>> The RMM will populate GPRS[0] with the written value in this case (even
>> if another register was actually used in the instruction). We then
>> transfer that to the usual VCPU structure so that the normal fault
>> handling logic works.
>>
> -----
> 
> Are these in this patch or another patch?

The RMM (not included in this particular series[1]) sets the first
element of the 'GPRS' array which is in memory shared with the host.

The Linux half to populate the vcpu structure is in the previous patch:

+static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
+{
+	struct rec *rec = &vcpu->arch.rec;
+
+	if (kvm_vcpu_dabt_iswrite(vcpu) && kvm_vcpu_dabt_isvalid(vcpu))
+		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu),
+			     rec->run->exit.gprs[0]);
+
+	return kvm_handle_guest_abort(vcpu);
+}

I guess it might make sense to pull the 'if' statement out of the
previous patch and into this one to keep all the MMIO code together.

Steve

[1] This Linux code is written against the RMM specification and in
theory could work with any RMM implementation. But the TF RMM is open
source, so I can point you at the assignment in the latest commit here:
https://git.trustedfirmware.org/TF-RMM/tf-rmm.git/tree/runtime/core/exit.c?id=d294b1b05e8d234d32684a982552aa2a17fb9157#n264

>>>> we can transfer this to the appropriate VCPU's register entry and then
>>>> depend on the generic MMIO handling code in KVM.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>>  arch/arm64/kvm/mmio.c | 7 +++++++
>>>>  1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
>>>> index 3dd38a151d2a..c4879fa3a8d3 100644
>>>> --- a/arch/arm64/kvm/mmio.c
>>>> +++ b/arch/arm64/kvm/mmio.c
>>>> @@ -6,6 +6,7 @@
>>>>  
>>>>  #include <linux/kvm_host.h>
>>>>  #include <asm/kvm_emulate.h>
>>>> +#include <asm/rmi_smc.h>
>>>>  #include <trace/events/kvm.h>
>>>>  
>>>>  #include "trace.h"
>>>> @@ -109,6 +110,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>>>>  			       &data);
>>>>  		data = vcpu_data_host_to_guest(vcpu, data, len);
>>>>  		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
>>>> +
>>>> +		if (vcpu_is_rec(vcpu))
>>>> +			vcpu->arch.rec.run->entry.gprs[0] = data;  
>>>
>>> I think the guest context is maintained by RMM (while KVM can only touch
>>> Rec{Entry, Exit} object) so that guest context in the legacy VHE mode is
>>> unused.
>>>
>>> If yes, I guess here is should be:
>>>
>>> if (unlikely(vcpu_is_rec(vcpu)))
>>> 	vcpu->arch.rec.run->entry.gprs[0] = data;
>>> else
>>> 	vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);  
>>
>> Correct. Although there's no harm in updating with vcpu_set_reg(). But
>> I'll make the change because it's clearer.
>>
>>>>  	}
>>>>  
>>>>  	/*
>>>> @@ -179,6 +183,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>>>>  	run->mmio.len		= len;
>>>>  	vcpu->mmio_needed	= 1;
>>>>  
>>>> +	if (vcpu_is_rec(vcpu))
>>>> +		vcpu->arch.rec.run->entry.flags |= RMI_EMULATED_MMIO;
>>>> +  
>>>
>>> Wouldn't it be better to set this in the kvm_handle_mmio_return where the MMIO
>>> read emulation has been surely successful?  
>>
>> Yes, that makes sense - I'll move this.
>>
>> Thanks,
>>
>> Steve
>>
>>>>  	if (!ret) {
>>>>  		/* We handled the access successfully in the kernel. */
>>>>  		if (!is_write)  
>>>   
>>
> 

