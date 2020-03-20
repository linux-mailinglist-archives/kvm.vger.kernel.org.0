Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF4518CC60
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 12:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgCTLJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 07:09:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28250 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbgCTLJb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 07:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584702570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FG3rV03ORdL5dZYsmjHuCpupbanGtM2DORWeRbjL06s=;
        b=BTYBcJCCk6QFYVX73N6jfPHZjc2Ol/bnYAOADhsbYdSilTco0vL1QrNyVZL+khpsWzZbo5
        q0cwDFb6NEuaQsWEkUAEm23l+G+84Nm2UnbkvcOOEiqIseRcY7J5UUtikj2VGrG67Dp2PV
        WvKxpZcMpR5sWbaFVSZ909DHnVr/v7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-XhybzQHaNwiNF6Rbkf4nkw-1; Fri, 20 Mar 2020 07:09:29 -0400
X-MC-Unique: XhybzQHaNwiNF6Rbkf4nkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4D3D189D6C3;
        Fri, 20 Mar 2020 11:09:26 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B60AD60C18;
        Fri, 20 Mar 2020 11:09:22 +0000 (UTC)
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
To:     Marc Zyngier <maz@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@marvell.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <49995ec9-3970-1f62-5dfc-118563ca00fc@redhat.com>
 <b98855a1-6300-d323-80f6-82d3b9854290@huawei.com>
 <e60578b5-910c-0355-d231-29322900679d@redhat.com>
 <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <02350520-8591-c62c-e7fa-33db30c25b96@redhat.com>
Date:   Fri, 20 Mar 2020 12:09:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <dfaf8a1b7c7fd8b769a244a8a779d952@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/20/20 10:46 AM, Marc Zyngier wrote:
> On 2020-03-20 07:59, Auger Eric wrote:
>> Hi Zenghui,
>>
>> On 3/20/20 4:08 AM, Zenghui Yu wrote:
>>> On 2020/3/20 4:38, Auger Eric wrote:
>>>> Hi Marc,
>>>> On 3/19/20 1:10 PM, Marc Zyngier wrote:
>>>>> Hi Zenghui,
>>>>>
>>>>> On 2020-03-18 06:34, Zenghui Yu wrote:
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>>>>>> The GICv4.1 architecture gives the hypervisor the option to let
>>>>>>> the guest choose whether it wants the good old SGIs with an
>>>>>>> active state, or the new, HW-based ones that do not have one.
>>>>>>>
>>>>>>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>>>>>>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>>>>>>> and handle the GICD_CTLR.nASSGIreq setting.
>>>>>>>
>>>>>>> In order to be able to deal with the restore of a guest, also
>>>>>>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>>>>>>> can move the restored SGIs to the HW if that's what the guest
>>>>>>> had selected in a previous life.
>>>>>>
>>>>>> I'm okay with the restore path.=C2=A0 But it seems that we still f=
ail to
>>>>>> save the pending state of vSGI - software pending_latch of HW-base=
d
>>>>>> vSGIs will not be updated (and always be false) because we directl=
y
>>>>>> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
>>>>>> tell the correct pending state to user-space (the correct one shou=
ld
>>>>>> be latched in HW).
>>>>>>
>>>>>> It would be good if we can sync the hardware state into pending_la=
tch
>>>>>> at an appropriate time (just before save), but not sure if we can.=
..
>>>>>
>>>>> The problem is to find the "appropriate time". It would require to
>>>>> define
>>>>> a point in the save sequence where we transition the state from HW =
to
>>>>> SW. I'm not keen on adding more state than we already have.
>>>>
>>>> may be we could use a dedicated device group/attr as we have for the
>>>> ITS
>>>> save tables? the user space would choose.
>>>
>>> It means that userspace will be aware of some form of GICv4.1 details
>>> (e.g., get/set vSGI state at HW level) that KVM has implemented.
>>> Is it something that userspace required to know? I'm open to this ;-)
>> Not sure we would be obliged to expose fine details. This could be a
>> generic save/restore device group/attr whose implementation at KVM lev=
el
>> could differ depending on the version being implemented, no?
>=20
> What prevents us from hooking this synchronization to the current behav=
iour
> of KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES? After all, this is already the
> point
> where we synchronize the KVM view of the pending state with userspace.
> Here, it's just a matter of picking the information from some other pla=
ce
> (i.e. the host's virtual pending table).
agreed
>=20
> The thing we need though is the guarantee that the guest isn't going to
> get more vLPIs at that stage, as they would be lost. This effectively
> assumes that we can also save/restore the state of the signalling devic=
es,
> and I don't know if we're quite there yet.
On QEMU, when KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES is called, the VM is
stopped.
See cddafd8f353d ("hw/intc/arm_gicv3_its: Implement state save/restore")
So I think it should work, no?

Thanks

Eric

>=20
> Thanks,
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 M.

