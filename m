Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A16418BC42
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgCSQSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:18:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56181 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727636AbgCSQSV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 12:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584634701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPMaeSZsclHVIbI6q8ygnn5aaACtoMCOfBf0pAjRkic=;
        b=cLVt3hXI4cjSXS6M4oNVTu30+c6Szax1IQ8fhhk7qwtSt2L7P33nywqf/XNdNjB3a9UOF7
        Y3JwDzJZd6w38mKCwHJSrlegTsY3efTRj5/BsaXs6W/WT0FJ4S9HF7gPsGPtUtoywG8cKE
        hOmRFFlyQy1P3NXMQ+GCKoS2MqGmirU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-HTtkVwovMASSWR69wcGIBQ-1; Thu, 19 Mar 2020 12:18:17 -0400
X-MC-Unique: HTtkVwovMASSWR69wcGIBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8238B1050920;
        Thu, 19 Mar 2020 16:17:52 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B01975D9CD;
        Thu, 19 Mar 2020 16:17:49 +0000 (UTC)
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
 <33576d89-2b12-b98b-e392-3342b9b1265c@redhat.com>
 <17921081f98a589c67b37b1d07a9cfcc@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <791e08fc-417c-e956-1a41-0c605f7617b7@redhat.com>
Date:   Thu, 19 Mar 2020 17:17:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <17921081f98a589c67b37b1d07a9cfcc@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/19/20 5:16 PM, Marc Zyngier wrote:
> Hi Eric,
>=20
> On 2020-03-19 15:43, Auger Eric wrote:
>> Hi Marc,
>>
>> On 3/19/20 4:21 PM, Marc Zyngier wrote:
>>> Hi Eric,
>=20
> [...]
>=20
>>>> The patch looks good to me but I am now lost about how we retrieve t=
he
>>>> pending stat of other hw mapped interrupts. Looks we use
>>>> irq->pending_latch always. Is that correct?
>>>
>>> Correct. GICv4.0 doesn't give us an architectural way to look at the
>>> vLPI pending state (there isn't even a guarantee about when the GIC
>>> will stop writing to memory, if it ever does).
>>>
>>> With GICv4.1, you can introspect the HW state for SGIs. You can also
>>> look at the vLPI state by peeking at the virtual pending table, but
>>> you'd need to unmap the VPE first, which I obviously don't want to do
>>> for this debug interface, specially as it can be used whilst the gues=
t
>>> is up and running.
>> OK for vLPIs, what about other HW mapped IRQs (arch timer?)
>=20
> Different kind of HW. With those, the injection is still virtual, so th=
e
> SW pending bit is still very much valid. You can actually try and make
> the timer interrupt pending, it should show up.
>=20
> What the irq->hw bit means is "this virtual interrupt is somehow relate=
d
> to the host_irq". How this is interpreted is completely context-depende=
nt.
OK thank you for refreshing my memories ;-)

Eric
>=20
> Thanks,
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 M.

