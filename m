Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BD11DE73F
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgEVMw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729964AbgEVMw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:28 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B4C02A19B
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:27 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z18so12439637lji.12
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WBg6Grrpfv0UYLyySue87ooSEtb1PaH0oM+7q4JuIvE=;
        b=k/PBhVH4U/84hhUDy2iNb6HmIdHpCtBme2OP7Q9seCU+mJ5bOwnJL0bkIYzY4tQzQd
         AMzF0kp3hxSOb/UdlBe3T50OcmZy7ZQXruO8tyi/YjR7rEj/6Flotp02nt90TGQfWa4V
         ghNFpOeIsz7O57IG/xOWpo/82qT8dM3ouBDmuc4hGLo6ga6Spz5pPGV6GpsCySA4/uy0
         g2/jU3t+DFQldIRJEWbDz5sU+QxU8yjwcXCUawNI9urbOdCIm4lXK39VbLyiZ7g8kkT5
         fPELafo+80qdXYx+Ta3tnd+1UQkuXvVbgUS2V+cGTdWJWBcSm4HDrl3GFlsaOmFW/Iuv
         Xlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBg6Grrpfv0UYLyySue87ooSEtb1PaH0oM+7q4JuIvE=;
        b=FJ4t+tMgp0f93JvRJCJv1i2xk/j1Mx1Qb5STEwHhuCSzQikUyNctnVtSR298zRfyhH
         xCb8i1oH9ZYwyYGmWJE/xdvx/eL8eDbL862oY06/xxRnkKGxTmdXWAvBb9vEcxbaEZXr
         hlY7TASKdJ+q69jqVrei79OXcsegCHVm4OMKHW6SoSWcG3TBrdu2BBq/VGtvMF3Fg5qf
         3D+uiARHeB2ZrpmzhDPAMV4bJ5qLZEY3Kz+zGyaVXjP4ia1/skEhMZrzFxQRg5/U6rZ0
         BLYUGt9S3oA55JfCuV0Pk9jfwB/qvysI+guJDiZW528xz9PZKKq+b8TxbFfH8jY8LeNG
         Sjuw==
X-Gm-Message-State: AOAM531hEoo+sBZCd9+R0VbqBqYQYAJsmoZnjIBYdRp+eCLSoHxXTlX8
        hsBZjkdxXYfj9DRoXQqN89go4w==
X-Google-Smtp-Source: ABdhPJwNm4ecA72ZG7EXOMbXL+0nWYPqAQuoYcz8FiPFtT8yxBCXefIBszRD/aNFrU9Q+/CufU2ZrQ==
X-Received: by 2002:a2e:3a08:: with SMTP id h8mr5865621lja.1.1590151945625;
        Fri, 22 May 2020 05:52:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id v5sm1441492ljh.131.2020.05.22.05.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 19BE810205D; Fri, 22 May 2020 15:52:20 +0300 (+03)
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
Subject: [RFC 15/16] KVM: Handle protected memory in __kvm_map_gfn()/__kvm_unmap_gfn()
Date:   Fri, 22 May 2020 15:52:13 +0300
Message-Id: <20200522125214.31348-16-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We cannot access protected pages directly. Use ioremap() to
create a temporary mapping of the page. The mapping is destroyed
on __kvm_unmap_gfn().

The new interface gfn_to_pfn_memslot_protected() is used to detect if
the page is protected.

ioremap_cache_force() is a hack to bypass IORES_MAP_SYSTEM_RAM check in
the x86 ioremap code. We need a better solution.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/io.h            |  2 ++
 arch/x86/include/asm/pgtable_types.h |  1 +
 arch/x86/mm/ioremap.c                | 16 +++++++++++++---
 include/linux/kvm_host.h             |  1 +
 virt/kvm/kvm_main.c                  | 14 +++++++++++---
 5 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index c58d52fd7bf2..a3e1bfad1026 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -184,6 +184,8 @@ extern void __iomem *ioremap_uc(resource_size_t offset, unsigned long size);
 #define ioremap_uc ioremap_uc
 extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 #define ioremap_cache ioremap_cache
+extern void __iomem *ioremap_cache_force(resource_size_t offset, unsigned long size);
+#define ioremap_cache_force ioremap_cache_force
 extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size, unsigned long prot_val);
 #define ioremap_prot ioremap_prot
 extern void __iomem *ioremap_encrypted(resource_size_t phys_addr, unsigned long size);
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b6606fe6cfdf..66cc22abda7b 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -147,6 +147,7 @@ enum page_cache_mode {
 	_PAGE_CACHE_MODE_UC       = 3,
 	_PAGE_CACHE_MODE_WT       = 4,
 	_PAGE_CACHE_MODE_WP       = 5,
+	_PAGE_CACHE_MODE_WB_FORCE = 6,
 
 	_PAGE_CACHE_MODE_NUM      = 8
 };
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 18c637c0dc6f..e48fc0e130b2 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -202,9 +202,12 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
 	__ioremap_check_mem(phys_addr, size, &io_desc);
 
 	/*
-	 * Don't allow anybody to remap normal RAM that we're using..
+	 * Don't allow anybody to remap normal RAM that we're using, unless
+	 * _PAGE_CACHE_MODE_WB_FORCE is used.
 	 */
-	if (io_desc.flags & IORES_MAP_SYSTEM_RAM) {
+	if (pcm == _PAGE_CACHE_MODE_WB_FORCE) {
+	    pcm = _PAGE_CACHE_MODE_WB;
+	} else if (io_desc.flags & IORES_MAP_SYSTEM_RAM) {
 		WARN_ONCE(1, "ioremap on RAM at %pa - %pa\n",
 			  &phys_addr, &last_addr);
 		return NULL;
@@ -419,6 +422,13 @@ void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_cache);
 
+void __iomem *ioremap_cache_force(resource_size_t phys_addr, unsigned long size)
+{
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WB_FORCE,
+				__builtin_return_address(0), false);
+}
+EXPORT_SYMBOL(ioremap_cache_force);
+
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
 				unsigned long prot_val)
 {
@@ -467,7 +477,7 @@ void iounmap(volatile void __iomem *addr)
 	p = find_vm_area((void __force *)addr);
 
 	if (!p) {
-		printk(KERN_ERR "iounmap: bad address %p\n", addr);
+		printk(KERN_ERR "iounmap: bad address %px\n", addr);
 		dump_stack();
 		return;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eca18ef9b1f4..b6944f88033d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -237,6 +237,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool protected;
 };
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8bcf3201304a..71aac117357f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2091,6 +2091,7 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
 	struct kvm_memory_slot *slot = __gfn_to_memslot(slots, gfn);
+	bool protected = false;
 	u64 gen = slots->generation;
 
 	if (!map)
@@ -2107,12 +2108,16 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	} else {
 		if (atomic)
 			return -EAGAIN;
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = gfn_to_pfn_memslot_protected(slot, gfn, &protected);
 	}
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
-	if (pfn_valid(pfn)) {
+	if (protected) {
+		if (atomic)
+			return -EAGAIN;
+		hva = ioremap_cache_force(pfn_to_hpa(pfn), PAGE_SIZE);
+	} else if (pfn_valid(pfn)) {
 		page = pfn_to_page(pfn);
 		if (atomic)
 			hva = kmap_atomic(page);
@@ -2133,6 +2138,7 @@ static int __kvm_map_gfn(struct kvm_memslots *slots, gfn_t gfn,
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->protected = protected;
 
 	return 0;
 }
@@ -2163,7 +2169,9 @@ static void __kvm_unmap_gfn(struct kvm_memory_slot *memslot,
 	if (!map->hva)
 		return;
 
-	if (map->page != KVM_UNMAPPED_PAGE) {
+	if (map->protected) {
+		iounmap(map->hva);
+	} else if (map->page != KVM_UNMAPPED_PAGE) {
 		if (atomic)
 			kunmap_atomic(map->hva);
 		else
-- 
2.26.2

