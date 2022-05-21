Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92C852FCC7
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355126AbiEUNRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355030AbiEUNQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:38 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD653BA6A;
        Sat, 21 May 2022 06:16:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h9so1728794pgl.4;
        Sat, 21 May 2022 06:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWj2Gm0RTm2whtHiHymRcHUNFcQ1CwVqw1Y3UlZwvQE=;
        b=jWL5TOsGwwsNXdZIq+IyTkc0mhiYbjVe8P6bT3GmWMrY4XkIT/oDv/eZzdde2Fz+Uw
         is/ZQaztuIwBiT1342s+UyyA2H99UucSLYWMtcaWk8X1rLVsJWMvSukzlThsBEXPnE3V
         GGCumzhRMpKXKoKrVJBKjqW+BtsPDkpf08B29jjgqRrQYFVX4gFWjCqAYUC6R19OvotY
         ZFLTzczQwLUnREpKflc4Nva/G0pquqrqe2KKIvynQZ8ZhYTawC/2oEtNgt0i/WtgrMsU
         bEqlaKl89IoxV7SBpJ8UAqsln54ZaXD5C2zxFZ3vbXz9aeRre44k5WITXkPnp+DBGSyI
         cDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWj2Gm0RTm2whtHiHymRcHUNFcQ1CwVqw1Y3UlZwvQE=;
        b=259m8fGuVptmIyLQg4X8hzmnRGHd+zyhsHKNfpCCtxdGKmyw06IclX35aI0hWHLc2F
         gdT3RLs4cZK+rjhit7nlfU8prrfRTBUg+07f0qe4eDp2qabiB2xdbhLuMYOCl+u6cxLH
         fS6QwMu8nEVfw80WX8m462izcZQtKFV6J0T0hJCl/Rz64KXqR59hLtNYzhOr2YPuRfJm
         a8yJCSUozFWPhA0sUpg62l3nHA5VjL5xgKok5IjarLjDVAsJm2qiETzCK+4oa42v90JU
         j0JwElmfknFCF+O1ij4xpdO87hrwcPSptiMeHj9rZTOMaIQtu1M0gHUhZHELay39pIPO
         D1jA==
X-Gm-Message-State: AOAM532Zf5btQTx2UED9cHe6/+vq8cEbqi1d0C0qe7YVY73PDKuGAOez
        psHy1iM0qXYx4vDU6aLEJnMUMsC8wxI=
X-Google-Smtp-Source: ABdhPJzVSPEi7wqKIPnt34q012TK0y3635WQ7idVxf96AHxKrfw81J+hRwewb2CiOuyvPs3xHwKKDA==
X-Received: by 2002:a65:6552:0:b0:3db:772a:2465 with SMTP id a18-20020a656552000000b003db772a2465mr12728770pgw.225.1653138990931;
        Sat, 21 May 2022 06:16:30 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id z11-20020a170902cccb00b0015e8d4eb28fsm1567562ple.217.2022.05.21.06.16.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:30 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 07/12] KVM: X86/MMU: Remove the check of the return value of to_shadow_page()
Date:   Sat, 21 May 2022 21:16:55 +0800
Message-Id: <20220521131700.3661-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
NULL and the obsoleting for local shadow page is already handled by
a different way.

When the obsoleting process is done, all the obsoleted non-local shadow
pages are already unlinked from the local shadow pages by the help of
the parent rmap from the children and the local shadow pages become
theoretically valid again.  The local shadow page can be freed if
is_obsolete_sp() return true, or be reused if is_obsolete_sp() becomes
false.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c     | 44 +++-----------------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +-----
 2 files changed, 4 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 684a0221aa4c..90b715eefe6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3397,8 +3397,6 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
-	if (WARN_ON(!sp))
-		return;
 
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
@@ -3501,8 +3499,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		if (!VALID_PAGE(root_hpa))
 			continue;
 
-		if (!to_shadow_page(root_hpa) ||
-			to_shadow_page(root_hpa)->role.guest_mode)
+		if (to_shadow_page(root_hpa)->role.guest_mode)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
@@ -3752,13 +3749,6 @@ static bool is_unsync_root(hpa_t root)
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
 
@@ -4068,21 +4058,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
@@ -5190,24 +5166,10 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 
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
index c163f7cc23ca..5779a2a7161e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -78,13 +78,8 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
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
 static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
-- 
2.19.1.6.gb485710b

