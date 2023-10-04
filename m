Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0BED7B98E6
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 01:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244055AbjJDXuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 19:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243199AbjJDXuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 19:50:13 -0400
Received: from out-200.mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15292C0
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 16:50:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696463408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRenIlqsPc+evZHrtiz/Qk3HBmdcI7TlAEqxL6NbRcw=;
        b=og60p8U20mBuCrifFkqZh8nAsyDGY5DhA5ma1rwT6Op6XSpSBBmROsDeeJVnhvZqkGbA71
        OGFxXuDg89PmeLS0fyrBMRpu8PI8/Wr8PyO2JQZdXlwNgMnaG8anWN+sk6fvdC0626TVD+
        BVQ3FCGNliohFyiaEHXSMzEjABf5hk0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: Only insert reserved ranges when SMCCC filter is used
Date:   Wed,  4 Oct 2023 23:49:46 +0000
Message-ID: <20231004234947.207507-3-oliver.upton@linux.dev>
In-Reply-To: <20231004234947.207507-1-oliver.upton@linux.dev>
References: <20231004234947.207507-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reserved ranges are only useful for preventing userspace from
adding a rule that intersects with functions we must handle in KVM. If
userspace never writes to the SMCCC filter than this is all just wasted
work/memory.

Insert reserved ranges on the first call to KVM_ARM_VM_SMCCC_FILTER.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hypercalls.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 35e023322cdb..20a878c64ba7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -133,12 +133,10 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 						   ARM_SMCCC_SMC_64,		\
 						   0, ARM_SMCCC_FUNC_MASK)
 
-static void init_smccc_filter(struct kvm *kvm)
+static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {
 	int r;
 
-	mt_init(&kvm->arch.smccc_filter);
-
 	/*
 	 * Prevent userspace from handling any SMCCC calls in the architecture
 	 * range, avoiding the risk of misrepresenting Spectre mitigation status
@@ -148,14 +146,20 @@ static void init_smccc_filter(struct kvm *kvm)
 			       SMC32_ARCH_RANGE_BEGIN, SMC32_ARCH_RANGE_END,
 			       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
 			       GFP_KERNEL_ACCOUNT);
-	WARN_ON_ONCE(r);
+	if (r)
+		goto out_destroy;
 
 	r = mtree_insert_range(&kvm->arch.smccc_filter,
 			       SMC64_ARCH_RANGE_BEGIN, SMC64_ARCH_RANGE_END,
 			       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
 			       GFP_KERNEL_ACCOUNT);
-	WARN_ON_ONCE(r);
+	if (r)
+		goto out_destroy;
 
+	return 0;
+out_destroy:
+	mtree_destroy(&kvm->arch.smccc_filter);
+	return r;
 }
 
 static bool kvm_smccc_filter_configured(struct kvm *kvm)
@@ -189,6 +193,12 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 		goto out_unlock;
 	}
 
+	if (!kvm_smccc_filter_configured(kvm)) {
+		r = kvm_smccc_filter_insert_reserved(kvm);
+		if (WARN_ON_ONCE(r))
+			goto out_unlock;
+	}
+
 	r = mtree_insert_range(&kvm->arch.smccc_filter, start, end,
 			       xa_mk_value(filter.action), GFP_KERNEL_ACCOUNT);
 	if (r)
@@ -392,7 +402,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
 
-	init_smccc_filter(kvm);
+	mt_init(&kvm->arch.smccc_filter);
 }
 
 void kvm_arm_teardown_hypercalls(struct kvm *kvm)
-- 
2.42.0.609.gbb76f46606-goog

