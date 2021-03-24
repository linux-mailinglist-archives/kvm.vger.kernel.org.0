Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37CC347AE9
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 15:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbhCXOjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 10:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236251AbhCXOjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 10:39:03 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E825E61A02;
        Wed, 24 Mar 2021 14:39:02 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lP4ey-003XVd-Sy; Wed, 24 Mar 2021 14:39:01 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        qperret@google.com, kernel-team@android.com,
        Andrew Walbran <qwandor@google.com>
Subject: [kvm-unit-tests PATCH] arm: pmu: Fix failing PMU test when no PMU is available
Date:   Wed, 24 Mar 2021 14:38:56 +0000
Message-Id: <20210324143856.2079220-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com, qperret@google.com, kernel-team@android.com, qwandor@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU unit tests fail with an UNDEF exception when no PMU
is available (although KVM hasn't been totally consistent
with that in the past).

This is caused by PMCR_EL0 being read *before* ID_AA64DFR0_EL1
is checked for the PMU version.

Move the PMCR_EL0 access to a reasonable place, which allows the
test to soft-fail gracefully.

Fixes: 784ee933fa5f ("arm: pmu: Introduce defines for PMU versions")
Reported-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cc959e6..15c542a 100644
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
2.30.0

