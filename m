Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E17320F8D
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 03:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhBVCrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 21:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhBVCrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 21:47:01 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0D7C0617A9
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 18:45:57 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so5748894pfq.0
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 18:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ss521oD40ZnZ/Nyo5tW+L84EULMrNn4Gw0gjrJuxp1M=;
        b=jwFgb/QDUW4kzKwp9G2USfUDzhdnenGNye8WO1n6t2LMoEN2pCbtbpWfuAVgzItrx0
         ACzoVjZvZRU3wJ3t+SO3k8TauTXtaXVoUguMFxqNYto5twkjywEuQXFgmwKOl/CWVanm
         NfLeYgvoeIF0rtnjepULnjMZEZV32vDGWZaxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ss521oD40ZnZ/Nyo5tW+L84EULMrNn4Gw0gjrJuxp1M=;
        b=gRtf+XaZIZJkzXuxFcmW2pUSRlCXfwSOGSq7NWDX2NTVdah+4m8cY598l93rhCxqcs
         DYMeuGEbaWHsk+r7iQprLr31ToCYzTaowTajenoeu8TO5PiEP65OQMDBIRLn+NxTUXHI
         trHbv7ENKqr4Bb6rWgItQi8TD9W35OPkdiFvorBYJRQDZNaLy51T3VHgSahVDc3hym0q
         men07CJW4rq2g5r3H6X+CYFlRM8EUANeVGUHzzNd3lSWPSfh+8Tju82zzoWycJ9Bu4Fe
         CENZcxPDW1/5+YDZqmq0FqK1X3FYoaSoejBOvW2l8OX0ordKkcajX/MGFX4J3b57VKVB
         19JQ==
X-Gm-Message-State: AOAM531HEGiJMClsqQb9+8mAKEhL6z6/piZkAdZoPlg7J8ParDBGNsTL
        ddcG5IL5B+UYA3Z/AwiMEEollw==
X-Google-Smtp-Source: ABdhPJwNgvHyZmW+/s05ddugGwvWr9Qw9pnLSevD8i66tTa9xzVCqS1ccHwM239iTRUUoYE9KH6RCg==
X-Received: by 2002:aa7:9356:0:b029:1dd:644a:d904 with SMTP id 22-20020aa793560000b02901dd644ad904mr19753804pfn.18.1613961956628;
        Sun, 21 Feb 2021 18:45:56 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:11b3:5e1a:7cb:7e1f])
        by smtp.gmail.com with UTF8SMTPSA id 14sm16852882pfy.55.2021.02.21.18.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 18:45:56 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v4 2/2] KVM: x86/mmu: Consider the hva in mmu_notifier retry
Date:   Mon, 22 Feb 2021 11:45:22 +0900
Message-Id: <20210222024522.1751719-3-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
In-Reply-To: <20210222024522.1751719-1-stevensd@google.com>
References: <20210222024522.1751719-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Track the range being invalidated by mmu_notifier and skip page fault
retries if the fault address is not affected by the in-progress
invalidation. Handle concurrent invalidations by finding the minimal
range which includes all ranges being invalidated. Although the combined
range may include unrelated addresses and cannot be shrunk as individual
invalidation operations complete, it is unlikely the marginal gains of
proper range tracking are worth the additional complexity.

The primary benefit of this change is the reduction in the likelihood of
extreme latency when handing a page fault due to another thread having
been preempted while modifying host virtual addresses.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
v3 -> v4:
 - Skip prefetch while invalidations are in progress

v2 -> v3:
 - Removed unnecessary ifdef
 - Style changes

v1 -> v2:
 - Improve handling of concurrent invalidation requests by unioning
   ranges, instead of just giving up and using [0, ULONG_MAX).
 - Add lockdep check
 - Code comments and formatting

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 23 ++++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
 include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
 virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
 6 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 38ea396a23d6..8e06cd3f759c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -590,7 +590,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok);
+					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bb35490400e9..e603de7ade52 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -822,7 +822,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p);
+					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9ac0a727015d..f6aaac729667 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2758,6 +2758,13 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	if (sp->role.level > PG_LEVEL_4K)
 		return;
 
+	/*
+	 * If addresses are being invalidated, skip prefetching to avoid
+	 * accidentally prefetching those addresses.
+	 */
+	if (unlikely(vcpu->kvm->mmu_notifier_count))
+		return;
+
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
@@ -3658,8 +3665,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
-			 bool *writable)
+			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
+			 bool write, bool *writable)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
@@ -3672,7 +3679,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
+				    write, writable, hva);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3686,7 +3694,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
+				    write, writable, hva);
 	return false;
 }
 
@@ -3699,6 +3708,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	hva_t hva;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
@@ -3717,7 +3727,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
+			 write, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
@@ -3725,7 +3736,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ab54263d857c..5f12f7b24d68 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -790,6 +790,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	struct guest_walker walker;
 	int r;
 	kvm_pfn_t pfn;
+	hva_t hva;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
 	int max_level;
@@ -840,8 +841,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
-			 &map_writable))
+	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
+			 write_fault, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
@@ -869,7 +870,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..850ff351583d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -11,6 +11,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
+#include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/preempt.h>
@@ -502,6 +503,8 @@ struct kvm {
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
+	unsigned long mmu_notifier_range_start;
+	unsigned long mmu_notifier_range_end;
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
@@ -729,7 +732,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable);
+			       bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -1203,6 +1206,26 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 		return 1;
 	return 0;
 }
+
+static inline int mmu_notifier_retry_hva(struct kvm *kvm,
+					 unsigned long mmu_seq,
+					 unsigned long hva)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+	/*
+	 * If mmu_notifier_count is non-zero, then the range maintained by
+	 * kvm_mmu_notifier_invalidate_range_start contains all addresses that
+	 * might be being invalidated. Note that it may include some false
+	 * positives, due to shortcuts when handing concurrent invalidations.
+	 */
+	if (unlikely(kvm->mmu_notifier_count) &&
+	    hva >= kvm->mmu_notifier_range_start &&
+	    hva < kvm->mmu_notifier_range_end)
+		return 1;
+	if (kvm->mmu_notifier_seq != mmu_seq)
+		return 1;
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8367d88ce39b..4a69bc13680c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -483,6 +483,24 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
+	if (likely(kvm->mmu_notifier_count == 1)) {
+		kvm->mmu_notifier_range_start = range->start;
+		kvm->mmu_notifier_range_end = range->end;
+	} else {
+		/*
+		 * Fully tracking multiple concurrent ranges has dimishing
+		 * returns. Keep things simple and just find the minimal range
+		 * which includes the current and new ranges. As there won't be
+		 * enough information to subtract a range after its invalidate
+		 * completes, any ranges invalidated concurrently will
+		 * accumulate and persist until all outstanding invalidates
+		 * complete.
+		 */
+		kvm->mmu_notifier_range_start =
+			min(kvm->mmu_notifier_range_start, range->start);
+		kvm->mmu_notifier_range_end =
+			max(kvm->mmu_notifier_range_end, range->end);
+	}
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
 	/* we've to flush the tlb before the pages can be freed */
@@ -2011,10 +2029,13 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable)
+			       bool *writable, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
+	if (hva)
+		*hva = addr;
+
 	if (addr == KVM_HVA_ERR_RO_BAD) {
 		if (writable)
 			*writable = false;
@@ -2042,19 +2063,19 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable);
+				    write_fault, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-- 
2.30.0.617.g56c4b15f3c-goog

