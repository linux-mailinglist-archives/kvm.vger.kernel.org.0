Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F47F19328A
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 22:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgCYVU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 17:20:57 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55747 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbgCYVU5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 17:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585171255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5OAiw4H8RHcYJgUDa0Alkcr13a5bPAHpwGb7bMq8gRE=;
        b=UVW04CcL6UdYdXTiMA82P5SEQsX/U8XdtZlnk6qIm/+m1FioHXHkfQf972TIOug+4/mnc5
        zRsRRrmDzK+fwVxd1CFN2A6UwY5/sZ51Gmg+InAFthiTgfrlrce4Y6RNa/CO4PSc/UgWxx
        6IogNkC+w88J6TA7HitEEMt7k1oxMFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-TBF9AnAZOf6sXTlQ7Bb0AA-1; Wed, 25 Mar 2020 17:20:53 -0400
X-MC-Unique: TBF9AnAZOf6sXTlQ7Bb0AA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE36107ACCD;
        Wed, 25 Mar 2020 21:20:51 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 57E20100EBAA;
        Wed, 25 Mar 2020 21:20:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 08/13] arm/arm64: ITS: Device and
 collection Initialization
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, thuth@redhat.com, alexandru.elisei@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-9-eric.auger@redhat.com>
 <63f3d8aa-c1e3-f40f-32a1-fb6d22e70541@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c5ce7101-9ea3-8b04-7ec0-cb27dfbdc116@redhat.com>
Date:   Wed, 25 Mar 2020 22:20:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <63f3d8aa-c1e3-f40f-32a1-fb6d22e70541@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/25/20 9:10 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/20 17:24, Eric Auger wrote:
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
>> v3 -> v4:
>> - remove unused its_baser variable from its_create_device()
>> - use get_order()
>> - device->itt becomes a GVA instead of GPA
>>
>> v2 -> v3:
>> - s/report_abort/assert
>>
>> v1 -> v2:
>> - s/nb_/nr_
>> ---
>> =C2=A0 lib/arm64/asm/gic-v3-its.h | 19 +++++++++++++++++++
>> =C2=A0 lib/arm64/gic-v3-its.c=C2=A0=C2=A0=C2=A0=C2=A0 | 38 +++++++++++=
+++++++++++++++++++++++++++
>> =C2=A0 2 files changed, 57 insertions(+)
>>
>> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
>> index 4683011..adcb642 100644
>> --- a/lib/arm64/asm/gic-v3-its.h
>> +++ b/lib/arm64/asm/gic-v3-its.h
>> @@ -31,6 +31,19 @@ struct its_baser {
>> =C2=A0 };
>> =C2=A0 =C2=A0 #define GITS_BASER_NR_REGS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 8
>> +#define GITS_MAX_DEVICES=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8
>> +#define GITS_MAX_COLLECTIONS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 8
>> +
>> +struct its_device {
>> +=C2=A0=C2=A0=C2=A0 u32 device_id;=C2=A0=C2=A0=C2=A0 /* device ID */
>> +=C2=A0=C2=A0=C2=A0 u32 nr_ites;=C2=A0=C2=A0=C2=A0 /* Max Interrupt Tr=
anslation Entries */
>> +=C2=A0=C2=A0=C2=A0 void *itt;=C2=A0=C2=A0=C2=A0 /* Interrupt Translat=
ion Table GVA */
>> +};
>> +
>> +struct its_collection {
>> +=C2=A0=C2=A0=C2=A0 u64 target_address;
>> +=C2=A0=C2=A0=C2=A0 u16 col_id;
>> +};
>> =C2=A0 =C2=A0 struct its_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *base;
>> @@ -39,6 +52,10 @@ struct its_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_baser coll_baser;
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
>> @@ -93,5 +110,7 @@ extern void its_parse_typer(void);
>> =C2=A0 extern void its_init(void);
>> =C2=A0 extern int its_baser_lookup(int i, struct its_baser *baser);
>> =C2=A0 extern void its_enable_defaults(void);
>> +extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
>> +extern struct its_collection *its_create_collection(u32 col_id, u32
>> target_pe);
>=20
> Maybe use 'u16 col_id'?
fair enough. At this point, not sure this is worth a respin though ;-)
>=20
> Besides,
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Thanks!

Eric




>=20
>=20
> Thanks
>=20
>=20

