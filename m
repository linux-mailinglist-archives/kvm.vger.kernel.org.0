Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDFB19430E
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgCZPZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:11 -0400
Received: from foss.arm.com ([217.140.110.172]:33782 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbgCZPZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DE6C7FA;
        Thu, 26 Mar 2020 08:25:09 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 63C913F71E;
        Thu, 26 Mar 2020 08:25:08 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 13/32] vfio/pci: Don't access unallocated regions
Date:   Thu, 26 Mar 2020 15:24:19 +0000
Message-Id: <20200326152438.6218-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't try to configure a BAR if there is no region associated with it.

Also move the variable declarations from inside the loop to the start of
the function for consistency.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 1f38f90c3ae9..4412c6d7a862 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -645,16 +645,19 @@ static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
 static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 {
 	int i;
+	u64 base;
 	ssize_t hdr_sz;
 	struct msix_cap *msix;
 	struct vfio_region_info *info;
 	struct vfio_pci_device *pdev = &vdev->pci;
+	struct vfio_region *region;
 
 	/* Initialise the BARs */
 	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
-		u64 base;
-		struct vfio_region *region = &vdev->regions[i];
+		if ((u32)i == vdev->info.num_regions)
+			break;
 
+		region = &vdev->regions[i];
 		/* Construct a fake reg to match what we've mapped. */
 		if (region->is_ioport) {
 			base = (region->port_base & PCI_BASE_ADDRESS_IO_MASK) |
@@ -853,11 +856,12 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 	u32 bar;
 	size_t map_size;
 	struct vfio_pci_device *pdev = &vdev->pci;
-	struct vfio_region *region = &vdev->regions[nr];
+	struct vfio_region *region;
 
 	if (nr >= vdev->info.num_regions)
 		return 0;
 
+	region = &vdev->regions[nr];
 	bar = pdev->hdr.bar[nr];
 
 	region->vdev = vdev;
-- 
2.20.1

