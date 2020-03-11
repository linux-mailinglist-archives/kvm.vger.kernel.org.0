Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AA0181410
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 10:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgCKJHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 05:07:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34877 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgCKJHs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 05:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583917666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90odkQRcEuNdf2jJohXDHYVWT8ef6QX7pd7255D7wy8=;
        b=TnGP2ZXfjzr1nlUoJqDjjnJLvT01j6ascktvdZEemzBTP/TY46HCS9WMUYLGYTo+IBIWLc
        uOxzLsKZvXwXzdehxSXdnCwUb/+oIzYsWq8j2iTbCkmqORydCLvgzsQ038TICegwWDk5TH
        XSxzojUzJwEZBscCJ1U5kik7H8vbf9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-isU5ogb3Pq-TV_LPOEpLBQ-1; Wed, 11 Mar 2020 05:07:42 -0400
X-MC-Unique: isU5ogb3Pq-TV_LPOEpLBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9F86107ACC4;
        Wed, 11 Mar 2020 09:07:40 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 695545D9C9;
        Wed, 11 Mar 2020 09:07:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 05/13] arm/arm64: gicv3: Set the LPI
 config and pending tables
To:     Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     andre.przywara@arm.com, drjones@redhat.com,
        alexandru.elisei@arm.com, thuth@redhat.com,
        peter.maydell@linaro.org
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-6-eric.auger@redhat.com>
 <cd3bab7d-a585-b091-621c-0ae712b82b3c@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <97357581-9712-b467-764c-d32f354b6f3c@redhat.com>
Date:   Wed, 11 Mar 2020 10:07:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cd3bab7d-a585-b091-621c-0ae712b82b3c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/11/20 7:42 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/10 22:54, Eric Auger wrote:
>> Allocate the LPI configuration and per re-distributor pending table.
>> Set redistributor's PROPBASER and PENDBASER. The LPIs are enabled
>> by default in the config table.
>>
>> Also introduce a helper routine that allows to set the pending table
>> bit for a given LPI.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v4 -> v5:
>> - Moved some reformattings previously done in
>> =C2=A0=C2=A0 "arm/arm64: ITS: its_enable_defaults", in this patch
>> - added assert(!gicv3_redist_base()) in gicv3_lpi_alloc_tables()
>> - revert for_each_present_cpu() change
>>
>> v2 -> v3:
>> - Move the helpers in lib/arm/gic-v3.c and prefix them with "gicv3_"
>> =C2=A0=C2=A0 and add _lpi prefix too
>>
>> v1 -> v2:
>> - remove memory attributes
>> ---
>> =C2=A0 lib/arm/asm/gic-v3.h | 15 +++++++++++++
>> =C2=A0 lib/arm/gic-v3.c=C2=A0=C2=A0=C2=A0=C2=A0 | 53 +++++++++++++++++=
+++++++++++++++++++++++++++
>> =C2=A0 2 files changed, 68 insertions(+)
>>
>> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
>> index 47df051..064cc68 100644
>> --- a/lib/arm/asm/gic-v3.h
>> +++ b/lib/arm/asm/gic-v3.h
>> @@ -50,6 +50,15 @@
>> =C2=A0 #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (MPIDR_AFFINITY_LEVEL(cluster_id, level=
) <<
>> ICC_SGI1R_AFFINITY_## level ## _SHIFT)
>> =C2=A0 +#define GICR_PROPBASER_IDBITS_MASK=C2=A0=C2=A0=C2=A0 (0x1f)
>=20
> Again this can be dropped, but not a problem.
OK
>=20
>> +
>> +#define GICR_PENDBASER_PTZ=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
BIT_ULL(62)
>> +
>> +#define LPI_PROP_GROUP1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 (1 << 1)
>> +#define LPI_PROP_ENABLED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (1=
 << 0)
>> +#define LPI_PROP_DEFAULT_PRIO=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 0xa0
>> +#define LPI_PROP_DEFAULT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (L=
PI_PROP_DEFAULT_PRIO |
>> LPI_PROP_GROUP1 | LPI_PROP_ENABLED)
>> +
>> =C2=A0 #include <asm/arch_gicv3.h>
>> =C2=A0 =C2=A0 #ifndef __ASSEMBLY__
>> @@ -66,6 +75,8 @@ struct gicv3_data {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *dist_base;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *redist_bases[GICV3_NR_REDISTS];
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *redist_base[NR_CPUS];
>> +=C2=A0=C2=A0=C2=A0 u8 *lpi_prop;
>> +=C2=A0=C2=A0=C2=A0 void *lpi_pend[NR_CPUS];
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int irq_nr;
>> =C2=A0 };
>> =C2=A0 extern struct gicv3_data gicv3_data;
>> @@ -82,6 +93,10 @@ extern void gicv3_write_eoir(u32 irqstat);
>> =C2=A0 extern void gicv3_ipi_send_single(int irq, int cpu);
>> =C2=A0 extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)=
;
>> =C2=A0 extern void gicv3_set_redist_base(size_t stride);
>> +extern void gicv3_lpi_set_config(int n, u8 val);
>> +extern u8 gicv3_lpi_get_config(int n);
>=20
> These two declarations can be dropped, and I think it's better to
> move their macro implementations here (they're now in patch #7).
> But also not a problem.
OK
>=20
>> +extern void gicv3_lpi_set_clr_pending(int rdist, int n, bool set);
>> +extern void gicv3_lpi_alloc_tables(void);
>> =C2=A0 =C2=A0 static inline void gicv3_do_wait_for_rwp(void *base)
>> =C2=A0 {
>> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
>> index feecb5e..d752bd4 100644
>> --- a/lib/arm/gic-v3.c
>> +++ b/lib/arm/gic-v3.c
>> @@ -5,6 +5,7 @@
>> =C2=A0=C2=A0 */
>> =C2=A0 #include <asm/gic.h>
>> =C2=A0 #include <asm/io.h>
>> +#include <alloc_page.h>
>> =C2=A0 =C2=A0 void gicv3_set_redist_base(size_t stride)
>> =C2=A0 {
>> @@ -147,3 +148,55 @@ void gicv3_ipi_send_single(int irq, int cpu)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask_set_cpu(cpu, &dest);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gicv3_ipi_send_mask(irq, &dest);
>> =C2=A0 }
>> +
>> +#if defined(__aarch64__)
>> +
>> +/*
>> + * alloc_lpi_tables - Allocate LPI config and pending tables
>> + * and set PROPBASER (shared by all rdistributors) and per
>> + * redistributor PENDBASER.
>> + *
>> + * gicv3_set_redist_base() must be called before
>> + */
>> +void gicv3_lpi_alloc_tables(void)
>> +{
>> +=C2=A0=C2=A0=C2=A0 unsigned long n =3D SZ_64K >> PAGE_SHIFT;
>> +=C2=A0=C2=A0=C2=A0 unsigned long order =3D fls(n);
>> +=C2=A0=C2=A0=C2=A0 u64 prop_val;
>> +=C2=A0=C2=A0=C2=A0 int cpu;
>> +
>> +=C2=A0=C2=A0=C2=A0 assert(!gicv3_redist_base());
>=20
> I guess you wanted assert(gicv3_redist_base())? With this confirmed,
damn, a last minute change I must have failed to test?! Indeed you're rig=
ht.
>=20
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Thanks!

>=20
>=20
> Thanks
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 gicv3_data.lpi_prop =3D alloc_pages(order);
>> +
>> +=C2=A0=C2=A0=C2=A0 /* ID bits =3D 13, ie. up to 14b LPI INTID */
>> +=C2=A0=C2=A0=C2=A0 prop_val =3D (u64)(virt_to_phys(gicv3_data.lpi_pro=
p)) | 13;
>> +
>> +=C2=A0=C2=A0=C2=A0 for_each_present_cpu(cpu) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 pend_val;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *ptr;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ptr =3D gicv3_data.redist_=
base[cpu];
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writeq(prop_val, ptr + GIC=
R_PROPBASER);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gicv3_data.lpi_pend[cpu] =3D=
 alloc_pages(order);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pend_val =3D (u64)(virt_to=
_phys(gicv3_data.lpi_pend[cpu]));
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writeq(pend_val, ptr + GIC=
R_PENDBASER);
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
>> +
>> +void gicv3_lpi_set_clr_pending(int rdist, int n, bool set)
>> +{
>> +=C2=A0=C2=A0=C2=A0 u8 *ptr =3D gicv3_data.lpi_pend[rdist];
>> +=C2=A0=C2=A0=C2=A0 u8 mask =3D 1 << (n % 8), byte;
>> +
>> +=C2=A0=C2=A0=C2=A0 ptr +=3D (n / 8);
>> +=C2=A0=C2=A0=C2=A0 byte =3D *ptr;
>> +=C2=A0=C2=A0=C2=A0 if (set)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 byte |=3D=C2=A0 mask;
>> +=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 byte &=3D ~mask;
>> +=C2=A0=C2=A0=C2=A0 *ptr =3D byte;
>> +}
>> +#endif /* __aarch64__ */
>>
>=20
>=20

