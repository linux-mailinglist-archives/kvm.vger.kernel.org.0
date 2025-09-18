Return-Path: <kvm+bounces-58055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A87B8759E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:23:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64E3C56495A
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5302C0F6E;
	Thu, 18 Sep 2025 23:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="msGWxbP3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301644A2D;
	Thu, 18 Sep 2025 23:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237781; cv=none; b=NZ0pHBJcGBNQM6KpgGvG1S+juDDhZs+13qjusfisLI2k9i7eNdymjhoNfAXI5hqXcQ5RxZACb7SMFTm7bWhCgVhQPXhEdkc0UYPuGHjYM3ja0CgdpFOOd9v5JALz+MWunWvoOtW7DVDYaDsEKdbAuMLSz8i+wyo1I279Rbz2emI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237781; c=relaxed/simple;
	bh=QEIC7STtfOyMswSNljOKc/S4NyL5T005GCWQh15pTM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c9rV+qYvbxQRXt/b0O8v2TXOsp64p6K3V/mE8+UFrAu3fnACDITF/LlU4klULVw6iPt7nQyfYz2HNjBN4wCmhqMkFkO0fv37Y4ComMqvPOl9o3lldDJPvDQqqcuAPnMoFcpifm5/pGPkCvdFHPEWxTwgm31uBb+XKfKcvnp1M8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=msGWxbP3; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237779; x=1789773779;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QEIC7STtfOyMswSNljOKc/S4NyL5T005GCWQh15pTM4=;
  b=msGWxbP3UDwxUYBC5HpkMh0wkyZ40Peu6BAamj71/tjFozZCjvqC60Z9
   G74fBa3uyIvj5Dh2zmqq2BitCfkAvjWus3TB2o7dAyFjn3RhSAAgRIajF
   w0qT4BT+fKOLdWVqhP55nHynUuVyKG4j7hqoY1aMrY3ex9DKq8EDfFFoR
   RdwBqDdD8mP9UlNe5vLQnHM78O1AhdTdka8Vx99yBrQXa2VjP9SFlJZu/
   mvyyZoBIZfruKV8Syh6VgYjTJoXQkh7qKA9MyQzWXQ3nVyR1ZoAp/9Zfq
   mxkNPhIws41YBanGatA0JDEIYFoXggHPB9sDn9g8q2jt+CmCO12wc2Wxl
   Q==;
X-CSE-ConnectionGUID: +HCjA7g9TLyW8A2V3l7xIw==
X-CSE-MsgGUID: 0C0JP+6vRYmH5YyjfWiNZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735365"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735365"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:22:59 -0700
X-CSE-ConnectionGUID: NjoWwBaoTCWqg8pLv9UsVw==
X-CSE-MsgGUID: 7tMVKjykQESkJBx+DHAQhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491387"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:22:57 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com
Subject: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Date: Thu, 18 Sep 2025 16:22:08 -0700
Message-ID: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is 3rd revision of Dynamic PAMT, which is a new feature that reduces 
memory use of TDX.

On v2 (as well as in PUCK) there was some discussion of the 
refcount/locking design tradeoffs for Dynamic PAMT. In v2, I’ve basically 
gone through and tried to make the details around this more reviewable. 
The basic solution is the same as v2, with the changes more about moving 
code around or splitting implementations/optimizations. I’m hoping with 
this v3 we can close on whether that approach is good enough or not.

I think the patch quality is in ok shape, but still need some review. 
Maintainers, please feel free to let us go through this v3 for lower level 
code issues, but I would appreciate engagement on the overall design.

Another open still is performance testing, besides the bit about excluding 
contention of the global lock.

Lastly, Yan raised some last minute doubts internally about TDX module 
locking contention. I’m not sure there is a problem, but we can come to an 
agreement as part of the review.

PAMT Background
===============
The TDX module needs to keep data about each physical page it uses. It 
requires the kernel to give it memory to use for this purpose, called 
PAMT. Internally it wants space for metadata for each page *and* each page 
size. That is, if a page is mapped at 2MB in a TD, it doesn’t spread this 
tracking across the allocations it uses for 4KB page size usage of the 
same physical memory. It is designed to use a separate allocation for 
this.

So each memory region that the TDX module could use (aka TDMRs) has three 
of these PAMT allocations. They are all allocated during the global TDX 
initialization, regardless of if the memory is actually getting used for a 
TD. It uses up approximately 0.4% of system memory.

Dynamic PAMT (DPAMT)
====================
Fortunately, only using physical memory for areas of an address space that 
are actually in use is a familiar problem in system engineering, with a 
well trodden solution: page tables. It would be great if TDX could do 
something like that for PAMT. This is basically the idea for Dynamic PAMT.

However, there are some design aspects that could be surprising for anyone 
expecting “PAMT, but page tables”. The following describes these 
differences.

DPAMT Levels
------------
Dynamic PAMT focuses on the page size level that has the biggest PAMT 
allocation - 4KB page size. Since the 2MB and 1GB levels are smaller 
allocations, they are left as the fixed arrays, as in normal PAMT. But the 
4KB page sizes are actually not fully dynamic either, the TDX module still 
requires a physically contiguous space for tracking each 4KB page in a 
TDMR. But this space shrinks significantly, to currently 1 bit per page.

Page Sizes
----------
Like normal PAMT, Dynamic PAMT wants to provide a way for the TDX module 
to have separate PAMT tracking for different page sizes. But unlike normal 
PAMT, it does not seamlessly switch between the 2MB and 4KB page sizes 
without VMM action. It wants the PAMT mapped at the same level that the 
underlying TDX memory is using. In practice this means the VMM needs to 
update the PAMT depending on whether secure EPT pages are to be mapped at 
2MB or 4KB.

While demote/promote have internal handling for these updates (and support 
passing or returning the PAMT pages involved), PAGE.ADD/AUG don’t. Instead 
two new SEAMCALLs are provided for the VMM to configure the PAMT to the 
intended page size (i.e. 4KB if the page will be mapped at 4KB): 
TDH.PHYMEM.PAMT.ADD/REMOVE.

While some operations on TD memory can internally handle the PAMT 
adjustments, the opposite is not true. That is changes in PAMT don’t try 
to automatically change private S-EPT page sizes. Instead an attempt to 
remove 4KB size PAMT pages while will fail if any of the covering range are
in use.

Concurrency
-----------
For every 2MB physical range there could be many 4KB pages used by TDX 
(obviously). But each of those only needs one set of PAMT pages added. So 
on the first use of the 2MB region the DPAMT needs to be installed, and 
after none of the pages in that range are in use, it needs to be freed.

The TDX module actually does track how many pages are using each 2MB range 
and gives hints for refcount of zero. But it is incremented when the 2MB 
region use actually starts. Like:
1.  TDH.PHYMEM.PAMT.ADD (backing for
                         2MB range X,
                         for page Y)
2.  TDH.MEM.PAGE.AUG (page Y)        <- Increments refcount for X.
3.  TDH.MEM.PAGE.REMOVE (page Y)     <- Decrements refcount for X,
                                        gives hint in return value.
4.  TDH.PHYMEM.PAMT.REMOVE (range X) <- Remove, check that each 4KB
                                        page in X is free.

The internal refcount is tricky to use because of the window of time 
between TDH.PHYMEM.PAMT.ADD and TDH.MEM.PAGE.AUG. The PAMT.ADD adds the 
backing, but doesn’t tell the TDX module a VMM intends to map it. Consider 
the range X that includes page Y and Z, for an implementation that tries 
to use these hints:

CPU 0                              CPU 1
TDH.PHYMEM.PAMT.ADD X (returns
                       already
                       mapped)
                                   TDH.MEM.PAGE.REMOVE (Y) (returns
                                                            refcount 0
                                                            hint)
                                   TDH.PHYMEM.PAMT.REMOVE (X)
TDH.MEM.PAGE.AUG Z (fail)


So the TDX module’s DPAMT refcounts don't track what the VMM intends to do 
with the page, only what it has already done. This leaves a window that
needs to be covered.

TDX module locking
------------------
Inside the TDX module there are various locks. The TDX module does not 
wait when it encounters contention, instead it returns a BUSY error code. 
This leaves the VMM with an option to either loop around the SEAMCALL, or 
return an error to the calling code. In some cases in Linux there is not 
an option to return an error from the operation making the SEAMCALL. To 
avoid potentially an indeterminable amount of retries, it opts to kick all 
the threads associated with the TD out of the TDX module and retry. This 
retry operation is fairly easy to do from with KVM.

Since PAMT is a global resource, this means that this lock contention 
could be from any TD. For normal PAMT, the exclusive locks locks are only 
taken at the 4KB page size granularity. In practice, this means any page 
that is not shared  between TDs won’t have to worry about contention. 
However, for DPAMT this changes. The TDH.PHYMEM.PAMT.ADD/REMOVE calls take 
a PAMT lock at 2MB granularity. If two calls try to operate on the same 
2MB region at the same time, one will get the BUSY error code.


Linux Challenges
================
So for dynamic PAMT, Linux needs to:
 1. Allocate a different fixed sized allocation for each TDMR, for the 4KB
    page size (the 1 bit per page bitmap instead of the normal larger
    allocation)
 2. Allocate DPAMT for control structures.
 3. Allocate DPAMT 4KB page backings for all TD private memory (which is
    currently only 4KB) and S-EPT page tables.

1 is easy, just query the new size when DPAMT is in use and use that 
instead of the regular 4KB PAMT size. The bitmap allocation is even passed 
in the same field to the TDX module. If you takeaway the TDX docs naming 
around the bitmap, it’s like a buffer that changes size.

For 2 and 3, there is a lot to consider. For 2, it is relatively easy as 
long as we want to install PAMT on demand since these pages come straight 
from the page allocator and not guestmemfd.

For 3, upstream we currently only have 4KB pages, which means we could 
ignore a lot of the specifics about matching page sizes - there is only 
one. However, TDX huge pages is also in progress. So we should avoid a 
design that would need to be redone immediately.

Installing 4KB DPAMT backings
-----------------------------
Some TDX pages are used for TD control structures. These need to have new 
code to install 4KB DPAMT backings. But the main problem is how do this 
for private memory.

Linux needs to add the DPAMT backing private memory before the page gets 
mapped in the TD. Doing so inside the KVM MMU call paths adds 
complications around the BUSY error code, as described above. It would be 
tempting to install DPAMT pages from a guestmemfd callback. This could 
happen outside the KVM MMU locks.

But there are three complications with this. One is that in case of 2MB 
pages, the guest can control the page size. This means, even if 4KB page 
sizes are installed automatically, KVM would have to handle edge cases of 
PAMT adjustments at runtime anyway. For example memslot deletion and 
re-adding would trigger a zap of huge pages that are later remapped at 
4KB. This could *maybe* be worked around by some variant of this technique 
[0].

Another wrinkle is that Vishal@google has expressed a strong interest in 
saving PAMT memory at runtime in the case of 2MB TD private memory. He 
wants to support a use case where most TD memory is mapped at 2MB, so he 
wants to avoid the overhead of a worse case allocation that assumes all 
memory will be mapped at 4KB.

Finally, pre-installing DPAMT pages before the fault doesn’t help with 
mapping DPAMT pages for the external (S-EPT) page tables that are 
allocated for the fault. So some fault time logic is needed. We could 
pre-install DPAMT backing for the external page table cache, which would 
happen outside of the MMU lock. This would free us from having to update 
DPAMT inside MMU lock. But it would not free KVM from having to do 
anything around DPAMT during a fault.

Three non-show stopping issues tilts things towards using a fault time 
DPAMT installation approach for private memory.

Avoiding duplicate attempts to add/remove DPAMT 
-----------------------------------------------
As covered above, there isn’t a refcount in the TDX module that we can 
use. Using the hints returned by TDH.MEM.PAGE.AUG/REMOVE was tried in v1, 
and Kirill was unable to both overcome the races and make nice with new 
failure scenarios around DPAMT locks. So in v2 refcounts were allocated on 
the kernel side for each 2MB range covered by a TDMR (a range the TDX 
module might use). This adds some small memory overhead of 0.0002%, which 
is small compared to the 0.4% to 0.004% savings of Dynamic PAMT. The major 
downside is code complexity. These allocations are still large and involve 
managing vmalloc space. The v2 solution reserves a vmalloc space to cover 
the entire physical address space, and only maps pages for any ranges that 
are covered by a TDMR.

Avoiding contention
-------------------
As covered above, Linux needs to deal with getting BUSY error codes here. 
The allocation/mapping paths for all these pages can already handle 
failure, but the trickier case is the removal paths. As previously sparred 
with during the base series, TDX module expects to be able to fail these 
calls, but the kernel does not. Further, the refcounts can not act as a 
race free lock on their own. So some synchronization is needed before 
actually removing the DPAMT backings.

V2 of the series includes a global lock to be used around actual 
installation/removal of the DPAMT backing, combined with opportunistic 
checking outside the lock to avoid taking it most of the time. In testing, 
booting 10 16GB TDs, the lock only hit contention 1136 times, with 4ms 
waiting. This is very small for an operation that took 60s of wall time. 
So despite being an (ugly) global lock, the actual impact was small. It 
will probably further be reduced in the case of huge pages, where most of 
the time 4KB DPAMT installation will not be necessary.

Updates in v3
=============
Besides incorporating the feedback and general cleanups, the major design 
change was around how DPAMT backing pages are allocated in the fault path.

Allocating DPAMT pages in v2
----------------------------
In v2, there was a specific page cache added in the generic x86 KVM MMU 
for DPAMT pages. This was needed because much of the fault happens inside 
a spinlock. By the time the fault handler knows whether it needs to 
install DPAMT backing, it can no longer allocate pages. This is a common 
pattern in the KVM MMU, and so pages are pre-allocated before taking the 
MMU spinlock. This way they can be used later if needed.

But KVM’s page cache infrastructure is not easy to pass into the arch/86 
code and inside the global spin lock where the pages would be consumed. So 
instead it passed a pointer to a function inside KVM that it can call to 
allocate pages from the KVM page cache component. Since the control 
structures need DPAMT backing installed outside of the fault, the arch/x86 
code also had logic to allocate pages directly from the page allocator. 
Further, there were various resulting intermediate lists that had to be 
marshaled through the DPMAT allocation paths.

This was all a bit complicated to me.

Updates in v3
-------------
V3 redid the areas described above to try to simplify it.

The KVM MMU already has knowledge that TDX needs special memory allocated 
for S-EPT. From the fault handlers perspective, this could be seen as just 
more memory of the same type. So v3 just turns the external page table 
allocation to an x86 op, and provides another op to allocate from it. This 
is done as refactoring. Then when dynamic PAMT is added the extra pages 
can just be added from within the x86 op in TDX code.

For removing the function pointer callback scheme, the external page 
tables are switched to a dirt simple linked list based page cache. This is 
somewhat reinventing the wheel, but KVM’s kvm_mmu_memory_cache operations 
are not easy to expose to the core kernel, and also TDX doesn’t need much 
of the fanciness of initial values and things like that. Building it out 
of the kernels linked list is enough code reuse.

Today the TDX module needs 2 pages for 2MB region of 4KB size dynamic PAMT 
backing. It would be tempting to just pass two pages in, but the TDX 
module exposes the number of Dynamic PAMT pages it needs as a metadata 
value. So the size is technically variable. To handle this, the design 
just passes in the simple TDX page cache list in the calls that might need 
to allocate dynamic PAMT.

Considerations for v4
=====================
This solution seems workable. It isolated Dynamic PAMT to TDX code, and 
doesn’t introduce any extra constraints to generic x86 KVM code. But the 
refcounts and global lock in arch/x86 side of TDX are still ugly.

There has been some internal discussion about pursuing various schemes to 
avoid this. But before a potential redesign, I wanted to share the current 
version. Both to get feedback on the updates, and so we can consider how 
“good enough” the current design is.

Testing and branch
==================
Testing is a bit light currently. Just TDX selftests, simple TDX Linux
guest boot. The branch is here: 
https://github.com/intel/tdx/commits/dpamt_v3/

Based on kvm_x86/next (603c090664d3)

[0] https://lore.kernel.org/kvm/20250807094423.4644-1-yan.y.zhao@intel.com/

Kirill A. Shutemov (13):
  x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>
  x86/tdx: Add helpers to check return status codes
  x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
  x86/virt/tdx: Allocate reference counters for PAMT memory
  x86/virt/tdx: Improve PAMT refcounters allocation for sparse memory
  x86/virt/tdx: Add tdx_alloc/free_page() helpers
  x86/virt/tdx: Optimize tdx_alloc/free_page() helpers
  KVM: TDX: Allocate PAMT memory for TD control structures
  KVM: TDX: Allocate PAMT memory for vCPU control structures
  KVM: TDX: Handle PAMT allocation in fault path
  KVM: TDX: Reclaim PAMT memory
  x86/virt/tdx: Enable Dynamic PAMT
  Documentation/x86: Add documentation for TDX's Dynamic PAMT

Rick Edgecombe (3):
  x86/virt/tdx: Simplify tdmr_get_pamt_sz()
  KVM: TDX: Add x86 ops for external spt cache
  x86/virt/tdx: Add helpers to allow for pre-allocating pages

 Documentation/arch/x86/tdx.rst              |  21 +
 arch/x86/coco/tdx/tdx.c                     |   6 +-
 arch/x86/include/asm/kvm-x86-ops.h          |   2 +
 arch/x86/include/asm/kvm_host.h             |  11 +-
 arch/x86/include/asm/shared/tdx.h           |   1 +
 arch/x86/include/asm/shared/tdx_errno.h     | 109 +++++
 arch/x86/include/asm/tdx.h                  |  76 ++-
 arch/x86/include/asm/tdx_global_metadata.h  |   1 +
 arch/x86/kvm/mmu/mmu.c                      |   4 +-
 arch/x86/kvm/mmu/mmu_internal.h             |   2 +-
 arch/x86/kvm/vmx/tdx.c                      | 157 ++++--
 arch/x86/kvm/vmx/tdx.h                      |   3 +-
 arch/x86/kvm/vmx/tdx_errno.h                |  40 --
 arch/x86/virt/vmx/tdx/tdx.c                 | 505 +++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h                 |   5 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   3 +
 16 files changed, 766 insertions(+), 180 deletions(-)
 create mode 100644 arch/x86/include/asm/shared/tdx_errno.h
 delete mode 100644 arch/x86/kvm/vmx/tdx_errno.h

-- 
2.51.0


