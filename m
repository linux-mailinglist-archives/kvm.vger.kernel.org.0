Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81F12DA23
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 17:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLaQKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 11:10:44 -0500
Received: from foss.arm.com ([217.140.110.172]:35586 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfLaQKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 11:10:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 220BB1007;
        Tue, 31 Dec 2019 08:10:43 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.8.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D54A93F68F;
        Tue, 31 Dec 2019 08:10:40 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v3 14/18] lib: arm/arm64: Refuse to disable the MMU with non-identity stack pointer
Date:   Tue, 31 Dec 2019 16:09:45 +0000
Message-Id: <1577808589-31892-15-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
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
index 928a3702c563..111e3a52591a 100644
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
2.7.4

