Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8452D4D3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiESNrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiESNqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:46:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962FE11A24
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E1F8617C1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F12C36AE3;
        Thu, 19 May 2022 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967963;
        bh=7ZFIfc31Ljwo59UHFdAV6Hez2rIIXtc9xnETxzvgDvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNozO7SAuAmOJdzhDHTWB9npt/YWIKfntAwQlt+/2AvOsFzCQNebP/51xqpn41wk1
         96KzcgKZXipkIg24qNupD07sJ2r64RuIRxqqo1tJ2a32q2UXrSAldrnfIb98VURoY5
         YUYDNmr873wEVy0bboxF855tUenGFoqND3EUw0sweETF5f59IHlF51rMLc61GSPmvT
         WPb1ZTT5+2GypfGQPtEo94PyYFeAAyMP4yA+Gg6VuN1n8ZAyngEJ+zHZK0izgZbvRi
         W8oSNpgO9c0UAULEJ5YJQY0ncWOdyZtoKVrCaIJwwq6kStQ/pz+YT2diOGExHV+yM/
         nfjt/yA+6Accw==
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
Subject: [PATCH 55/89] KVM: arm64: Do not pass the vcpu to __pkvm_host_map_guest()
Date:   Thu, 19 May 2022 14:41:30 +0100
Message-Id: <20220519134204.5379-56-will@kernel.org>
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

__pkvm_host_map_guest() always applies to the loaded vcpu in hyp, and
should not trust the host to provide the vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 15 ++++-----------
 arch/arm64/kvm/mmu.c               |  6 +++---
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e82c0faf6c81..0f1c9d27f6eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -445,20 +445,15 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 3);
-	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *host_vcpu;
 	struct kvm_vcpu *shadow_vcpu;
-	struct kvm *host_kvm;
-	unsigned int handle;
+	struct kvm_shadow_vcpu_state *shadow_state;
 	int ret = -EINVAL;
 
 	if (!is_protected_kvm_enabled())
 		goto out;
 
-	host_vcpu = kern_hyp_va(host_vcpu);
-	host_kvm = kern_hyp_va(host_vcpu->kvm);
-	handle = host_kvm->arch.pkvm.shadow_handle;
-	shadow_state = pkvm_load_shadow_vcpu_state(handle, host_vcpu->vcpu_idx);
+	shadow_state = pkvm_loaded_shadow_vcpu_state();
 	if (!shadow_state)
 		goto out;
 
@@ -468,11 +463,9 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 	/* Topup shadow memcache with the host's */
 	ret = pkvm_refill_memcache(shadow_vcpu, host_vcpu);
 	if (ret)
-		goto out_put_state;
+		goto out;
 
 	ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
-out_put_state:
-	pkvm_put_shadow_vcpu_state(shadow_state);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c74c431588a3..137d4382ed1c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1143,9 +1143,9 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	return 0;
 }
 
-static int pkvm_host_map_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
+static int pkvm_host_map_guest(u64 pfn, u64 gfn)
 {
-	int ret = kvm_call_hyp_nvhe(__pkvm_host_map_guest, pfn, gfn, vcpu);
+	int ret = kvm_call_hyp_nvhe(__pkvm_host_map_guest, pfn, gfn);
 
 	/*
 	 * Getting -EPERM at this point implies that the pfn has already been
@@ -1211,7 +1211,7 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	write_lock(&kvm->mmu_lock);
 	pfn = page_to_pfn(page);
-	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT, vcpu);
+	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT);
 	if (ret) {
 		if (ret == -EAGAIN)
 			ret = 0;
-- 
2.36.1.124.g0e6072fb45-goog

