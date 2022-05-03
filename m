Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF35187E8
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiECPLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiECPLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:11:04 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAE53969F;
        Tue,  3 May 2022 08:07:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t13so14233938pgn.8;
        Tue, 03 May 2022 08:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EZO0FfzGaND0LPzWqKkRZ01ZZcZI/mFzJ/gCyTl0eyA=;
        b=VO9ukxRL5ymaVr8gWWqs8jhW3T2lT41YAoRfa3txuvPz4Iyl26FO5m0ix9+2tHEJQV
         9Fh/Ebtyj9sqqZk/lTDCLVNTRq1OUsty5lEyFBOrNY4E/aLflt1JdAS6QVYq/hXkvHqN
         3ryV9ybn+xkP9km/w8qrk+VYzmNnRPxcH1+BeNLiYc2Jqp2dpsPh1dQ2Ux6p7fPgwJgT
         SauEQX4w9cTuuceJb3MjQA3jYYbXv3usbLem3YHgyXBFanTT70+T0X1pOWpE1PUBZA8Q
         yMAOPqNqEbBMhQDuxahEKsLQJmidKcLKJ+JEanzFTRHQqypwrMmGT08LyXaj8oqkNOUC
         YzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EZO0FfzGaND0LPzWqKkRZ01ZZcZI/mFzJ/gCyTl0eyA=;
        b=zaSMLRfBoVmkBeuh0czkM19tLQmX7UfkbwV5SGXwq1CWsYOKe3mjpq8h5Hxxw1h7Gl
         NG1Jn0UWh7CX65hg+64PO8f759cP2xmk2PmeltrCnnZC9nRckva65MP2hUtbTLAd+QN/
         O1LSHjf2+Av+OM/KsNykjjjWQvIM2A6SqGH2/+VKM410BgKCXmJuc58eRfqXDSg2+htb
         gW7wU38D3/45ThdZf10/tiJoJXOQ4WDTfSmqxPZzdfVM5NPfjCmfzf18UpFPTYMopKPD
         Qo6dGnkKC9j1q1A5q10tI/mzPFlF/JOS7hfbIeagWBjPM+bGumupxf/e87gci27muis/
         IYUQ==
X-Gm-Message-State: AOAM531W/Rk7NyDu5/mzZ8zPc7ypkq5rv57qn+Z+Md/dWqzi6sepbUr8
        +zdbdQ5yTr2w3MoBV+7VNuVcEwyO9Qw=
X-Google-Smtp-Source: ABdhPJyVG47HE6rJDbmU53GOQw3j2KiQwxvve94OB5hT/Z04wpQwhvSMGEa6DZGc/MsJkbLf6i7fkA==
X-Received: by 2002:a63:4:0:b0:3ab:17c6:e0ce with SMTP id 4-20020a630004000000b003ab17c6e0cemr14143744pga.511.1651590450750;
        Tue, 03 May 2022 08:07:30 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id y1-20020a636401000000b003c1424a25a9sm13436698pgb.2.2022.05.03.08.07.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:30 -0700 (PDT)
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
Subject: [PATCH V2 5/7] KVM: X86/MMU: Remove the check of the return value of to_shadow_page()
Date:   Tue,  3 May 2022 23:07:33 +0800
Message-Id: <20220503150735.32723-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
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
NULL and the obsoleting for special shadow page is already handled by
a different way.

When the obsoleting process is done, all the obsoleted shadow pages are
already unlinked from the special pages by the help of the parent rmap
of the children and the special pages become theoretically valid again.
The special shadow page can be freed if is_obsolete_sp() return true,
or be reused if is_obsolete_sp() return false.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c     | 44 +++-----------------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +-----
 2 files changed, 4 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f626d7e8ebb..bcb3e2730277 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3318,8 +3318,6 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
-	if (WARN_ON(!sp))
-		return;
 
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
@@ -3422,8 +3420,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		if (!VALID_PAGE(root_hpa))
 			continue;
 
-		if (!to_shadow_page(root_hpa) ||
-			to_shadow_page(root_hpa)->role.guest_mode)
+		if (to_shadow_page(root_hpa)->role.guest_mode)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
@@ -3673,13 +3670,6 @@ static bool is_unsync_root(hpa_t root)
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
 
@@ -3975,21 +3965,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
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
@@ -5094,24 +5070,10 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 
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

