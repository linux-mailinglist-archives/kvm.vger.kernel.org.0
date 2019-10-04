Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F21CBCD6
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 16:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbfJDOSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 10:18:40 -0400
Received: from foss.arm.com ([217.140.110.172]:46222 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388625AbfJDOSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 10:18:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84CD715AB;
        Fri,  4 Oct 2019 07:18:39 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B88AB3F68E;
        Fri,  4 Oct 2019 07:18:38 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/6] arm: gic: check_acked: add test description
Date:   Fri,  4 Oct 2019 15:18:24 +0100
Message-Id: <20191004141829.87135-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004141829.87135-1-andre.przywara@arm.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment the check_acked() IRQ helper function just prints a
generic "Completed" or "Timed out" message, without given a more
detailed test description.

To be able to tell the different IRQ tests apart, and also to allow
re-using it more easily, add a "description" parameter string,
which is prefixing the output line. This gives more information on what
exactly was tested.

This also splits the variable output part of the line (duration of IRQ
delivery) into a separate INFO: line, to not confuse testing frameworks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index ed5642e..2ec4070 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -60,7 +60,7 @@ static void stats_reset(void)
 	smp_wmb();
 }
 
-static void check_acked(cpumask_t *mask)
+static void check_acked(const char *testname, cpumask_t *mask)
 {
 	int missing = 0, extra = 0, unexpected = 0;
 	int nr_pass, cpu, i;
@@ -88,7 +88,9 @@ static void check_acked(cpumask_t *mask)
 			}
 		}
 		if (nr_pass == nr_cpus) {
-			report("Completed in %d ms", !bad, ++i * 100);
+			report("%s", !bad, testname);
+			if (i)
+				report_info("took more than %d ms", i * 100);
 			return;
 		}
 	}
@@ -105,8 +107,9 @@ static void check_acked(cpumask_t *mask)
 		}
 	}
 
-	report("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
-	       false, missing, extra, unexpected);
+	report("%s", false, testname);
+	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
+		    missing, extra, unexpected);
 }
 
 static void check_spurious(void)
@@ -185,7 +188,7 @@ static void ipi_test_self(void)
 	cpumask_clear(&mask);
 	cpumask_set_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_self();
-	check_acked(&mask);
+	check_acked("IPI: self", &mask);
 	report_prefix_pop();
 }
 
@@ -200,7 +203,7 @@ static void ipi_test_smp(void)
 	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
 		cpumask_clear_cpu(i, &mask);
 	gic_ipi_send_mask(IPI_IRQ, &mask);
-	check_acked(&mask);
+	check_acked("IPI: directed", &mask);
 	report_prefix_pop();
 
 	report_prefix_push("broadcast");
@@ -208,7 +211,7 @@ static void ipi_test_smp(void)
 	cpumask_copy(&mask, &cpu_present_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_broadcast();
-	check_acked(&mask);
+	check_acked("IPI: broadcast", &mask);
 	report_prefix_pop();
 }
 
-- 
2.17.1

