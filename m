Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2932E1AD2F3
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 00:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgDPWvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 18:51:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:49373 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbgDPWvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 18:51:01 -0400
IronPort-SDR: aRe8YSExJc6b+NOKf+/LcTTbrawLHr5zB4eJ1UT3n4uakgnSmWH0Rl48V/SyO4ibo4xEvhapRO
 rolR3tuBKltg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 15:51:00 -0700
IronPort-SDR: 3SWrEXltK0cnP2E2h1Fyod1t7tbH4FXYJ+dEFSp2J6FRqQBb7wyTtq7UxRHsZy1fHUWpLWiP3N
 HAuEvO4RzINA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,392,1580803200"; 
   d="scan'208";a="278029698"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 16 Apr 2020 15:50:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()
Date:   Thu, 16 Apr 2020 15:50:57 -0700
Message-Id: <20200416225057.8449-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use follow_pfn() to get the PFN of a PFNMAP VMA instead of assuming that
vma->vm_pgoff holds the base PFN of the VMA.  This fixes a bug where
attempting to do VFIO_IOMMU_MAP_DMA on an arbitrary PFNMAP'd region of
memory calculates garbage for the PFN.

Hilariously, this only got detected because the first "PFN" calculated
by vaddr_get_pfn() is PFN 0 (vma->vm_pgoff==0), and iommu_iova_to_phys()
uses PA==0 as an error, which triggers a WARN in vfio_unmap_unpin()
because the translation "failed".  PFN 0 is now unconditionally reserved
on x86 in order to mitigate L1TF, which causes is_invalid_reserved_pfn()
to return true and in turns results in vaddr_get_pfn() returning success
for PFN 0.  Eventually the bogus calculation runs into PFNs that aren't
reserved and leads to failure in vfio_pin_map_dma().  The subsequent
call to vfio_remove_dma() attempts to unmap PFN 0 and WARNs.

  WARNING: CPU: 8 PID: 5130 at drivers/vfio/vfio_iommu_type1.c:750 vfio_unmap_unpin+0x2e1/0x310 [vfio_iommu_type1]
  Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio ...
  CPU: 8 PID: 5130 Comm: sgx Tainted: G        W         5.6.0-rc5-705d787c7fee-vfio+ #3
  Hardware name: Intel Corporation Mehlow UP Server Platform/Moss Beach Server, BIOS CNLSE2R1.D00.X119.B49.1803010910 03/01/2018
  RIP: 0010:vfio_unmap_unpin+0x2e1/0x310 [vfio_iommu_type1]
  Code: <0f> 0b 49 81 c5 00 10 00 00 e9 c5 fe ff ff bb 00 10 00 00 e9 3d fe
  RSP: 0018:ffffbeb5039ebda8 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff9a55cbf8d480 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff9a52b771c200
  RBP: 0000000000000000 R08: 0000000000000040 R09: 00000000fffffff2
  R10: 0000000000000001 R11: ffff9a51fa896000 R12: 0000000184010000
  R13: 0000000184000000 R14: 0000000000010000 R15: ffff9a55cb66ea08
  FS:  00007f15d3830b40(0000) GS:ffff9a55d5600000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000561cf39429e0 CR3: 000000084f75f005 CR4: 00000000003626e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   vfio_remove_dma+0x17/0x70 [vfio_iommu_type1]
   vfio_iommu_type1_ioctl+0x9e3/0xa7b [vfio_iommu_type1]
   ksys_ioctl+0x92/0xb0
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x4c/0x180
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f15d04c75d7
  Code: <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48

Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I'm mostly confident this is correct from the standpoint that it generates
the correct VA->PA.  I'm far less confident the end result is what VFIO
wants, there appears to be a fair bit of magic going on that I don't fully
understand, e.g. I'm a bit mystified as to how this ever worked in any
capacity.

Mapping PFNMAP VMAs into the IOMMU without using a mmu_notifier also seems
dangerous, e.g. if the subsystem associated with the VMA unmaps/remaps the
VMA then the IOMMU will end up with stale translations.

Last thought, using PA==0 for the error seems unnecessarily risky, e.g.
why not use something similar to KVM_PFN_ERR_* or an explicit return code?

 drivers/vfio/vfio_iommu_type1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 85b32c325282..c2ada190c5cb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -342,8 +342,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		if (is_invalid_reserved_pfn(*pfn))
+		if (!follow_pfn(vma, vaddr, pfn) &&
+		    is_invalid_reserved_pfn(*pfn))
 			ret = 0;
 	}
 done:
-- 
2.26.0

