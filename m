Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F32B9C92B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfHZGVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39411 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so9935240pgi.6;
        Sun, 25 Aug 2019 23:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G4/GIjjvxQI6MZGovIhdNXi5RGCGvdzZ9iU6E6ba0z4=;
        b=pv6uA8tCkUQu2/nzFDxIxT78ahycnFFOeTFVUFDVPpPWhrs2oCkKw3LXYse67U1uFY
         MaCXWUjxnNYV2+/r8CbKolvnWezc5lA4VIhSMeu0vpBsFwrlCT3lFNbZnJibpV+gTkj8
         Y7s1OFhCxLYomdFTW8pTweBWTWpxIADG3ucY70LtcAyLlAOiMzv5XVodQ8wCGrT9p+UF
         +ypfMFIFhk0fMhjQwj0+3gcLkqg26YMxJLaQgjrwjRHHQ5IveZbVoDd6XAJzSB4X94qa
         Y+FYe/pa26frBL1rKYWSaJVR+curfeylq8eHeHZ/w/UkFHK4EvI64OsKUs09/BONcxdb
         6L3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G4/GIjjvxQI6MZGovIhdNXi5RGCGvdzZ9iU6E6ba0z4=;
        b=qYXIJzczt4Qc2J/d1nnDbzyzhGEJzS/mV3s+mtIwSnp13IwlpGQBpNZ0FnOP/pEiH3
         wwBw7nrXsd/IU55OkGxzXn4Cor+R5EUeRO/elTj3bDiyplCWbsNwUTqi9l6Asq4QCvgr
         ruaPuaVCiq4V8SdVDhHKzLinesvLHmUjdRblfJx721RBdmGbgE6hDSgZj6lU/9qUqzuy
         a7ufnroC+skOYuRdxC4+iqyOqSS+O1Hm1QwiLHeYqL53fTZZ9m3pwaKwZpwfYeJdosAP
         Dg4N4nxwPJdK1hLj2jCKHNa0O2kc8xCYPOEerR3ur9TsfgT5ltvejewR2wVcaef9yd7c
         9VGA==
X-Gm-Message-State: APjAAAXr/nJ/fKtDqAR1hmm3tEbCVomLjlHgGjfrA2LUMzjGHmyLdJf4
        SoLknuf8OGfUR+rOH+r5Fn/aszyxFTQ=
X-Google-Smtp-Source: APXvYqybaO9sjrfaugxybOpcCXMBQkduatZKnmL2LTTR4B2fuAcxwH0ch7R3VSJ0zUvoUw9+3eZweQ==
X-Received: by 2002:a63:e14d:: with SMTP id h13mr14903966pgk.431.1566800478353;
        Sun, 25 Aug 2019 23:21:18 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:17 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org
Subject: [PATCH 01/23] KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault handler
Date:   Mon, 26 Aug 2019 16:20:47 +1000
Message-Id: <20190826062109.7573-2-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Mackerras <paulus@ozlabs.org>

This makes the same changes in the page fault handler for HPT guests
that commits 31c8b0d0694a ("KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot()
in page fault handler", 2018-03-01), 71d29f43b633 ("KVM: PPC: Book3S HV:
Don't use compound_order to determine host mapping size", 2018-09-11)
and 6579804c4317 ("KVM: PPC: Book3S HV: Avoid crash from THP collapse
during radix page fault", 2018-10-04) made for the page fault handler
for radix guests.

In summary, where we used to call get_user_pages_fast() and then do
special handling for VM_PFNMAP vmas, we now call __get_user_pages_fast()
and then __gfn_to_pfn_memslot() if that fails, followed by reading the
Linux PTE to get the host PFN, host page size and mapping attributes.

This also brings in the change from SetPageDirty() to set_page_dirty_lock()
which was done for the radix page fault handler in commit c3856aeb2940
("KVM: PPC: Book3S HV: Fix handling of large pages in radix page fault
handler", 2018-02-23).

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 118 +++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 9a75f0e1933b..a485bb018193 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -497,17 +497,18 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	__be64 *hptep;
 	unsigned long mmu_seq, psize, pte_size;
 	unsigned long gpa_base, gfn_base;
-	unsigned long gpa, gfn, hva, pfn;
+	unsigned long gpa, gfn, hva, pfn, hpa;
 	struct kvm_memory_slot *memslot;
 	unsigned long *rmap;
 	struct revmap_entry *rev;
-	struct page *page, *pages[1];
-	long index, ret, npages;
+	struct page *page;
+	long index, ret;
 	bool is_ci;
-	unsigned int writing, write_ok;
-	struct vm_area_struct *vma;
+	bool writing, write_ok;
+	unsigned int shift;
 	unsigned long rcbits;
 	long mmio_update;
+	pte_t pte, *ptep;
 
 	if (kvm_is_radix(kvm))
 		return kvmppc_book3s_radix_page_fault(run, vcpu, ea, dsisr);
@@ -581,59 +582,62 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	smp_rmb();
 
 	ret = -EFAULT;
-	is_ci = false;
-	pfn = 0;
 	page = NULL;
-	pte_size = PAGE_SIZE;
 	writing = (dsisr & DSISR_ISSTORE) != 0;
 	/* If writing != 0, then the HPTE must allow writing, if we get here */
 	write_ok = writing;
 	hva = gfn_to_hva_memslot(memslot, gfn);
-	npages = get_user_pages_fast(hva, 1, writing ? FOLL_WRITE : 0, pages);
-	if (npages < 1) {
-		/* Check if it's an I/O mapping */
-		down_read(&current->mm->mmap_sem);
-		vma = find_vma(current->mm, hva);
-		if (vma && vma->vm_start <= hva && hva + psize <= vma->vm_end &&
-		    (vma->vm_flags & VM_PFNMAP)) {
-			pfn = vma->vm_pgoff +
-				((hva - vma->vm_start) >> PAGE_SHIFT);
-			pte_size = psize;
-			is_ci = pte_ci(__pte((pgprot_val(vma->vm_page_prot))));
-			write_ok = vma->vm_flags & VM_WRITE;
-		}
-		up_read(&current->mm->mmap_sem);
-		if (!pfn)
-			goto out_put;
+
+	/*
+	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
+	 * do it with !atomic && !async, which is how we call it.
+	 * We always ask for write permission since the common case
+	 * is that the page is writable.
+	 */
+	if (__get_user_pages_fast(hva, 1, 1, &page) == 1) {
+		write_ok = true;
 	} else {
-		page = pages[0];
-		pfn = page_to_pfn(page);
-		if (PageHuge(page)) {
-			page = compound_head(page);
-			pte_size <<= compound_order(page);
-		}
-		/* if the guest wants write access, see if that is OK */
-		if (!writing && hpte_is_writable(r)) {
-			pte_t *ptep, pte;
-			unsigned long flags;
-			/*
-			 * We need to protect against page table destruction
-			 * hugepage split and collapse.
-			 */
-			local_irq_save(flags);
-			ptep = find_current_mm_pte(current->mm->pgd,
-						   hva, NULL, NULL);
-			if (ptep) {
-				pte = kvmppc_read_update_linux_pte(ptep, 1);
-				if (__pte_write(pte))
-					write_ok = 1;
-			}
-			local_irq_restore(flags);
+		/* Call KVM generic code to do the slow-path check */
+		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
+					   writing, &write_ok);
+		if (is_error_noslot_pfn(pfn))
+			return -EFAULT;
+		page = NULL;
+		if (pfn_valid(pfn)) {
+			page = pfn_to_page(pfn);
+			if (PageReserved(page))
+				page = NULL;
 		}
 	}
 
+	/*
+	 * Read the PTE from the process' radix tree and use that
+	 * so we get the shift and attribute bits.
+	 */
+	local_irq_disable();
+	ptep = __find_linux_pte(vcpu->arch.pgdir, hva, NULL, &shift);
+	/*
+	 * If the PTE disappeared temporarily due to a THP
+	 * collapse, just return and let the guest try again.
+	 */
+	if (!ptep) {
+		local_irq_enable();
+		if (page)
+			put_page(page);
+		return RESUME_GUEST;
+	}
+	pte = *ptep;
+	local_irq_enable();
+	hpa = pte_pfn(pte) << PAGE_SHIFT;
+	pte_size = PAGE_SIZE;
+	if (shift)
+		pte_size = 1ul << shift;
+	is_ci = pte_ci(pte);
+
 	if (psize > pte_size)
 		goto out_put;
+	if (pte_size > psize)
+		hpa |= hva & (pte_size - psize);
 
 	/* Check WIMG vs. the actual page we're accessing */
 	if (!hpte_cache_flags_ok(r, is_ci)) {
@@ -647,14 +651,13 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	}
 
 	/*
-	 * Set the HPTE to point to pfn.
-	 * Since the pfn is at PAGE_SIZE granularity, make sure we
+	 * Set the HPTE to point to hpa.
+	 * Since the hpa is at PAGE_SIZE granularity, make sure we
 	 * don't mask out lower-order bits if psize < PAGE_SIZE.
 	 */
 	if (psize < PAGE_SIZE)
 		psize = PAGE_SIZE;
-	r = (r & HPTE_R_KEY_HI) | (r & ~(HPTE_R_PP0 - psize)) |
-					((pfn << PAGE_SHIFT) & ~(psize - 1));
+	r = (r & HPTE_R_KEY_HI) | (r & ~(HPTE_R_PP0 - psize)) | hpa;
 	if (hpte_is_writable(r) && !write_ok)
 		r = hpte_make_readonly(r);
 	ret = RESUME_GUEST;
@@ -719,20 +722,13 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	asm volatile("ptesync" : : : "memory");
 	preempt_enable();
 	if (page && hpte_is_writable(r))
-		SetPageDirty(page);
+		set_page_dirty_lock(page);
 
  out_put:
 	trace_kvm_page_fault_exit(vcpu, hpte, ret);
 
-	if (page) {
-		/*
-		 * We drop pages[0] here, not page because page might
-		 * have been set to the head page of a compound, but
-		 * we have to drop the reference on the correct tail
-		 * page to match the get inside gup()
-		 */
-		put_page(pages[0]);
-	}
+	if (page)
+		put_page(page);
 	return ret;
 
  out_unlock:
-- 
2.13.6

