Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F50318BB64
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 16:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgCSPnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 11:43:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:36000 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727416AbgCSPnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 11:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584632601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lokpvkMQVoKd0lod8SVkg+xNqrbRc/YyD9IgFwSAqTc=;
        b=HZSwW80SeYaxWWnPtIzz5Xk0s2NlhXCh1uE6+UnzyxrZ044d96uampXDT2rHATM3MuwvSP
        nc8IoKWCX860bYU4N1DgHRdB8o2oQ8f2U3QLiCrxQtOemhUHrmucOm0DFTS4RpYN8rE0lo
        da9fTYxaWZ3air6gjdkVTpyetgZCPHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-I-NX-DfHPpaC7toQ5qn_KQ-1; Thu, 19 Mar 2020 11:43:16 -0400
X-MC-Unique: I-NX-DfHPpaC7toQ5qn_KQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82C16107ACC4;
        Thu, 19 Mar 2020 15:43:14 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AE829081F;
        Thu, 19 Mar 2020 15:43:10 +0000 (UTC)
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <33576d89-2b12-b98b-e392-3342b9b1265c@redhat.com>
Date:   Thu, 19 Mar 2020 16:43:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <45c282bddd43420024633943c1befac3@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/19/20 4:21 PM, Marc Zyngier wrote:
> Hi Eric,
>=20
> On 2020-03-19 15:05, Auger Eric wrote:
>> Hi Marc,
>>
>> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>>> The vgic-state debugfs file could do with showing the pending state
>>> of the HW-backed SGIs. Plug it into the low-level code.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> =C2=A0virt/kvm/arm/vgic/vgic-debug.c | 14 +++++++++++++-
>>> =C2=A01 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-debug.c
>>> b/virt/kvm/arm/vgic/vgic-debug.c
>>> index cc12fe9b2df3..b13a9e3f99dd 100644
>>> --- a/virt/kvm/arm/vgic/vgic-debug.c
>>> +++ b/virt/kvm/arm/vgic/vgic-debug.c
>>> @@ -178,6 +178,8 @@ static void print_irq_state(struct seq_file *s,
>>> struct vgic_irq *irq,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_vcpu *vcpu)
>>> =C2=A0{
>>> =C2=A0=C2=A0=C2=A0=C2=A0 char *type;
>>> +=C2=A0=C2=A0=C2=A0 bool pending;
>> nit: can be directly initialized to irq->pending_latch
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (irq->intid < VGIC_NR_SGIS)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 type =3D "SGI";
>>> =C2=A0=C2=A0=C2=A0=C2=A0 else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
>>> @@ -190,6 +192,16 @@ static void print_irq_state(struct seq_file *s,
>>> struct vgic_irq *irq,
>>> =C2=A0=C2=A0=C2=A0=C2=A0 if (irq->intid =3D=3D0 || irq->intid =3D=3D =
VGIC_NR_PRIVATE_IRQS)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_header(s, irq,=
 vcpu);
>>>
>>> +=C2=A0=C2=A0=C2=A0 pending =3D irq->pending_latch;
>>> +=C2=A0=C2=A0=C2=A0 if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D irq_get_irqchip_s=
tate(irq->host_irq,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 IRQ=
CHIP_STATE_PENDING,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &pe=
nding);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(err);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 %s %4d "
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "=C2=A0=C2=A0=C2=A0 %2d "
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "%d%d%d%d%d%d%d "
>>> @@ -201,7 +213,7 @@ static void print_irq_state(struct seq_file *s,
>>> struct vgic_irq *irq,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "\n",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 type, irq->intid,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 (irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
rq->pending_latch,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 p=
ending,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 irq->line_level,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 irq->active,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 irq->enabled,
>>>
>> The patch looks good to me but I am now lost about how we retrieve the
>> pending stat of other hw mapped interrupts. Looks we use
>> irq->pending_latch always. Is that correct?
>=20
> Correct. GICv4.0 doesn't give us an architectural way to look at the
> vLPI pending state (there isn't even a guarantee about when the GIC
> will stop writing to memory, if it ever does).
>=20
> With GICv4.1, you can introspect the HW state for SGIs. You can also
> look at the vLPI state by peeking at the virtual pending table, but
> you'd need to unmap the VPE first, which I obviously don't want to do
> for this debug interface, specially as it can be used whilst the guest
> is up and running.
OK for vLPIs, what about other HW mapped IRQs (arch timer?)

Eric
>=20
> In the future, we'll have to implement that in order to support guest
> save/restore from a GICv4.1 system. I haven't given much thought to it
> though.
>=20
>> For the patch:
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>=20
> Thanks,
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 M.

