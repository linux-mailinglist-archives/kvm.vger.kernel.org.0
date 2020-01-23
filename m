Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0161469A0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgAWNsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:52 -0500
Received: from foss.arm.com ([217.140.110.172]:39838 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbgAWNsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC71AFEC;
        Thu, 23 Jan 2020 05:48:49 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ED6593F68E;
        Thu, 23 Jan 2020 05:48:48 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 24/30] vfio/pci: Don't write configuration value twice
Date:   Thu, 23 Jan 2020 13:47:59 +0000
Message-Id: <20200123134805.1993-25-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
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
index abde16dc8693..8a775a4a4a54 100644
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

