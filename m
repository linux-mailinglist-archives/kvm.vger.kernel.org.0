Return-Path: <kvm+bounces-33071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DB69E462E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 22:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 794A8BA302E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365032066C7;
	Wed,  4 Dec 2024 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jOAxqi7F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761A11F1316
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339663; cv=none; b=najhQ9ww8p02QQ+TNtH8y7g/SPHbf3xCRUBFIOtFPD7LZNkP+D3gFOTbIZaxu0CU6nHJrFrUUGFgZlPbS4OmPUYhH9w3/KqxQgIQYkQR3hx8OQkK3rGeawwIQ/AxPZvfpw0xmqyXzFfnOfH+x1fkqaYIOmqyZB0vaI0h0k7gCtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339663; c=relaxed/simple;
	bh=XRqLRNPGp4B36Newh1hGDaGyYURJiyoWnca3tYrEiRo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ebkQS3q3elEy+w8oX/nSxX+6m5DZCd6gyanA1itaPgTm8ZuI+yQIkwgq7qax6/G6LTKojSnxx9LBh8UiW8tpLsTIWuDWDGX4X5X21QGtzR6b4yGRz8fGBsJBcv2FoYttm/EGREKvR03JTMAA9Q0EZE7R3G5bUG/q9RCj5dlvyEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jOAxqi7F; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-7b67a9aea08so11345685a.2
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339660; x=1733944460; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tFj98HJEqxlM2yS1YScvzRxxJLlbahOUdL6PgedEnEc=;
        b=jOAxqi7FUI8TWziOOADTcMJ+ff3QMXEPr5+U2QMXBrOHGN8+j/HLOsH2fLdk9ZHLvg
         A/zhy5KpMHbODaovtM7BBdDtJaD3vl4aMPs9CnaYQO2ud/dAV9/GN8mCA9XeUhMkIdTj
         oZs/otNILoTrv99SbEkkPlf3dXGRonlZQjWyIYPAn05CsfxOEJhve+1b/oEbBb50tyN4
         tc2qadAlZmM+mamEd7uci3YFrd/5XNE5ZxDkuQPZWFk9x/rAAeVsLlyRkgIRkSYIE6R+
         zcySB3ktJ9wQX/6Mf/ra/K1uTAvkNfOODxQz/10WL4tYuAfJKFnIW7SlGtyAR8jv2VJC
         47Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339660; x=1733944460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFj98HJEqxlM2yS1YScvzRxxJLlbahOUdL6PgedEnEc=;
        b=aIVApAvSu6EL4qRThgbcKxcgFRZtPIYaMi2NPFdK/biEeHVySIF0B9/YIGPNVOk5YA
         7I5AV631kRAdrwhXWFSeVe+g7a2T1WNFv/rwbnjkRDXH8rHKWzxlvxd72D8973+8KYuq
         l9v+TylcINZC+I06S91m4d69gS+8PBEG52PVGHAOYJxZGBjclebN37vZTlJ6FhDIuh42
         nQoexaR640/7rPJEQxHoBY7mGTFi6oOsoV++8q1FUPjCuKuaVNDoD2d1aLtKviHeUeX7
         U/5F5a8ofr2983qwmfzbjQN3cWtMzV3lKUNRpwVY9xjKpE7Ua1ldbk+jccnip9eeVWml
         /MnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0yejQjAnzAKmaIatvqR6HajyscyZmoDFpctFNdBzq5xTKzjtYywodK3PGuJ2IajmVDUk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx32jsd4WDtdatwNpwHG78wzEFZvOSiou2khh02RxMfhStz03YH
	aaWxS+g3d+6wTYvTI4YodyrDU1NeOSeNJeNXkFFtW+X2NVxs5OFFT00/MBjhMUCI15aEx8D2dYN
	kuW8VpUsKhOVZp2SLeQ==
X-Google-Smtp-Source: AGHT+IEjAFXSEtfmGOodffFw31TXE80vwkJvDLAFbZ3yUQDUssUZgM+UMQkcUbluyRy21fc1aO4FFwapwVcSSi9j
X-Received: from qtbci19.prod.google.com ([2002:a05:622a:2613:b0:462:aa34:aae2])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:3188:b0:7b6:73f5:2867 with SMTP id af79cd13be357-7b6a61c819cmr926705785a.44.1733339660438;
 Wed, 04 Dec 2024 11:14:20 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:40 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-6-jthoughton@google.com>
Subject: [PATCH v1 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Adhering to the requirements of KVM Userfault:

1. Zap all sptes for the memslot when KVM_MEM_USERFAULT is toggled on
   with kvm_arch_flush_shadow_memslot().
2. Only all PAGE_SIZE sptes while KVM_MEM_USERFAULT is enabled (for both
   normal/GUP memory and guest_memfd memory).
3. Reconstruct huge mappings when KVM_MEM_USERFAULT is toggled off with
   kvm_mmu_recover_huge_pages().

With the new logic in kvm_mmu_slot_apply_flags(), I've simplified the
two dirty-logging-toggle checks into one, and I have dropped the
WARN_ON() that was there.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          | 27 +++++++++++++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++---
 arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++++---------
 include/linux/kvm_host.h        |  5 ++++-
 5 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ea2c4f21c1ca..286c6825cd1c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_X86
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
+	select HAVE_KVM_USERFAULT
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22e7ad235123..2f7381255d11 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4292,14 +4292,19 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
+static u8 kvm_max_private_mapping_level(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					kvm_pfn_t pfn, u8 max_level,
+					int gmem_order)
 {
 	u8 req_max_level;
 
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
+	if (kvm_memslot_userfault(slot))
+		return PG_LEVEL_4K;
+
 	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
@@ -4336,8 +4341,10 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
-	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
-							 fault->max_level, max_order);
+	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->slot,
+							 fault->pfn,
+							 fault->max_level,
+							 max_order);
 
 	return RET_PF_CONTINUE;
 }
@@ -4346,6 +4353,18 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
+	int userfault;
+
+	userfault = kvm_gfn_userfault(vcpu->kvm, fault->slot, fault->gfn);
+	if (userfault < 0)
+		return userfault;
+	if (userfault) {
+		kvm_mmu_prepare_userfault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
+	if (kvm_memslot_userfault(fault->slot))
+		fault->max_level = PG_LEVEL_4K;
 
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b00abbe3f6cf..15705faa3b67 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -282,12 +282,26 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
-static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-						     struct kvm_page_fault *fault)
+static inline void __kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+						       struct kvm_page_fault *fault,
+						       bool is_userfault)
 {
 	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
 				      PAGE_SIZE, fault->write, fault->exec,
-				      fault->is_private);
+				      fault->is_private,
+				      is_userfault);
+}
+
+static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+						     struct kvm_page_fault *fault)
+{
+	__kvm_mmu_prepare_memory_fault_exit(vcpu, fault, false);
+}
+
+static inline void kvm_mmu_prepare_userfault_exit(struct kvm_vcpu *vcpu,
+						  struct kvm_page_fault *fault)
+{
+	__kvm_mmu_prepare_memory_fault_exit(vcpu, fault, true);
 }
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..2f7080fd6218 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13053,12 +13053,36 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	u32 new_flags = new ? new->flags : 0;
 	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
+	/*
+	 * When toggling KVM Userfault on, zap all sptes so that userfault-ness
+	 * will be respected at refault time. All new faults will only install
+	 * small sptes. Therefore, when toggling it off, recover hugepages.
+	 *
+	 * For MOVE and DELETE, there will be nothing to do, as the old
+	 * mappings will have already been deleted by
+	 * kvm_arch_flush_shadow_memslot().
+	 *
+	 * For CREATE, no mappings will have been created yet.
+	 */
+	if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
+	    (change == KVM_MR_FLAGS_ONLY)) {
+		if (old_flags & KVM_MEM_USERFAULT)
+			kvm_mmu_recover_huge_pages(kvm, new);
+		else
+			kvm_arch_flush_shadow_memslot(kvm, old);
+	}
+
+	/*
+	 * Nothing more to do if dirty logging isn't being toggled.
+	 */
+	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
+
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
-		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
+	kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
 	 * Nothing more to do for RO slots (which can't be dirtied and can't be
@@ -13078,14 +13102,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
-	/*
-	 * READONLY and non-flags changes were filtered out above, and the only
-	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
-	 * logging isn't being toggled on or off.
-	 */
-	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
-		return;
-
 	if (!log_dirty_pages) {
 		/*
 		 * Recover huge page mappings in the slot now that dirty logging
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f7a3dfd5e224..9e8a8dcf2b73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2465,7 +2465,8 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 						 gpa_t gpa, gpa_t size,
 						 bool is_write, bool is_exec,
-						 bool is_private)
+						 bool is_private,
+						 bool is_userfault)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
 	vcpu->run->memory_fault.gpa = gpa;
@@ -2475,6 +2476,8 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	vcpu->run->memory_fault.flags = 0;
 	if (is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
+	if (is_userfault)
+		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_USERFAULT;
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-- 
2.47.0.338.g60cca15819-goog


