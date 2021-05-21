Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128FF38C68E
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 14:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhEUMdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 08:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUMdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 08:33:11 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6D3C061574
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 05:31:47 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b26so13406270lfq.4
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 05:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oCuR4pKqgiqiCfe5TxlaYBl+X1o7TTKu0eZOPaOxVwE=;
        b=rrgcHInWWfZIXci1QoMZH3excj2FaKwGIBlSH9oc03PTN3srqzXlWdYtk1IiczQkkv
         iattWaRJU4+QO5SZr86OkMPIRiWMliVKgpMQ2rxMK8r82rjFSeeNyJDjU+XefvpDflof
         AIraUYGj6AaBi7/AFsFiHyPhY3jcuAV8rgNqB9zVXS3yXqIcgtPEoIfxLNM+IqXf81Uu
         gqlQOIuhh1OGfMvmdhFx99oNPvFIYopigoFU4TPB46Os/RW0P9AhUCfHfErsiOl5rnrK
         zIs0brjJSeIpf9SWEU/IfB3Cc4UcPPkDtZ5roxNnXj/fj0AWuXSCnSvfP/l2o4g4U+B3
         sUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oCuR4pKqgiqiCfe5TxlaYBl+X1o7TTKu0eZOPaOxVwE=;
        b=M5ETMCV+E0LoZT/fX1PDKiuoeht5a5EiCRznzl6Fop6DhnPKWneizA+/CSzFUX2Hj6
         P12shz9Bn/B+ihVXdkiV9KCq4KhBoKEJO7aqWDQ8G+VAdNSJqiowXLw8ty/23kADdOaZ
         tc8kOdMO+IX/hcUL14ghlxBMrkgit20JMbZ3Lu0ix5FM3hqs9/JUiPWHNPVzKBnRgagz
         pWFjjd9p8pvjOanG73gIDthKRLidiJTEdQcslA+eQx3MwxoSL4NNZp4kC4g5prwFIpqB
         wUsenJaQ5+yIxcTnUIydAjczGDyT7kQWCFXgNh4O+b44KtnmxLhAL0WfsGqpRkBLUTCX
         KrTw==
X-Gm-Message-State: AOAM530GIa1/L/BV3rgw63NwJEMBeZ8HTvWqjB48bHCbxIsSoLQDRnHs
        kTlG+rCb3WK5W6HCM5aCKLwxlw==
X-Google-Smtp-Source: ABdhPJzaOPUFhCdEgGpR/4+pL+G+i0RKGl6GPBoHsjCP2zzgWd/90XsXSUN8t+otAaxYe7iUskdtYw==
X-Received: by 2002:a05:6512:388f:: with SMTP id n15mr2241572lft.280.1621600306262;
        Fri, 21 May 2021 05:31:46 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id d13sm654793lfs.100.2021.05.21.05.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 05:31:45 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 79182102762; Fri, 21 May 2021 15:31:48 +0300 (+03)
Date:   Fri, 21 May 2021 15:31:48 +0300
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
Message-ID: <20210521123148.a3t4uh4iezm6ax47@box>
References: <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="djrck6lxjzjvdkya"
Content-Disposition: inline
In-Reply-To: <YH8L0ihIzL6UB6qD@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--djrck6lxjzjvdkya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sean,

The core patch of the approach we've discussed before is below. It
introduce a new page type with the required semantics.

The full patchset can be found here:

 git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-guest-only

but only the patch below is relevant for TDX. QEMU patch is attached.

CONFIG_HAVE_KVM_PROTECTED_MEMORY has to be changed to what is appropriate
for TDX and FOLL_GUEST has to be used in hva_to_pfn_slow() when running
TDX guest.

When page get inserted into private sept we must make sure it is
PageGuest() or SIGBUS otherwise. Inserting PageGuest() into shared is
fine, but the page will not be accessible from userspace.

Any feedback is welcome.

-------------------------------8<-------------------------------------------

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
 include/linux/mm.h                     |  5 +++-
 include/linux/mman.h                   |  7 ++++--
 include/linux/page-flags.h             |  8 +++++++
 include/uapi/asm-generic/mman-common.h |  1 +
 mm/gup.c                               | 33 +++++++++++++++++++++-----
 mm/huge_memory.c                       | 24 +++++++++++++++----
 mm/memory.c                            | 26 ++++++++++++++------
 mm/mprotect.c                          | 18 ++++++++++++--
 mm/shmem.c                             | 13 ++++++++++
 9 files changed, 113 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecdf8a8cd6ae..f8024061cece 100644
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
@@ -2802,6 +2804,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
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
index ec5d0290e0ee..f963b96711f5 100644
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
index e4c224cd9661..d581ddb900e5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -357,10 +357,22 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
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
@@ -401,9 +413,18 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		migration_entry_wait(mm, pmd, address);
 		goto retry;
 	}
-	if ((flags & FOLL_NUMA) && pte_protnone(pte))
-		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
+
+	if (pte_protnone(pte)) {
+		if (flags & FOLL_GUEST) {
+			page = pte_page(pte);
+			if (!PageGuest(page))
+				goto no_page;
+		} else if (flags & FOLL_NUMA) {
+		    goto no_page;
+		}
+	}
+
+	if ((flags & FOLL_WRITE) && !can_follow_write_pte(vma, pte, flags)) {
 		pte_unmap_unlock(ptep, ptl);
 		return NULL;
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 91ca9b103ee5..9cd400a44f94 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1335,10 +1335,22 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
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
@@ -1351,7 +1363,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
+	if (flags & FOLL_WRITE && !can_follow_write_pmd(vma, *pmd, flags))
 		goto out;
 
 	/* Avoid dumping huge zero page */
@@ -1425,6 +1437,10 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t pmd)
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
index feff48e1465a..590fb43f8296 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3751,9 +3751,13 @@ static vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
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
@@ -3823,10 +3827,14 @@ vm_fault_t alloc_set_pte(struct vm_fault *vmf, struct page *page)
 	}
 
 	flush_icache_page(vma, page);
-	entry = mk_pte(page, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
-	if (write)
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (PageGuest(page)) {
+		entry = mk_pte(page, PAGE_NONE);
+	} else {
+		entry = mk_pte(page, vma->vm_page_prot);
+		entry = pte_sw_mkyoung(entry);
+		if (write)
+			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	}
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
@@ -4185,6 +4193,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
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
index ab709023e9aa..113be3c9ce08 100644
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
index 7c6b6d8f6c39..75bb56cf78a0 100644
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
@@ -2115,6 +2120,14 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 				  gfp, vma, vmf, &ret);
 	if (err)
 		return vmf_error(err);
+
+	if (vmf->vma->vm_flags & VM_GUEST) {
+		if (!TestSetPageGuest(vmf->page)) {
+			try_to_unmap(compound_head(vmf->page),
+				     TTU_IGNORE_MLOCK);
+		}
+	}
+
 	return ret;
 }
 
-- 
 Kirill A. Shutemov

--djrck6lxjzjvdkya
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="qemu.patch"

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b6d9f92f1513..f93a152f95ee 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2425,6 +2425,85 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
+#define KVM_HC_ENABLE_MEM_PROTECTED 12
+#define KVM_HC_MEM_SHARE            13
+
+#define PROT_GUEST	0x04000000
+
+static int kvm_protect_memory(void)
+{
+    KVMState *kvm = kvm_state;
+    KVMSlot *slot = NULL;
+    int i;
+
+    for (i = 0; i < kvm->nr_slots; i++, slot = NULL) {
+        slot = &kvm->as[0].ml->slots[i];
+        if (!slot->memory_size)
+            continue;
+
+        if (mprotect(slot->ram, slot->memory_size,
+                 PROT_GUEST | PROT_READ | PROT_WRITE)) {
+            perror("mprotect");
+            return -1;
+        }
+    }
+
+    return 0;
+}
+
+static int kvm_share_memory(hwaddr start, hwaddr size)
+{
+    KVMState *kvm = kvm_state;
+    KVMSlot *slot = NULL;
+    int i;
+    void *p;
+
+    for (i = 0; i < kvm->nr_slots; i++, slot = NULL) {
+        slot = &kvm->as[0].ml->slots[i];
+        if (!slot->memory_size)
+            continue;
+
+        if (start >= slot->start_addr &&
+            start < slot->start_addr + slot->memory_size)
+            break;
+    }
+
+    if (!slot)
+        return -1;
+
+    /* XXX: Share range across memory slots? */
+    if (start + size > slot->start_addr + slot->memory_size)
+        return -1;
+
+    p = mmap(slot->ram + (start - slot->start_addr), size,
+             PROT_READ | PROT_WRITE,
+             MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+
+    if (p == MAP_FAILED) {
+        printf("mmap failed\n");
+        return -1;
+    }
+
+    return 0;
+}
+
+static int kvm_handle_hypercall(CPUState *cpu, struct kvm_run *run)
+{
+
+    switch (run->hypercall.nr) {
+    case KVM_HC_ENABLE_MEM_PROTECTED:
+        return kvm_protect_memory();
+    case KVM_HC_MEM_SHARE:
+        return kvm_share_memory(run->hypercall.args[0] << 12,
+                                run->hypercall.args[1] << 12);
+    default:
+        fprintf(stderr, "KVM: unexpected hypercall %lld\n", run->hypercall.nr);
+        return -1;
+    }
+
+    return 0;
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run = cpu->kvm_run;
@@ -2561,6 +2640,9 @@ int kvm_cpu_exec(CPUState *cpu)
                 break;
             }
             break;
+        case KVM_EXIT_HYPERCALL:
+            ret = kvm_handle_hypercall(cpu, run);
+            break;
         default:
             DPRINTF("kvm_arch_handle_exit\n");
             ret = kvm_arch_handle_exit(cpu, run);
diff --git a/softmmu/memory.c b/softmmu/memory.c
index d4493ef9e430..fed346f84a67 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1533,7 +1533,7 @@ void memory_region_init_ram_nomigrate(MemoryRegion *mr,
                                       uint64_t size,
                                       Error **errp)
 {
-    memory_region_init_ram_shared_nomigrate(mr, owner, name, size, false, errp);
+    memory_region_init_ram_shared_nomigrate(mr, owner, name, size, true, errp);
 }
 
 void memory_region_init_ram_shared_nomigrate(MemoryRegion *mr,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ad99cad0e7ce..5e486f3e7482 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -804,7 +804,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
             "kvm-poll-control", "kvm-pv-sched-yield", "kvm-asyncpf-int", "kvm-msi-ext-dest-id",
-            NULL, NULL, NULL, NULL,
+            "kvm-mem-protected", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,

--djrck6lxjzjvdkya--
