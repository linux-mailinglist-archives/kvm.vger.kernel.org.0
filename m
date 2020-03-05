Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D290B17AF19
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 20:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCETmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 14:42:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgCETmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 14:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583437350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o2QOFnMMcZZ+uHhgLltxx0kXPKpZY9J5vvEiymhKIFA=;
        b=FCZRFwfAQIG7MCMIN8Vxo7Hmn6wJZMYNQjR/qLCRhN99HGaUVtoOhICpCEWmQn2XI4nXPu
        szkLmMQSQus6q3LqT9VIvgVgABGhixBcwrdZPTx8JxUBExN2O6C3sDhzDja8a7UQfc+TXZ
        FGzxeTZrMrh845gDQ6jeLpRP0cLTq/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-bSZWOfNyOa-fM50ncwp2lg-1; Thu, 05 Mar 2020 14:42:28 -0500
X-MC-Unique: bSZWOfNyOa-fM50ncwp2lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D738107ACC4;
        Thu,  5 Mar 2020 19:42:26 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ABF460BF1;
        Thu,  5 Mar 2020 19:42:23 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 09/14] arm/arm64: ITS: Device and
 collection Initialization
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-10-eric.auger@redhat.com>
 <42a8964a-af3d-0117-bfac-5db6b7b832dd@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <aac8e67f-1733-9f8e-f7bf-6870af4605c0@redhat.com>
Date:   Thu, 5 Mar 2020 20:42:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <42a8964a-af3d-0117-bfac-5db6b7b832dd@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2/7/20 6:41 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/1/28 18:34, Eric Auger wrote:
>> Introduce an helper functions to register
>> - a new device, characterized by its device id and the
>> =C2=A0=C2=A0 max number of event IDs that dimension its ITT (Interrupt
>> =C2=A0=C2=A0 Translation Table).=C2=A0 The function allocates the ITT.
>>
>> - a new collection, characterized by its ID and the
>> =C2=A0=C2=A0 target processing engine (PE).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - s/report_abort/assert
>>
>> v1 -> v2:
>> - s/nb_/nr_
>> ---
>> =C2=A0 lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++-
>> =C2=A0 lib/arm/gic-v3-its.c=C2=A0=C2=A0=C2=A0=C2=A0 | 44 +++++++++++++=
+++++++++++++++++++++++++++
>> =C2=A0 2 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index fe73c04..acd97a9 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -31,6 +31,19 @@ struct its_baser {
>> =C2=A0 };
>> =C2=A0 =C2=A0 #define GITS_BASER_NR_REGS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8
>> +#define GITS_MAX_DEVICES=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8
>> +#define GITS_MAX_COLLECTIONS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 8
>> +
>> +struct its_device {
>> +=C2=A0=C2=A0=C2=A0 u32 device_id;=C2=A0=C2=A0=C2=A0 /* device ID */
>> +=C2=A0=C2=A0=C2=A0 u32 nr_ites;=C2=A0=C2=A0=C2=A0 /* Max Interrupt Tr=
anslation Entries */
>> +=C2=A0=C2=A0=C2=A0 void *itt;=C2=A0=C2=A0=C2=A0 /* Interrupt Translat=
ion Table GPA */
>> +};
>> +
>> +struct its_collection {
>> +=C2=A0=C2=A0=C2=A0 u64 target_address;
>> +=C2=A0=C2=A0=C2=A0 u16 col_id;
>> +};
>> =C2=A0 =C2=A0 struct its_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *base;
>> @@ -38,6 +51,10 @@ struct its_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_baser baser[GITS_BASER_NR_RE=
GS];
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_base;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_write;
>> +=C2=A0=C2=A0=C2=A0 struct its_device devices[GITS_MAX_DEVICES];
>> +=C2=A0=C2=A0=C2=A0 u32 nr_devices;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* Allocated Devices */
>> +=C2=A0=C2=A0=C2=A0 struct its_collection collections[GITS_MAX_COLLECT=
IONS];
>> +=C2=A0=C2=A0=C2=A0 u32 nr_collections;=C2=A0=C2=A0=C2=A0 /* Allocated=
 Collections */
>> =C2=A0 };
>> =C2=A0 =C2=A0 extern struct its_data its_data;
>> @@ -90,7 +107,6 @@ extern struct its_data its_data;
>> =C2=A0 #define GITS_BASER_TYPE_DEVICE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 1
>> =C2=A0 #define GITS_BASER_TYPE_COLLECTION=C2=A0=C2=A0=C2=A0 4
>> =C2=A0 -
>> =C2=A0 struct its_cmd_block {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 raw_cmd[4];
>> =C2=A0 };
>> @@ -100,6 +116,8 @@ extern void its_init(void);
>> =C2=A0 extern int its_parse_baser(int i, struct its_baser *baser);
>> =C2=A0 extern struct its_baser *its_lookup_baser(int type);
>> =C2=A0 extern void its_enable_defaults(void);
>> +extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
>> +extern struct its_collection *its_create_collection(u32 col_id, u32
>> target_pe);
>> =C2=A0 =C2=A0 #else /* __arm__ */
>> =C2=A0 diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> index d1e7e52..c2dcd01 100644
>> --- a/lib/arm/gic-v3-its.c
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -175,3 +175,47 @@ void its_enable_defaults(void)
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writel(GITS_CTLR_ENABLE, its_dat=
a.base + GITS_CTLR);
>> =C2=A0 }
>> +
>> +struct its_device *its_create_device(u32 device_id, int nr_ites)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct its_baser *baser;
>> +=C2=A0=C2=A0=C2=A0 struct its_device *new;
>> +=C2=A0=C2=A0=C2=A0 unsigned long n, order;
>> +
>> +=C2=A0=C2=A0=C2=A0 assert(its_data.nr_devices < GITS_MAX_DEVICES);
>> +
>=20
>=20
>> +=C2=A0=C2=A0=C2=A0 baser =3D its_lookup_baser(GITS_BASER_TYPE_DEVICE)=
;
>> +=C2=A0=C2=A0=C2=A0 if (!baser)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>=20
> I think there's no need to lookup the device baser here. As the
> device baser should have already been setup at initialization
> time (i.e. in its_enable_defaults). And anyway, 'baser' is not
> being used in this function.
I fully agree. I Removed that.

Thanks!

Eric
>=20
>=20
> Thanks,
> Zenghui
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 new =3D &its_data.devices[its_data.nr_devices];
>> +
>> +=C2=A0=C2=A0=C2=A0 new->device_id =3D device_id;
>> +=C2=A0=C2=A0=C2=A0 new->nr_ites =3D nr_ites;
>> +
>> +=C2=A0=C2=A0=C2=A0 n =3D (its_data.typer.ite_size * nr_ites) >> PAGE_=
SHIFT;
>> +=C2=A0=C2=A0=C2=A0 order =3D is_power_of_2(n) ? fls(n) : fls(n) + 1;
>> +=C2=A0=C2=A0=C2=A0 new->itt =3D (void *)virt_to_phys(alloc_pages(orde=
r));
>> +
>> +=C2=A0=C2=A0=C2=A0 its_data.nr_devices++;
>> +=C2=A0=C2=A0=C2=A0 return new;
>> +}
>> +
>> +struct its_collection *its_create_collection(u32 col_id, u32 pe)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct its_collection *new;
>> +
>> +=C2=A0=C2=A0=C2=A0 assert(its_data.nr_collections < GITS_MAX_COLLECTI=
ONS);
>> +
>> +=C2=A0=C2=A0=C2=A0 new =3D &its_data.collections[its_data.nr_collecti=
ons];
>> +
>> +=C2=A0=C2=A0=C2=A0 new->col_id =3D col_id;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (its_data.typer.pta)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->target_address =3D (u=
64)gicv3_data.redist_base[pe];
>> +=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new->target_address =3D pe=
 << 16;
>> +
>> +=C2=A0=C2=A0=C2=A0 its_data.nr_collections++;
>> +=C2=A0=C2=A0=C2=A0 return new;
>> +}
>>
>=20

