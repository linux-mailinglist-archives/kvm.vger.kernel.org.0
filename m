Return-Path: <kvm+bounces-20015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 476D190F90C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53F751C2131D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486F515B124;
	Wed, 19 Jun 2024 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gxhVXAgf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9512122EED;
	Wed, 19 Jun 2024 22:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836584; cv=none; b=jXqlLc0nhvTJlxlZRDBKpnJHFUvWxGMfmn3qk5WJ8R/PT0YwI/CZPCy3/RsHLBkf5y5v/TXPAiqcZ17xZhnmx4rQE9o9T/4fNTZ0r9tOQOMVk1DlXj47nQP3TQfQT+RZ1JdMwgjB+F7htWeLx/Ikly8pA01I5I3VMO7pLgl9Svo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836584; c=relaxed/simple;
	bh=jevxF+h7r7iofvCuuMMbeLhMSo/YusJhoRkAzgt/gPk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=iXsugdcfyMBnEvcUqFd4c+cOBwxC6COgzJ/yCfBk6h0r2yWb1FRA6X26qO/RXumRDxosOZYwZ67j+gijm2LX4zL85FD1h9qffTjHSNkrh9ZSPweUM/7o3VeE0Wg9v49zc6lfAAQPBVQfIBRPq3aUsnYb56Dg/NAPOkdlxfkPdTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gxhVXAgf; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836581; x=1750372581;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jevxF+h7r7iofvCuuMMbeLhMSo/YusJhoRkAzgt/gPk=;
  b=gxhVXAgfBo4mPW5m2UAPo/Ze3m6V8SeYEuj24lZN2+JKiix8BrWX3eQu
   SywI2qzVx6Zhwfdpem15TsSkrrshYVYd/z1iQsD5EveLb/eL4/vK2y8Xi
   oArHVVjxQoFBxpDtCHc2t1Kh7DyOQ5G7S6FPUZyiqndqSKSYsn8bYZHfq
   kRowOK+7MtODaQZDI0cpa1hjSax4Llv6bW796ic98SUpsy4PBwbGjSV3U
   jVLZhd9Ex+6QZFKGihe2ymRtx5DVmiSqhYYR1Ky7KJcd7NtxoptqItoAe
   WM1Ax8uOE74TVJ1PMuQtY/T+DNd83VDSqd8TWl0rQlQlbKdsch4skOcmD
   Q==;
X-CSE-ConnectionGUID: Lpo6GApWR3+vy2SxB6IDRg==
X-CSE-MsgGUID: 3d8sg904QbWQurc5E0pAXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931924"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931924"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:20 -0700
X-CSE-ConnectionGUID: DK4EagMBSbGELGscz6+AYg==
X-CSE-MsgGUID: rTjS5Xv2Rsm9jLCdnqWC5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793315"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:19 -0700
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
Subject: [PATCH v3 00/17] TDX MMU prep series part 1
Date: Wed, 19 Jun 2024 15:35:57 -0700
Message-Id: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
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

This is v3 of the TDX MMU prep series, split out of the giant 130 patch 
TDX base enabling series [0]. It is focusing on the changes to the x86 MMU 
to support TDX’s separation of private/shared EPT into separate roots. A 
future breakout series will include the changes to actually interact with 
the TDX module to actually map private memory. The purpose of sending out 
a smaller series is to focus review, and hopefully rapidly iterate. We 
would like the series to go into kvm-coco-queue when it is ready.

I think patches are in pretty good shape at this point.

There is a larger team working on TDX KVM base enabling. The patches were 
originally authored by Sean Christopherson and Isaku Yamahata, but 
otherwise it especially represents the work of Isaku and Yan Y Zhao and 
myself.

The series has been tested as part of a development branch for the TDX base
series [1]. The testing of this series consists TDX kvm-unit-tests [2],
regular KVM selftests, and booting a Linux TD. Rebasing the TDX selftests
is still in progress.

Updates from v3
===============
For v2, Paolo did an extensive review. Most of that feedback was
non-functional, but internally we found two issues with the TDP MMU
iterator changes implemented in v2:
 - Shared bits not applied in try_step_side(), which affects the math in
   4-level paging
 - Shared bit passed into tdp_iter_start() for fast page fault path

Besides those fixes some other changes of note:
 - "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU" is
    pushed out of this series for later.
 - New patch "KVM: x86/tdp_mmu: Take a GFN in
   kvm_tdp_mmu_fast_pf_get_last_sptep()" to fix one of the previously
   mentioned bugs found earlier.
 - New patch "KVM: x86/tdp_mmu: Rename REMOVED_SPTE to FROZEN_SPTE", which
   Paolo mentioned might be a candidate for 6.11

With respect to other series in progress:
 - The "Introduce a quirk to control memslot zap behavior" [3] series will
   need a change in order to work with this. The attr_filter field
   (previously process) added in this series will need to be set in that
   series' kvm_mmu_zap_memslot_leafs() function.

   I will post an additional patch, that goes on top of that series and
   can be added when they are combined. Any branch with either of those
   series should be fine functionally until we can create VM of the TDX
   type.

 - The series to make max gfn configurable is still outstanding, but not
   required functionally.

This series is on top of kvm-coco-queue and two fixes to that branch. The
only critical one is the patch at [4].


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
external EPT - Protected by the TDX module, modified via TDX module
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
has to act accordingly. However, other proposed changes [5] will avoid the
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
[1] https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-06-19
[2] https://lore.kernel.org/kvm/20231218072247.2573516-1-qian.wen@intel.com/
[3] https://lore.kernel.org/kvm/20240613060708.11761-1-yan.y.zhao@intel.com/
[4] https://lore.kernel.org/lkml/20240518000430.1118488-2-seanjc@google.com/
[5] https://lore.kernel.org/kvm/20240309010929.1403984-6-seanjc@google.com/

Isaku Yamahata (13):
  KVM: Add member to struct kvm_gfn_range for target alias
  KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
  KVM: x86/mmu: Add an is_mirror member for union kvm_mmu_page_role
  KVM: x86/tdp_mmu: Take struct kvm in iter loops
  KVM: x86/mmu: Support GFN direct bits
  KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
  KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table
    type
  KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
  KVM: x86/tdp_mmu: Support mirror root for TDP MMU
  KVM: x86/tdp_mmu: Propagate attr_filter to MMU notifier callbacks
  KVM: x86/tdp_mmu: Propagate building mirror page tables
  KVM: x86/tdp_mmu: Propagate tearing down mirror page tables
  KVM: x86/tdp_mmu: Take root types for
    kvm_tdp_mmu_invalidate_all_roots()

Rick Edgecombe (4):
  KVM: x86/tdp_mmu: Rename REMOVED_SPTE to FROZEN_SPTE
  KVM: x86: Add a VM type define for TDX
  KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void
  KVM: x86/tdp_mmu: Take a GFN in kvm_tdp_mmu_fast_pf_get_last_sptep()

 arch/x86/include/asm/kvm-x86-ops.h |   4 +
 arch/x86/include/asm/kvm_host.h    |  26 ++-
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/mmu.h                 |  17 ++
 arch/x86/kvm/mmu/mmu.c             |  41 +++-
 arch/x86/kvm/mmu/mmu_internal.h    |  64 +++++-
 arch/x86/kvm/mmu/spte.c            |   2 +-
 arch/x86/kvm/mmu/spte.h            |  15 +-
 arch/x86/kvm/mmu/tdp_iter.c        |  10 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  16 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 328 +++++++++++++++++++++--------
 arch/x86/kvm/mmu/tdp_mmu.h         |  51 ++++-
 include/linux/kvm_host.h           |   6 +
 virt/kvm/guest_memfd.c             |   2 +
 virt/kvm/kvm_main.c                |  14 ++
 15 files changed, 481 insertions(+), 116 deletions(-)


base-commit: 698ca1e403579ca00e16a5b28ae4d576d9f1b20e
prerequisite-patch-id: c10f666d6a21c1485a32f393a50f38aa69c25caa
prerequisite-patch-id: a525ee37f0c8f41e74909343517d57a553724152
-- 
2.34.1


