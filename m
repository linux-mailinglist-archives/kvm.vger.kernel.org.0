Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AC82DD2BE
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgLQOPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:15:44 -0500
Received: from foss.arm.com ([217.140.110.172]:38562 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgLQOPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 09:15:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA4211435;
        Thu, 17 Dec 2020 06:14:21 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC9083F66B;
        Thu, 17 Dec 2020 06:14:20 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com, eric.auger@redhat.com, yuzenghui@huawei.com
Subject: [kvm-unit-tests PATCH v2 11/12] lib: arm64: gic-v3-its: Add wmb() barrier before INT command
Date:   Thu, 17 Dec 2020 14:13:59 +0000
Message-Id: <20201217141400.106137-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217141400.106137-1-alexandru.elisei@arm.com>
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ITS tests use the INT command like an SGI. The its_send_int() function
kicks a CPU and then the test checks that the interrupt was observed as
expected in check_lpi_stats(). This is done by using lpi_stats.observed and
lpi_stats.expected, where the target CPU only writes to lpi_stats.observed,
and the source CPU reads it and compares the values with
lpi_stats.expected.

The fact that the target CPU doesn't read data written by the source CPU
means that we don't need to do inter-processor memory synchronization
for that between the two at the moment.

The acked array is used by its-pending-migration test, but the reset value
for acked (zero) is the same as the initialization value for static
variables, so memory synchronization is again not needed.

However, that is all about to change when we modify all ITS tests to use
the same functions as the IPI tests. Add a write memory barrier to
its_send_int(), similar to the gicv3_ipi_send_mask(), which has similar
semantics.

Suggested-by: Auger Eric <eric.auger@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/gic-v3-its-cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
index 34574f71d171..32703147ee85 100644
--- a/lib/arm64/gic-v3-its-cmd.c
+++ b/lib/arm64/gic-v3-its-cmd.c
@@ -385,6 +385,12 @@ void __its_send_int(struct its_device *dev, u32 event_id, bool verbose)
 {
 	struct its_cmd_desc desc;
 
+	/*
+	 * The INT command is used by tests as an IPI. Ensure stores to Normal
+	 * memory are visible to other CPUs before sending the LPI.
+	 */
+	wmb();
+
 	desc.its_int_cmd.dev = dev;
 	desc.its_int_cmd.event_id = event_id;
 	desc.verbose = verbose;
-- 
2.29.2

