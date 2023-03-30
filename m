Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824876D0A5F
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbjC3PuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 11:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbjC3PuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 11:50:14 -0400
Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E88BE076
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 08:49:49 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680191371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AoqsVgN2tC8iCvDotSp79/T9YBYSz/45h6FJpoqtxMc=;
        b=nLF7bDUgDg35HoPBI42zx08UNtovKD29TlEKTFWCwySfI2+zT//JrHQO+6iU33oF/dclao
        rz1KzQymreJ5Qai9Rv45tKeVDTGOK1XxXz4akUrBxPjkW4KpSs5bDjTpwEHgCrGm1qSW8S
        f2wu+ige54SCkrkj6u/KkDE3Cuon6bg=
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
Subject: [PATCH v2 02/13] KVM: arm64: Add a helper to check if a VM has ran once
Date:   Thu, 30 Mar 2023 15:49:07 +0000
Message-Id: <20230330154918.4014761-3-oliver.upton@linux.dev>
In-Reply-To: <20230330154918.4014761-1-oliver.upton@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
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

The test_bit(...) pattern is quite a lot of keystrokes. Replace
existing callsites with a helper.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/hypercalls.c       | 3 +--
 arch/arm64/kvm/pmu-emul.c         | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcd774d74f34..d091d1c9890b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1061,6 +1061,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(system_supports_32bit_el0() &&				\
 	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
 
+#define kvm_vm_has_ran_once(kvm)					\
+	(test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &(kvm)->arch.flags))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5da884e11337..a09a526a7d7c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -379,8 +379,7 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 
 	mutex_lock(&kvm->lock);
 
-	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) &&
-	    val != *fw_reg_bmap) {
+	if (kvm_vm_has_ran_once(kvm) && val != *fw_reg_bmap) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..a0fc569fdbca 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -880,7 +880,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	list_for_each_entry(entry, &arm_pmus, entry) {
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
-			if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) ||
+			if (kvm_vm_has_ran_once(kvm) ||
 			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
 				ret = -EBUSY;
 				break;
@@ -963,7 +963,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		mutex_lock(&kvm->lock);
 
-		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
+		if (kvm_vm_has_ran_once(kvm)) {
 			mutex_unlock(&kvm->lock);
 			return -EBUSY;
 		}
-- 
2.40.0.348.gf938b09366-goog

