Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A207E43B65
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfFMP22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:28:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18568 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728944AbfFMLaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 07:30:30 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F3F6B74A37F2BCD5298E;
        Thu, 13 Jun 2019 19:30:27 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Jun 2019
 19:30:19 +0800
Subject: Re: [PATCH v1 2/5] KVM: arm/arm64: Adjust entry/exit and trap related
 tracepoints
To:     James Morse <james.morse@arm.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <christoffer.dall@arm.com>, <marc.zyngier@arm.com>,
        <acme@redhat.com>, <peterz@infradead.org>, <mingo@redhat.com>,
        <ganapatrao.kulkarni@cavium.com>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <mark.rutland@arm.com>, <acme@kernel.org>,
        <alexander.shishkin@linux.intel.com>, <jolsa@redhat.com>,
        <namhyung@kernel.org>, <wanghaibin.wang@huawei.com>,
        <xiexiangyou@huawei.com>, <linuxarm@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-3-git-send-email-yuzenghui@huawei.com>
 <977f8f8c-72b4-0287-4b1c-47a0d6f1fd6e@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e78a9798-cce3-a360-37c3-0ad359944b85@huawei.com>
Date:   Thu, 13 Jun 2019 19:28:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <977f8f8c-72b4-0287-4b1c-47a0d6f1fd6e@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On 2019/6/12 20:49, James Morse wrote:
> Hi,
> 
> On 12/06/2019 10:08, Zenghui Yu wrote:
>> Currently, we use trace_kvm_exit() to report exception type (e.g.,
>> "IRQ", "TRAP") and exception class (ESR_ELx's bit[31:26]) together.
> 
> (They both caused an exit!)
> 
> 
>> But hardware only saves the exit class to ESR_ELx on synchronous
> 
> EC is the 'Exception Class'. Exit is KVM/Linux's terminology.
Yes, a stupid mistake ;-)

>> exceptions, not on asynchronous exceptions. When the guest exits
>> due to external interrupts, we will get tracing output like:
>>
>> 	"kvm_exit: IRQ: HSR_EC: 0x0000 (UNKNOWN), PC: 0xffff87259e30"
>>
>> Obviously, "HSR_EC" here is meaningless.
> 
> I assume we do it this way so there is only one guest-exit tracepoint that catches all exits.
> I don't think its a problem if user-space has to know the EC isn't set for asynchronous
> exceptions, this is a property of the architecture and anything using these trace-points
> is already arch specific.
Actually, *no* problem in current implementation, and I'm OK to still
keep the EC in trace_kvm_exit().  What I really want to do is adding the
EC in trace_trap_enter (the new tracepoint), will explain it later.

>> This patch splits "exit" and "trap" events by adding two tracepoints
>> explicitly in handle_trap_exceptions(). Let trace_kvm_exit() report VM
>> exit events, and trace_kvm_trap_exit() report VM trap events.
>>
>> These tracepoints are adjusted also in preparation for supporting
>> 'perf kvm stat' on arm64.
> 
> Because the existing tracepoints are ABI, I don't think we can change them.
> 
> We can add new ones if there is something that a user reasonably needs to trace, and can't
> be done any other way.
> 
> What can't 'perf kvm stat' do with the existing trace points?
(A good question! I should have made it clear in the commit message,
  forgive me.)

First, how does 'perf kvm stat' interact with tracepoints?

We have three handlers for a specific event (e.g., "VM-EXIT") --
"is_begin_event", "is_end_event", "decode_key". The first two handlers
make use of two existing tracepoints ("kvm:kvm_exit" & "kvm:kvm_entry")
to check when the VM-EXIT events started/ended, thus the time difference
stats, event start/end time etc. can be calculated.
"is_begin_event" handler gets a *key* from the "ret" field (exit_code)
of "kvm:kvm_exit" payload, and "decode_key" handler makes use of the
*key* to find out the reason for the VM-EXIT event. Of course we should
maintain the mapping between exit_code and exit_reason in userspace.
These are all what *patch #4* had done, #4 is a simple patch to review!
Oh, we can also set "vcpu_id_str" to achieve per vcpu event record, but
currently, we only have the "vcpu_pc" field in "kvm:kvm_entry", without
something like "vcpu_id".

perf people must have a much deeper understanding of this.


OK, next comes the more important question - what should/can we do to
the tracepoints in preparation of 'perf kvm stat' on arm64?

 From the article you've provided, it's clear that we can't remove the EC
from trace_kvm_exit(). But can we add something like "vcpu_id" into
(at least) trace_kvm_entry(), just like what this patch has done?
If not, which means we have to keep the existing tracepoints totally
unchanged, then 'perf kvm stat' will have no way to record/report per
vcpu VM-EXIT events (other arch like X86, powerpc, s390 etc. have this
capability, if I understand it correctly).

As for TRAP events, should we consider adding two new tracepoints --
"kvm_trap_enter" and "kvm_trap_exit", to keep tracking of the trap
handling process? We should also record the EC in "kvm_trap_enter", 
which will be used as *key* in TRAP event's "is_begin_event" handler.
Patch #5 tells us the whole story, it's simple too.

What do you suggest?

>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index 516aead..af3c732 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -264,7 +264,10 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   		exit_handle_fn exit_handler;
>>   
>>   		exit_handler = kvm_get_exit_handler(vcpu);
>> +		trace_kvm_trap_enter(vcpu->vcpu_id,
>> +				     kvm_vcpu_trap_get_class(vcpu));
>>   		handled = exit_handler(vcpu, run);
>> +		trace_kvm_trap_exit(vcpu->vcpu_id);
>>   	}
> 
> Why are there two? Are you using this to benchmark the exit_handler()?
Almostly yes. Let perf know when the TRAP handling event start/end,
and ...

> As we can't remove the EC from the exit event, I don't think this tells us anything new.
As explained above, this EC is for 'perf kvm stat'.

>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 90cedeb..9f63fd9 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -758,7 +758,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   		/**************************************************************
>>   		 * Enter the guest
>>   		 */
>> -		trace_kvm_entry(*vcpu_pc(vcpu));
>> +		trace_kvm_entry(vcpu->vcpu_id, *vcpu_pc(vcpu));
> 
> Why do you need the PC? It was exported on exit.
> (its mostly junk for user-space anyway, you can't infer anything from it)
(I mainly wanted to add the "vcpu->vcpu_id" here.)
It seems that we can't just remove the PC, which will cause ABI change?


Thanks for your reviewing!

zenghui


.

