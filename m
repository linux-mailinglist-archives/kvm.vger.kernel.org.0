Return-Path: <kvm+bounces-18437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB1718D542A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BE85282453
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA851761B7;
	Thu, 30 May 2024 21:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVxMfUqq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D4347A5D;
	Thu, 30 May 2024 21:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103252; cv=none; b=gZvOolsUPST0dUVK68Qe2AqhN/p+3FUuvut/3Q9/hPV8rkcs7bTjv3Y0Nx/Pehz2/Q+8XlfTNUEpnaiK9QS+Ogi9yIoXiZiZ+F+dxD/N2KcgfcQcSHDuF0AW0RjXz1OB8UTeXl2Pu4PpaHUADyBblhiFF8zdPB9CslVAje2+RWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103252; c=relaxed/simple;
	bh=wECqoW9dndUphPEO8gsNT8VOioMCH6nJhBwS7rzQWo8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=n9soBGV8pknvw/T6Y1HixqdLzw/e4Blni69uJ8/T5ZwKN0rKyJt/SKfUWaVGZ0xwvZUdl1nhwMiGfXaTfLCBj2tbgBxKyNUok2dSrlOPlyhy6YDq7PU9tDhbAIRW4KVjgqxwGh2ibiMkQxjyXJgGvKEXWo9uX+siMyquW5V0dYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVxMfUqq; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103251; x=1748639251;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wECqoW9dndUphPEO8gsNT8VOioMCH6nJhBwS7rzQWo8=;
  b=fVxMfUqqXvMEMfF8FhHhOh3TK45s54Nhy3Zp3jJ/g56Aj7DU2IslfrbV
   2R5wAtUdnZBdh2NtTg7oTrN10VoW/Z/UTmpISHnFyKuDuQ5at2L4T5z7k
   xjT5WI42TzZT5K6+gUJ/v4cnROa4w7z7anWvgJfS4x0ueFnHExdnFnd/L
   zrq8QmhQfmOeFWuFb2i8891e2jjb41YbDJWpBvKvFn5X6VAOZnK3PNOFl
   hc2hyoluKsDVxa65TS8GbQ3Mu/gRxD7AjvZi5aVfLh5FdyQ5bQkqa97/i
   25PeBFqnJSb8thKrObTfmItBiODAB2quQRwFG/QSofMNfPV4PT4Kdr9Y2
   w==;
X-CSE-ConnectionGUID: cIgUGUSlSza9KiKKEP8Nwg==
X-CSE-MsgGUID: AuQqHXr4QOWRrIclvoEqIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117078"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117078"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:30 -0700
X-CSE-ConnectionGUID: 6VdVxl1VRMKog3EfBnxOOw==
X-CSE-MsgGUID: XlyLT43qSVatIz6upfO6Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874396"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:30 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v2 00/15] TDX MMU prep series part 1
Date: Thu, 30 May 2024 14:06:59 -0700
Message-Id: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is v2 of the TDX MMU prep series, split out of the giant 130 patch 
TDX base enabling series [0]. It is focusing on the changes to the x86 MMU 
to support TDX’s separation of private/shared EPT into separate roots. A 
future breakout series will include the changes to actually interact with 
the TDX module to actually map private memory. The purpose of sending out 
a smaller series is to focus review, and hopefully rapidly iterate. We 
would like the series to go into kvm-coco-queue when it is ready.

I think the maturity of these patches has significantly improved during 
the recent reviews. I expecting it still needs a little more work, but 
think that the basic structure is in decent shape at this point. Please 
consider it from the perspective of what is missing for inclusion in 
kvm-coco-queue.

There is a larger team working on TDX KVM base enabling. The patches were 
originally authored by Sean Christopherson and Isaku Yamahata, but 
otherwise it especially represents the work of Isaku and Yan Y Zhao and 
myself.

The series has been tested as part of a development branch for the TDX base
series [1]. The testing of this series consists TDX kvm-unit-tests [2],
regular KVM selftests, and booting a Linux TD. Rebasing the TDX selftests
is still in progress.

Updates from v2
===============
Most of the changes for v2 are around code clarity. At a high level:

 - Previously the (described below) mirror changes had a bunch of "private"
   naming in the generic MMU code. These have been renamed to "mirror". The
   connection between TDX private memory and mirrored memory inside mmu.h
   helpers. Now the generic MMU code simply selects the mirror root when
   performing private operations (faults, invalidation, etc). The TDX
   seamcalls to update the S-EPT are hidden inside the x86_ops, so the
   special TDX private parts don't pollute the concept for SEV.
  
   To do this the roots enum is changed to be about "mirror" and "direct"
   instead of "private" and "shared". The process enum retains these
   concepts, and TDX specific logic matches between the two. So there is a
   little more purpose to have two enums.
 
 - The gfn_shared_mask is now gfn_direct_mask, and it simply applies the
   mask when operating on the direct moot (i.e. a fault targeting a “gfn”
   on a normal “direct” root gets faulted in at gfn|gfn_direct_mask). Like
   the private memory connection, the connection between the normal
   "direct" root and shared memory is hidden inside mmu.h helpers.

 - The shared bit has been removed from all of the gfn_t's. This is
   achieved by applying the gfn_direct_mask from within the TDP MMU
   iterator. It prevents more of the MMU code to have to take special care
   around GFN's.

 - There also has been some re-organization and patch splitting to aid in
   reviewability.

 - Log improvements

The quirk for zapping all PTEs on memslot deletion will come as a separate
series. The change to make kvm_mmu_max_gfn() configurable will also come
separately. The kvm_zap_gfn_range() KVM_BUG_ON() patch is dropped.

Private/shared memory in TDX
============================
Confidential computing solutions have concepts of private and shared
memory. Often the guest accesses either private or shared memory via a bit
in the PTE. Solutions like SEV treat this bit more like a permission bit,
where solutions like TDX and ARM CCA treat it more like a GPA bit. In the
latter case, the host maps private memory in one half of the address space
and shared in another. For TDX these two halves are mapped by different
EPT roots. The private half (also called Secure EPT in Intel
documentation) gets managed by the privileged TDX Module. The shared half
is managed by the untrusted part of the VMM (KVM).

In addition to the separate roots for private and shared, there are
limitations on what operations can be done on the private side. TDX wants
to protect against protected memory being reset or otherwise scrambled by
the host. In order to prevent this, the guest has to take specific action
to “accept” memory after changes are made by the VMM to the private EPT.
This prevents the VMM from performing many of the usual memory management
operations that involve zapping and refaulting memory. The private memory
also is always RWX and cannot have VMM specified cache attribute
attributes applied.

TDX KVM MMU Design For Private Memory
=====================================

Private/shared split
--------------------
The operations that actually change the private half of the EPT are
limited and relatively slow compared to reading a PTE. For this reason the
design for KVM is to keep a “mirrored” copy of the private EPT in KVM’s
memory. This will allow KVM to quickly walk the EPT and only perform the
slower private EPT operations when it needs to actually modify mid-level
private PTEs.

To clarify the definitions of the three EPT trees at this point:
private EPT  - Protected by the TDX module, modified via TDX module
               calls.
mirror EPT   - Bookkeeping tree used as an optimization by KVM, not
               mapped.
shared EPT   - Normal EPT that maps unencrypted shared memory.
               Managed like the EPT of a normal VM.

It’s worth noting that we are making an effort to remove optimizations
that have complexity for the base enabling. Although keeping a mirrored
copy of the private page tables kind of fits into that category, it has
been so fundamental to the design for so long, dropping it would be too
disruptive.

Mirror EPT
------------
The mirror EPT needs to keep a mirrored version of the private EPT
maintained in the TDX module in order to be able to find out if a GPA’s
mid-level pagetable have already been installed. So this mirrored copy has
the same structure as the private EPT, having a page table present for
every GPA range and level in the mirrored EPT where a page table is
present private. The private page tables also cannot be zapped while the
range has anything mapped, so the mirrored/private page tables need to be
protected from KVM operations that zap any non-leaf PTEs, for example
kvm_mmu_reset_context() or kvm_mmu_zap_all_fast()

Modifications to the mirrored page tables need to also perform the same
operations to the private page tables. The actual TDX module calls to do
this are not covered in this prep series.

For convenience SPs for private page tables are tracked with a role bit
out of convenience. (Note to reviewers, please consider if this is really
needed).

Zapping Changes
---------------
For normal VMs, guest memory is zapped for several reasons, like user
memory getting paged out by the guest, memslots getting deleted or
virtualization operations like MTRRs, and attachment of non-coherent DMA.
For TDX (and SNP) there is also zapping associated with the conversion of
memory between shared and privates. These operations need to take care to
do two things:
1. Not zap any private memory that is in use by the guest.
2. Not zap any memory alias unnecessarily (i.e. Don’t zap anything more
than needed). The purpose of this is to not have any unnecessary behavior
userspace could grow to rely on.

For 1, this is possible because the zapping that is out of the control of
KVM/userspace (paging out of userspace memory) will only apply to shared
memory. Guest mem fd operations are protected from mmu notifier
operations. During TD runtime, zapping of private memory will only be from
memslot deletion and from conversion between private and shared memory
which is triggered by the guest.

For 2, KVM needs to be taught which operations will operate on which
aliases. An enum based scheme is introduced such that operations can
target specific aliases like:
Memslot deletion           - Private and shared
MMU notifier based zapping - Shared only
Conversion to shared       - Private only
Conversion to private      - Shared only
MTRRs, etc                 - Zapping will be avoided all together

For zapping arising from other virtualization based operations, there are
four scenarios:
1. MTRR update
2. CR0.CD update
3. APICv update
4. Non-coherent DMA status update

KVM TDX will not support 1-3. In future changes (after this series) the
features will not be supported for TDX. For 4, there isn’t an easy way to
not support the feature as the notification is just passed to KVM and it
has to act accordingly. However, other proposed changes [3] will avoid the
need for zapping on non-coherent DMA notification for selfsnoop CPUs. So
KVM can follow this logic and just always honor guest PAT for shared
memory.

Atomically updating private EPT
-------------------------------
Although this prep series does not interact with the TDX module at all to
actually configure the private EPT, it does lay the ground work for doing
this. In some ways updating the private EPT is as simple as plumbing PTE
modifications through to also call into the TDX module, but there is one
tricky property that is worth elaborating on. That is how to handle that
the TDP MMU allows modification of PTEs with the mmu_lock held only for
read and uses the PTEs themselves to perform synchronization.

Unfortunately while operating on a single PTE can be done atomically,
operating on both the mirrored and private PTEs at the same time needs
additional solution. To handle this situation, REMOVED_SPTE is used to
prevent concurrent operations while a call to the TDX module updates the
private EPT.

The series is based on kvm-coco-queue.

[0] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/
[1] https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-05-30
[2] https://lore.kernel.org/kvm/20231218072247.2573516-1-qian.wen@intel.com/
[3] https://lore.kernel.org/kvm/20240309010929.1403984-6-seanjc@google.com/

Isaku Yamahata (12):
  KVM: Add member to struct kvm_gfn_range for target alias
  KVM: x86/mmu: Add a mirrored pointer to struct kvm_mmu_page
  KVM: x86/mmu: Add a new mirror_pt member for union kvm_mmu_page_role
  KVM: x86/mmu: Support GFN direct mask
  KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
  KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table
    type
  KVM: x86/tdp_mmu: Support mirror root for TDP MMU
  KVM: x86/tdp_mmu: Reflect building mirror page tables
  KVM: x86/tdp_mmu: Reflect tearing down mirror page tables
  KVM: x86/tdp_mmu: Take root types for
    kvm_tdp_mmu_invalidate_all_roots()
  KVM: x86/tdp_mmu: Make mmu notifier callbacks to check kvm_process
  KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU

Rick Edgecombe (2):
  KVM: x86: Add a VM type define for TDX
  KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void

Sean Christopherson (1):
  KVM: x86/tdp_mmu: Invalidate correct roots

 arch/x86/include/asm/kvm-x86-ops.h |   4 +
 arch/x86/include/asm/kvm_host.h    |  45 +++-
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/mmu.h                 |  28 +++
 arch/x86/kvm/mmu/mmu.c             |  37 ++-
 arch/x86/kvm/mmu/mmu_internal.h    |  68 +++++-
 arch/x86/kvm/mmu/spte.h            |   5 +
 arch/x86/kvm/mmu/tdp_iter.c        |   5 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  16 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 352 +++++++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h         |  45 +++-
 arch/x86/kvm/x86.c                 |  10 +
 include/linux/kvm_host.h           |   8 +
 virt/kvm/guest_memfd.c             |   2 +
 virt/kvm/kvm_main.c                |  14 ++
 15 files changed, 537 insertions(+), 103 deletions(-)


base-commit: 698ca1e403579ca00e16a5b28ae4d576d9f1b20e
-- 
2.34.1


