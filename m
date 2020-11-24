Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD8E2C2053
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 09:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgKXIpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 03:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730743AbgKXIpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 03:45:03 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E362073C;
        Tue, 24 Nov 2020 08:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606207502;
        bh=xCFPFws3rl+rLs/hXsg30ZbSaEzwkNeXgxTpyEHJHGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j1emCflw6I0voluiwaNY3BYc4EZplrGs1OCSYe2Yqa0SJJtsdXs0hai6AgbirClTe
         qG89f8UrVqAbfxF11nmuYpnxOTumpsxfG9wd/q1u/ycmgucSruD9YK4nlqp+cu0dGw
         y9/MzlWVYFZePeBDuT6oqJLyp0qBCJrXKeZgDPSs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khTwZ-00DBsM-Tw; Tue, 24 Nov 2020 08:45:00 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 24 Nov 2020 08:44:59 +0000
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
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com, alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com, cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-24 08:10, Shenming Lu wrote:
> On 2020/11/23 17:27, Marc Zyngier wrote:
>> On 2020-11-23 06:54, Shenming Lu wrote:
>>> From: Zenghui Yu <yuzenghui@huawei.com>
>>> 
>>> When setting the forwarding path of a VLPI, it is more consistent to
>> 
>> I'm not sure it is more consistent. It is a *new* behaviour, because 
>> it only
>> matters for migration, which has been so far unsupported.
> 
> Alright, consistent may not be accurate...
> But I have doubt that whether there is really no need to transfer the
> pending states
> from kvm'vgic to VPT in set_forwarding regardless of migration, and the 
> similar
> for unset_forwarding.

If you have to transfer that state outside of the a save/restore, it 
means that
you have missed the programming of the PCI endpoint. This is an 
established
restriction that the MSI programming must occur *after* the translation 
has
been established using MAPI/MAPTI (see the large comment at the 
beginning of
vgic-v4.c).

If you want to revisit this, fair enough. But you will need a lot more 
than
just opportunistically transfer the pending state.

> 
>> 
>>> also transfer the pending state from irq->pending_latch to VPT 
>>> (especially
>>> in migration, the pending states of VLPIs are restored into kvm’s 
>>> vgic
>>> first). And we currently send "INT+VSYNC" to trigger a VLPI to 
>>> pending.
>>> 
>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-v4.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>> 
>>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
>>> b/arch/arm64/kvm/vgic/vgic-v4.c
>>> index b5fa73c9fd35..cc3ab9cea182 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>>> @@ -418,6 +418,18 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, 
>>> int virq,
>>>      irq->host_irq    = virq;
>>>      atomic_inc(&map.vpe->vlpi_count);
>>> 
>>> +    /* Transfer pending state */
>>> +    ret = irq_set_irqchip_state(irq->host_irq,
>>> +                    IRQCHIP_STATE_PENDING,
>>> +                    irq->pending_latch);
>>> +    WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
>>> +
>>> +    /*
>>> +     * Let it be pruned from ap_list later and don't bother
>>> +     * the List Register.
>>> +     */
>>> +    irq->pending_latch = false;
>> 
>> It occurs to me that calling into irq_set_irqchip_state() for a large
>> number of interrupts can take a significant amount of time. It is also
>> odd that you dump the VPT with the VPE unmapped, but rely on the VPE
>> being mapped for the opposite operation.
>> 
>> Shouldn't these be symmetric, all performed while the VPE is unmapped?
>> It would also save a lot of ITS traffic.
>> 
> 
> My thought was to use the existing interface directly without 
> unmapping...
> 
> If you want to unmap the vPE and poke the VPT here, as I said in the 
> cover
> letter, set/unset_forwarding might also be called when all devices are 
> running
> at normal run time, in which case the unmapping of the vPE is not 
> allowed...

No, I'm suggesting that you don't do anything here, but instead as a 
by-product
of restoring the ITS tables. What goes wrong if you use the
KVM_DEV_ARM_ITS_RESTORE_TABLE backend instead?

> Another possible solution is to add a new dedicated interface to QEMU
> to transfer
> these pending states to HW in GIC VM state change handler corresponding 
> to
> save_pending_tables?

Userspace has no way to know we use GICv4, and I intend to keep it
completely out of the loop. The API is already pretty tortuous, and
I really don't want to add any extra complexity to it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
