Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB87A8D1E
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjITTu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 15:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjITTuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 15:50:54 -0400
Received: from out-227.mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6D7A3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 12:50:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695239447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdzX8war5D0xFRhL0glcCvptW4Ze/njVqaHiKfO34Wo=;
        b=czDffILkbp5aAYIjPP8H4NJ3TZONhxhKUorhxQu5XgLr4efutRWI+z6cT9WAMuwPFXOLXT
        y07lgi04xZUiHt0iEq38ty16UXnqJZcTBp2vyAmw7jCefTZG92t1dLQKfLLYrzFThQdcmm
        3kEprwp+m51suryes+Ak45p9MoiMmHU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/8] KVM: arm64: Add generic check for system-supported vCPU features
Date:   Wed, 20 Sep 2023 19:50:29 +0000
Message-ID: <20230920195036.1169791-2-oliver.upton@linux.dev>
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

To date KVM has relied on kvm_reset_vcpu() failing when the vCPU feature
flags are unsupported by the system. This is a bit messy since
kvm_reset_vcpu() is called at runtime outside of the KVM_ARM_VCPU_INIT
ioctl when it is expected to succeed. Further complicating the matter is
that kvm_reset_vcpu() must tolerate be idemptotent to the config_lock,
as it isn't consistently called with the lock held.

Prepare to move feature compatibility checks out of kvm_reset_vcpu() with
a 'generic' check that compares the user-provided flags with a computed
maximum feature set for the system.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..66f3720cdd3a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1190,6 +1190,16 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
+static unsigned long system_supported_vcpu_features(void)
+{
+	unsigned long features = KVM_VCPU_VALID_FEATURES;
+
+	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
+
+	return features;
+}
+
 static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 					const struct kvm_vcpu_init *init)
 {
@@ -1204,12 +1214,12 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 	}
 
+	if (features & ~system_supported_vcpu_features())
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
-	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
-		return -EINVAL;
-
 	/* MTE is incompatible with AArch32 */
 	if (kvm_has_mte(vcpu->kvm))
 		return -EINVAL;
-- 
2.42.0.515.g380fc7ccd1-goog

