Return-Path: <kvm+bounces-8839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC5E857207
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E272E1C227C2
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333FD146911;
	Thu, 15 Feb 2024 23:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PL4bwg+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735941468F3
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041260; cv=none; b=uVF6KSIkScKkvG0sE5MxmJJOFQojwczRm9LBTla/Py30gANd1+9UroUXyKuMQlp4EF7gVeH3ExvHWQqtIx3ut2oagRdAg13rU6XqpkFePIRupz+kDv3VSzr2lTJt/AseE67QqTQOmOOFefs7PA4va1FhziUrE5i8cFdC/fXN8c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041260; c=relaxed/simple;
	bh=SiM4xWXwUgH8LHEU5tPvjdfJ67jD/ky4OB4FJ6Uv42A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BK0YtK6gN6GNEiiJQqfV0mnqQVEo6B4lT1kKKeAoCcvFDbRs2koQJ1L/9IUup9f2ePE8OCJnkuPUBtO5a/gEpwUbPr++YUXfm3X6jvnNM/47RJ5ov9lhPfXoZ7WFlcDBp6DHm60GZuteJ27Q/XDvS36o6pfdfnKJQydLEtOHMmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PL4bwg+R; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60665b5fabcso21937177b3.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041257; x=1708646057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAJxKBXqL+4n0kIk41piMFkW8X85Amto6kELtwrWAcE=;
        b=PL4bwg+REztaGbJFDoXU4X093o817k6T05kpp1azMHLSh/t7api9SltmNrQWXSwlxp
         VfA8LvFNlkjeTyHEHNM9cYEIYAsJI+yHc5AuBYui8PZRP+w7BljNY+CCh6neOt5U/38j
         8OoZQxY3kkco2T95d8VNwzTkbteCZK9plI2/rmAs7LbTZTWecnCspqJTMgGIgROj6J3J
         37Cd08c+JKR8basO7A/phC6QBp01m3EIhl/I/Z5zFTxbNDcnzIAWDGfgDlPnupYOZC+m
         8fzUrWk/sRBs05FhKQlJYOnU/beJWBdPyscprxsJgYUfcZfSKhjHA5As0cAn2A8DifUT
         2p+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041257; x=1708646057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAJxKBXqL+4n0kIk41piMFkW8X85Amto6kELtwrWAcE=;
        b=PsfI9hNEdrMUFX5DjgNy4qc5Sv9JuREZj1KWCagx3+nY2Q/1t/AQkvtA3ylq8Rg/0H
         957EtucwfgHS19MSMzYm7DZ+qu4VYcAODmX99HCjkoeOIK9CW1j6C2RlCl4D67GwWe+n
         4PjYs8SOcMyxgxkx2kkcnJ+gVqIPO/4/uyIIYkNv6YWKCk/V2ioMtvlZbWktgP1PHdU8
         9+OdV0wumT8v96Eh30PtJiG7gzWYScL2sj37EgT2BdVbThjYjj/2dduWqEsAnmVM3EmD
         zfbCSTqMqJPVWNkx5+iIrDflR1+t39WSvRkRY+9j1Ug/kOsMo10/1gwcEW5bHOMNRvKE
         XHNw==
X-Forwarded-Encrypted: i=1; AJvYcCXFqmrOiLoQs6R17lD/g5FIwAwSO9DOXcdvy9ZFsoRpN3YX8nhP9Y8s9jKiiCbkUjWB2XvVzOPaHiqlcp3FywiUvMs+
X-Gm-Message-State: AOJu0YykGYBw9n0ibjYnNrTgQXZ2JwJPkkOWkG/gJxLToxNJ5/pbHMU4
	m/R7j7zgfk+Mf/cFL5Hh8YZ4ekyJaKrgNW+FQ9/BDaYZgohUHmdU1/4VXtquLHDNNrMjRm5SMkS
	wqHT8k6s+yg==
X-Google-Smtp-Source: AGHT+IHuZ+cGSAfo5UbiyCXCmX5lx9/UGynmyEuSN81yBH4E8SXDV9tAecXhS2EWPac9/g2KZv1J6mjRjtTShw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:24e:b0:607:9e9a:cba6 with SMTP
 id ba14-20020a05690c024e00b006079e9acba6mr558060ywb.8.1708041257497; Thu, 15
 Feb 2024 15:54:17 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:57 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-7-amoorthy@google.com>
Subject: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an exit
 on missing hva mappings
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Allowing KVM to fault in pages during vcpu-context guest memory accesses
can be undesirable: during userfaultfd-based postcopy, it can cause
significant performance issues due to vCPUs contending for
userfaultfd-internal locks.

Add a new memslot flag (KVM_MEM_EXIT_ON_MISSING) through which userspace
can indicate that KVM_RUN should exit instead of faulting in pages
during vcpu-context guest memory accesses. The unfaulted pages are
reported by the accompanying KVM_EXIT_MEMORY_FAULT_INFO, allowing
userspace to determine and take appropriate action.

The basic implementation strategy is to check the memslot flag from
within __gfn_to_pfn_memslot() and override the caller-provided arguments
accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
out of this behavior, and do so by passing can_exit_on_missing=false.

No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING or
passes can_exit_on_missing=true to __gfn_to_pfn_memslot().

Suggested-by: James Houghton <jthoughton@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst         | 23 +++++++++++++++++-
 arch/arm64/kvm/mmu.c                   |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 |  4 ++--
 include/linux/kvm_host.h               | 12 +++++++++-
 include/uapi/linux/kvm.h               |  2 ++
 virt/kvm/Kconfig                       |  3 +++
 virt/kvm/kvm_main.c                    | 32 ++++++++++++++++++++++----
 9 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f5d45c49e36..bf7bc21d56ac 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1353,6 +1353,7 @@ yet and must be cleared on entry.
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
   #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
+  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1383,7 +1384,7 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports three flags
+The flags field supports four flags
 
 1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
@@ -1393,6 +1394,7 @@ to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
 3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
 incompatible with KVM_SET_USER_MEMORY_REGION.
+4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -1408,6 +1410,9 @@ Instead, an abort (data abort if the cause of the page-table update
 was a load or a store, instruction abort if it was an instruction
 fetch) is injected in the guest.
 
+Note: KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING are currently mutually
+exclusive.
+
 4.36 KVM_SET_TSS_ADDR
 ---------------------
 
@@ -8044,6 +8049,22 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.35 KVM_CAP_EXIT_ON_MISSING
+----------------------------
+
+:Architectures: None
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that userspace may set the
+KVM_MEM_EXIT_ON_MISSING flag on memslots. Said flag will cause KVM_RUN to fail
+(-EFAULT) in response to guest-context memory accesses which would require KVM
+to page fault on the userspace mapping.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO. Userspace should take appropriate action.
+This could mean, for instance, checking that the fault is resolvable, faulting
+in the relevant userspace mapping, then retrying KVM_RUN.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d14504821b79..dfe0cbb5937c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1487,7 +1487,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-				   write_fault, &writable, NULL);
+				   write_fault, &writable, false, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 2b1f0cdd8c18..31ebfe4fe8e1 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -614,7 +614,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, &write_ok, NULL);
+					   writing, &write_ok, false, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 4a1abb9f7c05..03b0f1c4a0d8 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -853,7 +853,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, upgrade_p, NULL);
+					   writing, upgrade_p, false, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d6cdeab1f8a..b89a9518f6de 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4371,7 +4371,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	async = false;
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  false, &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
 
@@ -4393,7 +4393,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  false, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32cbe5c3a9d1..210e07c4c2eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1216,7 +1216,8 @@ kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva);
+			       bool write_fault, bool *writable,
+			       bool can_exit_on_missing, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
@@ -2394,4 +2395,13 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+/*
+ * Whether vCPUs should exit upon trying to access memory for which the
+ * userspace mappings are missing.
+ */
+static inline bool kvm_is_slot_exit_on_missing(const struct kvm_memory_slot *slot)
+{
+	return slot && slot->flags & KVM_MEM_EXIT_ON_MISSING;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 36a51b162a71..e9f33ae93dee 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_EXIT_ON_MISSING	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -920,6 +921,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_EXIT_ON_MISSING 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 29b73eedfe74..c7bdde127af4 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,3 +109,6 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_EXIT_ON_MISSING
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67ca580a18c5..469b99898be8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1600,7 +1600,7 @@ static void kvm_replace_memslot(struct kvm *kvm,
  * only allows these.
  */
 #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
-	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
+	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY | KVM_MEM_EXIT_ON_MISSING)
 
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
@@ -1618,8 +1618,14 @@ static int check_memory_region_flags(struct kvm *kvm,
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING))
+		valid_flags |= KVM_MEM_EXIT_ON_MISSING;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
+	else if ((mem->flags & KVM_MEM_READONLY) &&
+		 (mem->flags & KVM_MEM_EXIT_ON_MISSING))
+		return -EINVAL;
 
 	return 0;
 }
@@ -3024,7 +3030,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool interruptible, bool *async,
-			       bool write_fault, bool *writable, hva_t *hva)
+			       bool write_fault, bool *writable,
+			       bool can_exit_on_missing, hva_t *hva)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
@@ -3047,6 +3054,19 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
+	/* When the slot is exit-on-missing (and when we should respect that)
+	 * set atomic=true to prevent GUP from faulting in the userspace
+	 * mappings.
+	 */
+	if (!atomic && can_exit_on_missing &&
+	    kvm_is_slot_exit_on_missing(slot)) {
+		atomic = true;
+		if (async) {
+			*async = false;
+			async = NULL;
+		}
+	}
+
 	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
 			  writable);
 }
@@ -3056,21 +3076,21 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    NULL, write_fault, writable, NULL);
+				    NULL, write_fault, writable, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, false, false, NULL, true,
-				    NULL, NULL);
+				    NULL, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	return __gfn_to_pfn_memslot(slot, gfn, true, false, NULL, true,
-				    NULL, NULL);
+				    NULL, false, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
@@ -4877,6 +4897,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
+	case KVM_CAP_EXIT_ON_MISSING:
+		return IS_ENABLED(CONFIG_HAVE_KVM_EXIT_ON_MISSING);
 	default:
 		break;
 	}
-- 
2.44.0.rc0.258.g7320e95886-goog


