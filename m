Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF1CF8FEE
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfKLMt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:49:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28280 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727166AbfKLMt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 07:49:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573562996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g9s0JIN2xt+eywacAxoWziOVtnj6SE0YzxR2eAkIxak=;
        b=HwNjv8wkyHAUN6apxz5bJYk78NPTG4nKTgrtdI5uQo2E6leo5PTxeqPW6ds0eH+x1RJSi3
        ylaG4/a699iVP5f0j/krUiLWSskNWpy7I5v9ZqW+8kY7df2rsb5wqjwJNY7KzHaFvFEnvh
        DJeJL7GXmjXLQhIyPX2XMAT2sitjWe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-qfzcBp8jPdia9I30u2CuOg-1; Tue, 12 Nov 2019 07:49:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 696978017E0;
        Tue, 12 Nov 2019 12:49:54 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2A4A10001BD;
        Tue, 12 Nov 2019 12:49:52 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 02/17] arm: gic: Generalise function names
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-3-andre.przywara@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b2657cf3-202a-3fc5-3268-1f2fcc1b68f2@redhat.com>
Date:   Tue, 12 Nov 2019 13:49:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-3-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: qfzcBp8jPdia9I30u2CuOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 11/8/19 3:42 PM, Andre Przywara wrote:
> In preparation for adding functions to test SPI interrupts, generalise
> some existing functions dealing with IPIs so far, since most of them
> are actually generic for all kind of interrupts.
> This also reformats the irq_handler() function, to later expand it
> more easily.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
>=20
> diff --git a/arm/gic.c b/arm/gic.c
> index 04b3337..a114009 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -135,28 +135,30 @@ static void check_ipi_sender(u32 irqstat)
>  =09}
>  }
> =20
> -static void check_irqnr(u32 irqnr)
> +static void check_irqnr(u32 irqnr, int expected)
>  {
> -=09if (irqnr !=3D IPI_IRQ)
> +=09if (irqnr !=3D expected)
>  =09=09bad_irq[smp_processor_id()] =3D irqnr;
>  }
> =20
> -static void ipi_handler(struct pt_regs *regs __unused)
> +static void irq_handler(struct pt_regs *regs __unused)
>  {
>  =09u32 irqstat =3D gic_read_iar();
>  =09u32 irqnr =3D gic_iar_irqnr(irqstat);
> =20
> -=09if (irqnr !=3D GICC_INT_SPURIOUS) {
> -=09=09gic_write_eoir(irqstat);
> -=09=09smp_rmb(); /* pairs with wmb in stats_reset */
> -=09=09++acked[smp_processor_id()];
> -=09=09check_ipi_sender(irqstat);
> -=09=09check_irqnr(irqnr);
> -=09=09smp_wmb(); /* pairs with rmb in check_acked */
> -=09} else {
> +=09if (irqnr =3D=3D GICC_INT_SPURIOUS) {
>  =09=09++spurious[smp_processor_id()];
>  =09=09smp_wmb();
> +=09=09return;
>  =09}
> +
> +=09gic_write_eoir(irqstat);
> +
> +=09smp_rmb(); /* pairs with wmb in stats_reset */
> +=09++acked[smp_processor_id()];
> +=09check_ipi_sender(irqstat);
> +=09check_irqnr(irqnr, IPI_IRQ);
> +=09smp_wmb(); /* pairs with rmb in check_acked */
>  }
> =20
>  static void gicv2_ipi_send_self(void)
> @@ -216,20 +218,20 @@ static void ipi_test_smp(void)
>  =09report_prefix_pop();
>  }
> =20
> -static void ipi_enable(void)
> +static void irqs_enable(void)
>  {
>  =09gic_enable_defaults();
>  #ifdef __arm__
> -=09install_exception_handler(EXCPTN_IRQ, ipi_handler);
> +=09install_exception_handler(EXCPTN_IRQ, irq_handler);
>  #else
> -=09install_irq_handler(EL1H_IRQ, ipi_handler);
> +=09install_irq_handler(EL1H_IRQ, irq_handler);
>  #endif
>  =09local_irq_enable();
>  }
> =20
>  static void ipi_send(void)
>  {
> -=09ipi_enable();
> +=09irqs_enable();
>  =09wait_on_ready();
>  =09ipi_test_self();
>  =09ipi_test_smp();
> @@ -237,9 +239,9 @@ static void ipi_send(void)
>  =09exit(report_summary());
>  }
> =20
> -static void ipi_recv(void)
> +static void irq_recv(void)
>  {
> -=09ipi_enable();
> +=09irqs_enable();
>  =09cpumask_set_cpu(smp_processor_id(), &ready);
>  =09while (1)
>  =09=09wfi();
> @@ -250,7 +252,7 @@ static void ipi_test(void *data __unused)
>  =09if (smp_processor_id() =3D=3D IPI_SENDER)
>  =09=09ipi_send();
>  =09else
> -=09=09ipi_recv();
> +=09=09irq_recv();
>  }
> =20
>  static struct gic gicv2 =3D {
> @@ -285,7 +287,7 @@ static void ipi_clear_active_handler(struct pt_regs *=
regs __unused)
> =20
>  =09=09smp_rmb(); /* pairs with wmb in stats_reset */
>  =09=09++acked[smp_processor_id()];
> -=09=09check_irqnr(irqnr);
> +=09=09check_irqnr(irqnr, IPI_IRQ);
>  =09=09smp_wmb(); /* pairs with rmb in check_acked */
>  =09} else {
>  =09=09++spurious[smp_processor_id()];
>=20
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

