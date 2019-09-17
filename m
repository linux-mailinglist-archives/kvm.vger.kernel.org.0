Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC8B49E5
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfIQIw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:52:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:37165 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfIQIwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:52:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 01:52:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,515,1559545200"; 
   d="scan'208";a="193695544"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2019 01:52:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 8/9] mmu: spp: Enable Lazy mode SPP protection
Date:   Tue, 17 Sep 2019 16:53:03 +0800
Message-Id: <20190917085304.16987-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190917085304.16987-1-weijiang.yang@intel.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
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
 arch/x86/kvm/mmu.c     | 14 ++++++++++++
 arch/x86/kvm/vmx/spp.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/spp.h |  4 ++++
 3 files changed, 66 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a632c6b3c326..c9c430d2c7e3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3240,6 +3240,17 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 			   map_writable);
 	direct_pte_prefetch(vcpu, it.sptep);
 	++vcpu->stat.pf_fixed;
+	if (level == PT_PAGE_TABLE_LEVEL) {
+		struct kvm_subpage sbp = {0};
+		int pages;
+
+		sbp.base_gfn = gfn;
+		sbp.npages = 1;
+		pages = kvm_spp_get_permission(vcpu->kvm, &sbp);
+		if (pages == 1  && sbp.access_map[0] != FULL_SPP_ACCESS)
+		      kvm_spp_mark_protection(vcpu->kvm, &sbp);
+	}
+
 	return ret;
 }
 
@@ -4183,6 +4194,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		if (level > PT_DIRECTORY_LEVEL &&
 		    !check_hugepage_cache_consistency(vcpu, gfn, level))
 			level = PT_DIRECTORY_LEVEL;
+
+		check_spp_protection(vcpu, gfn, &force_pt_level,&level);
+
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
diff --git a/arch/x86/kvm/vmx/spp.c b/arch/x86/kvm/vmx/spp.c
index b6fc2e313b59..7f7a3749c35b 100644
--- a/arch/x86/kvm/vmx/spp.c
+++ b/arch/x86/kvm/vmx/spp.c
@@ -547,6 +547,54 @@ inline u64 construct_spptp(unsigned long root_hpa)
 }
 EXPORT_SYMBOL_GPL(construct_spptp);
 
+bool is_spp_protected(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	int page_num = KVM_PAGES_PER_HPAGE(level);
+	int i;
+	gfn &= ~(page_num - 1);
+
+	for (i = 0; i < page_num; ++i) {
+		if (*gfn_to_subpage_wp_info(slot, gfn + i) != FULL_SPP_ACCESS)
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
+	u32 access;
+
+	if (!kvm->arch.spp_active)
+	      return false;
+
+	slot = gfn_to_memslot(kvm, gfn);
+
+	if (!slot)
+	      return false;
+
+	if (*level == PT_PAGE_TABLE_LEVEL) {
+		access = *gfn_to_subpage_wp_info(slot, gfn);
+
+		if (access != FULL_SPP_ACCESS) {
+			*force_pt_level = true;
+			return true;
+		}
+	} else {
+		if (is_spp_protected(slot, gfn, PT_PDPE_LEVEL)) {
+			bool protected = is_spp_protected(slot, gfn,
+							  PT_DIRECTORY_LEVEL);
+			*level = protected ? PT_PAGE_TABLE_LEVEL :
+				 PT_DIRECTORY_LEVEL;
+			*force_pt_level = protected;
+			return true;
+		}
+	}
+	return false;
+}
+
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 		     struct kvm_subpage *spp_info)
 {
diff --git a/arch/x86/kvm/vmx/spp.h b/arch/x86/kvm/vmx/spp.h
index 8925a6ca4d3b..ed7852bb6b33 100644
--- a/arch/x86/kvm/vmx/spp.h
+++ b/arch/x86/kvm/vmx/spp.h
@@ -4,9 +4,13 @@
 
 #define FULL_SPP_ACCESS		((u32)((1ULL << 32) - 1))
 
+int kvm_spp_get_permission(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_spp_mark_protection(struct kvm *kvm, struct kvm_subpage *spp_info);
 bool is_spp_spte(struct kvm_mmu_page *sp);
 void restore_spp_bit(u64 *spte);
 bool was_spp_armed(u64 spte);
+bool check_spp_protection(struct kvm_vcpu *vcpu, gfn_t gfn,
+			  bool *force_pt_level, int *level);
 inline u64 construct_spptp(unsigned long root_hpa);
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 		     struct kvm_subpage *spp_info);
-- 
2.17.2

