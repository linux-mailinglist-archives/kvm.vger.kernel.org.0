Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92907181A1F
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 14:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgCKNth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 09:49:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32268 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729512AbgCKNth (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 09:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583934575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JsvML7TjAQJWusNVkCpKgOQx6lENNDL9bm3AiV1RPfc=;
        b=FtHMMYqcx71j1Q1XV3hxocOLcKCMQ+nSS+rhYs8VvhVa1276naiKcUZbSFAO23tX53vXne
        xNlbvS/7XB3/yaVx8qPdfjuydHQUNy+8LrUwIgGe4YvwQZSL7OJOuuT+4e/v+4O9fUbxRy
        Fni/+nMxgNyigv5pU06xUKCcqdZ1Gh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-49vmNWx9MBC47vDTZl3Pig-1; Wed, 11 Mar 2020 09:49:31 -0400
X-MC-Unique: 49vmNWx9MBC47vDTZl3Pig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A9C01137841;
        Wed, 11 Mar 2020 13:49:29 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 397A692D2C;
        Wed, 11 Mar 2020 13:49:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 13/13] arm/arm64: ITS: pending table
 migration test
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com,
        thuth@redhat.com
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-14-eric.auger@redhat.com>
 <54139b63-3a1d-7276-4d0b-4d38f9901536@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <96f01985-6515-8501-2b14-c8f91dcdfa81@redhat.com>
Date:   Wed, 11 Mar 2020 14:49:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <54139b63-3a1d-7276-4d0b-4d38f9901536@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/20 1:07 PM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/10 22:54, Eric Auger wrote:
>> Add two new migration tests. One testing the migration of
>> a topology where collection were unmapped. The second test
>> checks the migration of the pending table.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v4 -> v5:
>> - move stub from header to arm/gic.c
>>
>> v3 -> v4:
>> - do not talk about odd/even CPUs, use pe0 and pe1
>> - comment the delay
>>
>> v2 -> v3:
>> - tests belong to both its and migration groups
>> - use LPI(i)
>> - gicv3_lpi_set_pending_table_bit renamed into gicv3_lpi_set_clr_pendi=
ng
>> ---
>> =C2=A0 arm/gic.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 146=
 ++++++++++++++++++++++++++++++++++++++++++++++
>> =C2=A0 arm/unittests.cfg |=C2=A0 16 +++++
>> =C2=A0 2 files changed, 162 insertions(+)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index b8fbc13..e6ffbc3 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -193,6 +193,7 @@ static void lpi_handler(struct pt_regs *regs
>> __unused)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smp_rmb(); /* pairs with wmb in lpi_sta=
ts_expect */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lpi_stats.observed.cpu_id =3D smp_proce=
ssor_id();
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lpi_stats.observed.lpi_id =3D irqnr;
>> +=C2=A0=C2=A0=C2=A0 acked[lpi_stats.observed.cpu_id]++;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smp_wmb(); /* pairs with rmb in check_l=
pi_stats */
>> =C2=A0 }
>> =C2=A0 @@ -236,6 +237,22 @@ static void secondary_lpi_test(void)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (1)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wfi();
>> =C2=A0 }
>> +
>> +static void check_lpi_hits(int *expected, const char *msg)
>> +{
>> +=C2=A0=C2=A0=C2=A0 bool pass =3D true;
>> +=C2=A0=C2=A0=C2=A0 int i;
>> +
>> +=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < nr_cpus; i++) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (acked[i] !=3D expected=
[i]) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
port_info("expected %d LPIs on PE #%d, %d observed",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 expected[i], i, acked[i]);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pa=
ss =3D false;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 report(pass, "%s", msg);
>> +}
>> =C2=A0 #endif
>> =C2=A0 =C2=A0 static void gicv2_ipi_send_self(void)
>> @@ -591,6 +608,8 @@ static void gic_test_mmio(void)
>> =C2=A0 static void test_its_introspection(void) {}
>> =C2=A0 static void test_its_trigger(void) {}
>> =C2=A0 static void test_its_migration(void) {}
>> +static void test_its_pending_migration(void) {}
>> +static void test_migrate_unmapped_collection(void) {}
>> =C2=A0 =C2=A0 #else /* __aarch64__ */
>> =C2=A0 @@ -659,6 +678,17 @@ static int its_prerequisites(int nb_cpus)
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
>> +
>> +=C2=A0=C2=A0=C2=A0 gicv3_lpi_set_config(physid, LPI_PROP_DEFAULT);
>> +=C2=A0=C2=A0=C2=A0 its_send_invall(col);
>=20
> Again, the col hasn't been mapped currently.
right. Moving it outside of the helper then
>=20
>> +}
>> +
>> =C2=A0 /*
>> =C2=A0=C2=A0 * Setup the configuration for those mappings:
>> =C2=A0=C2=A0 * dev_id=3D2 event=3D20 -> vcpu 3, intid=3D8195
>> @@ -799,6 +829,114 @@ static void test_its_migration(void)
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
>> +=C2=A0=C2=A0=C2=A0 int pe0 =3D nr_cpus - 1;
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
>> +
>> +=C2=A0=C2=A0=C2=A0 puts("Now migrate the VM, then press a key to cont=
inue...\n");
>> +=C2=A0=C2=A0=C2=A0 (void)getchar();
>> +=C2=A0=C2=A0=C2=A0 report_info("Migration complete");
>> +
>> +=C2=A0=C2=A0=C2=A0 /* on the destination, map the collection */
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(col, true);
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
>> +
>> +=C2=A0=C2=A0=C2=A0 /* unmap the collection */
>> +=C2=A0=C2=A0=C2=A0 its_send_mapc(col, false);
>=20
> Again, behavior is unpredictable.
yep removing that test.
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 lpi_stats_expect(-1, -1);
>> +=C2=A0=C2=A0=C2=A0 its_send_int(dev2, 0);
>> +=C2=A0=C2=A0=C2=A0 check_lpi_stats("no LPI triggered after collection=
 unmapping");
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
>> +=C2=A0=C2=A0=C2=A0 /* Set the PTZ bit on each pendbaser */
>=20
> 'Clear' the PTZ.
yep
>=20
> Otherwise looks good!

Thank you for your careful review!

Best Regards

Eric
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 expected[pe0] =3D 128;
>> +=C2=A0=C2=A0=C2=A0 expected[pe1] =3D 128;
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
> Thanks,
> Zenghui
>=20

