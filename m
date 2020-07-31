Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97053234CE2
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgGaVXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:50224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbgGaVXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:31 -0400
IronPort-SDR: QlZ05md2KNPYIzpbAmiKQbyIGgBXkeRSKYVEeu6fHUZuIl+fUPqDNgtdYOnT6pDFQnqCWuKbDw
 MPqm4m31ynRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075134"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: cyySMoQBdLD4wZpxqY0qAajzuUxlrh3m7BtU7M5kj5Q6OmwQ6m+4iDeqyrT+RMOmRBlTHLGPB1
 eQfhzUHiTzWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191319"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 8/8] KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
Date:   Fri, 31 Jul 2020 14:23:23 -0700
Message-Id: <20200731212323.21746-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/sev.c | 117 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 112 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f640b8beb443e..eb95914578497 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 
+#include "mmu.h"
 #include "x86.h"
 #include "svm.h"
 
@@ -415,6 +416,107 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 	return pages;
 }
 
+#define SEV_PFERR (PFERR_WRITE_MASK | PFERR_USER_MASK)
+
+static void *sev_alloc_pages(unsigned long size, unsigned long *npages)
+{
+	/* TODO */
+	*npages = 0;
+	return NULL;
+}
+
+static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
+					      unsigned long hva)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, slots) {
+		if (hva >= memslot->userspace_addr &&
+			hva < memslot->userspace_addr +
+				(memslot->npages << PAGE_SHIFT))
+			return memslot;
+	}
+
+	return NULL;
+}
+
+static bool hva_to_gpa(struct kvm *kvm, unsigned long hva)
+{
+	struct kvm_memory_slot *memslot;
+	gpa_t gpa_offset;
+
+	memslot = hva_to_memslot(kvm, hva);
+	if (!memslot)
+		return UNMAPPED_GVA;
+
+	gpa_offset = hva - memslot->userspace_addr;
+	return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
+}
+
+static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
+					   unsigned long size,
+					   unsigned long *npages)
+{
+	struct kvm_vcpu *vcpu;
+	struct page **pages;
+	unsigned long i;
+	kvm_pfn_t pfn;
+	int idx, ret;
+	gpa_t gpa;
+
+	pages = sev_alloc_pages(size, npages);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (mutex_lock_killable(&vcpu->mutex)) {
+		kvfree(pages);
+		return ERR_PTR(-EINTR);
+	}
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_mmu_load(vcpu);
+
+	for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			goto err;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		gpa = hva_to_gpa(kvm, addr);
+		if (gpa == UNMAPPED_GVA) {
+			ret = -EFAULT;
+			goto err;
+		}
+		pfn = kvm_mmu_map_tdp_page(vcpu, gpa, SEV_PFERR, PG_LEVEL_4K);
+		if (is_error_noslot_pfn(pfn)) {
+			ret = -EFAULT;
+			goto err;
+		}
+		pages[i] = pfn_to_page(pfn);
+		get_page(pages[i]);
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	mutex_unlock(&vcpu->mutex);
+	return pages;
+
+err:
+	for ( ; i; --i)
+		put_page(pages[i-1]);
+
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
 static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
@@ -439,9 +541,12 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
-	if (!inpages) {
-		ret = -ENOMEM;
+	if (atomic_read(&kvm->online_vcpus))
+		inpages = sev_pin_memory_in_mmu(kvm, vaddr, size, &npages);
+	else
+		inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	if (IS_ERR(inpages)) {
+		ret = PTR_ERR(inpages);
 		goto e_free;
 	}
 
@@ -449,9 +554,11 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	 * The LAUNCH_UPDATE command will perform in-place encryption of the
 	 * memory content (i.e it will write the same memory region with C=1).
 	 * It's possible that the cache may contain the data with C=0, i.e.,
-	 * unencrypted so invalidate it first.
+	 * unencrypted so invalidate it first.  Flushing is automatically
+	 * handled if the pages can be pinned in the MMU.
 	 */
-	sev_clflush_pages(inpages, npages);
+	if (!atomic_read(&kvm->online_vcpus))
+		sev_clflush_pages(inpages, npages);
 
 	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i += pages) {
 		int offset, len;
-- 
2.28.0

