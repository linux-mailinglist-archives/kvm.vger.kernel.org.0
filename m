Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDC8324845
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhBYBD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:03:58 -0500
Received: from foss.arm.com ([217.140.110.172]:58540 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236653AbhBYBCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06C591477;
        Wed, 24 Feb 2021 17:00:51 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD6EF3F73B;
        Wed, 24 Feb 2021 17:00:49 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 16/22] vfio: Switch to new ioport trap handlers
Date:   Thu, 25 Feb 2021 00:59:09 +0000
Message-Id: <20210225005915.26423-17-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the vfio device has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/core.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index ddd3c2c7..3ff2c0b0 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -81,7 +81,7 @@ out_free_buf:
 	return ret;
 }
 
-static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
+static bool vfio_ioport_in(struct vfio_region *region, u32 offset,
 			    void *data, int len)
 {
 	struct vfio_device *vdev = region->vdev;
@@ -115,7 +115,7 @@ static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
 	return true;
 }
 
-static bool _vfio_ioport_out(struct vfio_region *region, u32 offset,
+static bool vfio_ioport_out(struct vfio_region *region, u32 offset,
 			     void *data, int len)
 {
 	struct vfio_device *vdev = region->vdev;
@@ -155,30 +155,11 @@ static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 	u32 offset = addr - region->port_base;
 
 	if (is_write)
-		_vfio_ioport_out(region, offset, data, len);
+		vfio_ioport_out(region, offset, data, len);
 	else
-		_vfio_ioport_in(region, offset, data, len);
+		vfio_ioport_in(region, offset, data, len);
 }
 
-static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
-			    u16 port, void *data, int len)
-{
-	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
-	return true;
-}
-
-static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
-			   u16 port, void *data, int len)
-{
-	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
-	return true;
-}
-
-static struct ioport_operations vfio_ioport_ops = {
-	.io_in	= vfio_ioport_in,
-	.io_out	= vfio_ioport_out,
-};
-
 static void vfio_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 			     u8 is_write, void *ptr)
 {
@@ -223,9 +204,11 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
 				  struct vfio_region *region)
 {
 	if (region->is_ioport) {
-		int port = ioport__register(kvm, region->port_base,
-					   &vfio_ioport_ops, region->info.size,
-					   region);
+		int port;
+
+		port = kvm__register_pio(kvm, region->port_base,
+					 region->info.size, vfio_ioport_mmio,
+					 region);
 		if (port < 0)
 			return port;
 		return 0;
@@ -292,7 +275,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 		munmap(region->host_addr, region->info.size);
 		region->host_addr = NULL;
 	} else if (region->is_ioport) {
-		ioport__unregister(kvm, region->port_base);
+		kvm__deregister_pio(kvm, region->port_base);
 	} else {
 		kvm__deregister_mmio(kvm, region->guest_phys_addr);
 	}
-- 
2.17.5

