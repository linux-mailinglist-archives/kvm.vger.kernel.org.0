Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ECA2C1FD7
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 09:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgKXI07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 03:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbgKXI07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 03:26:59 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293F220870;
        Tue, 24 Nov 2020 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606206418;
        bh=YCvAHBNcK4JrFhb6WFO3tG22p20ZWh3it7ak5hEvG2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DzSuDDeBaz/h0qW7OiRtKhYC5Y7L3qQx5larBizrKvm42cruk2f03ei1/RN4SR/Wr
         VSq9y/dhO+f009B8o9oyOsJQZerIHcfaAvtZjq1hE5/nGqXOA5oGkdNmfMyTUC0dNJ
         eR9lbz+Lh/m3jdkMri6N7jXDJshrGda3DKeHP0pM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khTf5-00DBXE-Ui; Tue, 24 Nov 2020 08:26:56 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 24 Nov 2020 08:26:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-3-lushenming@huawei.com>
 <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
 <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <4e2b87897485e38e251c447b9ad70eb6@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com, cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-24 07:40, Shenming Lu wrote:
> On 2020/11/23 17:18, Marc Zyngier wrote:
>> On 2020-11-23 06:54, Shenming Lu wrote:
>>> After pausing all vCPUs and devices capable of interrupting, in order
>>         ^^^^^^^^^^^^^^^^^
>> See my comment below about this.
>> 
>>> to save the information of all interrupts, besides flushing the 
>>> pending
>>> states in kvm’s vgic, we also try to flush the states of VLPIs in the
>>> virtual pending tables into guest RAM, but we need to have GICv4.1 
>>> and
>>> safely unmap the vPEs first.
>>> 
>>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-v3.c | 62 
>>> +++++++++++++++++++++++++++++++----
>>>  1 file changed, 56 insertions(+), 6 deletions(-)
>>> 
>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c 
>>> b/arch/arm64/kvm/vgic/vgic-v3.c
>>> index 9cdf39a94a63..e1b3aa4b2b12 100644
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
>>> @@ -356,6 +358,39 @@ int vgic_v3_lpi_sync_pending_status(struct kvm
>>> *kvm, struct vgic_irq *irq)
>>>      return 0;
>>>  }
>>> 
>>> +/*
>>> + * With GICv4.1, we can get the VLPI's pending state after unmapping
>>> + * the vPE. The deactivation of the doorbell interrupt will trigger
>>> + * the unmapping of the associated vPE.
>>> + */
>>> +static void get_vlpi_state_pre(struct vgic_dist *dist)
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
>>> +static void get_vlpi_state_post(struct vgic_dist *dist)
>> 
>> nit: the naming feels a bit... odd. Pre/post what?
> 
> My understanding is that the unmapping is a preparation for 
> get_vlpi_state...
> Maybe just call it unmap/map_all_vpes?

Yes, much better.

[...]

>>> +        if (irq->hw) {
>>> +            WARN_RATELIMIT(irq_get_irqchip_state(irq->host_irq,
>>> +                        IRQCHIP_STATE_PENDING, &is_pending),
>>> +                       "IRQ %d", irq->host_irq);
>> 
>> Isn't this going to warn like mad on a GICv4.0 system where this, by 
>> definition,
>> will generate an error?
> 
> As we have returned an error in save_its_tables if hw && !has_gicv4_1, 
> we don't
> have to warn this here?

Are you referring to the check in vgic_its_save_itt() that occurs in 
patch 4?
Fair enough, though I think the use of irq_get_irqchip_state() isn't 
quite
what we want, as per my comments on patch #1.

>> 
>>> +        }
>>> +
>>> +        if (stored == is_pending)
>>>              continue;
>>> 
>>> -        if (irq->pending_latch)
>>> +        if (is_pending)
>>>              val |= 1 << bit_nr;
>>>          else
>>>              val &= ~(1 << bit_nr);
>>> 
>>>          ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
>>>          if (ret)
>>> -            return ret;
>>> +            goto out;
>>>      }
>>> -    return 0;
>>> +
>>> +out:
>>> +    get_vlpi_state_post(dist);
>> 
>> This bit worries me: you have unmapped the VPEs, so any interrupt that 
>> has been
>> generated during that phase is now forever lost (the GIC doesn't have 
>> ownership
>> of the pending tables).
> 
> In my opinion, during this phase, the devices capable of interrupting
> should have  already been paused (prevent from sending interrupts),
> such as VFIO migration protocol has already realized it.

Is that a hard guarantee? Pausing devices *may* be possible for a 
limited
set of endpoints, but I'm not sure that is universally possible to 
restart
them and expect a consistent state (you have just dropped a bunch of 
network
packets on the floor...).

>> Do you really expect the VM to be restartable from that point? I don't 
>> see how
>> this is possible.
>> 
> 
> If the migration has encountered an error, the src VM might be
> restarted, so we have to map the vPEs back.

As I said above, I doubt it is universally possible to do so, but
after all, this probably isn't worse that restarting on the target...

         M.
-- 
Jazz is not dead. It just smells funny...
