Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC67990A3
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbfHVKXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:23:09 -0400
Received: from foss.arm.com ([217.140.110.172]:43166 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730918AbfHVKXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:23:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71380337;
        Thu, 22 Aug 2019 03:23:08 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41E723F246;
        Thu, 22 Aug 2019 03:23:06 -0700 (PDT)
Subject: Re: Can we boot a 512U kvm guest?
To:     Auger Eric <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        kvmarm@lists.cs.columbia.edu, qemu-arm@nongnu.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        suzuki.poulose@arm.com, peter.maydell@linaro.org,
        kvm@vger.kernel.org, "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        zhang.zhanghailiang@huawei.com
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
 <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
 <681f59e8-a193-6d3e-0bcc-5e52f4203868@redhat.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <dc78b8af-e761-dc87-982e-1885cfb98100@kernel.org>
Date:   Thu, 22 Aug 2019 11:23:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <681f59e8-a193-6d3e-0bcc-5e52f4203868@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/08/2019 10:50, Auger Eric wrote:
> Hi Marc,
> 
> On 8/22/19 11:29 AM, Marc Zyngier wrote:
>> Hi Eric,
>>
>> On 22/08/2019 10:08, Auger Eric wrote:
>>> Hi Zenghui,
>>>
>>> On 8/13/19 10:50 AM, Zenghui Yu wrote:
>>>> Hi folks,
>>>>
>>>> Since commit e25028c8ded0 ("KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to
>>>> 512"), we seemed to be allowed to boot a 512U guest.  But I failed to
>>>> start it up with the latest QEMU.  I guess there are at least *two*
>>>> reasons (limitations).
>>>>
>>>> First I got a QEMU abort:
>>>>     "kvm_set_irq: Invalid argument"
>>>>
>>>> Enable the trace_kvm_irq_line() under debugfs, when it comed with
>>>> vcpu-256, I got:
>>>>     "Inject UNKNOWN interrupt (3), vcpu->idx: 0, num: 23, level: 0"
>>>> and kvm_vm_ioctl_irq_line() returns -EINVAL to user-space...
>>>>
>>>> So the thing is that we only have 8 bits for vcpu_index field ([23:16])
>>>> in KVM_IRQ_LINE ioctl.  irq_type field will be corrupted if we inject a
>>>> PPI to vcpu-256, whose vcpu_index will take 9 bits.
>>>>
>>>> I temporarily patched the KVM and QEMU with the following diff:
>>>>
>>>> ---8<---
>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>>> b/arch/arm64/include/uapi/asm/kvm.h
>>>> index 95516a4..39a0fb1 100644
>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>> @@ -325,10 +325,10 @@ struct kvm_vcpu_events {
>>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER        1
>>>>
>>>>  /* KVM_IRQ_LINE irq field index values */
>>>> -#define KVM_ARM_IRQ_TYPE_SHIFT        24
>>>> -#define KVM_ARM_IRQ_TYPE_MASK        0xff
>>>> +#define KVM_ARM_IRQ_TYPE_SHIFT        28
>>>> +#define KVM_ARM_IRQ_TYPE_MASK        0xf
>>>>  #define KVM_ARM_IRQ_VCPU_SHIFT        16
>>>> -#define KVM_ARM_IRQ_VCPU_MASK        0xff
>>>> +#define KVM_ARM_IRQ_VCPU_MASK        0xfff
>>>>  #define KVM_ARM_IRQ_NUM_SHIFT        0
>>>>  #define KVM_ARM_IRQ_NUM_MASK        0xffff
>>>>
>>>> ---8<---
>>>>
>>>> It makes things a bit better, it also immediately BREAKs the api with
>>>> old versions.
>>>>
>>>>
>>>> Next comes one more QEMU abort (with the "fix" above):
>>>>     "Failed to set device address: No space left on device"
>>>>
>>>> We register two io devices (rd_dev and sgi_dev) on KVM_MMIO_BUS for
>>>> each redistributor. 512 vcpus take 1024 io devices, which is beyond the
>>>> maximum limitation of the current kernel - NR_IOBUS_DEVS (1000).
>>>> So we get a ENOSPC error here.
>>>
>>> Do you plan to send a patch for increasing the NR_IOBUS_DEVS? Otherwise
>>> I can do it.
>>
>> I really wonder whether that's a sensible thing to do on its own.
>>
>> Looking at the implementation of kvm_io_bus_register_dev (which copies
>> the whole array each time we insert a device), we have an obvious issue
>> with systems that create a large number of device structures, leading to
>> large transient memory usage and slow guest start.
>>
>> We could also try and reduce the number of devices we insert by making
>> the redistributor a single device (which it is in reality). It probably
>> means we need to make the MMIO decoding more flexible.
> 
> Yes it makes sense. If no objection, I can work on this as I am the
> source of the mess ;-)

Sure, if you have some spare bandwidth, feel free to give it a go. I'd
certainly like to see the userspace counterpart to my earlier patch, and
some agreement on the ABI change.

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
