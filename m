Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98496536C92
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 13:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiE1Lit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 May 2022 07:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiE1Lik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 May 2022 07:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AEC167DD
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 04:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B957260E8C
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 11:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D16C341C7;
        Sat, 28 May 2022 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653737917;
        bh=QitljtCd2bC9tluPwrO35k5FC0JOHSttdsAV4rni6mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7a8GRIwH/eQNUNSEMyRBv6G2XUFqhuQhUi/x1dOOLqegGpsSCW2Caw0IDx9XS/hU
         lFWDzcELc9kkLo54cjO9ibODdDRvF4t02H7DSMN74FPyqYD86pGghIortUbspGqvCQ
         5q+uH40UXBImTIXc6cz5S6G8Lj40xE/ifzXveQwNYKwoG/Qszv5Oyb0TXPdHwbaBgi
         lQ1ZR3mXpJT/ZWRt/o9Ief/BAMxzo78db8Jje5kcrdVxzxcJUcpbV4R364/2HZXEzo
         qR2IWCKVRfiw/OlnM4e5nNtN8kBKVMKdM+RCzi7qmmjFcnMyGGq54sPxqeIWTR2zCM
         jXEGcWnw14CyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuumB-00EEGh-3F; Sat, 28 May 2022 12:38:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
Subject: [PATCH 07/18] KVM: arm64: Move vcpu configuration flags into their own set
Date:   Sat, 28 May 2022 12:38:17 +0100
Message-Id: <20220528113829.1043361-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_ARM64_{GUEST_HAS_SVE,VCPU_SVE_FINALIZED,GUEST_HAS_PTRAUTH}
flags are purely configuration flags. Once set, they are never cleared,
but evaluated all over the code base.

Move these three flags into the configuration set in one go, using
the new accessors, and take this opportunity to drop the KVM_ARM64_
prefix which doesn't provide any help.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 17 ++++++++++-------
 arch/arm64/kvm/reset.c            |  6 +++---
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c9dd0d4e22f2..2b8f1265eade 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -459,6 +459,13 @@ struct kvm_vcpu_arch {
 #define __flag_unpack(_set, _f, _m)	_f
 #define vcpu_flag_unpack(...)		__flag_unpack(__VA_ARGS__)
 
+/* SVE exposed to guest */
+#define GUEST_HAS_SVE		__vcpu_single_flag(cflags, BIT(0))
+/* SVE config completed */
+#define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
+/* PTRAUTH exposed to guest */
+#define GUEST_HAS_PTRAUTH	__vcpu_single_flag(cflags, BIT(2))
+
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -483,9 +490,6 @@ struct kvm_vcpu_arch {
 /* vcpu_arch flags field values: */
 #define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
 #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
-#define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
-#define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
-#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
 #define KVM_ARM64_PENDING_EXCEPTION	(1 << 8) /* Exception pending */
 /*
  * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
@@ -522,13 +526,13 @@ struct kvm_vcpu_arch {
 				 KVM_GUESTDBG_SINGLESTEP)
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
-			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+			    vcpu_get_flag((vcpu), GUEST_HAS_SVE))
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
 	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
 	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
-	 (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
+	  vcpu_get_flag(vcpu, GUEST_HAS_PTRAUTH))
 #else
 #define vcpu_has_ptrauth(vcpu)		false
 #endif
@@ -885,8 +889,7 @@ void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-#define kvm_arm_vcpu_sve_finalized(vcpu) \
-	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
+#define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
 
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6c70c6f61c70..0e08fbe68715 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -81,7 +81,7 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	 * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
 	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
 	 */
-	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
+	vcpu_set_flag(vcpu, GUEST_HAS_SVE);
 
 	return 0;
 }
@@ -120,7 +120,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	}
 	
 	vcpu->arch.sve_state = buf;
-	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
+	vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
 	return 0;
 }
 
@@ -177,7 +177,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	    !system_has_full_ptr_auth())
 		return -EINVAL;
 
-	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
 	return 0;
 }
 
-- 
2.34.1

