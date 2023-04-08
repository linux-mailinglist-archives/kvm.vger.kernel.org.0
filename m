Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCFA6DBACC
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 14:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjDHMSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 08:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDHMSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 08:18:02 -0400
Received: from out-37.mta0.migadu.com (out-37.mta0.migadu.com [IPv6:2001:41d0:1004:224b::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757EE4C17
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 05:18:00 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680956278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+hYMZNznSbG1YCea6EGTFnYeO7WZjTjg6+8yW/fTI8=;
        b=QKLEyvNv7qaECKmkECulfJi/E7f5QBkoEKNgXB285efOdqpMCRj1+Izuw2gKUFRsB8EXkH
        jUFt8cThP0SuyHE4FzGs6VGTujH/mBougBxwsKjesVFf97i2GdQoqBq2jy2N4SNnBe1tdR
        evX5d+HOzv/PNZwIFc459kAh2M6APm0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Prevent userspace from handling SMC64 arch range
Date:   Sat,  8 Apr 2023 12:17:31 +0000
Message-Id: <20230408121732.3411329-2-oliver.upton@linux.dev>
In-Reply-To: <20230408121732.3411329-1-oliver.upton@linux.dev>
References: <20230408121732.3411329-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Though presently unused, there is an SMC64 view of the Arm architecture
calls defined by the SMCCC. The documentation of the SMCCC filter states
that the SMC64 range is reserved, but nothing actually prevents
userspace from applying a filter to the range.

Insert a range with the HANDLE action for the SMC64 arch range, thereby
preventing userspace from imposing filtering/forwarding on it.

Fixes: fb88707dd39b ("KVM: arm64: Use a maple tree to represent the SMCCC filter")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hypercalls.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index baf1c4e4a4dc..2e16fc7b31bf 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -121,11 +121,17 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
-#define SMCCC_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
-#define SMCCC_ARCH_RANGE_END				\
-	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
-			   ARM_SMCCC_SMC_32,		\
-			   0, ARM_SMCCC_FUNC_MASK)
+#define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
+#define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_32,		\
+						   0, ARM_SMCCC_FUNC_MASK)
+
+#define SMC64_ARCH_RANGE_BEGIN	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   0, 0)
+#define SMC64_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   0, ARM_SMCCC_FUNC_MASK)
 
 static void init_smccc_filter(struct kvm *kvm)
 {
@@ -139,10 +145,17 @@ static void init_smccc_filter(struct kvm *kvm)
 	 * to the guest.
 	 */
 	r = mtree_insert_range(&kvm->arch.smccc_filter,
-			       SMCCC_ARCH_RANGE_BEGIN, SMCCC_ARCH_RANGE_END,
+			       SMC32_ARCH_RANGE_BEGIN, SMC32_ARCH_RANGE_END,
 			       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
 			       GFP_KERNEL_ACCOUNT);
 	WARN_ON_ONCE(r);
+
+	r = mtree_insert_range(&kvm->arch.smccc_filter,
+			       SMC64_ARCH_RANGE_BEGIN, SMC64_ARCH_RANGE_END,
+			       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+			       GFP_KERNEL_ACCOUNT);
+	WARN_ON_ONCE(r);
+
 }
 
 static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user *uaddr)
-- 
2.40.0.577.gac1e443424-goog

