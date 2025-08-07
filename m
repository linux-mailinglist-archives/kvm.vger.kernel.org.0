Return-Path: <kvm+bounces-54225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9EEB1D4FC
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82EE972245A
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D46125C6F1;
	Thu,  7 Aug 2025 09:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BUngsRDz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2E1D47B4;
	Thu,  7 Aug 2025 09:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559639; cv=none; b=oRGF7zrfaDjPixn4JNqD4p1M9/7XEQBWdY4ADSlrB2QTD/xO7wPuscLrjUOg+VFuWo34LVuLcWg1wBuvfbmzSSxo+5GDWvZj+M1BZE3ZNpxVEznW4S21Ct2cIYijDXsOOU1Y1reANAS1IvlwG111h9YfsBWLvt1Iabw8pffJz5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559639; c=relaxed/simple;
	bh=krd4q9iYCxErad0iyi7yT1cOAN2OfvucKu6AvyXp2do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LIqy3oKkhySSjM/uB5VFvF2rq4edpuB1zODjf44cJMPwZaCv6h+lNASPj+gA/oXxTyp02XjxPt55cZI/9YICv1Ak2wr51t0sNZjjWhiTqI6XKBYlOpxKXKhM8mX0K9q1BerjMm2hQrDRI4SukMq/1kvFbaZajGIL+aR7PsZqBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BUngsRDz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559637; x=1786095637;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=krd4q9iYCxErad0iyi7yT1cOAN2OfvucKu6AvyXp2do=;
  b=BUngsRDzIWIFmyh0yF22b5IVRIaJbfO5pPQ2FfuAsxcNp8Qfp7tYFx2u
   8qpxLJrJdZpOLA2mo/NEaWSSx/R0Swce6j6f0QM1i4R/xklSNZxwX6bZA
   vB00s1Lh3EsQweUxTtM9rAAFRRo0xZBZY2gGAhboemrfgEz8sesF5ZcGd
   P8VmBHP7/BXNtXptcymoPn6zg/QavlIe0SLQRSwKscg8a/FDOExDFG0be
   hDytRwQT/f9a3/+x4tDhrFwD9v9hc0Flc6aOqxIMWG3y4O6xkPswXSxZ6
   rMDwIelbL9U0GZouY44h0QnWYkvVncjuGWNvjlzHRp9rz59RtIK4BqHea
   A==;
X-CSE-ConnectionGUID: Pe7TSSq3QhWLV3qblAZtDw==
X-CSE-MsgGUID: WVWflKD+Q12+ms5a1Dvucw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67585988"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67585988"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:40:33 -0700
X-CSE-ConnectionGUID: MHEl7dP0T5OytTyisOfqTw==
X-CSE-MsgGUID: ol5EBm08QCSvWiVMqhvAhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="195852518"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:40:27 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 00/23] KVM: TDX huge page support for private memory
Date: Thu,  7 Aug 2025 17:39:50 +0800
Message-ID: <20250807093950.4395-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is RFC v2 series to support huge pages in TDX, currently focusing on
supporting 2MB huge pages only. (code available at [2]).

The main goal for RFC v2 is to have the TDX side feedback ready.

Tip folks, there are some SEAMCALL wrapper changes in this series, but we
need to have some discussion on the KVM side to figure out what it needs
still. Please feel free to ignore it for now."


4 opens in RFC v1
====
Open 1: How to pass guest's ACCEPT level info.
 
	The TDX guest can affect KVM's mapping level of a fault due to the
	current implementation of the guest ACCEPT operation in the TDX
	module. If KVM maps at a higher level than the guest's ACCEPT
	level, repeated faults are generated, prompting KVM to split the
	huge mapping to match the ACCEPT level. To prevent these repeated
	faults and subsequent splitting (at least for Linux TDs), it's
	efficient to pass the guest's ACCEPT level info to the KVM MMU core
	to restrict the mapping level of a fault.

	Prior to RFC v1, this info was conveyed by modifying each fault's
	error code [10][11].
	In RFC v1, the info was passed through the hook
	private_max_mapping_level, checking a per-vCPU
	violation_request_level inside TDX [12].

	In RFC v2, Sean and Rick suggested a global way [17] (vs a
	fault-by-fault per-vCPU way) to specify the info. This involves
	setting the disallow_lpage's GUEST_INHIBIT bit in a slot's
	lpage_infos above the specified guest ACCEPT level, indicating that
	the guest wants to prevent a specific GFN from being mapped at
	those higher levels (Patches 13 and 14).  This approach helps
	prevent potential subtle bugs that could arise from different
	ACCEPT levels specified by different vCPUs.


Open 2: Do we need to support huge pages on non-Linux TDs and the split in
        fault path.

	The current TDX module requires tdh_mem_range_block() to be invoked
	before each tdh_mem_page_demote(). It leads to the complexity of
	handling BUSY errors under a shared mmu_lock, since if a BUSY error
	is returned from tdh_mem_page_demote(), TDX must call
	tdh_mem_range_unblock() (which may also return a BUSY error) before
	passing the error to the KVM MMU core.

	For Linux TDs, guest ACCEPT operations usually occur before KVM
	populates the mappings, except when KVM pre-faults certain
	mappings. Therefore, to avoid splitting in the fault path for Linux
	TDs, RFC v1 required prefetch faults to be mapped at 4KB and KVM's
	mapping level to honor the guest's ACCEPT level.

	For non-Linux TDs, where guest ACCEPT operations may occur after
	KVM has populated mappings, KVM's mapping level has no way to honor
	the not-yet-specified guest's ACCEPT level. If the guest later
	accepts at a level smaller than KVM's mapping level, splitting in
	the fault path may be necessary. In RFC v1, splitting in the fault
	path was ignored, with the expectation that the guest would never
	accept at a lower level than KVM's mapping level. This expectation
	was later proven incorrect. Forcing a KVM's mapping to be at 4KB
	before the guest's ACCEPT level is available would disable huge
	pages for non-Linux TDs as the TD's later ACCEPT operations at a
	higher level would return error TDX_PAGE_SIZE_MISMATCH to the
	guest.
 
	In RFC v2, the fault path splitting issue is addressed by having
	TDX's EPT violation handler:
	(1) explicitly split previous huge mapping under write mmu_lock,
	(2) set GUEST_INHIBIT bit in a slot's lpage_info above the
	    specified guest ACCEPT level,
	before invoking KVM MMU core's kvm_mmu_page_fault().

	This mechanism allows support of huge pages for non-Linux TDs and
	also removes the 4KB restriction on pre-fault mappings for Linux
	TDs in RFC v1.

	It's a TODO to support split in the fault path once new TDX module
	supporting blockless tdh_mem_page_demote() is available. After
	that, step (1) would be unnecessary and step (2) could be optimized
	to be under shared mmu_lock to enhance performance.


Open 3: How to handle the TDX_INTERRUPTED_RESTARTABLE error from
	tdh_mem_page_demote().

	Currently, the TDX module returns TDX_INTERRUPTED_RESTARTABLE when
	it receives interrupts (including NMIs) during the SEAMCALL
	tdh_mem_page_demote(). However, a new TDX module is in planning,
        which will disable the interrupt checking (including for NMIs)
        during SEAMCALL tdh_mem_page_demote() for basic TDX (w/ or w/o
        DPAMT).

	As a result, the loop for endlessly retrying
	TDX_INTERRUPTED_RESTARTABLE has been removed in RFC v2.

	The retry logic remains in the code tree [2] for testing purpose
	with current TDX module.
										 
Open 4: How to handle unmap failures.

	To enable guest_memfd to support in-place conversion between shared
	and private memory [5], TDX is required not to hold refcount of the
	private pages allocated from guest_memfd. (see details in patch 6).

	Without TDX holding extra folio refcount for memory that are still
	mapped in S-EPT, the guest_memfd may have freed a page while it's
	still mapped in the S-EPT, since the current KVM unmap operation
	does not return errors to its callers. (For TDX, the error could
	arise from failures in SEAMCALLs tdh_mem_page_remove(),
	tdh_phymem_page_wbinvd_hkid(), tdh_phymem_page_reclaim()).

	Several approaches have been explored. (Refer to the links in patch
	6). Due to the complexity and given that S-EPT zapping failure is
	currently only possible due to bugs in the KVM or TDX module, which
	are very rare in a production kernel, this RFC v2 adopts a
	straightforward approach -- simply avoiding holding the page
	reference count in TDX and generating a KVM_BUG_ON() on S-EPT unmap
	failure without propagating the error back to guest_memfd or
	notifying guest_memfd through any out-of-band method.  To be robust
        against bugs, the user can enable panic_on_warn as normal.


Main changes from RFC v1
====
- Switched from using 2MB THP series [4] to HugeTLB based in-place
  conversion series v2 [5] as the huge page allocator. Patches 17 is the
  updated implementation in guest_memfd for punch_hole and
  private-to-shared conversion.

- Rebased onto DPAMT series [7] and pulled patches from [7.1] for DPAMT
  related changes in TDX huge pages. (Patches 19-23).

- Addressed the 4 opens in RFC v1.

- Updated tdh_mem_page_aug(), tdh_phymem_page_wbinvd_hkid(),
  tdh_phymem_page_reclaim(), introduced tdx_clear_folio() to support
  "folios" rather than "pages".

- Renamed kvm_split_boundary_leafs() to kvm_split_cross_boundary_leafs()
  and made it to leverage the existing tdp_mmu_split_huge_pages_root().
  The API is now available to both direct and mirror roots and also usable
  under shared mmu_lock.

- To address the lock issues present in the gmem series [4][5], this RFC v2
  is now based on the RFC patch "KVM: TDX: Decouple TDX init mem region
  from kvm_gmem_populate()" [9].
  (Will rebase to Sean's proposed fixes ([13]-[16]) later when the formal
  patches are available. It's not expected to introduce more than minimal
  change to the implementation of the TDX huge page series.)


Design
====
1. guest_memfd
   Although the TDX huge pages series uses guest_memfd as the huge page
   allocator, it does not depend on the implementation specifics of
   guest_memfd. Therefore, aside from the guest_memfd-specific code in
   patch 17, which calls kvm_split_cross_boundary_leafs() to split private
   mappings for hole punching and private-to-shared conversion, the TDX
   huge pages series can function with either 2MB THP guest_memfd [4] (by
   omitting patch 17) or HugeTLB-based in-place conversion guest_memfd [5].

2. Page size during TD build time
   It's forced to 4KB in the last patch (patch 23), because
   - tdh_mem_page_add() only adds private pages at 4KB.
   - No need to allow merging or splitting during TD build time.

3. Page size during TD runtime
   kvm_tdp_mmu_page_fault() can create mappings up to the 2MB level, as
   determined by TDX's private_max_mapping_level hook. This function can be
   triggered by host pre-faults, guest ACCEPT operations, or guest GPA
   accesses.

   KVM's mapping size can be influenced by the guest's ACCEPT size. When
   faults that carry the guest's ACCEPT level occur, the guest ACCEPT level
   info is passed to the KVM MMU core by setting the GUEST_INHIBIT bit in a
   slot's lpage_info above the guest ACCEPT level. Consequently, the KVM
   MMU core will map up to the guest's ACCEPT level.

   Currently, the GUEST_INHIBIT bit is set in a one-off manner under a
   write mmu_lock. Once set, it will not be unset, and the GFN will not be
   allowed to be mapped at higher levels, even if the mappings are zapped
   and re-accepted by the guest at higher levels later. This approach
   simplifies the code and has been tested to have a minor impact on the
   huge page map count with a typical Linux TD. Future optimizations may
   include setting the GUEST_INHIBIT bit under a shared mmu_lock or
   unsetting the GUEST_INHIBIT bit upon zapping.

4. Page splitting (page demotion)
   Page splitting can occur due to (1) private-to-shared conversion,
   (2) hole punching in guest_memfd, or (3) a guest's ACCEPT operation at
   a lower level than KVM's created mapping.

   With the current TDX module, splitting huge mappings in S-EPT requires
   executing tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
   and tdh_mem_page_demote() in sequence. If DPAMT is involved,
   tdh_phymem_pamt_add() is also required (see bullet 5).

   Currently, only scenario (3) may trigger page splitting under a shared
   mmu_lock. However, to avoid the complexity of handling BUSY errors when
   tdh_mem_page_demote() depends on tdh_mem_range_block(), TDX page
   splitting under a shared mmu_lock is not supported in this series (patch
   11 directly returns -EOPNOTSUPP). This is also prevented by triggering
   the splitting under an exclusive mmu_lock on a fault caused by (3) and
   setting the GUEST_INHIBIT bit in a slot's lpage_info above the guest
   ACCEPT level. Supporting split in the fault path is a TODO for when a
   new TDX module that supports blockless tdh_mem_page_demote() becomes
   available. 

   With an exclusive kvm->mmu_lock, TDX_OPERAND_BUSY is handled similarly
   to removing a private page, i.e., by kicking off all vCPUs and retrying,
   which should succeed on the second attempt.
  
   TDX_INTERRUPTED_RESTARTABLE will not be returned from
   tdh_mem_page_demote() for basic TDX in the new TDX module that is
   currently in planning. Therefore, this error is not handled in this RFC
   v2.

5. Dynamic PAMT
   Currently, DPAMT's involvement with TDX huge pages is limited to page
   splitting.

   This part of design depends on the outcome of the DPAMT series [7]
   design discussions.

   The call stack based on the current design is as follows:

   kvm_split_cross_boundary_leafs
      kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs
         tdp_mmu_split_cross_boundary_leafs
            tdp_mmu_split_huge_pages_root
               1.1 tdp_mmu_alloc_sp_for_split
               1.2 topup_mirror_caches   <-------------------------------
               2.tdp_mmu_split_huge_page                                 |
                    tdp_mmu_link_sp                                      |
                       tdp_mmu_iter_set_spte                             |
                          tdp_mmu_set_spte                               |
                             split_external_spt                          |
                                kvm_x86_call(split_external_spt)         |
                                   tdx_sept_split_private_spt            |
                                      3.1 BLOCK, TRACK                   |
                                      3.2 PAMT_ADD for the adding page --|
                                          table page                     |
                                      3.3 alloc pamt pages for the 2MB --
                                          guest page and DEMOTE

   1.2 allocates PAMT pages in the per-VM KVM MMU memory cache for both
       the adding page table page and the 2MB guest page to be demoted.
       (Patch 21).

   3.2 and 3.3 retrieve the PAMT pages from the per-VM KVM MMU memory
       cache and perform tdh_phymem_pamt_add() and tdh_mem_page_demote().
       Holding of the exclusive mmu_lock after 1.2 and re-checking the
       count of free pages ensure that 3.2 and 3.3 can safely acquire
       enough pages in an atomic context.

6. Page merging (page promotion)
   Promotion is disallowed (in patch 7), because
   - The current TDX module requires all 4KB leafs to be either all PENDING
     or all ACCEPTED before a successful promotion to 2MB. This requirement
     prevents successful page merging after partially converting a 2MB
     range from private to shared and then back to private, which is the
     primary scenario necessitating page promotion.
   - tdh_mem_page_promote() depends on tdh_mem_range_block() in the current
     TDX module. Consequently, handling BUSY errors is complex, as page
     merging typically occurs in the fault path under a shared mmu_lock.


Patches Layout
====
- Patches 01-05: Update SEAMCALL wrappers or page clearing helper.

- Patch 06: Drop holding gmem page refcount in TDX to facilitate
            guest_memfd in-place conversion [5].

- Patch 07: Disallow page merging for TDX.

- Patches 08-11: Enable KVM MMU core to propagate splitting requests to TDX
                 and provide the corresponding implementation in TDX.

- Patch 12: Introduce a higher level API to split pages.

- Patches 13-14: Split and inhibit huge pages in EPT violation handler.

- Patches 15-17: Split huge pages on page conversion/punch hole.

- Patches 18-22: Dynamic PAMT related changes for TDX huge pages.

- Patch 23: Turn on 2MB huge pages.


Testing
===
The kernel code is available at [2].

The code base includes
- kvm-x86-next-2025.07.21 (with shutdown optimization [8])
- guest_memfd code [6]
- DPAMT v2 [7]
- TDX selftests out of [6].

TDX huge pages can be tested with the KVM selftest tdx_vm_huge_page in [2]
or with the matching QEMU [3].

The 2MB mapping count can be checked via "/sys/kernel/debug/kvm/pages_2m".

Huge pages has been verified to work with DPAMT and shutdown optimization
on TDX module version TDX_1.5.20.00.887, though further testing is needed
(e.g., the mmu stress test).


Thanks
Yan

[1] RFC v1: https://lore.kernel.org/all/20250424030033.32635-1-yan.y.zhao@intel.com
[2] Kernel code: https://github.com/intel/tdx/tree/huge_page_v2
[3] QEMU code: https://github.com/intel-staging/qemu-tdx/tree/gmem-tdx-hugepage-v2
[4] 2M THP: https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com
[5] 1G: https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com
[6] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
[7] DPAMT: https://lore.kernel.org/all/20250609191340.2051741-1-kirill.shutemov@linux.intel.com
[7.1] git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge
[8] shutdown: https://lore.kernel.org/all/20250718181541.98146-1-seanjc@google.com 
[9] decouple: https://lore.kernel.org/all/20250703062641.3247-1-yan.y.zhao@intel.com
[10] https://lore.kernel.org/all/4d61104bff388a081ff8f6ae4ac71e05a13e53c3.1708933624.git.isaku.yamahata@intel.com/
[11]https://lore.kernel.org/all/3d2a6bfb033ee1b51f7b875360bd295376c32b54.1708933624.git.isaku.yamahata@intel.com/
[12] https://lore.kernel.org/all/20250424030713.403-1-yan.y.zhao@intel.com
[13] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
[14] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
[15] https://lore.kernel.org/lkml/20250613005400.3694904-2-michael.roth@amd.com
[16] https://lore.kernel.org/all/20250729225455.670324-15-seanjc@google.com
[17] https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com


Edgecombe, Rick P (1):
  KVM: x86/mmu: Disallow page merging (huge page adjustment) for mirror
    root

Isaku Yamahata (1):
  KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table
    splitting

Kirill A. Shutemov (5):
  x86/virt/tdx: Do not perform cache flushes unless CLFLUSH_BEFORE_ALLOC
    is set
  KVM: TDX: Pass down pfn to split_external_spt()
  KVM: TDX: Handle Dynamic PAMT in tdh_mem_page_demote()
  KVM: TDX: Preallocate PAMT pages to be used in split path
  KVM: TDX: Handle Dynamic PAMT on page split

Xiaoyao Li (1):
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()

Yan Zhao (15):
  x86/tdx: Enhance tdh_mem_page_aug() to support huge pages
  x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid() to invalidate huge
    pages
  KVM: TDX: Introduce tdx_clear_folio() to clear huge pages
  x86/tdx: Enhance tdh_phymem_page_reclaim() to support huge pages
  KVM: TDX: Do not hold page refcount on private guest pages
  KVM: x86/tdp_mmu: Add split_external_spt hook called during write
    mmu_lock
  KVM: TDX: Enable huge page splitting under write kvm->mmu_lock
  KVM: x86: Reject splitting huge pages under shared mmu_lock for mirror
    root
  KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
  KVM: x86: Introduce hugepage_set_guest_inhibit()
  KVM: TDX: Split and inhibit huge mappings if a VMExit carries level
    info
  KVM: Change the return type of gfn_handler_t() from bool to int
  KVM: x86: Split cross-boundary mirror leafs for
    KVM_SET_MEMORY_ATTRIBUTES
  KVM: guest_memfd: Split for punch hole and private-to-shared
    conversion
  KVM: TDX: Turn on PG_LEVEL_2M after TD is RUNNABLE

 arch/arm64/kvm/mmu.c               |   8 +-
 arch/loongarch/kvm/mmu.c           |   8 +-
 arch/mips/kvm/mmu.c                |   6 +-
 arch/powerpc/kvm/book3s.c          |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c   |   8 +-
 arch/riscv/kvm/mmu.c               |  12 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   7 +
 arch/x86/include/asm/tdx.h         |  18 ++-
 arch/x86/kvm/mmu.h                 |   3 +
 arch/x86/kvm/mmu/mmu.c             |  85 ++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c         | 208 ++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h         |   3 +
 arch/x86/kvm/vmx/tdx.c             | 238 ++++++++++++++++++++++-------
 arch/x86/kvm/vmx/tdx_arch.h        |   3 +
 arch/x86/virt/vmx/tdx/tdx.c        | 102 ++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h        |   1 +
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/guest_memfd.c             | 142 ++++++++++-------
 virt/kvm/kvm_main.c                |  37 +++--
 20 files changed, 691 insertions(+), 217 deletions(-)

-- 
2.43.2


