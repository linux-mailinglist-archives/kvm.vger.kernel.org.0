Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE35030A8
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356162AbiDOWB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356169AbiDOWBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:50 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DE7E80
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:21 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id i19-20020a5d9353000000b006495ab76af6so5477936ioo.0
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+7THeEZjrQkI4cL8qs69/ZVQNerdV4AViBcRVZLLx0E=;
        b=sgJWtGYVInFd1drSIPRRI4aezVykNPn0h3TZjKKiErpQM7sAIHOOKNGcQ0jWe9x2J3
         4uorM5vPe/np9qjkIYA4dfw4gtmkWWOabaU8tGatq8w8LsDoUg9+FMK0LVF1fX+QFyw6
         i9msKz6hKpt7r66C+xns81BxvuHbanyJZ610bbwgkWkEmS6Xl9AcIZ1z+pnbftljqbuV
         TZJnMR1dtR7pvNgtOgZtS1KwcCNK2XXzdflPkGu6sg9JhoQgHweTSx9tVIIm2620GETp
         v/lovjRa15qTioUPiP/HsnkVKkyBFJUAm8nxrDqS7jgG1Smlaj2NKciPmkptKeLE+kdI
         nEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+7THeEZjrQkI4cL8qs69/ZVQNerdV4AViBcRVZLLx0E=;
        b=IMSASfOS5CzjGEJpc9TUTHICeMW5ihX1mPOTL9qfVnyFyTX1PDxAtRCIIIyWSX7ZDE
         L2jFvj7ZBVaNOXPWV4hy8WnrrNoKP8TmCQTJZeFXqJZVEsUguuwmpIGRIxOozgnWrucU
         hFB7GcVF3FBjV/6+4rXYssWRMxdTpbDCd5S++T06Bi9FSbJgAtGOoP6aN6LOSBFQXl/W
         SpyVBcUh+AkKzlQeWhenrfK5PzWD9zNWvDb8RqsDwdjnqDcHo07Hw0RSoT279TmMYlyd
         uin3HKAbiFqmIEsE2OpSK+DQtHvQ0n2nqxcwA8yR9PVzYhn57UGGnKzseLMYc7dFGPzK
         DL9g==
X-Gm-Message-State: AOAM533Ez0YtCbUzsDundfxzDHKcBB1pb6h+BG3ijB8RG3ZQ545s61Ev
        y57q+wR+eOVQ2jIggvmXkBEEic4YCdk=
X-Google-Smtp-Source: ABdhPJyV71KyX7wIk4SdepWHYsPDO7JEsMOtpP8Ew2zkdCBFEtHJx6sDDgdROjEilaiKBOX2bMTgAgDq5z4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:8a07:0:b0:64c:8b33:6d19 with SMTP id
 d7-20020a5e8a07000000b0064c8b336d19mr315910iok.170.1650059960675; Fri, 15 Apr
 2022 14:59:20 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:57 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-14-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 13/17] KVM: arm64: Setup cache for stage2 page headers
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

In order to punt the last reference drop on a page to an RCU
synchronization we need to get a pointer to the page to handle the
callback.

Set up a memcache for stage2 page headers, but do nothing with it for
now. Note that the kmem_cache is never destoyed as it is currently not
possible to build KVM/arm64 as a module.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/mmu.c              | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c8947597a619..a640d015790e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -374,6 +374,7 @@ struct kvm_vcpu_arch {
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_caches {
 		struct kvm_mmu_memory_cache page_cache;
+		struct kvm_mmu_memory_cache header_cache;
 	} mmu_caches;
 
 	/* Target CPU and feature flags */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7a588928740a..cc6ed6b06ec2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,6 +31,12 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
+static struct kmem_cache *stage2_page_header_cache;
+
+struct stage2_page_header {
+	struct rcu_head rcu_head;
+	struct page *page;
+};
 
 /*
  * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
@@ -1164,6 +1170,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			return ret;
+
+		ret = kvm_mmu_topup_memory_cache(&mmu_caches->header_cache,
+						 kvm_mmu_cache_min_pages(kvm));
+		if (ret)
+			return ret;
 	}
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
@@ -1589,6 +1600,13 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 	if (err)
 		goto out_destroy_pgtable;
 
+	stage2_page_header_cache = kmem_cache_create("stage2_page_header",
+						     sizeof(struct stage2_page_header),
+						     0, SLAB_ACCOUNT, NULL);
+
+	if (!stage2_page_header_cache)
+		goto out_destroy_pgtable;
+
 	io_map_base = hyp_idmap_start;
 	return 0;
 
@@ -1604,11 +1622,13 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 void kvm_mmu_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.mmu_caches.page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->arch.mmu_caches.header_cache.kmem_cache = stage2_page_header_cache;
 }
 
 void kvm_mmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_caches.page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_caches.header_cache);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.36.0.rc0.470.gd361397f0d-goog

