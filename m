Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE797303F3F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392214AbhAZNnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:43:16 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11888 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404864AbhAZNnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:43:01 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DK2Mz7z7bNr;
        Tue, 26 Jan 2021 21:41:05 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:06 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v1 2/5] arm64: cpufeature: Add an API to get level of TTRem supported by hardware
Date:   Tue, 26 Jan 2021 21:41:59 +0800
Message-ID: <20210126134202.381996-3-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ARMv8.4 architecture offers 3 levels of support when changing
block size without changing any other parameters that are listed
as requiring use of break-before-make. So get the current level
of TTRem supported by hardware and software can use corresponding
process when changing block size.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9a555809b89c..f8ee7d30829b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -50,6 +50,11 @@ enum ftr_type {
 #define FTR_VISIBLE	true	/* Feature visible to the user space */
 #define FTR_HIDDEN	false	/* Feature is hidden from the user */
 
+/* Supported levels of ARMv8.4 TTRem feature */
+#define TTREM_LEVEL0	0
+#define TTREM_LEVEL1	1
+#define TTREM_LEVEL2	2
+
 #define FTR_VISIBLE_IF_IS_ENABLED(config)		\
 	(IS_ENABLED(config) ? FTR_VISIBLE : FTR_HIDDEN)
 
@@ -739,6 +744,14 @@ static inline bool system_supports_tlb_range(void)
 		cpus_have_const_cap(ARM64_HAS_TLB_RANGE);
 }
 
+static inline u32 system_support_level_of_ttrem(void)
+{
+	u64 mmfr2 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+
+	return cpuid_feature_extract_unsigned_field(mmfr2,
+						    ID_AA64MMFR2_BBM_SHIFT);
+}
+
 extern int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 
 static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
-- 
2.19.1

