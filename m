Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CC019E5A0
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgDDOiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726436AbgDDOiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aBG/mcHOc4lZna+l3/TBlcARw6Oe4Vd9Cbmo3iln5tI=;
        b=FKKIb0q1ZMKzjqIQ/ItTXUAu3Aa8gr5n+UE3zogGCDPO6pO0gdN6f949MhSJRmgDHuSzlu
        uf/hJYCtCnCvobZPpakuI6fZd/hfUi1cQSWLvHP/lci348G8oySGQh/XLyilP/9vzzRUDV
        V2mu8FxX82byzT4qFbKsOfXtd5gDt7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-3KcyUQyyMfahtAk-OZ6fjw-1; Sat, 04 Apr 2020 10:37:59 -0400
X-MC-Unique: 3KcyUQyyMfahtAk-OZ6fjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34D3C8017F3;
        Sat,  4 Apr 2020 14:37:58 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E1F69B912;
        Sat,  4 Apr 2020 14:37:56 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 08/39] arm64: timer: Check the timer interrupt state
Date:   Sat,  4 Apr 2020 16:37:00 +0200
Message-Id: <20200404143731.208138-9-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
2.25.1

