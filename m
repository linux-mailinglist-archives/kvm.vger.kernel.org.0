Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23EF1D3547
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgENPip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:45 -0400
Received: from foss.arm.com ([217.140.110.172]:39174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgENPip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEAA611B3;
        Thu, 14 May 2020 08:38:44 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C58D73F71E;
        Thu, 14 May 2020 08:38:43 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 04/12] vfio: Reserve ioports when configuring the BAR
Date:   Thu, 14 May 2020 16:38:21 +0100
Message-Id: <1589470709-4104-5-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's be consistent and reserve ioports when we are configuring the BAR,
not when we map it, just like we do with mmio regions.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c | 9 +++------
 vfio/pci.c  | 4 +++-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index b80ebf3bb913..bad3c7c8cd26 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -202,14 +202,11 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
 				  struct vfio_region *region)
 {
 	if (region->is_ioport) {
-		int port = pci_get_io_port_block(region->info.size);
-
-		port = ioport__register(kvm, port, &vfio_ioport_ops,
-					region->info.size, region);
+		int port = ioport__register(kvm, region->port_base,
+					   &vfio_ioport_ops, region->info.size,
+					   region);
 		if (port < 0)
 			return port;
-
-		region->port_base = port;
 		return 0;
 	}
 
diff --git a/vfio/pci.c b/vfio/pci.c
index 89d29b89db43..0b548e4bf9e2 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -894,7 +894,9 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 		}
 	}
 
-	if (!region->is_ioport) {
+	if (region->is_ioport) {
+		region->port_base = pci_get_io_port_block(region->info.size);
+	} else {
 		/* Grab some MMIO space in the guest */
 		map_size = ALIGN(region->info.size, PAGE_SIZE);
 		region->guest_phys_addr = pci_get_mmio_block(map_size);
-- 
2.7.4

