Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A642934C3
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403952AbgJTGTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403895AbgJTGTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:14 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C825C0613D1
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:14 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m20so746980ljj.5
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P1ZYdJ+48hESkuHQ/ZsaZHpWMaHGaWqk6TiKgGiH9uk=;
        b=d2jXg+GKr/U9ky+di6Pjj65rEOr97pO3dwozUnliTUnv1Qv9Q2TuAgC8IEHLG/EQuw
         DKuDYgSdeHQq8jTcfxrBKvbvkxwxjRrJq52cWR0Ir5bIH8OSpPK5LJmwPA7McOQwyCzV
         NDh+ERmP7yjlgXPEJgE/9Feow0m/be5I7IM+IsuJCjiMYomnibh63f9Yxm1vQafnbBAZ
         BcjvCzWRgWWr+i2/FDzXt0Mh46L9UL9hcL2QLTqh7wNOk6YCuKFryCJfrne2iiMTwj7u
         feCZU1reswc+eprlM23CpudlU/4fEiqdOYZSNVIh9qV2uyktYuq6LDH4AvTI1bQwcB40
         e4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P1ZYdJ+48hESkuHQ/ZsaZHpWMaHGaWqk6TiKgGiH9uk=;
        b=fOUG5zvE3zaUJHV2dDAKddpQ9ij9zAEBlxd+JcfXfE6XgI1ZMVbLwwLkJlHCHsYCGH
         acCjzZJGa0eapzn+uN9YtegSMCtEfc+GInAsXY/c7Y9OvhJr99bh+qCVmbnBaKc/VoNQ
         u/R5Y56lYmAerY7vEZ5ZOSXkayjBVs7hOgzRNLtP8VLpqNw5u+ivZQE8XxO8w+pwbh7D
         iOFEdBtmyuXTFbdfGrVf2N37Cy0mgWdRW957bjoIerJqwJdfeXQVM+yixm8joNDIqR7N
         q9ay50lW5Qrjt+Icqfsj6T9IjJM7WQ9fKHnAnY58C+BV8r6aX1mA9wKtOCmrnra9L+9i
         CBNA==
X-Gm-Message-State: AOAM533Kw4Ry/06WnulH2sNUZsqcSODh28Clayn2zL3zqVW0X8dhibG9
        VTvlOApkglxOoD7l1U5WwgF5PA==
X-Google-Smtp-Source: ABdhPJx4OTPXoR7QAQvHaAogNS+nSnlzEId+sAo8GQE1S8lBt0CtaocrLea19BD5ZB7UVB4nJWmOzw==
X-Received: by 2002:a2e:b5d7:: with SMTP id g23mr535144ljn.61.1603174752853;
        Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id a7sm139248lfl.2.2020.10.19.23.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 3C9F0102F6F; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 16/16] mm: Do not use zero page for VM_KVM_PROTECTED VMAs
Date:   Tue, 20 Oct 2020 09:18:59 +0300
Message-Id: <20201020061859.18385-17-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presence of zero pages in the mapping would disclose content of the
mapping. Don't use them if KVM memory protection is enabled.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/s390/include/asm/pgtable.h | 2 +-
 include/linux/mm.h              | 4 ++--
 mm/huge_memory.c                | 3 +--
 mm/memory.c                     | 3 +--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b55561cc8786..72ca3b3f04cb 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -543,7 +543,7 @@ static inline int mm_alloc_pgste(struct mm_struct *mm)
  * In the case that a guest uses storage keys
  * faults should no longer be backed by zero pages
  */
-#define mm_forbids_zeropage mm_has_pgste
+#define vma_forbids_zeropage(vma) mm_has_pgste(vma->vm_mm)
 static inline int mm_uses_skeys(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 74efc51e63f0..ee713b7c2819 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -130,8 +130,8 @@ extern int mmap_rnd_compat_bits __read_mostly;
  * s390 does this to prevent multiplexing of hardware bits
  * related to the physical page in case of virtualization.
  */
-#ifndef mm_forbids_zeropage
-#define mm_forbids_zeropage(X)	(0)
+#ifndef vma_forbids_zeropage
+#define vma_forbids_zeropage(vma) vma_is_kvm_protected(vma)
 #endif
 
 /*
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40974656cb43..383614b24c4f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -709,8 +709,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 		return VM_FAULT_OOM;
-	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
-			!mm_forbids_zeropage(vma->vm_mm) &&
+	if (!(vmf->flags & FAULT_FLAG_WRITE) && !vma_forbids_zeropage(vma) &&
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
 		struct page *zero_page;
diff --git a/mm/memory.c b/mm/memory.c
index e28bd5f902a7..9907ffe00490 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3495,8 +3495,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 		return 0;
 
 	/* Use the zero-page for reads */
-	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
-			!mm_forbids_zeropage(vma->vm_mm)) {
+	if (!(vmf->flags & FAULT_FLAG_WRITE) && !vma_forbids_zeropage(vma)) {
 		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
 						vma->vm_page_prot));
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-- 
2.26.2

