Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91C018CC01
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 11:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCTK47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 06:56:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39643 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgCTK47 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 06:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584701818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H3cw3n7DECAvhMsR5v/8iVgWxi7rS06XuVpILiRCFOk=;
        b=IiV3UIqtf4LiqVN/IxurQ4ZJETozXRNvU8qK0zlmUXcOkHmXdUdWU/Uax4ioWbl0UE9Ucs
        bQKZMATTCt8LPoav/fI3gEmsVyWoTA+vbYzE2EVVEOcbjY5/DpsdNmr339xqFSf0g2hry4
        mtotcPjTtM77Mvocxv4iY8xLBnjJSbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-OwZAXjqLMAKh5q-K0N9TJQ-1; Fri, 20 Mar 2020 06:56:56 -0400
X-MC-Unique: OwZAXjqLMAKh5q-K0N9TJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB188800EBD;
        Fri, 20 Mar 2020 10:56:53 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C5565C1D8;
        Fri, 20 Mar 2020 10:56:49 +0000 (UTC)
Subject: Re: [PATCH v5 18/23] KVM: arm64: GICv4.1: Add direct injection
 capability to SGI registers
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
 <20200304203330.4967-19-maz@kernel.org>
 <06705d70-0f99-e719-af52-1a5f778562d8@redhat.com>
 <3f7094ffd77a6615d7179be94dbecc60@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9b1ce453-f24f-7974-99ca-1608ad7c6a13@redhat.com>
Date:   Fri, 20 Mar 2020 11:56:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3f7094ffd77a6615d7179be94dbecc60@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/20/20 11:05 AM, Marc Zyngier wrote:
> Hi Eric,
>=20
> On 2020-03-20 08:11, Auger Eric wrote:
>> Hi Marc,
>> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>>> Most of the GICv3 emulation code that deals with SGIs now has to be
>>> aware of the v4.1 capabilities in order to benefit from it.
>>>
>>> Add such support, keyed on the interrupt having the hw flag set and
>>> being a SGI.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> =A0virt/kvm/arm/vgic/vgic-mmio-v3.c | 15 +++++-
>>> =A0virt/kvm/arm/vgic/vgic-mmio.c=A0=A0=A0 | 88 ++++++++++++++++++++++=
++++++++--
>>> =A02 files changed, 96 insertions(+), 7 deletions(-)
>>>
>=20
> [...]
>=20
>>> @@ -113,7 +125,21 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vc=
pu,
>>> =A0=A0=A0=A0=A0=A0=A0=A0 struct vgic_irq *irq =3D vgic_get_irq(vcpu->=
kvm, vcpu, intid +
>>> i);
>>>
>>> =A0=A0=A0=A0=A0=A0=A0=A0 raw_spin_lock_irqsave(&irq->irq_lock, flags)=
;
>>> -=A0=A0=A0=A0=A0=A0=A0 if (vgic_irq_is_mapped_level(irq)) {
>>> +=A0=A0=A0=A0=A0=A0=A0 if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!irq->enabled) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct irq_data *data;
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irq->enabled =3D true;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 data =3D &irq_to_desc(=
irq->host_irq)->irq_data;
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while (irqd_irq_disabl=
ed(data))
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 enable_irq=
(irq->host_irq);
>> could you explain me why the while() is requested?
>=20
> Ah, interesting question: disable_irq() (and its variants) can nest. Th=
is
> means that if you have done two disable_irq(), you must do two enable_i=
rq()
> to get back to the interrupt being enabled.
>=20
> The locking should ensure that this nesting doesn't happen, but I'm
> paranoid
> (see the GICv4.0 doorbell handling). It also makes it easier to reason
> about
> the initial state.

OK! thank you for this explanation.

Thanks

Eric
>=20
> [...]
>=20
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>=20
> Thanks!
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0 M.

