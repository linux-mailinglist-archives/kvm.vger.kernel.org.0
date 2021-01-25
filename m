Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F15302235
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 07:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbhAYGpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 01:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbhAYGnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 01:43:32 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3696C0613D6
        for <kvm@vger.kernel.org>; Sun, 24 Jan 2021 22:42:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u4so8007301pjn.4
        for <kvm@vger.kernel.org>; Sun, 24 Jan 2021 22:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=14Bj46XsmXbx8plhZIOf6y+coaN/fUKX0SPBaGuWf7g=;
        b=K+fEZGRQSbFrMb6wpHc6SmH0r9YjxxbhSOFrGK58eer8lhC15uhhxYdXkoFfOnIokM
         ShizDBmMZx2ZoD5i7bGeHdmqBpHgAIxp9Lla9dEPI1+s266i+9fAKebNZ4SpZlulRt+5
         ta0T+HzD4ymvq7xdjdAyz/vUWgEe76ciMAIH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=14Bj46XsmXbx8plhZIOf6y+coaN/fUKX0SPBaGuWf7g=;
        b=kBOyTjFAXlLAaOUTnS1MOUyx6B1MYdfbmPdW4H40s26Sdu9G/icPksUk9aOb4FvG6G
         4FUkbmBW1LVle+jgmOp2kOd+kbxLekeJHnHSxmz28vQkb/hBevleSN0YifRE38IGx2mi
         5FJqTxRzF9pP6bIEmr+iMFqushOsFDRMG1999nmAcmHs7pWgMp0+wW+UW/xImwBT6inb
         FfEvbfChbnK0+/ayWVFeL9nA+Tz48a0NxIdhPRCUY5RzYH48PXOxdWCohyrSE7Ivs8r0
         Wk3EsSRX7SG3NghmQ90aLTDnoH8eLSqi32tW3JcKaFwDyBIGxoHNsLAxDRf9p0OXfu2P
         RKIQ==
X-Gm-Message-State: AOAM530pofz97MyK/llI12gx5Tq50Hb40/6Mqp3XgKStAnwAMbQ63RoZ
        n8/4axq/NVb6CqIzudvRrxFG/wtySAb6/Q==
X-Google-Smtp-Source: ABdhPJw2Koj77z3eEz0N0rMl8RJZzwBQ86hcwevAAQ4aIZlPMfH8PvMZ5rre+Io8LdeOagBw+lsCUw==
X-Received: by 2002:a17:90a:a44:: with SMTP id o62mr20286765pjo.209.1611556965293;
        Sun, 24 Jan 2021 22:42:45 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f693:9fff:fef4:a930])
        by smtp.gmail.com with ESMTPSA id n8sm17935062pjo.18.2021.01.24.22.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 22:42:44 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>
Subject: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
Date:   Mon, 25 Jan 2021 15:42:34 +0900
Message-Id: <20210125064234.2078146-1-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Use the range passed to mmu_notifer's invalidate_range_start to prevent
spurious page fault retries due to changes in unrelated host virtual
addresses. This has the secondary effect of greatly reducing the
likelihood of extreme latency when handing a page fault due to another
thread having been preempted while modifying host virtual addresses.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
 include/linux/kvm_host.h               | 22 +++++++++++++++++++++-
 virt/kvm/kvm_main.c                    | 22 ++++++++++++++++++----
 6 files changed, 55 insertions(+), 16 deletions(-)

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
index 6d16481aa29d..79166288ed03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3658,8 +3658,8 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 }
 
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
-			 bool *writable)
+			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
+			 bool write, bool *writable)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
@@ -3672,7 +3672,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	}
 
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
+				    write, writable, hva);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -3686,7 +3687,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
+				    write, writable, hva);
 	return false;
 }
 
@@ -3699,6 +3701,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	hva_t hva;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
@@ -3717,7 +3720,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
+			 write, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
@@ -3725,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..3171784139a4 100644
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
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..b70097685249 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -502,6 +502,8 @@ struct kvm {
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
+	unsigned long mmu_notifier_range_start;
+	unsigned long mmu_notifier_range_end;
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
@@ -729,7 +731,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable);
+			       bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -1203,6 +1205,24 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
 		return 1;
 	return 0;
 }
+
+static inline int mmu_notifier_retry_hva(struct kvm *kvm,
+					 unsigned long mmu_seq,
+					 unsigned long hva)
+{
+	/*
+	 * Unlike mmu_notifier_retry, this function relies on
+	 * kvm->mmu_lock for consistency.
+	 */
+	if (unlikely(kvm->mmu_notifier_count)) {
+		if (kvm->mmu_notifier_range_start <= hva &&
+		    hva < kvm->mmu_notifier_range_end)
+			return 1;
+	}
+	if (kvm->mmu_notifier_seq != mmu_seq)
+		return 1;
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa9e3614d30e..d6e1ef5cb184 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -483,6 +483,18 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
+	if (likely(kvm->mmu_notifier_count == 1)) {
+		kvm->mmu_notifier_range_start = range->start;
+		kvm->mmu_notifier_range_end = range->end;
+	} else {
+		/**
+		 * Tracking multiple concurrent ranges has diminishing returns,
+		 * so just use the maximum range. This persists until after all
+		 * outstanding invalidation operations complete.
+		 */
+		kvm->mmu_notifier_range_start = 0;
+		kvm->mmu_notifier_range_end = ULONG_MAX;
+	}
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
 	/* we've to flush the tlb before the pages can be freed */
@@ -2010,9 +2022,11 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable)
+			       bool *writable, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	if (hva)
+		*hva = addr;
 
 	if (addr == KVM_HVA_ERR_RO_BAD) {
 		if (writable)
@@ -2041,19 +2055,19 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
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
2.30.0.280.ga3ce27912f-goog

