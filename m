Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF1815490D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBFQYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:24:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51129 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727687AbgBFQYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KSFaiR49IZ7H9CAqMnaJ05LSpmpZ/yYWMtM2kbxNYt0=;
        b=E4qKwirQ9aibGBdmsvImVTOZx+Bz6p8FpgIGntihBuNa+dYviV6wA+ZoplLk0J3vdRg981
        w5mQk6dYb8mCidJohkMbQI99qJYAQZ51/lo3YiAsnGN0RjD6edjOEIgmX/hU3gfcdIhLju
        7su2bry1SX8+pfXPhQ371dmC4qDjyvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-3wtcqOXUNPy9Uj10S7vlqQ-1; Thu, 06 Feb 2020 11:24:50 -0500
X-MC-Unique: 3wtcqOXUNPy9Uj10S7vlqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBBC618AB2C2;
        Thu,  6 Feb 2020 16:24:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDE1B1001B05;
        Thu,  6 Feb 2020 16:24:48 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 08/10] arm64: timer: Check the timer interrupt state
Date:   Thu,  6 Feb 2020 17:24:32 +0100
Message-Id: <20200206162434.14624-9-drjones@redhat.com>
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

We check that the interrupt is pending (or not) at the GIC level, but we
don't check if the timer is asserting it (or not). Let's make sure we don=
't
run into a strange situation where the two devices' states aren't
synchronized.

Coincidently, the "interrupt signal no longer pending" test fails for
non-emulated timers (i.e, the virtual timer on a non-vhe host) if the
host kernel doesn't have patch 16e604a437c89 ("KVM: arm/arm64: vgic:
Reevaluate level sensitive interrupts on enable").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index ba7e8c6a90ed..35038f2bae57 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -183,6 +183,13 @@ static void irq_handler(struct pt_regs *regs)
 	info->irq_received =3D true;
 }
=20
+/* Check that the timer condition is met. */
+static bool timer_pending(struct timer_info *info)
+{
+	return (info->read_ctl() & ARCH_TIMER_CTL_ENABLE) &&
+		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
+}
+
 static enum gic_state gic_timer_state(struct timer_info *info)
 {
 	enum gic_state state =3D GIC_STATE_INACTIVE;
@@ -220,7 +227,7 @@ static bool test_cval_10msec(struct timer_info *info)
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
=20
 	/* Wait for the timer to fire */
-	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
+	while (!timer_pending(info))
 		;
=20
 	/* It fired, check how long it took */
@@ -253,17 +260,17 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(gic_timer_state(info) =3D=3D GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
 			"not pending before");
=20
 	info->write_cval(now - 1);
-	report(gic_timer_state(info) =3D=3D GIC_STATE_PENDING,
+	report(timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_PE=
NDING,
 			"interrupt signal pending");
=20
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
-	report(gic_timer_state(info) =3D=3D GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
 			"interrupt signal no longer pending");
=20
 	report(test_cval_10msec(info), "latency within 10 ms");
--=20
2.21.1

