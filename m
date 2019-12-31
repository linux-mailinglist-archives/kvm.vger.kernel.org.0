Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1B412DA1C
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfLaQK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:28 -0500
Received: from foss.arm.com ([217.140.110.172]:35522 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbfLaQK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D268328;
        Tue, 31 Dec 2019 08:10:28 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 61A953F68F;
        Tue, 31 Dec 2019 08:10:26 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 08/18] lib: arm: Implement flush_tlb_all
Date:   Tue, 31 Dec 2019 16:09:39 +0000
Message-Id: <1577808589-31892-9-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

flush_tlb_all performs a TLBIALL, which invalidates the entire TLB and
affects only the executing PE; translation table walks are now Inner
Shareable, so execute a TLBIALLIS (invalidate TLB Inner Shareable) instead.
TLBIALLIS is the equivalent of TLBIALL [1] when the multiprocessing
extensions are implemented, which are mandated by the virtualization
extensions.

Also add the necessary barriers to tlb_flush_all and a comment to
flush_dcache_addr stating what instruction is uses (unsurprisingly, it's
DCCIMVAC, which does a dcache clean and invalidate by VA to PoC).

[1] ARM DDI 0406C.d, section B3.10.6

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 2bf8965ed35e..122874b8aebe 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -26,8 +26,11 @@ static inline void local_flush_tlb_all(void)
 
 static inline void flush_tlb_all(void)
 {
-	//TODO
-	local_flush_tlb_all();
+	dsb(ishst);
+	/* TLBIALLIS */
+	asm volatile("mcr p15, 0, %0, c8, c3, 0" :: "r" (0));
+	dsb(ish);
+	isb();
 }
 
 static inline void flush_tlb_page(unsigned long vaddr)
@@ -41,6 +44,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 
 static inline void flush_dcache_addr(unsigned long vaddr)
 {
+	/* DCCIMVAC */
 	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
 }
 
-- 
2.7.4

