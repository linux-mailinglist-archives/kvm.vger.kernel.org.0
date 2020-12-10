Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99682D65A0
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390508AbgLJObf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:31:35 -0500
Received: from foss.arm.com ([217.140.110.172]:45084 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390494AbgLJOb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8BD9152D;
        Thu, 10 Dec 2020 06:29:41 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACA5C3F718;
        Thu, 10 Dec 2020 06:29:40 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 15/21] vfio: Refactor ioport trap handler
Date:   Thu, 10 Dec 2020 14:29:02 +0000
Message-Id: <20201210142908.169597-16-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210142908.169597-1-andre.przywara@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO prototype.

Adjust the I/O port trap handler to use that new function, and provide
shims to implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 vfio/core.c | 51 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index 0b45e78b..f55f1f87 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -81,15 +81,12 @@ out_free_buf:
 	return ret;
 }
 
-static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
-			   u16 port, void *data, int len)
+static bool _vfio_ioport_in(struct vfio_region *region, u32 offset,
+			    void *data, int len)
 {
-	u32 val;
-	ssize_t nr;
-	struct vfio_region *region = ioport->priv;
 	struct vfio_device *vdev = region->vdev;
-
-	u32 offset = port - region->port_base;
+	ssize_t nr;
+	u32 val;
 
 	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_READ))
 		return false;
@@ -97,7 +94,7 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
 	nr = pread(vdev->fd, &val, len, region->info.offset + offset);
 	if (nr != len) {
 		vfio_dev_err(vdev, "could not read %d bytes from I/O port 0x%x\n",
-			     len, port);
+			     len, offset);
 		return false;
 	}
 
@@ -118,15 +115,13 @@ static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
 	return true;
 }
 
-static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
-			    u16 port, void *data, int len)
+static bool _vfio_ioport_out(struct vfio_region *region, u32 offset,
+			     void *data, int len)
 {
-	u32 val;
-	ssize_t nr;
-	struct vfio_region *region = ioport->priv;
 	struct vfio_device *vdev = region->vdev;
+	ssize_t nr;
+	u32 val;
 
-	u32 offset = port - region->port_base;
 
 	if (!(region->info.flags & VFIO_REGION_INFO_FLAG_WRITE))
 		return false;
@@ -148,11 +143,37 @@ static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
 	nr = pwrite(vdev->fd, &val, len, region->info.offset + offset);
 	if (nr != len)
 		vfio_dev_err(vdev, "could not write %d bytes to I/O port 0x%x",
-			     len, port);
+			     len, offset);
 
 	return nr == len;
 }
 
+static void vfio_ioport_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			     u8 is_write, void *ptr)
+{
+	struct vfio_region *region = ptr;
+	u32 offset = addr - region->port_base;
+
+	if (is_write)
+		_vfio_ioport_out(region, offset, data, len);
+	else
+		_vfio_ioport_in(region, offset, data, len);
+}
+
+static bool vfio_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
+			    u16 port, void *data, int len)
+{
+	vfio_ioport_mmio(vcpu, port, data, len, true, ioport->priv);
+	return true;
+}
+
+static bool vfio_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
+			   u16 port, void *data, int len)
+{
+	vfio_ioport_mmio(vcpu, port, data, len, false, ioport->priv);
+	return true;
+}
+
 static struct ioport_operations vfio_ioport_ops = {
 	.io_in	= vfio_ioport_in,
 	.io_out	= vfio_ioport_out,
-- 
2.17.1

