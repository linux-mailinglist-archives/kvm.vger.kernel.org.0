Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC58510B135
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfK0OZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:17 -0500
Received: from foss.arm.com ([217.140.110.172]:48242 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727263AbfK0OZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31308328;
        Wed, 27 Nov 2019 06:25:16 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0A4A13F68E;
        Wed, 27 Nov 2019 06:25:14 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH 08/18] lib: arm: Implement flush_tlb_all
Date:   Wed, 27 Nov 2019 14:24:00 +0000
Message-Id: <20191127142410.1994-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127142410.1994-1-alexandru.elisei@arm.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

flush_tlb_all performs a TLBIALL, which affects only the executing PE; fix
that by executing a TLBIALLIS. Note that virtualization extensions imply
the multiprocessing extensions, so we're safe to use that instruction.

While we're at it, let's add a comment to flush_dcache_addr stating what
instruction is uses (unsurprisingly, it's a dcache clean and invalidate to
PoC).

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 361f3cdcc3d5..7c9ee3dbc079 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -25,8 +25,10 @@ static inline void local_flush_tlb_all(void)
 
 static inline void flush_tlb_all(void)
 {
-	//TODO
-	local_flush_tlb_all();
+	/* TLBIALLIS */
+	asm volatile("mcr p15, 0, %0, c8, c3, 0" :: "r" (0));
+	dsb();
+	isb();
 }
 
 static inline void flush_tlb_page(unsigned long vaddr)
@@ -39,6 +41,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 
 static inline void flush_dcache_addr(unsigned long vaddr)
 {
+	/* DCCIMVAC */
 	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
 }
 
-- 
2.20.1

