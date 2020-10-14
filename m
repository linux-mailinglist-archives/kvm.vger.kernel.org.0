Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937DD28E661
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389802AbgJNS2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388613AbgJNS10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:26 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39308C061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:26 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id v7so50386plp.23
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=hkNKsBF60m7BvmN3QxbxSqMRTzsy0y9J5Po6mL/IB9c=;
        b=pe85GixKyXi2QiVC4AItexRyw4KUvjDLrDmc8khVTPhKaOlEPZXzdEGtecVI+Xzwy5
         npOTd7JLcCpJNm6fAbt5Aaj2G9me3jSjBY8+5ew5MJUHhUYKruA6UvJukKmLYxgf0QAd
         R1oKvX8QHBroCei1ZbmQpfH0+Wmb4R6DjLR7uCusYQfucVWHVDVfKzWcewRXb4S7CETF
         41lbjMozCLvRE8vzQDJg53NNlkfBX8NVhGBeOQsgm4US9za0+Fx53EY+1vaxD5aIPZcE
         EECzbhxXeZhxihWXAJnetxKRFXCCeyMcMEtfmsRRtQHxIlmMPkW26NVfJYuTbxQtQ0Xn
         KNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hkNKsBF60m7BvmN3QxbxSqMRTzsy0y9J5Po6mL/IB9c=;
        b=HhCU7eqvrqKCyYACK3OI0lztYk23StOyuauMVl6f9865if2g/1gEcVhd/GXi5MXYMB
         SDCqnqQ9M25en4seJV4s/Lu+7DjwOwhyOZ4YID8Fubnx/Onf0OMNP/KaUHrW2bjvUC8m
         /Uqgps1U0j3Wb+8ueBfGtEuVAjRH3ew4aKdH19cCWsoQVvgPLpNOyukO3Q5OUx3w3Ssw
         S6pUnvUEHLxH6dBK0F8Yff/iNFV8+y9/kp5j9dO1UWsbtS3inZY7FNBZSFCxr1ZHHkyy
         s87lUprwn9HOtF+g89KU08XhtkacxQHekEzcd3ZhgyN8gaTkQgeA0xKhEo0Fceh26ZwY
         thUg==
X-Gm-Message-State: AOAM531oSOpTDJx/sNK7NoTc6gUmuJ7bibI1+ksT+FFsXbjK38mJebSs
        K5Me3XHYjVFhPmTx8AKO0OiP53wFQ+zy
X-Google-Smtp-Source: ABdhPJyqyNioSrc7lGAo0sz2wPtjFzYdMZGpHTDD0T0wHnBt5QgzHp91ljqQw1MjMpG+dOcjNcng/JsG7dDP
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:8b89:b029:d2:4345:5dd with SMTP id
 ay9-20020a1709028b89b02900d2434505ddmr256316plb.57.1602700045732; Wed, 14 Oct
 2020 11:27:25 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:52 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-13-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 12/20] kvm: x86/mmu: Support invalidate range MMU notifier
 for TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
hooks to handle the invalidate range family of MMU notifiers.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 ++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +
 3 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 421a12a247b67..00534133f99fc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1781,7 +1781,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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
index 78d41a1949651..9ec6c26ed6619 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -58,7 +58,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end);
+			  gfn_t start, gfn_t end, bool can_yield);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -71,7 +71,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn);
+	zap_gfn_range(kvm, root, 0, max_gfn, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -318,9 +318,14 @@ static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
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
@@ -341,7 +346,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+		if (can_yield)
+			flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+		else
+			flush_needed = true;
 	}
 	return flush_needed;
 }
@@ -364,7 +372,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 		 */
 		get_tdp_mmu_root(kvm, root);
 
-		flush |= zap_gfn_range(kvm, root, start, end);
+		flush |= zap_gfn_range(kvm, root, start, end, true);
 
 		put_tdp_mmu_root(kvm, root);
 	}
@@ -502,3 +510,65 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
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
+		get_tdp_mmu_root(kvm, root);
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
+		put_tdp_mmu_root(kvm, root);
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
index 4d111a4dd332f..026ceb6284102 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -19,4 +19,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		    int map_writable, int max_level, kvm_pfn_t pfn,
 		    bool prefault, bool is_tdp);
 
+int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.1011.ga647a8990f-goog

