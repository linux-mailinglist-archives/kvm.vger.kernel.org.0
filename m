Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD5D2157BB
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 14:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgGFMy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 08:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgGFMy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 08:54:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49DB12082E;
        Mon,  6 Jul 2020 12:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594040096;
        bh=97r0UAhgwBQBHSU/XSf70vCNeGFAVUZ1Xuv9+c+mUQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCTIcomfWZ4AwzIPjNn8SrXFphSLKy+PLUQ3xsIdJB54zNx7Bg3RB+gQS01fCNS17
         +BuHVLp/udHwztEi8egoBDGecJwj9ld+aPD7Td81lfRxgd0TnIM3MaKar2sVgoZr5S
         gHn6S/KbSKVrM8VraUqimaJRBpVSrOcoltfWecws=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jsQe6-009SCo-O0; Mon, 06 Jul 2020 13:54:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 04/17] arm64: Add level-hinted TLB invalidation helper
Date:   Mon,  6 Jul 2020 13:54:12 +0100
Message-Id: <20200706125425.1671020-5-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706125425.1671020-1-maz@kernel.org>
References: <20200706125425.1671020-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a level-hinted TLB invalidation helper that only gets used if
ARMv8.4-TTL gets detected.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stage2_pgtable.h |  9 +++++
 arch/arm64/include/asm/tlbflush.h       | 45 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index b767904f28b1..996bf98f0cab 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -256,4 +256,13 @@ stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
+/*
+ * Level values for the ARMv8.4-TTL extension, mapping PUD/PMD/PTE and
+ * the architectural page-table level.
+ */
+#define S2_NO_LEVEL_HINT	0
+#define S2_PUD_LEVEL		1
+#define S2_PMD_LEVEL		2
+#define S2_PTE_LEVEL		3
+
 #endif	/* __ARM64_S2_PGTABLE_H_ */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index bc3949064725..3353f26302de 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -10,6 +10,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/bitfield.h>
 #include <linux/mm_types.h>
 #include <linux/sched.h>
 #include <asm/cputype.h>
@@ -59,6 +60,50 @@
 		__ta;						\
 	})
 
+/*
+ * Level-based TLBI operations.
+ *
+ * When ARMv8.4-TTL exists, TLBI operations take an additional hint for
+ * the level at which the invalidation must take place. If the level is
+ * wrong, no invalidation may take place. In the case where the level
+ * cannot be easily determined, a 0 value for the level parameter will
+ * perform a non-hinted invalidation.
+ *
+ * For Stage-2 invalidation, use the level values provided to that effect
+ * in asm/stage2_pgtable.h.
+ */
+#define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
+#define TLBI_TTL_TG_4K		1
+#define TLBI_TTL_TG_16K		2
+#define TLBI_TTL_TG_64K		3
+
+#define __tlbi_level(op, addr, level)					\
+	do {								\
+		u64 arg = addr;						\
+									\
+		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
+		    level) {						\
+			u64 ttl = level & 3;				\
+									\
+			switch (PAGE_SIZE) {				\
+			case SZ_4K:					\
+				ttl |= TLBI_TTL_TG_4K << 2;		\
+				break;					\
+			case SZ_16K:					\
+				ttl |= TLBI_TTL_TG_16K << 2;		\
+				break;					\
+			case SZ_64K:					\
+				ttl |= TLBI_TTL_TG_64K << 2;		\
+				break;					\
+			}						\
+									\
+			arg &= ~TLBI_TTL_MASK;				\
+			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\
+		}							\
+									\
+		__tlbi(op, arg);					\
+	} while(0)
+
 /*
  *	TLB Invalidation
  *	================
-- 
2.27.0

