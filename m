Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797754A547D
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 02:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiBABJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 20:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiBABJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 20:09:00 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADACEC06173D
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:09:00 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id z12-20020a17090a1fcc00b001b63e477f9fso5785423pjz.3
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 17:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4kaP3FlUpQFdehq8pWYdxVNwRbxH7i/N3SsKaNgWUGc=;
        b=h3EL5uywFEwrVZHjm51EZtEEJMlwQaV1z88Z7DeuzixINWb3XSD5/WyLhozYxe4LMx
         sct2ZuwT0YBcjticdqdu3PPzXlEma6RygOCKDK1odDKv0cVT7Kis7SLSnACsVuUx6mcc
         wMBnqr1/FPewELU4IkhgvXGP6E4JeniG02IJsQxq4HBwo4rLuxDQBwTqNvODxXDo4P6G
         yMiN3bsXYAj6ENO8uK9KZ5Q78slE35XhaFJN7NofJ1MP/uY8Q2tfFFOck9Ry8ukeDDIz
         EvY53YPpv4Es1Xf+/BzOl7qEEv6kREOkqoaY8CZ5m0M6ocDkqkBTe2+GFe4lXgtjRjHf
         Sesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4kaP3FlUpQFdehq8pWYdxVNwRbxH7i/N3SsKaNgWUGc=;
        b=ODx79jZl8UDswb85vyzr894keIQtvEhSjEE/7wTNHrBQOToPhextVl9NY65k6fHFfr
         u2iHppL6+yqRqLv7iiauyqNxCkT8Qr3ERCwOKx6uCfgNcVvwGhoZ+ddVhasW/n6IwY8l
         t6KHUi0uwPq4TGwbwMeuL5RpJ+Q+ML6/wTjBBLoCxKgldCHvCX9cyxk0QWSvSIbuceqw
         1JLLytF4nAI1EfzVkEf2HuzQdO2NStFhsxJfarp7D7QKIaOex7ngpD3hlbJL58NI2d7C
         2JMU4ovUrbMo0wN2+aRcXgR4Ljos8ejSWujr7T9sWjf5IEvKjhlfg1D76qjN/KtyKjMF
         Foyw==
X-Gm-Message-State: AOAM532EpXHrFao7XjC8K70hfOYRanIRNBLr6XxNOg292II2YGqI4f80
        bYogjhUG68GSRXHPB6JbkdU4W8okYVE=
X-Google-Smtp-Source: ABdhPJylCV3aOjYEjhVRX1NvX5dqLtIPXCTzy0xsVbRBa2f5cIttpJ71kIFQFrbLJbe3ibfEaVbQypjJEnU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c24d:: with SMTP id
 13mr20607003plg.24.1643677740209; Mon, 31 Jan 2022 17:09:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  1 Feb 2022 01:08:36 +0000
In-Reply-To: <20220201010838.1494405-1-seanjc@google.com>
Message-Id: <20220201010838.1494405-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220201010838.1494405-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 3/5] KVM: x86: Use __try_cmpxchg_user() to update guest PTE
 A/D bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced __try_cmpxchg_user() to update guest PTE A/D
bits instead of mapping the PTE into kernel address space.  The VM_PFNMAP
path is broken as it assumes that vm_pgoff is the base pfn of the mapped
VMA range, which is conceptually wrong as vm_pgoff is the offset relative
to the file and has nothing to do with the pfn.  The horrific hack worked
for the original use case (backing guest memory with /dev/mem), but leads
to accessing "random" pfns for pretty much any other VM_PFNMAP case.

Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
Debugged-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 45 +---------------------------------
 1 file changed, 1 insertion(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5b5bdac97c7b..551de15f342f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -143,49 +143,6 @@ static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
 	       FNAME(is_bad_mt_xwr)(&mmu->guest_rsvd_check, gpte);
 }
 
-static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			       pt_element_t __user *ptep_user, unsigned index,
-			       pt_element_t orig_pte, pt_element_t new_pte)
-{
-	int npages;
-	pt_element_t ret;
-	pt_element_t *table;
-	struct page *page;
-
-	npages = get_user_pages_fast((unsigned long)ptep_user, 1, FOLL_WRITE, &page);
-	if (likely(npages == 1)) {
-		table = kmap_atomic(page);
-		ret = CMPXCHG(&table[index], orig_pte, new_pte);
-		kunmap_atomic(table);
-
-		kvm_release_page_dirty(page);
-	} else {
-		struct vm_area_struct *vma;
-		unsigned long vaddr = (unsigned long)ptep_user & PAGE_MASK;
-		unsigned long pfn;
-		unsigned long paddr;
-
-		mmap_read_lock(current->mm);
-		vma = find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
-		if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
-			mmap_read_unlock(current->mm);
-			return -EFAULT;
-		}
-		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		paddr = pfn << PAGE_SHIFT;
-		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
-		if (!table) {
-			mmap_read_unlock(current->mm);
-			return -EFAULT;
-		}
-		ret = CMPXCHG(&table[index], orig_pte, new_pte);
-		memunmap(table);
-		mmap_read_unlock(current->mm);
-	}
-
-	return (ret != orig_pte);
-}
-
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  u64 gpte)
@@ -284,7 +241,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 		if (unlikely(!walker->pte_writable[level - 1]))
 			continue;
 
-		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
+		ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
 		if (ret)
 			return ret;
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

