Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1A25A3266
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345433AbiHZXMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345444AbiHZXMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D7EA144
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dd097f993so47975537b3.10
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=5b6tbkW/gcuFTQ/42n9E+pTWoQyrg4G/ccr6zGe/V3I=;
        b=E126LBnYe38LghXA6KOo/f8vh2Gz9Xy0x++mEi9UU1DPDZG1dBvp6UNu5eq1fPpqyM
         8kG8b2qaJ63z70VERvWGeaZdQuecwqCg7gMbnLqNgvjhYaTKoUG9v1YM1DbXeZrlit38
         K98Q0r5bazp+m5TTNnPngHSIuRepZX+HkeditJQeNALQC2rjMaDPDBrcQKsHwLgiks0T
         hFBw7uKmc6IBb24L34jRmOK64qtHvAmfDkbLm42zCV8SMG46jLj7Rysa4OmyxawY5QGX
         3ImQ8d7NX9q7h9Ope0FAE7Zr/YaZnuuAsSr2tMJzdBPsLrhZGVU7gUW8Clt2FVz2SNWY
         bcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=5b6tbkW/gcuFTQ/42n9E+pTWoQyrg4G/ccr6zGe/V3I=;
        b=1fKXCnTqoMUCgNbTOiWXT4PGLc7QAPQuwxWTxisYde+/pipP7bmMQDbKj265naskZS
         5RY5R8KpXa3oKrpbhqbQGpnqoB6SxcotvcunaqVEn92G4UA0aD8w6oQ6E9r11IG5cEfa
         cfhP1Wr6KcEhf5+Bf+vaLaoXng5g3m71QmiLwrLrHEzd0VDHVbabevcLwz6SDARvEuRI
         pxeIQETnMvfjphuFkxDJb4FCPSMT0tfRbZCscPGm42u//69ILsWgtgLFhp3QMCEDuPRP
         Lno+qWNFonR0cKq3U/8/3dljIwed0yyWORGevrcqh3YxrCayUfm+b6rTeFEUBg961/ic
         Sw9Q==
X-Gm-Message-State: ACgBeo08kf7tB5+/qcSMXT9E6DLiE4ZxZFh6sNL59ym4psGquNIjrH7+
        Vsb06WFknHNVv476ANjjYRtz3GuIUILYmA==
X-Google-Smtp-Source: AA6agR5E/w+rSFNHY4wQXj7GqF6U/qnnxfbqRlV+1G2PWK0Yn6P4TRreo6zBy6IOfpAkorowAGPsJJ2JxxDUiA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:c4c:0:b0:696:114c:ad25 with SMTP id
 d12-20020a5b0c4c000000b00696114cad25mr1670427ybr.13.1661555563375; Fri, 26
 Aug 2022 16:12:43 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:23 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-7-dmatlack@google.com>
Subject: [PATCH v2 06/10] KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
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
index fb30451f4b47..86282df37217 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3164,28 +3164,32 @@ static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
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
@@ -4187,7 +4191,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	return RET_PF_CONTINUE;
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			   unsigned int access)
 {
 	int ret;
 
@@ -4201,6 +4206,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (unlikely(is_error_pfn(fault->pfn)))
 		return kvm_handle_error_pfn(fault);
 
+	if (unlikely(!fault->slot))
+		return kvm_handle_noslot_fault(vcpu, fault, access);
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4251,11 +4259,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
2.37.2.672.g94769d06f0-goog

