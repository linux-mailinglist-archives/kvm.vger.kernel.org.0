Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B171A8007
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391078AbgDNOmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:42:38 -0400
Received: from foss.arm.com ([217.140.110.172]:57148 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391069AbgDNOkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A44E231B;
        Tue, 14 Apr 2020 07:40:12 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BB9A73F73D;
        Tue, 14 Apr 2020 07:40:11 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 13/18] vfio/pci: Don't access unallocated regions
Date:   Tue, 14 Apr 2020 15:39:41 +0100
Message-Id: <20200414143946.1521-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't try to configure a BAR if there is no region associated with it.

Also move the variable declarations from inside the loop to the start of
the function for consistency.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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

