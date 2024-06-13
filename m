Return-Path: <kvm+bounces-19542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40FF59063C9
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E40AB20DC4
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459081369BE;
	Thu, 13 Jun 2024 06:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jjkYfr3l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9871637C;
	Thu, 13 Jun 2024 06:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718259053; cv=none; b=lcVRtHrlceIWbEhQS8bdG41MOa1TNhbbzWM3PclEujPg9BrF/KdetCaGVuNRruJSXiSPpm1+BUHmJNVUKQZm4aXotW9Rcp6E2gjPMpA8G6W+ERChHUcvkAO7ZKu7NpxFXTQvBiqphRrGmEjUxd8PZrzeOnf2NUQaGHhh6vEneLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718259053; c=relaxed/simple;
	bh=GJW+aRbd3tyu56kqkS3E3JlIhZYvNb/UXv+q2wbBeig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LurtYKSX6NxQknPSlBP/l8FuRJkAtTuQoUwHnioMbpqXyLQ0bjG9dneAPCCdMwzNDrXdhXPm9CeLrVucHYBsQ4GopEel0dH13Iwx9fXl37dZsalMrFA36VZYzocuX5eCS3ZGWhQNjwoRfitty5hdGfbFOgvzKG3mlRXYtK38JKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jjkYfr3l; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718259052; x=1749795052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GJW+aRbd3tyu56kqkS3E3JlIhZYvNb/UXv+q2wbBeig=;
  b=jjkYfr3l8bex0Z3RutkC++l3gTJYwETsYSdrJ5naOqwfQwy1EuHWfjup
   IYQdvhdZQz3fr1BI6SmRhSe+VGj09AoaE1k91HAItQrwuQRxjsyT6/rnl
   Tw1i7F4jirRGCGUt6B+UqemA3sVlD61N44yhZqvMnGuMUhwef2KdMz+xi
   QzFLPJJxszmHLbNU/3jPL1s8suvY9qoFTE/1EOdKbgXFpgkn4mXSosfOE
   K9LlBIxQjjSkI0yfzd085KBvw6ng30zY+SMUmk41wBOHfdpImaaoMLwD1
   1nHGkYvlM17Dl2GN4BBdYyl1prcM6qjkmEnoHzraxWrRpOe9HJiRnTlEh
   g==;
X-CSE-ConnectionGUID: AO3LSsvuTvW21oYKgIECcA==
X-CSE-MsgGUID: yOxrJQI7Q+OM5SkVUONUJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="32598783"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="32598783"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:10:51 -0700
X-CSE-ConnectionGUID: u17XlQ0tTfCNQ7FVqmgU9Q==
X-CSE-MsgGUID: gRx5Dun+R2eTtjQ2cLBlew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="44476513"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:10:48 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/5] KVM: x86/mmu: Introduce a quirk to control memslot zap behavior
Date: Thu, 13 Jun 2024 14:09:46 +0800
Message-ID: <20240613060946.11806-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240613060708.11761-1-yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a quirk KVM_X86_QUIRK_SLOT_ZAP_ALL to allow users to choose
between enabling the quirk to invalidate/zap all SPTEs when a memslot is
moved/deleted and disabling the quirk to zap precisely/slowly of only leaf
SPTEs that are within the range of moving/deleting memslot.

The quirk is turned on by default. This is to work around a bug [1] where
the changing the zapping behavior of memslot move/deletion would cause VM
instability for VMs with an Nvidia GPU assigned.

Users have the option to deactivate the quirk for specific VMs that are
unaffected by this bug. Turning off the quirk enables a more precise
zapping of SPTEs within the memory slot range, enhancing performance for
certain scenarios [2] and meeting the functional requirements for TDX.
In TDX, it is crucial that the root page of the private page table remains
unchanged, with leaf entries being zapped before non-leaf entries.
Additionally, any pages dropped in TDX would necessitate their
re-acceptance by the guest.

Previously, an attempt was made to introduce a per-VM capability [3] as a
workaround for the bug. However, this approach was not preferred because
the root cause of the bug remained unidentified. An alternative solution
involving a per-memslot flag [4] was also considered but ultimately
rejected. Sean and Paolo thereafter recommended the implementation of this
quirk and explained that it's the least bad option [5].

For the quirk disabled case, add a new function kvm_mmu_zap_memslot_leafs()
to zap leaf SPTEs within a memslot when moving/deleting a memslot. Rather
than further calling kvm_unmap_gfn_range() for the actual zapping, this
function bypasses the special handling to APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.
This is based on the considerations that
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
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com [1]
Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com/#25054908 [2]
Link: https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#mabc0119583dacf621025e9d873c85f4fbaa66d5c [3]
Link: https://lore.kernel.org/all/20240515005952.3410568-3-rick.p.edgecombe@intel.com [4]
Link: https://lore.kernel.org/all/7df9032d-83e4-46a1-ab29-6c7973a2ab0b@redhat.com [5]
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 Documentation/virt/kvm/api.rst  |  6 ++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 36 ++++++++++++++++++++++++++++++++-
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebdf88078515..37b5ecb25778 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8146,6 +8146,12 @@ KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS By default, KVM emulates MONITOR/MWAIT (if
                                     guest CPUID on writes to MISC_ENABLE if
                                     KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is
                                     disabled.
+
+KVM_X86_QUIRK_SLOT_ZAP_ALL          By default, KVM invalidates all SPTEs in
+                                    fast way when a memslot is deleted.
+                                    When this quirk is disabled, KVM zaps only
+                                    leaf SPTEs that are within the range of the
+                                    memslot being deleted.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9499e3b5915..8152b5259435 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2383,7 +2383,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
-	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
+	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
+	 KVM_X86_QUIRK_SLOT_ZAP_ALL)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index f64421c55266..c5d189f9ca34 100644
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
index 1fd2f8ea6fab..6269fa315888 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6987,10 +6987,44 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
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
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_SLOT_ZAP_ALL))
+		kvm_mmu_zap_all_fast(kvm);
+	else
+		kvm_mmu_zap_memslot_leafs(kvm, slot);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
-- 
2.43.2


