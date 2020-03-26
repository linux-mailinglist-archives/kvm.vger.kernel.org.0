Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2DC5194314
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgCZPZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:21 -0400
Received: from foss.arm.com ([217.140.110.172]:33874 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgCZPZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C0E37FA;
        Thu, 26 Mar 2020 08:25:20 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 945843F71E;
        Thu, 26 Mar 2020 08:25:19 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 23/32] vfio: Reserve ioports when configuring the BAR
Date:   Thu, 26 Mar 2020 15:24:29 +0000
Message-Id: <20200326152438.6218-24-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 4412c6d7a862..fe02574390f6 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -886,7 +886,9 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
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
2.20.1

