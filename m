Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20F4303F0F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391958AbhAZNnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:43:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11446 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404851AbhAZNmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:42:55 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DT5z5yzjCXS;
        Tue, 26 Jan 2021 21:41:13 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:05 +0800
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
Subject: [RFC PATCH v1 1/5] arm64: cpufeature: Detect the ARMv8.4 TTRem feature
Date:   Tue, 26 Jan 2021 21:41:58 +0800
Message-ID: <20210126134202.381996-2-wangyanan55@huawei.com>
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

The ARMv8.4 TTRem feature offers 3 levels of support when changing block
size without changing any other parameters that are listed as requiring
use of break-before-make.

With level 0 supported, software must use break-before-make to avoid the
possible hardware problems. With level 1 supported, besides use of BBM,
software can also make use of the nT block translation entry. With level
2 supported, besides approaches of BBM and nT, software can also directly
change block size, but TLB conflicts possibly occur as a result.

We have found a place where TTRem can be used to improve the performance
in guest stage-2 translation. So detact the TTRem feature here.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpufeature.c   | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index b77d997b173b..e24570ea7444 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -66,7 +66,8 @@
 #define ARM64_WORKAROUND_1508412		58
 #define ARM64_HAS_LDAPR				59
 #define ARM64_KVM_PROTECTED_MODE		60
+#define ARM64_HAS_ARMv8_4_TTREM			61
 
-#define ARM64_NCAPS				61
+#define ARM64_NCAPS				62
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e99eddec0a46..8295dd1d450b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1960,6 +1960,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.min_field_value = ID_AA64ISAR0_TLB_RANGE,
 	},
+	{
+		.desc = "ARMv8.4 TTRem",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_ARMv8_4_TTREM,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_BBM_SHIFT,
+		.min_field_value = 1,
+		.matches = has_cpuid_feature,
+	},
 #ifdef CONFIG_ARM64_HW_AFDBM
 	{
 		/*
-- 
2.19.1

