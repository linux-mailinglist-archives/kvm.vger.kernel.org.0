Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE4A194315
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgCZPZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:23 -0400
Received: from foss.arm.com ([217.140.110.172]:33890 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgCZPZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B093F7FA;
        Thu, 26 Mar 2020 08:25:22 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C9A183F71E;
        Thu, 26 Mar 2020 08:25:21 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 25/32] vfio/pci: Don't write configuration value twice
Date:   Thu, 26 Mar 2020 15:24:31 +0000
Message-Id: <20200326152438.6218-26-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After writing to the device fd as part of the PCI configuration space
emulation, we read back from the device to make sure that the write
finished. The value is read back into the PCI configuration space and
afterwards, the same value is copied by the PCI emulation code. Let's
read from the device fd into a temporary variable, to prevent this
double write.

The double write is harmless in itself. But when we implement
reassignable BARs, we need to keep track of the old BAR value, and the
VFIO code is overwritting it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index fe02574390f6..8b2a0c8dbac3 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -470,7 +470,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	struct vfio_region_info *info;
 	struct vfio_pci_device *pdev;
 	struct vfio_device *vdev;
-	void *base = pci_hdr;
+	u32 tmp;
 
 	if (offset == PCI_ROM_ADDRESS)
 		return;
@@ -490,7 +490,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
 		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
 
-	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
+	if (pread(vdev->fd, &tmp, sz, info->offset + offset) != sz)
 		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
 			      sz, offset);
 }
-- 
2.20.1

