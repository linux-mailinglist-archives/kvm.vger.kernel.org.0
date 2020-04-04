Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1819E5A7
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgDDOiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31426 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726396AbgDDOiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dPpw8Y0BbKXD+s5EjzvlI+dw+lnTfzQ1bENX5180HXQ=;
        b=J8/l/fgDn23+CANFmd8RMYfjN0hsrcc915dWsN9lCzoGVJTv8rCCgkGiWsoJOJYQx2uDax
        CvzmVXJA29hNuy+k/VgWIPjvc6THcz3PKsp0ga8auzJDaG7eSut3SWOdZn3hgBC0ByqM11
        w4OLHn5dIb6Mr3ZMacj5EnIhuaPnWqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-Cg06DVXyPue4tgTxxAL-PA-1; Sat, 04 Apr 2020 10:38:01 -0400
X-MC-Unique: Cg06DVXyPue4tgTxxAL-PA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C188800D4E;
        Sat,  4 Apr 2020 14:38:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAC4D1147DA;
        Sat,  4 Apr 2020 14:37:58 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 09/39] arm64: timer: Test behavior when timer disabled or masked
Date:   Sat,  4 Apr 2020 16:37:01 +0200
Message-Id: <20200404143731.208138-10-drjones@redhat.com>
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

When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
set), timer interrupts must not be pending or asserted by the VGIC.
However, only when the timer interrupt is masked, we can still check
that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.

This test was used to discover a bug and test the fix introduced by KVM
commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
interrupts on enable").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c       | 7 +++++++
 arm/unittests.cfg | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 35038f2bae57..dea364f5355d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -269,10 +269,17 @@ static void test_timer(struct timer_info *info)
=20
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
+	info->irq_received =3D false;
 	set_timer_irq_enabled(info, true);
+	report(!info->irq_received, "no interrupt when timer is disabled");
 	report(!timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_I=
NACTIVE,
 			"interrupt signal no longer pending");
=20
+	info->write_cval(now - 1);
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
+	report(timer_pending(info) && gic_timer_state(info) =3D=3D GIC_STATE_IN=
ACTIVE,
+			"interrupt signal not pending");
+
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
=20
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1f1bb24d9d13..017958d28ffd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -132,7 +132,7 @@ groups =3D psci
 [timer]
 file =3D timer.flat
 groups =3D timer
-timeout =3D 8s
+timeout =3D 10s
 arch =3D arm64
=20
 # Exit tests
--=20
2.25.1

