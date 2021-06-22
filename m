Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C704B3B0C00
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhFVSAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbhFVSAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:37 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02427C0611C0
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:17 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id r15-20020a0562140c4fb0290262f40bf4bcso18347504qvj.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WVFaMcj6eBUNfXCYM+guxa1ToSj4nAzpGmcEUcXwoLU=;
        b=fR9azdqHDrrsRqLrk1mw1/khPxXD8zS5fO6Mc48QzCE1Wxj+ICx1DYJZGkJr6oKfw7
         O9boiQL7kNK/4+RNr9j9x4FnX8eeMyW+wgzHNPJ8GEbrnH1RBX4gLr5CvbnCTCZH1vNk
         0EvirxEWYIN7Xa0f4s7LGTMRkoORtdmDHpTKAUct7/4B6R9yYtkONcCmt6NsXrIa+s1b
         2Vi87sN2bWmFzdCHch4QdVnFPUsv0TX1BvhprsWhtzEZ1TP9h6H67zajN5fwTcpgVzq7
         128W4sMulSt06iM0BdbYOFyHnExtZ3d7GctYJD34w6WykmpMVmaatBZ0fqMzolxdNBwQ
         UIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WVFaMcj6eBUNfXCYM+guxa1ToSj4nAzpGmcEUcXwoLU=;
        b=EP904doX0GRYz5Lre23EGacK3z3bZbP6eE9G+iVsyxDf6/4gJvJBcS7NkS/+JsGZRE
         /yCN0AMJ2C9fvNBwrgPUwHifS4BKYR4e5npQr7dJSbgch5CFCR2UvnMmZQok2+DUb4vl
         r0bmgRUB5DpwSgBPSMGk7li5OzP2ErzdRLgpTTVRzhE193n4cIQHa9yH3AoRgP5okqeK
         NTzfnKJi5WtDJFLhR768VhLvE5ZKjmY07SvpXV1Ep7XD2BuR3QqjLnEE9Ub8LkE7PUPv
         aZWL1RCahr1oBgDMN7iMbRqoeZ88vBB+R2L04xUXY8w208UQIznX8y1ccMrfSCiBWcOt
         35Aw==
X-Gm-Message-State: AOAM531UvcLMGjhM7tXQrpkV3n4mF9wH1t0AjrLmREEkGHwg7GD724Vo
        AYHzcRDUZF8wrhIzRk5JfIWnBu9LBF0=
X-Google-Smtp-Source: ABdhPJxGL/L9iCuRcW+ybcf0LTSFzUQPLd8NEZi0xJP9P+67r+oO6cLmNTEqbsWhsecmFCudS5bpOsjLyGw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:d694:: with SMTP id n142mr6295564ybg.349.1624384696152;
 Tue, 22 Jun 2021 10:58:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:54 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
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

When creating a new upper-level shadow page, zap unsync shadow pages at
the same target gfn instead of attempting to sync the pages.  This fixes
a bug where an unsync shadow page could be sync'd with an incompatible
context, e.g. wrong smm, is_guest, etc... flags.  In practice, the bug is
relatively benign as sync_page() is all but guaranteed to fail its check
that the guest's desired gfn (for the to-be-sync'd page) matches the
current gfn associated with the shadow page.  I.e. kvm_sync_page() would
end up zapping the page anyways.

Alternatively, __kvm_sync_page() could be modified to explicitly verify
the mmu_role of the unsync shadow page is compatible with the current MMU
context.  But, except for this specific case, __kvm_sync_page() is called
iff the page is compatible, e.g. the transient sync in kvm_mmu_get_page()
requires an exact role match, and the call from kvm_sync_mmu_roots() is
only synchronizing shadow pages from the current MMU (which better be
compatible or KVM has problems).  And as described above, attempting to
sync shadow pages when creating an upper-level shadow page is unlikely
to succeed, e.g. zero successful syncs were observed when running Linux
guests despite over a million attempts.

Fixes: 9f1a122f970d ("KVM: MMU: allow more page become unsync at getting sp time")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 50 ++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04cab330c445..99d26859021d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1843,24 +1843,6 @@ static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return __kvm_sync_page(vcpu, sp, invalid_list);
 }
 
-/* @gfn should be write-protected at the call site */
-static bool kvm_sync_pages(struct kvm_vcpu *vcpu, gfn_t gfn,
-			   struct list_head *invalid_list)
-{
-	struct kvm_mmu_page *s;
-	bool ret = false;
-
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn) {
-		if (!s->unsync)
-			continue;
-
-		WARN_ON(s->role.level != PG_LEVEL_4K);
-		ret |= kvm_sync_page(vcpu, s, invalid_list);
-	}
-
-	return ret;
-}
-
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_MAX_LEVEL];
 	unsigned int idx[PT64_ROOT_MAX_LEVEL];
@@ -1990,8 +1972,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	struct hlist_head *sp_list;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
-	bool need_sync = false;
-	bool flush = false;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
@@ -2014,11 +1994,21 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (!need_sync && sp->unsync)
-			need_sync = true;
-
-		if (sp->role.word != role.word)
+		if (sp->role.word != role.word) {
+			/*
+			 * If the guest is creating an upper-level page, zap
+			 * unsync pages for the same gfn.  While it's possible
+			 * the guest is using recursive page tables, in all
+			 * likelihood the guest has stopped using the unsync
+			 * page and is installing a completely unrelated page.
+			 * Unsync pages must not be left as is, because the new
+			 * upper-level page will be write-protected.
+			 */
+			if (level > PG_LEVEL_4K && sp->unsync)
+				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+							 &invalid_list);
 			continue;
+		}
 
 		if (direct_mmu)
 			goto trace_get_page;
@@ -2052,22 +2042,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (!direct) {
-		/*
-		 * we should do write protection before syncing pages
-		 * otherwise the content of the synced shadow page may
-		 * be inconsistent with guest page table.
-		 */
 		account_shadowed(vcpu->kvm, sp);
 		if (level == PG_LEVEL_4K && rmap_write_protect(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
-
-		if (level > PG_LEVEL_4K && need_sync)
-			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
 	trace_kvm_mmu_get_page(sp, true);
-
-	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
 out:
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+
 	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
 		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
 	return sp;
-- 
2.32.0.288.g62a8d224e6-goog

