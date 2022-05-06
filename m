Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1451DA06
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 16:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442041AbiEFONH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442027AbiEFONC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:13:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 914A2674F0
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 07:09:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63AFC1570;
        Fri,  6 May 2022 07:09:19 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7391A3F885;
        Fri,  6 May 2022 07:09:18 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     jade.alglave@arm.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 15/23] arm64: Add a new type of memory type flag MR_F_RESERVED
Date:   Fri,  6 May 2022 15:08:47 +0100
Message-Id: <20220506140855.353337-16-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

