Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01FA71287C
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbjEZOfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjEZOfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663310D5
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD7D365068
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392A8C433A4;
        Fri, 26 May 2023 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111634;
        bh=SGsj8ICM0QC50tgffybqC2QCsVSiUinMmvMKn79p3gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXVV2DSmC3ewutGb+m6tch6/0/KqebZxiVCgS9tz32xfawLh+mGHaPaHdISOeMbF4
         O91l1xhbZC4+G6HKh6gFjzPasVwI+SH69npCZKuaciTYFBP+L4L5NIRO2S1SMYxFEM
         YjOj+48PDrEMXNV1rkXCbpJzrKClO5Yp2EkA4Rln5ETXQMMqnvUL040J6auxuDqd9O
         oh/FXGuIqkAMhDF0uQ710nPFx6vVwqntpDRdDfQ0dPPPFT+cZay2fhFOzQ/msg6zzk
         sz0LLm6MmZG1YeVW/Okho52GJHR4LBLFU57U3L4H7OvKC0JF2QYOENfn7wRzLJ2394
         ua3Il5lUHnWBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVs-000aHS-CW;
        Fri, 26 May 2023 15:33:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 04/17] arm64: Add KVM_HVHE capability and has_hvhe() predicate
Date:   Fri, 26 May 2023 15:33:35 +0100
Message-Id: <20230526143348.4072074-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose a capability keying the hVHE feature as well as a new
predicate testing it. Nothing is so far using it, and nothing
is enabling it yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/include/asm/virt.h       |  8 ++++++++
 arch/arm64/kernel/cpufeature.c      | 15 +++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 4 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index bc1009890180..3d4b547ae312 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -16,6 +16,7 @@
 #define cpu_feature(x)		KERNEL_HWCAP_ ## x
 
 #define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
+#define ARM64_SW_FEATURE_OVERRIDE_HVHE		4
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 91029709d133..5f84a87a6a2d 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -145,6 +145,14 @@ static __always_inline bool is_protected_kvm_enabled(void)
 		return cpus_have_final_cap(ARM64_KVM_PROTECTED_MODE);
 }
 
+static __always_inline bool has_hvhe(void)
+{
+	if (is_vhe_hyp_code())
+		return false;
+
+	return cpus_have_final_cap(ARM64_KVM_HVHE);
+}
+
 static inline bool is_hyp_nvhe(void)
 {
 	return is_hyp_mode_available() && !is_kernel_in_hyp_mode();
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2d2b7bb5fa0c..04ef60571b37 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1998,6 +1998,15 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
 	return true;
 }
 
+static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
+			  int __unused)
+{
+	u64 val;
+
+	val = arm64_sw_feature_override.val & arm64_sw_feature_override.mask;
+	return cpuid_feature_extract_unsigned_field(val, ARM64_SW_FEATURE_OVERRIDE_HVHE);
+}
+
 #ifdef CONFIG_ARM64_PAN
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
@@ -2643,6 +2652,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_dit,
 		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
 	},
+	{
+		.desc = "VHE for hypervisor only",
+		.capability = ARM64_KVM_HVHE,
+		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
+		.matches = hvhe_possible,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 40ba95472594..3c23a55d7c2f 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -47,6 +47,7 @@ HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HW_DBM
+KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MTE
-- 
2.34.1

