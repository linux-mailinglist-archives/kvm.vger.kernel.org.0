Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90F210CE42
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfK1SEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:42 -0500
Received: from foss.arm.com ([217.140.110.172]:39370 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfK1SEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BA591FB;
        Thu, 28 Nov 2019 10:04:41 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 778FD3F6C4;
        Thu, 28 Nov 2019 10:04:40 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 08/18] lib: arm: Implement flush_tlb_all
Date:   Thu, 28 Nov 2019 18:04:08 +0000
Message-Id: <20191128180418.6938-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
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

