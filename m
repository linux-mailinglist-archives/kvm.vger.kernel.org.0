Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C9317DD5D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgCIKYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:24:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49068 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726656AbgCIKYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 06:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583749491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MvayPD2KrkjvVludp3nPmXgg5XhOf+bBUlyipWBvYKU=;
        b=bML8bTa4VoXLxmSjG1v5VJOc1kWvnHP8urAKKa2IajT3eKYlvAxABheA+uHeEBuk8dtFCp
        lWac9e6AzGt9mVQTsxQE76nRzab01ZZBzFl9GkceZqMUvD5z/qks1qkxG8CMl+GDEfzycu
        4Wrl50MLqAJb2jdapNiQXV5mwPK997w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-jnfEeXoHOma61Zys7wINog-1; Mon, 09 Mar 2020 06:24:47 -0400
X-MC-Unique: jnfEeXoHOma61Zys7wINog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7F078017CC;
        Mon,  9 Mar 2020 10:24:45 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D85CB90779;
        Mon,  9 Mar 2020 10:24:42 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 03/13] arm/arm64: gic: Introduce setup_irq() helper
Date:   Mon,  9 Mar 2020 11:24:10 +0100
Message-Id: <20200309102420.24498-4-eric.auger@redhat.com>
In-Reply-To: <20200309102420.24498-1-eric.auger@redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

v2 -> v3:
- do not export setup_irq anymore
---
 arm/gic.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index fcf4c1f..abf08c7 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -34,6 +34,7 @@ static struct gic *gic;
 static int acked[NR_CPUS], spurious[NR_CPUS];
 static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
 static cpumask_t ready;
+typedef void (*handler_t)(struct pt_regs *regs __unused);
=20
 static void nr_cpu_check(int nr)
 {
@@ -215,20 +216,20 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
=20
-static void ipi_enable(void)
+static void setup_irq(handler_t handler)
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
@@ -238,7 +239,7 @@ static void ipi_send(void)
=20
 static void ipi_recv(void)
 {
-	ipi_enable();
+	setup_irq(ipi_handler);
 	cpumask_set_cpu(smp_processor_id(), &ready);
 	while (1)
 		wfi();
@@ -295,14 +296,7 @@ static void ipi_clear_active_handler(struct pt_regs =
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
--=20
2.20.1

