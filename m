Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD9C1D610F
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgEPMyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:47569 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgEPMyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:54:06 -0400
IronPort-SDR: vQ2uHiaVSNBuiCW85jS06JHAU1/5ldUkTv/gk3d3kCKnl1rLkRvldtm9XGBEBSzZQFYIE5BY/o
 KJ0uXMWxV+Uw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:54:06 -0700
IronPort-SDR: zn0Y3QyFmJ3jgxb2+Bz1/6iMAT6xMNsuhR0vkKqi3hisoLiAmxyhrKnoh1jbgFjfyO9+Djm6WM
 PnF69CwF8Hag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076604"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:54:03 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 07/11] mmu: spp: Enable Lazy mode SPP protection
Date:   Sat, 16 May 2020 20:55:03 +0800
Message-Id: <20200516125507.5277-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
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
 arch/x86/kvm/mmu/mmu.c | 19 +++++++++++++++++++
 arch/x86/kvm/mmu/spp.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h |  2 ++
 3 files changed, 64 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 270dd567272e..9d5a0eb3d24e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3131,6 +3131,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	unsigned int access = sp->role.access;
 	int i, ret;
 	gfn_t gfn;
+	u32 *wp_bitmap;
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
@@ -3144,6 +3145,13 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
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
 
@@ -3336,6 +3344,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
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
 
@@ -4125,6 +4142,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (lpage_disallowed)
 		max_level = PT_PAGE_TABLE_LEVEL;
 
+	check_spp_protection(vcpu, gfn, &max_level);
+
 	r = fast_page_fault(vcpu, gpa, error_code);
 
 	if (r != RET_PF_INVALID)
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index bb8f298d72da..8f89df57da7c 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -433,6 +433,49 @@ int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access)
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
+void check_spp_protection(struct kvm_vcpu *vcpu, gfn_t gfn,
+			  int *max_level)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memory_slot *slot;
+	bool protected;
+
+	if (!kvm->arch.spp_active)
+		return;
+
+	slot = gfn_to_memslot(kvm, gfn);
+
+	if (!slot)
+		return;
+
+	protected = is_spp_protected(slot, gfn, PT_DIRECTORY_LEVEL);
+
+	if (protected) {
+		*max_level = PT_PAGE_TABLE_LEVEL;
+	} else if (*max_level == PT_PDPE_LEVEL &&
+		   is_spp_protected(slot, gfn, PT_PDPE_LEVEL)) {
+		*max_level = PT_DIRECTORY_LEVEL;
+	}
+
+	return;
+}
+
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
 			      u32 npages,
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index c3588c20be52..e0541901ec41 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -11,6 +11,8 @@ int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
+void check_spp_protection(struct kvm_vcpu *vcpu, gfn_t gfn,
+			  int *max_level);
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
 			      u32 npages,
-- 
2.17.2

