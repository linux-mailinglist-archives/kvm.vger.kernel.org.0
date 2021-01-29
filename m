Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD263308A76
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 17:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhA2Qjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 11:39:37 -0500
Received: from foss.arm.com ([217.140.110.172]:51182 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhA2QjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 11:39:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D7AA15BE;
        Fri, 29 Jan 2021 08:37:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 628E43F71B;
        Fri, 29 Jan 2021 08:37:19 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, Auger Eric <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [kvm-unit-tests PATCH v3 10/11] arm64: gic: its-trigger: Don't trigger the LPI while it is pending
Date:   Fri, 29 Jan 2021 16:36:46 +0000
Message-Id: <20210129163647.91564-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129163647.91564-1-alexandru.elisei@arm.com>
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The its-trigger test checks that LPI 8195 is not delivered to the CPU while
it is disabled at the ITS level. After that it is re-enabled and the test
checks that the interrupt is properly asserted. After it's re-enabled and
before the stats are examined, the test triggers the interrupt again, which
can lead to the same interrupt being delivered twice: once after the
configuration invalidation and before the INT command, and once after the
INT command.

Add an explicit check that the interrupt has fired after the invalidation.
Leave the check after the INT command to make sure the INT command still
works for the now re-enabled LPI.

CC: Auger Eric <eric.auger@redhat.com>
Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index af2c112336e7..8bc2a35908f2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -802,6 +802,9 @@ static void test_its_trigger(void)
 
 	/* Now call the invall and check the LPI hits */
 	its_send_invall(col3);
+	lpi_stats_expect(3, 8195);
+	check_lpi_stats("dev2/eventid=20 pending LPI is received");
+
 	lpi_stats_expect(3, 8195);
 	its_send_int(dev2, 20);
 	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
-- 
2.30.0

