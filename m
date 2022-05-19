Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8093F52D4E1
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbiESNrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiESNq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE59442A16
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCCF8617CA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD38BC36AE7;
        Thu, 19 May 2022 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967995;
        bh=ZcIfzGb/vK2vfQ80a6r+rH0+I9h0CSiL3sHfSlkSKFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koKvS2BJfJlWQTyHB1/GcP7ECOIzwWeD22WksHUY4txSEj3OsGg68jqB7dg6xdVVS
         42zLeqlHJAiu6Pd+gq96X8ili4d6uLSrfnVV8g4ODy/BdYaSxPSb6awiqPIviPBkkZ
         KkOOhGxtG0AII2SbMTVwEiRFYMeVzPyvVDjPgH7xWDYRvFu6D5zfD/sou5vU42f9Q3
         ATqxWYa+6vp3uT4QNdyWMeYHxsyY+mOhd2bY0uoLYQxjPSX8s2l204k5tVbNTQAzTo
         agrhMliNtz7gWMJSEoDEYYFUCwtoXaK/9KAH7RWqoXeAjHyRBOFSeAt25tlOgt9tN1
         dd0v//a7iD2Ng==
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
Subject: [PATCH 63/89] KVM: arm64: Fix initializing traps in protected mode
Date:   Thu, 19 May 2022 14:41:38 +0100
Message-Id: <20220519134204.5379-64-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

The values of the trapping registers for protected VMs should be
computed from the ground up, and not depend on potentially
preexisting values.

Moreover, non-protected VMs should not be restricted in protected
mode in the same manner as protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 48 ++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2c13ba0f2bf2..839506a546c7 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -168,34 +168,48 @@ static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
  */
 static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 {
-	const u64 hcr_trap_feat_regs = HCR_TID3;
-	const u64 hcr_trap_impdef = HCR_TACR | HCR_TIDCP | HCR_TID1;
-
 	/*
 	 * Always trap:
 	 * - Feature id registers: to control features exposed to guests
 	 * - Implementation-defined features
 	 */
-	vcpu->arch.hcr_el2 |= hcr_trap_feat_regs | hcr_trap_impdef;
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS |
+			     HCR_TID3 | HCR_TACR | HCR_TIDCP | HCR_TID1;
+
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
 
-	/* Clear res0 and set res1 bits to trap potential new features. */
-	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
-	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-	vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+
+	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID2;
 }
 
 /*
  * Initialize trap register values for protected VMs.
  */
-static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct kvm_vcpu *shadow_vcpu, struct kvm_vcpu *host_vcpu)
 {
-	pvm_init_trap_regs(vcpu);
-	pvm_init_traps_aa64pfr0(vcpu);
-	pvm_init_traps_aa64pfr1(vcpu);
-	pvm_init_traps_aa64dfr0(vcpu);
-	pvm_init_traps_aa64mmfr0(vcpu);
-	pvm_init_traps_aa64mmfr1(vcpu);
+	shadow_vcpu->arch.cptr_el2 = CPTR_EL2_DEFAULT;
+	shadow_vcpu->arch.mdcr_el2 = 0;
+
+	if (!vcpu_is_protected(shadow_vcpu)) {
+		shadow_vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS |
+					    READ_ONCE(host_vcpu->arch.hcr_el2);
+		return;
+	}
+
+	pvm_init_trap_regs(shadow_vcpu);
+	pvm_init_traps_aa64pfr0(shadow_vcpu);
+	pvm_init_traps_aa64pfr1(shadow_vcpu);
+	pvm_init_traps_aa64dfr0(shadow_vcpu);
+	pvm_init_traps_aa64mmfr0(shadow_vcpu);
+	pvm_init_traps_aa64mmfr1(shadow_vcpu);
 }
 
 /*
@@ -364,7 +378,7 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 
 		shadow_vcpu->arch.hw_mmu = &vm->kvm.arch.mmu;
 
-		pkvm_vcpu_init_traps(shadow_vcpu);
+		pkvm_vcpu_init_traps(shadow_vcpu, host_vcpu);
 	}
 
 	return 0;
-- 
2.36.1.124.g0e6072fb45-goog

