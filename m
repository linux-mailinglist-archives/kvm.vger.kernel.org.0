Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4450C15490B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgBFQYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727698AbgBFQYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CY3T6LNlwbHP5kfhu2Ly+XYBV1SDiRcOigjjRUA8eho=;
        b=GUc0ev2axEzG+ikImjt8CSAph6ARhM7+XU1Mst0rssbeSIjl5FItUWVnm+rQFIkJAnl0Rk
        oeU23uoZXCiCuLXNnfv0YLOZ4J9FcwaDTz/oD5ohInCdO7z4dt1cmzcSKprS/Y2lobmBZU
        SQe8XiQQn+tjPRZIbkygLp01OHcD6rM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-s9XQmPrdMo6bRDREPedjug-1; Thu, 06 Feb 2020 11:24:49 -0500
X-MC-Unique: s9XQmPrdMo6bRDREPedjug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8493294CA3;
        Thu,  6 Feb 2020 16:24:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8601E1001B05;
        Thu,  6 Feb 2020 16:24:47 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 07/10] arm64: timer: Wait for the GIC to sample timer interrupt state
Date:   Thu,  6 Feb 2020 17:24:31 +0100
Message-Id: <20200206162434.14624-8-drjones@redhat.com>
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
References: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

There is a delay between the timer asserting the interrupt and the GIC
sampling the interrupt state. Let's take that into account when we are
checking if the timer interrupt is pending (or not) at the GIC level.

An interrupt can be pending or active and pending [1,2]. Let's be precise
and check that the interrupt is actually pending, not active and pending.

[1] ARM IHI 0048B.b, section 1.4.1
[2] ARM IHI 0069E, section 1.2.2

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c       | 43 ++++++++++++++++++++++++++++++++++++++-----
 arm/unittests.cfg |  2 +-
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index b6f9dd10162d..ba7e8c6a90ed 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <devicetree.h>
 #include <errata.h>
+#include <asm/delay.h>
 #include <asm/processor.h>
 #include <asm/gic.h>
 #include <asm/io.h>
@@ -16,6 +17,14 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
=20
+enum gic_state {
+	GIC_STATE_INACTIVE,
+	GIC_STATE_PENDING,
+	GIC_STATE_ACTIVE,
+	GIC_STATE_ACTIVE_PENDING,
+};
+
+static void *gic_isactiver;
 static void *gic_ispendr;
 static void *gic_isenabler;
 static void *gic_icenabler;
@@ -174,9 +183,28 @@ static void irq_handler(struct pt_regs *regs)
 	info->irq_received =3D true;
 }
=20
-static bool gic_timer_pending(struct timer_info *info)
+static enum gic_state gic_timer_state(struct timer_info *info)
 {
-	return readl(gic_ispendr) & (1 << PPI(info->irq));
+	enum gic_state state =3D GIC_STATE_INACTIVE;
+	int i;
+	bool pending, active;
+
+	/* Wait for up to 1s for the GIC to sample the interrupt. */
+	for (i =3D 0; i < 10; i++) {
+		pending =3D readl(gic_ispendr) & (1 << PPI(info->irq));
+		active =3D readl(gic_isactiver) & (1 << PPI(info->irq));
+		if (!active && !pending)
+			state =3D GIC_STATE_INACTIVE;
+		if (pending)
+			state =3D GIC_STATE_PENDING;
+		if (active)
+			state =3D GIC_STATE_ACTIVE;
+		if (active && pending)
+			state =3D GIC_STATE_ACTIVE_PENDING;
+		mdelay(100);
+	}
+
+	return state;
 }
=20
 static bool test_cval_10msec(struct timer_info *info)
@@ -225,15 +253,18 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(!gic_timer_pending(info), "not pending before");
+	report(gic_timer_state(info) =3D=3D GIC_STATE_INACTIVE,
+			"not pending before");
=20
 	info->write_cval(now - 1);
-	report(gic_timer_pending(info), "interrupt signal pending");
+	report(gic_timer_state(info) =3D=3D GIC_STATE_PENDING,
+			"interrupt signal pending");
=20
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
-	report(!gic_timer_pending(info), "interrupt signal no longer pending");
+	report(gic_timer_state(info) =3D=3D GIC_STATE_INACTIVE,
+			"interrupt signal no longer pending");
=20
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
@@ -307,11 +338,13 @@ static void test_init(void)
=20
 	switch (gic_version()) {
 	case 2:
+		gic_isactiver =3D gicv2_dist_base() + GICD_ISACTIVER;
 		gic_ispendr =3D gicv2_dist_base() + GICD_ISPENDR;
 		gic_isenabler =3D gicv2_dist_base() + GICD_ISENABLER;
 		gic_icenabler =3D gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
+		gic_isactiver =3D gicv3_sgi_base() + GICD_ISACTIVER;
 		gic_ispendr =3D gicv3_sgi_base() + GICD_ISPENDR;
 		gic_isenabler =3D gicv3_sgi_base() + GICR_ISENABLER0;
 		gic_icenabler =3D gicv3_sgi_base() + GICR_ICENABLER0;
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a09ad39..1f1bb24d9d13 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -132,7 +132,7 @@ groups =3D psci
 [timer]
 file =3D timer.flat
 groups =3D timer
-timeout =3D 2s
+timeout =3D 8s
 arch =3D arm64
=20
 # Exit tests
--=20
2.21.1

