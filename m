Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EF352D4FA
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbiESNse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiESNrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E931147073
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46144B824B0
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B259C36AE9;
        Thu, 19 May 2022 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968022;
        bh=PaDvO7OrWACJT+4yuXWM0lxUPvUE9Q+FqN8Dtq8OkYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsTVC9ijsjxTgVKN4ZxQeljZ4egvZyASLAVQrvNK+vfin5WkChvWM0MZ4vaVc8lUQ
         MA29CgUqKr29/+PkljcpierdXtaBJX5oOr6BOpA3se/asO+cglnCIDcv3OLJuLKP23
         SR4Nof5VZ/pOobQ02GymuIKcskCFnIaCMr8ibihB7O356lPuI8IGTzRI4z+y2fHXsx
         D5KXzW/rCs5CthslpRLqrCQYLYF8f6fQS5WL3c9GOpe+SbtNMpVmjIrdEQeuK58cYS
         4K1jjEA2EV/O6mBBEAmylVFqpYmi48myGiIB6ssoTpfLRzn5Tfiw7oQ0l41QhntPgG
         WYFQRuKnZ3Z6w==
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
Subject: [PATCH 70/89] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
Date:   Thu, 19 May 2022 14:41:45 +0100
Message-Id: <20220519134204.5379-71-will@kernel.org>
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

Move kvm_vcpu_enable_ptrauth() to a shared header to be used by
hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 16 ++++++++++++++++
 arch/arm64/kvm/reset.c               | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..bb56aff4de95 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -43,6 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
+static inline int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * For now make sure that both address/generic pointer authentication
+	 * features are requested by the userspace together and the system
+	 * supports these capabilities.
+	 */
+	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
+	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
+	    !system_has_full_ptr_auth())
+		return -EINVAL;
+
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+	return 0;
+}
+
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index c07265ea72fd..cc25f540962b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -165,22 +165,6 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
-static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * For now make sure that both address/generic pointer authentication
-	 * features are requested by the userspace together and the system
-	 * supports these capabilities.
-	 */
-	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
-	    !system_has_full_ptr_auth())
-		return -EINVAL;
-
-	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
-	return 0;
-}
-
 static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *tmp;
-- 
2.36.1.124.g0e6072fb45-goog

