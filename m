Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA6814074B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 11:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgAQKEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 05:04:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbgAQKEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 05:04:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EFDA36E91CCDC5E96B4D;
        Fri, 17 Jan 2020 18:04:49 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 18:04:42 +0800
Subject: Re: [PATCH v22 8/9] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        James Morse <james.morse@arm.com>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-9-git-send-email-gengdongjiu@huawei.com>
 <CAFEAcA_=PgkrWjwPxD89fCi85XPpcTHssXkSmE04Ctoj7AX0kA@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <c89db331-cb94-8e0b-edf8-25bfb64f826d@huawei.com>
Date:   Fri, 17 Jan 2020 18:04:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_=PgkrWjwPxD89fCi85XPpcTHssXkSmE04Ctoj7AX0kA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/1/17 0:28, Peter Maydell wrote:
> On Wed, 8 Jan 2020 at 11:33, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
>> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>> +{
>> +    ram_addr_t ram_addr;
>> +    hwaddr paddr;
>> +
>> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>> +
>> +    if (acpi_enabled && addr &&
>> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
>> +        ram_addr = qemu_ram_addr_from_host(addr);
>> +        if (ram_addr != RAM_ADDR_INVALID &&
>> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
>> +            kvm_hwpoison_page_add(ram_addr);
>> +            /*
>> +             * Asynchronous signal will be masked by main thread, so
>> +             * only handle synchronous signal.
>> +             */
> 
> I don't understand this comment. (I think we've had discussions
> about it before, but it's still not clear to me.)
> 
> This function (kvm_arch_on_sigbus_vcpu()) will be called in two contexts:
> 
> (1) in the vcpu thread:
>   * the real SIGBUS handler sigbus_handler() sets a flag and arranges
>     for an immediate vcpu exit
>   * the vcpu thread reads the flag on exit from KVM_RUN and
>     calls kvm_arch_on_sigbus_vcpu() directly
>   * the error could be MCEERR_AR or MCEERR_AOFor the vcpu thread, the error can be MCEERR_AR or MCEERR_AO,
but kernel/KVM usually uses MCEERR_AR(action required) instead of MCEERR_AO, because it needs do action immediately. For MCEERR_AO error, the action is optional and the error can be ignored.
At least I do not find Linux kernel/KVM deliver MCEERR_AO in the vcpu threads.

> (2) MCE errors on other threads:
>   * here SIGBUS is blocked, so MCEERR_AR (action-required)
>     errors will cause the kernel to just kill the QEMU process
>   * MCEERR_AO errors will be handled via the iothread's use
>     of signalfd(), so kvm_on_sigbus() will get called from
>     the main thread, and it will call kvm_arch_on_sigbus_vcpu()
>   * in this case the passed in CPUState will (arbitrarily) be that
>     for the first vCPU

For the MCE errors on other threads, it can only handle MCEERR_AO. If it is MCEERR_AR, the QEMU will assert and exit[2].

Case1: Other APP indeed can send MCEERR_AO to QEMU， QEMU handle it via the iothread's use of signalfd() through above path.
Case2: But if the MCEERR_AO is delivered by kernel, I see QEMU ignore it because SIGBUS is masked in main thread[3], for this case, I do not see QEMU handle it via signalfd() for MCEERR_AO errors from my test.

For Case1，I think we should not let guest know it, because it is not triggered by guest. only other APP send SIGBUS to tell QEMU do somethings.
For Case2，it does not call call kvm_arch_on_sigbus_vcpu().


[1]:
/* Called synchronously (via signalfd) in main thread.  */
int kvm_on_sigbus(int code, void *addr)
{
#ifdef KVM_HAVE_MCE_INJECTION
    /* Action required MCE kills the process if SIGBUS is blocked.  Because
     * that's what happens in the I/O thread, where we handle MCE via signalfd,
     * we can only get action optional here.
     */
[2]: assert(code != BUS_MCEERR_AR);
    kvm_arch_on_sigbus_vcpu(first_cpu, code, addr);
    return 0;
#else
    return 1;
#endif
}

[3]: https://lists.gnu.org/archive/html/qemu-devel/2017-11/msg03575.html


> 
> For MCEERR_AR, the code here looks correct -- we know this is
> only going to happen for the relevant vCPU so we can go ahead
> and do the "record it in the ACPI table and tell the guest" bit.
> 
> But shouldn't we be doing something with the MCEERR_AO too?

Above all, from my test, for MCEERR_AO error which is triggered by guest, it not call kvm_arch_on_sigbus_vcpu().
so I think currently we can just report error. If afterwards  MCEERR_AO error can call kvm_arch_on_sigbus_vcpu(), we can let the guest know about it.

> That of course will be trickier because we're not necessarily
> in the vcpu thread, but it would be nice to let the guest
> know about it.
> 
> One comment that would work with the current code would be:
> 
> /*
>  * If this is a BUS_MCEERR_AR, we know we have been called
>  * synchronously from the vCPU thread, so we can easily
>  * synchronize the state and inject an error.
>  *
>  * TODO: we currently don't tell the guest at all about BUS_MCEERR_AO.
>  * In that case we might either be being called synchronously from
>  * the vCPU thread, or a bit later from the main thread, so doing
At least I do not find Linux kernel/KVM deliver MCEERR_AO in the vcpu threads.
In the main thread, signalfd() is not called when it is BUS_MCEERR_AO which is triggered by guest.

>  * the injection of the error would be more complicated.
>  */
> 
> but I don't know if that's what you meant to say/implement...
we can implement MCEERR_AO logic when QEMU can receive MCEERR_AO error which is triggered by guest.

> 
>> +            if (code == BUS_MCEERR_AR) {
>> +                kvm_cpu_synchronize_state(c);
>> +                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
>> +                    kvm_inject_arm_sea(c);
>> +                } else {
>> +                    error_report("failed to record the error");
>> +                    abort();
>> +                }
>> +            }
>> +            return;
>> +        }
>> +        if (code == BUS_MCEERR_AO) {
>> +            error_report("Hardware memory error at addr %p for memory used by "
>> +                "QEMU itself instead of guest system!", addr);
>> +        }
>> +    }
>> +
>> +    if (code == BUS_MCEERR_AR) {
>> +        error_report("Hardware memory error!");
>> +        exit(1);
>> +    }
>> +}
>>
> 
> thanks
> -- PMM
> .
> 

