Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB3A146996
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAWNsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:38 -0500
Received: from foss.arm.com ([217.140.110.172]:39760 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgAWNsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7157511B3;
        Thu, 23 Jan 2020 05:48:37 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 683773F68E;
        Thu, 23 Jan 2020 05:48:36 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 14/30] vfio/pci: Don't access potentially unallocated regions
Date:   Thu, 23 Jan 2020 13:47:49 +0000
Message-Id: <20200123134805.1993-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't try to configure a BAR if there is no region associated with it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 1f38f90c3ae9..f86a7d9b7032 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -652,6 +652,8 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
 
 	/* Initialise the BARs */
 	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
+		if ((u32)i == vdev->info.num_regions)
+			break;
 		u64 base;
 		struct vfio_region *region = &vdev->regions[i];
 
@@ -853,11 +855,12 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
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

