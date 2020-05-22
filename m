Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1CA1DE734
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgEVMwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729955AbgEVMw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:28 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA39C02A19D
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m12so10088399ljc.6
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iuw1xkRjcXmsK4stEeuiGW4w7Bgw3ocR3EwBbivjZB8=;
        b=nAvZfwpo2XufBEG9O4I+bP/QA3rUDiglZWAfRAUbbmxFJHVM7MjJX6jw9D+v83wIEh
         bLAe30hWjHZbCfPlen5i0Pk/uCZMnaHGf+QEwyDoeKzBvpuREkRedR6H+OFtWMTQ9B1A
         V0TJrPi4cZ8U+PtvIXGZ0+HBjbkEp5kHOmiNTiI4Z4ed72WscM9psLvvGE7W4WJZy1t9
         AAGCxTd5v19W2bwiyUOA3qjxhuuygCbECxupUCzA4tTRbc0DEx33sLJ1UrDrpBoXbCpa
         7wl1kPLvtGIQPMjEhtvLJn57b7mKbvxjyERMnAY8TmQ6cKzezAJWQSNWeN0WzBFY62q8
         zoFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iuw1xkRjcXmsK4stEeuiGW4w7Bgw3ocR3EwBbivjZB8=;
        b=sASCnf1HvflHnmfAtesncDAf7jkkIr1EuW+oRR3bTy6K+KUT7vEt7c1IySFeJjJhf/
         fQGNM/VnEqd+9uHv3r7F3Z7DfxlppXn2+UDQpPJuLnwffntDVYo9t1z6LxlimlMiw2gX
         JKo3SQZHBGeb2L1O0Wh1MkBu9QrQaBQjwD9u5FRGwIynAA5etJHO873yCkQv5N6wJswD
         s9n7mrERQ6NZL1hI7bRa4YJAbHdElg7HtaDsE22VMGiKkbfdUDJIy5m8TfTAlJNEqoCr
         CU60ZKJhBbEW5a6H6H7K+zFdbfu1CfvimMXOAGqtZv0pCtq+KXTOoxESwhN6LHdy0xxm
         +P9g==
X-Gm-Message-State: AOAM532hFED/k4uXPVmwskuAlr3eRDhhY2R6CVMNh68JZ2lPdmTNOOme
        K5joYkkO8P3hg7a8mcsfJdh49Q==
X-Google-Smtp-Source: ABdhPJwqihqvAsOaLlmGwWVOsCLhtqXYamXtJyWkA59wywoSZ5SCKVLtje40pqAx/jhBiNJOmWuLpg==
X-Received: by 2002:a2e:7a02:: with SMTP id v2mr5172371ljc.374.1590151946210;
        Fri, 22 May 2020 05:52:26 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j10sm2312515ljc.21.2020.05.22.05.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 1206D10205C; Fri, 22 May 2020 15:52:20 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 14/16] KVM: Introduce gfn_to_pfn_memslot_protected()
Date:   Fri, 22 May 2020 15:52:12 +0300
Message-Id: <20200522125214.31348-15-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new interface allows to detect if the page is protected.
A protected page cannot be accessed directly by the host: it has to be
mapped manually.

This is preparation for the next patch.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 |  6 +++--
 include/linux/kvm_host.h               |  2 +-
 virt/kvm/kvm_main.c                    | 35 ++++++++++++++++++--------
 5 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 2b35f9bcf892..e9a13ecf812f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -587,7 +587,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok);
+					   writing, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index aa12cd4078b3..58f8df466a94 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -798,7 +798,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p);
+					   writing, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8071952e9cf2..0fc095a66a3c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4096,7 +4096,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	async = false;
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable,
+				    NULL);
 	if (!async)
 		return false; /* *pfn has correct page already */
 
@@ -4110,7 +4111,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			return true;
 	}
 
-	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable);
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL, write, writable,
+				    NULL);
 	return false;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d7072f6d6aa0..eca18ef9b1f4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -724,7 +724,7 @@ kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable);
+			       bool *writable, bool *protected);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 63282def3760..8bcf3201304a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1779,9 +1779,10 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * 1 indicates success, -errno is returned if error is detected.
  */
 static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
-			   bool *writable, kvm_pfn_t *pfn)
+			   bool *writable, bool *protected, kvm_pfn_t *pfn)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_KVM;
+	struct vm_area_struct *vma;
 	struct page *page;
 	int npages = 0;
 
@@ -1795,9 +1796,15 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	if (async)
 		flags |= FOLL_NOWAIT;
 
-	npages = get_user_pages_unlocked(addr, 1, &page, flags);
-	if (npages != 1)
+	down_read(&current->mm->mmap_sem);
+	npages = get_user_pages(addr, 1, flags, &page, &vma);
+	if (npages != 1) {
+		up_read(&current->mm->mmap_sem);
 		return npages;
+	}
+	if (protected)
+		*protected = vma_is_kvm_protected(vma);
+	up_read(&current->mm->mmap_sem);
 
 	/* map read fault as writable if possible */
 	if (unlikely(!write_fault) && writable) {
@@ -1888,7 +1895,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
  *     whether the mapping is writable.
  */
 static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+			bool write_fault, bool *writable, bool *protected)
 {
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
@@ -1903,7 +1910,8 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, async, write_fault, writable, protected,
+				 &pfn);
 	if (npages == 1)
 		return pfn;
 
@@ -1937,7 +1945,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 
 kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
-			       bool *writable)
+			       bool *writable, bool *protected)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -1960,7 +1968,7 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 	}
 
 	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+			  writable, protected);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
@@ -1968,19 +1976,26 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
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
 
+static kvm_pfn_t gfn_to_pfn_memslot_protected(struct kvm_memory_slot *slot,
+					      gfn_t gfn, bool *protected)
+{
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL,
+				    protected);
+}
+
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-- 
2.26.2

