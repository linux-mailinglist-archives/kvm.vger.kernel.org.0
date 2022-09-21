Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DD15C055B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiIURgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIURgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1320A285F
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n10-20020a170902e54a00b001782663dcaeso4265463plf.18
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=txhHYdjk2BSCdeMy6FWl5BicUnTO60zW2ErXKNHJFxo=;
        b=fhUhbbm4U1KDnOOK6JMDZsP6I/dWi1kiOpam8aXaUtl8fLpRcGdxCphZBQiBKdkazJ
         YrpgQaDMl11lNKitU9Ja9Kmbbj+Ah6mo3nH5zwEectca7XtphXO/Mca3SvxQU28+BLl1
         bAMNCQFwYa2+mpa8RnkKAvOsUXmzgwTn+cvgGF4oEhHPKkWLnyJ5lEaYgprVgyiIxFBU
         Zkpn28qvN83un6OYd15cQO4ikfYkdgFHxAdXSNQHJVOnmLzTOC/FF2otvXc4PgGbQeAH
         nucFyor09ZXV+uwPR6E6nrJ1MlFHAFeqa/KBoga8vQvOdYhme9VmMgPzC49dEOtsj6Il
         nIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=txhHYdjk2BSCdeMy6FWl5BicUnTO60zW2ErXKNHJFxo=;
        b=XKoPnhLne947r2OnxM5Z64Q8MqrgaczfGTdBnTpEnP47uHt8QDnjKPA27Cw0s54xwe
         07Ot0IYLZB1MeNCsqU6aWThD5bNVlLADm9ysaUwxlxn23kNfZ/A8E3WkKgWsnKUTV4uy
         xgKEFdyNfa4nfn7vQUbZEP8xT1HF9tWXfLzvq6mT2IfsrF76lANM0DS+VAeKnwpybBSv
         lEopDED0yrVWp+xQQT0hQFF8+u93c7KGkthpiY5OShr25kNJtHdI8rqaEGSCEVOavLJo
         70H+kd0fINN/K3Qjr2Zq7sM/qxTULeeSJIivr0tgtUcmnzGr6+dH3AgpIjDlQvkXu7zI
         a2dw==
X-Gm-Message-State: ACrzQf14CB6x2eTVi1oRrIEJviXQa9kD0ooAkIRWVUBcn5JO7oIHyL9q
        t9j8aVH2P8bqgOMTkBAY9LJoeBzS1AaUlQ==
X-Google-Smtp-Source: AMsMyM5q5tC6BDAm6lOOyG+ZdtaapT6tr17ru8tIFimVI2kbdzaJe4QlOshpRpCKjUJ9fIA8TLAsDTrr2BlqQA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:902:ec87:b0:176:d549:2f28 with SMTP
 id x7-20020a170902ec8700b00176d5492f28mr5831759plg.12.1663781761949; Wed, 21
 Sep 2022 10:36:01 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:42 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-7-dmatlack@google.com>
Subject: [PATCH v3 06/10] KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle faults on GFNs that do not have a backing memslot in
kvm_faultin_pfn() and drop handle_abnormal_pfn(). This eliminates
duplicate code in the various page fault handlers.

Opportunistically tweak the comment about handling gfn > host.MAXPHYADDR
to reflect that the effect of returning RET_PF_EMULATE at that point is
to avoid creating an MMIO SPTE for such GFNs.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 56 ++++++++++++++++++----------------
 arch/x86/kvm/mmu/paging_tmpl.h |  6 +---
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b6f84e470677..e3b248385154 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3161,28 +3161,32 @@ static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
 	return -EFAULT;
 }
 
-static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			       unsigned int access)
+static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
+				   struct kvm_page_fault *fault,
+				   unsigned int access)
 {
-	if (unlikely(!fault->slot)) {
-		gva_t gva = fault->is_tdp ? 0 : fault->addr;
+	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
-		vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
-				     access & shadow_mmio_access_mask);
-		/*
-		 * If MMIO caching is disabled, emulate immediately without
-		 * touching the shadow page tables as attempting to install an
-		 * MMIO SPTE will just be an expensive nop.  Do not cache MMIO
-		 * whose gfn is greater than host.MAXPHYADDR, any guest that
-		 * generates such gfns is running nested and is being tricked
-		 * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
-		 * and only if L1's MAXPHYADDR is inaccurate with respect to
-		 * the hardware's).
-		 */
-		if (unlikely(!enable_mmio_caching) ||
-		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
-			return RET_PF_EMULATE;
-	}
+	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
+			     access & shadow_mmio_access_mask);
+
+	/*
+	 * If MMIO caching is disabled, emulate immediately without
+	 * touching the shadow page tables as attempting to install an
+	 * MMIO SPTE will just be an expensive nop.
+	 */
+	if (unlikely(!enable_mmio_caching))
+		return RET_PF_EMULATE;
+
+	/*
+	 * Do not create an MMIO SPTE for a gfn greater than host.MAXPHYADDR,
+	 * any guest that generates such gfns is running nested and is being
+	 * tricked by L0 userspace (you can observe gfn > L1.MAXPHYADDR if and
+	 * only if L1's MAXPHYADDR is inaccurate with respect to the
+	 * hardware's).
+	 */
+	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
+		return RET_PF_EMULATE;
 
 	return RET_PF_CONTINUE;
 }
@@ -4183,7 +4187,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	return RET_PF_CONTINUE;
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			   unsigned int access)
 {
 	int ret;
 
@@ -4197,6 +4202,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(fault);
 
+	if (unlikely(!fault->slot))
+		return kvm_handle_noslot_fault(vcpu, fault, access);
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4247,11 +4255,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	r = kvm_faultin_pfn(vcpu, fault);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
-	r = handle_abnormal_pfn(vcpu, fault, ACC_ALL);
+	r = kvm_faultin_pfn(vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 98f4abce4eaf..e014e09ac2c1 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -837,11 +837,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	else
 		fault->max_level = walker.level;
 
-	r = kvm_faultin_pfn(vcpu, fault);
-	if (r != RET_PF_CONTINUE)
-		return r;
-
-	r = handle_abnormal_pfn(vcpu, fault, walker.pte_access);
+	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
-- 
2.37.3.998.g577e59143f-goog

