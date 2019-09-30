Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6BC232A
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 16:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbfI3OZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 10:25:17 -0400
Received: from foss.arm.com ([217.140.110.172]:55534 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731503AbfI3OZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 10:25:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8F061570;
        Mon, 30 Sep 2019 07:25:16 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9799E3F706;
        Mon, 30 Sep 2019 07:25:15 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        mark.rutland@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 1/3] lib: arm64: Add missing ISB in flush_tlb_page
Date:   Mon, 30 Sep 2019 15:25:06 +0100
Message-Id: <20190930142508.25102-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190930142508.25102-1-alexandru.elisei@arm.com>
References: <20190930142508.25102-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux commit d0b7a302d58a made it abundantly clear that certain CPU
implementations require an ISB after a DSB. Add the missing ISB to
flush_tlb_page. No changes are required for flush_tlb_all, as the function
already had the ISB.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/mmu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index fa554b0c20ae..72d75eafc882 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -24,6 +24,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 	dsb(ishst);
 	asm("tlbi	vaae1is, %0" :: "r" (page));
 	dsb(ish);
+	isb();
 }
 
 static inline void flush_dcache_addr(unsigned long vaddr)
-- 
2.20.1

