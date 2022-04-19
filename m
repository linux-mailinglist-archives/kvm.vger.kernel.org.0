Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520A7507929
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357065AbiDSShT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357370AbiDSSgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA3F4C40B
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1E2961558
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42059C385A5;
        Tue, 19 Apr 2022 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392889;
        bh=S4wtuSawBIdOirV9+EXKlxJVAMKzTeuezpQs7TWd4mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGmjgynnH14dipIz76FhevPlKKtSYOeldIE8sZyvphKTNBY3U4mFDueEN+2S5wEk4
         FWUiXVYRP088jM5en0c+HFxBR5oPFRVLlgL+3ObIbn1z+5nG25PFa9jhfzufb4UZ5G
         ANMCGkTxwIseb5Ua9XqDvJoiR1ADazTxceFcetiG9jKAKVd/njDZ4vwqT5jSKuJ2KE
         z/7q3EX8COwrK4qB2U/yiYveU8fIeHKMS0rP4uXVzcUV05mE6WDJDnu+oUWIIhPkre
         bkNQFjHrSN6BLfwCjWI3tAhEBapz/BXAN3pfTBAXrzcziFpJURFycaTq7PXyV52LeK
         dk3E7p1xjG12w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa6-005QYF-2P; Tue, 19 Apr 2022 19:28:06 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 08/10] arm64: Add HWCAP advertising FEAT_WFXT
Date:   Tue, 19 Apr 2022 19:27:53 +0100
Message-Id: <20220419182755.601427-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to allow userspace to enjoy WFET, add a new HWCAP that
advertises it when available.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/arm64/cpu-feature-registers.rst | 2 ++
 Documentation/arm64/elf_hwcaps.rst            | 4 ++++
 arch/arm64/include/asm/hwcap.h                | 1 +
 arch/arm64/include/uapi/asm/hwcap.h           | 1 +
 arch/arm64/kernel/cpufeature.c                | 3 ++-
 arch/arm64/kernel/cpuinfo.c                   | 1 +
 6 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/cpu-feature-registers.rst b/Documentation/arm64/cpu-feature-registers.rst
index 749ae970c319..04ba83e1965f 100644
--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -290,6 +290,8 @@ infrastructure:
      +------------------------------+---------+---------+
      | RPRES                        | [7-4]   |    y    |
      +------------------------------+---------+---------+
+     | WFXT                         | [3-0]   |    y    |
+     +------------------------------+---------+---------+
 
 
 Appendix I: Example
diff --git a/Documentation/arm64/elf_hwcaps.rst b/Documentation/arm64/elf_hwcaps.rst
index a8f30963e550..af3ab524e826 100644
--- a/Documentation/arm64/elf_hwcaps.rst
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -264,6 +264,10 @@ HWCAP2_MTE3
     Functionality implied by ID_AA64PFR1_EL1.MTE == 0b0011, as described
     by Documentation/arm64/memory-tagging-extension.rst.
 
+HWCAP2_WFXT
+
+    Functionality implied by ID_AA64ISAR2_EL1.WFXT == 0b0010.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 8db5ec0089db..909337b50e1f 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -109,6 +109,7 @@
 #define KERNEL_HWCAP_AFP		__khwcap2_feature(AFP)
 #define KERNEL_HWCAP_RPRES		__khwcap2_feature(RPRES)
 #define KERNEL_HWCAP_MTE3		__khwcap2_feature(MTE3)
+#define KERNEL_HWCAP_WFXT		__khwcap2_feature(WFXT)
 
 /*
  * This yields a mask that user programs can use to figure out what
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 99cb5d383048..9dddde1d046c 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -79,5 +79,6 @@
 #define HWCAP2_AFP		(1 << 20)
 #define HWCAP2_RPRES		(1 << 21)
 #define HWCAP2_MTE3		(1 << 22)
+#define HWCAP2_WFXT		(1 << 23)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index db6d9ab685e5..945190ebadd5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -237,7 +237,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_GPA3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_WFXT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_WFXT_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2587,6 +2587,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64MMFR0_EL1, ID_AA64MMFR0_ECV_SHIFT, 4, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ECV),
 	HWCAP_CAP(SYS_ID_AA64MMFR1_EL1, ID_AA64MMFR1_AFP_SHIFT, 4, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_AFP),
 	HWCAP_CAP(SYS_ID_AA64ISAR2_EL1, ID_AA64ISAR2_RPRES_SHIFT, 4, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_RPRES),
+	HWCAP_CAP(SYS_ID_AA64ISAR2_EL1, ID_AA64ISAR2_WFXT_SHIFT, 4, FTR_UNSIGNED, ID_AA64ISAR2_WFXT_SUPPORTED, CAP_HWCAP, KERNEL_HWCAP_WFXT),
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 330b92ea863a..781eab314794 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -98,6 +98,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_AFP]		= "afp",
 	[KERNEL_HWCAP_RPRES]		= "rpres",
 	[KERNEL_HWCAP_MTE3]		= "mte3",
+	[KERNEL_HWCAP_WFXT]		= "wfxt",
 };
 
 #ifdef CONFIG_COMPAT
-- 
2.34.1

