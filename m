Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234BCF94C3
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 16:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfKLPxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 10:53:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726008AbfKLPxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 10:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573574009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XTmFUarj8lucQryXTKa68ejaJ1XPqldN+7/k1/pkVrY=;
        b=fO1KoNbFwRtr9dwp8uKlkHitUEWAtgjcGdJdp5uv8gaC/dIazjEWGwqCVnt22Idip0W41T
        TrpQIGupe99fBVcKHBLnHmPyoMHRnDPQr2q0ftWkr5GFucNvQYLv7IkJY9AjAANXZQz6ki
        CHLkHC9KS75z3DxY6YlvUztyER4LnhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-CIbTbeJFMsukokw-KtcO-Q-1; Tue, 12 Nov 2019 10:53:27 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B000107ACC4;
        Tue, 12 Nov 2019 15:53:26 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 694E66117D;
        Tue, 12 Nov 2019 15:53:23 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 03/17] arm: gic: Provide per-IRQ helper
 functions
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-4-andre.przywara@arm.com>
 <9cc460d1-c01f-6b0a-c6be-292a63174d68@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <bcdc76b2-3549-94fe-1070-8a8198e22a63@redhat.com>
Date:   Tue, 12 Nov 2019 16:53:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <9cc460d1-c01f-6b0a-c6be-292a63174d68@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: CIbTbeJFMsukokw-KtcO-Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 11/12/19 1:51 PM, Alexandru Elisei wrote:
> Hi,
>=20
> On 11/8/19 2:42 PM, Andre Przywara wrote:
>> A common theme when accessing per-IRQ parameters in the GIC distributor
>> is to set fields of a certain bit width in a range of MMIO registers.
>> Examples are the enabled status (one bit per IRQ), the level/edge
>> configuration (2 bits per IRQ) or the priority (8 bits per IRQ).
>>
>> Add a generic helper function which is able to mask and set the
>> respective number of bits, given the IRQ number and the MMIO offset.
>> Provide wrappers using this function to easily allow configuring an IRQ.
>>
>> For now assume that private IRQ numbers always refer to the current CPU.
>> In a GICv2 accessing the "other" private IRQs is not easily doable (the
>> registers are banked per CPU on the same MMIO address), so we impose the
>> same limitation on GICv3, even though those registers are not banked
>> there anymore.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  lib/arm/asm/gic-v3.h |  1 +
>>  lib/arm/asm/gic.h    |  9 +++++
>>  lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 100 insertions(+)
>>
>> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
>> index ed6a5ad..8cfaed1 100644
>> --- a/lib/arm/asm/gic-v3.h
>> +++ b/lib/arm/asm/gic-v3.h
>> @@ -23,6 +23,7 @@
>>  #define GICD_CTLR_ENABLE_G1A=09=09(1U << 1)
>>  #define GICD_CTLR_ENABLE_G1=09=09(1U << 0)
>> =20
>> +#define GICD_IROUTER=09=09=090x6000
>>  #define GICD_PIDR2=09=09=090xffe8
>> =20
>>  /* Re-Distributor registers, offsets from RD_base */
>> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
>> index 1fc10a0..21cdb58 100644
>> --- a/lib/arm/asm/gic.h
>> +++ b/lib/arm/asm/gic.h
>> @@ -15,6 +15,7 @@
>>  #define GICD_IIDR=09=09=090x0008
>>  #define GICD_IGROUPR=09=09=090x0080
>>  #define GICD_ISENABLER=09=09=090x0100
>> +#define GICD_ICENABLER=09=09=090x0180
>>  #define GICD_ISPENDR=09=09=090x0200
>>  #define GICD_ICPENDR=09=09=090x0280
>>  #define GICD_ISACTIVER=09=09=090x0300
>> @@ -73,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
>>  extern void gic_ipi_send_single(int irq, int cpu);
>>  extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
>> =20
>> +void gic_set_irq_bit(int irq, int offset);
>> +void gic_enable_irq(int irq);
>> +void gic_disable_irq(int irq);
>> +void gic_set_irq_priority(int irq, u8 prio);
>> +void gic_set_irq_target(int irq, int cpu);
>> +void gic_set_irq_group(int irq, int group);
>> +int gic_get_irq_group(int irq);
>> +
>>  #endif /* !__ASSEMBLY__ */
>>  #endif /* _ASMARM_GIC_H_ */
>> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
>> index 9430116..cf4e811 100644
>> --- a/lib/arm/gic.c
>> +++ b/lib/arm/gic.c
>> @@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *de=
st)
>>  =09assert(gic_common_ops && gic_common_ops->ipi_send_mask);
>>  =09gic_common_ops->ipi_send_mask(irq, dest);
>>  }
>> +
>> +enum gic_bit_access {
>> +=09ACCESS_READ,
>> +=09ACCESS_SET,
>> +=09ACCESS_RMW
>> +};
>> +
>> +static u8 gic_masked_irq_bits(int irq, int offset, int bits, u8 value,
>> +=09=09=09      enum gic_bit_access access)
>> +{
>> +=09void *base;
>> +=09int split =3D 32 / bits;
>> +=09int shift =3D (irq % split) * bits;
>> +=09u32 reg, mask =3D ((1U << bits) - 1) << shift;
>> +
>> +=09switch (gic_version()) {
>> +=09case 2:
>> +=09=09base =3D gicv2_dist_base();
>> +=09=09break;
>> +=09case 3:
>> +=09=09if (irq < 32)
>> +=09=09=09base =3D gicv3_sgi_base();
>> +=09=09else
>> +=09=09=09base =3D gicv3_dist_base();
>> +=09=09break;
>> +=09default:
>> +=09=09return 0;
>> +=09}
>> +=09base +=3D offset + (irq / split) * 4;
>=20
> This is probably not what you intended, if irq =3D 4 and split =3D 8, (ir=
q / split) *
> 4 =3D 0. On the other hand, irq * 4 / split =3D 2.

I think that's correct. if bits =3D 4 this means there are 8 of such
fields in a word and the field corresponding to irq=3D4 is indeed located
in word 0.

Thanks

Eric
>=20
>> +
>> +=09switch (access) {
>> +=09case ACCESS_READ:
>> +=09=09return (readl(base) & mask) >> shift;
>> +=09case ACCESS_SET:
>> +=09=09reg =3D 0;
>> +=09=09break;
>> +=09case ACCESS_RMW:
>> +=09=09reg =3D readl(base) & ~mask;
>> +=09=09break;
>> +=09}
>> +
>> +=09writel(reg | ((u32)value << shift), base);
>> +
>> +=09return 0;
>> +}
> This function looks a bit out of place:
> - the function name has a verb in the past tense ('masked'), which makes =
me think
> it should return a bool, but the function actually performs an access to =
a GIC
> register.
> - the return value is an u8, but it returns an u32 on a read, because rea=
dl
> returns an u32.
> - the semantics of the function and the return value change based on the =
access
> parameter; worse yet, the return value on a write is completely ignored b=
y the
> callers and the value parameter is ignored on reads.
>=20
> You could split it into separate functions - see below.
>=20
>> +
>> +void gic_set_irq_bit(int irq, int offset)
>> +{
>> +=09gic_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET);
>> +}
>> +
>> +void gic_enable_irq(int irq)
>> +{
>> +=09gic_set_irq_bit(irq, GICD_ISENABLER);
>> +}
>> +
>> +void gic_disable_irq(int irq)
>> +{
>> +=09gic_set_irq_bit(irq, GICD_ICENABLER);
>> +}
>> +
>> +void gic_set_irq_priority(int irq, u8 prio)
>> +{
>> +=09gic_masked_irq_bits(irq, GICD_IPRIORITYR, 8, prio, ACCESS_RMW);
>> +}
>> +
>> +void gic_set_irq_target(int irq, int cpu)
>> +{
>> +=09if (irq < 32)
>> +=09=09return;
>> +
>> +=09if (gic_version() =3D=3D 2) {
>> +=09=09gic_masked_irq_bits(irq, GICD_ITARGETSR, 8, 1U << cpu,
>> +=09=09=09=09    ACCESS_RMW);
>> +
>> +=09=09return;
>> +=09}
>> +
>> +=09writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
>> +}
>> +
>> +void gic_set_irq_group(int irq, int group)
>> +{
>> +=09gic_masked_irq_bits(irq, GICD_IGROUPR, 1, group, ACCESS_RMW);
>> +}
>> +
>> +int gic_get_irq_group(int irq)
>> +{
>> +=09return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
>> +}
>=20
> The pattern for the public functions in this file is to check that the GI=
C has
> been initialized (assert(gic_common_ops)).
>=20
> I propose we rewrite the functions like this (compile tested only):
>=20
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 94301169215c..1f5aa7b48828 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -146,3 +146,89 @@ void gic_ipi_send_mask(int irq, const cpumask_t *des=
t)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops && gic_c=
ommon_ops->ipi_send_mask);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gic_common_ops->ipi_send_mask(=
irq, dest);
> =C2=A0}
> +
> +static void *gic_get_irq_reg(int irq, int offset, int width)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *base;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (gic_version()) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 2:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 base =3D gicv2_dist_base();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 break;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 3:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (irq < 32)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 base =3D gicv3=
_sgi_base();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 base =3D gicv3=
_dist_base();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 break;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return 0;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return base + offset + (irq * width=
 / 32);
> +}
> +
> +static void gic_set_irq_field(int irq, int offset, int width, u32 value)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *reg;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 val;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int shift =3D (irq * width) % 32;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 mask =3D ((1U << width) - 1) <<=
 shift;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg =3D gic_get_irq_reg(irq, offset=
, width);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D readl(reg);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D (val & ~mask) | (value << s=
hift);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writel(val, reg);
> +}
> +
> +void gic_enable_irq(int irq)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gic_set_irq_field(irq, GICD_ISENABL=
ER, 1, 1);
> +}
> +
> +void gic_disable_irq(int irq)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gic_set_irq_field(irq, GICD_ICENABL=
ER, 1, 1);
> +}
> +
> +void gic_set_irq_priority(int irq, u8 prio)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gic_set_irq_field(irq, GICD_IPRIORI=
TYR, 8, prio);
> +}
> +
> +void gic_set_irq_target(int irq, int cpu)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (irq < 32)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (gic_version() =3D=3D 2) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 gic_set_irq_field(irq, GICD_ITARGETSR, 8, 1U << cpu);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 return;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 writeq(cpus[cpu], gicv3_dist_base()=
 + GICD_IROUTER + irq * 8);
> +}
> +
> +void gic_set_irq_group(int irq, int group)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gic_set_irq_field(irq, GICD_IGROUPR=
, 1, 1);
> +}
> +
> +int gic_get_irq_group(int irq)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *reg;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 val;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int shift =3D irq % 32;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(gic_common_ops);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg =3D gic_get_irq_reg(irq, GICD_I=
GROUPR, 1);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D readl(reg);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return (val >> shift) & 0x1;
> +}
>=20
> A bit more lines of code, but to me more readable. What do you think?
>=20
>=20
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>=20

