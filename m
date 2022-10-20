Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB299605A96
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiJTJHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJTJHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EFA19C061
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E2F8B826A5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162A0C433D7;
        Thu, 20 Oct 2022 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666256857;
        bh=g8NaNuEldTy+x0KzS6ZbURgaE6wc7Eaz7sRUiTtxPbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOEbPDQyjrMk8DtKVtEQjrZtnPaA9jR7mjW4ndxxhDb31/qw2u5uqMPOiTuX+XIp0
         rhSRqyWn2Sx16hPO9bAKZMsG3bJVv33PMA+yIOVLNTtZr8y2dzz8+6li3vRnnJ6Gco
         wM3KBOvgNiNAl/oIVAB27d4iGH7HOilf7RHu0BE+zPtDiDYPJEncEyrnEo+0kzy5Vj
         YO6QidKcyVMjOuoNvYtL8E8huxxll06pOr6MXEiL1CHneVueUsqm58+9kt2tgSguJp
         NP5i0ejrIv/Mymksp4SAAqmCebVAo7mrYCvE4kqHjpn74F9tRBbjVmznezM91PKiUq
         pJlGoilJNxhbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWY-000Buf-PN;
        Thu, 20 Oct 2022 10:07:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 01/17] arm64: Turn kaslr_feature_override into a generic SW feature override
Date:   Thu, 20 Oct 2022 10:07:11 +0100
Message-Id: <20221020090727.3669908-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index f73f11b55042..f44a7860636f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -15,6 +15,8 @@
 #define MAX_CPU_FEATURES	128
 #define cpu_feature(x)		KERNEL_HWCAP_ ## x
 
+#define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
+
 #ifndef __ASSEMBLY__
 
 #include <linux/bug.h>
@@ -914,6 +916,8 @@ extern struct arm64_ftr_override id_aa64smfr0_override;
 extern struct arm64_ftr_override id_aa64isar1_override;
 extern struct arm64_ftr_override id_aa64isar2_override;
 
+extern struct arm64_ftr_override arm64_sw_feature_override;
+
 u32 get_kvm_ipa_limit(void);
 void dump_cpu_features(void);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6062454a9067..a3959e9f7d55 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -620,6 +620,8 @@ struct arm64_ftr_override __ro_after_init id_aa64smfr0_override;
 struct arm64_ftr_override __ro_after_init id_aa64isar1_override;
 struct arm64_ftr_override __ro_after_init id_aa64isar2_override;
 
+struct arm64_ftr_override arm64_sw_feature_override;
+
 static const struct __ftr_reg_entry {
 	u32			sys_id;
 	struct arm64_ftr_reg 	*reg;
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 95133765ed29..4e8ef5e05db7 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -137,15 +137,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
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
@@ -157,7 +153,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
 	&isar1,
 	&isar2,
 	&smfr0,
-	&kaslr,
+	&sw_features,
 };
 
 static const struct {
@@ -174,7 +170,7 @@ static const struct {
 	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
 	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
 	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
-	{ "nokaslr",			"kaslr.disabled=1" },
+	{ "nokaslr",			"arm64_sw.nokaslr=1" },
 };
 
 static int __init find_field(const char *cmdline,
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 325455d16dbc..7b39283278e5 100644
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

