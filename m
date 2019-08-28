Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB41A036D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfH1NjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:03 -0400
Received: from foss.arm.com ([217.140.110.172]:59606 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbfH1NjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4770528;
        Wed, 28 Aug 2019 06:39:02 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2031E3F246;
        Wed, 28 Aug 2019 06:39:01 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 09/16] lib: arm/arm64: Invalidate TLB before enabling MMU
Date:   Wed, 28 Aug 2019 14:38:24 +0100
Message-Id: <1566999511-24916-10-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's invalidate the TLB before enabling the MMU, not after, so we don't
accidently use a stale TLB mapping. For arm64, we already do that in
asm_mmu_enable, and we issue an extra invalidation after the function
returns. Invalidate the TLB in asm_mmu_enable for arm also, and remove the
redundant call to tlb_flush_all.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 1 -
 arm/cstart.S  | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 161f7a8e607c..66a05d789386 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -57,7 +57,6 @@ void mmu_enable(pgd_t *pgtable)
 	struct thread_info *info = current_thread_info();
 
 	asm_mmu_enable(__pa(pgtable));
-	flush_tlb_all();
 
 	info->pgtable = pgtable;
 	mmu_mark_enabled(info->cpu);
diff --git a/arm/cstart.S b/arm/cstart.S
index 5d4fe4b1570b..316672545551 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -160,6 +160,10 @@ halt:
 .equ	NMRR,	0xff000004		@ MAIR1 (from Linux kernel)
 .globl asm_mmu_enable
 asm_mmu_enable:
+	/* TLBIALL */
+	mcr	p15, 0, r2, c8, c7, 0
+	dsb	ish
+
 	/* TTBCR */
 	mrc	p15, 0, r2, c2, c0, 2
 	orr	r2, #(1 << 31)		@ TTB_EAE
-- 
2.7.4

