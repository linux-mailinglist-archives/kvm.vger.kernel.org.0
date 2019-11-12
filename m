Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EAEF9B50
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 21:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLU4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 15:56:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45667 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfKLU4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 15:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573592180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWnDUrwMNWzeWSYABRZ4rErF0Ev5zOYIDNIsGxLphw8=;
        b=IgPrwTZErTHR2TmPEIJ0lRiIVKIcmM1mPJNAF7b/rx7rJ6u6ydjiEEWPKKy/BOV5l3nCF0
        xKHSRYUVjxQf9QHdA59z6q8O6H3sloPsyADjBUVrDOcLPN1IC/D0rxCb6dNBbHutVLofxc
        U+X1yeyuYJrpx5Q/eP2PzK2yBIVqg1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-x35vS6cbODWuRti3I0hJ_Q-1; Tue, 12 Nov 2019 15:56:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BDBE800C61;
        Tue, 12 Nov 2019 20:56:16 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52A2D66089;
        Tue, 12 Nov 2019 20:56:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 05/17] arm: gic: Prepare IRQ handler for
 handling SPIs
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-6-andre.przywara@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <76947b00-816b-9363-a9d6-5e4ef92b74c5@redhat.com>
Date:   Tue, 12 Nov 2019 21:56:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-6-andre.przywara@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: x35vS6cbODWuRti3I0hJ_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 11/8/19 3:42 PM, Andre Przywara wrote:
> So far our IRQ handler routine checks that the received IRQ is actually
> the one SGI (IPI) that we are using for our testing.
>=20
> To make the IRQ testing routine more versatile, also allow the IRQ to be
> one test SPI (shared interrupt).
> We use the penultimate IRQ of the first SPI group for that purpose.
I don't get the above sentence. What do you mean by group here?
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/arm/gic.c b/arm/gic.c
> index eca9188..c909668 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -23,6 +23,7 @@
> =20
>  #define IPI_SENDER=091
>  #define IPI_IRQ=09=091
> +#define SPI_IRQ=09=09(GIC_FIRST_SPI + 30)
> =20
>  struct gic {
>  =09struct {
> @@ -162,8 +163,12 @@ static void irq_handler(struct pt_regs *regs __unuse=
d)
> =20
>  =09smp_rmb(); /* pairs with wmb in stats_reset */
>  =09++acked[smp_processor_id()];
> -=09check_ipi_sender(irqstat);
> -=09check_irqnr(irqnr, IPI_IRQ);
> +=09if (irqnr < GIC_NR_PRIVATE_IRQS) {
> +=09=09check_ipi_sender(irqstat);
> +=09=09check_irqnr(irqnr, IPI_IRQ);
> +=09} else {
> +=09=09check_irqnr(irqnr, SPI_IRQ);
I think I would rather have different handlers per test.
I have rebased the ITS series and I use a different LPI handler there.
I think you shouldn't be obliged to hardcode a specific intid in the
handler.

Can't we have
static void setup_irq(handler_t handler)?

Thanks

Eric

> +=09}
>  =09smp_wmb(); /* pairs with rmb in check_acked */
>  }
> =20
>=20

