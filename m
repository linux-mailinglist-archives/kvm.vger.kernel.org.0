Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7447CEC0E
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjJRXc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJRXc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:32:27 -0400
Received: from out-206.mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C99B6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:32:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697671944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NX2tcg9Z9Bc5W2cmvgfkVb4+LcJ84+/C8FJrOnbT3KA=;
        b=FOMa3VW4bw27iK0cX0HTfIqaj36bFp6BzGmxd2eRJErhY5R/WQxafRNCedg5DNfsZEiL1P
        LqRpX9IkohZH4ldXWufLoHk7rI4q8b41NfMlvawJlpp1DT9zJDFq1XzecFDAeQMFHE9sop
        4YaGFZtz6tHnu3rRvdL3CMy4JCzRZEk=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 2/5] KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
Date:   Wed, 18 Oct 2023 23:32:09 +0000
Message-ID: <20231018233212.2888027-3-oliver.upton@linux.dev>
In-Reply-To: <20231018233212.2888027-1-oliver.upton@linux.dev>
References: <20231018233212.2888027-1-oliver.upton@linux.dev>
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

From: Marc Zyngier <maz@kernel.org>

An MMU notifier could cause us to clobber the stage-2 context loaded on
a CPU when we switch to another VM's context to invalidate. This isn't
an issue right now as the stage-2 context gets reloaded on every guest
entry, but is disastrous when moving __load_stage2() into the
vcpu_load() path.

Restore the previous stage-2 context on the way out of a TLB
invalidation if we installed something else. Deliberately do this after
TGE=1 is synchronized to keep things safe in light of the speculative AT
errata.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index f3f2e142e4f4..b636b4111dbf 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -11,18 +11,25 @@
 #include <asm/tlbflush.h>
 
 struct tlb_inv_context {
-	unsigned long	flags;
-	u64		tcr;
-	u64		sctlr;
+	struct kvm_s2_mmu	*mmu;
+	unsigned long		flags;
+	u64			tcr;
+	u64			sctlr;
 };
 
 static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 				  struct tlb_inv_context *cxt)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	u64 val;
 
 	local_irq_save(cxt->flags);
 
+	if (vcpu && mmu != vcpu->arch.hw_mmu)
+		cxt->mmu = vcpu->arch.hw_mmu;
+	else
+		cxt->mmu = NULL;
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/*
 		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
@@ -69,6 +76,10 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	isb();
 
+	/* ... and the stage-2 MMU context that we switched away from */
+	if (cxt->mmu)
+		__load_stage2(cxt->mmu, cxt->mmu->arch);
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Restore the registers to what they were */
 		write_sysreg_el1(cxt->tcr, SYS_TCR);
-- 
2.42.0.655.g421f12c284-goog

