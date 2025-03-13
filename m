Return-Path: <kvm+bounces-40974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDAFA5FF12
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4AC97AA572
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2975D1EB5E9;
	Thu, 13 Mar 2025 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHbtlbZw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E248F15CD78;
	Thu, 13 Mar 2025 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741889812; cv=none; b=E25F4BImXJVuQRNGAy1JbDA6XwEkgnB6G7MUxEd/2tE0nXJDnT6d9KhwY2pHI4xBkrNSnDeT7cAABOGmcC7l2lPr+L2Kk4tuuMVatpm71V6Pawk5awzC905By2/GNyj2D+iHZdEEmv75N5Fvb7dpy1P5QddOL04y0JPHFw2Nkpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741889812; c=relaxed/simple;
	bh=JHaDvHnmIuMbfv/S6wMqMf0r0ma36TZbA+ecaHDSje4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gLePhk2rdqUunGFHG7I5Ok2B8kNHIhQnucldVdbeB/SWL9kOQevUIRVuU06CnSkGdLfs1XzMSVwEwsyEwhmeAkVGHUEzRoWcfFC1nRu/j1fxSjytUsTbnpvIU5swc2lVySgiqc/KYGdd/+df5evmn2rg0bDhVb2IyRXo5JpvJQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHbtlbZw; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741889810; x=1773425810;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JHaDvHnmIuMbfv/S6wMqMf0r0ma36TZbA+ecaHDSje4=;
  b=SHbtlbZwBRuEt4wj+6F2KgRTkTkl0hwqTKfBca8m3MwizAvvgJyJ7BXV
   OWIr2Y8wNsohSgRuAp5/heuO81cXQ6H9f8sBClY2dX27dJy7AL4N2rxYl
   pe62mi/KqiKltUG3jJbDBspPsPVWCoUte57u8svz5tCLc9MR9hlchQ1Uv
   rVQ4cgEK4vzDhWrpZsUCMG7gvMFGBy/bT/yFN58PajlZ/3BaKwLUooaeH
   ZdPtTy2LqT4/oa4s4GDXpnW00UYqbnMuFAMMnrDUrixV32/puUMCHrUZz
   gCqLegkFuY46hFRQ3OR79dhy4wBcjbALOoYKqVupUwQnFSdx0BgHhlFKK
   A==;
X-CSE-ConnectionGUID: yLDfHBDDTZqlDkSa7CCKzA==
X-CSE-MsgGUID: Qqe9XHuGQdeg40ceXQPeuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="54400593"
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="54400593"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 11:16:49 -0700
X-CSE-ConnectionGUID: VYq43T5HTauAr/gEKRwoLg==
X-CSE-MsgGUID: Bt2FvP9vRS2UdfFBKsfn8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,245,1736841600"; 
   d="scan'208";a="121036443"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.245.89.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 11:16:41 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease shutdown time
Date: Thu, 13 Mar 2025 20:16:29 +0200
Message-ID: <20250313181629.17764-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Improve TDX shutdown performance by adding a more efficient shutdown
operation at the cost of adding separate branches for the TDX MMU
operations for normal runtime and shutdown.  This more efficient method was
previously used in earlier versions of the TDX patches, but was removed to
simplify the initial upstreaming.  This is an RFC, and still needs a proper
upstream commit log. It is intended to be an eventual follow up to base
support.

== Background ==

TDX has 2 methods for the host to reclaim guest private memory, depending
on whether the TD (TDX VM) is in a runnable state or not.  These are
called, respectively:
  1. Dynamic Page Removal
  2. Reclaiming TD Pages in TD_TEARDOWN State

Dynamic Page Removal is much slower.  Reclaiming a 4K page in TD_TEARDOWN
state can be 5 times faster, although that is just one part of TD shutdown.

== Relevant TDX Architecture ==

Dynamic Page Removal is slow because it has to potentially deal with a
running TD, and so involves a number of steps:
	Block further address translation
	Exit each VCPU
	Clear Secure EPT entry
	Flush/write-back/invalidate relevant caches

Reclaiming TD Pages in TD_TEARDOWN State is fast because the shutdown
procedure (refer tdx_mmu_release_hkid()) has already performed the relevant
flushing.  For details, see TDX Module Base Spec October 2024 sections:

	7.5.   TD Teardown Sequence
	5.6.3. TD Keys Reclamation, TLB and Cache Flush

Essentially all that remains then is to take each page away from the
TDX Module and return it to the kernel.

== Problem ==

Currently, Dynamic Page Removal is being used when the TD is being
shutdown for the sake of having simpler initial code.

This happens when guest_memfds are closed, refer kvm_gmem_release().
guest_memfds hold a reference to struct kvm, so that VM destruction cannot
happen until after they are released, refer kvm_gmem_release().

Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
reclaim time.  For example:

	VCPUs	Size (GB)	Before (secs)	After (secs)
	 4	 18		 72		 24
	32	107		517		134

Note, the V19 patch set:

	https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@intel.com/

did not have this issue because the HKID was released early, something that
Sean effectively NAK'ed:

	"No, the right answer is to not release the HKID until the VM is
	destroyed."

	https://lore.kernel.org/all/ZN+1QHGa6ltpQxZn@google.com/

That was taken on board in the "TDX MMU Part 2" patch set.  Refer
"Moving of tdx_mmu_release_hkid()" in:

	https://lore.kernel.org/kvm/20240904030751.117579-1-rick.p.edgecombe@intel.com/

== Options ==

  1. Start TD teardown earlier so that when pages are removed,
  they can be reclaimed faster.
  2. Defer page removal until after TD teardown has started.
  3. A combination of 1 and 2.

Option 1 is problematic because it means putting the TD into a non-runnable
state while it is potentially still active. Also, as mentioned above, Sean
effectively NAK'ed it.

Option 2 is possible because the lifetime of guest memory pages is separate
from guest_memfd (struct kvm_gmem) lifetime.

A reference is taken to pages when they are faulted in, refer
kvm_gmem_get_pfn().  That reference is not released until the pages are
removed from the mirror SEPT, refer tdx_unpin().

Option 3 is not needed because TD teardown begins during VM destruction
before pages are reclaimed.  TD_TEARDOWN state is entered by
tdx_mmu_release_hkid(), whereas pages are reclaimed by tdp_mmu_zap_root(),
as follows:

    kvm_arch_destroy_vm()
        ...
        vt_vm_pre_destroy()
            tdx_mmu_release_hkid()
        ...
        kvm_mmu_uninit_vm()
            kvm_mmu_uninit_tdp_mmu()
                kvm_tdp_mmu_invalidate_roots()
                kvm_tdp_mmu_zap_invalidated_roots()
                    tdp_mmu_zap_root()

== Proof of Concept for option 2 ==

Assume user space never needs to close a guest_memfd except as part of VM
shutdown.

Add a callback from kvm_gmem_release() to decide whether to defer removal.
For TDX, record the inode (up to a max. of 64 inodes) and pin it.

Amend the release of guest_memfds to skip removing pages from the MMU
in that case.

Amend TDX private memory page removal to detect TD_TEARDOWN state, and
reclaim the page accordingly.

For TDX, finally unpin any pinned inodes.

This hopefully illustrates what needs to be done, but guidance is sought
for the best way to do it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 ++
 arch/x86/kvm/Kconfig               |  1 +
 arch/x86/kvm/vmx/main.c            | 12 +++++++-
 arch/x86/kvm/vmx/tdx.c             | 47 +++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/tdx.h             | 14 +++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 arch/x86/kvm/x86.c                 |  7 +++++
 include/linux/kvm_host.h           |  5 ++++
 virt/kvm/Kconfig                   |  4 +++
 virt/kvm/guest_memfd.c             | 26 ++++++++++++-----
 11 files changed, 107 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 79406bf07a1c..e4728f1fe646 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -148,6 +148,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP_OPTIONAL_RET0(gmem_defer_removal)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b9dde476f3c..d1afb4e1c2ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1661,6 +1661,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+struct inode;
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1888,6 +1890,7 @@ struct kvm_x86_ops {
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*gmem_defer_removal)(struct kvm *kvm, struct inode *inode);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 0d445a317f61..32c4b9922e7b 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,7 @@ config KVM_INTEL
 	depends on KVM && IA32_FEAT_CTL
 	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
 	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
+	select HAVE_KVM_ARCH_GMEM_DEFER_REMOVAL if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 94d5d907d37b..b835006e1282 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -888,6 +888,14 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	return 0;
 }
 
+static int vt_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
+{
+	if (is_td(kvm))
+		return tdx_gmem_defer_removal(kvm, inode);
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -1046,7 +1054,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
 	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 
-	.private_max_mapping_level = vt_gmem_private_max_mapping_level
+	.private_max_mapping_level = vt_gmem_private_max_mapping_level,
+
+	.gmem_defer_removal = vt_gmem_defer_removal,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d9eb20516c71..51bbb44ac1bd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 #include <asm/fpu/xcr.h>
 #include <linux/misc_cgroup.h>
 #include <linux/mmu_context.h>
+#include <linux/fs.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "mmu.h"
@@ -594,10 +595,20 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	kvm_tdx->td.tdr_page = NULL;
 }
 
+static void tdx_unpin_inodes(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	for (int i = 0; i < kvm_tdx->nr_gmem_inodes; i++)
+		iput(kvm_tdx->gmem_inodes[i]);
+}
+
 void tdx_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
+	tdx_unpin_inodes(kvm);
+
 	tdx_reclaim_td_control_pages(kvm);
 
 	kvm_tdx->state = TD_STATE_UNINITIALIZED;
@@ -1778,19 +1789,28 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return tdx_reclaim_page(virt_to_page(private_spt));
 }
 
+static int tdx_sept_teardown_private_spte(struct kvm *kvm, enum pg_level level, struct page *page)
+{
+	int ret;
+
+	if (level != PG_LEVEL_4K)
+		return -EINVAL;
+
+	ret = tdx_reclaim_page(page);
+	if (!ret)
+		tdx_unpin(kvm, page);
+
+	return ret;
+}
+
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn)
 {
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm)))
+		return tdx_sept_teardown_private_spte(kvm, level, pfn_to_page(pfn));
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
@@ -3221,6 +3241,19 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	return PG_LEVEL_4K;
 }
 
+int tdx_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	if (kvm_tdx->nr_gmem_inodes >= TDX_MAX_GMEM_INODES)
+		return 0;
+
+	kvm_tdx->gmem_inodes[kvm_tdx->nr_gmem_inodes++] = inode;
+	ihold(inode);
+
+	return 1;
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 6b3bebebabfa..fb5c4face131 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -20,6 +20,10 @@ enum kvm_tdx_state {
 	TD_STATE_RUNNABLE,
 };
 
+struct inode;
+
+#define TDX_MAX_GMEM_INODES 64
+
 struct kvm_tdx {
 	struct kvm kvm;
 
@@ -43,6 +47,16 @@ struct kvm_tdx {
 	 * Set/unset is protected with kvm->mmu_lock.
 	 */
 	bool wait_for_sept_zap;
+
+	/*
+	 * For pages that will not be removed until TD shutdown, the associated
+	 * guest_memfd inode is pinned.  Allow for a fixed number of pinned
+	 * inodes.  If there are more, then when the guest_memfd is closed,
+	 * their pages will be removed safely but inefficiently prior to
+	 * shutdown.
+	 */
+	struct inode *gmem_inodes[TDX_MAX_GMEM_INODES];
+	int nr_gmem_inodes;
 };
 
 /* TDX module vCPU states */
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 4704bed033b1..4ee123289d85 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -164,6 +164,7 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int tdx_gmem_defer_removal(struct kvm *kvm, struct inode *inode);
 #else
 static inline void tdx_disable_virtualization_cpu(void) {}
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -229,6 +230,7 @@ static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 static inline int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn) { return 0; }
+static inline int tdx_gmem_defer_removal(struct kvm *kvm, struct inode *inode) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03db366e794a..96ebf0303223 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13659,6 +13659,13 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 }
 #endif
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_DEFER_REMOVAL
+bool kvm_arch_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
+{
+	return kvm_x86_call(gmem_defer_removal)(kvm, inode);
+}
+#endif
+
 int kvm_spec_ctrl_test_value(u64 value)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d72ba0a4ca0e..f5c8b1923c24 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2534,6 +2534,11 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
 #endif
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_DEFER_REMOVAL
+struct inode;
+bool kvm_arch_gmem_defer_removal(struct kvm *kvm, struct inode *inode);
+#endif
+
 #ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
 /**
  * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..589111505ad0 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config HAVE_KVM_ARCH_GMEM_DEFER_REMOVAL
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..cd485f45fdaf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -248,6 +248,15 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 	return ret;
 }
 
+inline bool kvm_gmem_defer_removal(struct kvm *kvm, struct inode *inode)
+{
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_DEFER_REMOVAL
+	return kvm_arch_gmem_defer_removal(kvm, inode);
+#else
+	return false;
+#endif
+}
+
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct kvm_gmem *gmem = file->private_data;
@@ -275,13 +284,16 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	xa_for_each(&gmem->bindings, index, slot)
 		WRITE_ONCE(slot->gmem.file, NULL);
 
-	/*
-	 * All in-flight operations are gone and new bindings can be created.
-	 * Zap all SPTEs pointed at by this file.  Do not free the backing
-	 * memory, as its lifetime is associated with the inode, not the file.
-	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	if (!kvm_gmem_defer_removal(kvm, inode)) {
+		/*
+		 * All in-flight operations are gone and new bindings can be
+		 * created.  Zap all SPTEs pointed at by this file.  Do not free
+		 * the backing memory, as its lifetime is associated with the
+		 * inode, not the file.
+		 */
+		kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+		kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	}
 
 	list_del(&gmem->entry);
 
-- 
2.43.0


