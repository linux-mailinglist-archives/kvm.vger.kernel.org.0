Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87FE508944
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379038AbiDTN2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379032AbiDTN2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:36 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E174F11A36;
        Wed, 20 Apr 2022 06:25:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bg9so1604742pgb.9;
        Wed, 20 Apr 2022 06:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LkvNab/6tjOJLVxEQOpqPQJoB0oTUl274FVeJL6vXA=;
        b=DorGCDAlIME225NVrrVUdFe8hl/FJoxit0vf/SUZTlVJQ096P6UpSwyZwsw/dTyUEa
         Uo038b/+rHeHFZlhzABlPJr0+jFGm+lW8E5YRG4JwKl9B7bDk3sirniuZY0gjnJqbRh4
         emAKGdruA57bwR+VWQRwcZ7GpI1x6eU93GoAdZRK6YFApFIxhQ1YLobYbz0iafOdxJcp
         hKU0kbGSE4dZL4EEt8FaL1/Orgk1xMe3JUV9IdvghTAY7B98GNtr0b3EFaBAQ1ot4F5F
         8S++ZnqFOFyulmaGa9t8sm6xp6NUzz1WNo0wwMF/VJu6lV0aqRwrTcWeSrvcCgGpOdBR
         NUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LkvNab/6tjOJLVxEQOpqPQJoB0oTUl274FVeJL6vXA=;
        b=cFABkfaVNs3zXY8NLa3d4/JBFQFV+RuncnDF8OSdkL6+ivLuXN/vVtRpTKVOo0V8mM
         LPQRWV2G4G3QktXtRYWTr/xF1PreIJN2Ovek6FshdF9q3K8XFa4poMtey+w6T7dgwDhN
         cNS1TKS7Jy93ddXnh98eCHt/NHOdLmCyoUzWN5BTc7vuPHqig3kmI1iWZUAWI2tHhFK2
         kTiTow5U2Qmrws0H5YuaN0vkDH3C/2tKCSV517hx4fpCaZbq0twruixURC7l9nQ0yH6+
         Q+VTOXQ443LWcvA08DhV4Fxq8C/8lCroWct5OlrOi9Fzuz+jP0EWr1l4ZzCs7D9aAcZj
         l55Q==
X-Gm-Message-State: AOAM532lMqRdb2W9793fSrJl/aOh7xVAs/Mqdnc6a8+NtCqyHXQ4S8mX
        C46sNBfh0iguOKorL2NH/MjhOSUNh9A=
X-Google-Smtp-Source: ABdhPJxH753vNUNaiRfbkVu9zw8nveSjuhbUIU8CFyc/KgFf6Qzj99r6dwCkttJRsoKDV0SGKwswiQ==
X-Received: by 2002:a62:5343:0:b0:4f7:baad:5c22 with SMTP id h64-20020a625343000000b004f7baad5c22mr23214956pfb.30.1650461149233;
        Wed, 20 Apr 2022 06:25:49 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id d8-20020a636808000000b00398e9c7049bsm19899161pgc.31.2022.04.20.06.25.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:49 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 5/7] KVM: X86/MMU: Remove the check of the return value of to_shadow_page()
Date:   Wed, 20 Apr 2022 21:26:03 +0800
Message-Id: <20220420132605.3813-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420132605.3813-1-jiangshanlai@gmail.com>
References: <20220420132605.3813-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Remove the check of the return value of to_shadow_page() in
mmu_free_root_page(), kvm_mmu_free_guest_mode_roots(), is_unsync_root()
and is_tdp_mmu() because it can not return NULL.

Remove the check of the return value of to_shadow_page() in
is_page_fault_stale() and is_obsolete_root() because it can not return
NULL and the obsoleting for special shadow page is already handled by
a different way.

When the obsoleting process is done, all the obsoleted shadow pages are
already unlinked from the special pages by the help of the rmap of the
children and the special pages become theoretically valid again.  The
special shadow page can be freed if is_obsolete_sp() return true, or be
reused if is_obsolete_sp() return false.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c     | 44 +++-----------------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +-----
 2 files changed, 4 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b34a6912081..72a1af35e331 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3278,8 +3278,6 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
-	if (WARN_ON(!sp))
-		return;
 
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
@@ -3382,8 +3380,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		if (!VALID_PAGE(root_hpa))
 			continue;
 
-		if (!to_shadow_page(root_hpa) ||
-			to_shadow_page(root_hpa)->role.guest_mode)
+		if (to_shadow_page(root_hpa)->role.guest_mode)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
@@ -3632,13 +3629,6 @@ static bool is_unsync_root(hpa_t root)
 	smp_rmb();
 	sp = to_shadow_page(root);
 
-	/*
-	 * PAE roots (somewhat arbitrarily) aren't backed by shadow pages, the
-	 * PDPTEs for a given PAE root need to be synchronized individually.
-	 */
-	if (WARN_ON_ONCE(!sp))
-		return false;
-
 	if (sp->unsync || sp->unsync_children)
 		return true;
 
@@ -3934,21 +3924,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault, int mmu_seq)
 {
-	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
-
-	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
-	if (sp && is_obsolete_sp(vcpu->kvm, sp))
-		return true;
-
-	/*
-	 * Roots without an associated shadow page are considered invalid if
-	 * there is a pending request to free obsolete roots.  The request is
-	 * only a hint that the current root _may_ be obsolete and needs to be
-	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
-	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
-	 * to reload even if no vCPU is actively using the root.
-	 */
-	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
+	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root.hpa)))
 		return true;
 
 	return fault->slot &&
@@ -5099,24 +5075,10 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 
 static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
 {
-	struct kvm_mmu_page *sp;
-
 	if (!VALID_PAGE(root_hpa))
 		return false;
 
-	/*
-	 * When freeing obsolete roots, treat roots as obsolete if they don't
-	 * have an associated shadow page.  This does mean KVM will get false
-	 * positives and free roots that don't strictly need to be freed, but
-	 * such false positives are relatively rare:
-	 *
-	 *  (a) only PAE paging and nested NPT has roots without shadow pages
-	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
-	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
-	 *      is unlikely to zap an in-use PGD.
-	 */
-	sp = to_shadow_page(root_hpa);
-	return !sp || is_obsolete_sp(kvm, sp);
+	return is_obsolete_sp(kvm, to_shadow_page(root_hpa));
 }
 
 static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5e5ef2576c81..4f70cb1b46df 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -84,13 +84,8 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 	if (WARN_ON(!VALID_PAGE(hpa)))
 		return false;
 
-	/*
-	 * A NULL shadow page is legal when shadowing a non-paging guest with
-	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
-	 * pae_root page, not a shadow page.
-	 */
 	sp = to_shadow_page(hpa);
-	return sp && is_tdp_mmu_page(sp) && sp->root_count;
+	return is_tdp_mmu_page(sp) && sp->root_count;
 }
 #else
 static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
-- 
2.19.1.6.gb485710b

