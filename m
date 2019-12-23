Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400CD129097
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 02:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLWBJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 20:09:31 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:42768 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfLWBJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Dec 2019 20:09:30 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 384C8AE80026;
        Sun, 22 Dec 2019 20:08:19 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH kernel] vfio/spapr/nvlink2: Skip unpinning pages on error exit
Date:   Mon, 23 Dec 2019 12:09:27 +1100
Message-Id: <20191223010927.79843-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nvlink2 subdriver for IBM Witherspoon machines preregisters
GPU memory in the IOMMI API so KVM TCE code can map this memory
for DMA as well. This is done by mm_iommu_newdev() called from
vfio_pci_nvgpu_regops::mmap.

In an unlikely event of failure the data->mem remains NULL and
since mm_iommu_put() (which unregisters the region and unpins memory
if that was regular memory) does not expect mem==NULL, it should not be
called.

This adds a check to only call mm_iommu_put() for a valid data->mem.

Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/pci/vfio_pci_nvlink2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index f2983f0f84be..3f5f8198a6bb 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -97,8 +97,10 @@ static void vfio_pci_nvgpu_release(struct vfio_pci_device *vdev,
 
 	/* If there were any mappings at all... */
 	if (data->mm) {
-		ret = mm_iommu_put(data->mm, data->mem);
-		WARN_ON(ret);
+		if (data->mem) {
+			ret = mm_iommu_put(data->mm, data->mem);
+			WARN_ON(ret);
+		}
 
 		mmdrop(data->mm);
 	}
-- 
2.17.1

