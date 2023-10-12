Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E667C782E
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 22:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442824AbjJLUyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 16:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442643AbjJLUyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 16:54:38 -0400
Received: from out-195.mta1.migadu.com (out-195.mta1.migadu.com [IPv6:2001:41d0:203:375::c3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7C59D
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 13:54:37 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697144075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ysKrMhA787sO5UVDC8NhNunti56cIWj9yanawa7g7NY=;
        b=RJSVLSkUo1jGerM0C+jXC5LuQQOX0NXdEVkQulty3HZ4V8GJBZdNgx2SLjZ/v5G2kFNtNk
        +4nlqlOw0tMlBpX4+AJrbtQvXhV4srN0X1b5Z9M+XaF8wuH8Di1egaTeNFcgi4+jBrGWQ7
        48PIzaN4W4FSvw8nzDh2KCIjm6tEXWU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 2/5] KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
Date:   Thu, 12 Oct 2023 20:54:19 +0000
Message-ID: <20231012205422.3924618-3-oliver.upton@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
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
index f3f2e142e4f4..ef21153ce5fa 100644
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
+		cxt->mmu = mmu;
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

