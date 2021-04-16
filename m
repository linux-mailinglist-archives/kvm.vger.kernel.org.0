Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48799362442
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344104AbhDPPmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:4092 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344009AbhDPPmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:18 -0400
IronPort-SDR: ys/ErzOvSPh31eGEN6I+iY/Zeoje/pxRuMWX9rdVO037hlrdbFAaCsrz612T5oiqPZ0ZJTriWM
 22DtxA4PEgjA==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="195169170"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="195169170"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:53 -0700
IronPort-SDR: 1PONy81YMcZYKwhg3gFvr/r9D7/FGF9ROpTuRsjtnW2sVq/T3fT9LLPWXFndWTfBDjYnn8O62R
 mTk2PTcSoT0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="419149007"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 16 Apr 2021 08:41:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 5BA5A388; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Date:   Fri, 16 Apr 2021 18:41:06 +0300
Message-Id: <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
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

TODO: THP support is missing.

[1] https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-module-1eas.pdf

Not-signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/Kconfig           |   1 +
 arch/x86/kvm/cpuid.c           |   3 +-
 arch/x86/kvm/mmu/mmu.c         |  12 ++-
 arch/x86/kvm/mmu/paging_tmpl.h |  10 +-
 arch/x86/kvm/x86.c             |   6 ++
 include/linux/kvm_host.h       |  19 ++++
 include/uapi/linux/kvm_para.h  |   1 +
 mm/page_alloc.c                |   7 ++
 virt/Makefile                  |   2 +-
 virt/kvm/Kconfig               |   4 +
 virt/kvm/Makefile              |   1 +
 virt/kvm/kvm_main.c            | 163 ++++++++++++++++++++++++++++-----
 virt/kvm/mem_protected.c       | 110 ++++++++++++++++++++++
 13 files changed, 311 insertions(+), 28 deletions(-)
 create mode 100644 virt/kvm/Makefile
 create mode 100644 virt/kvm/mem_protected.c

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
index 3b97342af026..3fa76693edcd 100644
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
@@ -3725,6 +3727,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
 		return r;
 
+	if (vcpu->kvm->mem_protected && unlikely(!is_noslot_pfn(pfn))) {
+		if (!kvm_protect_pfn(vcpu->kvm, gfn, pfn)) {
+			unsigned long hva = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+			kvm_send_hwpoison_signal(hva, current);
+			return RET_PF_RETRY;
+		}
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
index fadaccb95a4c..cd2374802702 100644
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
@@ -513,6 +515,10 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+	bool mem_protected;
+	void *id;
+	int nr_shared_ranges;
+	struct range shared_ranges[KVM_NR_SHARED_RANGES];
 };
 
 #define kvm_err(fmt, ...) \
@@ -709,6 +715,16 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
+int kvm_protect_memory(struct kvm *kvm);
+
+void __kvm_share_memory(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_share_memory(struct kvm *kvm, unsigned long gfn, unsigned long npages);
+
+bool kvm_protect_pfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
+void kvm_share_pfn(struct kvm *kvm, kvm_pfn_t pfn);
+
+bool kvm_page_allowed(struct kvm *kvm, struct page *page);
+
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			    struct page **pages, int nr_pages);
 
@@ -718,6 +734,9 @@ unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 				      bool *writable);
+int copy_from_guest(struct kvm *kvm, void *data, unsigned long hva, int len);
+int copy_to_guest(struct kvm *kvm, unsigned long hva, const void *data, int len);
+
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 519a60d5b6f7..5d05129e8b0c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1224,6 +1224,13 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 	trace_mm_page_free(page, order);
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) &&
+	    unlikely(PageHWPoison(page))) {
+		void kvm_unpoison_page(struct page *page);
+
+		kvm_unpoison_page(page);
+	}
+
 	if (unlikely(PageHWPoison(page)) && !order) {
 		/*
 		 * Do not let hwpoison pages hit pcplists/buddy
diff --git a/virt/Makefile b/virt/Makefile
index 1cfea9436af9..a931049086a3 100644
--- a/virt/Makefile
+++ b/virt/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y	+= lib/
+obj-y	+= lib/ kvm/
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1c37ccd5d402..5f28048718f4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -63,3 +63,7 @@ config HAVE_KVM_NO_POLL
 
 config KVM_XFER_TO_GUEST_WORK
        bool
+
+config HAVE_KVM_PROTECTED_MEMORY
+       bool
+       select MEMORY_FAILURE
diff --git a/virt/kvm/Makefile b/virt/kvm/Makefile
new file mode 100644
index 000000000000..f10c62b98968
--- /dev/null
+++ b/virt/kvm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HAVE_KVM_PROTECTED_MEMORY) += mem_protected.o
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e2dbaef7979..9cbd3716b3e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
+#include <linux/rmap.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -741,6 +742,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	struct kvm *kvm = kvm_arch_alloc_vm();
 	int r = -ENOMEM;
 	int i;
+	static long id = 0;
 
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
@@ -803,6 +805,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
+	kvm->id = xa_mk_value(id++);
+	if (id < 0)
+		id = 0;
 	mutex_unlock(&kvm_lock);
 
 	preempt_notifier_inc();
@@ -1852,7 +1857,8 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * The slow path to get the pfn of the specified host virtual address,
  * 1 indicates success, -errno is returned if error is detected.
  */
-static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
+static int hva_to_pfn_slow(struct kvm *kvm, unsigned long addr,
+			   bool *async, bool write_fault,
 			   bool *writable, kvm_pfn_t *pfn)
 {
 	unsigned int flags = FOLL_HWPOISON;
@@ -1868,11 +1874,17 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 		flags |= FOLL_WRITE;
 	if (async)
 		flags |= FOLL_NOWAIT;
+	if (kvm->mem_protected)
+		flags |= FOLL_ALLOW_POISONED;
 
 	npages = get_user_pages_unlocked(addr, 1, &page, flags);
 	if (npages != 1)
 		return npages;
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) &&
+	    kvm->mem_protected && !kvm_page_allowed(kvm, page))
+		return -EHWPOISON;
+
 	/* map read fault as writable if possible */
 	if (unlikely(!write_fault) && writable) {
 		struct page *wpage;
@@ -1961,8 +1973,9 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+static kvm_pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr,
+			    bool atomic, bool *async,
+			    bool write_fault, bool *writable)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -1977,7 +1990,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(kvm, addr, async, write_fault, writable, &pfn);
 	if (npages == 1)
 		return pfn;
 
@@ -2033,8 +2046,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		writable = NULL;
 	}
 
-	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+	return hva_to_pfn(kvm, addr, atomic, async, write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
@@ -2338,19 +2350,93 @@ static int next_segment(unsigned long len, int offset)
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
+		npages = get_user_pages_unlocked(hva, 1, &page,
+						 FOLL_ALLOW_POISONED);
+		if (npages != 1)
+			return -EFAULT;
+
+		if (!kvm_page_allowed(kvm, page))
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
+		npages = get_user_pages_unlocked(hva, 1, &page,
+						 FOLL_WRITE | FOLL_ALLOW_POISONED);
+		if (npages != 1)
+			return -EFAULT;
+
+		if (!kvm_page_allowed(kvm, page))
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
@@ -2358,7 +2444,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -2367,7 +2453,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -2449,7 +2535,8 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	addr = gfn_to_hva_memslot(memslot, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
+
+	r = copy_to_guest(kvm, addr + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
@@ -2586,7 +2673,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_write_guest(kvm, gpa, data, len);
 
-	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
+	r = copy_to_guest(kvm, ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
@@ -2607,7 +2694,6 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				 unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
-	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
 	BUG_ON(len + offset > ghc->len);
@@ -2623,11 +2709,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
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
 
@@ -2693,6 +2775,41 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+int kvm_protect_memory(struct kvm *kvm)
+{
+	if (mmap_write_lock_killable(kvm->mm))
+		return -KVM_EINTR;
+
+	kvm->mem_protected = true;
+	kvm_arch_flush_shadow_all(kvm);
+	mmap_write_unlock(kvm->mm);
+
+	return 0;
+}
+
+int kvm_share_memory(struct kvm *kvm, unsigned long gfn, unsigned long npages)
+{
+	unsigned long end = gfn + npages;
+
+	if (!npages || !IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY))
+		return 0;
+
+	__kvm_share_memory(kvm, gfn, end);
+
+	for (; gfn < end; gfn++) {
+		struct page *page = gfn_to_page(kvm, gfn);
+		unsigned long pfn = page_to_pfn(page);
+
+		if (page == KVM_ERR_PTR_BAD_PAGE)
+			continue;
+
+		kvm_share_pfn(kvm, pfn);
+		put_page(page);
+	}
+
+	return 0;
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->sigset_active)
diff --git a/virt/kvm/mem_protected.c b/virt/kvm/mem_protected.c
new file mode 100644
index 000000000000..81882bd3232b
--- /dev/null
+++ b/virt/kvm/mem_protected.c
@@ -0,0 +1,110 @@
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <linux/rmap.h>
+
+static DEFINE_XARRAY(kvm_pfn_map);
+
+static bool gfn_is_shared(struct kvm *kvm, unsigned long gfn)
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
+bool kvm_protect_pfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+	bool ret = true;
+
+	if (gfn_is_shared(kvm, gfn))
+		return true;
+
+	if (is_zero_pfn(pfn))
+		return true;
+
+	/* Only anonymous and shmem/tmpfs pages are supported */
+	if (!PageSwapBacked(page))
+		return false;
+
+	lock_page(page);
+
+	/* Recheck gfn_is_shared() under page lock */
+	if (gfn_is_shared(kvm, gfn))
+		goto out;
+
+	if (!TestSetPageHWPoison(page)) {
+		try_to_unmap(page, TTU_IGNORE_MLOCK);
+		xa_store(&kvm_pfn_map, pfn, kvm->id, GFP_KERNEL);
+	} else if (xa_load(&kvm_pfn_map, pfn) != kvm->id) {
+		ret = false;
+	}
+out:
+	unlock_page(page);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_protect_pfn);
+
+void __kvm_share_memory(struct kvm *kvm,
+			unsigned long start, unsigned long end)
+{
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
+						kvm->nr_shared_ranges,
+						start, end);
+	kvm->nr_shared_ranges = clean_sort_range(kvm->shared_ranges,
+					    ARRAY_SIZE(kvm->shared_ranges));
+	spin_unlock(&kvm->mmu_lock);
+}
+EXPORT_SYMBOL(__kvm_share_memory);
+
+void kvm_share_pfn(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	lock_page(page);
+	if (xa_load(&kvm_pfn_map, pfn) == kvm->id) {
+		xa_erase(&kvm_pfn_map, pfn);
+		ClearPageHWPoison(page);
+	}
+	unlock_page(page);
+}
+EXPORT_SYMBOL(kvm_share_pfn);
+
+void kvm_unpoison_page(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (xa_erase(&kvm_pfn_map, pfn))
+		ClearPageHWPoison(page);
+}
+
+bool kvm_page_allowed(struct kvm *kvm, struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (!PageHWPoison(page))
+		return true;
+
+	return xa_load(&kvm_pfn_map, pfn) == kvm->id;
+}
-- 
2.26.3

