Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462AF514002
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353790AbiD2BIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353773AbiD2BHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5660EBCB56
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b6-20020a170903228600b0015d22ba49a9so3472391plh.16
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NFp7K8Sjv/vAI1JLTFSd8X9Uxcf8+O/4N0wyohIecW4=;
        b=MeMNHrhvIY+IQbG/CYO0Q1CrteMY07/gcrCNOfHdmVywdCt8O2Plv1D3u7ZpG3x1nI
         MM3swrVCIMXp5XaKHm7JyyLeetRDMFAqc8g+KFGypMsa7MLFQJABwBPvsPV+dAQmKRw2
         X2g/tIBZO/VbKQnAdxN55H7rPoz6jBZSmtjH5hzD1HGDJOcOpP/hwwBHIBAanPDoS9f5
         +y6cd/4+1MJ6szaQSA8aI5AJq5kahtqBv4IEfVTrcr+glJ1c1JEU68zRmuXzzULqQNJr
         DvnPR1IO05cHIZcSBcpyvdGFRDjij7wP628IE2/JeRWUxD1cQLvzL/prRi+Eq41aa2Of
         A8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NFp7K8Sjv/vAI1JLTFSd8X9Uxcf8+O/4N0wyohIecW4=;
        b=pe5oxoNyi93p+bbrKvHgjyeb3yFwOvedRCJHM6kZqVjhuh/zhTMjQksTS6lL/AlfC+
         V0wYLb0EGuQ+vH+hCD1u+1A9IRm5+d39g+IYu/ojGcnPlmwVAuyh2MjRqrfkxeWhJ+wk
         dr6dyo3OA7p1QmvR+7fXLyw5UM7DKzOFgvcNxB0PArOZJV4F5mMrQGvKXz1eaqGiMcdu
         s+6beaBGX10G0YlQ2WgibsJa7OMo+G2G85T/1OprjUrpdhi3kXe+pJA3WiyuM6uIvmR2
         mJ1akjEEpPZDbWfJHmpeadb/p/3wHBqx8gy6sdwgpk1Vi9xMU/eY7oIA7T2o6tfk1ecy
         FTqg==
X-Gm-Message-State: AOAM531ZPcXRJ1hFb6+u9H7LVgi0cbJQdJpBkdB87BwYrVpyZg9/9bsX
        aoJHTFSnjiUZfLoi503IUFQpQnaq0C0=
X-Google-Smtp-Source: ABdhPJx8581mpEqS+OF/vbbg6/vEcOQagjZDHIrCx+28J0pzty67F/6uDSxH0CAfDbIvZpVClQZVg1o78m0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2444:b0:15d:281d:87 with SMTP id
 l4-20020a170903244400b0015d281d0087mr19178900pls.9.1651194275630; Thu, 28 Apr
 2022 18:04:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:16 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 10/10] KVM: x86/mmu: Shove refcounted page dependency into host_pfn_mapping_level()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Move the check that restricts mapping huge pages into the guest to pfns
that are backed by refcounted 'struct page' memory into the helper that
actually "requires" a 'struct page', host_pfn_mapping_level().  In
addition to deduplicating code, moving the check to the helper eliminates
the subtle requirement that the caller check that the incoming pfn is
backed by a refcounted struct page, and as an added bonus avoids an extra
pfn_to_page() lookup.

Note, the is_error_noslot_pfn() check in kvm_mmu_hugepage_adjust() needs
to stay where it is, as it guards against dereferencing a NULL memslot in
the kvm_slot_dirty_track_enabled() that follows.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 14 +++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c |  3 +--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7da6741d6ea7..20c8f3cb6b4d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2824,11 +2824,19 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  const struct kvm_memory_slot *slot)
 {
-	struct page *page = pfn_to_page(pfn);
 	unsigned long hva;
+	struct page *page;
 	pte_t *pte;
 	int level;
 
+	/*
+	 * Note, @slot must be non-NULL, i.e. the caller is responsible for
+	 * ensuring @pfn isn't garbage and is backed by a memslot.
+	 */
+	page = kvm_pfn_to_refcounted_page(pfn);
+	if (!page)
+		return PG_LEVEL_4K;
+
 	if (!PageCompound(page) && !kvm_is_zone_device_page(page))
 		return PG_LEVEL_4K;
 
@@ -2880,7 +2888,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (unlikely(fault->max_level == PG_LEVEL_4K))
 		return;
 
-	if (is_error_noslot_pfn(fault->pfn) || !kvm_pfn_to_refcounted_page(fault->pfn))
+	if (is_error_noslot_pfn(fault->pfn))
 		return;
 
 	if (kvm_slot_dirty_track_enabled(slot))
@@ -5950,7 +5958,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct && kvm_pfn_to_refcounted_page(pfn) &&
+		if (sp->role.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
 			pte_list_remove(kvm, rmap_head, sptep);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index de2cc963dbec..25efaf7da91f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1737,8 +1737,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		pfn = spte_to_pfn(iter.old_spte);
-		if (!kvm_pfn_to_refcounted_page(pfn) ||
-		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
+		if (iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
 							    pfn, PG_LEVEL_NUM))
 			continue;
 
-- 
2.36.0.464.gb9c8b46e94-goog

