Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794A43B7473
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhF2OkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 10:40:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234256AbhF2OkY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 10:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624977476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jRVFmJcbokqFdQc15sbLq2rBFx4NytC1M5MiNC+3llM=;
        b=gsct2UzDQDrteyfWAYPckrRk5gEiMj9hE4/yIjraaaSr12K2fAk8Dq+yVm1wUmAfmfZRC7
        JCCI+NTRhbgyaexhsDE9rJJPpDc8J4Uawl7dg6lNwGaWRGy6fnxMKjOaZpVnlO5pyXhcud
        jeFltEXXwrNGgLZdHOGQvGxTogtaYvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-3-ptyiaYPU63sMUC2of4WQ-1; Tue, 29 Jun 2021 10:37:55 -0400
X-MC-Unique: 3-ptyiaYPU63sMUC2of4WQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE0CA1023F48;
        Tue, 29 Jun 2021 14:37:53 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-112-106.phx2.redhat.com [10.3.112.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A059F60854;
        Tue, 29 Jun 2021 14:37:46 +0000 (UTC)
Subject: [PATCH v3] vfio/pci: Handle concurrent vma faults
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Date:   Tue, 29 Jun 2021 08:37:46 -0600
Message-ID: <162497742783.3883260.3282953006487785034.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

io_remap_pfn_range() will trigger a BUG_ON if it encounters a
populated pte within the mapping range.  This can occur because we map
the entire vma on fault and multiple faults can be blocked behind the
vma_lock.  This leads to traces like the one reported below.

We can use our vma_list to test whether a given vma is mapped to avoid
this issue.

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

Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
Reported-by: Zeng Tao <prime.zeng@hisilicon.com>
Suggested-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 759dfb118712..318864d52837 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1584,6 +1584,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_mmap_vma *mmap_vma;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 
 	mutex_lock(&vdev->vma_lock);
@@ -1591,24 +1592,36 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 
 	if (!__vfio_pci_memory_enabled(vdev)) {
 		ret = VM_FAULT_SIGBUS;
-		mutex_unlock(&vdev->vma_lock);
 		goto up_out;
 	}
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
-		mutex_unlock(&vdev->vma_lock);
-		goto up_out;
+	/*
+	 * We populate the whole vma on fault, so we need to test whether
+	 * the vma has already been mapped, such as for concurrent faults
+	 * to the same vma.  io_remap_pfn_range() will trigger a BUG_ON if
+	 * we ask it to fill the same range again.
+	 */
+	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
+		if (mmap_vma->vma == vma)
+			goto up_out;
 	}
 
-	mutex_unlock(&vdev->vma_lock);
-
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
+			       vma->vm_end - vma->vm_start,
+			       vma->vm_page_prot)) {
 		ret = VM_FAULT_SIGBUS;
+		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+		goto up_out;
+	}
+
+	if (__vfio_pci_add_vma(vdev, vma)) {
+		ret = VM_FAULT_OOM;
+		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	}
 
 up_out:
 	up_read(&vdev->memory_lock);
+	mutex_unlock(&vdev->vma_lock);
 	return ret;
 }
 


