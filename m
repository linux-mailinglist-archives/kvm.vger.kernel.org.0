Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063841074AA
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 16:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKVPPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 10:15:33 -0500
Received: from foss.arm.com ([217.140.110.172]:48796 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfKVPPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 10:15:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A900ADA7;
        Fri, 22 Nov 2019 07:15:32 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3645C3F703;
        Fri, 22 Nov 2019 07:15:32 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] runtime: set MAX_SMP to number of online
 cpus
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20191120141928.6849-1-drjones@redhat.com>
 <86280ced-214f-eb0f-0662-0854e5c57991@arm.com>
 <20191122111917.fzdrdjkbm2w3reph@kamzik.brq.redhat.com>
 <03b0c1e1-c7d6-66e2-e338-f6812c367791@arm.com>
 <20191122145757.d2qupmdewipajxnn@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9511df62-74cc-b2f4-dbda-f918f8b46a52@arm.com>
Date:   Fri, 22 Nov 2019 15:15:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122145757.d2qupmdewipajxnn@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/22/19 2:57 PM, Andrew Jones wrote:
> On Fri, Nov 22, 2019 at 11:35:33AM +0000, Alexandru Elisei wrote:
>> Hi,
>>
>> On 11/22/19 11:19 AM, Andrew Jones wrote:
>>> On Fri, Nov 22, 2019 at 10:45:08AM +0000, Alexandru Elisei wrote:
>>>> Hi,
>>>>
>>>> On 11/20/19 2:19 PM, Andrew Jones wrote:
>>>>> We can only use online cpus, so make sure we check specifically for
>>>>> those.
>>>>>
>>>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>>>> ---
>>>>>  scripts/runtime.bash | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
>>>>> index 200d5b67290c..fbad0bd05fc5 100644
>>>>> --- a/scripts/runtime.bash
>>>>> +++ b/scripts/runtime.bash
>>>>> @@ -1,5 +1,5 @@
>>>>>  : "${RUNTIME_arch_run?}"
>>>>> -: ${MAX_SMP:=$(getconf _NPROCESSORS_CONF)}
>>>>> +: ${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}
>>>> I tested it on my machine by offlining a CPU and calling getconf _NPROCESSORS_CONF
>>>> (returned 32) and getconf _NPROCESSORS_ONLN (returned 31). man 3 sysconf also
>>>> agrees with your patch.
>>>>
>>>> I am wondering though, if _NPROCESSORS_CONF is 8 and _NPROCESSORS_ONLN is 1
>>>> (meaning that 7 CPUs were offlined), that means that qemu will create 8 VCPUs
>>>> which will share the same physical CPU. Is that undesirable?
>>> With KVM enabled that's not recommended. KVM_CAP_NR_VCPUS returns the
>>> number of online VCPUs (at least for arm). Since the guest code may not
>>> run as expected with overcommitted VCPUs we don't usually want to test
>> Can you give more details about what may go wrong if several kvm-unit-tests VCPUs
>> run on the same physical CPU? I was thinking that maybe we want to run the VCPUs
>> in parallel (each on its own physical CPU) to detect races in KVM, not because of
>> a limitation in kvm-unit-tests.
> There's no specific limitation in kvm-unit-tests. All guest kernels are at
> risk of behaving strangely with overcommitted VCPUs.
>
> A made-up example could be that a guest kernel thread T1 needs to wait for
> another thread T2. T1 may choose not to yield because T2 appears to be
> running on another CPU. But it isn't, because both T1's VCPU and T2's VCPU
> are running on the same PCPU. In general, telling a guest kernel it can
> run threads in parallel may cause it to make decisions that won't work
> well when executed serially.
>
> In kvm-unit-tests, where we can know that we're overcommitted in certain
> test cases, we can actually write tests that will still behave
> predictably. Knowing the test runs fine with overcommitted VCPUs will
> allow us to check if KVM does as well.

Makes sense, thank you for the explanation. For the patch:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
> Thanks,
> drew
>
>> Thanks,
>> Alex
>>> that way. OTOH, maybe we should write a test or two that does run with
>>> overcommitted VCPUs in order to look for bugs in KVM.
>>>
>>> Thanks,
>>> drew
>>>> Thanks,
>>>> Alex
>>>>>  : ${TIMEOUT:=90s}
>>>>>  
>>>>>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
