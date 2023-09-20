Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112117A8D23
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjITTvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjITTvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:51:00 -0400
Received: from out-212.mta0.migadu.com (out-212.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9646CF
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmsd+cmXdh5Wnuo3B63Fy6hr6UdLHBnrjyIdvUByTdo=;
        b=uwLjCK9/Lvat9rKT13yy618oablIoQQGZq8LgT/UPhqCnAB8tlgJ2DiUbMLl1BHVw7ldg6
        L2RS/7TYTNm9uRjsiBszk2p8+vSptka3sAQ5iYfTKNzwPQmzYMQx6iJiNnk2FNxp77gttP
        X38iTZZD0g5GmZDOqexnx3Y9dRLXvDI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/8] KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
Date:   Wed, 20 Sep 2023 19:50:32 +0000
Message-ID: <20230920195036.1169791-5-oliver.upton@linux.dev>
In-Reply-To: <20230920195036.1169791-1-oliver.upton@linux.dev>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test for feature support in the ioctl handler rather than
kvm_reset_vcpu(). Continue to uphold our all-or-nothing policy with
address and generic pointer authentication.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   | 13 +++++++++++++
 arch/arm64/kvm/reset.c | 21 +++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9415a760fcda..e40f3bfcb0a1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1203,6 +1203,11 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!system_supports_sve())
 		clear_bit(KVM_ARM_VCPU_SVE, &features);
 
+	if (!system_has_full_ptr_auth()) {
+		clear_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features);
+		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
+	}
+
 	return features;
 }
 
@@ -1223,6 +1228,14 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	if (features & ~system_supported_vcpu_features())
 		return -EINVAL;
 
+	/*
+	 * For now make sure that both address/generic pointer authentication
+	 * features are requested by the userspace together.
+	 */
+	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features) !=
+	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3cb08d35b8e0..bbcf5bbd66d9 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -165,20 +165,9 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
-static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 {
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
 	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
-	return 0;
 }
 
 /**
@@ -233,12 +222,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
-		if (kvm_vcpu_enable_ptrauth(vcpu)) {
-			ret = -EINVAL;
-			goto out;
-		}
-	}
+	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
+		kvm_vcpu_enable_ptrauth(vcpu);
 
 	if (vcpu_el1_is_32bit(vcpu))
 		pstate = VCPU_RESET_PSTATE_SVC;
-- 
2.42.0.515.g380fc7ccd1-goog

