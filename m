Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE701800B3
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgCJOyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:54:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30591 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727390AbgCJOyi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 10:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583852076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1He/Rpf4JLCiKi93YfAGw3px9JkkCyAWLJbg5rNbYc=;
        b=doP9XKnpDHnLWVkSI3PjhZlxCzfL03o2FQpPIxeIp0Oa6D0dT6i7YVayEl25vjuaWm6BEs
        XFwKT4DbjMqC4yFOov2uV9Nlgjo2BfAuVdnlTLfJUoF+lPmii9xBpl0ogDJt95RyO5hduS
        6VadofTIVvThwCKXVrDL8qE8xyQ5J1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-75yIwRbYNVqc9bkaXDnWSw-1; Tue, 10 Mar 2020 10:54:34 -0400
X-MC-Unique: 75yIwRbYNVqc9bkaXDnWSw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D3E11005509;
        Tue, 10 Mar 2020 14:54:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-85.ams2.redhat.com [10.36.117.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAF3C60E3E;
        Tue, 10 Mar 2020 14:54:27 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 03/13] arm/arm64: gic: Introduce setup_irq() helper
Date:   Tue, 10 Mar 2020 15:54:00 +0100
Message-Id: <20200310145410.26308-4-eric.auger@redhat.com>
In-Reply-To: <20200310145410.26308-1-eric.auger@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ipi_enable() code would be reusable for other interrupts
than IPI. Let's rename it setup_irq() and pass an interrupt
handler pointer.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- s/handler_t/irq_handler_t
- also add irq_handler_fn in lib/arm/asm/processor.h

v2 -> v3:
- do not export setup_irq anymore
---
 arm/gic.c               | 19 ++++++-------------
 lib/arm/asm/processor.h |  2 ++
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index fcf4c1f..2f904b0 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -215,20 +215,20 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
=20
-static void ipi_enable(void)
+static void setup_irq(irq_handler_fn handler)
 {
 	gic_enable_defaults();
 #ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, ipi_handler);
+	install_exception_handler(EXCPTN_IRQ, handler);
 #else
-	install_irq_handler(EL1H_IRQ, ipi_handler);
+	install_irq_handler(EL1H_IRQ, handler);
 #endif
 	local_irq_enable();
 }
=20
 static void ipi_send(void)
 {
-	ipi_enable();
+	setup_irq(ipi_handler);
 	wait_on_ready();
 	ipi_test_self();
 	ipi_test_smp();
@@ -238,7 +238,7 @@ static void ipi_send(void)
=20
 static void ipi_recv(void)
 {
-	ipi_enable();
+	setup_irq(ipi_handler);
 	cpumask_set_cpu(smp_processor_id(), &ready);
 	while (1)
 		wfi();
@@ -295,14 +295,7 @@ static void ipi_clear_active_handler(struct pt_regs =
*regs __unused)
 static void run_active_clear_test(void)
 {
 	report_prefix_push("active");
-	gic_enable_defaults();
-#ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, ipi_clear_active_handler);
-#else
-	install_irq_handler(EL1H_IRQ, ipi_clear_active_handler);
-#endif
-	local_irq_enable();
-
+	setup_irq(ipi_clear_active_handler);
 	ipi_test_self();
 	report_prefix_pop();
 }
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index 1e1132d..e26ef89 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -26,7 +26,9 @@ enum vector {
 	EXCPTN_MAX,
 };
=20
+typedef void (*irq_handler_fn)(struct pt_regs *regs);
 typedef void (*exception_fn)(struct pt_regs *);
+
 extern void install_exception_handler(enum vector v, exception_fn fn);
=20
 extern void show_regs(struct pt_regs *regs);
--=20
2.20.1

