Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D46FB164
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbjEHNXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 09:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjEHNXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 09:23:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642E383;
        Mon,  8 May 2023 06:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683552229; x=1715088229;
  h=from:to:cc:subject:date:message-id;
  bh=8SCm4wFEaCHIjaaMs+tOcclnzwJ0N0aJVRlTnjeWArY=;
  b=NxiT+kvP3EHjRZBkF5hpSVX3nOEH2ECltC9x5L/ltmwX9zMnx3uEXJsE
   cXp9fJvTCLCPm0QSJlcj1VkAyCv6iM4jV6cwmcWDB8120J/uC1Im+E73q
   hoWwtzAaw+PQxIi7b/es5uG6mOVLh7w1TPe8PPyM3m9lG9agMxa4giuny
   Y8JIz3unikABksYQ80hBiDwC/gC+wPh7K/WWpXaQFe1H/J/QIzW/ac+jq
   MpAqKvOAKzzq+XiKN8tMSoiFBqMbO3b6sBUGRsgMrI3XDhlqJ207M3dDf
   8FZpn+bWwnMbH956OOTctospTcuCmtkKGp7skcsYXWXXRksChEUxDPipf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="349674058"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="349674058"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 06:23:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="648873705"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="648873705"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 06:23:46 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Date:   Mon,  8 May 2023 20:58:42 +0800
Message-Id: <20230508125842.28193-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In VFIO type1, vaddr_get_pfns() will try fault in MMIO PFNs after
pin_user_pages_remote() returns -EFAULT.

follow_fault_pfn
 fixup_user_fault
  handle_mm_fault
   handle_mm_fault
    do_fault
     do_shared_fault
      do_fault
       __do_fault
        vfio_pci_mmap_fault
         io_remap_pfn_range
          remap_pfn_range
           track_pfn_remap
            vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)
           remap_pfn_range_notrack
            vm_flags_set         ==> mmap_assert_write_locked(vma->vm_mm)

As io_remap_pfn_range() will call vm_flags_set() to update vm_flags [1],
holding of mmap write lock is required.
So, update vfio_pci_mmap_fault() to drop mmap read lock and take mmap
write lock.

[1] https://lkml.kernel.org/r/20230126193752.297968-3-surenb@google.com
commit bc292ab00f6c ("mm: introduce vma->vm_flags wrapper functions")
commit 1c71222e5f23
("mm: replace vma->vm_flags direct modifications with modifier calls")

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..5082f89152b3 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1687,6 +1687,12 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	struct vfio_pci_mmap_vma *mmap_vma;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 
+	mmap_assert_locked(vma->vm_mm);
+	mmap_read_unlock(vma->vm_mm);
+
+	if (mmap_write_lock_killable(vma->vm_mm))
+		return VM_FAULT_RETRY;
+
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
 
@@ -1726,6 +1732,17 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 up_out:
 	up_read(&vdev->memory_lock);
 	mutex_unlock(&vdev->vma_lock);
+	mmap_write_unlock(vma->vm_mm);
+
+	/* If PTE is installed successfully, add the completed flag to
+	 * indicate mmap lock is released,
+	 * otherwise retake the read lock
+	 */
+	if (ret == VM_FAULT_NOPAGE)
+		ret |= VM_FAULT_COMPLETED;
+	else
+		mmap_read_lock(vma->vm_mm);
+
 	return ret;
 }
 

base-commit: 705b004ee377b789e39ae237519bab714297ac83
-- 
2.17.1

