Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB1652D4FD
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiESNsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbiESNr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA38D028B
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33276B824A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A117C385AA;
        Thu, 19 May 2022 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968030;
        bh=hCh5aMXsjpfqNJ0ujhIzhZM+KshM303G+POWXF8vjmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpObs3l33bmi2hgGcZfQGielUdcM4kiaTitgszKPs+CAXPpQgg3DOTn+vtj7f/FA8
         3O7wmJz2Oo92OeK3eiHNZlE6YbQAjYjHcighQwArM8zp8MEPexpWB7X6kBaW1LapNl
         vlA/B03vD6+WJFpPbWuX0cEA/qfvGGjKgYbz7J5NnxLhCMcHIJd0bl7ZQcJQIkZkyM
         jO5NXEPxUQw4aaO5yh2+J+j3OzdL96JkVUrCojCtQtJ5H4I4+H/zLufXur3kEGH6jD
         FxeD34LXtYEIE1Fi2SopnbaioFPax+Dt4ve6AN5gds75b8IFtvPsi+pbGGYFiCjcii
         dwLjo9/zYy7PQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 72/89] KVM: arm64: Track the SVE state in the shadow vcpu
Date:   Thu, 19 May 2022 14:41:47 +0100
Message-Id: <20220519134204.5379-73-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

When dealing with a guest with SVE enabled, make sure the host SVE
state is pinned at EL2 S1, and that the shadow state is correctly
initialised (and then unpinned on teardown).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  9 ++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 33 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5d6cee7436f4..1e39dc7eab4d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -416,8 +416,7 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 		if (host_flags & KVM_ARM64_PKVM_STATE_DIRTY)
 			__flush_vcpu_state(shadow_state);
 
-		shadow_vcpu->arch.sve_state = kern_hyp_va(host_vcpu->arch.sve_state);
-		shadow_vcpu->arch.sve_max_vl = host_vcpu->arch.sve_max_vl;
+		shadow_vcpu->arch.flags = host_flags;
 
 		shadow_vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS & ~(HCR_RW | HCR_TWI | HCR_TWE);
 		shadow_vcpu->arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2);
@@ -488,8 +487,10 @@ static void sync_shadow_state(struct kvm_shadow_vcpu_state *shadow_state,
 		BUG();
 	}
 
-	host_flags = READ_ONCE(host_vcpu->arch.flags) &
-		~(KVM_ARM64_PENDING_EXCEPTION | KVM_ARM64_INCREMENT_PC);
+	host_flags = shadow_vcpu->arch.flags;
+	if (shadow_state_is_protected(shadow_state))
+		host_flags &= ~(KVM_ARM64_PENDING_EXCEPTION | KVM_ARM64_INCREMENT_PC);
+
 	WRITE_ONCE(host_vcpu->arch.flags, host_flags);
 	shadow_state->exit_code = exit_reason;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 51da5c1d7e0d..9feeb0b5433a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -372,7 +372,19 @@ static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
 
 	for (i = 0; i < nr_vcpus; i++) {
 		struct kvm_vcpu *host_vcpu = shadow_vcpu_states[i].host_vcpu;
+		struct kvm_vcpu *shadow_vcpu = &shadow_vcpu_states[i].shadow_vcpu;
+		size_t sve_state_size;
+		void *sve_state;
+
 		hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
+
+		if (!test_bit(KVM_ARM_VCPU_SVE, shadow_vcpu->arch.features))
+			continue;
+
+		sve_state = shadow_vcpu->arch.sve_state;
+		sve_state = kern_hyp_va(sve_state);
+		sve_state_size = vcpu_sve_state_size(shadow_vcpu);
+		hyp_unpin_shared_mem(sve_state, sve_state + sve_state_size);
 	}
 }
 
@@ -448,6 +460,27 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 		if (ret)
 			return ret;
 
+		if (test_bit(KVM_ARM_VCPU_SVE, shadow_vcpu->arch.features)) {
+			size_t sve_state_size;
+			void *sve_state;
+
+			shadow_vcpu->arch.sve_state = READ_ONCE(host_vcpu->arch.sve_state);
+			shadow_vcpu->arch.sve_max_vl = READ_ONCE(host_vcpu->arch.sve_max_vl);
+
+			sve_state = kern_hyp_va(shadow_vcpu->arch.sve_state);
+			sve_state_size = vcpu_sve_state_size(shadow_vcpu);
+
+			if (!shadow_vcpu->arch.sve_state || !sve_state_size ||
+			    hyp_pin_shared_mem(sve_state,
+					       sve_state + sve_state_size)) {
+				clear_bit(KVM_ARM_VCPU_SVE,
+					  shadow_vcpu->arch.features);
+				shadow_vcpu->arch.sve_state = NULL;
+				shadow_vcpu->arch.sve_max_vl = 0;
+				return -EINVAL;
+			}
+		}
+
 		pkvm_vcpu_init_traps(shadow_vcpu, host_vcpu);
 		kvm_reset_pvm_sys_regs(shadow_vcpu);
 	}
-- 
2.36.1.124.g0e6072fb45-goog

