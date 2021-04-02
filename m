Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA3B352D6C
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236268AbhDBP1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbhDBP1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:27:04 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F2BC06178C
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:27:02 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id q29so8028899lfb.4
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HR3F/UAJDKjuF9Hl3a5y3RW0XzXLCZLHeNx4ieqs1Ks=;
        b=OFCJ7C88v9T3ZO5FuIYZ4WIRU5HzJdSZ1SrnGSxqXG0JIRO7fdUSBe12lbgfVjrRrs
         33I5UWqpEXf8bMQMoXTC+zFHmulioWoCYamTDLQx/E44uzS7VwKJfiYOyAFdbvP2GbYF
         j4NxZdYwvrgFPaiRHOQIeuRqDoIs77acL205ScFv0qnp1SINI72VldrxQLzap3Ku6RGW
         PRbjp5iWVRXzUtB+X0KdlxhO3BbB3YbfdCoO6fzmTsem/oXkGYwNbySMtSx8SOP9Lfh0
         AnNRbGe8VbXOtX2DrKRr4IbQRFOQvSPRWDDkHqpO4t0DVYfbTJH5NAYR+q6UYA5zjYCa
         7nOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HR3F/UAJDKjuF9Hl3a5y3RW0XzXLCZLHeNx4ieqs1Ks=;
        b=HfuPNU6+9sHU8+ubLHLXZZWUyGxQSkEwY2rWJRqHJFRebykdfvxDI9Feu3vuNAWPtb
         GLeM7+EhvONR3QR4k3ExczlOfegEjw65ZknU0mrHxfjVS2AaodMGGxtjawzIuV8x8VRQ
         BF3svCqc0uJijmtIb91OYZxvCeUvPVMVwOhuIJlCFlamClX6bu0Dl+PbVLlwlwFFFRDp
         C91mF8DtT0sPpZwKDfjU0d9dLm/jzgCCEyOZRmtXcICDcEsdeOLbSe4xF23aylktcNfF
         0cFWYhlL2wn2Q7Xu4FxKvJxgVSkC5XLla1O/GdYPsj9byWb69URtv+xqwMoeC5zzVJEf
         7dzQ==
X-Gm-Message-State: AOAM530k7WbLuf0rflTzSBQ3evTz+BpvukAfVHQmhq+OpSLzBu8yvcp6
        GlZGG255iY7MIC6nPgmv9ko0Aw==
X-Google-Smtp-Source: ABdhPJza487W4PANJskXRHpy88EZKj+PehJI/iZExRzRuFwVX6dYkWpTyngQQRbKtaDSI0NNHf/b8Q==
X-Received: by 2002:ac2:4205:: with SMTP id y5mr9143399lfh.375.1617377220699;
        Fri, 02 Apr 2021 08:27:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id i4sm884729lfv.161.2021.04.02.08.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:26:59 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 574C3102679; Fri,  2 Apr 2021 18:26:59 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Date:   Fri,  2 Apr 2021 18:26:45 +0300
Message-Id: <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX architecture aims to provide resiliency against confidentiality and
integrity attacks. Towards this goal, the TDX architecture helps enforce
the enabling of memory integrity for all TD-private memory.

The CPU memory controller computes the integrity check value (MAC) for
the data (cache line) during writes, and it stores the MAC with the
memory as meta-data. A 28-bit MAC is stored in the ECC bits.

Checking of memory integrity is performed during memory reads. If
integrity check fails, CPU poisones cache line.

On a subsequent consumption (read) of the poisoned data by software,
there are two possible scenarios:

 - Core determines that the execution can continue and it treats
   poison with exception semantics signaled as a #MCE

 - Core determines execution cannot continue,and it does an unbreakable
   shutdown

For more details, see Chapter 14 of Intel TDX Module EAS[1]

As some of integrity check failures may lead to system shutdown host
kernel must not allow any writes to TD-private memory. This requirment
clashes with KVM design: KVM expects the guest memory to be mapped into
host userspace (e.g. QEMU).

This patch aims to start discussion on how we can approach the issue.

For now I intentionally keep TDX out of picture here and try to find a
generic way to unmap KVM guest memory from host userspace. Hopefully, it
makes the patch more approachable. And anyone can try it out.

To the proposal:

Looking into existing codepaths I've discovered that we already have
semantics we want. That's PG_hwpoison'ed pages and SWP_HWPOISON swap
entries in page tables:

  - If an application touches a page mapped with the SWP_HWPOISON, it will
    get SIGBUS.

  - GUP will fail with -EFAULT;

Access the poisoned memory via page cache doesn't match required
semantics right now, but it shouldn't be too hard to make it work:
access to poisoned dirty pages should give -EIO or -EHWPOISON.

My idea is that we can mark page as poisoned when we make it TD-private
and replace all PTEs that map the page with SWP_HWPOISON.

The patch is proof-of-concept and has known issues:

  - Limited to swap-backed pages for now: anon or tmpfs/shmem

  - No THP support

  - Need a new FOLL_XXX flags to access such pages from KVM code.

  - Page unpoisoning is not implemented. It proved to be more difficult
    than I expected. I'm looking into solution.

  - Poisoned pages must be tied to KVM instance and another KVM must not
    be able to map the page into guest.

[1] https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf

Not-signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/Kconfig           |   1 +
 arch/x86/kvm/cpuid.c           |   3 +-
 arch/x86/kvm/mmu/mmu.c         |  15 ++-
 arch/x86/kvm/mmu/paging_tmpl.h |  10 +-
 arch/x86/kvm/x86.c             |   6 ++
 include/linux/kvm_host.h       |  12 +++
 include/linux/swapops.h        |  20 ++++
 include/uapi/linux/kvm_para.h  |   1 +
 mm/gup.c                       |  31 ++++---
 mm/memory.c                    |  45 ++++++++-
 mm/page_vma_mapped.c           |   8 +-
 mm/rmap.c                      |   2 +-
 mm/shmem.c                     |   7 ++
 virt/kvm/Kconfig               |   3 +
 virt/kvm/kvm_main.c            | 164 +++++++++++++++++++++++++++++----
 15 files changed, 290 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7ac592664c52..b7db1c455e7c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,6 +46,7 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_VFIO
 	select SRCU
+	select HAVE_KVM_PROTECTED_MEMORY
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 38172ca627d3..1457692c1080 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -796,7 +796,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_MEM_PROTECTED);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..53a69c8c59f1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -43,6 +43,7 @@
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
 #include <linux/kthread.h>
+#include <linux/rmap.h>
 
 #include <asm/page.h>
 #include <asm/memtype.h>
@@ -2758,7 +2759,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	if (sp->role.level > PG_LEVEL_4K)
 		return;
 
-	__direct_pte_prefetch(vcpu, sp, sptep);
+	if (!vcpu->kvm->mem_protected)
+		__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
 static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
@@ -3723,6 +3725,17 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
 		return r;
 
+	if (vcpu->kvm->mem_protected && unlikely(!is_noslot_pfn(pfn)) &&
+	    !gfn_is_shared(vcpu->kvm, gfn)) {
+		struct page *page = pfn_to_page(pfn);
+		lock_page(page);
+		VM_BUG_ON_PAGE(!PageSwapBacked(page) && !PageReserved(page), page);
+		/* Recheck gfn_is_shared() under page lock */
+		if (!gfn_is_shared(vcpu->kvm, gfn) && !TestSetPageHWPoison(page))
+			try_to_unmap(page, TTU_IGNORE_MLOCK);
+		unlock_page(page);
+	}
+
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..26b0494a1207 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -397,8 +397,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			goto error;
 
 		ptep_user = (pt_element_t __user *)((void *)host_addr + offset);
-		if (unlikely(__get_user(pte, ptep_user)))
-			goto error;
+		if (vcpu->kvm->mem_protected) {
+			if (copy_from_guest(vcpu->kvm, &pte, host_addr + offset,
+					    sizeof(pte)))
+				goto error;
+		} else {
+			if (unlikely(__get_user(pte, ptep_user)))
+				goto error;
+		}
 		walker->ptep_user[walker->level - 1] = ptep_user;
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b404e4d7dd8..f8183386abe7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8170,6 +8170,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_ENABLE_MEM_PROTECTED:
+		ret = kvm_protect_memory(vcpu->kvm);
+		break;
+	case KVM_HC_MEM_SHARE:
+		ret = kvm_share_memory(vcpu->kvm, a0, a1);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..f941bcbefb79 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -436,6 +436,8 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
+#define KVM_NR_SHARED_RANGES 32
+
 /*
  * Note:
  * memslots are not sorted by id anymore, please use id_to_memslot()
@@ -513,6 +515,9 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+	bool mem_protected;
+	int nr_shared_ranges;
+	struct range shared_ranges[KVM_NR_SHARED_RANGES];
 };
 
 #define kvm_err(fmt, ...) \
@@ -709,6 +714,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
+int kvm_protect_memory(struct kvm *kvm);
+int kvm_share_memory(struct kvm *kvm, unsigned long gfn, unsigned long npages);
+bool gfn_is_shared(struct kvm *kvm, unsigned long gfn);
+
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			    struct page **pages, int nr_pages);
 
@@ -718,6 +727,9 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 				      bool *writable);
+int copy_from_guest(struct kvm *kvm, void *data, unsigned long hva, int len);
+int copy_to_guest(struct kvm *kvm, unsigned long hva, const void *data, int len);
+
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index d9b7c9132c2f..520589b12fb3 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -323,6 +323,16 @@ static inline int is_hwpoison_entry(swp_entry_t entry)
 	return swp_type(entry) == SWP_HWPOISON;
 }
 
+static inline unsigned long hwpoison_entry_to_pfn(swp_entry_t entry)
+{
+	return swp_offset(entry);
+}
+
+static inline struct page *hwpoison_entry_to_page(swp_entry_t entry)
+{
+	return pfn_to_page(hwpoison_entry_to_pfn(entry));
+}
+
 static inline void num_poisoned_pages_inc(void)
 {
 	atomic_long_inc(&num_poisoned_pages);
@@ -345,6 +355,16 @@ static inline int is_hwpoison_entry(swp_entry_t swp)
 	return 0;
 }
 
+static inline unsigned long hwpoison_entry_to_pfn(swp_entry_t entry)
+{
+	return 0;
+}
+
+static inline struct page *hwpoison_entry_to_page(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline void num_poisoned_pages_inc(void)
 {
 }
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 09d36683ee0a..743e621111f0 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -17,6 +17,7 @@
 #define KVM_E2BIG		E2BIG
 #define KVM_EPERM		EPERM
 #define KVM_EOPNOTSUPP		95
+#define KVM_EINTR		EINTR
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
 #define KVM_HC_MMU_OP			2
diff --git a/mm/gup.c b/mm/gup.c
index e4c224cd9661..ce4fdf213455 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -384,22 +384,31 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	pte = *ptep;
 	if (!pte_present(pte)) {
-		swp_entry_t entry;
+		swp_entry_t entry = pte_to_swp_entry(pte);
+
+		if (pte_none(pte))
+			goto no_page;
+
 		/*
 		 * KSM's break_ksm() relies upon recognizing a ksm page
 		 * even while it is being migrated, so for that case we
 		 * need migration_entry_wait().
 		 */
-		if (likely(!(flags & FOLL_MIGRATION)))
-			goto no_page;
-		if (pte_none(pte))
-			goto no_page;
-		entry = pte_to_swp_entry(pte);
-		if (!is_migration_entry(entry))
-			goto no_page;
-		pte_unmap_unlock(ptep, ptl);
-		migration_entry_wait(mm, pmd, address);
-		goto retry;
+		if (is_migration_entry(entry) && (flags & FOLL_MIGRATION)) {
+			pte_unmap_unlock(ptep, ptl);
+			migration_entry_wait(mm, pmd, address);
+			goto retry;
+		}
+
+		if (is_hwpoison_entry(entry)) {
+			page = hwpoison_entry_to_page(entry);
+			if (PageHWPoison(page) /* && (flags & FOLL_ALLOW_POISONED) */) {
+				get_page(page);
+				goto out;
+			}
+		}
+
+		goto no_page;
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..524dce15a087 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -767,6 +767,9 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				pte = pte_swp_mkuffd_wp(pte);
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
+	} else if (is_hwpoison_entry(entry)) {
+		page = hwpoison_entry_to_page(entry);
+		get_page(page);
 	}
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -1305,6 +1308,9 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 
 			page = migration_entry_to_page(entry);
 			rss[mm_counter(page)]--;
+
+		} else if (is_hwpoison_entry(entry)) {
+			put_page(hwpoison_entry_to_page(entry));
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
 			print_bad_pte(vma, addr, ptent, NULL);
@@ -3274,7 +3280,43 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			vmf->page = device_private_entry_to_page(entry);
 			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
 		} else if (is_hwpoison_entry(entry)) {
-			ret = VM_FAULT_HWPOISON;
+			page = hwpoison_entry_to_page(entry);
+
+			locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
+			if (!locked) {
+				ret = VM_FAULT_RETRY;
+				goto out;
+			}
+
+			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+						       vmf->address, &vmf->ptl);
+
+			if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
+				ret = 0;
+			} else if (PageHWPoison(page)) {
+				ret = VM_FAULT_HWPOISON;
+			} else {
+				/*
+				 * The page is unpoisoned. Replace hwpoison
+				 * entry with a present PTE.
+				 */
+
+				inc_mm_counter(vma->vm_mm, mm_counter(page));
+				pte = mk_pte(page, vma->vm_page_prot);
+
+				if (PageAnon(page)) {
+					page_add_anon_rmap(page, vma,
+							   vmf->address, false);
+				} else {
+					page_add_file_rmap(page, false);
+				}
+
+				set_pte_at(vma->vm_mm, vmf->address,
+					   vmf->pte, pte);
+			}
+
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			unlock_page(page);
 		} else {
 			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
 			ret = VM_FAULT_SIGBUS;
@@ -3282,7 +3324,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 	}
 
-
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry, vma, vmf->address);
 	swapcache = page;
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 86e3a3688d59..8fffae175104 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -93,10 +93,12 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw)
 			return false;
 		entry = pte_to_swp_entry(*pvmw->pte);
 
-		if (!is_migration_entry(entry))
+		if (is_migration_entry(entry))
+			pfn = migration_entry_to_pfn(entry);
+		else if (is_hwpoison_entry(entry))
+			pfn = hwpoison_entry_to_pfn(entry);
+		else
 			return false;
-
-		pfn = migration_entry_to_pfn(entry);
 	} else if (is_swap_pte(*pvmw->pte)) {
 		swp_entry_t entry;
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 08c56aaf72eb..f08d1fc28522 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1575,7 +1575,7 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 				dec_mm_counter(mm, mm_counter(page));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
-
+			get_page(page);
 		} else if (pte_unused(pteval) && !userfaultfd_armed(vma)) {
 			/*
 			 * The guest indicated that the page content is of no
diff --git a/mm/shmem.c b/mm/shmem.c
index 7c6b6d8f6c39..d29a0c9be19c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1832,6 +1832,13 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 
 	if (page)
 		hindex = page->index;
+
+	if (page && PageHWPoison(page)) {
+		unlock_page(page);
+		put_page(page);
+		return -EIO;
+	}
+
 	if (page && sgp == SGP_WRITE)
 		mark_page_accessed(page);
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1c37ccd5d402..50d7422386aa 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -63,3 +63,6 @@ config HAVE_KVM_NO_POLL
 
 config KVM_XFER_TO_GUEST_WORK
        bool
+
+config HAVE_KVM_PROTECTED_MEMORY
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8367d88ce39b..f182c54bfa34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
+#include <linux/rmap.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -2333,19 +2334,85 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+int copy_from_guest(struct kvm *kvm, void *data, unsigned long hva, int len)
+{
+	int offset = offset_in_page(hva);
+	struct page *page;
+	int npages, seg;
+	void *vaddr;
+
+	if (!IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) ||
+	    !kvm->mem_protected) {
+		return __copy_from_user(data, (void __user *)hva, len);
+	}
+
+	might_fault();
+	kasan_check_write(data, len);
+	check_object_size(data, len, false);
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		npages = get_user_pages_unlocked(hva, 1, &page, 0);
+		if (npages != 1)
+			return -EFAULT;
+
+		vaddr = kmap_atomic(page);
+		memcpy(data, vaddr + offset, seg);
+		kunmap_atomic(vaddr);
+
+		put_page(page);
+		len -= seg;
+		hva += seg;
+		data += seg;
+		offset = 0;
+	}
+
+	return 0;
+}
+
+int copy_to_guest(struct kvm *kvm, unsigned long hva, const void *data, int len)
+{
+	int offset = offset_in_page(hva);
+	struct page *page;
+	int npages, seg;
+	void *vaddr;
+
+	if (!IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) ||
+	    !kvm->mem_protected) {
+		return __copy_to_user((void __user *)hva, data, len);
+	}
+
+	might_fault();
+	kasan_check_read(data, len);
+	check_object_size(data, len, true);
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
+		if (npages != 1)
+			return -EFAULT;
+
+		vaddr = kmap_atomic(page);
+		memcpy(vaddr + offset, data, seg);
+		kunmap_atomic(vaddr);
+
+		put_page(page);
+		len -= seg;
+		hva += seg;
+		data += seg;
+		offset = 0;
+	}
+
+	return 0;
+}
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
-	int r;
 	unsigned long addr;
 
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
-		return -EFAULT;
-	return 0;
+	return copy_from_guest(kvm, data, addr + offset, len);
 }
 
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
@@ -2353,7 +2420,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -2362,7 +2429,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -2444,7 +2511,8 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	addr = gfn_to_hva_memslot(memslot, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
+
+	r = copy_to_guest(kvm, addr + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
@@ -2581,7 +2649,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_write_guest(kvm, gpa, data, len);
 
-	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
+	r = copy_to_guest(kvm, ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
@@ -2602,7 +2670,6 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				 unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
-	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
 	BUG_ON(len + offset > ghc->len);
@@ -2618,11 +2685,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_read_guest(kvm, gpa, data, len);
 
-	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
-	if (r)
-		return -EFAULT;
-
-	return 0;
+	return copy_from_guest(kvm, data, ghc->hva + offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_offset_cached);
 
@@ -2688,6 +2751,73 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+int kvm_protect_memory(struct kvm *kvm)
+{
+	if (mmap_write_lock_killable(kvm->mm))
+		return -KVM_EINTR;
+	kvm->mem_protected = true;
+	kvm_arch_flush_shadow_all(kvm);
+	mmap_write_unlock(kvm->mm);
+
+	return 0;
+}
+
+bool gfn_is_shared(struct kvm *kvm, unsigned long gfn)
+{
+	bool ret = false;
+	int i;
+
+	spin_lock(&kvm->mmu_lock);
+	for (i = 0; i < kvm->nr_shared_ranges; i++) {
+		if (gfn < kvm->shared_ranges[i].start)
+			continue;
+		if (gfn >= kvm->shared_ranges[i].end)
+			continue;
+
+		ret = true;
+		break;
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	return ret;
+}
+
+int kvm_share_memory(struct kvm *kvm, unsigned long gfn, unsigned long npages)
+{
+	unsigned long end = gfn + npages;
+
+	if (!npages)
+		return 0;
+
+	/*
+	 * Out of slots.
+	 * Still worth to proceed: the new range may merge with an existing
+	 * one.
+	 */
+	WARN_ON_ONCE(kvm->nr_shared_ranges == ARRAY_SIZE(kvm->shared_ranges));
+
+	spin_lock(&kvm->mmu_lock);
+	kvm->nr_shared_ranges = add_range_with_merge(kvm->shared_ranges,
+						ARRAY_SIZE(kvm->shared_ranges),
+						kvm->nr_shared_ranges, gfn, end);
+	kvm->nr_shared_ranges = clean_sort_range(kvm->shared_ranges,
+					    ARRAY_SIZE(kvm->shared_ranges));
+	spin_unlock(&kvm->mmu_lock);
+
+	for (; gfn < end; gfn++) {
+		struct page *page = gfn_to_page(kvm, gfn);
+
+		if (page == KVM_ERR_PTR_BAD_PAGE)
+			continue;
+		lock_page(page);
+		ClearPageHWPoison(page);
+		unlock_page(page);
+		put_page(page);
+	}
+
+	return 0;
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->sigset_active)
-- 
2.26.3

