Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A5914699C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAWNst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:49 -0500
Received: from foss.arm.com ([217.140.110.172]:39832 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbgAWNst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B91C3FEC;
        Thu, 23 Jan 2020 05:48:48 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B79BA3F68E;
        Thu, 23 Jan 2020 05:48:47 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 23/30] vfio: Reserve ioports when configuring the BAR
Date:   Thu, 23 Jan 2020 13:47:58 +0000
Message-Id: <20200123134805.1993-24-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's be consistent and reserve ioports when we are configuring the BAR,
not when we map it, just like we do with mmio regions.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c | 9 +++------
 vfio/pci.c  | 4 +++-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index 73fdac8be675..6b9b58ea8d2f 100644
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
index f86a7d9b7032..abde16dc8693 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -885,7 +885,9 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
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

