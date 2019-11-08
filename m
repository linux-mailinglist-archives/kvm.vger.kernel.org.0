Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51E4F4E7E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfKHOnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:43:02 -0500
Received: from foss.arm.com ([217.140.110.172]:44618 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfKHOnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:43:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35E5446A;
        Fri,  8 Nov 2019 06:43:01 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18ADD3F719;
        Fri,  8 Nov 2019 06:42:59 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 08/17] arm: gic: Add simple SPI MP test
Date:   Fri,  8 Nov 2019 14:42:31 +0000
Message-Id: <20191108144240.204202-9-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shared Peripheral Interrupts (SPI) can target a specific CPU. Test this
feature by routing the test SPI to each of the vCPUs, then triggering it
and confirm its reception on that requested core.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arm/gic.c b/arm/gic.c
index 63aa9f4..304b7b9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -620,16 +620,45 @@ static void spi_test_single(void)
 	check_acked("now enabled SPI fires", &cpumask);
 }
 
+static void spi_test_smp(void)
+{
+	int cpu;
+	int cores = 1;
+
+	wait_on_ready();
+	for_each_present_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+		spi_configure_irq(SPI_IRQ, cpu);
+		if (trigger_and_check_spi(NULL, IRQ_STAT_IRQ, cpu))
+			cores++;
+		else
+			report_info("SPI delivery failed on core %d", cpu);
+	}
+	report("SPI delievered on all cores", cores == nr_cpus);
+}
+
 static void spi_send(void)
 {
 	irqs_enable();
 
 	spi_test_single();
 
+	if (nr_cpus > 1)
+		spi_test_smp();
+
 	check_spurious();
 	exit(report_summary());
 }
 
+static void spi_test(void *data __unused)
+{
+	if (smp_processor_id() == 0)
+		spi_send();
+	else
+		irq_recv();
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -663,7 +692,7 @@ int main(int argc, char **argv)
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "irq") == 0) {
 		report_prefix_push(argv[1]);
-		spi_send();
+		on_cpus(spi_test, NULL);
 		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
-- 
2.17.1

