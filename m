Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB480134D80
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgAHU2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:28:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:21736 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbgAHU1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658362"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: [PATCH 03/14] KVM: Use vcpu-specific gva->hva translation when querying host page size
Date:   Wed,  8 Jan 2020 12:24:37 -0800
Message-Id: <20200108202448.9669-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_vcpu_gfn_to_hva() when retrieving the host page size so that the
correct set of memslots is used when handling x86 page faults in SMM.

Fixes: 54bf36aac520 ("KVM: x86: use vcpu-specific functions to read/write/translate GFNs")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/book3s_xive_native.c | 2 +-
 arch/x86/kvm/mmu/mmu.c                | 6 +++---
 include/linux/kvm_host.h              | 2 +-
 virt/kvm/kvm_main.c                   | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index d83adb1e1490..6ef0151ff70a 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -631,7 +631,7 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	gfn = gpa_to_gfn(kvm_eq.qaddr);
 
-	page_size = kvm_host_page_size(kvm, gfn);
+	page_size = kvm_host_page_size(vcpu, gfn);
 	if (1ull << kvm_eq.qshift > page_size) {
 		srcu_read_unlock(&kvm->srcu, srcu_idx);
 		pr_warn("Incompatible host page size %lx!\n", page_size);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ca14c84c4f4b..8ca6cd04cdf1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1286,12 +1286,12 @@ static bool mmu_gfn_lpage_is_disallowed(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return __mmu_gfn_lpage_is_disallowed(gfn, level, slot);
 }
 
-static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
+static int host_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	unsigned long page_size;
 	int i, ret = 0;
 
-	page_size = kvm_host_page_size(kvm, gfn);
+	page_size = kvm_host_page_size(vcpu, gfn);
 
 	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
 		if (page_size >= KVM_HPAGE_SIZE(i))
@@ -1362,7 +1362,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 	 * So, do not propagate host_mapping_level() to max_level as KVM can
 	 * still promote the guest mapping to a huge page in the THP case.
 	 */
-	host_level = host_mapping_level(vcpu->kvm, large_gfn);
+	host_level = host_mapping_level(vcpu, large_gfn);
 	return min(host_level, max_level);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 411b71a02f25..3c0ceec45ebd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -767,7 +767,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
-unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
+unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e8ca8bf12320..5f7f06824c2b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1416,14 +1416,14 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
-unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn)
+unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
 	unsigned long addr, size;
 
 	size = PAGE_SIZE;
 
-	addr = gfn_to_hva(kvm, gfn);
+	addr = kvm_vcpu_gfn_to_hva(vcpu, gfn);
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
-- 
2.24.1

