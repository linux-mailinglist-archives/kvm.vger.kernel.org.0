Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E641207EB
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfLPODx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 09:03:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727950AbfLPODx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 09:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIBn80+V74amPBupfe+F9anDq8XfKyQu39ZmejTiR10=;
        b=BxJVH3Xah74LAYZCEHLAOxai6gwRpmdRthnFhcGx0cH2C9U5xVKsBJE2ed4Y2dam1Iaoap
        p5lin7XPmHjffgncFGs0yjeb5uWUbfimQE+EGOpT7n9MvBu3alTJ/q+iT7sOhaamYJ/CPc
        T/nuUOm4Lm2Z8b6LRYu5wHNiN6dhTf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-J5MIrWbNMCydWN3sERnNSw-1; Mon, 16 Dec 2019 09:03:50 -0500
X-MC-Unique: J5MIrWbNMCydWN3sERnNSw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17434DBC9;
        Mon, 16 Dec 2019 14:03:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C94ED675B9;
        Mon, 16 Dec 2019 14:03:38 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 03/16] arm/arm64: gic: Introduce setup_irq() helper
Date:   Mon, 16 Dec 2019 15:02:22 +0100
Message-Id: <20191216140235.10751-4-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ipi_enable() code would be reusable for other interrupts
than IPI. Let's rename it setup_irq() and pass an interrupt
handler pointer. We also export it to use it in other tests
such as the PMU's one.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/gic.c         | 24 +++---------------------
 lib/arm/asm/gic.h |  3 +++
 lib/arm/gic.c     | 11 +++++++++++
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index fcf4c1f..ba43ae5 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -215,20 +215,9 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
=20
-static void ipi_enable(void)
-{
-	gic_enable_defaults();
-#ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, ipi_handler);
-#else
-	install_irq_handler(EL1H_IRQ, ipi_handler);
-#endif
-	local_irq_enable();
-}
-
 static void ipi_send(void)
 {
-	ipi_enable();
+	setup_irq(ipi_handler);
 	wait_on_ready();
 	ipi_test_self();
 	ipi_test_smp();
@@ -238,7 +227,7 @@ static void ipi_send(void)
=20
 static void ipi_recv(void)
 {
-	ipi_enable();
+	setup_irq(ipi_handler);
 	cpumask_set_cpu(smp_processor_id(), &ready);
 	while (1)
 		wfi();
@@ -295,14 +284,7 @@ static void ipi_clear_active_handler(struct pt_regs =
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
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 21cdb58..55dd84b 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -82,5 +82,8 @@ void gic_set_irq_target(int irq, int cpu);
 void gic_set_irq_group(int irq, int group);
 int gic_get_irq_group(int irq);
=20
+typedef void (*handler_t)(struct pt_regs *regs __unused);
+extern void setup_irq(handler_t handler);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index aa9cb86..8416dde 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -236,3 +236,14 @@ int gic_get_irq_group(int irq)
 {
 	return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
 }
+
+void setup_irq(handler_t handler)
+{
+	gic_enable_defaults();
+#ifdef __arm__
+	install_exception_handler(EXCPTN_IRQ, handler);
+#else
+	install_irq_handler(EL1H_IRQ, handler);
+#endif
+	local_irq_enable();
+}
--=20
2.20.1

