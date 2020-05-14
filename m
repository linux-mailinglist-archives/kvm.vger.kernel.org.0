Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDBF1D354A
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgENPiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:50 -0400
Received: from foss.arm.com ([217.140.110.172]:39188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgENPis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AB211045;
        Thu, 14 May 2020 08:38:47 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7328B3F71E;
        Thu, 14 May 2020 08:38:46 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 06/12] vfio/pci: Don't write configuration value twice
Date:   Thu, 14 May 2020 16:38:23 +0100
Message-Id: <1589470709-4104-7-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
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
 vfio/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 0b548e4bf9e2..2de893407574 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -3,6 +3,8 @@
 #include "kvm/kvm-cpu.h"
 #include "kvm/vfio.h"
 
+#include <assert.h>
+
 #include <sys/ioctl.h>
 #include <sys/eventfd.h>
 #include <sys/resource.h>
@@ -478,7 +480,10 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	struct vfio_region_info *info;
 	struct vfio_pci_device *pdev;
 	struct vfio_device *vdev;
-	void *base = pci_hdr;
+	u32 tmp;
+
+	/* Make sure a larger size will not overrun tmp on the stack. */
+	assert(sz <= 4);
 
 	if (offset == PCI_ROM_ADDRESS)
 		return;
@@ -498,7 +503,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
 		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
 
-	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
+	if (pread(vdev->fd, &tmp, sz, info->offset + offset) != sz)
 		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
 			      sz, offset);
 }
-- 
2.7.4

