Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8771B12DA26
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfLaQKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:50 -0500
Received: from foss.arm.com ([217.140.110.172]:35616 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbfLaQKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E25A3328;
        Tue, 31 Dec 2019 08:10:49 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2212F3F68F;
        Tue, 31 Dec 2019 08:10:47 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 17/18] arm/arm64: Invalidate TLB before enabling MMU
Date:   Tue, 31 Dec 2019 16:09:48 +0000
Message-Id: <1577808589-31892-18-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's invalidate the TLB before enabling the MMU, not after, so we don't
accidently use a stale TLB mapping. For arm, we add a TLBIALL operation,
which applies only to the PE that executed the instruction [1]. For arm64,
we already do that in asm_mmu_enable.

We now find ourselves in a situation where we issue an extra invalidation
after asm_mmu_enable returns. Remove this redundant call to tlb_flush_all.

[1] ARM DDI 0406C.d, section B3.10.6

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 1 -
 arm/cstart.S  | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 111e3a52591a..5fb56180d334 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -59,7 +59,6 @@ void mmu_enable(pgd_t *pgtable)
 	struct thread_info *info = current_thread_info();
 
 	asm_mmu_enable(__pa(pgtable));
-	flush_tlb_all();
 
 	info->pgtable = pgtable;
 	mmu_mark_enabled(info->cpu);
diff --git a/arm/cstart.S b/arm/cstart.S
index 3c2a3bcde61a..32b2b4f03098 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -161,6 +161,10 @@ halt:
 .equ	NMRR,	0xff000004		@ MAIR1 (from Linux kernel)
 .globl asm_mmu_enable
 asm_mmu_enable:
+	/* TLBIALL */
+	mcr	p15, 0, r2, c8, c7, 0
+	dsb	nsh
+
 	/* TTBCR */
 	ldr	r2, =(TTBCR_EAE | 				\
 		      TTBCR_SH0_SHARED | 			\
-- 
2.7.4

