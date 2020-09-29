Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BE627C0D9
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgI2JSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:18:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14708 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728006AbgI2JSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:18:04 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7CC37386EB632C20326B;
        Tue, 29 Sep 2020 17:18:02 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.69) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:17:56 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <will@kernel.org>, <catalin.marinas@arm.com>, <maz@kernel.org>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>,
        <yezengruan@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <fanhenglong@huawei.com>, <wangjingyi11@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [RFC PATCH 1/4] arm64: cpufeature: TWED support detection
Date:   Tue, 29 Sep 2020 17:17:24 +0800
Message-ID: <20200929091727.8692-2-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zengruan Ye <yezengruan@huawei.com>

TWE Delay is an optional feature in ARMv8.6 Extentions. This patch
detect this feature.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arch/arm64/Kconfig               | 10 ++++++++++
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/kernel/cpufeature.c   | 12 ++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d232837cbee..fe66f4fc5f49 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1666,6 +1666,16 @@ config ARCH_RANDOM
 
 endmenu
 
+menu "ARMv8.6 architectural features"
+
+config ARM64_TWED
+	bool "Enable suppot for delayed trapping of WFE"
+	default y
+	help
+	  Delayed Trapping of WFE (part of the ARMv8.6 Extensions)
+
+endmenu
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 07b643a70710..7b8f018d142b 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -64,7 +64,8 @@
 #define ARM64_BTI				54
 #define ARM64_HAS_ARMv8_4_TTL			55
 #define ARM64_HAS_TLB_RANGE			56
+#define ARM64_HAS_TWED				57
 
-#define ARM64_NCAPS				57
+#define ARM64_NCAPS				58
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6424584be01e..d042d32a1144 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2120,6 +2120,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = ID_AA64PFR1_BT_BTI,
 		.sign = FTR_UNSIGNED,
 	},
+#endif
+#ifdef CONFIG_ARM64_TWED
+	{
+		.desc = "Delayed Trapping of WFE",
+		.capability = ARM64_HAS_TWED,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR1_EL1,
+		.field_pos = ID_AA64MMFR1_TWED_SHIFT,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = 1,
+	},
 #endif
 	{},
 };
-- 
2.19.1

