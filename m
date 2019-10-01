Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65CC313B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbfJAKX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:23:56 -0400
Received: from foss.arm.com ([217.140.110.172]:45988 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfJAKX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:23:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7DD1000;
        Tue,  1 Oct 2019 03:23:55 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6F62D3F739;
        Tue,  1 Oct 2019 03:23:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 12/19] arm/arm64: Invalidate TLB before enabling MMU
Date:   Tue,  1 Oct 2019 11:23:16 +0100
Message-Id: <20191001102323.27628-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Changes:
* Reworded the commit message a bit, but I figured the changes are small and so
  I kept the Reviewed-by.

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
index c8bbb4f0a2a2..748548c3b516 100644
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
2.20.1

