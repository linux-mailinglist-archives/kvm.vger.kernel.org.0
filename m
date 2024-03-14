Return-Path: <kvm+bounces-11836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC0187C4C4
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A69361C20C98
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B1B768EF;
	Thu, 14 Mar 2024 21:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ihpwlybX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6A97581E;
	Thu, 14 Mar 2024 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710451753; cv=none; b=KOWM87bd488E6nAI7LNnNtJs5Cv69x4ZPHTjOnAeXmABASDh4vbIJ9X8rEM4dCngKSb6XJ7er8a0gg7ozZi9qjfpQkkxn/wKZgGd/pPGfB7ePilx1+uwe037jud0b3gQXaIJNGspGZcLV4GQhxMUVAZ0vyTF3UvVcZ4aNq+YBJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710451753; c=relaxed/simple;
	bh=MED+h4DCUYshDs2E/vNHLvvckMSgAWgEgs04Lf97qwU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CM9UQ0lvDYiKCgylDsVBCS/D07CWZc3sVK5BB4IVSF93h7iswskGpY2n+zv3uvjsLSoq4KD7CFqS7YolCSQUY30gDAcsDENvhlj7NcUmxx+OtUmH3DiUTp1I3sJyqPhiYrrBfbimJAtZdNNSylqyJA4wkntTQiPdf0/5MeMWa0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ihpwlybX; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710451752; x=1741987752;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MED+h4DCUYshDs2E/vNHLvvckMSgAWgEgs04Lf97qwU=;
  b=ihpwlybXzWzEJyrKZIeGQk0v8p2xXCdWKiy8tgEGNs3O/zU1NvHSQX2p
   XkFBWgT0lO6aUiqSgBXEn+t57rLHWAtp04Q0anGIZfWnuJKN3qeivWF0U
   KSchBSiDX0DO9nI2LjR4664HMEWEgdGMdP7Pga84J4W42p1Lof2iAQSZl
   r3QQODUOnPWEAI4I/17YIj8eyohNpvusmftaeFRJoYGTfCk5LhlcJBlws
   nYtfi/y0p81i3HnNE9vR/RpxETP8zSxFyfx0gQKxphlxGeGv3xFZK5/pK
   TJQOr2YzcA5RWoKDMyh5Na1BQ2PFE8qZl9mzBEaHMFD3C7Z1RSNH3IOL0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5169268"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5169268"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 14:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12350447"
Received: from svvasiak-mobl.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.81.54])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 14:29:09 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	chao.p.peng@linux.intel.com,
	isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH v2] KVM: x86/mmu: x86: Don't overflow lpage_info when checking attributes
Date: Thu, 14 Mar 2024 14:29:02 -0700
Message-Id: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>
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
are smaller than the 1GB page size, it does call hugepage_has_attrs(). In
this case the huge page is both the head and tail page. The issue can be
observed simply by compiling the kernel with CONFIG_KASAN_VMALLOC and
running the selftest “private_mem_conversions_test”, which produces the
output like the following:

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

It is a little ambiguous whether the unaligned head page (in the bug case 
also the tail page) should be expected to have KVM_LPAGE_MIXED_FLAG set. 
It is not functionally required, as the unaligned head/tail pages will 
already have their kvm_lpage_info count incremented. The comments imply 
not setting it on unaligned head pages is intentional, so fix the callers 
to skip trying to set KVM_LPAGE_MIXED_FLAG in this case, and in doing so 
not call hugepage_has_attrs().

Cc: stable@vger.kernel.org
Fixes: 90b4fe17981e ("KVM: x86: Disallow hugepages when memory attributes are mixed")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v2:
 - Drop function rename (Sean)
 - Clarify in commit log that this is only head pages that are also tail
   pages (Sean)
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0544700ca50b..42e7de604bb6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7388,7 +7388,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 			 * by the memslot, KVM can't use a hugepage due to the
 			 * misaligned address regardless of memory attributes.
 			 */
-			if (gfn >= slot->base_gfn) {
+			if (gfn >= slot->base_gfn &&
+			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
 				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
 					hugepage_clear_mixed(slot, gfn, level);
 				else
-- 
2.34.1


