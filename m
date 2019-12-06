Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE15011567B
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfLFR2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:28:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726332AbfLFR2P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 12:28:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575653295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19yQ4vp56OlBsL/0IrWKby5/zs2yahEC4NVwVl09/bk=;
        b=G3UfLBzYqlCXsU0y1w7G3tsyPap1TergDLakD7weNcp8zgYg1Do9nWfUNWWeOQtugi1xD1
        w4/Os6hTZ4+WF/9uLYo0DlTrQSeZ4AT43qyS86KAOTua0CTpetsFGOECA9RzSejZW488nn
        kgLdSQugQ6zs28CdteQv+C/zn85jjI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-K79uiRAXONuXvi2zOw0w7Q-1; Fri, 06 Dec 2019 12:28:14 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B301B1005502;
        Fri,  6 Dec 2019 17:28:11 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0C1E60BF4;
        Fri,  6 Dec 2019 17:28:06 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
Subject: [kvm-unit-tests RFC 09/10] arm/arm64: gic: Introduce setup_irq() helper
Date:   Fri,  6 Dec 2019 18:27:23 +0100
Message-Id: <20191206172724.947-10-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: K79uiRAXONuXvi2zOw0w7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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
index adb6aa4..04919ae 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -215,20 +215,9 @@ static void ipi_test_smp(void)
 =09report_prefix_pop();
 }
=20
-static void ipi_enable(void)
-{
-=09gic_enable_defaults();
-#ifdef __arm__
-=09install_exception_handler(EXCPTN_IRQ, ipi_handler);
-#else
-=09install_irq_handler(EL1H_IRQ, ipi_handler);
-#endif
-=09local_irq_enable();
-}
-
 static void ipi_send(void)
 {
-=09ipi_enable();
+=09setup_irq(ipi_handler);
 =09wait_on_ready();
 =09ipi_test_self();
 =09ipi_test_smp();
@@ -238,7 +227,7 @@ static void ipi_send(void)
=20
 static void ipi_recv(void)
 {
-=09ipi_enable();
+=09setup_irq(ipi_handler);
 =09cpumask_set_cpu(smp_processor_id(), &ready);
 =09while (1)
 =09=09wfi();
@@ -295,14 +284,7 @@ static void ipi_clear_active_handler(struct pt_regs *r=
egs __unused)
 static void run_active_clear_test(void)
 {
 =09report_prefix_push("active");
-=09gic_enable_defaults();
-#ifdef __arm__
-=09install_exception_handler(EXCPTN_IRQ, ipi_clear_active_handler);
-#else
-=09install_irq_handler(EL1H_IRQ, ipi_clear_active_handler);
-#endif
-=09local_irq_enable();
-
+=09setup_irq(ipi_clear_active_handler);
 =09ipi_test_self();
 =09report_prefix_pop();
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
index aa9cb86..0c5511f 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -236,3 +236,14 @@ int gic_get_irq_group(int irq)
 {
 =09return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
 }
+
+void setup_irq(handler_t handler)
+{
+        gic_enable_defaults();
+#ifdef __arm__
+        install_exception_handler(EXCPTN_IRQ, handler);
+#else
+        install_irq_handler(EL1H_IRQ, handler);
+#endif
+        local_irq_enable();
+}
--=20
2.20.1

