Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C431C039C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 12:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfI0Kml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 06:42:41 -0400
Received: from foss.arm.com ([217.140.110.172]:48772 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbfI0Kmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 06:42:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3F8F1570;
        Fri, 27 Sep 2019 03:42:39 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33DAD3F534;
        Fri, 27 Sep 2019 03:42:39 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 6/6] arm: Add missing test name prefix calls
Date:   Fri, 27 Sep 2019 11:42:27 +0100
Message-Id: <20190927104227.253466-7-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190927104227.253466-1-andre.przywara@arm.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running the unit tests in TAP mode (./run_tests.sh -t), every single
test result is printed. This works fine for most tests which use the
reporting prefix feature to indicate the actual test name.
However psci and pci were missing those names, so the reporting left
people scratching their head what was actually tested:
...
ok 74 - invalid-function
ok 75 - affinity-info-on
ok 76 - affinity-info-off
ok 77 - cpu-on

Push a "psci" prefix before running those tests to make those report
lines more descriptive.
While at it, do the same for pci, even though it is less ambigious there.
Also the GIC ITARGETSR test was missing a report_prefix_pop().

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c      | 2 ++
 arm/pci-test.c | 2 ++
 arm/psci.c     | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 66dcafe..ebb6ea2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -480,6 +480,8 @@ static void test_targets(int nr_irqs)
 	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
 
 	writel(orig_targets, targetsptr + GIC_FIRST_SPI);
+
+	report_prefix_pop();
 }
 
 static void gic_test_mmio(void)
diff --git a/arm/pci-test.c b/arm/pci-test.c
index cf128ac..7c3836e 100644
--- a/arm/pci-test.c
+++ b/arm/pci-test.c
@@ -19,6 +19,8 @@ int main(void)
 		return report_summary();
 	}
 
+	report_prefix_push("pci");
+
 	pci_print();
 
 	ret = pci_testdev();
diff --git a/arm/psci.c b/arm/psci.c
index 5cb4d5c..536c9b7 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -126,6 +126,8 @@ int main(void)
 {
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 
+	report_prefix_push("psci");
+
 	if (nr_cpus < 2) {
 		report_skip("At least 2 cpus required");
 		goto done;
-- 
2.17.1

