Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109EC71287A
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 16:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjEZOfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 10:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbjEZOe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 10:34:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5B210D4
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 07:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0E960DE6
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 14:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291A7C433A1;
        Fri, 26 May 2023 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111634;
        bh=cs9s6WrxAIG0+qz4uZPPdbaqmFHbrYSMu2k9xtlONS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUTyRSDOCEqlMgdHRbZXBJdiXX3jUdTnZl3BC+7R7NlQ6n2387EJe6vsn3qAuEBB8
         RIVh/gsl8yVYzgRiADM3IpbBMp8bs0eucG9hYPE03GGALR9rvHQ/UjftpVRRkPWcHA
         +bhLDYCwgE3dvpMHc3YOWHWjIRG/wA2VBUHnXivZ/W/WdPRhqDufGcrmf5KLWlYcdH
         0+5fcgbRac70n/QM9D6P/OWkKf80G+nObd/8EBXLWjXWuYIQDn1Xn0yy3mzIZGVmRm
         g1YTlKY1cJWGgoJl3PkH5kg6YKNKym4vku+5ztVY45FAbCcO6jjcWe9v7VYBWhcQXh
         dI84/XqBGCDlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q2YVs-000aHS-3e;
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
Subject: [PATCH v2 03/17] arm64: Turn kaslr_feature_override into a generic SW feature override
Date:   Fri, 26 May 2023 15:33:34 +0100
Message-Id: <20230526143348.4072074-4-maz@kernel.org>
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

Disabling KASLR from the command line is implemented as a feature
override. Repaint it slightly so that it can further be used as
more generic infrastructure for SW override purposes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  4 ++++
 arch/arm64/kernel/cpufeature.c      |  2 ++
 arch/arm64/kernel/idreg-override.c  | 16 ++++++----------
 arch/arm64/kernel/kaslr.c           |  6 +++---
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6bf013fb110d..bc1009890180 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -15,6 +15,8 @@
 #define MAX_CPU_FEATURES	128
 #define cpu_feature(x)		KERNEL_HWCAP_ ## x
 
+#define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
+
 #ifndef __ASSEMBLY__
 
 #include <linux/bug.h>
@@ -925,6 +927,8 @@ extern struct arm64_ftr_override id_aa64smfr0_override;
 extern struct arm64_ftr_override id_aa64isar1_override;
 extern struct arm64_ftr_override id_aa64isar2_override;
 
+extern struct arm64_ftr_override arm64_sw_feature_override;
+
 u32 get_kvm_ipa_limit(void);
 void dump_cpu_features(void);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7d7128c65161..2d2b7bb5fa0c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -664,6 +664,8 @@ struct arm64_ftr_override __ro_after_init id_aa64smfr0_override;
 struct arm64_ftr_override __ro_after_init id_aa64isar1_override;
 struct arm64_ftr_override __ro_after_init id_aa64isar2_override;
 
+struct arm64_ftr_override arm64_sw_feature_override;
+
 static const struct __ftr_reg_entry {
 	u32			sys_id;
 	struct arm64_ftr_reg 	*reg;
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 370ab84fd06e..8c93b6198bf5 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -138,15 +138,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
 	},
 };
 
-extern struct arm64_ftr_override kaslr_feature_override;
-
-static const struct ftr_set_desc kaslr __initconst = {
-	.name		= "kaslr",
-#ifdef CONFIG_RANDOMIZE_BASE
-	.override	= &kaslr_feature_override,
-#endif
+static const struct ftr_set_desc sw_features __initconst = {
+	.name		= "arm64_sw",
+	.override	= &arm64_sw_feature_override,
 	.fields		= {
-		FIELD("disabled", 0, NULL),
+		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
 		{}
 	},
 };
@@ -158,7 +154,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
 	&isar1,
 	&isar2,
 	&smfr0,
-	&kaslr,
+	&sw_features,
 };
 
 static const struct {
@@ -175,7 +171,7 @@ static const struct {
 	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
 	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
 	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
-	{ "nokaslr",			"kaslr.disabled=1" },
+	{ "nokaslr",			"arm64_sw.nokaslr=1" },
 };
 
 static int __init parse_nokaslr(char *unused)
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index e7477f21a4c9..5d4ce7f5f157 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -23,8 +23,6 @@
 u64 __ro_after_init module_alloc_base;
 u16 __initdata memstart_offset_seed;
 
-struct arm64_ftr_override kaslr_feature_override __initdata;
-
 static int __init kaslr_init(void)
 {
 	u64 module_range;
@@ -36,7 +34,9 @@ static int __init kaslr_init(void)
 	 */
 	module_alloc_base = (u64)_etext - MODULES_VSIZE;
 
-	if (kaslr_feature_override.val & kaslr_feature_override.mask & 0xf) {
+	if (cpuid_feature_extract_unsigned_field(arm64_sw_feature_override.val &
+						 arm64_sw_feature_override.mask,
+						 ARM64_SW_FEATURE_OVERRIDE_NOKASLR)) {
 		pr_info("KASLR disabled on command line\n");
 		return 0;
 	}
-- 
2.34.1

