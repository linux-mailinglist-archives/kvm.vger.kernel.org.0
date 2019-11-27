Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E4E10B143
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfK0OZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:35 -0500
Received: from foss.arm.com ([217.140.110.172]:48300 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfK0OZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4100031B;
        Wed, 27 Nov 2019 06:25:24 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1BDEE3F68E;
        Wed, 27 Nov 2019 06:25:23 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH 14/18] lib: arm/arm64: Refuse to disable the MMU with non-identity stack pointer
Date:   Wed, 27 Nov 2019 14:24:06 +0000
Message-Id: <20191127142410.1994-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127142410.1994-1-alexandru.elisei@arm.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the MMU is off, all addresses are physical addresses. If the stack
pointer is not an identity mapped address (the virtual address is not the
same as the physical address), then we end up trying to access an invalid
memory region. This can happen if we call mmu_disable from a secondary CPU,
which has its stack allocated from the vmalloc region.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index ed5411c157bb..773c764c4836 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -68,8 +68,12 @@ void mmu_enable(pgd_t *pgtable)
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
2.20.1

