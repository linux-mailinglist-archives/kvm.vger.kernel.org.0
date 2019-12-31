Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9CC12DA16
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfLaQKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:14 -0500
Received: from foss.arm.com ([217.140.110.172]:35460 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbfLaQKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B33C81007;
        Tue, 31 Dec 2019 08:10:13 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D18FB3F68F;
        Tue, 31 Dec 2019 08:10:11 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 02/18] lib: arm: Add proper data synchronization barriers for TLBIs
Date:   Tue, 31 Dec 2019 16:09:33 +0000
Message-Id: <1577808589-31892-3-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need to issue a DSB before doing TLB invalidation to make sure that the
table walker sees the new VA mapping after the TLBI finishes. For
flush_tlb_page, we do a DSB ISHST (synchronization barrier for writes in
the Inner Shareable domain) because translation table walks are now
coherent for arm. For local_flush_tlb_all, we only need to affect the
Non-shareable domain, and we do a DSB NSHST. We need a synchronization
barrier here, and not a memory ordering barrier, because a table walk is
not a memory operation and therefore not affected by the DMB.

For the same reasons, we downgrade the full system DSB after the TLBI to a
DSB ISH (synchronization barrier for reads and writes in the Inner
Shareable domain), and, respectively, DSB NSH (in the Non-shareable
domain).

With these two changes, our TLB maintenance functions now match what Linux
does in __flush_tlb_kernel_page, and, respectively, in local_flush_tlb_all.

A similar change was implemented in Linux commit 62cbbc42e001 ("ARM: tlb:
reduce scope of barrier domains for TLB invalidation").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 361f3cdcc3d5..2bf8965ed35e 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -17,9 +17,10 @@
 
 static inline void local_flush_tlb_all(void)
 {
+	dsb(nshst);
 	/* TLBIALL */
 	asm volatile("mcr p15, 0, %0, c8, c7, 0" :: "r" (0));
-	dsb();
+	dsb(nsh);
 	isb();
 }
 
@@ -31,9 +32,10 @@ static inline void flush_tlb_all(void)
 
 static inline void flush_tlb_page(unsigned long vaddr)
 {
+	dsb(ishst);
 	/* TLBIMVAAIS */
 	asm volatile("mcr p15, 0, %0, c8, c3, 3" :: "r" (vaddr));
-	dsb();
+	dsb(ish);
 	isb();
 }
 
-- 
2.7.4

