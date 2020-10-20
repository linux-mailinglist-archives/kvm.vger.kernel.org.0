Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B84C2934C4
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403935AbgJTGTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403885AbgJTGTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:13 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290F4C061755
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:13 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id l28so649951lfp.10
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YqXoyWzrpggXifhp2ZZvkYQN13pzHcgcJE84Cdo/0fA=;
        b=OvuEbAZWg3vpu8+LZy777g08/QYkrpy0M/C3pJJUVn5405klpLJKvddwUm/X8YG7sp
         GyOX+PH1FyvsxFbYCY9z84kfL6l126OrW4VmCKmakO3y1HTg9VEyY02PYG1PEge7/Q8r
         z2j50GS5eoRh2cLyya1+OFS64Xwz8sEdMr3uN1ZnQBxMTBotnH7o/PoKd8pHThWyvsn+
         uRCnDYRMb9t5l1XcGamPtITidQt8bkWtkHpL0SGaWPxfwx4Wwu0AkhnmRi2RXvyTfx5A
         MJ9bSUBb3CHAqNR0w2ov2Jg1ExbFBpFv7W9z60KdpSn3fpPMRxCujKX9CYht0WBYmcls
         MjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YqXoyWzrpggXifhp2ZZvkYQN13pzHcgcJE84Cdo/0fA=;
        b=btsLz0ujQQburydyGrxi+fwFoxdySKFRkhsJ8LkaLJd5jwq2/c3dZHAy/D6ipQfbFx
         xTp7JpDkLAJwB++6iLWL5pYVfhb8nZ5+fnjv8d8cUAH0YaZ7dzxQ6Uftnsnf/5Bcdv/S
         tS4HEDrh6/hI/bwODAKg4HE+L7Idp2XyfjTprFZmSeXyjy4UBbIgnvOQYbUl6ShIJnjZ
         JVeguHz40J5LtaRZ2ScdWceCaxDKFQYjly39a9x0eT1daLZ2DGzg52BdfSsQnGvY3EkA
         y4z4PHXSwxPKLPDZliKO3k0NLCydVqSCFoWN0x6wp+8HV9L9C0gJBE7DLAKOYZvFk4L5
         cZjA==
X-Gm-Message-State: AOAM532GqlsRlK/05GQH3LcZosXdUE3iqJwy5znhx7XhdG3wZzzi9n9W
        +Cu5U+uOHm5DIIFcSZszkYj4xg==
X-Google-Smtp-Source: ABdhPJx1Za/f8n8gS2Lf4tVPWSC9ysXQk4V29HtHvIrTK/S7VXXVqCjMAeIH20fbfqK12CcIlnQacA==
X-Received: by 2002:a19:4cd:: with SMTP id 196mr374025lfe.484.1603174751608;
        Mon, 19 Oct 2020 23:19:11 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id o14sm136989lfc.29.2020.10.19.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 24A6D102F6C; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
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
Subject: [RFCv2 13/16] KVM: Rework copy_to/from_guest() to avoid direct mapping
Date:   Tue, 20 Oct 2020 09:18:56 +0300
Message-Id: <20201020061859.18385-14-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are going unmap guest pages from direct mapping and cannot rely on it
for guest memory access. Use temporary kmap_atomic()-style mapping to
access guest memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 virt/kvm/kvm_main.c      |  27 ++++++++++-
 virt/lib/mem_protected.c | 101 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4c008c7b4974..9b569b78874a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
+#include <linux/pagewalk.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -154,6 +155,12 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+void *kvm_map_page_atomic(struct page *page);
+void kvm_unmap_page_atomic(void *vaddr);
+
+int kvm_init_protected_memory(void);
+void kvm_exit_protected_memory(void);
+
 int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect);
 
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
@@ -2329,6 +2336,7 @@ int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
 	int offset = offset_in_page(hva);
 	struct page *page;
 	int npages, seg;
+	void *vaddr;
 
 	if (!protected)
 		return __copy_from_user(data, (void __user *)hva, len);
@@ -2341,7 +2349,11 @@ int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
 		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
-		memcpy(data, page_address(page) + offset, seg);
+
+		vaddr = kvm_map_page_atomic(page);
+		memcpy(data, vaddr + offset, seg);
+		kvm_unmap_page_atomic(vaddr);
+
 		put_page(page);
 		len -= seg;
 		hva += seg;
@@ -2356,6 +2368,7 @@ int copy_to_guest(unsigned long hva, const void *data, int len, bool protected)
 	int offset = offset_in_page(hva);
 	struct page *page;
 	int npages, seg;
+	void *vaddr;
 
 	if (!protected)
 		return __copy_to_user((void __user *)hva, data, len);
@@ -2369,7 +2382,11 @@ int copy_to_guest(unsigned long hva, const void *data, int len, bool protected)
 						 FOLL_WRITE | FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
-		memcpy(page_address(page) + offset, data, seg);
+
+		vaddr = kvm_map_page_atomic(page);
+		memcpy(vaddr + offset, data, seg);
+		kvm_unmap_page_atomic(vaddr);
+
 		put_page(page);
 		len -= seg;
 		hva += seg;
@@ -4945,6 +4962,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_free;
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) &&
+	    kvm_init_protected_memory())
+		goto out_unreg;
+
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
@@ -4968,6 +4989,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	return 0;
 
 out_unreg:
+	kvm_exit_protected_memory();
 	kvm_async_pf_deinit();
 out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
@@ -4989,6 +5011,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	kvm_exit_protected_memory();
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
diff --git a/virt/lib/mem_protected.c b/virt/lib/mem_protected.c
index 0b01dd74f29c..1dfe82534242 100644
--- a/virt/lib/mem_protected.c
+++ b/virt/lib/mem_protected.c
@@ -5,6 +5,100 @@
 #include <linux/vmalloc.h>
 #include <asm/tlbflush.h>
 
+static pte_t **guest_map_ptes;
+static struct vm_struct *guest_map_area;
+
+void *kvm_map_page_atomic(struct page *page)
+{
+	pte_t *pte;
+	void *vaddr;
+
+	preempt_disable();
+	pte = guest_map_ptes[smp_processor_id()];
+	vaddr = guest_map_area->addr + smp_processor_id() * PAGE_SIZE;
+	set_pte(pte, mk_pte(page, PAGE_KERNEL));
+	return vaddr;
+}
+EXPORT_SYMBOL_GPL(kvm_map_page_atomic);
+
+void kvm_unmap_page_atomic(void *vaddr)
+{
+	pte_t *pte = guest_map_ptes[smp_processor_id()];
+	set_pte(pte, __pte(0));
+	flush_tlb_one_kernel((unsigned long)vaddr);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(kvm_unmap_page_atomic);
+
+int kvm_init_protected_memory(void)
+{
+	guest_map_ptes = kmalloc_array(num_possible_cpus(),
+				       sizeof(pte_t *), GFP_KERNEL);
+	if (!guest_map_ptes)
+		return -ENOMEM;
+
+	guest_map_area = alloc_vm_area(PAGE_SIZE * num_possible_cpus(),
+				       guest_map_ptes);
+	if (!guest_map_ptes) {
+		kfree(guest_map_ptes);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_init_protected_memory);
+
+void kvm_exit_protected_memory(void)
+{
+	if (guest_map_area)
+		free_vm_area(guest_map_area);
+	if (guest_map_ptes)
+		kfree(guest_map_ptes);
+}
+EXPORT_SYMBOL_GPL(kvm_exit_protected_memory);
+
+static int adjust_direct_mapping_pte_range(pmd_t *pmd, unsigned long addr,
+					   unsigned long end,
+					   struct mm_walk *walk)
+{
+	bool protect = (bool)walk->private;
+	pte_t *pte;
+	struct page *page;
+
+	if (pmd_trans_huge(*pmd)) {
+		page = pmd_page(*pmd);
+		if (is_huge_zero_page(page))
+			return 0;
+		VM_BUG_ON_PAGE(total_mapcount(page) != 1, page);
+		/* XXX: Would it fail with direct device assignment? */
+		VM_BUG_ON_PAGE(page_count(page) != 1, page);
+		kernel_map_pages(page, HPAGE_PMD_NR, !protect);
+		return 0;
+	}
+
+	pte = pte_offset_map(pmd, addr);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		pte_t entry = *pte;
+
+		if (!pte_present(entry))
+			continue;
+
+		if (is_zero_pfn(pte_pfn(entry)))
+			continue;
+
+		page = pte_page(entry);
+
+		VM_BUG_ON_PAGE(page_mapcount(page) != 1, page);
+		kernel_map_pages(page, 1, !protect);
+	}
+
+	return 0;
+}
+
+static const struct mm_walk_ops adjust_direct_mapping_ops = {
+	.pmd_entry      = adjust_direct_mapping_pte_range,
+};
+
 int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect)
 {
 	struct mm_struct *mm = current->mm;
@@ -50,6 +144,13 @@ int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect)
 		if (ret)
 			goto out;
 
+		if (vma_is_anonymous(vma)) {
+			ret = walk_page_range_novma(mm, start, tmp,
+						    &adjust_direct_mapping_ops, NULL,
+						    (void *) protect);
+			if (ret)
+				goto out;
+		}
 next:
 		start = tmp;
 		if (start < prev->vm_end)
-- 
2.26.2

