Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F342A64CB
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 14:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgKDND6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 08:03:58 -0500
Received: from foss.arm.com ([217.140.110.172]:36820 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgKDND5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 08:03:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58E85142F;
        Wed,  4 Nov 2020 05:03:56 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 59F823F719;
        Wed,  4 Nov 2020 05:03:55 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/2] arm64: Check if the configured translation granule is supported
Date:   Wed,  4 Nov 2020 13:03:51 +0000
Message-Id: <20201104130352.17633-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104130352.17633-1-nikos.nikoleris@arm.com>
References: <20201104130352.17633-1-nikos.nikoleris@arm.com>
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As arm64 implementations may support a subset of the architecturally
defined granules, we need to check and warn the user if the configured
translation granule is not supported.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/arm64/asm/processor.h | 36 ++++++++++++++++++++++++++++++++++++
 lib/arm/mmu.c             |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b8..9248689 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -117,5 +117,41 @@ static inline u64 get_ctr(void)
 
 extern u32 dcache_line_size;
 
+static inline unsigned long get_id_aa64mmfr0_el1(void)
+{
+	return read_sysreg(id_aa64mmfr0_el1);
+}
+
+#define ID_AA64MMFR0_TGRAN4_SHIFT	28
+#define ID_AA64MMFR0_TGRAN64_SHIFT	24
+#define ID_AA64MMFR0_TGRAN16_SHIFT	20
+
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+
+static inline bool system_supports_granule(size_t granule)
+{
+	u32 shift;
+	u32 val;
+	u64 mmfr0;
+
+	if (granule == SZ_4K) {
+		shift = ID_AA64MMFR0_TGRAN4_SHIFT;
+		val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
+	} else if (granule == SZ_16K) {
+		shift = ID_AA64MMFR0_TGRAN16_SHIFT;
+		val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
+	} else {
+		assert(granule == SZ_64K);
+		shift = ID_AA64MMFR0_TGRAN64_SHIFT;
+		val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
+	}
+
+	mmfr0 = get_id_aa64mmfr0_el1();
+
+	return ((mmfr0 >> shift) & 0xf) == val;
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 540a1e8..a3758a0 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -160,6 +160,9 @@ void *setup_mmu(phys_addr_t phys_end)
 
 #ifdef __aarch64__
 	init_alloc_vpage((void*)(4ul << 30));
+
+	assert_msg(system_supports_granule(PAGE_SIZE),
+			"Unsupported translation granule %ld\n", PAGE_SIZE);
 #endif
 
 	mmu_idmap = alloc_page();
-- 
2.17.1

