Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1CE19781B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgC3J4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:56:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23061 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727376AbgC3J4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 05:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585562174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+i48u5EVTvTZXlAFzW/M3AOj4ZvswK4iw2XDLheQWkE=;
        b=VM/SRVPBV35QbWYdC5U+u+DtMdAxlvziRX6wxaS7nIceLuTYsM7n5IgwbDas8J0ICzEXLb
        nK1dt2J8A0uzjMRdxE05Y+PXwWCUoVrYf/sc2sc9XQmZQvlaj+RPivZsA+i/lM04rhsK/A
        xskY7uMvSAIPXzdKJ2Zyvy1IN02uEWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-jk6K2iO_ORCgrkaHNScO6Q-1; Mon, 30 Mar 2020 05:56:12 -0400
X-MC-Unique: jk6K2iO_ORCgrkaHNScO6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B4E7801E53;
        Mon, 30 Mar 2020 09:56:10 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA160953D6;
        Mon, 30 Mar 2020 09:56:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
 <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
 <8878be7f-7653-b427-cd0d-722f82fb6b65@redhat.com>
 <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <7d6dc4e7-82b4-3c54-574f-2149d4a85c48@redhat.com>
Date:   Mon, 30 Mar 2020 11:56:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200330091139.i2d6vv64f5diamlz@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/30/20 11:11 AM, Andrew Jones wrote:
> On Mon, Mar 30, 2020 at 10:46:57AM +0200, Auger Eric wrote:
>> Hi Zenghui,
>>
>> On 3/30/20 10:30 AM, Zenghui Yu wrote:
>>> Hi Eric,
>>>
>>> On 2020/3/20 17:24, Eric Auger wrote:
>>>> +static void its_cmd_queue_init(void)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 unsigned long order =3D get_order(SZ_64K >> PAGE=
_SHIFT);
>>>> +=C2=A0=C2=A0=C2=A0 u64 cbaser;
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_base =3D (void *)virt_to_phys(alloc=
_pages(order));
>>>
>>> Shouldn't the cmd_base (and the cmd_write) be set as a GVA?
>> yes it should
>=20
> If it's supposed to be a virtual address, when why do the virt_to_phys?
What is programmed in CBASER register is a physical address. So the
virt_to_phys() is relevant. The inconsistency is in its_allocate_entry()
introduced later on where I return the physical address instead of the
virtual address. I will fix that.


>=20
>>>
>>> Otherwise I think we will end-up with memory corruption when writing
>>> the command queue.=C2=A0 But it seems that everything just works fine=
 ...
>>> So I'm really confused here :-/
>> I was told by Paolo that the VA/PA memory map is flat in kvmunit test.
>=20
> What does flat mean?

Yes I meant an identity map.

 kvm-unit-tests, at least arm/arm64, does prepare
> an identity map of all physical memory, which explains why the above
> is working.

should be the same on x86

 It's doing virt_to_phys(some-virt-addr), which gets a
> phys addr, but when the ITS uses it as a virt addr it works because
> we *also* have a virt addr =3D=3D phys addr mapping in the default page
> table, which is named "idmap" for good reason.
>=20
> I think it would be better to test with the non-identity mapped address=
es
> though.

is there any way to exercise a non idmap?

Thanks

Eric
>=20
> Thanks,
> drew
>=20
>>
>>>
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 cbaser =3D ((u64)its_data.cmd_base | (SZ_64K / S=
Z_4K - 1)=C2=A0=C2=A0=C2=A0 |
>>>> GITS_CBASER_VALID);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 writeq(cbaser, its_data.base + GITS_CBASER);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_write =3D its_data.cmd_base;
>>>> +=C2=A0=C2=A0=C2=A0 writeq(0, its_data.base + GITS_CWRITER);
>>>> +}
>>>
>>> Otherwise this looks good,
>>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>> Thanks!
>>
>> Eric
>>>
>>>
>>> Thanks
>>>
>>
>>

