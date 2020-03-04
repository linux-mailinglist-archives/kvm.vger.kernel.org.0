Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C4117924F
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 15:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgCDO0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 09:26:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726748AbgCDO0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 09:26:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583332003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvGdvyoYicE65N8jrEMq9T3OVl/eWTUOTcqawK3mVp4=;
        b=brLmhNsFmg7hEEgjlrFGp+KrXBkDwsXZHTqwIwogcCD6BoIBQu3N1j7trioE3NmaO9ck0R
        cwyRUm49uzHr+vn0zpHTT6nmfm8+/PcuOHMpRyC83tliTagrh+OWmfQaYhDwSW1CSIFiM2
        XHrk3914Qll4JvaDKhpHuRqHbDc0JrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-6WHthEjRNrONjgC-NvHxrw-1; Wed, 04 Mar 2020 09:26:40 -0500
X-MC-Unique: 6WHthEjRNrONjgC-NvHxrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7F8C107ACCA;
        Wed,  4 Mar 2020 14:26:37 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6E6010013A1;
        Wed,  4 Mar 2020 14:26:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 08/14] arm/arm64: ITS:
 its_enable_defaults
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-9-eric.auger@redhat.com>
 <10d0630f-1464-b12a-5ad5-ee617eaa5cca@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a49227ce-355a-be35-c006-441e2adca8e1@redhat.com>
Date:   Wed, 4 Mar 2020 15:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <10d0630f-1464-b12a-5ad5-ee617eaa5cca@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,
On 2/7/20 4:20 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/1/28 18:34, Eric Auger wrote:
>> its_enable_defaults() is the top init function that allocates the
>> command queue and all the requested tables (device, collection,
>> lpi config and pending tables), enable LPIs at distributor level
>> and ITS level.
>>
>> gicv3_enable_defaults must be called before.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - introduce its_setup_baser in this patch
>> - squash "arm/arm64: ITS: Init the command queue" in this patch.
>> ---
>> =C2=A0 lib/arm/asm/gic-v3-its.h |=C2=A0 8 ++++
>> =C2=A0 lib/arm/gic-v3-its.c=C2=A0=C2=A0=C2=A0=C2=A0 | 89 +++++++++++++=
+++++++++++++++++++++++++++
>> =C2=A0 2 files changed, 97 insertions(+)
>>
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index 815c515..fe73c04 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -36,6 +36,8 @@ struct its_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *base;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_typer typer;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_baser baser[GITS_BASER_NR_RE=
GS];
>> +=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_base;
>> +=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd_write;
>> =C2=A0 };
>> =C2=A0 =C2=A0 extern struct its_data its_data;
>> @@ -88,10 +90,16 @@ extern struct its_data its_data;
>> =C2=A0 #define GITS_BASER_TYPE_DEVICE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 1
>> =C2=A0 #define GITS_BASER_TYPE_COLLECTION=C2=A0=C2=A0=C2=A0 4
>> =C2=A0 +
>> +struct its_cmd_block {
>> +=C2=A0=C2=A0=C2=A0 u64 raw_cmd[4];
>> +};
>> +
>> =C2=A0 extern void its_parse_typer(void);
>> =C2=A0 extern void its_init(void);
>> =C2=A0 extern int its_parse_baser(int i, struct its_baser *baser);
>> =C2=A0 extern struct its_baser *its_lookup_baser(int type);
>> +extern void its_enable_defaults(void);
>> =C2=A0 =C2=A0 #else /* __arm__ */
>> =C2=A0 diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> index 2c0ce13..d1e7e52 100644
>> --- a/lib/arm/gic-v3-its.c
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -86,3 +86,92 @@ void its_init(void)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 its_parse_baser=
(i, &its_data.baser[i]);
>> =C2=A0 }
>> =C2=A0 +static void its_setup_baser(int i, struct its_baser *baser)
>> +{
>> +=C2=A0=C2=A0=C2=A0 unsigned long n =3D (baser->nr_pages * baser->psz)=
 >> PAGE_SHIFT;
>> +=C2=A0=C2=A0=C2=A0 unsigned long order =3D is_power_of_2(n) ? fls(n) =
: fls(n) + 1;
>> +=C2=A0=C2=A0=C2=A0 u64 val;
>> +
>> +=C2=A0=C2=A0=C2=A0 baser->table_addr =3D (u64)virt_to_phys(alloc_page=
s(order));
>> +
>> +=C2=A0=C2=A0=C2=A0 val =3D ((u64)baser->table_addr=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((u64)baser->type=C2=A0=C2=
=A0=C2=A0 << GITS_BASER_TYPE_SHIFT)=C2=A0=C2=A0=C2=A0 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((u64)(baser->esz - 1)=C2=A0=
=C2=A0=C2=A0 << GITS_BASER_ENTRY_SIZE_SHIFT)=C2=A0=C2=A0=C2=A0 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((baser->nr_pages - 1)=C2=A0=
=C2=A0=C2=A0 << GITS_BASER_PAGES_SHIFT)=C2=A0=C2=A0=C2=A0 |
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u64)baser->indirect=C2=A0=
=C2=A0=C2=A0 << 62=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
>=20
> I haven't seen the 'nr_pages' and 'indirect' are programmed anywhere
> except in its_parse_baser(). It looks like they're treated as RO (but
> they shouldn't) and I now don't think it makes sense to parse them in
> its_parse_baser(), in patch#5.

First of all please forgive me for the delay.

I agree with you on nr_pages. However indirect also indicates the BASER
capability to support or not 2 level tables. So I think it makes sense
to read it on init.
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u64)baser->valid=C2=A0=C2=
=A0=C2=A0 << 63);
>> +
>> +=C2=A0=C2=A0=C2=A0 switch (baser->psz) {
>> +=C2=A0=C2=A0=C2=A0 case SZ_4K:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val |=3D GITS_BASER_PAGE_S=
IZE_4K;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 case SZ_16K:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val |=3D GITS_BASER_PAGE_S=
IZE_16K;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 case SZ_64K:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val |=3D GITS_BASER_PAGE_S=
IZE_64K;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 writeq(val, gicv3_its_base() + GITS_BASER + i * 8)=
;
>> +}
>> +
>> +/**
>> + * init_cmd_queue: Allocate the command queue and initialize
>> + * CBASER, CREADR, CWRITER
>=20
> no 'CREADR'.
OK

Thanks

Eric
>=20
>=20
> Thanks,
> Zenghui
>=20

