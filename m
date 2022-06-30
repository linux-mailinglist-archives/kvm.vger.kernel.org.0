Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1C56171E
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiF3KEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbiF3KET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:19 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C80F12B278
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:04:10 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC90B1C0A;
        Thu, 30 Jun 2022 03:04:10 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDFA23F5A1;
        Thu, 30 Jun 2022 03:04:09 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, andrew.jones@linux.dev,
        pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 18/27] arm64: Add a new type of memory type flag MR_F_RESERVED
Date:   Thu, 30 Jun 2022 11:03:15 +0100
Message-Id: <20220630100324.3153655-19-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

This will be used by future change to add PTE entries for special EFI
memory regions.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/arm/asm/setup.h | 1 +
 lib/arm/mmu.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index f0e70b1..64cd379 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -15,6 +15,7 @@ extern int nr_cpus;
 
 #define MR_F_IO			(1U << 0)
 #define MR_F_CODE		(1U << 1)
+#define MR_F_RESERVED		(1U << 2)
 #define MR_F_UNKNOWN		(1U << 31)
 
 struct mem_region {
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index e1a72fe..931be98 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -174,6 +174,10 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
 			continue;
+		} else if (r->flags & MR_F_RESERVED) {
+			/* Reserved pages need to be writable for whatever reserved them */
+			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
+					   __pgprot(PTE_WBWA));
 		} else if (r->flags & MR_F_CODE) {
 			/* armv8 requires code shared between EL1 and EL0 to be read-only */
 			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
-- 
2.25.1

