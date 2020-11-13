Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B242B154E
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 06:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKMFQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 00:16:18 -0500
Received: from ozlabs.ru ([107.174.27.60]:54926 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgKMFQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 00:16:18 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2020 00:16:18 EST
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 67D7DAE80053;
        Fri, 13 Nov 2020 00:06:34 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH kernel] vfio_pci_nvlink2: Do not attempt NPU2 setup on old P8's NPU
Date:   Fri, 13 Nov 2020 16:06:32 +1100
Message-Id: <20201113050632.74124-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We execute certain NPU2 setup code (such as mapping an LPID to a device
in NPU2) unconditionally if an Nvlink bridge is detected. However this
cannot succeed on P8+ machines as the init helpers return an error other
than ENODEV which means the device is there is and setup failed so
vfio_pci_enable() fails and pass through is not possible.

This changes the two NPU2 related init helpers to return -ENODEV if
there is no "memory-region" device tree property as this is
the distinction between NPU and NPU2.

Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/pci/vfio_pci_nvlink2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index 65c61710c0e9..9adcf6a8f888 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -231,7 +231,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
 		return -EINVAL;
 
 	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
-		return -EINVAL;
+		return -ENODEV;
 
 	mem_node = of_find_node_by_phandle(mem_phandle);
 	if (!mem_node)
@@ -393,7 +393,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 	int ret;
 	struct vfio_pci_npu2_data *data;
 	struct device_node *nvlink_dn;
-	u32 nvlink_index = 0;
+	u32 nvlink_index = 0, mem_phandle = 0;
 	struct pci_dev *npdev = vdev->pdev;
 	struct device_node *npu_node = pci_device_to_OF_node(npdev);
 	struct pci_controller *hose = pci_bus_to_host(npdev->bus);
@@ -408,6 +408,9 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 	if (!pnv_pci_get_gpu_dev(vdev->pdev))
 		return -ENODEV;
 
+	if (of_property_read_u32(npu_node, "memory-region", &mem_phandle))
+		return -ENODEV;
+
 	/*
 	 * NPU2 normally has 8 ATSD registers (for concurrency) and 6 links
 	 * so we can allocate one register per link, using nvlink index as
-- 
2.17.1

