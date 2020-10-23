Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF912973CC
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751659AbgJWQbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751438AbgJWQas (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2r6z2eq2n8RapzH3Hc0CANhd1X+6+VQ1WVVzaGN7U3M=;
        b=i2pDy0AXIXNYKUTI6fMUKa9+dq9sbzTWBlKjEdXf56YqHO7c5UGe8ypdpBM5WZ/q65r1Uz
        2Hi5zibR4owGMn7hRrV04xbAsDYVFVFKBnh02fKFTZarnjPMmtw0KIFIl7YlbPTxLv+VIj
        28NlC+ENe7cdOslUj2yoffvDb7GqSko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-RCsahkEeOdaZ4_LF-Vm3WA-1; Fri, 23 Oct 2020 12:30:44 -0400
X-MC-Unique: RCsahkEeOdaZ4_LF-Vm3WA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3608C10309BB;
        Fri, 23 Oct 2020 16:30:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6CE09CBC8;
        Fri, 23 Oct 2020 16:30:42 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 22/22] kvm: x86/mmu: NX largepage recovery for TDP MMU
Date:   Fri, 23 Oct 2020 12:30:24 -0400
Message-Id: <20201023163024.2765558-23-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

When KVM maps a largepage backed region at a lower level in order to
make it executable (i.e. NX large page shattering), it reduces the TLB
performance of that region. In order to avoid making this degradation
permanent, KVM must periodically reclaim shattered NX largepages by
zapping them and allowing them to be rebuilt in the page fault handler.

With this patch, the TDP MMU does not respect KVM's rate limiting on
reclaim. It traverses the entire TDP structure every time. This will be
addressed in a future patch.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-21-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          | 13 +++++++++----
 arch/x86/kvm/mmu/mmu_internal.h |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b52fa1f01b0..17587f496ec7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -776,7 +776,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 }
 
-static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (sp->lpage_disallowed)
 		return;
@@ -804,7 +804,7 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	--kvm->stat.nx_lpage_splits;
 	sp->lpage_disallowed = false;
@@ -5988,8 +5988,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		WARN_ON_ONCE(sp->lpage_disallowed);
+		if (sp->tdp_mmu_page)
+			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
+				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+		else {
+			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+			WARN_ON_ONCE(sp->lpage_disallowed);
+		}
 
 		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6db40ea85974..bfc6389edc28 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -143,4 +143,7 @@ bool is_nx_huge_page_enabled(void);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5158d02b8925..e246d71b8ea2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -273,6 +273,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 		list_del(&sp->link);
 
+		if (sp->lpage_disallowed)
+			unaccount_huge_nx_page(kvm, sp);
+
 		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 			old_child_spte = READ_ONCE(*(pt + i));
 			WRITE_ONCE(*(pt + i), 0);
@@ -571,6 +574,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 						     !shadow_accessed_mask);
 
 			trace_kvm_mmu_get_page(sp, true);
+			if (huge_page_disallowed && req_level >= iter.level)
+				account_huge_nx_page(vcpu->kvm, sp);
+
 			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
 		}
 	}
-- 
2.26.2

