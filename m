Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B32DD103
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 13:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgLQMB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 07:01:57 -0500
Received: from foss.arm.com ([217.140.110.172]:60200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLQMBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 07:01:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70D84101E;
        Thu, 17 Dec 2020 04:01:09 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D539F3F66B;
        Thu, 17 Dec 2020 04:01:08 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 1/1] arm: pmu: Don't read PMCR if PMU is not present
Date:   Thu, 17 Dec 2020 12:00:57 +0000
Message-Id: <20201217120057.88562-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217120057.88562-1-alexandru.elisei@arm.com>
References: <20201217120057.88562-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For arm and arm64, the PMU is an optional part of the architecture.
According to ARM DDI 0487F.b, page D13-3683, accessing PMCR_EL0 when the
PMU is not present generates an undefined exception (one would assume that
this is also true for arm).

The pmu_probe() function reads the register before checking that a PMU is
present, so defer accessing PMCR_EL0 until after we know that it is safe.

This hasn't been a problem so far because there's no hardware in the wild
without a PMU and KVM, contrary to the architecture, has treated the PMU
registers as RAZ/WI if the VCPU doesn't have the PMU feature. However,
that's about to change as KVM will start treating the registers as
undefined when the guest doesn't have a PMU.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cc959e6a5c76..15c542a230ea 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -988,7 +988,7 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
-	uint32_t pmcr = get_pmcr();
+	uint32_t pmcr;
 	uint8_t implementer;
 
 	pmu.version = get_pmu_version();
@@ -997,6 +997,7 @@ static bool pmu_probe(void)
 
 	report_info("PMU version: 0x%x", pmu.version);
 
+	pmcr = get_pmcr();
 	implementer = (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK;
 	report_info("PMU implementer/ID code: %#"PRIx32"(\"%c\")/%#"PRIx32,
 		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
-- 
2.29.2

