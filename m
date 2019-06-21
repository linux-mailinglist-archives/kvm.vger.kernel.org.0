Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2AF4E91E
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUN15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:27:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18659 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbfFUN15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:27:57 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6E11239D1491C775AFA3;
        Fri, 21 Jun 2019 21:27:50 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Jun 2019
 21:27:44 +0800
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
 <e78a9798-cce3-a360-37c3-0ad359944b85@huawei.com>
 <4d16d690-e93b-7b89-3251-aa4bd8489715@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <34bcb641-9815-cda7-69e0-98ed477e84a6@huawei.com>
Date:   Fri, 21 Jun 2019 21:25:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <4d16d690-e93b-7b89-3251-aa4bd8489715@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

sorry for the late reply.

On 2019/6/17 19:19, James Morse wrote:
> Hi Zenghui,
> 
> On 13/06/2019 12:28, Zenghui Yu wrote:
>> On 2019/6/12 20:49, James Morse wrote:
>>> On 12/06/2019 10:08, Zenghui Yu wrote:
>>>> Currently, we use trace_kvm_exit() to report exception type (e.g.,
>>>> "IRQ", "TRAP") and exception class (ESR_ELx's bit[31:26]) together.
>>>> But hardware only saves the exit class to ESR_ELx on synchronous
>>>> exceptions, not on asynchronous exceptions. When the guest exits
>>>> due to external interrupts, we will get tracing output like:
>>>>
>>>>      "kvm_exit: IRQ: HSR_EC: 0x0000 (UNKNOWN), PC: 0xffff87259e30"
>>>>
>>>> Obviously, "HSR_EC" here is meaningless.
> 
>>> I assume we do it this way so there is only one guest-exit tracepoint that catches all
>>> exits.
>>> I don't think its a problem if user-space has to know the EC isn't set for asynchronous
>>> exceptions, this is a property of the architecture and anything using these trace-points
>>> is already arch specific.
> 
>> Actually, *no* problem in current implementation, and I'm OK to still
>> keep the EC in trace_kvm_exit().  What I really want to do is adding the
>> EC in trace_trap_enter (the new tracepoint), will explain it later.
> 
> 
>>>> This patch splits "exit" and "trap" events by adding two tracepoints
>>>> explicitly in handle_trap_exceptions(). Let trace_kvm_exit() report VM
>>>> exit events, and trace_kvm_trap_exit() report VM trap events.
>>>>
>>>> These tracepoints are adjusted also in preparation for supporting
>>>> 'perf kvm stat' on arm64.
>>>
>>> Because the existing tracepoints are ABI, I don't think we can change them.
>>>
>>> We can add new ones if there is something that a user reasonably needs to trace, and can't
>>> be done any other way.
>>>
>>> What can't 'perf kvm stat' do with the existing trace points?
> 
>> First, how does 'perf kvm stat' interact with tracepoints?
> 
> Start at the beginning, good idea. (I've never used this thing!)
> 
> 
>> We have three handlers for a specific event (e.g., "VM-EXIT") --
>> "is_begin_event", "is_end_event", "decode_key". The first two handlers
>> make use of two existing tracepoints ("kvm:kvm_exit" & "kvm:kvm_entry")
>> to check when the VM-EXIT events started/ended, thus the time difference
>> stats, event start/end time etc. can be calculated.
> 
>> "is_begin_event" handler gets a *key* from the "ret" field (exit_code)
>> of "kvm:kvm_exit" payload, and "decode_key" handler makes use of the
>> *key* to find out the reason for the VM-EXIT event. Of course we should
>> maintain the mapping between exit_code and exit_reason in userspace.
> 
> Interpreting 'ret' is going to get tricky if we change those values on a whim. Its
> internal to the KVM arch code.

Yes. We have to keep the definition of 'ret' and the mapping
(kvm_arm_exception_type) consistent between user side and kernel side.
Specifically,
kernel side: arch/arm64/include/asm/kvm_asm.h
user side:   tools/perf/arch/arm64/util/aarch64_guest_exits.h (patch #4)

Do we have a better approach?

>> These are all what *patch #4* had done, #4 is a simple patch to review!
> 
>> Oh, we can also set "vcpu_id_str" to achieve per vcpu event record, but
>> currently, we only have the "vcpu_pc" field in "kvm:kvm_entry", without
>> something like "vcpu_id".
> 
> Heh, so from the trace-point data, you can't know which on is vcpu-0 and which is vcpu-1.

Yes!

>> OK, next comes the more important question - what should/can we do to
>> the tracepoints in preparation of 'perf kvm stat' on arm64?
>>
>>  From the article you've provided, it's clear that we can't remove the EC
>> from trace_kvm_exit(). But can we add something like "vcpu_id" into
>> (at least) trace_kvm_entry(), just like what this patch has done?
> 
> Adding something is still likely to break a badly written user-space that is trying to
> parse the trace information. A regex picking out the last argument will now get a
> different value.
> 
> 
>> If not, which means we have to keep the existing tracepoints totally
>> unchanged, then 'perf kvm stat' will have no way to record/report per
>> vcpu VM-EXIT events (other arch like X86, powerpc, s390 etc. have this
>> capability, if I understand it correctly).
> 
> Well, you get the events, but you don't know which vCPU is which. You can map this back to
> the pid of the host thread assuming user-space isn't moving vcpu between host threads.
> 
> If we're really stuck: Adding tracepoints to KVM-core's vcpu get/put, that export the
> vcpu_id would let you map pid->vcpu_id, which you can then use for the batch of enter/exit
> events that come before a final vcpu put.
> grepping "vpu_id" shows perf has a mapping for which arch-specific argument in enter/exit
> is the vcpu-id. Done with this core-code mapping, you could drop that code...

Yes. In the current 'perf kvm' implementation, we make use of the
"vcpu id" field (specified by vcpu_id_str, differ between arch) of
"kvm:kvm_entry" tracepoint payload, to achieve per vcpu record/report.
(Details in per_vcpu_record() in tools/perf/builtin-kvm.c)

Adding tracepoints in vcpu_load()/vcpu_put() might be a good idea, we
can get "vcpu id" information without breaking existing tracepoint ABI.
And I think other arch will benefit from this way, for those who haven't
supported 'perf kvm stat' yet and don't have "vcpu id" info in the
"kvm:kvm_entry" tracepoint.

But there is at least one problem (as I can see)... KVM will not always
do a vcpu_load()/vcpu_put(), while guest always enters/exits.
In the worst case, if KVM can always handle guest's exits, perf will not
have a chance to catch vcpu_load()/vcpu_put(). And still, we fail to get
per vcpu statistical analysis.

I've written a simple patch to prove this, attached at the end of this
mail. I run 'perf kvm stat record/report' against a 4-VCPU guest, but
only vcpu-3 will be reported, as only vcpu-3 is doing some MMIO access
and we have to return to user space (and vcpu_load() will be invoked).

I'm not sure if I (likely) missed some important points you've provided.

> But I'd be a little nervous adding a new trace-point to work around an ABI problem, as we
> may have just moved the ABI problem! (What does a user of a vcpu_put tracepoint really need?)
> 
> 
>> As for TRAP events, should we consider adding two new tracepoints --
>> "kvm_trap_enter" and "kvm_trap_exit", to keep tracking of the trap
>> handling process? We should also record the EC in "kvm_trap_enter", which will be used as
>> *key* in TRAP event's "is_begin_event" handler.
> 
> The EC can't change between trace_kvm_exit() and handle_exit(), so you already have this.
> 
> What are the 'trap' trace points needed for? You get the timing and 'exception class' from
> the guest enter/exit tracepoints. What about handle_exit() can't you work out from this?

In short, these two trap tracepoints are for patch #5.
Some users (me) may want to know, how many traps a guest has in a given
period of time, how many times a particular type of trap (e.g., Dabort)
has occurred, and how long each trap has been processed. That's what
patch #5 does, you can get these info through 'perf kvm stat report
--event=trap'.

If we use guest enter/exit tracepoints to support TRAP events, there
will be two problems:
   1) the timing becomes inaccurate (longer than the real timing)
   2) the reported 'EC' becomes "Unknown" in the case when guest exits
      due to IRQ, as we set 'esr_ec' to 0 on asynchronous exceptions,
      in trace_kvm_exit.

>> Patch #5 tells us the whole story, it's simple too.
> 
> (I only skimmed the perf patches, I'll go back now that I know a little more about what
> you're doing)

Much appreciated :)

>> What do you suggest?
> 
> We can explore the vcpu_load()/vcpu_put() trace idea, (it may not work for some other
> reason). I'd like to understand what the 'trap' tracepoints are needed for.

Thanks for your suggestion!


Btw, I have collected some useful links, attached here, to share with
someone who're interested in this series.

[1] the initial idea for 'perf kvm stat':
https://events.static.linuxfound.org/images/stories/pdf/lcjp2012_guangrong.pdf
[2] a discussion on improving kvm_exit tracepoint:
https://patchwork.kernel.org/patch/7097311/


Thanks,
zenghui



---8<---

Two tracepoints have already been added in vcpu_load/put().

---
  tools/perf/arch/arm64/util/kvm-stat.c | 2 ++
  tools/perf/builtin-kvm.c              | 7 ++++++-
  2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/arm64/util/kvm-stat.c 
b/tools/perf/arch/arm64/util/kvm-stat.c
index 41b28de..a91fe7d 100644
--- a/tools/perf/arch/arm64/util/kvm-stat.c
+++ b/tools/perf/arch/arm64/util/kvm-stat.c
@@ -103,6 +103,8 @@ static void trap_event_decode_key(struct 
perf_kvm_stat *kvm __maybe_unused,
  	"kvm:kvm_exit",
  	"kvm:kvm_trap_enter",
  	"kvm:kvm_trap_exit",
+	"kvm:vcpu_load",
+	"kvm:vcpu_put",
  	NULL,
  };

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index dbb6f73..f011fcf 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -81,6 +81,11 @@ bool exit_event_begin(struct perf_evsel *evsel,
  	return false;
  }

+static bool kvm_vcpu_load_event(struct perf_evsel *evsel)
+{
+	return !strcmp(evsel->name, "kvm:vcpu_load");
+}
+
  bool kvm_entry_event(struct perf_evsel *evsel)
  {
  	return !strcmp(evsel->name, kvm_entry_trace);
@@ -400,7 +405,7 @@ struct vcpu_event_record *per_vcpu_record(struct 
thread *thread,
  					  struct perf_sample *sample)
  {
  	/* Only kvm_entry records vcpu id. */
-	if (!thread__priv(thread) && kvm_entry_event(evsel)) {
+	if (!thread__priv(thread) && kvm_vcpu_load_event(evsel)) {
  		struct vcpu_event_record *vcpu_record;

  		vcpu_record = zalloc(sizeof(*vcpu_record));
-- 

