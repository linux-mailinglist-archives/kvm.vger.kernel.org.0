Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220F1130FEF
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgAFKER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726382AbgAFKEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4+6mda+PnSK3BiYbKeAM7B0ij6eYTp1vY1hLQf/NQ40=;
        b=KpSlKBnlEuM2zB/YpH1U6HlBo92R8KYhl5cHFrdnAp9et92gZXKZmwj/VvubUW3sngmmcz
        agoxGM5YFjNINKT8STa765MvjSCOyBTZuVPsndOGZwx3y7rfyFKmbzEHAo2hf5heCoawb4
        VM1BBCTTwV8PMI58mo57ztLERCUvCOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-dr-aGpapP8ymTFrDyTyEUg-1; Mon, 06 Jan 2020 05:04:12 -0500
X-MC-Unique: dr-aGpapP8ymTFrDyTyEUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42363800D48;
        Mon,  6 Jan 2020 10:04:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0E57BA4F;
        Mon,  6 Jan 2020 10:04:09 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 13/17] arm64: timer: Write to ICENABLER to disable timer IRQ
Date:   Mon,  6 Jan 2020 11:03:43 +0100
Message-Id: <20200106100347.1559-14-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

According the Generic Interrupt Controller versions 2, 3 and 4 architectu=
re
specifications, a write of 0 to the GIC{D,R}_ISENABLER{,0} registers is
ignored; this is also how KVM emulates the corresponding register. Write
instead to the ICENABLER register when disabling the timer interrupt.

Note that fortunately for us, the timer test was still working as intende=
d
because KVM does the sensible thing and all interrupts are disabled by
default when creating a VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c          | 22 +++++++++++-----------
 lib/arm/asm/gic-v3.h |  1 +
 lib/arm/asm/gic.h    |  1 +
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index b30fd6b6d90b..f390e8e65d31 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,6 +17,9 @@
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
=20
 static void *gic_ispendr;
+static void *gic_isenabler;
+static void *gic_icenabler;
+
 static bool ptimer_unsupported;
=20
 static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned in=
t esr)
@@ -132,19 +135,12 @@ static struct timer_info ptimer_info =3D {
=20
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
-	u32 val =3D 0;
+	u32 val =3D 1 << PPI(info->irq);
=20
 	if (enabled)
-		val =3D 1 << PPI(info->irq);
-
-	switch (gic_version()) {
-	case 2:
-		writel(val, gicv2_dist_base() + GICD_ISENABLER + 0);
-		break;
-	case 3:
-		writel(val, gicv3_sgi_base() + GICR_ISENABLER0);
-		break;
-	}
+		writel(val, gic_isenabler);
+	else
+		writel(val, gic_icenabler);
 }
=20
 static void irq_handler(struct pt_regs *regs)
@@ -306,9 +302,13 @@ static void test_init(void)
 	switch (gic_version()) {
 	case 2:
 		gic_ispendr =3D gicv2_dist_base() + GICD_ISPENDR;
+		gic_isenabler =3D gicv2_dist_base() + GICD_ISENABLER;
+		gic_icenabler =3D gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
 		gic_ispendr =3D gicv3_sgi_base() + GICD_ISPENDR;
+		gic_isenabler =3D gicv3_sgi_base() + GICR_ISENABLER0;
+		gic_icenabler =3D gicv3_sgi_base() + GICR_ICENABLER0;
 		break;
 	}
=20
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 347be2f9da17..0dc838b3ab2d 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -31,6 +31,7 @@
 /* Re-Distributor registers, offsets from SGI_base */
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
+#define GICR_ICENABLER0			GICD_ICENABLER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
=20
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 1fc10a096259..09826fd5bc29 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -15,6 +15,7 @@
 #define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
 #define GICD_ISPENDR			0x0200
 #define GICD_ICPENDR			0x0280
 #define GICD_ISACTIVER			0x0300
--=20
2.21.0

