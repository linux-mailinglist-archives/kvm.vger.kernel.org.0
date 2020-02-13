Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C223415BBC0
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 10:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgBMJdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 04:33:11 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53228 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729632AbgBMJdJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 04:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581586388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O8Z9Thp+VSDpsbJ/c3/SKEh6FPSKloGY5r0r2a4bGnM=;
        b=b0Dm8qpAsBVp0LFUHF2wgAbhLn4QHlBlq2QYoNkIKBo/aXNXXhyeWgvZM3pOjSh/wpeskz
        Ta+prHgKHHFxBalCE8/bDFcE7duqF21qmQBeBGAjVQj76OMA/dxsqIWrHdfWmeTzfUnb2Z
        iBAbTKbmk9NAheMu5E/EJOFtr3aMMzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-yZJ42JDsPGWE0H5Gm83c3A-1; Thu, 13 Feb 2020 04:33:04 -0500
X-MC-Unique: yZJ42JDsPGWE0H5Gm83c3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26D68107ACCA;
        Thu, 13 Feb 2020 09:33:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA80B5C13F;
        Thu, 13 Feb 2020 09:32:58 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, yuzenghui@huawei.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests v3] arm64: timer: Speed up gic-timer-state check
Date:   Thu, 13 Feb 2020 10:32:57 +0100
Message-Id: <20200213093257.23367-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's bail out of the wait loop if we see the expected state
to save over six seconds of run time. Make sure we wait a bit
before reading the registers and double check again after,
though, to somewhat mitigate the chance of seeing the expected
state by accident.

We also take this opportunity to push more IRQ state code to
the library.

Cc: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
v3:
 - make gic_irq_state general for all irqs < 1020 [Zenghui Yu]
 - remove unused gic offsets from arm/timer.c [Alexandru Elisei]
v2:
 - check timer irq state twice [Alexandru Elisei]

 arm/timer.c       | 36 ++++++++++++------------------------
 lib/arm/asm/gic.h | 11 ++++++-----
 lib/arm/gic.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f5cf775ce50f..44621b4f2967 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,8 +17,6 @@
 #define ARCH_TIMER_CTL_IMASK   (1 << 1)
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
=20
-static void *gic_isactiver;
-static void *gic_ispendr;
 static void *gic_isenabler;
 static void *gic_icenabler;
=20
@@ -183,28 +181,22 @@ static bool timer_pending(struct timer_info *info)
 		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
 }
=20
-static enum gic_state gic_timer_state(struct timer_info *info)
+static bool gic_timer_check_state(struct timer_info *info,
+				  enum gic_irq_state expected_state)
 {
-	enum gic_state state =3D GIC_STATE_INACTIVE;
 	int i;
-	bool pending, active;
=20
 	/* Wait for up to 1s for the GIC to sample the interrupt. */
 	for (i =3D 0; i < 10; i++) {
-		pending =3D readl(gic_ispendr) & (1 << PPI(info->irq));
-		active =3D readl(gic_isactiver) & (1 << PPI(info->irq));
-		if (!active && !pending)
-			state =3D GIC_STATE_INACTIVE;
-		if (pending)
-			state =3D GIC_STATE_PENDING;
-		if (active)
-			state =3D GIC_STATE_ACTIVE;
-		if (active && pending)
-			state =3D GIC_STATE_ACTIVE_PENDING;
 		mdelay(100);
+		if (gic_irq_state(PPI(info->irq)) =3D=3D expected_state) {
+			mdelay(100);
+			if (gic_irq_state(PPI(info->irq)) =3D=3D expected_state)
+				return true;
+		}
 	}
=20
-	return state;
+	return false;
 }
=20
 static bool test_cval_10msec(struct timer_info *info)
@@ -253,11 +245,11 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STAT=
E_INACTIVE),
 			"not pending before");
=20
 	info->write_cval(now - 1);
-	report(timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_PE=
NDING,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE=
_PENDING),
 			"interrupt signal pending");
=20
 	/* Disable the timer again and prepare to take interrupts */
@@ -265,12 +257,12 @@ static void test_timer(struct timer_info *info)
 	info->irq_received =3D false;
 	set_timer_irq_enabled(info, true);
 	report(!info->irq_received, "no interrupt when timer is disabled");
-	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STAT=
E_INACTIVE),
 			"interrupt signal no longer pending");
=20
 	info->write_cval(now - 1);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
-	report(timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_IN=
ACTIVE,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE=
_INACTIVE),
 			"interrupt signal not pending");
=20
 	report(test_cval_10msec(info), "latency within 10 ms");
@@ -345,14 +337,10 @@ static void test_init(void)
=20
 	switch (gic_version()) {
 	case 2:
-		gic_isactiver =3D gicv2_dist_base() + GICD_ISACTIVER;
-		gic_ispendr =3D gicv2_dist_base() + GICD_ISPENDR;
 		gic_isenabler =3D gicv2_dist_base() + GICD_ISENABLER;
 		gic_icenabler =3D gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
-		gic_isactiver =3D gicv3_sgi_base() + GICR_ISACTIVER0;
-		gic_ispendr =3D gicv3_sgi_base() + GICR_ISPENDR0;
 		gic_isenabler =3D gicv3_sgi_base() + GICR_ISENABLER0;
 		gic_icenabler =3D gicv3_sgi_base() + GICR_ICENABLER0;
 		break;
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index a72e0cde4e9c..922cbe95750c 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -47,11 +47,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
=20
-enum gic_state {
-	GIC_STATE_INACTIVE,
-	GIC_STATE_PENDING,
-	GIC_STATE_ACTIVE,
-	GIC_STATE_ACTIVE_PENDING,
+enum gic_irq_state {
+	GIC_IRQ_STATE_INACTIVE,
+	GIC_IRQ_STATE_PENDING,
+	GIC_IRQ_STATE_ACTIVE,
+	GIC_IRQ_STATE_ACTIVE_PENDING,
 };
=20
 /*
@@ -80,6 +80,7 @@ extern u32 gic_iar_irqnr(u32 iar);
 extern void gic_write_eoir(u32 irqstat);
 extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
+extern enum gic_irq_state gic_irq_state(int irq);
=20
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 94301169215c..c3c5f6bc5b0e 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -146,3 +146,48 @@ void gic_ipi_send_mask(int irq, const cpumask_t *des=
t)
 	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
 	gic_common_ops->ipi_send_mask(irq, dest);
 }
+
+enum gic_irq_state gic_irq_state(int irq)
+{
+	enum gic_irq_state state;
+	void *ispendr, *isactiver;
+	bool pending, active;
+	int offset, mask;
+
+	assert(gic_common_ops);
+	assert(irq < 1020);
+
+	switch (gic_version()) {
+	case 2:
+		ispendr =3D gicv2_dist_base() + GICD_ISPENDR;
+		isactiver =3D gicv2_dist_base() + GICD_ISACTIVER;
+		break;
+	case 3:
+		if (irq < GIC_NR_PRIVATE_IRQS) {
+			ispendr =3D gicv3_sgi_base() + GICR_ISPENDR0;
+			isactiver =3D gicv3_sgi_base() + GICR_ISACTIVER0;
+		} else {
+			ispendr =3D gicv3_dist_base() + GICD_ISPENDR;
+			isactiver =3D gicv3_dist_base() + GICD_ISACTIVER;
+		}
+		break;
+	default:
+		assert(0);
+	}
+
+	offset =3D irq / 32 * 4;
+	mask =3D 1 << (irq % 32);
+	pending =3D readl(ispendr + offset) & mask;
+	active =3D readl(isactiver + offset) & mask;
+
+	if (!active && !pending)
+		state =3D GIC_IRQ_STATE_INACTIVE;
+	if (pending)
+		state =3D GIC_IRQ_STATE_PENDING;
+	if (active)
+		state =3D GIC_IRQ_STATE_ACTIVE;
+	if (active && pending)
+		state =3D GIC_IRQ_STATE_ACTIVE_PENDING;
+
+	return state;
+}
--=20
2.21.1

