Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FA9473836
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244111AbhLMW7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244071AbhLMW7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:38 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215C3C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:38 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e68-20020a621e47000000b004b13a82634eso6731295pfe.23
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r9yRjg9BMyYVZKVb9TRMFJxQhrx7asVzPH3IeS46ZBM=;
        b=h0DWCZaUCcedLKkBjEE3uJkekKZ1VIBGo5hWgx2wS5U0SkUQAdU2XZbuVMwD60nVix
         +CJkVkjVVd8lOwsGR1dLt4V0ZOhgiU7hmEeiGEIJnh3xmL6qL+pUNcqiVI172+gUDZsb
         Qgsvtunq9mdmojh4nP2wgHqDa/hhGh4/tEKftlQTZLSmoIzKOLmQeUbbY0tRgAKsTeXs
         pQrx+NPrwUfx5mhUblat++H9xCCfyn2BVZNnQjl97KUcANOYGJmhLDtpRbqXiW97hXTt
         sQ8dkJ54otTI84i+HEw2abRmIn4Jou7b8xoOlPKOpOIrYUDMWAGPSWzekC4521uz4+kK
         zfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r9yRjg9BMyYVZKVb9TRMFJxQhrx7asVzPH3IeS46ZBM=;
        b=x4Q2mrNN48+2FFqi9Q9SlA0c2eytiv74GwaUaZNPIARx5tZ5fGdY9zYHX2FnAp94MR
         JNgdIZD8qwm4j2gdr0LkEnGROmL5qYWJCm/h7qpD3IDRPugVgtnVYKMM4cPmFtTQmZ6a
         npHHTsTcsPJ3MG/vM5jVn1nRjxTz7N3+9urHXz/9u5YzYMLUQ4aaRkdB8U41+2OEMXzf
         aE7ctT/z4QM9zuIsCeGXSrWbUC+XQpHCqbM77DyTXF1+RVaqPxjXB18dlUQybJ8GOB82
         uMjVQNXHk3R/NvG0cNdreQyRt7L4gGI1IVTnoy9OE6zt3HtSUj3QvfBOVDtJfqjoJ2ji
         KWBQ==
X-Gm-Message-State: AOAM530FCct+h3dShZaZx3KvGZP7oV6ueBQOZfiu9Y2ZfqFRYIem2E7D
        UcDgzMQyONRKoVIH44IdSqRlry/hr2ixwQ==
X-Google-Smtp-Source: ABdhPJxJZ5C4VR0Xm7ItN0P7uAYzN3Kx6zVFXx9ZigyjYbL6g8i3FP4UIRct3a8OvcwFl2DnRVJ5K9EoW60E7A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:22c6:b0:141:fac1:b722 with SMTP
 id y6-20020a17090322c600b00141fac1b722mr1887176plg.23.1639436377559; Mon, 13
 Dec 2021 14:59:37 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:15 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-11-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 10/13] KVM: Push MMU locking down into kvm_arch_mmu_enable_log_dirty_pt_masked
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of acquiring the MMU lock in the arch-generic code, force each
implementation of kvm_arch_mmu_enable_log_dirty_pt_masked to acquire the
MMU lock as needed. This is in preparation for performing eager page
splitting in the x86 implementation of
kvm_arch_mmu_enable_log_dirty_pt_masked, which involves dropping the MMU
lock in write-mode and re-acquiring it in read mode (and possibly
rescheduling) during splitting. Pushing the MMU lock down into the
arch code makes the x86 synchronization much easier to reason about, and
does not harm readability of other architectures.

This should be a safe change because:

* No architecture requires a TLB flush before dropping the MMU lock.
* The dirty bitmap does not need to be synchronized with changes to the
  page tables by the MMU lock as evidenced by the fact that x86 modifies
  the dirty bitmap without acquiring the MMU lock in fast_page_fault.

This change does increase the number of times the MMU lock is acquired
and released during KVM_CLEAR_DIRTY_LOG, but this is not a performance
critical path and breaking up the lock duration may reduce contention
on vCPU threads.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/arm64/kvm/mmu.c   | 2 ++
 arch/mips/kvm/mmu.c    | 5 +++--
 arch/riscv/kvm/mmu.c   | 2 ++
 arch/x86/kvm/mmu/mmu.c | 4 ++++
 virt/kvm/dirty_ring.c  | 2 --
 virt/kvm/kvm_main.c    | 4 ----
 6 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e65acf35cee3..48085cb534d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -749,7 +749,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
+	spin_lock(&kvm->mmu_lock);
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 1bfd1b501d82..7e67edcd5aae 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -409,8 +409,7 @@ int kvm_mips_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn)
  * @mask:	The mask of dirty pages at offset 'gfn_offset' in this memory
  *		slot to be write protected
  *
- * Walks bits set in mask write protects the associated pte's. Caller must
- * acquire @kvm->mmu_lock.
+ * Walks bits set in mask write protects the associated pte's.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -420,7 +419,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	gfn_t start = base_gfn +  __ffs(mask);
 	gfn_t end = base_gfn + __fls(mask);
 
+	spin_lock(&kvm->mmu_lock);
 	kvm_mips_mkclean_gpa_pt(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 /*
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 7d884b15cf5e..d084ac939b0f 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -424,7 +424,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
+	spin_lock(&kvm->mmu_lock);
 	stage2_wp_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9116c6a4ced1..c9e5fe290714 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1347,6 +1347,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
+	write_lock(&kvm->mmu_lock);
+
 	/*
 	 * Huge pages are NOT write protected when we start dirty logging in
 	 * initially-all-set mode; must write protect them here so that they
@@ -1374,6 +1376,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+
+	write_unlock(&kvm->mmu_lock);
 }
 
 int kvm_cpu_dirty_log_size(void)
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 88f4683198ea..6b26ec60c96a 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -61,9 +61,7 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
 		return;
 
-	KVM_MMU_LOCK(kvm);
 	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
-	KVM_MMU_UNLOCK(kvm);
 }
 
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3595eddd476a..da4850fb2982 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2048,7 +2048,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
-		KVM_MMU_LOCK(kvm);
 		for (i = 0; i < n / sizeof(long); i++) {
 			unsigned long mask;
 			gfn_t offset;
@@ -2064,7 +2063,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
-		KVM_MMU_UNLOCK(kvm);
 	}
 
 	if (flush)
@@ -2159,7 +2157,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -2182,7 +2179,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 								offset, mask);
 		}
 	}
-	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.34.1.173.g76aa8bc2d0-goog

