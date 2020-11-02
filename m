Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D332A299B
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgKBLex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 06:34:53 -0500
Received: from foss.arm.com ([217.140.110.172]:58106 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbgKBLeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 06:34:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 860D7106F;
        Mon,  2 Nov 2020 03:34:49 -0800 (PST)
Received: from camtx2.cambridge.arm.com (camtx2.cambridge.arm.com [10.1.7.22])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86BCD3F66E;
        Mon,  2 Nov 2020 03:34:48 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH 2/2] arm64: Check if the configured translation granule is supported
Date:   Mon,  2 Nov 2020 11:34:44 +0000
Message-Id: <20201102113444.103536-3-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201102113444.103536-1-nikos.nikoleris@arm.com>
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
X-ARM-No-Footer: FoSSMail
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can change the translation granule at will, and since
arm64 implementations can support a subset of the architecturally
defined granules, we need to check and warn the user if the configured
granule is not supported.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/arm64/asm/processor.h | 65 +++++++++++++++++++++++++++++++++++++++
 lib/arm/mmu.c             |  3 ++
 2 files changed, 68 insertions(+)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b8..0eac928 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -117,5 +117,70 @@ static inline u64 get_ctr(void)
 
 extern u32 dcache_line_size;
 
+static inline unsigned long get_id_aa64mmfr0_el1(void)
+{
+	unsigned long mmfr0;
+	asm volatile("mrs %0, id_aa64mmfr0_el1" : "=r" (mmfr0));
+	return mmfr0;
+}
+
+/* From arch/arm64/include/asm/cpufeature.h */
+static inline unsigned int
+cpuid_feature_extract_unsigned_field_width(u64 features, int field, int width)
+{
+	return (u64)(features << (64 - width - field)) >> (64 - width);
+}
+
+#define ID_AA64MMFR0_TGRAN4_SHIFT	28
+#define ID_AA64MMFR0_TGRAN64_SHIFT	24
+#define ID_AA64MMFR0_TGRAN16_SHIFT	20
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+
+static inline bool system_supports_64kb_granule(void)
+{
+	u64 mmfr0;
+	u32 val;
+
+	mmfr0 = get_id_aa64mmfr0_el1();
+	val = cpuid_feature_extract_unsigned_field_width(
+		mmfr0, ID_AA64MMFR0_TGRAN4_SHIFT,4);
+
+	return val == ID_AA64MMFR0_TGRAN64_SUPPORTED;
+}
+
+static inline bool system_supports_16kb_granule(void)
+{
+	u64 mmfr0;
+	u32 val;
+
+	mmfr0 = get_id_aa64mmfr0_el1();
+	val = cpuid_feature_extract_unsigned_field_width(
+		mmfr0, ID_AA64MMFR0_TGRAN16_SHIFT, 4);
+
+	return val == ID_AA64MMFR0_TGRAN16_SUPPORTED;
+}
+
+static inline bool system_supports_4kb_granule(void)
+{
+	u64 mmfr0;
+	u32 val;
+
+	mmfr0 = get_id_aa64mmfr0_el1();
+	val = cpuid_feature_extract_unsigned_field_width(
+		mmfr0, ID_AA64MMFR0_TGRAN4_SHIFT, 4);
+
+	return val == ID_AA64MMFR0_TGRAN4_SUPPORTED;
+}
+
+#if PAGE_SIZE == 65536
+#define system_supports_configured_granule system_supports_64kb_granule
+#elif PAGE_SIZE == 16384
+#define system_supports_configured_granule system_supports_16kb_granule
+#elif PAGE_SIZE == 4096
+#define system_supports_configured_granule system_supports_4kb_granule
+#endif
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 6d1c75b..51fa745 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -163,6 +163,9 @@ void *setup_mmu(phys_addr_t phys_end)
 
 #ifdef __aarch64__
 	init_alloc_vpage((void*)(4ul << 30));
+
+	assert_msg(system_supports_configured_granule(),
+		   "Unsupported translation granule %d\n", PAGE_SIZE);
 #endif
 
 	mmu_idmap = alloc_page();
-- 
2.17.1

