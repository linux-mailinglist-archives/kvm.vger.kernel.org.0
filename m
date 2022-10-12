Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8BB5FCA67
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJLSRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiJLSRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4BF6AA0F
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:22 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t21-20020a056a0021d500b0056358536cdeso4801510pfj.22
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HGu23Wr+qHQVNklFm3PpeuujWY5OcBocaxwK/75/O5s=;
        b=r6J9FqsfaxJSHD4tY9LVFpySVzsbTFiE91iL9h1qUa0sv5QFxq/m/ieFoiZbvvhHus
         KnsqUi4onZbRHZeEE1XOH5O7kG9wrZgxVHkOMYlkNM9QvQNOsqiPxHVSavmI18DJ77fI
         MZFYY6onEA5K6v9n2kki8CFia8IxP3aJusSWvPcjkwoRc9MmPGB50BO/KWmarPsfJ2Xx
         Jzd07R5PG30W1fLz9Tl67fFI2TkvyyXKVV4KDurwgOz0yLpycZgkwq1pT7irqDpF7Yhd
         R9Knw8jqLStNWl3BfZyMoEPBNxeJzNt6EDrqF1ePMA/+vYjY5JNm8F+EnXnxz0DPYwUO
         C78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HGu23Wr+qHQVNklFm3PpeuujWY5OcBocaxwK/75/O5s=;
        b=RNYk/FVdwFMKD/L/INz3OgAiQdsoIbQh2yMme+rXAKYI88DVclgtGjjYlsrqvDjh90
         OJ6iNGP/K9Uot+m08cC9jun4a/z+buuMW+jfxpI6lczmxoK5r1xIVM1WtV90Wg0komle
         ykMir9NPjz2xki4YFPfFT04pY9R009BEFrptvP8Wi3bDqK/fn4z3bW54I8mkBC0v0JRO
         Frm68ogZQG+9mjyARJS+oqFGrElMIP2caty+rUKv79fV7QYrCJKp/w/19vxBmE6wMLsE
         dsqR7vnK9SM41985uEF/cViVeDKWnCRent1Z6aWtXXLWnyYPRQ/+4VlEcamcwwUoBvJP
         GIwQ==
X-Gm-Message-State: ACrzQf1ivOrzY5Cv4AmMFptLnC5QBRpuMPAeUOA2R/sS7OtYpN4YKznG
        wneA0Nouv5at7Ejw/kdcy2P+db7cOR4=
X-Google-Smtp-Source: AMsMyM54w4ZsjtZ+hfVdEHLx8pp2DhfoZcjJXZA++yCmPm4WyMuAzZv0oPKKJqJybZMDuzDtqtyybHDI8T0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr556759pjt.1.1665598641021; Wed, 12 Oct
 2022 11:17:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:59 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-9-seanjc@google.com>
Subject: [PATCH v4 08/11] KVM: x86/mmu: Pivot on "TDP MMU enabled" to check if
 active MMU is TDP MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify and optimize the logic for detecting if the current/active MMU
is a TDP MMU.  If the TDP MMU is globally enabled, then the active MMU is
a TDP MMU if it is direct.  When TDP is enabled, so called nonpaging MMUs
are never used as the only form of shadow paging KVM uses is for nested
TDP, and the active MMU can't be direct in that case.

Rename the helper and take the vCPU instead of an arbitrary MMU, as
nonpaging MMUs can show up in the walk_mmu if L1 is using nested TDP and
L2 has paging disabled.  Taking the vCPU has the added bonus of cleaning
up the callers, all of which check the current MMU but wrap code that
consumes the vCPU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 11 ++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h | 18 ------------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fe3aa890a487..1598aaf29c4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -615,9 +615,14 @@ static bool mmu_spte_age(u64 *sptep)
 	return true;
 }
 
+static inline bool is_tdp_mmu_active(struct kvm_vcpu *vcpu)
+{
+	return is_tdp_mmu_enabled() && vcpu->arch.mmu->root_role.direct;
+}
+
 static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 {
-	if (is_tdp_mmu(vcpu->arch.mmu)) {
+	if (is_tdp_mmu_active(vcpu)) {
 		kvm_tdp_mmu_walk_lockless_begin();
 	} else {
 		/*
@@ -636,7 +641,7 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 
 static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 {
-	if (is_tdp_mmu(vcpu->arch.mmu)) {
+	if (is_tdp_mmu_active(vcpu)) {
 		kvm_tdp_mmu_walk_lockless_end();
 	} else {
 		/*
@@ -3997,7 +4002,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 
 	walk_shadow_page_lockless_begin(vcpu);
 
-	if (is_tdp_mmu(vcpu->arch.mmu))
+	if (is_tdp_mmu_active(vcpu))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
 		leaf = get_walk(vcpu, addr, sptes, &root);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 9d086a103f77..5808f32e4a45 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -70,26 +70,8 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 
 #ifdef CONFIG_X86_64
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
-
-static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
-{
-	struct kvm_mmu_page *sp;
-	hpa_t hpa = mmu->root.hpa;
-
-	if (WARN_ON(!VALID_PAGE(hpa)))
-		return false;
-
-	/*
-	 * A NULL shadow page is legal when shadowing a non-paging guest with
-	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
-	 * pae_root page, not a shadow page.
-	 */
-	sp = to_shadow_page(hpa);
-	return sp && is_tdp_mmu_page(sp) && sp->root_count;
-}
 #else
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
-static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
 #endif
 
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.38.0.rc1.362.ged0d419d3c-goog

