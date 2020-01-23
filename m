Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921FA146995
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAWNsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:37 -0500
Received: from foss.arm.com ([217.140.110.172]:39750 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgAWNsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30D20106F;
        Thu, 23 Jan 2020 05:48:36 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2BF943F68E;
        Thu, 23 Jan 2020 05:48:35 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 13/30] vfio/pci: Ignore expansion ROM BAR writes
Date:   Thu, 23 Jan 2020 13:47:48 +0000
Message-Id: <20200123134805.1993-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To get the size of the expansion ROM, software writes 0xfffff800 to the
expansion ROM BAR in the PCI configuration space. PCI emulation executes
the optional configuration space write callback that a device can
implement before emulating this write.

VFIO doesn't have support for emulating expansion ROMs. However, the
callback writes the guest value to the hardware BAR, and then it reads
it back to the BAR to make sure the write has completed successfully.

After this, we return to regular PCI emulation and because the BAR is
no longer 0, we write back to the BAR the value that the guest used to
get the size. As a result, the guest will think that the ROM size is
0x800 after the subsequent read and we end up unintentionally exposing
to the guest a BAR which we don't emulate.

Let's fix this by ignoring writes to the expansion ROM BAR.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/vfio/pci.c b/vfio/pci.c
index 1bdc20038411..1f38f90c3ae9 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -472,6 +472,9 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	struct vfio_device *vdev;
 	void *base = pci_hdr;
 
+	if (offset == PCI_ROM_ADDRESS)
+		return;
+
 	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
 	vdev = container_of(pdev, struct vfio_device, pci);
 	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
-- 
2.20.1

