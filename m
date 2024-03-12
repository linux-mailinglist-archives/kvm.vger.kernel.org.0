Return-Path: <kvm+bounces-11685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A081879AAD
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 18:33:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4E0FB21A8C
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 17:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709E31386B9;
	Tue, 12 Mar 2024 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4ZZ53nn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2832A58107;
	Tue, 12 Mar 2024 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710264822; cv=none; b=tyhT9Gl/umg9Dqq3wAJWPqRIHTT0aevTvIWwlq9zra8p7qhN9WJsONqnylwxf5j+dA93uvefPtYoqXcZUReaVyUY4ykamZAUZtKHF4Sb0wrJC5wDS1BMQbv0k3YrlU31NasJtnrr5EFWLGiePobOMeAJrtWDUQqfHcuJf4SPi7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710264822; c=relaxed/simple;
	bh=NCbPjafC35X2dszbUimr93WO79ZvaDGjYwKw9cjmSfs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CHg8zgmDT41arE62vhl6l6KyS6y7NckXE9g0dit+n9+i+w4ShASc09duWCHObDqQjSgsi6c/UiuLnopxp1J6r/z1ptThgm1szmBhanntI4QpcMftpF8h5gIQUI9i27lIuy42IfcK3dM310ZGN3/zexwgrArYTTv+iSONP0HKH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4ZZ53nn; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710264821; x=1741800821;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NCbPjafC35X2dszbUimr93WO79ZvaDGjYwKw9cjmSfs=;
  b=Y4ZZ53nncCg9qGvBNOz6QryCZlBwcONU7m090xJXCKZpV/MuldQHZypV
   OuFCZm9IC1E3I+T2wbuIMArRNsYy5mCNBPZSbCTKb5DrBzS+EaPvwO80J
   eBZfvQS8kCr0NT+KRIeUxMBycICwnG3FSGCEcNV5D9X+sgqVyrMet2kpe
   nGiOb2xyv3E2aEQN+R0XnrZquvKHwTDEeq1e5+xX+x720CPDUuwqs0XZa
   csDr6LJx0dfG69EzpyDe8MYnt5kw4t6+zwTrr1KXaXlojI1MFeaBMKRi4
   Gfa/+wputQqsEMlIF9rKau0EQMBj4Jll5x8ewBamYvNK5jNCb+ZQJXInp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="4919787"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4919787"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 10:33:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16271882"
Received: from gargayus-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.255.231.196])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 10:33:40 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	hao.p.peng@linux.intel.com,
	isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when checking attributes
Date: Tue, 12 Mar 2024 10:33:34 -0700
Message-Id: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix KVM_SET_MEMORY_ATTRIBUTES to not overflow lpage_info array and trigger
KASAN splat, as seen in the private_mem_conversions_test selftest.

When memory attributes are set on a GFN range, that range will have
specific properties applied to the TDP. A huge page cannot be used when
the attributes are inconsistent, so they are disabled for those the
specific huge pages. For internal KVM reasons, huge pages are also not
allowed to span adjacent memslots regardless of whether the backing memory
could be mapped as huge.

What GFNs support which huge page sizes is tracked by an array of arrays
'lpage_info' on the memslot, of ‘kvm_lpage_info’ structs. Each index of
lpage_info contains a vmalloc allocated array of these for a specific
supported page size. The kvm_lpage_info denotes whether a specific huge
page (GFN and page size) on the memslot is supported. These arrays include
indices for unaligned head and tail huge pages.

Preventing huge pages from spanning adjacent memslot is covered by
incrementing the count in head and tail kvm_lpage_info when the memslot is
allocated, but disallowing huge pages for memory that has mixed attributes
has to be done in a more complicated way. During the
KVM_SET_MEMORY_ATTRIBUTES ioctl KVM updates lpage_info for each memslot in
the range that has mismatched attributes. KVM does this a memslot at a
time, and marks a special bit, KVM_LPAGE_MIXED_FLAG, in the kvm_lpage_info
for any huge page. This bit is essentially a permanently elevated count.
So huge pages will not be mapped for the GFN at that page size if the
count is elevated in either case: a huge head or tail page unaligned to
the memslot or if KVM_LPAGE_MIXED_FLAG is set because it has mixed
attributes.

To determine whether a huge page has consistent attributes, the
KVM_SET_MEMORY_ATTRIBUTES operation checks an xarray to make sure it
consistently has the incoming attribute. Since level - 1 huge pages are
aligned to level huge pages, it employs an optimization. As long as the
level - 1 huge pages are checked first, it can just check these and assume
that if each level - 1 huge page contained within the level sized huge
page is not mixed, then the level size huge page is not mixed. This
optimization happens in the helper hugepage_has_attrs().

Unfortunately, although the kvm_lpage_info array representing page size
'level' will contain an entry for an unaligned tail page of size level,
the array for level - 1  will not contain an entry for each GFN at page
size level. The level - 1 array will only contain an index for any
unaligned region covered by level - 1 huge page size, which can be a
smaller region. So this causes the optimization to overflow the level - 1
kvm_lpage_info and perform a vmalloc out of bounds read.

In some cases of head and tail pages where an overflow could happen,
callers skip the operation completely as KVM_LPAGE_MIXED_FLAG is not
required to prevent huge pages as discussed earlier. But for memslots that
are smaller than the 1GB page size, it does call hugepage_has_attrs(). The
issue can be observed simply by compiling the kernel with
CONFIG_KASAN_VMALLOC and running the selftest
“private_mem_conversions_test”, which produces the output like the
following:

BUG: KASAN: vmalloc-out-of-bounds in hugepage_has_attrs+0x7e/0x110
Read of size 4 at addr ffffc900000a3008 by task private_mem_con/169
Call Trace:
  dump_stack_lvl
  print_report
  ? __virt_addr_valid
  ? hugepage_has_attrs
  ? hugepage_has_attrs
  kasan_report
  ? hugepage_has_attrs
  hugepage_has_attrs
  kvm_arch_post_set_memory_attributes
  kvm_vm_ioctl

It is a little ambiguous whether the unaligned tail page should be
expected to have KVM_LPAGE_MIXED_FLAG set. It is not functionally
required, as the unaligned tail pages will already have their
kvm_lpage_info count incremented. The comments imply not setting it on
unaligned head pages is intentional, so fix the callers to skip trying to
set KVM_LPAGE_MIXED_FLAG in this case, and in doing so not call
hugepage_has_attrs().

Also rename hugepage_has_attrs() to __slot_hugepage_has_attrs() because it
is a delicate function that should not be widely used, and only is valid
for ranges covered by the passed slot.

Cc: stable@vger.kernel.org
Fixes: 90b4fe17981e ("KVM: x86: Disallow hugepages when memory attributes are mixed")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
Hi,

I added cc stable because I didn't rule out a way to trigger a non-kasan
crash from userspace on non-x86. But of course this is a testing only
feature at this point and shouldn't cause a crash for normal users.

Testing was just the upstream selftests and a TDX guest boot on out of tree
branch.

Rick
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0544700ca50b..4dac778b2520 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7337,8 +7337,8 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
 }
 
-static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       gfn_t gfn, int level, unsigned long attrs)
+static bool __slot_hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
+				      gfn_t gfn, int level, unsigned long attrs)
 {
 	const unsigned long start = gfn;
 	const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
@@ -7388,8 +7388,9 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 			 * by the memslot, KVM can't use a hugepage due to the
 			 * misaligned address regardless of memory attributes.
 			 */
-			if (gfn >= slot->base_gfn) {
-				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+			if (gfn >= slot->base_gfn &&
+			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
+				if (__slot_hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 					hugepage_clear_mixed(slot, gfn, level);
 				else
 					hugepage_set_mixed(slot, gfn, level);
@@ -7411,7 +7412,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 		 */
 		if (gfn < range->end &&
 		    (gfn + nr_pages) <= (slot->base_gfn + slot->npages)) {
-			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+			if (__slot_hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
 			else
 				hugepage_set_mixed(slot, gfn, level);
@@ -7449,7 +7450,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 		for (gfn = start; gfn < end; gfn += nr_pages) {
 			unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
 
-			if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
+			if (__slot_hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 				hugepage_clear_mixed(slot, gfn, level);
 			else
 				hugepage_set_mixed(slot, gfn, level);

base-commit: 5abf6dceb066f2b02b225fd561440c98a8062681
-- 
2.34.1


