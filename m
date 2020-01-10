Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DAD136F2B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgAJOT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:19:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727539AbgAJOT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 09:19:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578665996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aTffNF/e15nm3FHxlKhe7evWawGZzCWvldzrhkLBOYg=;
        b=D6t0HQBP3XIyq41ub+I5mfc59H00ppRP5UUe881sLpPQUxqiQvUV4L754jYSlwlsWSlc7M
        uP+WBFEGEOye8itZvr1RjXSe9QDLDHdY8cBhDz9wywp0Z1xsjZWnV43JXrPy6OlMrVg1Vi
        Bf02X81uTillfkZSprP2IHrDYJSWbIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-s_H5Abn8MCObOiPxEvmLCQ-1; Fri, 10 Jan 2020 09:19:53 -0500
X-MC-Unique: s_H5Abn8MCObOiPxEvmLCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44D2E108ADA8;
        Fri, 10 Jan 2020 14:19:51 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3360B86CA0;
        Fri, 10 Jan 2020 14:19:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 08/16] arm/arm64: ITS: Init the command
 queue
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-9-eric.auger@redhat.com>
 <37c8b078-900b-a474-04a0-0273c3a32aed@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <006eb558-8108-ae6e-8fe3-9ae2f1b725c3@redhat.com>
Date:   Fri, 10 Jan 2020 15:19:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <37c8b078-900b-a474-04a0-0273c3a32aed@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 12/20/19 8:10 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2019/12/16 22:02, Eric Auger wrote:
>> Allocate the command queue and initialize related registers:
>> CBASER, CREADR, CWRITER.
>>
>> The command queue is 64kB. This aims at not bothing with fullness.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> =C2=A0 lib/arm/asm/gic-v3-its.h |=C2=A0 7 +++++++
>> =C2=A0 lib/arm/gic-v3-its.c=C2=A0=C2=A0=C2=A0=C2=A0 | 37 +++++++++++++=
++++++++++++++++++++++++
>> =C2=A0 2 files changed, 44 insertions(+)
>>
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index 0d11aed..ed42707 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -113,10 +113,17 @@ struct its_baser {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int esz;
>> =C2=A0 };
>> =C2=A0 +struct its_cmd_block {
>> +=C2=A0=C2=A0=C2=A0 u64=C2=A0=C2=A0=C2=A0=C2=A0 raw_cmd[4];
>> +};
>> +
>> =C2=A0 struct its_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *base;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_typer typer;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_baser baser[GITS_BASER_NR_RE=
GS];
>> +=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_base;
>> +=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_write;
>> +=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_readr;
>=20
> I think we can just get rid of the 'cmd_readr'. As GITS_CREADR is
> generally manipulated by the ITS, and ...
>=20
>> =C2=A0 };
>> =C2=A0 =C2=A0 extern struct its_data its_data;
>> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> index 0b5a700..8b6a095 100644
>> --- a/lib/arm/gic-v3-its.c
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -188,3 +188,40 @@ void set_pending_table_bit(int rdist, int n, bool
>> set)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 byte &=3D ~mask=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *ptr =3D byte;
>> =C2=A0 }
>> +
>> +/**
>> + * init_cmd_queue: Allocate the command queue and initialize
>> + * CBASER, CREADR, CWRITER
>> + */
>> +void init_cmd_queue(void);
>> +void init_cmd_queue(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 unsigned long n =3D SZ_64K >> PAGE_SHIFT;
>> +=C2=A0=C2=A0=C2=A0 unsigned long order =3D fls(n);
>> +=C2=A0=C2=A0=C2=A0 u64 cbaser, tmp;
>> +
>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_base =3D (void *)virt_to_phys(alloc_p=
ages(order));
>> +
>> +=C2=A0=C2=A0=C2=A0 cbaser =3D ((u64)its_data.cmd_base=C2=A0=C2=A0=C2=A0=
 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GITS_CBASER_WaWb=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GITS_CBASER_InnerSha=
reable=C2=A0=C2=A0=C2=A0=C2=A0 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (SZ_64K / SZ_4K - 1)=
 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 GITS_CBASER_VALID);
>> +
>> +=C2=A0=C2=A0=C2=A0 writeq(cbaser, its_data.base + GITS_CBASER);
>=20
> ..."(CREADR) is cleared to 0 when a value is written to GITS_CBASER."
> -- from IHI0069E 9.19.3
>=20
>> +=C2=A0=C2=A0=C2=A0 tmp =3D readq(its_data.base + GITS_CBASER);
>> +
>> +=C2=A0=C2=A0=C2=A0 if ((tmp ^ cbaser) & GITS_CBASER_SHAREABILITY_MASK=
) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(tmp & GITS_CBASER_SH=
AREABILITY_MASK)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cb=
aser &=3D ~(GITS_CBASER_SHAREABILITY_MASK |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 GITS_CBASER_CACHEABILITY_MASK);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cb=
aser |=3D GITS_CBASER_nC;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wr=
iteq(cbaser, its_data.base + GITS_CBASER);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_write =3D its_data.cmd_base;
>> +=C2=A0=C2=A0=C2=A0 its_data.cmd_readr =3D its_data.cmd_base;
>> +=C2=A0=C2=A0=C2=A0 writeq(0, its_data.base + GITS_CWRITER);
>> +=C2=A0=C2=A0=C2=A0 writeq(0, its_data.base + GITS_CREADR);
>=20
> So this writeq() is also not needed.
>=20
> Or I've just missed the point that this is done by intention to test
> "whether the GITS_CREADR implemented by KVM is Write Ignored"?
> If so, please ignore all of the comments above :)
No I must admit this was not done on purpose. I can remove it from the
its_data struct at the moment.

Thanks

Eric
>=20
>=20
> Thanks,
> Zenghui
>=20

