Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775C052D4F4
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiESNsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239119AbiESNrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B6B1D325
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1050EB824DB
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9BBC385B8;
        Thu, 19 May 2022 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968042;
        bh=0mU7k9EwSwUtnIN+8oQEEhPJDCDPGHEQw7raxhtz3Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVSOYf4g8C0W9C6u1dWFO8tC3NZrQ/+a8hERURAcXTaafwf9lT2RdsjxDsEMZbF1e
         LcKA66CMWIjp8Yxw7w/mOMZhDANKkmw/BG1p7WI9Nx65519p7wSO2YG7pd8c3MYy6T
         KkPytu1aRcBk79HKVb4Ds3lfUKPPTm6IMulKUBXK1dIWHgf9uUySZAwhnn/B5gmFYd
         A4Exm67JltDh6PHqGDh75Xm6vkopwMCTiXeNQB6e5R42RCv7ASkn+2oJRpYM9wcXar
         qfX1ysqJfJOM9hCKSzbajhAonurP8SEyzRkl1VrN7wzJhDJxsp3cCEVixozWWkfAi4
         DAFJfrqSm3MXQ==
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
Subject: [PATCH 75/89] KVM: arm64: Move some kvm_psci functions to a shared header
Date:   Thu, 19 May 2022 14:41:50 +0100
Message-Id: <20220519134204.5379-76-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Move some PSCI functions and macros to a shared header to be used
by hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 30 ++++++++++++++++++++++++++++
 arch/arm64/kvm/psci.c                | 28 --------------------------
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bb56aff4de95..82515b015eb4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -492,4 +492,34 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
 	return test_bit(feature, vcpu->arch.features);
 }
 
+/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
+static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	/*
+	 * Zero the input registers' upper 32 bits. They will be fully
+	 * zeroed on exit, so we're fine changing them in place.
+	 */
+	for (i = 1; i < 4; i++)
+		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
+}
+
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	return !(affinity & ~MPIDR_HWID_BITMASK);
+}
+
+
+#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
+
+static inline unsigned long psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
+
+	return 0;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 372da09a2fab..e7baacd696ad 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -21,16 +21,6 @@
  * as described in ARM document number ARM DEN 0022A.
  */
 
-#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
-
-static unsigned long psci_affinity_mask(unsigned long affinity_level)
-{
-	if (affinity_level <= 3)
-		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
-
-	return 0;
-}
-
 static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -58,12 +48,6 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
-{
-	return !(affinity & ~MPIDR_HWID_BITMASK);
-}
-
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -201,18 +185,6 @@ static void kvm_psci_system_reset2(struct kvm_vcpu *vcpu)
 				 KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2);
 }
 
-static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
-{
-	int i;
-
-	/*
-	 * Zero the input registers' upper 32 bits. They will be fully
-	 * zeroed on exit, so we're fine changing them in place.
-	 */
-	for (i = 1; i < 4; i++)
-		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
-}
-
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
 	switch(fn) {
-- 
2.36.1.124.g0e6072fb45-goog

