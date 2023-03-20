Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBCD6C2443
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCTWKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCTWKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:41 -0400
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [IPv6:2001:41d0:203:375::24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28A6E1B1
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:10:40 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09m5ZW/mB3LgyiUMpUEOZ02UayLrXTpdVSzSlLqb338=;
        b=c2qw7xIodP1SnzAWaMWnGMA2D0TArTbDT8TyQgiEND1OL4uo20MBCJbG9JSEz62ln0IF1W
        U5EpJh4iwYc1+4sMN+8Lpohqhj/p9fhycADPZ6dF4UP0kh0Pmdp/RtqH6RTNYbXBhMryu+
        UzUC0Z8Lbni8VK1vIEn66TUrbmhPmsI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 06/11] KVM: arm64: Refactor hvc filtering to support different actions
Date:   Mon, 20 Mar 2023 22:09:57 +0000
Message-Id: <20230320221002.4191007-7-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM presently allows userspace to filter guest hypercalls with bitmaps
expressed via pseudo-firmware registers. These bitmaps have a narrow
scope and, of course, can only allow/deny a particular call. A
subsequent change to KVM will introduce a generalized UAPI for filtering
hypercalls, allowing functions to be forwarded to userspace.

Refactor the existing hypercall filtering logic to make room for more
than two actions. While at it, generalize the function names around
SMCCC as it is the basis for the upcoming UAPI.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/uapi/asm/kvm.h |  9 +++++++++
 arch/arm64/kvm/hypercalls.c       | 19 +++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..bbab92402510 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -469,6 +469,15 @@ enum {
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
+enum kvm_smccc_filter_action {
+	KVM_SMCCC_FILTER_ALLOW = 0,
+	KVM_SMCCC_FILTER_DENY,
+
+#ifdef __KERNEL__
+	NR_SMCCC_FILTER_ACTIONS
+#endif
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 05e588948e5a..50145d2132ae 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -65,7 +65,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
-static bool kvm_hvc_call_default_allowed(u32 func_id)
+static bool kvm_smccc_default_allowed(u32 func_id)
 {
 	switch (func_id) {
 	/*
@@ -93,7 +93,7 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
 	}
 }
 
-static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
+static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 
@@ -117,19 +117,30 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
 	default:
-		return kvm_hvc_call_default_allowed(func_id);
+		return false;
 	}
 }
 
+static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	if (kvm_smccc_test_fw_bmap(vcpu, func_id) ||
+	    kvm_smccc_default_allowed(func_id))
+		return KVM_SMCCC_FILTER_ALLOW;
+
+	return KVM_SMCCC_FILTER_DENY;
+}
+
 int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
+	u8 action;
 	gpa_t gpa;
 
-	if (!kvm_hvc_call_allowed(vcpu, func_id))
+	action = kvm_smccc_get_action(vcpu, func_id);
+	if (action == KVM_SMCCC_FILTER_DENY)
 		goto out;
 
 	switch (func_id) {
-- 
2.40.0.rc1.284.g88254d51c5-goog

