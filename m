Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36D197C19
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 14:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgC3Mir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 08:38:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25746 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730064AbgC3Mir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 08:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585571925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4cUzeidLCschmMx+521qeR+2AGe9fkhbWsqAhHXFkg=;
        b=Jei6MkZohwWkaJ0GFaOPY+9Wyuch94fZKKz9l/VPvrNx7L66Ahn45CvhnAYmYUu3pFt7C6
        JDq9n8Dt6Veurj2Hkx7F1+EqAurISyI1pD/VQcwynZuezHaHizoT+7eddi1kxwmQMLpOS3
        QuXk5q/T9LzJ51K/TLzeUwlEFUWBOoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-e6d9mGMXOOW6hD0m0hqhTQ-1; Mon, 30 Mar 2020 08:38:41 -0400
X-MC-Unique: e6d9mGMXOOW6hD0m0hqhTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A27618AB2C4;
        Mon, 30 Mar 2020 12:38:40 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89E3C5DA66;
        Mon, 30 Mar 2020 12:38:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 13/13] arm/arm64: ITS: pending table
 migration test
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, thuth@redhat.com, alexandru.elisei@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-14-eric.auger@redhat.com>
 <296c574b-810c-9c90-a613-df732a9ac193@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ea74559c-2ab4-752c-e587-2bf40eab14b0@redhat.com>
Date:   Mon, 30 Mar 2020 14:38:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <296c574b-810c-9c90-a613-df732a9ac193@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/30/20 2:06 PM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/20 17:24, Eric Auger wrote:
>> Add two new migration tests. One testing the migration of
>> a topology where collection were unmapped. The second test
>> checks the migration of the pending table.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>=20
> [...]
>=20
>> @@ -659,6 +678,15 @@ static int its_prerequisites(int nb_cpus)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> =C2=A0 }
>> =C2=A0 +static void set_lpi(struct its_device *dev, u32 eventid, u32 p=
hysid,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 st=
ruct its_collection *col)
>> +{
>> +=C2=A0=C2=A0=C2=A0 assert(dev && col);
>> +
>> +=C2=A0=C2=A0=C2=A0 its_send_mapti(dev, physid, eventid, col);
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(physid, LPI_PROP_DEFAULT);
>> +}
>=20
> I'd say we can just drop this helper and open-code it anywhere
> necessarily. The name 'set_lpi' doesn't tell me too much about
> what has been implemented inside the helper.
>=20
>> +
>> =C2=A0 /*
>> =C2=A0=C2=A0 * Setup the configuration for those mappings:
>> =C2=A0=C2=A0 * dev_id=3D2 event=3D20 -> vcpu 3, intid=3D8195
>> @@ -790,6 +818,108 @@ static void test_its_migration(void)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 its_send_int(dev7, 255);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev7/eventid=3D255 tri=
ggers LPI 8196 on PE #2
>> after migration");
>> =C2=A0 }
>> +
>> +static void test_migrate_unmapped_collection(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct its_collection *col;
>> +=C2=A0=C2=A0=C2=A0 struct its_device *dev2, *dev7;
>> +=C2=A0=C2=A0=C2=A0 int pe0 =3D 0;
>> +=C2=A0=C2=A0=C2=A0 u8 config;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (its_setup1())
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> +
>> +=C2=A0=C2=A0=C2=A0 col =3D its_create_collection(pe0, pe0);
>> +=C2=A0=C2=A0=C2=A0 dev2 =3D its_get_device(2);
>> +=C2=A0=C2=A0=C2=A0 dev7 =3D its_get_device(7);
>> +
>> +=C2=A0=C2=A0=C2=A0 /* MAPTI with the collection unmapped */
>> +=C2=A0=C2=A0=C2=A0 set_lpi(dev2, 0, 8192, col);
>=20
> ... and it's only invoked here.
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 puts("Now migrate the VM, then press a key to cont=
inue...\n");
>> +=C2=A0=C2=A0=C2=A0 (void)getchar();
>> +=C2=A0=C2=A0=C2=A0 report_info("Migration complete");
>> +
>> +=C2=A0=C2=A0=C2=A0 /* on the destination, map the collection */
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(col, true);
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col);
>> +
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(2, 8196);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev7, 255);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev7/eventid=3D 255 triggered LPI=
 8196 on PE #2");
>> +
>> +=C2=A0=C2=A0=C2=A0 config =3D gicv3_lpi_get_config(8192);
>> +=C2=A0=C2=A0=C2=A0 report(config =3D=3D LPI_PROP_DEFAULT,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "Config =
of LPI 8192 was properly migrated");
>> +
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(pe0, 8192);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 0);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("dev2/eventid =3D 0 triggered LPI =
8192 on PE0");
>> +}
>> +
>> +static void test_its_pending_migration(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct its_device *dev;
>> +=C2=A0=C2=A0=C2=A0 struct its_collection *collection[2];
>> +=C2=A0=C2=A0=C2=A0 int *expected =3D malloc(nr_cpus * sizeof(int));
>> +=C2=A0=C2=A0=C2=A0 int pe0 =3D nr_cpus - 1, pe1 =3D nr_cpus - 2;
>> +=C2=A0=C2=A0=C2=A0 u64 pendbaser;
>> +=C2=A0=C2=A0=C2=A0 void *ptr;
>> +=C2=A0=C2=A0=C2=A0 int i;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (its_prerequisites(4))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> +
>> +=C2=A0=C2=A0=C2=A0 dev =3D its_create_device(2 /* dev id */, 8 /* nb_=
ites */);
>> +=C2=A0=C2=A0=C2=A0 its_send_mapd(dev, true);
>> +
>> +=C2=A0=C2=A0=C2=A0 collection[0] =3D its_create_collection(pe0, pe0);
>> +=C2=A0=C2=A0=C2=A0 collection[1] =3D its_create_collection(pe1, pe1);
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(collection[0], true);
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(collection[1], true);
>> +
>> +=C2=A0=C2=A0=C2=A0 /* disable lpi at redist level */
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_rdist_disable(pe0);
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_rdist_disable(pe1);
>> +
>> +=C2=A0=C2=A0=C2=A0 /* lpis are interleaved inbetween the 2 PEs */
>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 256; i++) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_collection *col=
 =3D i % 2 ? collection[0] :
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 collection[1];
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int vcpu =3D col->target_a=
ddress >> 16;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 its_send_mapti(dev, LPI(i)=
, i, col);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(LPI(i=
), LPI_PROP_DEFAULT);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_clr_pending(=
vcpu, LPI(i), true);
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(collection[0]);
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(collection[1]);
>> +
>> +=C2=A0=C2=A0=C2=A0 /* Clear the PTZ bit on each pendbaser */
>> +
>> +=C2=A0=C2=A0=C2=A0 expected[pe0] =3D 128;
>> +=C2=A0=C2=A0=C2=A0 expected[pe1] =3D 128;
>=20
> Do we need to initialize expected[] for other PEs? Or it has always
> been zeroed by the kvm-unit-tests implementation of malloc()?
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 ptr =3D gicv3_data.redist_base[pe0] + GICR_PENDBAS=
ER;
>> +=C2=A0=C2=A0=C2=A0 pendbaser =3D readq(ptr);
>> +=C2=A0=C2=A0=C2=A0 writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>> +
>> +=C2=A0=C2=A0=C2=A0 ptr =3D gicv3_data.redist_base[pe1] + GICR_PENDBAS=
ER;
>> +=C2=A0=C2=A0=C2=A0 pendbaser =3D readq(ptr);
>> +=C2=A0=C2=A0=C2=A0 writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>> +
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_rdist_enable(pe0);
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_rdist_enable(pe1);
>=20
> I don't know how the migration gets implemented in kvm-unit-tests.
> But is there any guarantee that the LPIs will only be triggered on the
> destination side? As once the EnableLPIs bit becomes 1, VGIC will start
> reading the pending bit in guest memory and potentially injecting LPIs
> into the target vcpu (in the source side).

I expect some LPIs to hit on source and some others to hit on the
destination. To me, this does not really matter as long as the handlers
gets called and accumulate the stats. Given the number of LPIs, we will
at least test the migration of some of the pending bits and especially
adjacent ones. It does work as it allows to test your fix:

ca185b260951  KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Thanks

Eric
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 puts("Now migrate the VM, then press a key to cont=
inue...\n");
>> +=C2=A0=C2=A0=C2=A0 (void)getchar();
>> +=C2=A0=C2=A0=C2=A0 report_info("Migration complete");
>> +
>> +=C2=A0=C2=A0=C2=A0 /* let's wait for the 256 LPIs to be handled */
>> +=C2=A0=C2=A0=C2=A0 mdelay(1000);
>> +
>> +=C2=A0=C2=A0=C2=A0 check_lpi_hits(expected, "128 LPIs on both PE0 and=
 PE1 after
>> migration");
>> +}
>=20
>=20
> Thanks,
> Zenghui
>=20
>=20

