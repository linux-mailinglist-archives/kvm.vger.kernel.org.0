Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A817BB455
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjJFJg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjJFJgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:36:24 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [IPv6:2001:41d0:203:375::be])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B29AD6
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 02:36:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696584978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/yIMo10s50+HEEuceJOygtADefYGavI8ddW8z0g0no=;
        b=ubEQae1wqPG7kyr3OrdWayUEFDvyQH/gBNN/t013RPbSVdJY2mpxhSryDHJ4cTXx12Jdsc
        gxfdRwcDG0ShuOKA7qTnES557j5PB8lsxPXKQ2qH0O8qR/zFTRpq0xvb2SHTBJgoKeFHiL
        EaGHxGERYRgX4YuQ3AudB+wD16TW8RU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
Date:   Fri,  6 Oct 2023 09:36:00 +0000
Message-ID: <20231006093600.1250986-4-oliver.upton@linux.dev>
In-Reply-To: <20231006093600.1250986-1-oliver.upton@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
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

To date the VHE code has aggressively reloaded the stage-2 MMU context
on every guest entry, despite the fact that this isn't necessary. This
was probably done for consistency with the nVHE code, which needs to
switch in/out the stage-2 MMU context as both the host and guest run at
EL1.

Hoist __stage2_load() into kvm_vcpu_load_vhe(), thus avoiding a reload
on every guest entry/exit. This is likely to be beneficial to systems
with one of the speculative AT errata, as there is now one less context
synchronization event on the guest entry path. Additionally, it is
possible that implementations have hitched correctness mitigations on
writes to VTTBR_EL2, which are now elided on guest re-entry.

Note that __tlb_switch_to_guest() is deliberately left untouched as it
can be called outside the context of a running vCPU.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d05b6a08dcde..b0cafd7c5f8f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,6 +120,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 {
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
+	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
 }
 
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
@@ -182,17 +183,11 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_save_host_state_vhe(host_ctxt);
 
 	/*
-	 * ARM erratum 1165522 requires us to configure both stage 1 and
-	 * stage 2 translation for the guest context before we clear
-	 * HCR_EL2.TGE.
-	 *
-	 * We have already configured the guest's stage 1 translation in
-	 * kvm_vcpu_load_sysregs_vhe above.  We must now call
-	 * __load_stage2 before __activate_traps, because
-	 * __load_stage2 configures stage 2 translation, and
-	 * __activate_traps clear HCR_EL2.TGE (among other things).
+	 * Note that ARM erratum 1165522 requires us to configure both stage 1
+	 * and stage 2 translation for the guest context before we clear
+	 * HCR_EL2.TGE. The stage 1 and stage 2 guest context has already been
+	 * loaded on the CPU in kvm_vcpu_load_vhe().
 	 */
-	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
 	__activate_traps(vcpu);
 
 	__kvm_adjust_pc(vcpu);
-- 
2.42.0.609.gbb76f46606-goog

