Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDAB52D506
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiESNtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbiESNtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:49:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20AA1C11D
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A32ABB824D9
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0148C34115;
        Thu, 19 May 2022 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968070;
        bh=NKHi1S9dowrOA1pvVkNqiZvmnGHhmVg8DFJ6rMj+TKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqzWyoHjbCn6oAOlNYD9hpVLuM89F2FGpkJ8NTddouNuMdMtGPvDW877U56SGOwin
         YP84w9Rt6Em7GWReORDO1DQZCUsXVPuV01k+lII5m03Qx82csKUval6UmcuEzL7aPc
         utPesrK4fY3INarMNKM5CjIA6jYDQhF8TJASsqzR/v0GMepYn49ZPYnoyLlnzRMCcK
         Ni0YahpftDDpFzzEAB+emQPWWXNjNt86dlad9gzGM7G8yPXupPEXFtd6thBY4bs2XK
         4zWA4liV9l+GHzDQTU/6/cYgvby1i0anp7LaStJCoYwobBD6+GeOQSmdruEWTvwmSl
         r5ARzxRNMIDVg==
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
Subject: [PATCH 82/89] KVM: arm64: Support TLB invalidation in guest context
Date:   Thu, 19 May 2022 14:41:57 +0100
Message-Id: <20220519134204.5379-83-will@kernel.org>
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

Typically, TLB invalidation of guest stage-2 mappings using nVHE is
performed by a hypercall originating from the host. For the invalidation
instruction to be effective, therefore, __tlb_switch_to_{guest,host}()
swizzle the active stage-2 context around the TLBI instruction.

With guest-to-host memory sharing and unsharing hypercalls originating
from the guest under pKVM, there is now a need to support both guest
and host VMID invalidations issued from guest context.

Replace the __tlb_switch_to_{guest,host}() functions with a more general
{enter,exit}_vmid_context() implementation which supports being invoked
from guest context and acts as a no-op if the target context matches the
running context.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 96 ++++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f589..3f5601176fab 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -11,26 +11,62 @@
 #include <nvhe/mem_protect.h>
 
 struct tlb_inv_context {
-	u64		tcr;
+	struct kvm_s2_mmu	*mmu;
+	u64			tcr;
+	u64			sctlr;
 };
 
-static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
-				  struct tlb_inv_context *cxt)
+static void enter_vmid_context(struct kvm_s2_mmu *mmu,
+			       struct tlb_inv_context *cxt)
 {
+	struct kvm_s2_mmu *host_mmu = &host_kvm.arch.mmu;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *vcpu;
+
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+	cxt->mmu = NULL;
+
+	/*
+	 * If we're already in the desired context, then there's nothing
+	 * to do.
+	 */
+	if (vcpu) {
+		if (mmu == vcpu->arch.hw_mmu || WARN_ON(mmu != host_mmu))
+			return;
+	} else if (mmu == host_mmu) {
+		return;
+	}
+
+	cxt->mmu = mmu;
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
 		/*
 		 * For CPUs that are affected by ARM 1319367, we need to
-		 * avoid a host Stage-1 walk while we have the guest's
-		 * VMID set in the VTTBR in order to invalidate TLBs.
-		 * We're guaranteed that the S1 MMU is enabled, so we can
-		 * simply set the EPD bits to avoid any further TLB fill.
+		 * avoid a Stage-1 walk with the old VMID while we have
+		 * the new VMID set in the VTTBR in order to invalidate TLBs.
+		 * We're guaranteed that the host S1 MMU is enabled, so
+		 * we can simply set the EPD bits to avoid any further
+		 * TLB fill. For guests, we ensure that the S1 MMU is
+		 * temporarily enabled in the next context.
 		 */
 		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
 		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
 		write_sysreg_el1(val, SYS_TCR);
 		isb();
+
+		if (vcpu) {
+			val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
+			if (!(val & SCTLR_ELx_M)) {
+				val |= SCTLR_ELx_M;
+				write_sysreg_el1(val, SYS_SCTLR);
+				isb();
+			}
+		} else {
+			/* The host S1 MMU is always enabled. */
+			cxt->sctlr = SCTLR_ELx_M;
+		}
 	}
 
 	/*
@@ -39,20 +75,44 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	 * ensuring that we always have an ISB, but not two ISBs back
 	 * to back.
 	 */
-	__load_stage2(mmu, kern_hyp_va(mmu->arch));
+	if (vcpu)
+		__load_host_stage2();
+	else
+		__load_stage2(mmu, kern_hyp_va(mmu->arch));
+
 	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
-static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
+static void exit_vmid_context(struct tlb_inv_context *cxt)
 {
-	__load_host_stage2();
+	struct kvm_s2_mmu *mmu = cxt->mmu;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *vcpu;
+
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+
+	if (!mmu)
+		return;
+
+	if (vcpu)
+		__load_stage2(mmu, kern_hyp_va(mmu->arch));
+	else
+		__load_host_stage2();
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/* Ensure write of the host VMID */
+		/* Ensure write of the old VMID */
 		isb();
-		/* Restore the host's TCR_EL1 */
+
+		if (!(cxt->sctlr & SCTLR_ELx_M)) {
+			write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
+			isb();
+		}
+
 		write_sysreg_el1(cxt->tcr, SYS_TCR);
 	}
+
+	cxt->mmu = NULL;
 }
 
 void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
@@ -63,7 +123,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -106,7 +166,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	if (icache_is_vpipt())
 		icache_inval_all_pou();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
@@ -116,13 +176,13 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
@@ -130,14 +190,14 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	__tlbi(vmalle1);
 	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_flush_vm_context(void)
-- 
2.36.1.124.g0e6072fb45-goog

