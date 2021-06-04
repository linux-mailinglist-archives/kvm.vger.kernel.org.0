Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0553539BAEB
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFDObr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 10:31:47 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:39783 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFDObr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 10:31:47 -0400
Received: by mail-lj1-f178.google.com with SMTP id c11so11811875ljd.6
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pCVIi+nZZxe8ZlGb7I4OC8njN4h/VVm5Y+yB3/IfyTY=;
        b=mECmWYzqpTySZQH2wkJqMIcmn7LfTexE4j7Pnh/TsKf9bK7kqLD8Nygupkg9vC1PRD
         f7cGVXK8JOAhOJ5PVXkkzN9KnNUYAjNjAY1Fu7L7AmTzD0SkF6clA1gzmTQ0LXn49gkx
         ZGBETftbNT0BteVgRar5B1jjLfGUrR9+knrQNRpM/mqrCtfOcbcxJArFwo228YFYPfWC
         M3IItISx9mUuG+kIgTlR3kO8oJdnUjsDHBTuMQk9IdQYSMmZYtm/nj2ly7BtbocFRfwk
         nj3PvHU9nQeai5n+2PgyZEnVhcNdF+peC9sQ7qsEaWp2PYR4omyFa0RcBh+tlyr8RsXa
         HlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pCVIi+nZZxe8ZlGb7I4OC8njN4h/VVm5Y+yB3/IfyTY=;
        b=NOii9dxcvLdsrdqzvSvuLY/sHhJq+DEXNx8IJV9+jQmcgA/kw1txvlFvIzqCW0cDyt
         CUGSdFuHNAjRjREkbx3Ur4NgmbNNRgF+/gC5B+HnkTBLR3jV2iw9N3qPAfTYlzRQ2bzh
         uX2FVLMr+lsQd+YhPJ/b7cpn67yIKvXN5Ves3/jtMokAepO9QNZw/vxnPqjF+PeBWRJy
         rq7Oewitv+Et0ie+zpAWqMkMHmGIJUdu4KuZyCAl/YEJcSDvd7Q3PRaW5YKXU1XF/3Pm
         Jz/jHS9VKge4G1eFYl6Q7sLABW58Aroi/2H8h3M3BfTena180yMM9u+HzBT8vW42SMwp
         FaDA==
X-Gm-Message-State: AOAM533owIhKQlnpUejTsIBuctbb/yshDMtm/Q3wwh9D2cjnrt+agO1j
        rz7eh6hUAm8uAXIVJwIjPJqE8A==
X-Google-Smtp-Source: ABdhPJze2U6fVG84J+l655keZISi8YYSxYUcal139okOmnVe75lfp7wt2w4m44eMDXc5ufSKvksw1g==
X-Received: by 2002:a2e:8715:: with SMTP id m21mr3765506lji.170.1622816940038;
        Fri, 04 Jun 2021 07:29:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id l7sm239126ljc.28.2021.06.04.07.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 07:28:59 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 20BF81027A9; Fri,  4 Jun 2021 17:29:11 +0300 (+03)
Date:   Fri, 4 Jun 2021 17:29:11 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <20210604142911.vbbucf4ten7e5khf@box>
References: <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
 <YK6lrHeaeUZvHMJC@google.com>
 <20210531200712.qjxghakcaj4s6ara@box.shutemov.name>
 <YLfFBgPeWZ91TfH7@google.com>
 <20210602233353.gxq35yxluhas5knp@box>
 <YLkxrMQ2a5aWD5zt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLkxrMQ2a5aWD5zt@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 07:46:52PM +0000, Sean Christopherson wrote:
> In other words, I would expect the code to look something ike:
> 
> 	if (PageGuest()) {
> 		if (!(flags & FOLL_GUEST)) {
> 			pte_unmap_unlock(ptep, ptl);
> 			return NULL;
> 		}
> 	} else if ((flags & FOLL_NUMA) && pte_protnone(pte)) {
> 		goto no_page;
> 	}

Okay, looks good. Updated patch is below. I fixed few more bugs.

The branch is also updated and rebased to v5.12.

> Yeah, and I'm saying we should explicitly disallow mapping PageGuest() into
> shared memory, and then the KVM code that manually kmaps() PageGuest() memory
> to avoid copy_{to,from}_user() failure goes aways.

Manual kmap thing is not needed for TDX: it only required for pure KVM
where we handle instruction emulation in the host.

------------------------------8<------------------------------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 16 Apr 2021 01:30:48 +0300
Subject: [PATCH] mm: Introduce guest-only pages

PageGuest() pages are only allowed to be used as guest memory. Userspace
is not allowed read from or write to such pages.

On page fault, PageGuest() pages produce PROT_NONE page table entries.
Read or write there will trigger SIGBUS. Access to such pages via
syscall leads to -EIO.

The new mprotect(2) flag PROT_GUEST translates to VM_GUEST. Any page
fault to VM_GUEST VMA produces PageGuest() page.

Only shared tmpfs/shmem mappings are supported.

GUP normally fails on such pages. KVM will use the new FOLL_GUEST flag
to access them.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h                     |  5 ++-
 include/linux/mman.h                   |  7 +++-
 include/linux/page-flags.h             |  8 ++++
 include/uapi/asm-generic/mman-common.h |  1 +
 mm/gup.c                               | 36 ++++++++++++++----
 mm/huge_memory.c                       | 51 +++++++++++++++++++-------
 mm/memory.c                            | 28 ++++++++++----
 mm/mprotect.c                          | 18 ++++++++-
 mm/shmem.c                             | 12 ++++++
 9 files changed, 133 insertions(+), 33 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8ba434287387..8e679f4d0f21 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -362,6 +362,8 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_GROWSUP	VM_NONE
 #endif
 
+#define VM_GUEST	VM_HIGH_ARCH_4
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
 
@@ -413,7 +415,7 @@ extern unsigned int kobjsize(const void *objp);
 #ifndef VM_ARCH_CLEAR
 # define VM_ARCH_CLEAR	VM_NONE
 #endif
-#define VM_FLAGS_CLEAR	(ARCH_VM_PKEY_FLAGS | VM_ARCH_CLEAR)
+#define VM_FLAGS_CLEAR	(ARCH_VM_PKEY_FLAGS | VM_GUEST | VM_ARCH_CLEAR)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
@@ -2793,6 +2795,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_GUEST	0x100000 /* allow access to guest-only pages */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/include/linux/mman.h b/include/linux/mman.h
index 629cefc4ecba..204e03d7787c 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -103,7 +103,9 @@ static inline void vm_unacct_memory(long pages)
  */
 static inline bool arch_validate_prot(unsigned long prot, unsigned long addr)
 {
-	return (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM)) == 0;
+	int allowed;
+	allowed = PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM | PROT_GUEST;
+	return (prot & ~allowed) == 0;
 }
 #define arch_validate_prot arch_validate_prot
 #endif
@@ -140,7 +142,8 @@ calc_vm_prot_bits(unsigned long prot, unsigned long pkey)
 {
 	return _calc_vm_trans(prot, PROT_READ,  VM_READ ) |
 	       _calc_vm_trans(prot, PROT_WRITE, VM_WRITE) |
-	       _calc_vm_trans(prot, PROT_EXEC,  VM_EXEC) |
+	       _calc_vm_trans(prot, PROT_EXEC,  VM_EXEC ) |
+	       _calc_vm_trans(prot, PROT_GUEST, VM_GUEST) |
 	       arch_calc_vm_prot_bits(prot, pkey);
 }
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 04a34c08e0a6..4bac0371f5c9 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -436,6 +436,14 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_HAVE_KVM_PROTECTED_MEMORY)
+PAGEFLAG(Guest, arch_2, PF_HEAD)
+TESTSCFLAG(Guest, arch_2, PF_HEAD)
+#else
+PAGEFLAG_FALSE(Guest)
+TESTSCFLAG_FALSE(Guest)
+#endif
+
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
 TESTPAGEFLAG(Young, young, PF_ANY)
 SETPAGEFLAG(Young, young, PF_ANY)
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index f94f65d429be..c4d985d22b49 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -16,6 +16,7 @@
 #define PROT_NONE	0x0		/* page can not be accessed */
 #define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
 #define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
+#define PROT_GUEST	0x04000000	/* KVM guest memory */
 
 /* 0x01 - 0x03 are defined in linux/mman.h */
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
diff --git a/mm/gup.c b/mm/gup.c
index ef7d2da9f03f..2d2d57f70e1f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -356,10 +356,22 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
  * FOLL_FORCE can write to even unwritable pte's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
+static inline bool can_follow_write_pte(struct vm_area_struct *vma,
+					pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+	if (pte_write(pte))
+		return true;
+
+	if ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte))
+		return true;
+
+	if (!(flags & FOLL_GUEST))
+		return false;
+
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) != (VM_WRITE | VM_SHARED))
+		return false;
+
+	return PageGuest(pte_page(pte));
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -400,14 +412,20 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		migration_entry_wait(mm, pmd, address);
 		goto retry;
 	}
-	if ((flags & FOLL_NUMA) && pte_protnone(pte))
+
+	page = vm_normal_page(vma, address, pte);
+	if (page && PageGuest(page)) {
+		if (!(flags & FOLL_GUEST))
+			goto no_page;
+	} else if ((flags & FOLL_NUMA) && pte_protnone(pte)) {
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
+	}
+
+	if ((flags & FOLL_WRITE) && !can_follow_write_pte(vma, pte, flags)) {
 		pte_unmap_unlock(ptep, ptl);
 		return NULL;
 	}
 
-	page = vm_normal_page(vma, address, pte);
 	if (!page && pte_devmap(pte) && (flags & (FOLL_GET | FOLL_PIN))) {
 		/*
 		 * Only return device mapping pages in the FOLL_GET or FOLL_PIN
@@ -571,8 +589,12 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (likely(!pmd_trans_huge(pmdval)))
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
 
-	if ((flags & FOLL_NUMA) && pmd_protnone(pmdval))
+	if (PageGuest(pmd_page(pmdval))) {
+	    if (!(flags & FOLL_GUEST))
+		    return no_page_table(vma, flags);
+	}  else if ((flags & FOLL_NUMA) && pmd_protnone(pmdval)) {
 		return no_page_table(vma, flags);
+	}
 
 retry_locked:
 	ptl = pmd_lock(mm, pmd);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ae907a9c2050..c430a52a3b7f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1336,10 +1336,22 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
  * FOLL_FORCE can write to even unwritable pmd's, but only
  * after we've gone through a COW cycle and they are dirty.
  */
-static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+static inline bool can_follow_write_pmd(struct vm_area_struct *vma,
+					pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	if (pmd_write(pmd))
+		return true;
+
+	if ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd))
+		return true;
+
+	if (!(flags & FOLL_GUEST))
+		return false;
+
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) != (VM_WRITE | VM_SHARED))
+		return false;
+
+	return PageGuest(pmd_page(pmd));
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
@@ -1352,20 +1364,30 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
-		goto out;
+	if (!pmd_present(*pmd))
+		return NULL;
+
+	page = pmd_page(*pmd);
+	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
+
+	if (PageGuest(page)) {
+		if (!(flags & FOLL_GUEST))
+			return NULL;
+	} else if ((flags & FOLL_NUMA) && pmd_protnone(*pmd)) {
+		/*
+		 * Full NUMA hinting faults to serialise migration in fault
+		 * paths
+		 */
+		return NULL;
+	}
+
+	if (flags & FOLL_WRITE && !can_follow_write_pmd(vma, *pmd, flags))
+		return NULL;
 
 	/* Avoid dumping huge zero page */
 	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(*pmd))
 		return ERR_PTR(-EFAULT);
 
-	/* Full NUMA hinting faults to serialise migration in fault paths */
-	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
-		goto out;
-
-	page = pmd_page(*pmd);
-	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
-
 	if (!try_grab_page(page, flags))
 		return ERR_PTR(-ENOMEM);
 
@@ -1408,7 +1430,6 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
 
-out:
 	return page;
 }
 
@@ -1426,6 +1447,10 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t pmd)
 	bool was_writable;
 	int flags = 0;
 
+	page = pmd_page(pmd);
+	if (PageGuest(page))
+		return VM_FAULT_SIGBUS;
+
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(pmd, *vmf->pmd)))
 		goto out_unlock;
diff --git a/mm/memory.c b/mm/memory.c
index 550405fc3b5e..d588220feabf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3703,9 +3703,13 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		flush_icache_page(vma, page + i);
 
-	entry = mk_huge_pmd(page, vma->vm_page_prot);
-	if (write)
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	if (PageGuest(page)) {
+		entry = mk_huge_pmd(page, PAGE_NONE);
+	} else {
+		entry = mk_huge_pmd(page, vma->vm_page_prot);
+		if (write)
+			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	}
 
 	add_mm_counter(vma->vm_mm, mm_counter_file(page), HPAGE_PMD_NR);
 	page_add_file_rmap(page, true);
@@ -3741,13 +3745,17 @@ void do_set_pte(struct vm_fault *vmf, struct page *page, unsigned long addr)
 	pte_t entry;
 
 	flush_icache_page(vma, page);
-	entry = mk_pte(page, vma->vm_page_prot);
+	if (PageGuest(page)) {
+		entry = mk_pte(page, PAGE_NONE);
+	} else {
+		entry = mk_pte(page, vma->vm_page_prot);
 
-	if (prefault && arch_wants_old_prefaulted_pte())
-		entry = pte_mkold(entry);
+		if (prefault && arch_wants_old_prefaulted_pte())
+			entry = pte_mkold(entry);
 
-	if (write)
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		if (write)
+			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	}
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
@@ -4105,6 +4113,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
 
+	page = pte_page(vmf->orig_pte);
+	if (PageGuest(page))
+		return VM_FAULT_SIGBUS;
+
 	/*
 	 * The "pte" at this point cannot be used safely without
 	 * validation through pte_unmap_same(). It's of NUMA type but
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 94188df1ee55..aecba46af544 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -484,8 +484,12 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	dirty_accountable = vma_wants_writenotify(vma, vma->vm_page_prot);
 	vma_set_page_prot(vma);
 
-	change_protection(vma, start, end, vma->vm_page_prot,
-			  dirty_accountable ? MM_CP_DIRTY_ACCT : 0);
+	if (vma->vm_flags & VM_GUEST) {
+		zap_page_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	} else {
+		change_protection(vma, start, end, vma->vm_page_prot,
+				  dirty_accountable ? MM_CP_DIRTY_ACCT : 0);
+	}
 
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
@@ -603,6 +607,16 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			goto out;
 		}
 
+		if ((newflags & (VM_GUEST|VM_SHARED)) == VM_GUEST) {
+			error = -EINVAL;
+			goto out;
+		}
+
+		if ((newflags & VM_GUEST) && !vma_is_shmem(vma)) {
+			error = -EINVAL;
+			goto out;
+		}
+
 		/* Allow architectures to sanity-check the new flags */
 		if (!arch_validate_flags(newflags)) {
 			error = -EINVAL;
diff --git a/mm/shmem.c b/mm/shmem.c
index b2db4ed0fbc7..0f44f2fac06c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1835,6 +1835,11 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	if (page && sgp == SGP_WRITE)
 		mark_page_accessed(page);
 
+	if (page && PageGuest(page) && sgp != SGP_CACHE) {
+		error = -EIO;
+		goto unlock;
+	}
+
 	/* fallocated page? */
 	if (page && !PageUptodate(page)) {
 		if (sgp != SGP_READ)
@@ -2117,6 +2122,13 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 				  gfp, vma, vmf, &ret);
 	if (err)
 		return vmf_error(err);
+
+	if ((vmf->vma->vm_flags & VM_GUEST) && !TestSetPageGuest(vmf->page)) {
+		struct page *head = compound_head(vmf->page);
+		try_to_unmap(head, TTU_IGNORE_MLOCK);
+		set_page_dirty(head);
+	}
+
 	return ret;
 }
 
-- 
 Kirill A. Shutemov
