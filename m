Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569CB154681
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgBFOuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:50:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgBFOuf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sx/+8+iZzlYrslWjWWCbVGN3KcfYw72YNJslLwCNE1I=; b=c7SlY+e7+2GKm3ImZMQV3ImgPJ
        9BKpSuWQavKccG9qodDo7YEb4lkfFZNu8C2n31DNKWhx6E07MllEgwB3ZWQKTZT7cOuHlDfducD15
        ZlLgYe/3wLmP+pniJsvfjwXCbRrPAMppb49Pm0tiM59cz2APU5ogHfiGtm/2WR2FhRkeu9D7HMTXv
        jyB+ead+goXL+gZIrMYm6D/lZ4CSlr4MxnHtcUmbBfcSBWkU36c+sHVnAWIT3r/1CqzXy+pP1k/S6
        BZXrcDee6s9nthsuciw0ia6ZOVMPqLp7daKSQOLZdNU6okH5gfy2VGG+wrr7B1xcCr5AdAa4APhyP
        NaXZb5KA==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziUE-0004IL-AI; Thu, 06 Feb 2020 14:50:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziU6-002nLi-Vw; Thu, 06 Feb 2020 15:50:26 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 21/27] docs: kvm: Convert locking.txt to ReST format
Date:   Thu,  6 Feb 2020 15:50:18 +0100
Message-Id: <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Use document title and chapter markups;
- Add markups for literal blocks;
- use :field: for field descriptions;
- Add blank lines and adjust indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/index.rst              |   1 +
 .../virt/kvm/{locking.txt => locking.rst}     | 111 ++++++++++--------
 2 files changed, 63 insertions(+), 49 deletions(-)
 rename Documentation/virt/kvm/{locking.txt => locking.rst} (78%)

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ac83bc588f7e..9be8f53b729d 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -12,6 +12,7 @@ KVM
    cpuid
    halt-polling
    hypercalls
+   locking
    msr
    vcpu-requests
 
diff --git a/Documentation/virt/kvm/locking.txt b/Documentation/virt/kvm/locking.rst
similarity index 78%
rename from Documentation/virt/kvm/locking.txt
rename to Documentation/virt/kvm/locking.rst
index 635cd6eaf714..428cb3412ecc 100644
--- a/Documentation/virt/kvm/locking.txt
+++ b/Documentation/virt/kvm/locking.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
 KVM Lock Overview
 =================
 
@@ -18,7 +21,7 @@ On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
-2: Exception
+2. Exception
 ------------
 
 Fast page fault:
@@ -28,15 +31,16 @@ the mmu-lock on x86. Currently, the page fault can be fast in one of the
 following two cases:
 
 1. Access Tracking: The SPTE is not present, but it is marked for access
-tracking i.e. the SPTE_SPECIAL_MASK is set. That means we need to
-restore the saved R/X bits. This is described in more detail later below.
+   tracking i.e. the SPTE_SPECIAL_MASK is set. That means we need to
+   restore the saved R/X bits. This is described in more detail later below.
 
 2. Write-Protection: The SPTE is present and the fault is
-caused by write-protect. That means we just need to change the W bit of the 
-spte.
+   caused by write-protect. That means we just need to change the W bit of
+   the spte.
 
 What we use to avoid all the race is the SPTE_HOST_WRITEABLE bit and
 SPTE_MMU_WRITEABLE bit on the spte:
+
 - SPTE_HOST_WRITEABLE means the gfn is writable on host.
 - SPTE_MMU_WRITEABLE means the gfn is writable on mmu. The bit is set when
   the gfn is writable on guest mmu and it is not write-protected by shadow
@@ -48,19 +52,23 @@ restore the saved R/X bits if VMX_EPT_TRACK_ACCESS mask is set, or both. This
 is safe because whenever changing these bits can be detected by cmpxchg.
 
 But we need carefully check these cases:
-1): The mapping from gfn to pfn
+
+1) The mapping from gfn to pfn
+
 The mapping from gfn to pfn may be changed since we can only ensure the pfn
 is not changed during cmpxchg. This is a ABA problem, for example, below case
 will happen:
 
-At the beginning:
-gpte = gfn1
-gfn1 is mapped to pfn1 on host
-spte is the shadow page table entry corresponding with gpte and
-spte = pfn1
+At the beginning::
 
-   VCPU 0                           VCPU0
-on fast page fault path:
+	gpte = gfn1
+	gfn1 is mapped to pfn1 on host
+	spte is the shadow page table entry corresponding with gpte and
+	spte = pfn1
+
+	   VCPU 0                           VCPU0
+
+on fast page fault path::
 
    old_spte = *spte;
                                  pfn1 is swapped out:
@@ -81,6 +89,7 @@ We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
 For direct sp, we can easily avoid it since the spte of direct sp is fixed
 to gfn. For indirect sp, before we do cmpxchg, we call gfn_to_pfn_atomic()
 to pin gfn to pfn, because after gfn_to_pfn_atomic():
+
 - We have held the refcount of pfn that means the pfn can not be freed and
   be reused for another gfn.
 - The pfn is writable that means it can not be shared between different gfns
@@ -91,7 +100,8 @@ Then, we can ensure the dirty bitmaps is correctly set for a gfn.
 Currently, to simplify the whole things, we disable fast page fault for
 indirect shadow page.
 
-2): Dirty bit tracking
+2) Dirty bit tracking
+
 In the origin code, the spte can be fast updated (non-atomically) if the
 spte is read-only and the Accessed bit has already been set since the
 Accessed bit and Dirty bit can not be lost.
@@ -99,12 +109,14 @@ Accessed bit and Dirty bit can not be lost.
 But it is not true after fast page fault since the spte can be marked
 writable between reading spte and updating spte. Like below case:
 
-At the beginning:
-spte.W = 0
-spte.Accessed = 1
+At the beginning::
 
-   VCPU 0                                       VCPU0
-In mmu_spte_clear_track_bits():
+	spte.W = 0
+	spte.Accessed = 1
+
+	   VCPU 0                                       VCPU0
+
+In mmu_spte_clear_track_bits()::
 
    old_spte = *spte;
 
@@ -134,7 +146,8 @@ In order to avoid this kind of issue, we always treat the spte as "volatile"
 if it can be updated out of mmu-lock, see spte_has_volatile_bits(), it means,
 the spte is always atomically updated in this case.
 
-3): flush tlbs due to spte updated
+3) flush tlbs due to spte updated
+
 If the spte is updated from writable to readonly, we should flush all TLBs,
 otherwise rmap_write_protect will find a read-only spte, even though the
 writable spte might be cached on a CPU's TLB.
@@ -166,47 +179,47 @@ which time it will be set using the Dirty tracking mechanism described above.
 3. Reference
 ------------
 
-Name:		kvm_lock
-Type:		mutex
-Arch:		any
-Protects:	- vm_list
+:Name:		kvm_lock
+:Type:		mutex
+:Arch:		any
+:Protects:	- vm_list
 
-Name:		kvm_count_lock
-Type:		raw_spinlock_t
-Arch:		any
-Protects:	- hardware virtualization enable/disable
-Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
+:Name:		kvm_count_lock
+:Type:		raw_spinlock_t
+:Arch:		any
+:Protects:	- hardware virtualization enable/disable
+:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
-Name:		kvm_arch::tsc_write_lock
-Type:		raw_spinlock
-Arch:		x86
-Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
+:Name:		kvm_arch::tsc_write_lock
+:Type:		raw_spinlock
+:Arch:		x86
+:Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
 		- tsc offset in vmcb
-Comment:	'raw' because updating the tsc offsets must not be preempted.
+:Comment:	'raw' because updating the tsc offsets must not be preempted.
 
-Name:		kvm->mmu_lock
-Type:		spinlock_t
-Arch:		any
-Protects:	-shadow page/shadow tlb entry
-Comment:	it is a spinlock since it is used in mmu notifier.
+:Name:		kvm->mmu_lock
+:Type:		spinlock_t
+:Arch:		any
+:Protects:	-shadow page/shadow tlb entry
+:Comment:	it is a spinlock since it is used in mmu notifier.
 
-Name:		kvm->srcu
-Type:		srcu lock
-Arch:		any
-Protects:	- kvm->memslots
+:Name:		kvm->srcu
+:Type:		srcu lock
+:Arch:		any
+:Protects:	- kvm->memslots
 		- kvm->buses
-Comment:	The srcu read lock must be held while accessing memslots (e.g.
+:Comment:	The srcu read lock must be held while accessing memslots (e.g.
 		when using gfn_to_* functions) and while accessing in-kernel
 		MMIO/PIO address->device structure mapping (kvm->buses).
 		The srcu index can be stored in kvm_vcpu->srcu_idx per vcpu
 		if it is needed by multiple functions.
 
-Name:		blocked_vcpu_on_cpu_lock
-Type:		spinlock_t
-Arch:		x86
-Protects:	blocked_vcpu_on_cpu
-Comment:	This is a per-CPU lock and it is used for VT-d posted-interrupts.
+:Name:		blocked_vcpu_on_cpu_lock
+:Type:		spinlock_t
+:Arch:		x86
+:Protects:	blocked_vcpu_on_cpu
+:Comment:	This is a per-CPU lock and it is used for VT-d posted-interrupts.
 		When VT-d posted-interrupts is supported and the VM has assigned
 		devices, we put the blocked vCPU on the list blocked_vcpu_on_cpu
 		protected by blocked_vcpu_on_cpu_lock, when VT-d hardware issues
-- 
2.24.1

