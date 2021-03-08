Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E24330C14
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 12:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCHLRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 06:17:25 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13071 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbhCHLRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 06:17:19 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DvG2t2cX8zMkKk;
        Mon,  8 Mar 2021 19:15:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Mar 2021 19:17:10 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <alex.williamson@redhat.com>
CC:     <linuxarm@huawei.com>, Zeng Tao <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        "Jann Horn" <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Date:   Mon, 8 Mar 2021 19:11:26 +0800
Message-ID: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have met the following error when test with DPDK testpmd:
[ 1591.733256] kernel BUG at mm/memory.c:2177!
[ 1591.739515] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[ 1591.747381] Modules linked in: vfio_iommu_type1 vfio_pci vfio_virqfd vfio pv680_mii(O)
[ 1591.760536] CPU: 2 PID: 227 Comm: lcore-worker-2 Tainted: G O 5.11.0-rc3+ #1
[ 1591.770735] Hardware name:  , BIOS HixxxxFPGA 1P B600 V121-1
[ 1591.778872] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
[ 1591.786134] pc : remap_pfn_range+0x214/0x340
[ 1591.793564] lr : remap_pfn_range+0x1b8/0x340
[ 1591.799117] sp : ffff80001068bbd0
[ 1591.803476] x29: ffff80001068bbd0 x28: 0000042eff6f0000
[ 1591.810404] x27: 0000001100910000 x26: 0000001300910000
[ 1591.817457] x25: 0068000000000fd3 x24: ffffa92f1338e358
[ 1591.825144] x23: 0000001140000000 x22: 0000000000000041
[ 1591.832506] x21: 0000001300910000 x20: ffffa92f141a4000
[ 1591.839520] x19: 0000001100a00000 x18: 0000000000000000
[ 1591.846108] x17: 0000000000000000 x16: ffffa92f11844540
[ 1591.853570] x15: 0000000000000000 x14: 0000000000000000
[ 1591.860768] x13: fffffc0000000000 x12: 0000000000000880
[ 1591.868053] x11: ffff0821bf3d01d0 x10: ffff5ef2abd89000
[ 1591.875932] x9 : ffffa92f12ab0064 x8 : ffffa92f136471c0
[ 1591.883208] x7 : 0000001140910000 x6 : 0000000200000000
[ 1591.890177] x5 : 0000000000000001 x4 : 0000000000000001
[ 1591.896656] x3 : 0000000000000000 x2 : 0168044000000fd3
[ 1591.903215] x1 : ffff082126261880 x0 : fffffc2084989868
[ 1591.910234] Call trace:
[ 1591.914837]  remap_pfn_range+0x214/0x340
[ 1591.921765]  vfio_pci_mmap_fault+0xac/0x130 [vfio_pci]
[ 1591.931200]  __do_fault+0x44/0x12c
[ 1591.937031]  handle_mm_fault+0xcc8/0x1230
[ 1591.942475]  do_page_fault+0x16c/0x484
[ 1591.948635]  do_translation_fault+0xbc/0xd8
[ 1591.954171]  do_mem_abort+0x4c/0xc0
[ 1591.960316]  el0_da+0x40/0x80
[ 1591.965585]  el0_sync_handler+0x168/0x1b0
[ 1591.971608]  el0_sync+0x174/0x180
[ 1591.978312] Code: eb1b027f 540000c0 f9400022 b4fffe02 (d4210000)

The cause is that the vfio_pci_mmap_fault function is not reentrant, if
multiple threads access the same address which will lead to a page fault
at the same time, we will have the above error.

Fix the issue by making the vfio_pci_mmap_fault reentrant, and there is
another issue that when the io_remap_pfn_range fails, we need to undo
the __vfio_pci_add_vma, fix it by moving the __vfio_pci_add_vma down
after the io_remap_pfn_range.

Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
---
 drivers/vfio/pci/vfio_pci.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b..6928c37 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1613,6 +1613,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
+	unsigned long pfn;
 
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
@@ -1623,18 +1624,23 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 		goto up_out;
 	}
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
+	if (!follow_pfn(vma, vma->vm_start, &pfn)) {
 		mutex_unlock(&vdev->vma_lock);
 		goto up_out;
 	}
 
-	mutex_unlock(&vdev->vma_lock);
 
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
 		ret = VM_FAULT_SIGBUS;
+		mutex_unlock(&vdev->vma_lock);
+		goto up_out;
+	}
+
+	if (__vfio_pci_add_vma(vdev, vma))
+		ret = VM_FAULT_OOM;
 
+	mutex_unlock(&vdev->vma_lock);
 up_out:
 	up_read(&vdev->memory_lock);
 	return ret;
-- 
2.8.1

