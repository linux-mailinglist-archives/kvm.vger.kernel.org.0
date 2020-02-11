Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F0A158E97
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 13:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgBKMfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 07:35:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50988 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728031AbgBKMf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 07:35:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581424529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SvgnBksltlfdKTQjesT7j5JDJyAmqiI6NDbtZfxaBYc=;
        b=QQXq1/OoeobxBPDl6j3B5I1tadgyW1YEXwsq4mHwMSHTEIXIuZjPzWxIV9CGFclNA3t/t5
        HP4X9patdwnrDvu4ES0l9u0qe7rlnWHIRloUCno5wj854CmVm1R+O0TqLzpKIWt3LcZJrk
        iOnGyYOFgm/600OST0T8WRr7eYgarvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-p6630gJaMpGBbeTuArspaw-1; Tue, 11 Feb 2020 07:35:25 -0500
X-MC-Unique: p6630gJaMpGBbeTuArspaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CAF9477;
        Tue, 11 Feb 2020 12:35:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A15976055B;
        Tue, 11 Feb 2020 12:35:22 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, yuzenghui@huawei.com
Subject: [PATCH kvm-unit-tests] arm64: timer: Speed up gic-timer-state check
Date:   Tue, 11 Feb 2020 13:35:21 +0100
Message-Id: <20200211123521.13637-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's bail out of the wait loop if we see the expected state
to save about seven seconds of run time. Make sure we wait a
bit before reading the registers, though, to somewhat mitigate
the chance of the expected state being stale.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f5cf775ce50f..c2262c112c09 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -183,7 +183,8 @@ static bool timer_pending(struct timer_info *info)
 		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
 }
=20
-static enum gic_state gic_timer_state(struct timer_info *info)
+static bool gic_timer_check_state(struct timer_info *info,
+				  enum gic_state expected_state)
 {
 	enum gic_state state =3D GIC_STATE_INACTIVE;
 	int i;
@@ -191,6 +192,7 @@ static enum gic_state gic_timer_state(struct timer_in=
fo *info)
=20
 	/* Wait for up to 1s for the GIC to sample the interrupt. */
 	for (i =3D 0; i < 10; i++) {
+		mdelay(100);
 		pending =3D readl(gic_ispendr) & (1 << PPI(info->irq));
 		active =3D readl(gic_isactiver) & (1 << PPI(info->irq));
 		if (!active && !pending)
@@ -201,10 +203,11 @@ static enum gic_state gic_timer_state(struct timer_=
info *info)
 			state =3D GIC_STATE_ACTIVE;
 		if (active && pending)
 			state =3D GIC_STATE_ACTIVE_PENDING;
-		mdelay(100);
+		if (state =3D=3D expected_state)
+			return true;
 	}
=20
-	return state;
+	return false;
 }
=20
 static bool test_cval_10msec(struct timer_info *info)
@@ -253,11 +256,11 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_IN=
ACTIVE),
 			"not pending before");
=20
 	info->write_cval(now - 1);
-	report(timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_PE=
NDING,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_PEN=
DING),
 			"interrupt signal pending");
=20
 	/* Disable the timer again and prepare to take interrupts */
@@ -265,12 +268,12 @@ static void test_timer(struct timer_info *info)
 	info->irq_received =3D false;
 	set_timer_irq_enabled(info, true);
 	report(!info->irq_received, "no interrupt when timer is disabled");
-	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_IN=
ACTIVE),
 			"interrupt signal no longer pending");
=20
 	info->write_cval(now - 1);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
-	report(timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_IN=
ACTIVE,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INA=
CTIVE),
 			"interrupt signal not pending");
=20
 	report(test_cval_10msec(info), "latency within 10 ms");
--=20
2.21.1

