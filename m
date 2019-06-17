Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4D848080
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfFQLTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:19:37 -0400
Received: from foss.arm.com ([217.140.110.172]:45944 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbfFQLTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:19:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0179344;
        Mon, 17 Jun 2019 04:19:35 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78CB23F246;
        Mon, 17 Jun 2019 04:21:18 -0700 (PDT)
Subject: Re: [PATCH v1 2/5] KVM: arm/arm64: Adjust entry/exit and trap related
 tracepoints
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, christoffer.dall@arm.com,
        marc.zyngier@arm.com, acme@redhat.com, peterz@infradead.org,
        mingo@redhat.com, ganapatrao.kulkarni@cavium.com,
        catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com,
        acme@kernel.org, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, wanghaibin.wang@huawei.com,
        xiexiangyou@huawei.com, linuxarm@huawei.com
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
 <1560330526-15468-3-git-send-email-yuzenghui@huawei.com>
 <977f8f8c-72b4-0287-4b1c-47a0d6f1fd6e@arm.com>
 <e78a9798-cce3-a360-37c3-0ad359944b85@huawei.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <4d16d690-e93b-7b89-3251-aa4bd8489715@arm.com>
Date:   Mon, 17 Jun 2019 12:19:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e78a9798-cce3-a360-37c3-0ad359944b85@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 13/06/2019 12:28, Zenghui Yu wrote:
> On 2019/6/12 20:49, James Morse wrote:
>> On 12/06/2019 10:08, Zenghui Yu wrote:
>>> Currently, we use trace_kvm_exit() to report exception type (e.g.,
>>> "IRQ", "TRAP") and exception class (ESR_ELx's bit[31:26]) together.
>>> But hardware only saves the exit class to ESR_ELx on synchronous
>>> exceptions, not on asynchronous exceptions. When the guest exits
>>> due to external interrupts, we will get tracing output like:
>>>
>>>     "kvm_exit: IRQ: HSR_EC: 0x0000 (UNKNOWN), PC: 0xffff87259e30"
>>>
>>> Obviously, "HSR_EC" here is meaningless.

>> I assume we do it this way so there is only one guest-exit tracepoint that catches all
>> exits.
>> I don't think its a problem if user-space has to know the EC isn't set for asynchronous
>> exceptions, this is a property of the architecture and anything using these trace-points
>> is already arch specific.

> Actually, *no* problem in current implementation, and I'm OK to still
> keep the EC in trace_kvm_exit().  What I really want to do is adding the
> EC in trace_trap_enter (the new tracepoint), will explain it later.


>>> This patch splits "exit" and "trap" events by adding two tracepoints
>>> explicitly in handle_trap_exceptions(). Let trace_kvm_exit() report VM
>>> exit events, and trace_kvm_trap_exit() report VM trap events.
>>>
>>> These tracepoints are adjusted also in preparation for supporting
>>> 'perf kvm stat' on arm64.
>>
>> Because the existing tracepoints are ABI, I don't think we can change them.
>>
>> We can add new ones if there is something that a user reasonably needs to trace, and can't
>> be done any other way.
>>
>> What can't 'perf kvm stat' do with the existing trace points?

> First, how does 'perf kvm stat' interact with tracepoints?

Start at the beginning, good idea. (I've never used this thing!)


> We have three handlers for a specific event (e.g., "VM-EXIT") --
> "is_begin_event", "is_end_event", "decode_key". The first two handlers
> make use of two existing tracepoints ("kvm:kvm_exit" & "kvm:kvm_entry")
> to check when the VM-EXIT events started/ended, thus the time difference
> stats, event start/end time etc. can be calculated.

> "is_begin_event" handler gets a *key* from the "ret" field (exit_code)
> of "kvm:kvm_exit" payload, and "decode_key" handler makes use of the
> *key* to find out the reason for the VM-EXIT event. Of course we should
> maintain the mapping between exit_code and exit_reason in userspace.

Interpreting 'ret' is going to get tricky if we change those values on a whim. Its
internal to the KVM arch code.


> These are all what *patch #4* had done, #4 is a simple patch to review!

> Oh, we can also set "vcpu_id_str" to achieve per vcpu event record, but
> currently, we only have the "vcpu_pc" field in "kvm:kvm_entry", without
> something like "vcpu_id".

Heh, so from the trace-point data, you can't know which on is vcpu-0 and which is vcpu-1.


> OK, next comes the more important question - what should/can we do to
> the tracepoints in preparation of 'perf kvm stat' on arm64?
> 
> From the article you've provided, it's clear that we can't remove the EC
> from trace_kvm_exit(). But can we add something like "vcpu_id" into
> (at least) trace_kvm_entry(), just like what this patch has done?

Adding something is still likely to break a badly written user-space that is trying to
parse the trace information. A regex picking out the last argument will now get a
different value.


> If not, which means we have to keep the existing tracepoints totally
> unchanged, then 'perf kvm stat' will have no way to record/report per
> vcpu VM-EXIT events (other arch like X86, powerpc, s390 etc. have this
> capability, if I understand it correctly).

Well, you get the events, but you don't know which vCPU is which. You can map this back to
the pid of the host thread assuming user-space isn't moving vcpu between host threads.

If we're really stuck: Adding tracepoints to KVM-core's vcpu get/put, that export the
vcpu_id would let you map pid->vcpu_id, which you can then use for the batch of enter/exit
events that come before a final vcpu put.
grepping "vpu_id" shows perf has a mapping for which arch-specific argument in enter/exit
is the vcpu-id. Done with this core-code mapping, you could drop that code...

But I'd be a little nervous adding a new trace-point to work around an ABI problem, as we
may have just moved the ABI problem! (What does a user of a vcpu_put tracepoint really need?)


> As for TRAP events, should we consider adding two new tracepoints --
> "kvm_trap_enter" and "kvm_trap_exit", to keep tracking of the trap
> handling process? We should also record the EC in "kvm_trap_enter", which will be used as
> *key* in TRAP event's "is_begin_event" handler.

The EC can't change between trace_kvm_exit() and handle_exit(), so you already have this.

What are the 'trap' trace points needed for? You get the timing and 'exception class' from
the guest enter/exit tracepoints. What about handle_exit() can't you work out from this?


> Patch #5 tells us the whole story, it's simple too.

(I only skimmed the perf patches, I'll go back now that I know a little more about what
you're doing)


> What do you suggest?

We can explore the vcpu_load()/vcpu_put() trace idea, (it may not work for some other
reason). I'd like to understand what the 'trap' tracepoints are needed for.


Thanks,

James
