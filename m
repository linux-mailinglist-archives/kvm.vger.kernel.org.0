Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9023F5435
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 02:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhHXAxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 20:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhHXAxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 20:53:52 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6132C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 17:53:08 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id s206-20020a3745d70000b02903b9207abc7bso13090347qka.4
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 17:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=7Bj9O+NGglPUzfSNB9km4DcNB8gZ8RN1hK+4xg4gXdk=;
        b=YJuis4XG0x2TEcoj2yW2MQyGQuyOk/omPgq6rmBQvLFYfg5WP6HYBEoW7tvTXmnuoR
         c5Tl/euU7S/ZUraCEU9b6icmtpS1OdAfKWls4EMLL4bmTxr/gW31bgRt6tdfUX7jN7lU
         dpVJESXKmeosYWuiwvjzpKXzFzLmjvEFUBKE+wBvu4H6HMKVH6KRYwzBLVcQB4hLIw+x
         ExxRavrl0JiDOvjuJy3TYteErsiNc7vZPpgPRIIHYlBPyMiz+FaJHqw7doxC0q71p5Vm
         c/AJHToqBYq+okf7rI2/aA+vdw8n7Y9yo64dZzdVH+5nCsbDTZGCjkBuJlSWXYxRoxnq
         flxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=7Bj9O+NGglPUzfSNB9km4DcNB8gZ8RN1hK+4xg4gXdk=;
        b=LbwG2sYN+2Cjp3TzvJqAzAuQf4VYhaygIrveKtIoZ8EOBTSqI/9sT+aDVmPKr7cOtK
         OTvsk0moxsuNTqqHZ1PWWsTPsnDvdMzw2Gf65eI10racPzw5/1fwxLK0rHRj9noL0hGh
         dzcyhuhwv0DL20tdiN7ptoe36Lax6QfvazSoU5QwIzS+pykEYRMQnTqmO1R3YB7P+8jo
         CdoKCpLUDKNZ1DD3gV5aMDty2Um2h+btU5TrlqXzbRAm8eUTOrs3SOMl5tI2kvp2NfgH
         oB0OcYeDLc81iOQCzVxSw1QDBjsJU1nNr3XyI03aFAxO2AbTlbUGsIm5utk4P0WzwS9V
         5W+g==
X-Gm-Message-State: AOAM530VGUCi3QMyyEggvRjXYR7CLffezdRoZ5MR+mpxDRoCWNXADi5R
        MmKOLaUi29MvSaDnC5NH0b1/TQCjdL4=
X-Google-Smtp-Source: ABdhPJxy9hK9edahdAonhesCD/Cbr2HOfL0SPoZCy/IXT8GIyqhvRtEQnX9MZLZTpTqTHxPMEEPxwJMIrXU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:109c:7eb8:d5ed:2e59])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1382:: with SMTP id
 g2mr35833771qvz.14.1629766387891; Mon, 23 Aug 2021 17:53:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Aug 2021 17:52:48 -0700
Message-Id: <20210824005248.200037-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [RFC] KVM: mm: fd-based approach for supporting KVM guest private memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The goal of this RFC is to try and align KVM, mm, and anyone else with skin in the
game, on an acceptable direction for supporting guest private memory, e.g. for
Intel's TDX.  The TDX architectural effectively allows KVM guests to crash the
host if guest private memory is accessible to host userspace, and thus does not
play nice with KVM's existing approach of pulling the pfn and mapping level from
the host page tables.

This is by no means a complete patch; it's a rough sketch of the KVM changes that
would be needed.  The kernel side of things is completely omitted from the patch;
the design concept is below.

There's also fair bit of hand waving on implementation details that shouldn't
fundamentally change the overall ABI, e.g. how the backing store will ensure
there are no mappings when "converting" to guest private.

Background
==========

This is a loose continuation of Kirill's RFC[*] to support TDX guest private
memory by tracking guest memory at the 'struct page' level.  This proposal is the
result of several offline discussions that were prompted by Andy Lutomirksi's
concerns with tracking via 'struct page':

  1. The kernel wouldn't easily be able to enforce a 1:1 page:guest association,
     let alone a 1:1 pfn:gfn mapping.

  2. Does not work for memory that isn't backed by 'struct page', e.g. if devices
     gain support for exposing encrypted memory regions to guests.

  3. Does not help march toward page migration or swap support (though it doesn't
     hurt either).

[*] https://lkml.kernel.org/r/20210416154106.23721-1-kirill.shutemov@linux.intel.com

Concept
=======

Guest private memory must be backed by an "enlightened" file descriptor, where
"enlightened" means the implementing subsystem supports a one-way "conversion" to
guest private memory and provides bi-directional hooks to communicate directly
with KVM.  Creating a private fd doesn't necessarily have to be a conversion, e.g. it
could also be a flag provided at file creation, a property of the file system itself,
etc...

Before a private fd can be mapped into a KVM guest, it must be paired 1:1 with a
KVM guest, i.e. multiple guests cannot share a fd.  At pairing, KVM and the fd's
subsystem exchange a set of function pointers to allow KVM to call into the subsystem,
e.g. to translate gfn->pfn, and vice versa to allow the subsystem to call into KVM,
e.g. to invalidate/move/swap a gfn range.

Mapping a private fd in host userspace is disallowed, i.e. there is never a host
virtual address associated with the fd and thus no userspace page tables pointing
at the private memory.

Pinning _from KVM_ is not required.  If the backing store supports page migration
and/or swap, it can query the KVM-provided function pointers to see if KVM supports
the operation.  If the operation is not supported (this will be the case initially
in KVM), the backing store is responsible for ensuring correct functionality.

Unmapping guest memory, e.g. to prevent use-after-free, is handled via a callback
from the backing store to KVM.  KVM will employ techniques similar to those it uses
for mmu_notifiers to ensure the guest cannot access freed memory.

A key point is that, unlike similar failed proposals of the past, e.g. /dev/mktme,
existing backing stores can be englightened, a from-scratch implementations is not
required (though would obviously be possible as well).

One idea for extending existing backing stores, e.g. HugeTLBFS and tmpfs, is
to add F_SEAL_GUEST, which would convert the entire file to guest private memory
and either fail if the current size is non-zero or truncate the size to zero.

KVM
===

Guest private memory is managed as a new address space, i.e. as a different set of
memslots, similar to how KVM has a separate memory view for when a guest vCPU is
executing in virtual SMM.  SMM is mutually exclusive with guest private memory.

The fd (the actual integer) is provided to KVM when a private memslot is added
via KVM_SET_USER_MEMORY_REGION.  This is when the aforementioned pairing occurs.

By default, KVM memslot lookups will be "shared", only specific touchpoints will
be modified to work with private memslots, e.g. guest page faults.  All host
accesses to guest memory, e.g. for emulation, will thus look for shared memory
and naturally fail without attempting copy_to/from_user() if the guest attempts
to coerce KVM into access private memory.  Note, avoiding copy_to/from_user() and
friends isn't strictly necessary, it's more of a happy side effect.

A new KVM exit reason, e.g. KVM_EXIT_MEMORY_ERROR, and data struct in vcpu->run
is added to propagate illegal accesses (see above) and implicit conversions
to userspace (see below).  Note, the new exit reason + struct can also be to
support several other feature requests in KVM[1][2].

The guest may explicitly or implicity request KVM to map a shared/private variant
of a GFN.  An explicit map request is done via hypercall (out of scope for this
proposal as both TDX and SNP ABIs define such a hypercall).  An implicit map request
is triggered simply by the guest accessing the shared/private variant, which KVM
sees as a guest page fault (EPT violation or #NPF).  Ideally only explicit requests
would be supported, but neither TDX nor SNP require this in their guest<->host ABIs.

For implicit or explicit mappings, if a memslot is found that fully covers the
requested range (which is a single gfn for implicit mappings), KVM's normal guest
page fault handling works with minimal modification.

If a memslot is not found, for explicit mappings, KVM will exit to userspace with
the aforementioned dedicated exit reason.  For implict _private_ mappings, KVM will
also immediately exit with the same dedicated reason.  For implicit shared mappings,
an additional check is required to differentiate between emulated MMIO and an
implicit private->shared conversion[*].  If there is an existing private memslot
for the gfn, KVM will exit to userspace, otherwise KVM will treat the access as an
emulated MMIO access and handle the page fault accordingly.

[1] https://lkml.kernel.org/r/YKxJLcg/WomPE422@google.com
[2] https://lkml.kernel.org/r/20200617230052.GB27751@linux.intel.com

Punching Holes
==============

The expected userspace memory model is that mapping requests will be handled as
conversions, e.g. on a shared mapping request, first unmap the private gfn range,
then map the shared gfn range.  A new KVM ioctl() will likely be needed to allow
userspace to punch a hole in a memslot, as expressing such an operation isn't
possible with KVM_SET_USER_MEMORY_REGION.  While userspace could delete the
memslot, then recreate three new memslots, doing so would be destructive to guest
data as unmapping guest private memory (from the EPT/NPT tables) is destructive
to the data for both TDX and SEV-SNP guests.

Pros (vs. struct page)
======================

Easy to enforce 1:1 fd:guest pairing, as well as 1:1 gfn:pfn mapping.

Userspace page tables are not populated, e.g. reduced memory footprint, lower
probability of making private memory accessible to userspace.

Provides line of sight to supporting page migration and swap.

Provides line of sight to mapping MMIO pages into guest private memory.

Cons (vs. struct page)
======================

Significantly more churn in KVM, e.g. to plumb 'private' through where needed,
support memslot hole punching, etc...

KVM's MMU gets another method of retrieving host pfn and page size.

Requires enabling in every backing store that someone wants to support.

Because the NUMA APIs work on virtual addresses, new syscalls fmove_pages(),
fbind(), etc... would be required to provide equivalents to existing NUMA
functionality (though those syscalls would likely be useful irrespective of guest
private memory).

Washes (vs. struct page)
========================

A misbehaving guest that triggers a large number of shared memory mappings will
consume a large number of memslots.  But, this is likely a wash as similar effect
would happen with VMAs in the struct page approach.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Varad Gautam <varad.gautam@suse.com>
Cc: Dario Faggioli <dfaggioli@suse.com>
Cc: x86@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-coco@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++---
 arch/x86/include/uapi/asm/kvm.h |  4 ++++
 arch/x86/kvm/mmu.h              |  3 +++
 arch/x86/kvm/mmu/mmu.c          | 26 ++++++++++++++++++++--
 include/linux/kvm_host.h        | 24 ++++++++++++++++++---
 include/uapi/linux/kvm.h        |  4 ++++
 virt/kvm/kvm_main.c             | 38 ++++++++++++++++++++++++++++-----
 7 files changed, 93 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20daaf67a5bf..5ab6e5e9f38b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1810,10 +1810,11 @@ enum {
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 7)
 
 #define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
-#define KVM_ADDRESS_SPACE_NUM 2
+#define KVM_ADDRESS_SPACE_NUM 3
 
-#define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
-#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
+#define kvm_arch_vcpu_memslots_id(vcpu, private)	\
+	(((vcpu)->arch.hflags & HF_SMM_MASK) ? 1 : (!!private) << 1)
+#define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm | (role).private << 1)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a6c327f8ad9e..600bf108741d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -53,6 +53,10 @@
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
+#define KVM_DEFAULT_ADDRESS_SPACE	0
+#define KVM_SMM_ADDRESS_SPACE		1
+#define KVM_PRIVATE_ADDRESS_SPACE	2
+
 struct kvm_memory_alias {
 	__u32 slot;  /* this has a different namespace than memory slots */
 	__u32 flags;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ce369a533800..fc620eda27fd 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -127,6 +127,9 @@ struct kvm_page_fault {
 	const bool rsvd;
 	const bool user;
 
+	/* Guest private, derived from error_code (SNP) or gfn (TDX). */
+	const bool private;
+
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
 	const bool nx_huge_page_workaround_enabled;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a272ccbddfa1..771080235b2d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2896,6 +2896,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
+	if (memslot_is_private(slot))
+		return slot->private_ops->pfn_mapping_level(...);
+
 	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
 	return min(host_level, max_level);
 }
@@ -3835,9 +3838,11 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault, int *r)
 {
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
+	struct kvm_memory_slot *slot;
 	bool async;
 
+	slot = __kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn, fault->private);
+
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
 	 * or moved.  This ensures any existing SPTEs for the old memslot will
@@ -3846,8 +3851,19 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
 		goto out_retry;
 
+	/*
+	 * Exit to userspace to map the requested private/shared memory region
+	 * if there is no memslot and (a) the access is private or (b) there is
+	 * an existing private memslot.  Emulated MMIO must be accessed through
+	 * shared GPAs, thus a memslot miss on a private GPA is always handled
+	 * as an implicit conversion "request".
+	 */
+	if (!slot &&
+	    (fault->private || __kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn, true)))
+		goto out_convert;
+
 	if (!kvm_is_visible_memslot(slot)) {
-		/* Don't expose private memslots to L2. */
+		/* Don't expose KVM's internal memslots to L2. */
 		if (is_guest_mode(vcpu)) {
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
@@ -3890,6 +3906,12 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 out_retry:
 	*r = RET_PF_RETRY;
 	return true;
+
+out_convert:
+	vcpu->run->exit_reason = KVM_EXIT_MAP_MEMORY;
+	/* TODO: fill vcpu->run with more info. */
+	*r = 0;
+	return true;
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..21ff766f98d0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -434,6 +434,7 @@ struct kvm_memory_slot {
 	u32 flags;
 	short id;
 	u16 as_id;
+	struct guest_private_memory_ops *private_ops;
 };
 
 static inline bool kvm_slot_dirty_track_enabled(struct kvm_memory_slot *slot)
@@ -514,7 +515,7 @@ struct kvm_irq_routing_table {
 #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_PRIVATE_MEM_SLOTS)
 
 #ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
-static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
+static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu, bool private)
 {
 	return 0;
 }
@@ -785,13 +786,19 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 	return __kvm_memslots(kvm, 0);
 }
 
-static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
+static inline struct kvm_memslots *__kvm_vcpu_memslots(struct kvm_vcpu *vcpu,
+						       bool private)
 {
-	int as_id = kvm_arch_vcpu_memslots_id(vcpu);
+	int as_id = kvm_arch_vcpu_memslots_id(vcpu, private);
 
 	return __kvm_memslots(vcpu->kvm, as_id);
 }
 
+static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
+{
+	return __kvm_vcpu_memslots(vcpu, false);
+}
+
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
@@ -807,6 +814,15 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 	return slot;
 }
 
+static inline bool memslot_is_private(struct kvm_memory_slot *slot)
+{
+#ifdef KVM_PRIVATE_ADDRESS_SPACE
+	return slot && slot->as_id == KVM_PRIVATE_ADDRESS_SPACE;
+#else
+	return false;
+#endif
+}
+
 /*
  * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
  * - create a new memory slot
@@ -946,6 +962,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot, g
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
+struct kvm_memory_slot *__kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu,
+						  gfn_t gfn, bool private);
 struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
 kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..bd01cff9aeff 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -101,6 +101,9 @@ struct kvm_userspace_memory_region {
 	__u64 guest_phys_addr;
 	__u64 memory_size; /* bytes */
 	__u64 userspace_addr; /* start of the userspace allocated memory */
+#ifdef KVM_PRIVATE_ADDRESS_SPACE
+	__u32 fd; /* valid iff memslot is guest private memory */
+#endif
 };
 
 /*
@@ -269,6 +272,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_MEMORY_ERROR	  35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..8747a39d4173 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1583,7 +1583,19 @@ static int kvm_set_memslot(struct kvm *kvm,
 		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
 	}
 
+#ifdef KVM_PRIVATE_ADDRESS_SPACE
+	if (change == KVM_MR_CREATE && as_id == KVM_PRIVATE_ADDRESS_SPACE) {
+		r = kvm_register_private_memslot(kvm, mem, old, new);
+		if (r)
+			goto out_slots;
+	}
+#endif
+
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
+#ifdef KVM_PRIVATE_ADDRESS_SPACE
+	if ((r || change == KVM_MR_DELETE) && as_id == KVM_PRIVATE_ADDRESS_SPACE)
+		kvm_unregister_private_memslot(kvm, mem, old, new);
+#endif
 	if (r)
 		goto out_slots;
 
@@ -1706,6 +1718,12 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		new.dirty_bitmap = NULL;
 		memset(&new.arch, 0, sizeof(new.arch));
 	} else { /* Modify an existing slot. */
+#ifdef KVM_PRIVATE_ADDRESS_SPACE
+		/* Private memslots are immutable, they can only be deleted. */
+		if (as_id == KVM_PRIVATE_ADDRESS_SPACE)
+			return -EINVAL;
+#endif
+
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
 		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
@@ -2059,9 +2077,10 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
-struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn)
+struct kvm_memory_slot *__kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu,
+						  gfn_t gfn, bool private)
 {
-	struct kvm_memslots *slots = kvm_vcpu_memslots(vcpu);
+	struct kvm_memslots *slots = __kvm_vcpu_memslots(vcpu, private);
 	struct kvm_memory_slot *slot;
 	int slot_index;
 
@@ -2082,6 +2101,12 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__kvm_vcpu_gfn_to_memslot);
+
+struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	return __kvm_vcpu_gfn_to_memslot(vcpu, gfn, false);
+}
 EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
 
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
@@ -2428,8 +2453,12 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool atomic, bool *async, bool write_fault,
 			       bool *writable, hva_t *hva)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	unsigned long addr;
 
+	if (memslot_is_private(slot))
+		return slot->private_ops->gfn_to_pfn(...);
+
+	addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 	if (hva)
 		*hva = addr;
 
@@ -2624,8 +2653,7 @@ EXPORT_SYMBOL_GPL(kvm_map_gfn);
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map,
-		NULL, false);
+	return __kvm_map_gfn(kvm_vcpu_memslots(vcpu), gfn, map, NULL, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

