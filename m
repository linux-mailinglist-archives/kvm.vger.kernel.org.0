Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33932141BCD
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 05:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgASEAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 23:00:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:62796 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgASEAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 23:00:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 20:00:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="214910507"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2020 20:00:33 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 06/10] mmu: spp: Enable Lazy mode SPP protection
Date:   Sun, 19 Jan 2020 12:05:03 +0800
Message-Id: <20200119040507.23113-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200119040507.23113-1-weijiang.yang@intel.com>
References: <20200119040507.23113-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SPP protection is set but the gfn->pfn mapping isn't there,
we need to check and mark SPP protection in EPT while
gfn->pfn mapping is being built, but the setup for SPPT is deferred
to handle_spp() handler.

From HW's capability, SPP only works for 4KB mappings, to apply
SPP protection for hugepage(2MB,1GB) cases, hugepage entries need
to be zapped before SPP set up. In tdp_page_fault(), there's check
for SPP protection before sets 4KB, 2MB or 1GB mapping, the target
is introducing least impact to hugepage setup, i.e., falls back to
most possible hugepage mapping.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++++++++++
 arch/x86/kvm/mmu/spp.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h |  2 ++
 3 files changed, 65 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 665923deb4a9..fe14f60928a2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3251,6 +3251,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	unsigned access = sp->role.access;
 	int i, ret;
 	gfn_t gfn;
+	u32 *wp_bitmap;
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
@@ -3264,6 +3265,13 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
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
 
@@ -3377,6 +3385,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
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
 
@@ -4337,6 +4354,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		if (level > PT_DIRECTORY_LEVEL &&
 		    !check_hugepage_cache_consistency(vcpu, gfn, level))
 			level = PT_DIRECTORY_LEVEL;
+
+		check_spp_protection(vcpu, gfn, &force_pt_level, &level);
+
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 2f2558c0041d..eb540e1b5133 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -429,6 +429,49 @@ int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access)
 	return ret;
 }
 
+static bool is_spp_protected(struct kvm_memory_slot *slot, gfn_t gfn, int level)
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
index c3588c20be52..51a209a04863 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -11,6 +11,8 @@ int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
+bool check_spp_protection(struct kvm_vcpu *vcpu, gfn_t gfn,
+			  bool *force_pt_level, int *level);
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
 			      u32 npages,
-- 
2.17.2

