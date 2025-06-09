Return-Path: <kvm+bounces-48754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5DEEAD2673
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A25CF16FA8C
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5E6221284;
	Mon,  9 Jun 2025 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a8kl45Jh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEEB21FF28;
	Mon,  9 Jun 2025 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496439; cv=none; b=qXPX5E4iHZ5QQTsm+Ih7Wo+kYkh0DHM8Ti46AZuYITiWEPru50bWH8ZQeKE5V7u+ABD+labXACpDEEM1DrWnDZcXUxzguKEyts/ZRw1JKt8UQJrRxx8oWVnvZqT3OV3ArmSmKuf89r1O/EbHmHBoW+fhXvB3d1+3LqJnWhCW/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496439; c=relaxed/simple;
	bh=O1bp7xsLN/UiMI3ANXWRO48aEkLc2NgOL4Ewkr+3Pbk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xih4XfnRv44TsgR/WwWvAReLbQVb1oHL21bytqBRkbbPEIRKaXNYP7Fa3VMSYvy0CwfXoyFktxWWUW1npamcUoYG2crHqsMVBWM4CaTtqjx1hBPYU/TGmF3fDrMFWsQ37/7tUftY9NPjVd1L/8QU7/28LBQgyEb++q707+3ayqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a8kl45Jh; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496437; x=1781032437;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O1bp7xsLN/UiMI3ANXWRO48aEkLc2NgOL4Ewkr+3Pbk=;
  b=a8kl45JhTB+8++Qjgdva8Jbq4SPokvdBACL0lws9OaSE3gVyUNXBj6zJ
   N+xC9GnLsoVqH9H1eFA6j4Jr9MWwYuTlVuEtvgDzjAGvuJR9vm8idGksf
   pyK2/jcLuuCZctgTALXHtMwWeIh+qE6xsRfMTcch4/w/LmJJ8hKo4B8+7
   ws6zbtBwx0LbQHc1oWr+VzYwOTwbPQMAEdhm5yejOAmwmAUaBi3KH22q9
   j9w8FXm5IC36fdFXj5dq8fvbsvjbVGKWWUJ/9nOAxmGcnchRDOj0hoK2j
   XbYkJN6XIEKXVNO2/VH/Y3C/rw0gfUk7Ymm12Qzz8kToVSewDCybr5ifx
   Q==;
X-CSE-ConnectionGUID: qcoV/cKjQqGAUU/ZVlotuA==
X-CSE-MsgGUID: VZPn9mGvSE2EkjKmWWZASg==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681757"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681757"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:13:55 -0700
X-CSE-ConnectionGUID: /k77bWelTqejoOGl2klrTQ==
X-CSE-MsgGUID: JG2hYnBuTWeq7PE0K6f9mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174161"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:51 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id E84151D2; Mon, 09 Jun 2025 22:13:48 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Date: Mon,  9 Jun 2025 22:13:28 +0300
Message-ID: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset enables Dynamic PAMT in TDX. Please review.

Previously, we thought it can get upstreamed after huge page support, but
huge pages require support on guestmemfd side which might take time to hit
upstream. Dynamic PAMT doesn't have dependencies.

The patchset can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt

==========================================================================

The Physical Address Metadata Table (PAMT) holds TDX metadata for
physical memory and must be allocated by the kernel during TDX module
initialization.

The exact size of the required PAMT memory is determined by the TDX
module and may vary between TDX module versions, but currently it is
approximately 0.4% of the system memory. This is a significant
commitment, especially if it is not known upfront whether the machine
will run any TDX guests.

The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
PAMT_2M levels are still allocated on TDX module initialization, but the
PAMT_4K level is allocated dynamically, reducing static allocations to
approximately 0.004% of the system memory.

PAMT memory is dynamically allocated as pages gain TDX protections.
It is reclaimed when TDX protections have been removed from all
pages in a contiguous area.

Dynamic PAMT support in TDX module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Dynamic PAMT is a TDX feature that allows VMM to allocate PAMT_4K as
needed. PAMT_1G and PAMT_2M are still allocated statically at the time of
TDX module initialization. At init stage allocation of PAMT_4K is replaced
with PAMT_PAGE_BITMAP which currently requires one bit of memory per 4k.

VMM is responsible for allocating and freeing PAMT_4K. There's a couple of
new SEAMCALLs for this: TDH.PHYMEM.PAMT.ADD and TDH.PHYMEM.PAMT.REMOVE.
They add/remove PAMT memory in form of page pair. There's no requirement
for these pages to be contiguous.

Page pair supplied via TDH.PHYMEM.PAMT.ADD will cover specified 2M region.
It allows any 4K from the region to be usable by TDX module.

With Dynamic PAMT, a number of SEAMCALLs can now fail due to missing PAMT
memory (TDX_MISSING_PAMT_PAGE_PAIR):

 - TDH.MNG.CREATE
 - TDH.MNG.ADDCX
 - TDH.VP.ADDCX
 - TDH.VP.CREATE
 - TDH.MEM.PAGE.ADD
 - TDH.MEM.PAGE.AUG
 - TDH.MEM.PAGE.DEMOTE
 - TDH.MEM.PAGE.RELOCATE

Basically, if you supply memory to a TD, this memory has to backed by PAMT
memory.

Once no TD uses the 2M range, the PAMT page pair can be reclaimed with
TDH.PHYMEM.PAMT.REMOVE.

TDX module track PAMT memory usage and can give VMM a hint that PAMT
memory can be removed. Such hint is provided from all SEAMCALLs that
removes memory from TD:

 - TDH.MEM.SEPT.REMOVE
 - TDH.MEM.PAGE.REMOVE
 - TDH.MEM.PAGE.PROMOTE
 - TDH.MEM.PAGE.RELOCATE
 - TDH.PHYMEM.PAGE.RECLAIM

With Dynamic PAMT, TDH.MEM.PAGE.DEMOTE takes PAMT page pair as additional
input to populate PAMT_4K on split. TDH.MEM.PAGE.PROMOTE returns no longer
needed PAMT page pair.

PAMT memory is global resource and not tied to a specific TD. TDX modules
maintains PAMT memory in a radix tree addressed by physical address. Each
entry in the tree can be locked with shared or exclusive lock. Any
modification of the tree requires exclusive lock.

Any SEAMCALL that takes explicit HPA as an argument will walk the tree
taking shared lock on entries. It required to make sure that the page
pointed by HPA is of compatible type for the usage.

TDCALLs don't take PAMT locks as none of the take HPA as an argument.

Dynamic PAMT enabling in kernel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Kernel maintains refcounts for every 2M regions with two helpers
tdx_pamt_get() and tdx_pamt_put().

The refcount represents number of users for the PAMT memory in the region.
Kernel calls TDH.PHYMEM.PAMT.ADD on 0->1 transition and
TDH.PHYMEM.PAMT.REMOVE on transition 1->0.

The function tdx_alloc_page() allocates a new page and ensures that it is
backed by PAMT memory. Pages allocated in this manner are ready to be used
for a TD. The function tdx_free_page() frees the page and releases the
PAMT memory for the 2M region if it is no longer needed.

PAMT memory gets allocated as part of TD init, VCPU init, on populating
SEPT tree and adding guest memory (both during TD build and via AUG on
accept). Splitting 2M page into 4K also requires PAMT memory.

PAMT memory removed on reclaim of control pages and guest memory.

Populating PAMT memory on fault and on split is tricky as kernel cannot
allocate memory from the context where it is needed. These code paths use
pre-allocated PAMT memory pools.

Previous attempt on Dynamic PAMT enabling
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The initial attempt at kernel enabling was quite different. It was built
around lazy PAMT allocation: only trying to add a PAMT page pair if a
SEAMCALL fails due to a missing PAMT and reclaiming it based on hints
provided by the TDX module.

The motivation was to avoid duplicating the PAMT memory refcounting that
the TDX module does on the kernel side.

This approach is inherently more racy as there is no serialization of
PAMT memory add/remove against SEAMCALLs that add/remove memory for a TD.
Such serialization would require global locking, which is not feasible.

This approach worked, but at some point it became clear that it could not
be robust as long as the kernel avoids TDX_OPERAND_BUSY loops.
TDX_OPERAND_BUSY will occur as a result of the races mentioned above.

This approach was abandoned in favor of explicit refcounting.

v2:
 - Drop phys_prepare/clenup. Use kvm_get_running_vcpu() to reach per-VCPU PAMT
   memory pool from TDX code instead.
 - Move code that allocates/frees PAMT out of KVM;
 - Allocate refcounts per-memblock, not per-TDMR;
 - Fix free_pamt_metadata() for machines without Dynamic PAMT;
 - Fix refcounting in tdx_pamt_put() error path;
 - Export functions where they are used;
 - Consolidate TDX error handling code;
 - Add documentation for Dynamic PAMT;
 - Mark /proc/meminfo patch [NOT-FOR-UPSTREAM];
Kirill A. Shutemov (12):
  x86/tdx: Consolidate TDX error handling
  x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
  x86/virt/tdx: Allocate reference counters for PAMT memory
  x86/virt/tdx: Add tdx_alloc/free_page() helpers
  KVM: TDX: Allocate PAMT memory in __tdx_td_init()
  KVM: TDX: Allocate PAMT memory in tdx_td_vcpu_init()
  KVM: TDX: Preallocate PAMT pages to be used in page fault path
  KVM: TDX: Handle PAMT allocation in fault path
  KVM: TDX: Reclaim PAMT memory
  [NOT-FOR-UPSTREAM] x86/virt/tdx: Account PAMT memory and print it in
    /proc/meminfo
  x86/virt/tdx: Enable Dynamic PAMT
  Documentation/x86: Add documentation for TDX's Dynamic PAMT

 Documentation/arch/x86/tdx.rst              | 108 ++++++
 arch/x86/coco/tdx/tdx.c                     |   6 +-
 arch/x86/include/asm/kvm_host.h             |   2 +
 arch/x86/include/asm/set_memory.h           |   3 +
 arch/x86/include/asm/tdx.h                  |  40 ++-
 arch/x86/include/asm/tdx_errno.h            |  96 +++++
 arch/x86/include/asm/tdx_global_metadata.h  |   1 +
 arch/x86/kvm/mmu/mmu.c                      |   7 +
 arch/x86/kvm/vmx/tdx.c                      | 102 ++++--
 arch/x86/kvm/vmx/tdx.h                      |   1 -
 arch/x86/kvm/vmx/tdx_errno.h                |  40 ---
 arch/x86/mm/Makefile                        |   2 +
 arch/x86/mm/meminfo.c                       |  11 +
 arch/x86/mm/pat/set_memory.c                |   2 +-
 arch/x86/virt/vmx/tdx/tdx.c                 | 380 +++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h                 |   5 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   3 +
 virt/kvm/kvm_main.c                         |   1 +
 18 files changed, 702 insertions(+), 108 deletions(-)
 create mode 100644 arch/x86/include/asm/tdx_errno.h
 delete mode 100644 arch/x86/kvm/vmx/tdx_errno.h
 create mode 100644 arch/x86/mm/meminfo.c

-- 
2.47.2


