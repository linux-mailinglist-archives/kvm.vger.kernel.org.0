Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1E018C865
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 09:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCTIAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 04:00:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52070 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgCTIAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 04:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584691199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NCLldPyucn2EtjkD/YGvXmu67T8oQjms+EaHjNLuyLQ=;
        b=EPJ8F59uR2xsFbWETRKBMlOHuhQq87+4ZApFLoFrwPEzuYsqskYMdU9VgLPVpelbEKTRP3
        VtHXxpoG+VezMF4d2MG5mtgJhlc7R1a2dIusOzEqFfWeBm3a2xvexBVsWon9mYBW5S1OQr
        mYIrDfldOs0i442vdRtZN9n0AL6fs0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-KENkeixLMkCVD1dP4OHYhg-1; Fri, 20 Mar 2020 03:59:54 -0400
X-MC-Unique: KENkeixLMkCVD1dP4OHYhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBAB8800D53;
        Fri, 20 Mar 2020 07:59:52 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2F365C1A5;
        Fri, 20 Mar 2020 07:59:49 +0000 (UTC)
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e60578b5-910c-0355-d231-29322900679d@redhat.com>
Date:   Fri, 20 Mar 2020 08:59:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/20/20 4:08 AM, Zenghui Yu wrote:
> On 2020/3/20 4:38, Auger Eric wrote:
>> Hi Marc,
>> On 3/19/20 1:10 PM, Marc Zyngier wrote:
>>> Hi Zenghui,
>>>
>>> On 2020-03-18 06:34, Zenghui Yu wrote:
>>>> Hi Marc,
>>>>
>>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>>> The GICv4.1 architecture gives the hypervisor the option to let
>>>>> the guest choose whether it wants the good old SGIs with an
>>>>> active state, or the new, HW-based ones that do not have one.
>>>>>
>>>>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>>>>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>>>>> and handle the GICD_CTLR.nASSGIreq setting.
>>>>>
>>>>> In order to be able to deal with the restore of a guest, also
>>>>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>>>>> can move the restored SGIs to the HW if that's what the guest
>>>>> had selected in a previous life.
>>>>
>>>> I'm okay with the restore path.=A0 But it seems that we still fail t=
o
>>>> save the pending state of vSGI - software pending_latch of HW-based
>>>> vSGIs will not be updated (and always be false) because we directly
>>>> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
>>>> tell the correct pending state to user-space (the correct one should
>>>> be latched in HW).
>>>>
>>>> It would be good if we can sync the hardware state into pending_latc=
h
>>>> at an appropriate time (just before save), but not sure if we can...
>>>
>>> The problem is to find the "appropriate time". It would require to
>>> define
>>> a point in the save sequence where we transition the state from HW to
>>> SW. I'm not keen on adding more state than we already have.
>>
>> may be we could use a dedicated device group/attr as we have for the I=
TS
>> save tables? the user space would choose.
>=20
> It means that userspace will be aware of some form of GICv4.1 details
> (e.g., get/set vSGI state at HW level) that KVM has implemented.
> Is it something that userspace required to know? I'm open to this ;-)
Not sure we would be obliged to expose fine details. This could be a
generic save/restore device group/attr whose implementation at KVM level
could differ depending on the version being implemented, no?

Thanks

Eric
>=20
>>
>> Thanks
>>
>> Eric
>>>
>>> But what we can do is to just ask the HW to give us the right state
>>> on userspace access, at all times. How about this:
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index 48fd9fc229a2..281fe7216c59 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -305,8 +305,18 @@ static unsigned long
>>> vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
>>> =A0=A0=A0=A0=A0=A0 */
>>> =A0=A0=A0=A0=A0 for (i =3D 0; i < len * 8; i++) {
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 struct vgic_irq *irq =3D vgic_get_irq(vcp=
u->kvm, vcpu, intid
>>> + i);
>>> +=A0=A0=A0=A0=A0=A0=A0 bool state =3D irq->pending_latch;
>>>
>>> -=A0=A0=A0=A0=A0=A0=A0 if (irq->pending_latch)
>>> +=A0=A0=A0=A0=A0=A0=A0 if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int err;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 err =3D irq_get_irqchip_state(irq-=
>host_irq,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 IRQCHIP_STATE_PENDING,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &state);
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 WARN_ON(err);
>>> +=A0=A0=A0=A0=A0=A0=A0 }
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 if (state)
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 value |=3D (1U << i);
>>>
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 vgic_put_irq(vcpu->kvm, irq);
>=20
> Anyway this looks good to me and will do the right thing on a userspace
> save.
>=20
>>>
>>> I can add this to "KVM: arm64: GICv4.1: Add direct injection capabili=
ty
>>> to SGI registers".
>=20
> Thanks,
> Zenghui
>=20

