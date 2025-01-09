Return-Path: <kvm+bounces-34958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F38AA081AC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C05A3A75A9
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EE52063C5;
	Thu,  9 Jan 2025 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R4sFoSJz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F59204F8C
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455802; cv=none; b=P1dnanFGuSMcALMzbvWFDbo5xSy3tfLYDQlTUf0Gr9N7z2pxCD57JnzdIthSviP3QAYkwYGq8w5vKyN40PrUFs8bSzQuwoHxA13oQyPNcm73tMf0gt66HdcHVifQFBG1oqqxhQ4NkdjvXsbXX5RQORgQkNyqO2SnJrw5OSEE06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455802; c=relaxed/simple;
	bh=TwC+lxLuP7IoW1MiOmdDsx36ofsqO5AeypzfePzITWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z4R1TcDvvLhumlgTHDnBApD7AVpo0otwEy/xgwGh7loqh4WBzLUKFE4vYbwA4INY4waH19VbyGyCs3QhFFSLi051Zz8o5KCIYBM4ZjxxUlRPUT533fjGRuLBlGz58o1nJf2BmaDtxR2f+LXmbkOJTD5EiKb8WafYpyNJmjq2nJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R4sFoSJz; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4b1013c826aso184090137.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455799; x=1737060599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HQeKkaeKNAINyBb7M+Oe0wr1NoWCGD3LtUC6EAysWvA=;
        b=R4sFoSJz4a691lRggESbr2D1UtwTSSdaNZT9N5+5cBtrglYNkYlnQGihDPTNs4yFq3
         GC+sbF71Lv4vKPrJtp6g6hk6QEQFgJ0A3k2sBKjarb24hDHZxwDDmKrgTd3Rd8t6KMG2
         tNRdJIaMPY5gcCpU/G+h5P1q8GiwzvEwmQMnvEb1ZLps72ANJNkG5WDQkyVhilr9HnXQ
         dGBdJg24ZEi6QoruHuUpl8vAdB9Vp64HVOLeaIEX03RJ6HlEWyl8ATzR2VJ2uArHM1JZ
         bj0yIfFMQdT0EEWnsSE4SM/jXFspgMmZC58ox3h3X93nlqmH9cur3TMb7VQD4D8sZ7cl
         gecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455799; x=1737060599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQeKkaeKNAINyBb7M+Oe0wr1NoWCGD3LtUC6EAysWvA=;
        b=thHhsVreV1yKDRPsr9zw43CwEZe1A5xf40+IIdspnSHIOkILGya2iM5zF6hI9CV+Zf
         vkK9fmu8njBpPYaefxeeO7e32Ms0EdLpskK844J2Y6pzJkm/SgZcnVRgxYXW/EHef4VC
         spaqAFNpgcBjuz3LkV7orGHDT0IRgTdWgtdR+BuTkOUBxKy+AYBY8ugjOloY7DFBSKh4
         GLxn4wCSRHyLmo72ZVFbx0MNYlzVWEN1CVYz/oXBCSxwmFIlR/GuLKAJWjBsr/7yhIUw
         Z23grs6I+a7JW+K/2n5OJ3OU8XZYu7I35ZP7ek1aBr5hIIuBexgmgoT0zmvNKLPsew0w
         39DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDsSfAsuh52U8DiUOcFdXcuOaIttKH3TeVPvAshKtJVGKLAbdxVOACTScsTmoSjM11LIU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2MH7EijxSFp2ycFYnHFRHDr5W6TfLtT29HxAPbd3npeV6830w
	YKUqjNzlXzXZML7jE3VTWIVSUst6EKrOibmUWPbS1Cm31D8BOif1nCYIzGmqFmHMopBPRA9zSpr
	iGKOZa1qCtNPmU/OBDA==
X-Google-Smtp-Source: AGHT+IE1KR8Jo0njtEmz2wd6kPBO+ZySo59zWwIng47TZxzkw4plAazjZ+t5031NO6mP2E11kmCWbmDTOkkQK6kQ
X-Received: from vsig20.prod.google.com ([2002:a05:6102:9d4:b0:4b2:cc7a:f725])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:509f:b0:4b2:5d10:58f1 with SMTP id ada2fe7eead31-4b3d0f9d056mr8432287137.11.1736455799217;
 Thu, 09 Jan 2025 12:49:59 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:21 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-6-jthoughton@google.com>
Subject: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Adhering to the requirements of KVM Userfault:

1. Zap all sptes for the memslot when KVM_MEM_USERFAULT is toggled on
   with kvm_arch_flush_shadow_memslot().
2. Only all PAGE_SIZE sptes when KVM_MEM_USERFAULT is enabled (for both
   normal/GUP memory and guest_memfd memory).
3. Reconstruct huge mappings when KVM_MEM_USERFAULT is toggled off with
   kvm_mmu_recover_huge_pages(). This is the behavior when dirty logging
   is disabled; remain consistent with it.

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
index 2401606db260..5cab2785b97f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4280,14 +4280,19 @@ static inline u8 kvm_max_level_for_order(int order)
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
@@ -4324,8 +4329,10 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
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
@@ -4334,6 +4341,18 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
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
index 1b04092ec76a..2abb425a6514 100644
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
2.47.1.613.gc27f4b7a9f-goog


