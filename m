Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807EA98FFD
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 11:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbfHVJub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 05:50:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbfHVJub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 05:50:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A5733DE02;
        Thu, 22 Aug 2019 09:50:30 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63748600CD;
        Thu, 22 Aug 2019 09:50:26 +0000 (UTC)
Subject: Re: Can we boot a 512U kvm guest?
To:     Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
        kvmarm@lists.cs.columbia.edu, qemu-arm@nongnu.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        suzuki.poulose@arm.com, peter.maydell@linaro.org,
        kvm@vger.kernel.org, "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        zhang.zhanghailiang@huawei.com
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
 <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <681f59e8-a193-6d3e-0bcc-5e52f4203868@redhat.com>
Date:   Thu, 22 Aug 2019 11:50:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 22 Aug 2019 09:50:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/22/19 11:29 AM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 22/08/2019 10:08, Auger Eric wrote:
>> Hi Zenghui,
>>
>> On 8/13/19 10:50 AM, Zenghui Yu wrote:
>>> Hi folks,
>>>
>>> Since commit e25028c8ded0 ("KVM: arm/arm64: Bump VGIC_V3_MAX_CPUS to
>>> 512"), we seemed to be allowed to boot a 512U guest.  But I failed to
>>> start it up with the latest QEMU.  I guess there are at least *two*
>>> reasons (limitations).
>>>
>>> First I got a QEMU abort:
>>>     "kvm_set_irq: Invalid argument"
>>>
>>> Enable the trace_kvm_irq_line() under debugfs, when it comed with
>>> vcpu-256, I got:
>>>     "Inject UNKNOWN interrupt (3), vcpu->idx: 0, num: 23, level: 0"
>>> and kvm_vm_ioctl_irq_line() returns -EINVAL to user-space...
>>>
>>> So the thing is that we only have 8 bits for vcpu_index field ([23:16])
>>> in KVM_IRQ_LINE ioctl.  irq_type field will be corrupted if we inject a
>>> PPI to vcpu-256, whose vcpu_index will take 9 bits.
>>>
>>> I temporarily patched the KVM and QEMU with the following diff:
>>>
>>> ---8<---
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>>> b/arch/arm64/include/uapi/asm/kvm.h
>>> index 95516a4..39a0fb1 100644
>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>> @@ -325,10 +325,10 @@ struct kvm_vcpu_events {
>>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER        1
>>>
>>>  /* KVM_IRQ_LINE irq field index values */
>>> -#define KVM_ARM_IRQ_TYPE_SHIFT        24
>>> -#define KVM_ARM_IRQ_TYPE_MASK        0xff
>>> +#define KVM_ARM_IRQ_TYPE_SHIFT        28
>>> +#define KVM_ARM_IRQ_TYPE_MASK        0xf
>>>  #define KVM_ARM_IRQ_VCPU_SHIFT        16
>>> -#define KVM_ARM_IRQ_VCPU_MASK        0xff
>>> +#define KVM_ARM_IRQ_VCPU_MASK        0xfff
>>>  #define KVM_ARM_IRQ_NUM_SHIFT        0
>>>  #define KVM_ARM_IRQ_NUM_MASK        0xffff
>>>
>>> ---8<---
>>>
>>> It makes things a bit better, it also immediately BREAKs the api with
>>> old versions.
>>>
>>>
>>> Next comes one more QEMU abort (with the "fix" above):
>>>     "Failed to set device address: No space left on device"
>>>
>>> We register two io devices (rd_dev and sgi_dev) on KVM_MMIO_BUS for
>>> each redistributor. 512 vcpus take 1024 io devices, which is beyond the
>>> maximum limitation of the current kernel - NR_IOBUS_DEVS (1000).
>>> So we get a ENOSPC error here.
>>
>> Do you plan to send a patch for increasing the NR_IOBUS_DEVS? Otherwise
>> I can do it.
> 
> I really wonder whether that's a sensible thing to do on its own.
> 
> Looking at the implementation of kvm_io_bus_register_dev (which copies
> the whole array each time we insert a device), we have an obvious issue
> with systems that create a large number of device structures, leading to
> large transient memory usage and slow guest start.
> 
> We could also try and reduce the number of devices we insert by making
> the redistributor a single device (which it is in reality). It probably
> means we need to make the MMIO decoding more flexible.

Yes it makes sense. If no objection, I can work on this as I am the
source of the mess ;-)

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
