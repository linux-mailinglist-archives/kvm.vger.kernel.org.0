Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B23F6887
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbhHXSAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240939AbhHXR76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 13:59:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCA3C0E569D;
        Tue, 24 Aug 2021 10:40:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2851674pjq.4;
        Tue, 24 Aug 2021 10:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n2Yhwdxg87AjiJQPOXAK9fAfw6iA/p1KpP0vkmBf3iI=;
        b=PnIYN7XDcQqoI4NGz1IG50cn95beIP+i6LsApG21Xq3XThDbC/NbBPNFh/ZcbOMtc+
         LFUF4fYDUWBA4s1u8lmBkxBi99HPKyLpPZw+hOWNVSRjvbr5fdUcnbuofceYeUoQBrn8
         NxB15h04q3oL8AkvCxDj89VlPk88AEN/V3YoT+k5ZqMwkhBDrMhJxRPjFd2v6Sn/+79u
         3ATkPE1nOh4z0S9kcRvQudlygjevq/44cUHcVE8jcrFmg8O1UG6tv1rUCnIBCfnGnBLX
         M09oIC4h5rVWpvuW6OAej4xnxMhX0/7s3Bgif0w1m99J3cHXrRL5xeoyZZ6Z8yxO7p+D
         nhqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n2Yhwdxg87AjiJQPOXAK9fAfw6iA/p1KpP0vkmBf3iI=;
        b=HlMYaBFsPWvvlpQ/HBKGeGKPhCPo7clMoum1SbfVoB1plod+yrKxQ0oQq2hQSop03d
         qIHXtbdOYQjUTcdPogmKAG316xw5vCaIt6uNKNuoJs1StHIkTV2Mn81g82TXsnmhWVLw
         3OKrPVlJFlp+bNwxxsgEU3x+PNMRJ1KmCva7Tb+MWtQcZHlQg4ns1c9I7m9Tr0lAnDA0
         lyj2nq2lyeqZdT3hMK1+yMv53a9frZcBohUONp0q7iDTz/xPHQMDJT9kC+Zo9RaoHmbU
         OxhuVYwee1Q1xl6YZSTkHor86bxDhNAQE7N2rUnxU8+5OYxsaLj70AaXnu7wIuLJ9JVb
         I2Qw==
X-Gm-Message-State: AOAM530gmjoXevbrt7aUZAuZ/L11UbZZWMo2qF+D1hfD1hGYCPbo8wjq
        fDV7TSv7Gv6RSHsKNvteVy0XbxcW7iE=
X-Google-Smtp-Source: ABdhPJxBJ/7paECHawfYfO6vY4v9UKkH24PLLWF0eAhvcBDpeXPY89gdPoUNlTmF6NTj4JRqoCs7RQ==
X-Received: by 2002:a17:90a:7384:: with SMTP id j4mr5637555pjg.138.1629826836728;
        Tue, 24 Aug 2021 10:40:36 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id w186sm20624084pfw.78.2021.08.24.10.40.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:40:36 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before link it
Date:   Tue, 24 Aug 2021 15:55:18 +0800
Message-Id: <20210824075524.3354-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

If gpte is changed from non-present to present, the guest doesn't need
to flush tlb per SDM.  So the host must synchronze sp before
link it.  Otherwise the guest might use a wrong mapping.

For example: the guest first changes a level-1 pagetable, and then
links its parent to a new place where the original gpte is non-present.
Finally the guest can access the remapped area without flushing
the tlb.  The guest's behavior should be allowed per SDM, but the host
kvm mmu makes it wrong.

Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c         | 21 ++++++++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h | 28 +++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 313918df1a10..987953a901d2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2032,8 +2032,9 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 	} while (!sp->unsync_children);
 }
 
-static void mmu_sync_children(struct kvm_vcpu *vcpu,
-			      struct kvm_mmu_page *parent)
+static bool mmu_sync_children(struct kvm_vcpu *vcpu,
+			      struct kvm_mmu_page *parent,
+			      bool root)
 {
 	int i;
 	struct kvm_mmu_page *sp;
@@ -2061,11 +2062,20 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
 			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
 			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
+			/*
+			 * If @parent is not root, the caller doesn't have
+			 * any reference to it.  And we couldn't access to
+			 * @parent and continue synchronizing after the
+			 * mmu_lock was once released.
+			 */
+			if (!root)
+				return false;
 			flush = false;
 		}
 	}
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+	return true;
 }
 
 static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
@@ -2151,9 +2161,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}
 
-		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-
 		__clear_sp_write_flooding_count(sp);
 
 trace_get_page:
@@ -3650,7 +3657,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		write_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 
-		mmu_sync_children(vcpu, sp);
+		mmu_sync_children(vcpu, sp, true);
 
 		kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 		write_unlock(&vcpu->kvm->mmu_lock);
@@ -3666,7 +3673,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		if (IS_VALID_PAE_ROOT(root)) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
-			mmu_sync_children(vcpu, sp);
+			mmu_sync_children(vcpu, sp, true);
 		}
 	}
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..48c7fe1b2d50 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -664,7 +664,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  * emulate this operation, return 1 to indicate this case.
  */
 static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			 struct guest_walker *gw)
+			 struct guest_walker *gw, unsigned long mmu_seq)
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
@@ -678,6 +678,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	top_level = vcpu->arch.mmu->root_level;
 	if (top_level == PT32E_ROOT_LEVEL)
 		top_level = PT32_ROOT_LEVEL;
+
+again:
 	/*
 	 * Verify that the top-level gpte is still there.  Since the page
 	 * is a root page, it is either write protected (and cannot be
@@ -713,8 +715,28 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
 			goto out_gpte_changed;
 
-		if (sp)
+		if (sp) {
+			/*
+			 * We must synchronize the pagetable before link it
+			 * because the guest doens't need to flush tlb when
+			 * gpte is changed from non-present to present.
+			 * Otherwise, the guest may use the wrong mapping.
+			 *
+			 * For PG_LEVEL_4K, kvm_mmu_get_page() has already
+			 * synchronized it transiently via kvm_sync_page().
+			 *
+			 * For higher level pagetable, we synchronize it
+			 * via slower mmu_sync_children().  If it once
+			 * released the mmu_lock, we need to restart from
+			 * the root since we don't have reference to @sp.
+			 */
+			if (sp->unsync_children && !mmu_sync_children(vcpu, sp, false)) {
+				if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
+					goto out_gpte_changed;
+				goto again;
+			}
 			link_shadow_page(vcpu, it.sptep, sp);
+		}
 	}
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -905,7 +927,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, fault, &walker);
+	r = FNAME(fetch)(vcpu, fault, &walker, mmu_seq);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.19.1.6.gb485710b

