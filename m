Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764665FCA6B
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJLSR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiJLSRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:37 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B9145F6E
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:20 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d18-20020a170903231200b0018031042fb6so9659673plh.19
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vUaKgOSrNqA1/LJ+9txEymrprt2AYNUfSfOocHXnnPA=;
        b=TV0tYpUJlzj2DrhD9CPl8P8ic32L5Cbn5gVvBySQmsBGKCWVfG/vcVj5z05yHAhWrp
         ApMxT74hLkEBLq0mgx7MSBPwckA2eLstZXh4/ld9M+3YxQmZr4iqyt02J8G1WQGsTkgN
         Qp0Ed+FCdo0f1eMzfRJp+RWra39O62tVUChPlg+7NaJorCjiNPVPXJ1lJpCmXUCcqPcm
         R3y4xSbjX/YUgQ4UIr1A6LDN/47mgjF7KcNjK90T0hzJBBv0NMsN+lS28ijCFjYgELv3
         jL+I6IIQO7w3Qhwux1iTqvyz7754thhuT4lPavt2CtcEXFsggzpipPE6vNOMnIUgEP4e
         6haQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vUaKgOSrNqA1/LJ+9txEymrprt2AYNUfSfOocHXnnPA=;
        b=yJXEAR+opKLgIy+lzBbQdGuXyRK6Isn6Biz239SIUVg7kxPucvlx/4qFK7/L1vEMaE
         hiORXVMGGeG9cc0WcZPI2+S5/hsI7z9H7+3ZxbZfbE6JSCAmJUf1sa3lOoHM8sp3NOPl
         YsS+23RzwPWR9z6XYv1pUXA/BFP1vWfWeFhZ0RT0/tUha5Ik2VPEroDiMaJ0/LRoBcr2
         zyFM8S8Dm6b6JABKDlWp/FAR+sepiZg7pnuLTNciQjt3IQfO5U/ppdIJ3b4j/bPynpyb
         dmX7Ziik92IXlEGYFq5jXlJnXKyYyr1IgGkcmaJ4+ogaNF1sUbEIMQSCO9Qf+7K8FPKd
         xA4Q==
X-Gm-Message-State: ACrzQf0tCJV+Z3C7ePTwHSQ34gCPtNUSOloQNriFe+0J7GRP8hk5FxVq
        C4mIshWe8ytsxl0g9/ByfM7pseidTYQ=
X-Google-Smtp-Source: AMsMyM6NLKMVWBVhxXqpNktOPLqijNknlgx85gWq5Yox6xkv3aBfx4K5CAJNFODuB42nFrQQgU5CYvEAXaI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b0c:b0:20d:7ffa:4b1b with SMTP id
 lx12-20020a17090b4b0c00b0020d7ffa4b1bmr6560072pjb.16.1665598637830; Wed, 12
 Oct 2022 11:17:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:57 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-7-seanjc@google.com>
Subject: [PATCH v4 06/11] KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
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

From: David Matlack <dmatlack@google.com>

Handle faults on GFNs that do not have a backing memslot in
kvm_faultin_pfn() and drop handle_abnormal_pfn(). This eliminates
duplicate code in the various page fault handlers.

Opportunistically tweak the comment about handling gfn > host.MAXPHYADDR
to reflect that the effect of returning RET_PF_EMULATE at that point is
to avoid creating an MMIO SPTE for such GFNs.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 56 ++++++++++++++++++----------------
 arch/x86/kvm/mmu/paging_tmpl.h |  6 +---
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 07c3f83b3204..5710be4d328b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3175,28 +3175,32 @@ static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
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
@@ -4197,7 +4201,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	return RET_PF_CONTINUE;
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			   unsigned int access)
 {
 	int ret;
 
@@ -4211,6 +4216,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(fault);
 
+	if (unlikely(!fault->slot))
+		return kvm_handle_noslot_fault(vcpu, fault, access);
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4261,11 +4269,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
index 30b9d9b6734f..60bd642bbb90 100644
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
2.38.0.rc1.362.ged0d419d3c-goog

