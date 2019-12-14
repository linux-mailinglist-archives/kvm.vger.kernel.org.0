Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922BE11F2AB
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 16:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLNP4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 10:56:52 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfLNP4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 10:56:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576339011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IiMSoFUEZseoMxLw1sAmT/IUeieWX2EUqAxBTC+j+po=;
        b=MsdGxiOAuI3TpMWumBs3S87MFcocJUweZ9R89UjHZCvMI47GTrDoCLMf1QPRN3LpvJ+vqw
        FFErJNSfKPB3l1murZou81w55rHq/LhiuLf1BnoI+cQyOzyvd9dtlOyU9CCXydN1VF+ZOB
        q5YYejji8Fez7sb5GT3LpJl10HlvCjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-8GfcR2qbM7asPJU8NqZDDA-1; Sat, 14 Dec 2019 10:56:49 -0500
X-MC-Unique: 8GfcR2qbM7asPJU8NqZDDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62B71107ACC4;
        Sat, 14 Dec 2019 15:56:47 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C0F166A1A;
        Sat, 14 Dec 2019 15:56:32 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/8] hw/arm/nrf51_soc: Use memory_region_add_subregion() when priority is 0
Date:   Sat, 14 Dec 2019 16:56:07 +0100
Message-Id: <20191214155614.19004-2-philmd@redhat.com>
In-Reply-To: <20191214155614.19004-1-philmd@redhat.com>
References: <20191214155614.19004-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is pointless to overlap a memory subregion with priority 0.
Use the simpler memory_region_add_subregion() function.

This patch was produced with the following spatch script:

    @@
    expression region;
    expression offset;
    expression subregion;
    @@
    -memory_region_add_subregion_overlap(region, offset, subregion, 0)
    +memory_region_add_subregion(region, offset, subregion)

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 hw/arm/nrf51_soc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/hw/arm/nrf51_soc.c b/hw/arm/nrf51_soc.c
index 74029169d0..ade06b225f 100644
--- a/hw/arm/nrf51_soc.c
+++ b/hw/arm/nrf51_soc.c
@@ -94,7 +94,7 @@ static void nrf51_soc_realize(DeviceState *dev_soc, Err=
or **errp)
         return;
     }
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->uart), 0);
-    memory_region_add_subregion_overlap(&s->container, NRF51_UART_BASE, =
mr, 0);
+    memory_region_add_subregion(&s->container, NRF51_UART_BASE, mr);
     sysbus_connect_irq(SYS_BUS_DEVICE(&s->uart), 0,
                        qdev_get_gpio_in(DEVICE(&s->cpu),
                        BASE_TO_IRQ(NRF51_UART_BASE)));
@@ -107,7 +107,7 @@ static void nrf51_soc_realize(DeviceState *dev_soc, E=
rror **errp)
     }
=20
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->rng), 0);
-    memory_region_add_subregion_overlap(&s->container, NRF51_RNG_BASE, m=
r, 0);
+    memory_region_add_subregion(&s->container, NRF51_RNG_BASE, mr);
     sysbus_connect_irq(SYS_BUS_DEVICE(&s->rng), 0,
                        qdev_get_gpio_in(DEVICE(&s->cpu),
                        BASE_TO_IRQ(NRF51_RNG_BASE)));
@@ -127,13 +127,13 @@ static void nrf51_soc_realize(DeviceState *dev_soc,=
 Error **errp)
     }
=20
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->nvm), 0);
-    memory_region_add_subregion_overlap(&s->container, NRF51_NVMC_BASE, =
mr, 0);
+    memory_region_add_subregion(&s->container, NRF51_NVMC_BASE, mr);
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->nvm), 1);
-    memory_region_add_subregion_overlap(&s->container, NRF51_FICR_BASE, =
mr, 0);
+    memory_region_add_subregion(&s->container, NRF51_FICR_BASE, mr);
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->nvm), 2);
-    memory_region_add_subregion_overlap(&s->container, NRF51_UICR_BASE, =
mr, 0);
+    memory_region_add_subregion(&s->container, NRF51_UICR_BASE, mr);
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->nvm), 3);
-    memory_region_add_subregion_overlap(&s->container, NRF51_FLASH_BASE,=
 mr, 0);
+    memory_region_add_subregion(&s->container, NRF51_FLASH_BASE, mr);
=20
     /* GPIO */
     object_property_set_bool(OBJECT(&s->gpio), true, "realized", &err);
@@ -143,7 +143,7 @@ static void nrf51_soc_realize(DeviceState *dev_soc, E=
rror **errp)
     }
=20
     mr =3D sysbus_mmio_get_region(SYS_BUS_DEVICE(&s->gpio), 0);
-    memory_region_add_subregion_overlap(&s->container, NRF51_GPIO_BASE, =
mr, 0);
+    memory_region_add_subregion(&s->container, NRF51_GPIO_BASE, mr);
=20
     /* Pass all GPIOs to the SOC layer so they are available to the boar=
d */
     qdev_pass_gpios(DEVICE(&s->gpio), dev_soc, NULL);
--=20
2.21.0

