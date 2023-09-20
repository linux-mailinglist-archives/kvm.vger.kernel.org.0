Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE287A8D25
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjITTvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjITTvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:51:03 -0400
Received: from out-213.mta0.migadu.com (out-213.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0244BD6
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:57 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C3t7Tx6eEZI7zC55Ut5AMznCQ8vTN93NHvrb/xhr1po=;
        b=NhbhCjDhoYAgg50q+TYrMfp1oB8IBdZCbWxM+y2agTmhjW7nhLZYJQ4i87MgqdSeck6DWD
        nf7g15DE0411PUv5AGVc4myh1vhv0F37Gi8dAr3jW+dAsE2AxWG5i0KDv67fTaNnU0u/zy
        6QsCtFuli602EcHWO0jolCWBQ5dWc4Y=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6/8] KVM: arm64: Hoist NV+SVE check into KVM_ARM_VCPU_INIT ioctl handler
Date:   Wed, 20 Sep 2023 19:50:34 +0000
Message-ID: <20230920195036.1169791-7-oliver.upton@linux.dev>
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

Move the feature check out of kvm_reset_vcpu() so we can make the
function succeed uncondtitionally.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   | 5 +++++
 arch/arm64/kvm/reset.c | 8 +-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ef92c2f2de70..cae7a2df52ab 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1239,6 +1239,11 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
+	/* Disallow NV+SVE for the time being */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features) &&
+	    test_bit(KVM_ARM_VCPU_SVE, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index bbcf5bbd66d9..edffbfab5e7b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -208,12 +208,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
-	/* Disallow NV+SVE for the time being */
-	if (vcpu_has_nv(vcpu) && vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
 		if (test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features))
 			kvm_vcpu_enable_sve(vcpu);
@@ -267,7 +261,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset timer */
 	ret = kvm_timer_vcpu_reset(vcpu);
-out:
+
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
-- 
2.42.0.515.g380fc7ccd1-goog

