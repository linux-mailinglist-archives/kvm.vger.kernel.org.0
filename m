Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B20D6D67BF
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbjDDPmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbjDDPmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:42:06 -0400
Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5445275
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:41:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680622888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6Ri1ZueZlnftyflHTC7/SP3fREozY6pRxymvlj4mZc=;
        b=rVL2CGj+2y0erE6UTfchWmuZj892kpZtDFI7cFr+4wpUQhf1MQz3JBD8J0v+qu8vt0huTL
        7+BzafAHDYjnNhYjhD08OcgsLPIpBF2hujx2bPQJY2hcspQLquFJ/U343kUGd9ceORlS+3
        ABFqQhQTf3HKsoZm6NkVw2lKhXAjyQI=
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
Subject: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Date:   Tue,  4 Apr 2023 15:40:45 +0000
Message-Id: <20230404154050.2270077-9-oliver.upton@linux.dev>
In-Reply-To: <20230404154050.2270077-1-oliver.upton@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
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

In anticipation of user hypercall filters, add the necessary plumbing to
get SMCCC calls out to userspace. Even though the exit structure has
space for KVM to pass register arguments, let's just avoid it altogether
and let userspace poke at the registers via KVM_GET_ONE_REG.

This deliberately stretches the definition of a 'hypercall' to cover
SMCs from EL1 in addition to the HVCs we know and love. KVM doesn't
support EL1 calls into secure services, but now we can paint that as a
userspace problem and be done with it.

Finally, we need a flag to let userspace know what conduit instruction
was used (i.e. SMC vs. HVC).

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst    | 18 ++++++++++++++++--
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/handle_exit.c      |  4 +++-
 arch/arm64/kvm/hypercalls.c       | 16 ++++++++++++++++
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9b01e3d0e757..9497792c4ee5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6221,11 +6221,25 @@ to the byte array.
 			__u64 flags;
 		} hypercall;
 
-Unused.  This was once used for 'hypercall to userspace'.  To implement
-such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
+
+It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
+``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
+requires a guest to interact with host userpace.
 
 .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
 
+For arm64:
+----------
+
+``nr`` contains the function ID of the guest's SMCCC call. Userspace is
+expected to use the ``KVM_GET_ONE_REG`` ioctl to retrieve the call
+parameters from the vCPU's GPRs.
+
+Definition of ``flags``:
+ - ``KVM_HYPERCALL_EXIT_SMC``: Indicates that the guest used the SMC
+   conduit to initiate the SMCCC call. If this bit is 0 then the guest
+   used the HVC conduit for the SMCCC call.
+
 ::
 
 		/* KVM_EXIT_TPR_ACCESS */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f9672ef1159a..f86446c5a7e3 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -472,12 +472,16 @@ enum {
 enum kvm_smccc_filter_action {
 	KVM_SMCCC_FILTER_HANDLE = 0,
 	KVM_SMCCC_FILTER_DENY,
+	KVM_SMCCC_FILTER_FWD_TO_USER,
 
 #ifdef __KERNEL__
 	NR_SMCCC_FILTER_ACTIONS
 #endif
 };
 
+/* arm64-specific KVM_EXIT_HYPERCALL flags */
+#define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 68f95dcd41a1..3f43e20c48b6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -71,7 +71,9 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 * Trap exception, not a Secure Monitor Call exception [...]"
 	 *
 	 * We need to advance the PC after the trap, as it would
-	 * otherwise return to the same address...
+	 * otherwise return to the same address. Furthermore, pre-incrementing
+	 * the PC before potentially exiting to userspace maintains the same
+	 * abstraction for both SMCs and HVCs.
 	 */
 	kvm_incr_pc(vcpu);
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index ba7cd84c6668..2db53709bec1 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -180,6 +180,19 @@ static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
 	return KVM_SMCCC_FILTER_DENY;
 }
 
+static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	u8 ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
+	struct kvm_run *run = vcpu->run;
+
+	run->exit_reason = KVM_EXIT_HYPERCALL;
+	run->hypercall.nr = func_id;
+	run->hypercall.flags = 0;
+
+	if (ec == ESR_ELx_EC_SMC32 || ec == ESR_ELx_EC_SMC64)
+		run->hypercall.flags |= KVM_HYPERCALL_EXIT_SMC;
+}
+
 int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
@@ -195,6 +208,9 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case KVM_SMCCC_FILTER_DENY:
 		goto out;
+	case KVM_SMCCC_FILTER_FWD_TO_USER:
+		kvm_prepare_hypercall_exit(vcpu, func_id);
+		return 0;
 	default:
 		WARN_RATELIMIT(1, "Unhandled SMCCC filter action: %d\n", action);
 		goto out;
-- 
2.40.0.348.gf938b09366-goog

