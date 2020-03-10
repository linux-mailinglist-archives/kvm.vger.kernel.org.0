Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7547A1804CF
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgCJRal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:30:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726380AbgCJRak (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 13:30:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583861439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6RWW66Auc2Rk/GNuUgSAGvLduNQwWlqc2HkVeIS1zc=;
        b=VSFUNLqW/O9LJUofrtIlTkuYYbhqffy23fquzBQjQK9Yr1xQ6EyLq8rXHCvcqU/4bCaAB/
        Tug8NcmqVTtgXiZKd7WTcVpWkwPHeeafRVOoVlhiM/oR8dmeAp++vZdUsZUKW0hLn5H1v2
        kyJHUePkVR6u4h22Gs0waMGTvb0P6LU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-4H-srkrCPfWDrBsXlrJ0_w-1; Tue, 10 Mar 2020 13:30:35 -0400
X-MC-Unique: 4H-srkrCPfWDrBsXlrJ0_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45FEE107ACC4;
        Tue, 10 Mar 2020 17:30:33 +0000 (UTC)
Received: from [10.36.117.85] (ovpn-117-85.ams2.redhat.com [10.36.117.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14EF110013A1;
        Tue, 10 Mar 2020 17:30:30 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] KVM: arm64: Document PMU filtering API
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-3-maz@kernel.org>
 <7943c896-013b-d9cb-ba89-2040b46437fe@redhat.com>
 <07f4ef9b5ff6c6c5086c9723c64c035f@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <867c7926-df43-7ab0-d20a-211a59d7612d@redhat.com>
Date:   Tue, 10 Mar 2020 18:30:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <07f4ef9b5ff6c6c5086c9723c64c035f@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/10/20 12:54 PM, Marc Zyngier wrote:
> On 2020-03-09 18:17, Auger Eric wrote:
>> Hi Marc,
>>
>> On 3/9/20 1:48 PM, Marc Zyngier wrote:
>>> Add a small blurb describing how the event filtering API gets used.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> =A0Documentation/virt/kvm/devices/vcpu.rst | 40 +++++++++++++++++++++=
++++
>>> =A01 file changed, 40 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst
>>> b/Documentation/virt/kvm/devices/vcpu.rst
>>> index 9963e680770a..7262c0469856 100644
>>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>>> @@ -55,6 +55,46 @@ Request the initialization of the PMUv3.=A0 If usi=
ng
>>> the PMUv3 with an in-kernel
>>> =A0virtual GIC implementation, this must be done after initializing t=
he
>>> in-kernel
>>> =A0irqchip.
>>>
>>> +1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
>>> +---------------------------------------
>>> +
>>> +:Parameters: in kvm_device_attr.addr the address for a PMU event
>>> filter is a
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pointer to a struct kvm_pmu_eve=
nt_filter
>>> +
>>> +:Returns:
>>> +
>>> +=A0=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> +=A0=A0=A0=A0 -ENODEV: PMUv3 not supported or GIC not initialized
>>> +=A0=A0=A0=A0 -ENXIO:=A0 PMUv3 not properly configured or in-kernel i=
rqchip not
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 configured as required prior to calli=
ng this attribute
>>> +=A0=A0=A0=A0 -EBUSY:=A0 PMUv3 already initialized
>> maybe document -EINVAL?
>=20
> Yup, definitely.
>=20
>>> +=A0=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> +
>>> +Request the installation of a PMU event filter describe as follows:
>> s/describe/described
>>> +
>>> +struct kvm_pmu_event_filter {
>>> +=A0=A0=A0 __u16=A0=A0=A0 base_event;
>>> +=A0=A0=A0 __u16=A0=A0=A0 nevents;
>>> +
>>> +#define KVM_PMU_EVENT_ALLOW=A0=A0=A0 0
>>> +#define KVM_PMU_EVENT_DENY=A0=A0=A0 1
>>> +
>>> +=A0=A0=A0 __u8=A0=A0=A0 action;
>>> +=A0=A0=A0 __u8=A0=A0=A0 pad[3];
>>> +};
>>> +
>>> +A filter range is defined as the range [@base_event, @base_event +
>>> @nevents[,
>>> +together with an @action (KVM_PMU_EVENT_ALLOW or
>>> KVM_PMU_EVENT_DENY). The
>>> +first registered range defines the global policy (global ALLOW if
>>> the first
>>> +@action is DENY, global DENY if the first @action is ALLOW).
>>> Multiple ranges
>>> +can be programmed, and must fit within the 16bit space defined by
>>> the ARMv8.1
>>> +PMU architecture.
>> what about before 8.1 where the range was 10 bits? Should it be tested
>> in the code?
>=20
> It's a good point. We could test that upon installing the filter and li=
mit
> the bitmap allocation to the minimum.
>=20
>> nitpicking: It is not totally obvious what does happen if the user spa=
ce
>> sets a deny filter on a range and then an allow filter on the same
>> range. it is supported but may be worth telling so? Also explain the t=
he
>> default filtering remains "allow" by default?
>=20
> Overlapping filters are easy: the last one wins. And yes, no filter mea=
ns
> just that: no filter.
Actually the point I wanted to put forward is
1) set allow filter on range [0-a] -> default setting is deny and allow
[0-a] only
2) deny deny filter on rang [0-a] -> there is no "real" active filtering
anymore but default behavior still is deny. ie. you do not destroy the
bitmap on the last filter removal but on the VM removal.

Thanks

Eric

>=20
> Thanks,
>=20
> =A0=A0=A0=A0=A0=A0=A0 M.

