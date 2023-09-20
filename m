Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2B7A8D1F
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjITTu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjITTu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:50:56 -0400
Received: from out-228.mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A06BD3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WqUs/7yAcT86lqyVi3bi6/3EeWVA+owFHQLC8nksiPI=;
        b=o9tUEvQMvO9NUnzt4hh5GmpKh3C1sKhZF18TTF2m/oXKu9WSndgbJDzh7fCwoDGGeIYrZk
        1RmDmminOeFnoQwwyQEkjkLUlDvoEnMGxPsBRySwVVNq0RqCaK9zG11/A0Kbataij+gdmA
        afh1BnCUzPNgjukOm/rzWUwpBsf6D8E=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/8] KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
Date:   Wed, 20 Sep 2023 19:50:30 +0000
Message-ID: <20230920195036.1169791-3-oliver.upton@linux.dev>
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

Test that the system supports PMUv3 before ever getting to
kvm_reset_vcpu().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   | 3 +++
 arch/arm64/kvm/reset.c | 5 -----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 66f3720cdd3a..c6cb7e40315f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1197,6 +1197,9 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
+	if (!kvm_arm_support_pmu_v3())
+		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
+
 	return features;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 7a65a35ee4ac..5b5c74cb901d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -255,11 +255,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	else
 		pstate = VCPU_RESET_PSTATE_EL1;
 
-	if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
 	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
-- 
2.42.0.515.g380fc7ccd1-goog

