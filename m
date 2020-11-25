Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA262C446B
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 16:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgKYPuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 10:50:04 -0500
Received: from foss.arm.com ([217.140.110.172]:55794 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730318AbgKYPuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 10:50:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA8FD11D4;
        Wed, 25 Nov 2020 07:50:03 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1657E3F7BB;
        Wed, 25 Nov 2020 07:50:02 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     eric.auger@redhat.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 01/10] lib: arm/arm64: gicv3: Add missing barrier when sending IPIs
Date:   Wed, 25 Nov 2020 15:51:04 +0000
Message-Id: <20201125155113.192079-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201125155113.192079-1-alexandru.elisei@arm.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One common usage for IPIs is for one CPU to write to a shared memory
location, send the IPI to kick another CPU, and the receiver to read from
the same location. Proper synchronization is needed to make sure that the
IPI receiver reads the most recent value and not stale data (for example,
the write from the sender CPU might still be in a store buffer).

For GICv3, IPIs are generated with a write to the ICC_SGI1R_EL1 register.
To make sure the memory stores are observable by other CPUs, we need a
wmb() barrier (DSB ST), which waits for stores to complete.

From the definition of DSB from ARM DDI 0487F.b, page B2-139:

"In addition, no instruction that appears in program order after the DSB
instruction can alter any state of the system or perform any part of its
functionality until the DSB completes other than:

- Being fetched from memory and decoded.
- Reading the general-purpose, SIMD and floating-point, Special-purpose, or
System registers that are directly or indirectly read without causing
side-effects."

Similar definition for armv7 (ARM DDI 0406C.d, page A3-150).

The DSB instruction is enough to prevent reordering of the GIC register
write which comes in program order after the memory access.

This also matches what the Linux GICv3 irqchip driver does (commit
21ec30c0ef52 ("irqchip/gic-v3: Use wmb() instead of smb_wmb() in
gic_raise_softirq()")).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/gic-v3.c | 3 +++
 arm/gic.c        | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index a7e2cb819746..a6afa42d5fbe 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -77,6 +77,9 @@ void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)
 
 	assert(irq < 16);
 
+	/* Ensure stores are visible to other CPUs before sending the IPI */
+	wmb();
+
 	/*
 	 * For each cpu in the mask collect its peers, which are also in
 	 * the mask, in order to form target lists.
diff --git a/arm/gic.c b/arm/gic.c
index acb060585fae..512c83636a2e 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -275,6 +275,8 @@ static void gicv3_ipi_send_self(void)
 
 static void gicv3_ipi_send_broadcast(void)
 {
+	/* Ensure stores are visible to other CPUs before sending the IPI */
+	wmb();
 	gicv3_write_sgi1r(1ULL << 40 | IPI_IRQ << 24);
 	isb();
 }
-- 
2.29.2

