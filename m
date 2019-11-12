Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4749BF8FEC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKLMtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:49:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725847AbfKLMtu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 07:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573562989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvYcM7f3oL6WcKps2IjEC36+XCQGeg8zp1MVCMPdVfM=;
        b=Gx7ZgN/tjUOdAU+aSHeqGprEx38fI6bqVjO8cIGr3mINCadw3IxumlJhPQseCdF52zhmNd
        TPf8UMst6RouDxdLKv0wiCrP9bdyqjua8D6SJ1RIwCWRM66AYKzEwWMHF25v4xUjqFKnyt
        XWqyMnpeQ9TjMMJ27oivYEm/KXE1kug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-_AhoEWoDOA68FMcZsD6Vbw-1; Tue, 12 Nov 2019 07:49:48 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55707107ACC5;
        Tue, 12 Nov 2019 12:49:45 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61D905DDA8;
        Tue, 12 Nov 2019 12:49:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 01/17] arm: gic: Enable GIC MMIO tests for
 GICv3 as well
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-2-andre.przywara@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ee75ee48-c774-c2d8-2156-f9ed256733e6@redhat.com>
Date:   Tue, 12 Nov 2019 13:49:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-2-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: _AhoEWoDOA68FMcZsD6Vbw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 11/8/19 3:42 PM, Andre Przywara wrote:
> So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
> machines tend to have a GICv3-only GIC, so can't run those tests.
> It turns out that most GIC distributor registers we test in the unit
> tests are actually the same in GICv3, so we can just enable those tests
> for GICv3 guests as well.
> The only exception is the CPU number in the TYPER register, which is
> only valid in the GICv2 compat mode (ARE=3D0), which KVM does not support=
.
> So we protect this test against running on a GICv3 guest.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c            | 13 +++++++++++--
>  arm/unittests.cfg    | 26 ++++++++++++++++++++++----
>  lib/arm/asm/gic-v3.h |  2 ++
>  3 files changed, 35 insertions(+), 6 deletions(-)
>=20
> diff --git a/arm/gic.c b/arm/gic.c
> index adb6aa4..04b3337 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -6,6 +6,7 @@
>   *   + MMIO access tests
>   * GICv3
>   *   + test sending/receiving IPIs
> + *   + MMIO access tests
>   *
>   * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
>   *
> @@ -496,7 +497,14 @@ static void gic_test_mmio(void)
>  =09=09idreg =3D gic_dist_base + GICD_ICPIDR2;
>  =09=09break;
>  =09case 0x3:
> -=09=09report_abort("GICv3 MMIO tests NYI");
> +=09=09/*
> +=09=09 * We only test generic registers or those affecting
> +=09=09 * SPIs, so don't need to consider the SGI base in
> +=09=09 * the redistributor here.
> +=09=09 */
> +=09=09gic_dist_base =3D gicv3_dist_base();
> +=09=09idreg =3D gic_dist_base + GICD_PIDR2;
> +=09=09break;
>  =09default:
>  =09=09report_abort("GIC version %d not supported", gic_version());
>  =09}
> @@ -505,7 +513,8 @@ static void gic_test_mmio(void)
>  =09nr_irqs =3D GICD_TYPER_IRQS(reg);
>  =09report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI=
);
> =20
> -=09test_typer_v2(reg);
> +=09if (gic_version() =3D=3D 0x2)
> +=09=09test_typer_v2(reg);

nit: reports mention ICPIDR2 independently on the version.

=09report("ICPIDR2 is read-only", test_readonly_32(idreg, false));
=09report_info("value of ICPIDR2: 0x%08x", reg);

> =20
>  =09report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
> =20
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index daeb5a0..12ac142 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -86,28 +86,46 @@ smp =3D $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params =3D -machine gic-version=3D2 -append 'ipi'
>  groups =3D gic
> =20
> -[gicv2-mmio]
> +[gicv3-ipi]
> +file =3D gic.flat
> +smp =3D $MAX_SMP
> +extra_params =3D -machine gic-version=3D3 -append 'ipi'
> +groups =3D gic
> +
> +[gicv2-max-mmio]
>  file =3D gic.flat
>  smp =3D $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params =3D -machine gic-version=3D2 -append 'mmio'
>  groups =3D gic
> =20
> +[gicv3-max-mmio]
> +file =3D gic.flat
> +smp =3D $MAX_SMP
> +extra_params =3D -machine gic-version=3D3 -append 'mmio'
> +groups =3D gic
> +
>  [gicv2-mmio-up]
>  file =3D gic.flat
>  smp =3D 1
>  extra_params =3D -machine gic-version=3D2 -append 'mmio'
>  groups =3D gic
> =20
> +[gicv3-mmio-up]
> +file =3D gic.flat
> +smp =3D 1
> +extra_params =3D -machine gic-version=3D3 -append 'mmio'
> +groups =3D gic
> +
>  [gicv2-mmio-3p]
>  file =3D gic.flat
>  smp =3D $((($MAX_SMP < 3)?$MAX_SMP:3))
>  extra_params =3D -machine gic-version=3D2 -append 'mmio'
>  groups =3D gic
> =20
> -[gicv3-ipi]
> +[gicv3-mmio-3p]
>  file =3D gic.flat
> -smp =3D $MAX_SMP
> -extra_params =3D -machine gic-version=3D3 -append 'ipi'
> +smp =3D $((($MAX_SMP < 3)?$MAX_SMP:3))
why do we keep this smp computation?
> +extra_params =3D -machine gic-version=3D2 -append 'mmio'
gic-version=3D3
>  groups =3D gic
> =20
>  [gicv2-active]
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 347be2f..ed6a5ad 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -23,6 +23,8 @@
>  #define GICD_CTLR_ENABLE_G1A=09=09(1U << 1)
>  #define GICD_CTLR_ENABLE_G1=09=09(1U << 0)
> =20
> +#define GICD_PIDR2=09=09=090xffe8
> +
>  /* Re-Distributor registers, offsets from RD_base */
>  #define GICR_TYPER=09=09=090x0008
> =20
>

Otherwise Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

