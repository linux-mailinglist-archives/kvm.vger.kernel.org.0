Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A0503185
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiDOWB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356162AbiDOWBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:49 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7479C60F2
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:20 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id l2-20020a4ab0c2000000b00334cb56f0a5so2342553oon.17
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=22i24DLcyXUieSnW3PAwQCkjoUnvyMWdp2sKJnAUF64=;
        b=VPtHgLB2eymVJQjQSElXFQ0Zv2gLUgxLry175CS0FCPH1QdUk/jXMMBoPOrHmGBwoq
         eWdmwHWefSkyKrTkoNNUmWeZAwfQOesyHQ/c4F+nNUh1RnLeH6LvowZHB8nX3nwQ6l3L
         GEUKEunrQWJsjT9PH9meExTOYNHH3hU7S6IfE1PLsiTpOqRRkTbel/mLpuqamcBbNfG9
         GoFAe3BQFqD1GHm76/Rdvr36nNdmSstr6rfNRpwHof4KzfU+AjgBiLREY1NzMY207hNQ
         sxhnRfFngtq2kuNUX0v2DKU0e2znK8YIUUSoecH7YVoHWITRrIMv7LGu6/DrG+fBMRUD
         Iqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=22i24DLcyXUieSnW3PAwQCkjoUnvyMWdp2sKJnAUF64=;
        b=egHPP79YGki9fwyBuRAT/he9wqjgQmsjyI/NQ0eYksI4c+uI3JuC9gubKPdv7xxV+k
         fqf/3HSG2CZ6gqHZN0LZTBQKJYmWvqbPxrfifti14/tHlzhT4xCkz/MFCAf6hj1ho9jN
         giYnWPx8h7hHK4O89OnDh7zkT91eSBm74HbyqEubseLpUthY5gmLzqDyNM/2P7Nig5lT
         2v3o4Ue5ys7hDMEOGIBSjnZPwlQMTPAa3iWAhCsCgf7GvWmiWL/J7mP5eR5EQ8AZzOzw
         417CRCJjJAEZApl6JYPUq2+dC0+tsjbwtIUPYBG+Ia3p/rqAQ3Ix3vvUbS0zm4rCdSrU
         9/3A==
X-Gm-Message-State: AOAM5330xfzgCpf/Kl1GB74fZNfo3zJ+Yb3/F75Pl1xRXXnsoasGLwDB
        U/rm60vXcrOvbfykGmy4m2vwDNLcRec=
X-Google-Smtp-Source: ABdhPJya0hEPL3+v3IGSw82KDihmFFDLjFiBSt27i0G11hzjmjLYmOhkEY2+c79aK0bz4MZlGmwNEBfJ24k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:639e:b0:e2:ab7c:d868 with SMTP id
 t30-20020a056870639e00b000e2ab7cd868mr373366oap.108.1650059959809; Fri, 15
 Apr 2022 14:59:19 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:56 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-13-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 12/17] KVM: arm64: Stuff mmu page cache in sub struct
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're about to add another mmu cache. Stuff the current one in a sub
struct so its easier to pass them all to ->zalloc_page().

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++-
 arch/arm64/kvm/mmu.c              | 14 +++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..c8947597a619 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -372,7 +372,9 @@ struct kvm_vcpu_arch {
 	bool pause;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	struct kvm_mmu_caches {
+		struct kvm_mmu_memory_cache page_cache;
+	} mmu_caches;
 
 	/* Target CPU and feature flags */
 	int target;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f29d5179196b..7a588928740a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -91,10 +91,10 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 
 static void *stage2_memcache_zalloc_page(void *arg)
 {
-	struct kvm_mmu_memory_cache *mc = arg;
+	struct kvm_mmu_caches *mmu_caches = arg;
 
 	/* Allocated with __GFP_ZERO, so no need to zero */
-	return kvm_mmu_memory_cache_alloc(mc);
+	return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
 }
 
 static void *kvm_host_zalloc_pages_exact(size_t size)
@@ -1073,7 +1073,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool shared;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_caches *mmu_caches = &vcpu->arch.mmu_caches;
 	struct vm_area_struct *vma;
 	short vma_shift;
 	gfn_t gfn;
@@ -1160,7 +1160,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
 	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
+		ret = kvm_mmu_topup_memory_cache(&mmu_caches->page_cache,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			return ret;
@@ -1273,7 +1273,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache);
+					     mmu_caches);
 	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
@@ -1603,12 +1603,12 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 
 void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->arch.mmu_caches.page_cache.gfp_zero = __GFP_ZERO;
 }
 
 void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_caches.page_cache);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.36.0.rc0.470.gd361397f0d-goog

