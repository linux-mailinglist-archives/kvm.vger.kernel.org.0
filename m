Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB5652D502
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiESNs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbiESNsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:48:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391E31CFC2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2004061783
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19249C34116;
        Thu, 19 May 2022 13:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968058;
        bh=Fi4thb9Ps0T6UgODhOnaPjCJWB96ZlDSu7QTR8NPXQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZBOSK7VfxPFzib5mV3HMqsJQ9/evGbAliHuAVatM2kZEoNTGkN0CKuYss/GQpPCu
         wCgUw+uVwN1pqUqj1qSqKSMfGISRf8SfmpdY+mlaCSYruHm7oXUJPdGWrFmbeTh8WP
         Zw6e+/WSVVPnQxuonjCpc79/P2/cMN0N4Tjhn/j+zb1kaj+Lat55ejjuUb/totLzuL
         IcYgQuKPC9LjSOJdsAwwp6UQ5bG03WonLTNoT26HOaaY6QgmMyqnifqvsLB80yC+Jg
         CaIFEdO2RVaFsM73oebNGyphbNtUAV020Nd+iw/B3afIZavVOonu+kcI200/wbJa/j
         ZjfRbga5U+cvQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 79/89] KVM: arm64: Add is_pkvm_initialized() helper
Date:   Thu, 19 May 2022 14:41:54 +0100
Message-Id: <20220519134204.5379-80-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

Add a helper allowing to check when the pkvm static key is enabled to
ease the introduction of pkvm hooks in other parts of the code.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 0e80db4327b6..3d5bfcdb49aa 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -74,6 +74,12 @@ void __hyp_reset_vectors(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+static inline bool is_pkvm_initialized(void)
+{
+	return IS_ENABLED(CONFIG_KVM) &&
+	       static_branch_likely(&kvm_protected_mode_initialized);
+}
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
@@ -81,8 +87,7 @@ static inline bool is_hyp_mode_available(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return true;
 
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
@@ -96,8 +101,7 @@ static inline bool is_hyp_mode_mismatched(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return false;
 
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
-- 
2.36.1.124.g0e6072fb45-goog

