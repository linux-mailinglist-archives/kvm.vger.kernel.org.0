Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8F82EAC54
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 14:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbhAENsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 08:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbhAENsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 08:48:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBB32226A;
        Tue,  5 Jan 2021 13:47:59 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kwmgk-005ROK-Rr; Tue, 05 Jan 2021 13:47:57 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 05 Jan 2021 13:47:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <0fa19ab1-60ba-9067-e1aa-ee78191c52ed@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
 <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
 <0fa19ab1-60ba-9067-e1aa-ee78191c52ed@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <13d4e6de8653528aa71b07a2cfaa3552@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, eric.auger@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com, lorenzo.pieralisi@arm.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-05 13:02, Shenming Lu wrote:
> On 2021/1/5 17:13, Marc Zyngier wrote:
>> On 2021-01-04 08:16, Shenming Lu wrote:
>>> After pausing all vCPUs and devices capable of interrupting, in order
>>> to save the information of all interrupts, besides flushing the 
>>> pending
>>> states in kvm’s vgic, we also try to flush the states of VLPIs in the
>>> virtual pending tables into guest RAM, but we need to have GICv4.1 
>>> and
>>> safely unmap the vPEs first.
>>> 
>>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-v3.c | 58 
>>> +++++++++++++++++++++++++++++++----
>>>  1 file changed, 52 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c 
>>> b/arch/arm64/kvm/vgic/vgic-v3.c
>>> index 9cdf39a94a63..a58c94127cb0 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>>> @@ -1,6 +1,8 @@
>>>  // SPDX-License-Identifier: GPL-2.0-only
>>> 
>>>  #include <linux/irqchip/arm-gic-v3.h>
>>> +#include <linux/irq.h>
>>> +#include <linux/irqdomain.h>
>>>  #include <linux/kvm.h>
>>>  #include <linux/kvm_host.h>
>>>  #include <kvm/arm_vgic.h>
>>> @@ -356,6 +358,38 @@ int vgic_v3_lpi_sync_pending_status(struct kvm
>>> *kvm, struct vgic_irq *irq)
>>>      return 0;
>>>  }
>>> 
>>> +/*
>>> + * The deactivation of the doorbell interrupt will trigger the
>>> + * unmapping of the associated vPE.
>>> + */
>>> +static void unmap_all_vpes(struct vgic_dist *dist)
>>> +{
>>> +    struct irq_desc *desc;
>>> +    int i;
>>> +
>>> +    if (!kvm_vgic_global_state.has_gicv4_1)
>>> +        return;
>>> +
>>> +    for (i = 0; i < dist->its_vm.nr_vpes; i++) {
>>> +        desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
>>> +        irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
>>> +    }
>>> +}
>>> +
>>> +static void map_all_vpes(struct vgic_dist *dist)
>>> +{
>>> +    struct irq_desc *desc;
>>> +    int i;
>>> +
>>> +    if (!kvm_vgic_global_state.has_gicv4_1)
>>> +        return;
>>> +
>>> +    for (i = 0; i < dist->its_vm.nr_vpes; i++) {
>>> +        desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
>>> +        irq_domain_activate_irq(irq_desc_get_irq_data(desc), false);
>>> +    }
>>> +}
>>> +
>>>  /**
>>>   * vgic_v3_save_pending_tables - Save the pending tables into guest 
>>> RAM
>>>   * kvm lock and all vcpu lock must be held
>>> @@ -365,14 +399,18 @@ int vgic_v3_save_pending_tables(struct kvm 
>>> *kvm)
>>>      struct vgic_dist *dist = &kvm->arch.vgic;
>>>      struct vgic_irq *irq;
>>>      gpa_t last_ptr = ~(gpa_t)0;
>>> -    int ret;
>>> +    int ret = 0;
>>>      u8 val;
>>> 
>>> +    /* As a preparation for getting any VLPI states. */
>>> +    unmap_all_vpes(dist);
>> 
>> What if the VPEs are not mapped yet? Is it possible to snapshot a VM
>> that has not run at all?
> 
> What I see in QEMU is that the saving of the pending tables would only 
> be
> called when stopping the VM and it needs the current VM state to be 
> RUNNING.

Sure, but that's what QEMU does, and a different userspace could well do
something different. It looks to me that I should be able to start (or
even restore) a guest, and snapshot it immediately. Here, I'm pretty
sure this wouldn't do the right thing (I have the suspicion that the
doorbells are not allocated, and that we'll end-up with an Oops at unmap
time, though I haven't investigated it to be sure).

>> 
>>> +
>>>      list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>>>          int byte_offset, bit_nr;
>>>          struct kvm_vcpu *vcpu;
>>>          gpa_t pendbase, ptr;
>>>          bool stored;
>>> +        bool is_pending = irq->pending_latch;
>>> 
>>>          vcpu = irq->target_vcpu;
>>>          if (!vcpu)
>>> @@ -387,24 +425,32 @@ int vgic_v3_save_pending_tables(struct kvm 
>>> *kvm)
>>>          if (ptr != last_ptr) {
>>>              ret = kvm_read_guest_lock(kvm, ptr, &val, 1);
>>>              if (ret)
>>> -                return ret;
>>> +                goto out;
>>>              last_ptr = ptr;
>>>          }
>>> 
>>>          stored = val & (1U << bit_nr);
>>> -        if (stored == irq->pending_latch)
>>> +
>>> +        if (irq->hw)
>>> +            vgic_v4_get_vlpi_state(irq, &is_pending);
>> 
>> You don't check the return value here, so I wonder why the checks
>> in vgic_v4_get_vlpi_state().
> 
> Since I have already checked the condition and reported in 
> save_its_tables
> (patch 4), I just check in get_vlpi_state and don't report again here.

Sure, but why the checks and the return value then? I'd rather you check 
all
the relevant conditions in one place.

> 
>> 
>> Another thing that worries me is that vgic_v4_get_vlpi_state() doesn't
>> have any cache invalidation, and can end-up hitting in the CPU cache
>> (there is no guarantee of coherency between the GIC and the CPU, only
>> that the GIC will have flushed its caches).
>> 
>> I'd expect this to happen at unmap time, though, in order to avoid
>> repeated single byte invalidations.
> 
> Ok, I will add a cache invalidation at unmap time.

I guess a sensible place to do that would be at deactivation time.
I came up with the following hack, completely untested.

If that works for you, I'll turn it into a proper patch that you
can carry with the series (I may turn it into a __inval_dcache_area
call if I can find the equivalent 32bit).

Thanks,

         M.

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index 7db602434ac5..2dbef127ca15 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4552,6 +4552,10 @@ static void its_vpe_irq_domain_deactivate(struct 
irq_domain *domain,

  		its_send_vmapp(its, vpe, false);
  	}
+
+	if (find_4_1_its() && !atomic_read(vpe->vmapp_count))
+		gic_flush_dcache_to_poc(page_address(vpe->vpt_page),
+					LPI_PENDBASE_SZ);
  }

  static const struct irq_domain_ops its_vpe_domain_ops = {


-- 
Jazz is not dead. It just smells funny...
