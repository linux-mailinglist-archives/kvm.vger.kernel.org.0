Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8671D610C
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgEPMx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:53:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:47561 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgEPMxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:53:55 -0400
IronPort-SDR: jlVLNnnsh1rjdfJS9M4BcErfxwRHwwcjsp17IMHBz/qhtV1YJrdjXEhqr8FICNzez+ttY17GCH
 tU+20YBXo7Qw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:53:55 -0700
IronPort-SDR: QG37WowSspaPzmaY6zwzKegKBxmttLVvZFI5k8+bmL2dfCAttJAA1fwhIZgM7SRgmY0YtSa0mE
 IV+o3OXcC+2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076577"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:53:52 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 03/11] mmu: spp: Implement SPPT setup functions
Date:   Sat, 16 May 2020 20:54:59 +0800
Message-Id: <20200516125507.5277-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPPT(Sub-Page Permission Table) is a 4-level structure similar
to EPT. If SPP is enabled in secondary execution control, WP and
SPP bit(61) are set in a 4KB EPT leaf entry, then SPPT is traversed
with the gfn, the leaf entry of SPPT contains the permission vector,
every subpage within the 4KB page owns one bit.

SPPT setup is similar to that of EPT therefore a lot of EPT helpers
are re-used in spp.c. To make least change to mmu.c and keep the patch
clean meanwhile, spp.c is embedded at the end of mmu.c.

Specific to SPPT:
1)The leaf entry contains a 64-bit permission vector. Subpage is
  128B each so 4KB/128B = 32bits are required for write permission.
  The even bits(2*i) corrrespond to write-permission to subpage(i),
  if it's 1, subpage(i) is writable, otherwise, it's write-protected.
  The odd bits are reserved and must be 0.
2)When permission vectors are updated, it first flushes the corresponding
  entry at SPPT L2E by making the entry invalid so that following SPPT
  walk can trigger SPP-miss handling, there the permission vectors are
  rebuilt.

spp.c is built as a separate object file now per previous patch.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   5 +-
 arch/x86/kvm/Makefile           |   2 +-
 arch/x86/kvm/mmu/spp.c          | 129 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h          |   5 ++
 4 files changed, 139 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/spp.c
 create mode 100644 arch/x86/kvm/mmu/spp.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0dea9f122bb9..ee4721bd8703 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -274,7 +274,8 @@ union kvm_mmu_page_role {
 		unsigned smap_andnot_wp:1;
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
-		unsigned :6;
+		unsigned spp:1;
+		unsigned reserved:5;
 
 		/*
 		 * This is left at the top of the word so that
@@ -982,6 +983,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	hpa_t sppt_root;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4a3081e9f4b5..1561543d443a 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -15,7 +15,7 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
-			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
+			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o mmu/spp.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
new file mode 100644
index 000000000000..8924096df390
--- /dev/null
+++ b/arch/x86/kvm/mmu/spp.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kvm_host.h>
+#include "mmu_internal.h"
+#include "mmu.h"
+#include "spp.h"
+
+#define for_each_shadow_spp_entry(_vcpu, _addr, _walker)    \
+	for (shadow_spp_walk_init(&(_walker), _vcpu, _addr);	\
+	     shadow_walk_okay(&(_walker));			\
+	     shadow_walk_next(&(_walker)))
+
+static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
+				 struct kvm_vcpu *vcpu, u64 addr)
+{
+	iterator->addr = addr;
+	iterator->shadow_addr = vcpu->kvm->arch.sppt_root;
+
+	/* SPP Table is a 4-level paging structure */
+	iterator->level = PT64_ROOT_4LEVEL;
+}
+
+struct kvm_mmu_page *kvm_spp_get_page(struct kvm_vcpu *vcpu,
+				      gfn_t gfn,
+				      unsigned int level)
+{
+	struct kvm_mmu_page *sp;
+	union kvm_mmu_page_role role;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = level;
+	role.direct = true;
+	role.spp = true;
+
+	for_each_valid_sp(vcpu->kvm, sp, gfn) {
+		if (sp->gfn != gfn)
+			continue;
+		if (sp->role.word != role.word)
+			continue;
+		if (sp->role.spp && sp->role.level == level)
+			goto out;
+	}
+
+	sp = kvm_mmu_alloc_page(vcpu, true);
+	sp->gfn = gfn;
+	sp->role = role;
+	hlist_add_head(&sp->hash_link,
+		       &vcpu->kvm->arch.mmu_page_hash
+		       [kvm_page_table_hashfn(gfn)]);
+	clear_page(sp->spt);
+out:
+	return sp;
+}
+
+static void link_spp_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
+				 struct kvm_mmu_page *sp)
+{
+	u64 spte;
+
+	spte = __pa(sp->spt) | PT_PRESENT_MASK;
+
+	mmu_spte_set(sptep, spte);
+
+	mmu_page_add_parent_pte(vcpu, sp, sptep);
+}
+
+static u64 format_spp_spte(u32 spp_wp_bitmap)
+{
+	u64 new_spte = 0;
+	int i = 0;
+
+	/*
+	 * One 4K-page contains 32 sub-pages, they're flagged in even bits in
+	 * SPPT L4E, the odd bits are reserved now, so convert 4-byte write
+	 * permission bitmap to 8-byte SPP L4E format.
+	 */
+	for (i = 0; i < 32; i++)
+		new_spte |= (spp_wp_bitmap & BIT_ULL(i)) << i;
+
+	return new_spte;
+}
+
+static void spp_spte_set(u64 *sptep, u64 new_spte)
+{
+	__set_spte(sptep, new_spte);
+}
+
+int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
+			    u32 access_map, gfn_t gfn)
+{
+	struct kvm_shadow_walk_iterator iter;
+	struct kvm_mmu_page *sp;
+	gfn_t pseudo_gfn;
+	u64 old_spte, spp_spte;
+	int ret = -EFAULT;
+
+	if (!VALID_PAGE(vcpu->kvm->arch.sppt_root))
+		return -EFAULT;
+
+	for_each_shadow_spp_entry(vcpu, (u64)gfn << PAGE_SHIFT, iter) {
+		if (iter.level == PT_PAGE_TABLE_LEVEL) {
+			spp_spte = format_spp_spte(access_map);
+			old_spte = mmu_spte_get_lockless(iter.sptep);
+			if (old_spte != spp_spte)
+				spp_spte_set(iter.sptep, spp_spte);
+			ret = 0;
+			break;
+		}
+
+		if (!is_shadow_present_pte(*iter.sptep)) {
+			u64 base_addr = iter.addr;
+
+			base_addr &= PT64_LVL_ADDR_MASK(iter.level);
+			pseudo_gfn = base_addr >> PAGE_SHIFT;
+			sp = kvm_spp_get_page(vcpu, pseudo_gfn,
+					      iter.level - 1);
+			link_spp_shadow_page(vcpu, iter.sptep, sp);
+		} else if (iter.level == PT_DIRECTORY_LEVEL) {
+			spp_spte = mmu_spte_get_lockless(iter.sptep);
+			if (!(spp_spte & PT_PRESENT_MASK) &&
+			    (spp_spte & PT64_BASE_ADDR_MASK)) {
+				spp_spte |= PT_PRESENT_MASK;
+				spp_spte_set(iter.sptep, spp_spte);
+			}
+		}
+	}
+
+	kvm_flush_remote_tlbs(vcpu->kvm);
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
new file mode 100644
index 000000000000..03e4dfad595a
--- /dev/null
+++ b/arch/x86/kvm/mmu/spp.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_SPP_H
+#define __KVM_X86_VMX_SPP_H
+
+#endif /* __KVM_X86_VMX_SPP_H */
-- 
2.17.2

