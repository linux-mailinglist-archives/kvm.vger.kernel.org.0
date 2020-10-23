Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B44A2973D5
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751610AbgJWQaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751586AbgJWQap (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZ+rMtNIVJE0chFpsiXOgLU87Yhy1rI2EEdvRwuExCc=;
        b=dkc2WkJhqV0DLcEVbo+BMvag6SKyjfIKOHIgQx95m5WeULOgEMp8eiWl0WU6BXZkp7S8m4
        yzPvGPsAFf+y9M8UoYwQMLfLEXQjdMY/9ympaRGMBn+zmVFm0IfSAU4zzpgZ+pAsnWFdmd
        W63gSaL0r7rui7ONZxuwbr9mfXGtV8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-BFZEmebkObOBuuT2IKKCaQ-1; Fri, 23 Oct 2020 12:30:40 -0400
X-MC-Unique: BFZEmebkObOBuuT2IKKCaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD7FB805729;
        Fri, 23 Oct 2020 16:30:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75F08756AC;
        Fri, 23 Oct 2020 16:30:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 14/22] kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU
Date:   Fri, 23 Oct 2020 12:30:16 -0400
Message-Id: <20201023163024.2765558-15-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
hooks to handle the invalidate range family of MMU notifiers.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-13-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 ++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 3 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31d7ba716b44..35c277ed6c78 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1497,7 +1497,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 			unsigned flags)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+	int r;
+
+	r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
+
+	return r;
 }
 
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f06802289c1f..96bc6aa39628 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -52,7 +52,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end);
+			  gfn_t start, gfn_t end, bool can_yield);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -65,7 +65,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn);
+	zap_gfn_range(kvm, root, 0, max_gfn, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -303,9 +303,14 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
+ * If can_yield is true, will release the MMU lock and reschedule if the
+ * scheduler needs the CPU or there is contention on the MMU lock. If this
+ * function cannot yield, it will not release the MMU lock or reschedule and
+ * the caller must ensure it does not supply too large a GFN range, or the
+ * operation can cause a soft lockup.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end)
+			  gfn_t start, gfn_t end, bool can_yield)
 {
 	struct tdp_iter iter;
 	bool flush_needed = false;
@@ -326,7 +331,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+		if (can_yield)
+			flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+		else
+			flush_needed = true;
 	}
 	return flush_needed;
 }
@@ -349,7 +357,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 		 */
 		kvm_mmu_get_root(kvm, root);
 
-		flush |= zap_gfn_range(kvm, root, start, end);
+		flush |= zap_gfn_range(kvm, root, start, end, true);
 
 		kvm_mmu_put_root(kvm, root);
 	}
@@ -496,3 +504,65 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	return ret;
 }
+
+static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
+		unsigned long end, unsigned long data,
+		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       struct kvm_mmu_page *root, gfn_t start,
+			       gfn_t end, unsigned long data))
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	struct kvm_mmu_page *root;
+	int ret = 0;
+	int as_id;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		kvm_mmu_get_root(kvm, root);
+
+		as_id = kvm_mmu_page_as_id(root);
+		slots = __kvm_memslots(kvm, as_id);
+		kvm_for_each_memslot(memslot, slots) {
+			unsigned long hva_start, hva_end;
+			gfn_t gfn_start, gfn_end;
+
+			hva_start = max(start, memslot->userspace_addr);
+			hva_end = min(end, memslot->userspace_addr +
+				      (memslot->npages << PAGE_SHIFT));
+			if (hva_start >= hva_end)
+				continue;
+			/*
+			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+			 */
+			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
+			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
+
+			ret |= handler(kvm, memslot, root, gfn_start,
+				       gfn_end, data);
+		}
+
+		kvm_mmu_put_root(kvm, root);
+	}
+
+	return ret;
+}
+
+static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
+				     struct kvm_memory_slot *slot,
+				     struct kvm_mmu_page *root, gfn_t start,
+				     gfn_t end, unsigned long unused)
+{
+	return zap_gfn_range(kvm, root, start, end, false);
+}
+
+int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
+					    zap_gfn_range_hva_wrapper);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index aed21a7a3bd6..af25d2462cb8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -18,4 +18,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		    int map_writable, int max_level, kvm_pfn_t pfn,
 		    bool prefault);
+
+int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


