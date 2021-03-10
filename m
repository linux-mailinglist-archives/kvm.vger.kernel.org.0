Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14C3345C0
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhCJRx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 12:53:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233141AbhCJRxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 12:53:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615398822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PuJS7Uwxjf6BC5NU8Y7Fju1Ajk5eXmk9D7KP7XIVI9E=;
        b=PYdhZt9RcIJVy+lJMjN72MeEqZcQgoUQn9jWNIvI141Nm81AUCG8INl3j0JE7Y54TIJKqO
        z427OpoiUEonIEQIgnlVntNvupvp1jah9YNRMv70gf61psm3S1thBtWuHUncTCIfBYW/HC
        jye2QlYMv9qV1bKbWbTibvYtPl4RBZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-a6dvy-ReNKWEL7uMIW-mrg-1; Wed, 10 Mar 2021 12:53:38 -0500
X-MC-Unique: a6dvy-ReNKWEL7uMIW-mrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23ECE808259;
        Wed, 10 Mar 2021 17:53:37 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04846E15C;
        Wed, 10 Mar 2021 17:53:29 +0000 (UTC)
Subject: [PATCH] vfio/pci: Handle concurrent vma faults
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Date:   Wed, 10 Mar 2021 10:53:29 -0700
Message-ID: <161539852724.8302.17137130175894127401.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_mmap_fault() incorrectly makes use of io_remap_pfn_range()
from within a vm_ops fault handler.  This function will trigger a
BUG_ON if it encounters a populated pte within the remapped range,
where any fault is meant to populate the entire vma.  Concurrent
inflight faults to the same vma will therefore hit this issue,
triggering traces such as:

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

Switch to using vmf_insert_pfn_prot() so that we can retain the
decrypted memory protection from io_remap_pfn_range(), but allow
concurrent page table updates.  Tracking of vmas is also updated to
prevent duplicate entries.

Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
Reported-by: Zeng Tao <prime.zeng@hisilicon.com>
Suggested-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Zeng Tao, I hope you don't mind me sending a new version to keep
this moving.  Testing and review appreciated, thanks!

 drivers/vfio/pci/vfio_pci.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578..ae723808e08b 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1573,6 +1573,11 @@ static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
 
+	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
+		if (mmap_vma->vma == vma)
+			return 0; /* Swallow the error, the vma is tracked */
+	}
+
 	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
 	if (!mmap_vma)
 		return -ENOMEM;
@@ -1612,31 +1617,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
+	unsigned long vaddr = vma->vm_start, pfn = vma->vm_pgoff;
+	vm_fault_t ret = VM_FAULT_SIGBUS;
 
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
 
-	if (!__vfio_pci_memory_enabled(vdev)) {
-		ret = VM_FAULT_SIGBUS;
-		mutex_unlock(&vdev->vma_lock);
+	if (!__vfio_pci_memory_enabled(vdev))
 		goto up_out;
+
+	for (; vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
+		ret = vmf_insert_pfn_prot(vma, vaddr, pfn,
+					  pgprot_decrypted(vma->vm_page_prot));
+		if (ret != VM_FAULT_NOPAGE) {
+			zap_vma_ptes(vma, vma->vm_start, vaddr - vma->vm_start);
+			goto up_out;
+		}
 	}
 
 	if (__vfio_pci_add_vma(vdev, vma)) {
 		ret = VM_FAULT_OOM;
-		mutex_unlock(&vdev->vma_lock);
-		goto up_out;
+		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 	}
 
-	mutex_unlock(&vdev->vma_lock);
-
-	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		ret = VM_FAULT_SIGBUS;
-
 up_out:
 	up_read(&vdev->memory_lock);
+	mutex_unlock(&vdev->vma_lock);
 	return ret;
 }
 

