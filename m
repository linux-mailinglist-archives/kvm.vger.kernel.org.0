Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED103B1E77
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFWQTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:19:54 -0400
Received: from foss.arm.com ([217.140.110.172]:37314 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWQTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:19:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CACA31B;
        Wed, 23 Jun 2021 09:17:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A2C93F718;
        Wed, 23 Jun 2021 09:17:34 -0700 (PDT)
Subject: Re: [PATCH v4 0/9] KVM: arm64: Initial host support for the Apple M1
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
References: <20210601104005.81332-1-maz@kernel.org>
 <9bc0923c-5c3b-eeac-86ee-c3234c486955@arm.com> <871r8tdhjq.wl-maz@kernel.org>
 <df8163a0-3c2e-afc5-2f98-e804934c864c@arm.com> <87v965c1bl.wl-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <eb5438b6-1f98-1b22-8174-e65feb319e53@arm.com>
Date:   Wed, 23 Jun 2021 17:18:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87v965c1bl.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/22/21 5:26 PM, Marc Zyngier wrote:
> On Tue, 22 Jun 2021 17:03:22 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 6/22/21 4:51 PM, Marc Zyngier wrote:
>>> Hi Alex,
>>>
>>> On Tue, 22 Jun 2021 16:39:11 +0100,
>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>> Hi Marc,
>>>>
>>>> On 6/1/21 11:39 AM, Marc Zyngier wrote:
>>>>> This is a new version of the series previously posted at [3], reworking
>>>>> the vGIC and timer code to cope with the M1 braindead^Wamusing nature.
>>>>>
>>>>> Hardly any change this time around, mostly rebased on top of upstream
>>>>> now that the dependencies have made it in.
>>>>>
>>>>> Tested with multiple concurrent VMs running from an initramfs.
>>>>>
>>>>> Until someone shouts loudly now, I'll take this into 5.14 (and in
>>>>> -next from tomorrow).
>>>> I am not familiar with irqdomains or with the irqchip
>>>> infrastructure, so I can't really comment on patch #8.
>>>>
>>>> I tried testing this with a GICv3 by modifying the driver to set
>>>> no_hw_deactivation and no_maint_irq_mask:
>>>>
>>>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>>>> index 340c51d87677..d0c6f808d7f4 100644
>>>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>>>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>>>> @@ -565,8 +565,10 @@ int kvm_vgic_hyp_init(void)
>>>>         if (ret)
>>>>                 return ret;
>>>>  
>>>> +       /*
>>>>         if (!has_mask)
>>>>                 return 0;
>>>> +               */
>>>>  
>>>>         ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
>>>>                                  vgic_maintenance_handler,
>>>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>>>> index 453fc425eede..9ce4dee20655 100644
>>>> --- a/drivers/irqchip/irq-gic-v3.c
>>>> +++ b/drivers/irqchip/irq-gic-v3.c
>>>> @@ -1850,6 +1850,12 @@ static void __init gic_of_setup_kvm_info(struct device_node
>>>> *node)
>>>>         if (!ret)
>>>>                 gic_v3_kvm_info.vcpu = r;
>>>>  
>>>> +       gic_v3_kvm_info.no_hw_deactivation = true;
>>> Blink...
>>>
>>>> +       gic_v3_kvm_info.no_maint_irq_mask = true;
>>>> +
>>>> +       vgic_set_kvm_info(&gic_v3_kvm_info);
>>>> +       return;
>>>> +
>>>>         gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
>>>>         gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
>>>>         vgic_set_kvm_info(&gic_v3_kvm_info);
>>>>
>>>> Kept the maintenance irq ID so the IRQ gets enabled at the
>>>> Redistributor level. I don't know if I managed to break something
>>>> with those changes, but when testing on the model and on a rockpro64
>>>> (with the patches cherry-picked on top of v5.13-rc7) I kept seeing
>>>> rcu stalls. I assume I did something wrong.
>>> If you do that, the interrupts that are forwarded to the guest
>>> (timers) will never be deactivated, and will be left dangling after
>>> the first injection. This is bound to create havoc, as we will then
>>> use mask/unmask to control the timer delivery (remember that the
>>> Active state is just another form of auto-masking on top of the
>>> standard enable bit)
>>>
>>> On the contrary, the AIC only has a single bit to control the timer
>>> (used as a mask), which is what the irqdomain stuff implements to
>>> mimic the active state.
>> So these patches work **only** with the AIC, not with a standard
>> GICv3 without the HW bit in the LR registers and with an unmaskable
>> maintenance IRQ? Because from the commit message from #8 I got the
>> impression that the purpose of the change is to make timers work on
>> a standard GICv3, sans those required architectural features.
> I don't understand what you mean.

I think I understand what is happening better now.

With my changes, vgic_set_irq_phys_active(irq,
false)->irq_set_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, false) will call
timer_set_irqchip_state()->irqchip_unmask_parent() which doesn't clear the active
state of the timer interrupt at the GIC level. This means that the timer interrupt
acts like it's permanently masked after that first interrupt, like you've said.

From this I understand that the AIC is the only GIC implementation that will work
when no_hw_deactivation = true. To put it another way, a GIC implementation that
is 100% according to the spec with the exception that ICH_LR.HW is hardwired to 0
and the maintenance interrupt enabled and unmaskable will not work with these
patches because vgic_set_irq_phys_active(irq, false) will unmask the interrupt
instead of clearing the active state.

I was confused about that because I didn't find anywhere mentioned in the commit
message or in the code for patch #8 that the patch only works with an AIC, and not
with a generic GICv3 without hardware deactivation.

Thanks,

Alex

> The HW bit in the LR and deactivation *are* required, non-negotiable
> parts of the GICv3 architecture. Apple did not implement it is a
> consequence of the AIC not having an active state that the guest can
> manipulate independently of the host.
>
> Either you have both HW bit and active state, and both work together
> (normal GICv3), or you have none of that and we rely on the
> maintenance interrupt to exit and fix the mess (Apple crap). You
> cannot have an intermediate state between the two.
>
> Thanks,
>
> 	M.
>
