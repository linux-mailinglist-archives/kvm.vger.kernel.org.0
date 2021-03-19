Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD71134291E
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 00:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCSXUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 19:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhCSXUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 19:20:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A64C061760
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:20:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o9so52951050yba.18
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=E7z8xVF+fWiGn0TFnbWDWHgOTYKvAGR0RJUvGhAunZo=;
        b=K8aXtzFqa6wR3SqLb64Mti+wSQXoLt35gLpWMpMkJ5a8du9jNNgjlbmg0iOGeQkrQV
         2u73vN72yUKvmb4uZLrnJ8F1S8t9M4UaABekwy5jTGENOqInkRzMZE0kVvoBfq/YsNwV
         G+PEQsVZ51BEQ8NLN93H1ZSV6pTWBV7r2V1X44SI+FM8uLaCYUEWvm9zFg0vppxbEx68
         H2e1ZKgC3rOeFDGhC5Nx/ub6ej1OtEMZIYB7qByYpiz7zwHmMZCLKu7qB9huagdbXmHV
         A1nRro+T7Nul42DRkF3jOqKHskyzgKZQMu5bkh/loXEoc2Vg5eN+djeqAsdIRYPe0yPD
         ZLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=E7z8xVF+fWiGn0TFnbWDWHgOTYKvAGR0RJUvGhAunZo=;
        b=ce8xyySHT0A7pwOYycjuaM8xriipVgbc5qy5/StCbzdobAEkw6E4z3M/FU56mvSuJu
         7Yz3N/LlgAAkCMGMBMA/ap+185BGsOHFmVics6VQAf0QW79YLPlevTKrle4V+XhD47M1
         Aq2YJXjacswCWvdK/24ZIKE0kDSDXHzFUtkJA6/L1HLh/lco5wCZNcBRIE0EJhri80iK
         J4MBcsUIBzoQJIHFE20Ior/On2vZstd9YUrDnOTP23N8q1PXeDHFsYFyQhQkZPvfKdjv
         P6Nu+nMzTYi+2W8JgGDIf/+6CLV+ldOt4Bt1EeyspjO5gAPydYiP0hEZLlvOKXK9YXx4
         NARw==
X-Gm-Message-State: AOAM533DkphEeb+LRmC/6TXrZ+/2TNb5vWVxMjR+TIC2qjl8Gc6FBVMl
        22BUUUdg1/jEDYIkfPlyGNmMuAHYVyo=
X-Google-Smtp-Source: ABdhPJycaD8prj8+STy4qYHzk1rppIakcMFGXxWktSXQJ9w4xoY19OQEhhCcMleKskydYPBizOOu7Q0UFxE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:115a:eb6e:42f6:f9d5])
 (user=seanjc job=sendgmr) by 2002:a25:67d6:: with SMTP id b205mr8924692ybc.394.1616196015764;
 Fri, 19 Mar 2021 16:20:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 19 Mar 2021 16:20:06 -0700
In-Reply-To: <20210319232006.3468382-1-seanjc@google.com>
Message-Id: <20210319232006.3468382-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210319232006.3468382-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 2/2] KVM: x86/mmu: Ensure TLBs are flushed when yielding
 during NX zapping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix two intertwined bugs in the NX huge page zapping that were introduced
by the incorporation of the TDP MMU.  Because there is a unified list of
NX huge pages, zapping can encounter both TDP MMU and legacy MMU pages,
and the two MMUs have different tracking for TLB flushing.  If one flavor
needs a flush, but the code for the other flavor yields, KVM will fail to
flush before yielding.

First, honor the "flush needed" return from kvm_tdp_mmu_zap_gfn_range(),
which does the flush itself if and only if it yields, and otherwise
expects the caller to do the flush.  This requires feeding the result
into kvm_mmu_remote_flush_or_zap(), and so also fixes the case where the
TDP MMU needs a flush, the legacy MMU does not, and the main loop yields.

Second, tell the TDP MMU a flush is pending if the list of zapped pages
from legacy MMUs is not empty, i.e. the legacy MMU needs a flush.  This
fixes the case where the TDP MMU yields, but it iteslf does not require a
flush.

Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 15 ++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ed633594a2..413d6259340e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5517,7 +5517,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end,
+						  false);
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 	}
@@ -5939,6 +5940,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	struct kvm_mmu_page *sp;
 	unsigned int ratio;
 	LIST_HEAD(invalid_list);
+	bool flush = false;
+	gfn_t gfn_end;
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
@@ -5960,19 +5963,21 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (is_tdp_mmu_page(sp)) {
-			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
-				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+			gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end,
+							  flush || !list_empty(&invalid_list));
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 			cond_resched_rwlock_write(&kvm->mmu_lock);
+			flush = false;
 		}
 	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cf08c3c537f..367f12bf1026 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -709,10 +709,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+			       bool flush)
 {
 	struct kvm_mmu_page *root;
-	bool flush = false;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root)
 		flush = zap_gfn_range(kvm, root, start, end, true, flush);
@@ -725,7 +725,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush;
 
-	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
+	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn, false);
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3b761c111bff..e39bee52d49e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -8,7 +8,8 @@
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+			       bool flush);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-- 
2.31.0.rc2.261.g7f71774620-goog

