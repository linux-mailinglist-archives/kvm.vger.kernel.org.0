Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886AEA0369
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfH1NjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:02 -0400
Received: from foss.arm.com ([217.140.110.172]:59592 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfH1NjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEB8815AB;
        Wed, 28 Aug 2019 06:39:00 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B75353F246;
        Wed, 28 Aug 2019 06:38:59 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 08/16] lib: arm/arm64: Refuse to disable the MMU with non-identity stack pointer
Date:   Wed, 28 Aug 2019 14:38:23 +0100
Message-Id: <1566999511-24916-9-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the MMU is off, all addresses are physical addresses. If the stack
pointer is not an identity mapped address (the virtual address is not the
same as the physical address), then we end up trying to access an invalid
memory region. This can happen if we call mmu_disable from a secondary CPU,
which has its stack allocated from the vmalloc region.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 3d38c8397f5a..161f7a8e607c 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -66,8 +66,12 @@ void mmu_enable(pgd_t *pgtable)
 extern void asm_mmu_disable(void);
 void mmu_disable(void)
 {
+	unsigned long sp = current_stack_pointer;
 	int cpu = current_thread_info()->cpu;
 
+	assert_msg(__virt_to_phys(sp) == sp,
+			"Attempting to disable MMU with non-identity mapped stack");
+
 	mmu_mark_disabled(cpu);
 
 	asm_mmu_disable();
-- 
2.7.4

