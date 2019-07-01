Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8EF629B17
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389919AbfEXPcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 11:32:04 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:45342 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389887AbfEXPcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 11:32:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11F4180D;
        Fri, 24 May 2019 08:32:03 -0700 (PDT)
Received: from en101.cambridge.arm.com (en101.cambridge.arm.com [10.1.196.93])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 429663F575;
        Fri, 24 May 2019 08:32:01 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     linux-mm@kvack.org
Cc:     mgorman@techsingularity.net, akpm@linux-foundation.org,
        mhocko@suse.com, cai@lca.pw, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, suzuki.poulose@arm.com
Subject: [PATCH] mm, compaction: Make sure we isolate a valid PFN
Date:   Fri, 24 May 2019 16:31:48 +0100
Message-Id: <1558711908-15688-1-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190524103924.GN18914@techsingularity.net>
References: <20190524103924.GN18914@techsingularity.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we have holes in a normal memory zone, we could endup having
cached_migrate_pfns which may not necessarily be valid, under heavy memory
pressure with swapping enabled ( via __reset_isolation_suitable(), triggered
by kswapd).

Later if we fail to find a page via fast_isolate_freepages(), we may
end up using the migrate_pfn we started the search with, as valid
page. This could lead to accessing NULL pointer derefernces like below,
due to an invalid mem_section pointer.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008 [47/1825]
 Mem abort info:
   ESR = 0x96000004
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp = 0000000082f94ae9
 [0000000000000008] pgd=0000000000000000
 Internal error: Oops: 96000004 [#1] SMP
 ...
 CPU: 10 PID: 6080 Comm: qemu-system-aar Not tainted 510-rc1+ #6
 Hardware name: AmpereComputing(R) OSPREY EV-883832-X3-0001/OSPREY, BIOS 4819 09/25/2018
 pstate: 60000005 (nZCv daif -PAN -UAO)
 pc : set_pfnblock_flags_mask+0x58/0xe8
 lr : compaction_alloc+0x300/0x950
 [...]
 Process qemu-system-aar (pid: 6080, stack limit = 0x0000000095070da5)
 Call trace:
  set_pfnblock_flags_mask+0x58/0xe8
  compaction_alloc+0x300/0x950
  migrate_pages+0x1a4/0xbb0
  compact_zone+0x750/0xde8
  compact_zone_order+0xd8/0x118
  try_to_compact_pages+0xb4/0x290
  __alloc_pages_direct_compact+0x84/0x1e0
  __alloc_pages_nodemask+0x5e0/0xe18
  alloc_pages_vma+0x1cc/0x210
  do_huge_pmd_anonymous_page+0x108/0x7c8
  __handle_mm_fault+0xdd4/0x1190
  handle_mm_fault+0x114/0x1c0
  __get_user_pages+0x198/0x3c0
  get_user_pages_unlocked+0xb4/0x1d8
  __gfn_to_pfn_memslot+0x12c/0x3b8
  gfn_to_pfn_prot+0x4c/0x60
  kvm_handle_guest_abort+0x4b0/0xcd8
  handle_exit+0x140/0x1b8
  kvm_arch_vcpu_ioctl_run+0x260/0x768
  kvm_vcpu_ioctl+0x490/0x898
  do_vfs_ioctl+0xc4/0x898
  ksys_ioctl+0x8c/0xa0
  __arm64_sys_ioctl+0x28/0x38
  el0_svc_common+0x74/0x118
  el0_svc_handler+0x38/0x78
  el0_svc+0x8/0xc
 Code: f8607840 f100001f 8b011401 9a801020 (f9400400)
 ---[ end trace af6a35219325a9b6 ]---

The issue was reported on an arm64 server with 128GB with holes in the zone
(e.g, [32GB@4GB, 96GB@544GB]), with a swap device enabled, while running 100 KVM
guest instances.

This patch fixes the issue by ensuring that the page belongs to a valid PFN
when we fallback to using the lower limit of the scan range upon failure in
fast_isolate_freepages().

Fixes: 5a811889de10f1eb ("mm, compaction: use free lists to quickly locate a migration target")
Reported-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 mm/compaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9febc8c..9e1b9ac 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1399,7 +1399,7 @@ fast_isolate_freepages(struct compact_control *cc)
 				page = pfn_to_page(highest);
 				cc->free_pfn = highest;
 			} else {
-				if (cc->direct_compaction) {
+				if (cc->direct_compaction && pfn_valid(min_pfn)) {
 					page = pfn_to_page(min_pfn);
 					cc->free_pfn = min_pfn;
 				}
-- 
2.7.4

