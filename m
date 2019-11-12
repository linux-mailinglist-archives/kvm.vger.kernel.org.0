Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7019BF9100
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKLNtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 08:49:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48752 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726946AbfKLNtY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 08:49:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573566563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pE+UPzYK/83Xgn5Oal6kD+8qNIvBjohPXIrqziRsjnc=;
        b=X05+12TrCphJYyq/KdYgZ5CShtMq/BhUgvOQALwSHyJ5hBGzeaQRJEKnhXb8E38b7bjQVZ
        f5zLRukz5had4NvRtvlAcGindMvPlNUtqtuz9grg0uUGi+AWemyKmSj/Sl/chmRZ2LGskw
        WzGuqv7/0CydSfG09jyYYsu+FCNIr8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-s-rOSYUdMzOJ8X686Yd9OQ-1; Tue, 12 Nov 2019 08:49:20 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 121E180B732;
        Tue, 12 Nov 2019 13:49:19 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E55A28D1E;
        Tue, 12 Nov 2019 13:49:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 03/17] arm: gic: Provide per-IRQ helper
 functions
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-4-andre.przywara@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9ce6a73d-8e37-8144-b65e-b1ba7140dae5@redhat.com>
Date:   Tue, 12 Nov 2019 14:49:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-4-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: s-rOSYUdMzOJ8X686Yd9OQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre

On 11/8/19 3:42 PM, Andre Przywara wrote:
> A common theme when accessing per-IRQ parameters in the GIC distributor
> is to set fields of a certain bit width in a range of MMIO registers.
> Examples are the enabled status (one bit per IRQ), the level/edge
> configuration (2 bits per IRQ) or the priority (8 bits per IRQ).
>=20
> Add a generic helper function which is able to mask and set the
> respective number of bits, given the IRQ number and the MMIO offset.
> Provide wrappers using this function to easily allow configuring an IRQ.
>=20
> For now assume that private IRQ numbers always refer to the current CPU.
> In a GICv2 accessing the "other" private IRQs is not easily doable (the
> registers are banked per CPU on the same MMIO address), so we impose the
> same limitation on GICv3, even though those registers are not banked
> there anymore.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  lib/arm/asm/gic-v3.h |  1 +
>  lib/arm/asm/gic.h    |  9 +++++
>  lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
>=20
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index ed6a5ad..8cfaed1 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -23,6 +23,7 @@
>  #define GICD_CTLR_ENABLE_G1A=09=09(1U << 1)
>  #define GICD_CTLR_ENABLE_G1=09=09(1U << 0)
> =20
> +#define GICD_IROUTER=09=09=090x6000
>  #define GICD_PIDR2=09=09=090xffe8
> =20
>  /* Re-Distributor registers, offsets from RD_base */
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 1fc10a0..21cdb58 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -15,6 +15,7 @@
>  #define GICD_IIDR=09=09=090x0008
>  #define GICD_IGROUPR=09=09=090x0080
>  #define GICD_ISENABLER=09=09=090x0100
> +#define GICD_ICENABLER=09=09=090x0180
>  #define GICD_ISPENDR=09=09=090x0200
>  #define GICD_ICPENDR=09=09=090x0280
>  #define GICD_ISACTIVER=09=09=090x0300
> @@ -73,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
>  extern void gic_ipi_send_single(int irq, int cpu);
>  extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
> =20
> +void gic_set_irq_bit(int irq, int offset);
> +void gic_enable_irq(int irq);
> +void gic_disable_irq(int irq);
> +void gic_set_irq_priority(int irq, u8 prio);
> +void gic_set_irq_target(int irq, int cpu);
> +void gic_set_irq_group(int irq, int group);
> +int gic_get_irq_group(int irq);
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_GIC_H_ */
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 9430116..cf4e811 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *des=
t)
>  =09assert(gic_common_ops && gic_common_ops->ipi_send_mask);
>  =09gic_common_ops->ipi_send_mask(irq, dest);
>  }
> +
> +enum gic_bit_access {
> +=09ACCESS_READ,
> +=09ACCESS_SET,
> +=09ACCESS_RMW
> +};
> +
> +static u8 gic_masked_irq_bits(int irq, int offset, int bits, u8 value,
> +=09=09=09      enum gic_bit_access access)
> +{
> +=09void *base;
> +=09int split =3D 32 / bits;
> +=09int shift =3D (irq % split) * bits;
> +=09u32 reg, mask =3D ((1U << bits) - 1) << shift;
> +
> +=09switch (gic_version()) {
> +=09case 2:
> +=09=09base =3D gicv2_dist_base();
> +=09=09break;
> +=09case 3:
> +=09=09if (irq < 32)
> +=09=09=09base =3D gicv3_sgi_base();
> +=09=09else
> +=09=09=09base =3D gicv3_dist_base();
> +=09=09break;
> +=09default:
> +=09=09return 0;
> +=09}
> +=09base +=3D offset + (irq / split) * 4;
> +
> +=09switch (access) {
> +=09case ACCESS_READ:
> +=09=09return (readl(base) & mask) >> shift;
> +=09case ACCESS_SET:
> +=09=09reg =3D 0;
> +=09=09break;
> +=09case ACCESS_RMW:
> +=09=09reg =3D readl(base) & ~mask;
> +=09=09break;
> +=09}
> +
> +=09writel(reg | ((u32)value << shift), base);
value & mask may be safer
> +
> +=09return 0;
> +}
> +
> +void gic_set_irq_bit(int irq, int offset)
> +{
> +=09gic_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET);
Why don't we use ACCESS_RMW?
> +}
> +
> +void gic_enable_irq(int irq)
> +{
> +=09gic_set_irq_bit(irq, GICD_ISENABLER);
here we just want to touch one bit and not erase other bits in the word?
> +}
> +
> +void gic_disable_irq(int irq)
> +{
> +=09gic_set_irq_bit(irq, GICD_ICENABLER);
> +}
> +
> +void gic_set_irq_priority(int irq, u8 prio)
> +{
> +=09gic_masked_irq_bits(irq, GICD_IPRIORITYR, 8, prio, ACCESS_RMW);
> +}
> +
> +void gic_set_irq_target(int irq, int cpu)
> +{
> +=09if (irq < 32)
> +=09=09return;
> +
> +=09if (gic_version() =3D=3D 2) {
> +=09=09gic_masked_irq_bits(irq, GICD_ITARGETSR, 8, 1U << cpu,
> +=09=09=09=09    ACCESS_RMW);
> +
> +=09=09return;
> +=09}
> +
> +=09writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
> +}
> +
> +void gic_set_irq_group(int irq, int group)
> +{
> +=09gic_masked_irq_bits(irq, GICD_IGROUPR, 1, group, ACCESS_RMW);
> +}
> +
> +int gic_get_irq_group(int irq)
> +{
> +=09return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
> +}
>=20
Thanks

Eric

