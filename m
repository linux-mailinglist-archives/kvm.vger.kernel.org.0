Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1344F4E79
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 15:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfKHOm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 09:42:56 -0500
Received: from foss.arm.com ([217.140.110.172]:44560 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbfKHOm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 09:42:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D844446A;
        Fri,  8 Nov 2019 06:42:55 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB2813F719;
        Fri,  8 Nov 2019 06:42:54 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 04/17] arm: gic: Support no IRQs test case
Date:   Fri,  8 Nov 2019 14:42:27 +0000
Message-Id: <20191108144240.204202-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For some tests it would be important to check that an IRQ was *not*
triggered, for instance to test certain masking operations.

Extend the check_added() function to recognise an empty cpumask to
detect this situation. The timeout duration is reduced, and the "no IRQs
triggered" case is actually reported as a success in this case.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index a114009..eca9188 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -66,9 +66,10 @@ static void check_acked(const char *testname, cpumask_t *mask)
 	int missing = 0, extra = 0, unexpected = 0;
 	int nr_pass, cpu, i;
 	bool bad = false;
+	bool noirqs = cpumask_empty(mask);
 
 	/* Wait up to 5s for all interrupts to be delivered */
-	for (i = 0; i < 50; ++i) {
+	for (i = 0; i < (noirqs ? 15 : 50); ++i) {
 		mdelay(100);
 		nr_pass = 0;
 		for_each_present_cpu(cpu) {
@@ -88,7 +89,7 @@ static void check_acked(const char *testname, cpumask_t *mask)
 				bad = true;
 			}
 		}
-		if (nr_pass == nr_cpus) {
+		if (!noirqs && nr_pass == nr_cpus) {
 			report("%s", !bad, testname);
 			if (i)
 				report_info("took more than %d ms", i * 100);
@@ -96,6 +97,11 @@ static void check_acked(const char *testname, cpumask_t *mask)
 		}
 	}
 
+	if (noirqs && nr_pass == nr_cpus) {
+		report("%s", !bad, testname);
+		return;
+	}
+
 	for_each_present_cpu(cpu) {
 		if (cpumask_test_cpu(cpu, mask)) {
 			if (!acked[cpu])
-- 
2.17.1

