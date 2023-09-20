Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BBB7A8D26
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjITTvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjITTvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:51:05 -0400
Received: from out-220.mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7510EA3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXXLZ6AILg1o6VRTAQ+9JMrbOjRxx5nOGp8PM7AE/6w=;
        b=qvwAvILFnyZ7mrC3Q7FJkzC86qes2/Qu6j0VRodPEEjYo2pRjYhOLd9AbEzDl5Q9MN2h7w
        EXjMWJdxmH0iotPBQrxe6RGaA13bVhyJUdnC5rF0M8yRiyPqyZnurEOB5Qc2KOjKQYGcdJ
        4q43toWy3D0cD5fMIkykUuPWwJaP0L4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 7/8] KVM: arm64: Remove unused return value from kvm_reset_vcpu()
Date:   Wed, 20 Sep 2023 19:50:35 +0000
Message-ID: <20230920195036.1169791-8-oliver.upton@linux.dev>
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

Get rid of the return value for kvm_reset_vcpu() as there are no longer
any cases where it returns a nonzero value.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arch_timer.c       |  4 +---
 arch/arm64/kvm/arm.c              | 10 ++++------
 arch/arm64/kvm/reset.c            |  6 ++----
 include/kvm/arm_arch_timer.h      |  2 +-
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..cb2cde7b2682 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -78,7 +78,7 @@ extern unsigned int __ro_after_init kvm_sve_max_vl;
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
-int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
+void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
 struct kvm_hyp_memcache {
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6dcdae4d38cb..74d7d57ba6fc 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -943,7 +943,7 @@ void kvm_timer_sync_user(struct kvm_vcpu *vcpu)
 		unmask_vtimer_irq_user(vcpu);
 }
 
-int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
+void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct timer_map map;
@@ -987,8 +987,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 		soft_timer_cancel(&map.emul_vtimer->hrtimer);
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
-
-	return 0;
 }
 
 static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cae7a2df52ab..32360a5f3779 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1282,15 +1282,12 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	bitmap_copy(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
 
 	/* Now we know what it is, we can reset it. */
-	ret = kvm_reset_vcpu(vcpu);
-	if (ret) {
-		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
-		goto out_unlock;
-	}
+	kvm_reset_vcpu(vcpu);
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
 	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
+	ret = 0;
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
@@ -1315,7 +1312,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_init_changed(vcpu, init))
 		return -EINVAL;
 
-	return kvm_reset_vcpu(vcpu);
+	kvm_reset_vcpu(vcpu);
+	return 0;
 }
 
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index edffbfab5e7b..96ef9b7e74d4 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -188,10 +188,9 @@ static void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  * disable preemption around the vcpu reset as we would otherwise race with
  * preempt notifiers which also call put/load.
  */
-int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
+void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_reset_state reset_state;
-	int ret;
 	bool loaded;
 	u32 pstate;
 
@@ -260,12 +259,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	/* Reset timer */
-	ret = kvm_timer_vcpu_reset(vcpu);
+	kvm_timer_vcpu_reset(vcpu);
 
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
-	return ret;
 }
 
 u32 get_kvm_ipa_limit(void)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index bb3cb005873e..8adf09dbc473 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -94,7 +94,7 @@ struct arch_timer_cpu {
 
 int __init kvm_timer_hyp_init(bool has_gic);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
-int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
-- 
2.42.0.515.g380fc7ccd1-goog

