Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1373B0C07
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhFVSBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhFVSAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:54 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E72C0613A2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:27 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x4-20020a3763040000b02903ab95237c25so19051307qkb.0
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZVQPmrwIO1jLx03fsUYY+unjOucbiEXlPfNgj7m+k/Q=;
        b=TLCaZriIZLxqUOGqBFW+2bxITVCMWf2aZbVzomfs8xmn4CKpqFQxG6voZh1f8ao7jJ
         gRSpgY88aisFMUt8/yqAw+6GxwXTMyHwRdbYznJHY1IkbS6/CN3o9KcyV0DXeZabwf0W
         ZR/iD/K+Xf1LfgdDb2QEE2H4vUEIun0rHj/ZjZEHSRVOXIukg7aBUIMb4dCTZVqrnwT6
         p+E1Q8CGAo9cisd88M7YLozW1C3VPNpF5BeYcq+MhO1sSqUvFjXyboGyvjNsW6fMf9KU
         rPYr4O5a0jmcIPakG7ou28FStARJGrtT/n1PAmX8V8xOnejx+XMD6eOO2qZNO3MIQRAe
         T0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZVQPmrwIO1jLx03fsUYY+unjOucbiEXlPfNgj7m+k/Q=;
        b=SkMi6ICpUtSIkiysV72GzbSoccfWGOGpXAsuwGNofnRTaB9p/eTQ/0Im4JbdwFjUOe
         aAy8DkdTmE8ANURTBp4fCY0hw69rX+KDHavnby1J5OcW3HtesvUgAh6yjJEK43rgt7TK
         XeRRwW1khAFi5UNhzMJ/9jMpXUdkO+6YPMHWgikTYhQa/K3vAW1ZxRc5PRsSXT6qEw88
         ECukJ+2XuOe7NtTypE4+3BbnSioyxd5Tef2C1gM9fDYJJAzjhR193nMg5mAvjVjl4yG2
         eDCDuReXZpGU7OHdtq99UXVxNie+znDiySLCU/RQCxgW2mQelnRDPcO+KG+dWGNOdXEJ
         +DFw==
X-Gm-Message-State: AOAM533CenVGpm5S8u34jzCJvThihUYtkQIpc57ROP1Ac76n1qorzC5V
        BydOuYva0rxbB8IEQ3Qt5dwr6DexopE=
X-Google-Smtp-Source: ABdhPJxCk4WUMsvLagMH83wIjfOEjv3rLY5xkwQoaxVvsirwDlm46lLgIwGiZKST1D9A22U/zM4VccK8gMM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:f449:: with SMTP id p9mr6413791ybe.259.1624384706126;
 Tue, 22 Jun 2021 10:58:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:58 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 13/54] KVM: x86/mmu: Rename unsync helper and update related comments
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename mmu_need_write_protect() to mmu_try_to_unsync_pages() and update
a variety of related, stale comments.  Add several new comments to call
out subtle details, e.g. that upper-level shadow pages are write-tracked,
and that can_unsync is false iff KVM is in the process of synchronizing
pages.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 34 ++++++++++++++++++++++++---------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +--
 arch/x86/kvm/mmu/spte.c         | 10 ++++++++--
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 77296ce6215f..0171c245ecc7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2458,17 +2458,33 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	kvm_mmu_mark_parents_unsync(sp);
 }
 
-bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
-			    bool can_unsync)
+/*
+ * Attempt to unsync any shadow pages that can be reached by the specified gfn,
+ * KVM is creating a writable mapping for said gfn.  Returns 0 if all pages
+ * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
+ * be write-protected.
+ */
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 {
 	struct kvm_mmu_page *sp;
 
+	/*
+	 * Force write-protection if the page is being tracked.  Note, the page
+	 * track machinery is used to write-protect upper-level shadow pages,
+	 * i.e. this guards the role.level == 4K assertion below!
+	 */
 	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
-		return true;
+		return -EPERM;
 
+	/*
+	 * The page is not write-tracked, mark existing shadow pages unsync
+	 * unless KVM is synchronizing an unsync SP (can_unsync = false).  In
+	 * that case, KVM must complete emulation of the guest TLB flush before
+	 * allowing shadow pages to become unsync (writable by the guest).
+	 */
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
 		if (!can_unsync)
-			return true;
+			return -EPERM;
 
 		if (sp->unsync)
 			continue;
@@ -2499,8 +2515,8 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	 *                      2.2 Guest issues TLB flush.
 	 *                          That causes a VM Exit.
 	 *
-	 *                      2.3 kvm_mmu_sync_pages() reads sp->unsync.
-	 *                          Since it is false, so it just returns.
+	 *                      2.3 Walking of unsync pages sees sp->unsync is
+	 *                          false and skips the page.
 	 *
 	 *                      2.4 Guest accesses GVA X.
 	 *                          Since the mapping in the SP was not updated,
@@ -2516,7 +2532,7 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	 */
 	smp_wmb();
 
-	return false;
+	return 0;
 }
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
@@ -3461,8 +3477,8 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		 * flush strictly after those changes are made. We only need to
 		 * ensure that the other CPU sets these flags before any actual
 		 * changes to the page tables are made. The comments in
-		 * mmu_need_write_protect() describe what could go wrong if this
-		 * requirement isn't satisfied.
+		 * mmu_try_to_unsync_pages() describe what could go wrong if
+		 * this requirement isn't satisfied.
 		 */
 		if (!smp_load_acquire(&sp->unsync) &&
 		    !smp_load_acquire(&sp->unsync_children))
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 18be103df9d5..35567293c1fd 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -122,8 +122,7 @@ static inline bool is_nx_huge_page_enabled(void)
 	return READ_ONCE(nx_huge_pages);
 }
 
-bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
-			    bool can_unsync);
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
 
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8e8e8da740a0..246e61e0771e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -147,13 +147,19 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		/*
 		 * Optimization: for pte sync, if spte was writable the hash
 		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of mmu_get_page / kvm_sync_page.
+		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
 		if (!can_unsync && is_writable_pte(old_spte))
 			goto out;
 
-		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
+		/*
+		 * Unsync shadow pages that are reachable by the new, writable
+		 * SPTE.  Write-protect the SPTE if the page can't be unsync'd,
+		 * e.g. it's write-tracked (upper-level SPs) or has one or more
+		 * shadow pages and unsync'ing pages is not allowed.
+		 */
+		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret |= SET_SPTE_WRITE_PROTECTED_PT;
-- 
2.32.0.288.g62a8d224e6-goog

