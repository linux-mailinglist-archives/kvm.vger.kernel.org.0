Return-Path: <kvm+bounces-20860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BDF924D83
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A0E8B2263D
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295414A3D;
	Wed,  3 Jul 2024 02:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mrg5nZdI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7CB804;
	Wed,  3 Jul 2024 02:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972719; cv=none; b=A8tf+ugTpWAmGETu7G0NWVoipbuueRLvmRaI3mNW3hGjSH/jXPJZQ8E4Dk/OXH8GYJKfgn6u9VWHlN+O6ykjhzDFTBfH3shZgPfghFKqtVmuzxH1U7hFb31Du1AAfbJc7TXzpLmm7HXZ433WWgtwH/UnSuJA0kyGnm1gxCSNvHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972719; c=relaxed/simple;
	bh=kgLkCpqeqOjiWLRYxV0BkD9lcckC7zExjBK2eaxI6gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRSsZ9C7CHpnKMj53ZVCn0L9KkDTvTAERmePJa2EO4HdjGJBQbzDYmIdT5lVN2r2EavMwwNO7nP0IjPPzJEIsY6C2/36Lo3NXG2OevQe6E2ePWmsuPc/Ic4/woeGHJlO/7JAUEeibTUb7qVG8/13LntxDX8D+vrFn2im6l2RNYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mrg5nZdI; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972717; x=1751508717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kgLkCpqeqOjiWLRYxV0BkD9lcckC7zExjBK2eaxI6gk=;
  b=Mrg5nZdIKemmnB+JCypZqDyzoG5ysmvHpuiy6uMx1S4LWyhf1jwwCjoB
   riiPGVi8UxiXKM/Yb6QQ3NoVwHEP+NYQw0xYtfQP0zAxR2kPSoym1BnoU
   Caw4wdngx1saAAnEdoxfvBt1iJG66d+lsfdRx2nZjedDcDw90zcFJEYVQ
   rdkfS7vKscB35VN3PO4r4P2d0732ByEpBJ2ZalbTPciQN0z+Jkv22UMSE
   A9dpoAjXWPt9Ay7Oj4nU8An7zDhGRdoXgOPYqEeu6UxX0gTiPuTsMDNFD
   Z1p7LLF9plfofIG6niLvF0u0qj+1A7tx3jpaAIgP7Z2gPV3rMahop6rak
   w==;
X-CSE-ConnectionGUID: EChH3yp8QfyoUWgVwxPVhw==
X-CSE-MsgGUID: hHQJW2yTQSyuNzdJgzQblg==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="16836879"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="16836879"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:11:56 -0700
X-CSE-ConnectionGUID: i68/W8MPRZ60yNf7ZR9ngA==
X-CSE-MsgGUID: b67YupYzTK6IjH2dXydVUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46832146"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:11:54 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/4] KVM: x86/mmu: Introduce a quirk to control memslot zap behavior
Date: Wed,  3 Jul 2024 10:10:43 +0800
Message-ID: <20240703021043.13881-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240703020921.13855-1-yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the quirk KVM_X86_QUIRK_SLOT_ZAP_ALL to allow users to select
KVM's behavior when a memslot is moved or deleted for KVM_X86_DEFAULT_VM
VMs. Make sure KVM behave as if the quirk is always disabled for
non-KVM_X86_DEFAULT_VM VMs.

The KVM_X86_QUIRK_SLOT_ZAP_ALL quirk offers two behavior options:
- when enabled:  Invalidate/zap all SPTEs ("zap-all"),
- when disabled: Precisely zap only the leaf SPTEs within the range of the
                 moving/deleting memory slot ("zap-slot-leafs-only").

"zap-all" is today's KVM behavior to work around a bug [1] where the
changing the zapping behavior of memslot move/deletion would cause VM
instability for VMs with an Nvidia GPU assigned; while
"zap-slot-leafs-only" allows for more precise zapping of SPTEs within the
memory slot range, improving performance in certain scenarios [2], and
meeting the functional requirements for TDX.

Previous attempts to select "zap-slot-leafs-only" include a per-VM
capability approach [3] (which was not preferred because the root cause of
the bug remained unidentified) and a per-memslot flag approach [4]. Sean
and Paolo finally recommended the implementation of this quirk and
explained that it's the least bad option [5].

By default, the quirk is enabled on KVM_X86_DEFAULT_VM VMs to use
"zap-all". Users have the option to disable the quirk to select
"zap-slot-leafs-only" for specific KVM_X86_DEFAULT_VM VMs that are
unaffected by this bug.

For non-KVM_X86_DEFAULT_VM VMs, the "zap-slot-leafs-only" behavior is
always selected without user's opt-in, regardless of if the user opts for
"zap-all".
This is because it is assumed until proven otherwise that non-
KVM_X86_DEFAULT_VM VMs will not be exposed to the bug [1], and most
importantly, it's because TDX must have "zap-slot-leafs-only" always
selected. In TDX's case a memslot's GPA range can be a mixture of "private"
or "shared" memory. Shared is roughly analogous to how EPT is handled for
normal VMs, but private GPAs need lots of special treatment:
1) "zap-all" would require to zap private root page or non-leaf entries or
   at least leaf-entries beyond the deleting memslot scope. However, TDX
   demands that the root page of the private page table remains unchanged,
   with leaf entries being zapped before non-leaf entries, and any dropped
   private guest pages must be re-accepted by the guest.
2) if "zap-all" zaps only shared page tables, it would result in private
   pages still being mapped when the memslot is gone. This may affect even
   other processes if later the gmem fd was whole punched, causing the
   pages being freed on the host while still mapped in the TD, because
   there's no pgoff to the gfn information to zap the private page table
   after memslot is gone.

So, simply go "zap-slot-leafs-only" as if the quirk is always disabled for
non-KVM_X86_DEFAULT_VM VMs to avoid manual opt-in for every VM type [6] or
complicating quirk disabling interface (current quirk disabling interface
is limited, no way to query quirks, or force them to be disabled).

Add a new function kvm_mmu_zap_memslot_leafs() to implement
"zap-slot-leafs-only". This function does not call kvm_unmap_gfn_range(),
bypassing special handling to APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, as
1) The APIC_ACCESS_PAGE_PRIVATE_MEMSLOT cannot be created by users, nor can
   it be moved. It is only deleted by KVM when APICv is permanently
   inhibited.
2) kvm_vcpu_reload_apic_access_page() effectively does nothing when
   APIC_ACCESS_PAGE_PRIVATE_MEMSLOT is deleted.
3) Avoid making all cpus request of KVM_REQ_APIC_PAGE_RELOAD can save on
   costly IPIs.

Suggested-by: Kai Huang <kai.huang@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com [1]
Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com/#25054908 [2]
Link: https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#mabc0119583dacf621025e9d873c85f4fbaa66d5c [3]
Link: https://lore.kernel.org/all/20240515005952.3410568-3-rick.p.edgecombe@intel.com [4]
Link: https://lore.kernel.org/all/7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com [5]
Link: https://lore.kernel.org/all/ZnGa550k46ow2N3L@google.com [6]
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 Documentation/virt/kvm/api.rst  |  8 +++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 42 ++++++++++++++++++++++++++++++++-
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..7c1248142a5a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7997,6 +7997,14 @@ KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS By default, KVM emulates MONITOR/MWAIT (if
                                     guest CPUID on writes to MISC_ENABLE if
                                     KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is
                                     disabled.
+
+KVM_X86_QUIRK_SLOT_ZAP_ALL          By default, KVM invalidates all SPTEs in
+                                    fast way for memslot deletion when VM type
+                                    is KVM_X86_DEFAULT_VM.
+                                    When this quirk is disabled or when VM type
+                                    is other than KVM_X86_DEFAULT_VM, KVM zaps
+                                    only leaf SPTEs that are within the range of
+                                    the memslot being deleted.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bb2e164c523..a40577911744 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2327,7 +2327,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
-	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
+	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
+	 KVM_X86_QUIRK_SLOT_ZAP_ALL)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 988b5204d636..6a399859c42d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -438,6 +438,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
+#define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1432deb75cbb..be3a82a32295 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6915,10 +6915,50 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_mmu_zap_all(kvm);
 }
 
+/*
+ * Zapping leaf SPTEs with memslot range when a memslot is moved/deleted.
+ *
+ * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
+ * case scenario we'll have unused shadow pages lying around until they
+ * are recycled due to age or when the VM is destroyed.
+ */
+static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_gfn_range range = {
+		.slot = slot,
+		.start = slot->base_gfn,
+		.end = slot->base_gfn + slot->npages,
+		.may_block = true,
+	};
+	bool flush = false;
+
+	write_lock(&kvm->mmu_lock);
+
+	if (kvm_memslots_have_rmaps(kvm))
+		flush = kvm_handle_gfn_range(kvm, &range, kvm_zap_rmap);
+
+	if (tdp_mmu_enabled)
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
+
+	if (flush)
+		kvm_flush_remote_tlbs_memslot(kvm, slot);
+
+	write_unlock(&kvm->mmu_lock);
+}
+
+static inline bool kvm_memslot_flush_zap_all(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_DEFAULT_VM &&
+	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+}
+
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	if (kvm_memslot_flush_zap_all(kvm))
+		kvm_mmu_zap_all_fast(kvm);
+	else
+		kvm_mmu_zap_memslot_leafs(kvm, slot);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
-- 
2.43.2


