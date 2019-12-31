Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05F12D6AF
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2019 07:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfLaGq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Dec 2019 01:46:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:16543 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfLaGqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Dec 2019 01:46:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Dec 2019 22:46:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,378,1571727600"; 
   d="scan'208";a="224368501"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 30 Dec 2019 22:46:52 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 07/10] mmu: spp: Enable Lazy mode SPP protection
Date:   Tue, 31 Dec 2019 14:50:40 +0800
Message-Id: <20191231065043.2209-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191231065043.2209-1-weijiang.yang@intel.com>
References: <20191231065043.2209-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To deal with SPP protected 4KB pages within hugepage(2MB,1GB etc),
the hugepage entry is first zapped when set subpage permission, then
in tdp_page_fault(), it checks whether the gfn should be mapped to
PT_PAGE_TABLE_LEVEL or PT_DIRECTORY_LEVEL level depending on gfn
inclusion of SPP protected page range.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++++++++++
 arch/x86/kvm/mmu/spp.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h |  2 ++
 3 files changed, 65 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c41791ebee65..aada0a3552b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3246,6 +3246,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	unsigned access = sp->role.access;
 	int i, ret;
 	gfn_t gfn;
+	u32 *wp_bitmap;
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
@@ -3259,6 +3260,13 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, start, access, 0, sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);
+		if (vcpu->kvm->arch.spp_active) {
+			wp_bitmap = gfn_to_subpage_wp_info(slot, gfn);
+			if (wp_bitmap && *wp_bitmap != FULL_SPP_ACCESS)
+				kvm_spp_mark_protection(vcpu->kvm,
+							gfn,
+							*wp_bitmap);
+		}
 		put_page(pages[i]);
 	}
 
@@ -3372,6 +3380,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 			   map_writable);
 	direct_pte_prefetch(vcpu, it.sptep);
 	++vcpu->stat.pf_fixed;
+	if (level == PT_PAGE_TABLE_LEVEL) {
+		int ret;
+		u32 access;
+
+		ret = kvm_spp_get_permission(vcpu->kvm, gfn, 1, &access);
+		if (ret == 1  && access != FULL_SPP_ACCESS)
+			kvm_spp_mark_protection(vcpu->kvm, gfn, access);
+	}
+
 	return ret;
 }
 
@@ -4338,6 +4355,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		if (level > PT_DIRECTORY_LEVEL &&
 		    !check_hugepage_cache_consistency(vcpu, gfn, level))
 			level = PT_DIRECTORY_LEVEL;
+
+		check_spp_protection(vcpu, gfn, &force_pt_level, &level);
+
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 9d9edb295394..a5b881f438b1 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -571,6 +571,49 @@ inline u64 construct_spptp(unsigned long root_hpa)
 }
 EXPORT_SYMBOL_GPL(construct_spptp);
 
+bool is_spp_protected(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	int page_num = KVM_PAGES_PER_HPAGE(level);
+	u32 *access;
+	gfn_t gfn_max;
+
+	gfn &= ~(page_num - 1);
+	gfn_max = gfn + page_num - 1;
+	for (; gfn <= gfn_max; gfn++) {
+		access = gfn_to_subpage_wp_info(slot, gfn);
+		if (access && *access != FULL_SPP_ACCESS)
+			return true;
+	}
+	return false;
+}
+
+bool check_spp_protection(struct kvm_vcpu *vcpu, gfn_t gfn,
+			  bool *force_pt_level, int *level)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memory_slot *slot;
+	bool protected;
+	int old_level = *level;
+
+	if (!kvm->arch.spp_active)
+		return false;
+
+	slot = gfn_to_memslot(kvm, gfn);
+
+	if (!slot)
+		return false;
+	protected = is_spp_protected(slot, gfn, PT_DIRECTORY_LEVEL);
+
+	if (protected) {
+		*level = PT_PAGE_TABLE_LEVEL;
+		*force_pt_level = true;
+	} else if (*level == PT_PDPE_LEVEL &&
+		   is_spp_protected(slot, gfn, PT_PDPE_LEVEL))
+		*level = PT_DIRECTORY_LEVEL;
+
+	return (old_level != *level);
+}
+
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
 			      u32 npages,
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 3a2a71cea276..6b2810965d6a 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -13,6 +13,8 @@ int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
 bool is_spp_spte(struct kvm_mmu_page *sp);
 void restore_spp_bit(u64 *spte);
 bool was_spp_armed(u64 spte);
+bool check_spp_protection(struct kvm_vcpu *vcpu, gfn_t gfn,
+			  bool *force_pt_level, int *level);
 inline u64 construct_spptp(unsigned long root_hpa);
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
-- 
2.17.2

