Return-Path: <kvm+bounces-854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A487E37BE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D43FB20B58
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F378329CF2;
	Tue,  7 Nov 2023 09:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vy4F3cdm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5928E29
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:22:32 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C490A114
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qaX76sba0ihoWf79BpMjucCx6OK5R/g8GeoiQOwguNA=; b=Vy4F3cdmVrZDN8OdQ8yswaBCcD
	H0d5tv4GKZdX8q2YUADeKMPnY3Y8Q5m2INiIh49d5erdwPxXHU8DaWOCeg7BHS6XPPQmSwOGEUiij
	qBT2PgRY+d8steJDkFD6bceOapYA+Ut92ElQ0CcqwgxTdjramjxxgg4fxJ1SxyL7gIxG00oixtquZ
	gvMORJpAETT5lNq0thRGyroFWHBj7inI/7JrPLLwAzVsFyzxK+LkwVMzuQ+Aq19bHfoqlaOTAxTTK
	ykDmbRecugCKq+9TPczxpacUUpZQnpeNfH5koRx0/XwM4XBdFZTjaPc/fhR4kC9KSqPCZZcy0uznk
	8a7xJLZg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r0IHP-00BtG4-0U;
	Tue, 07 Nov 2023 09:21:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1r0IHO-001hKk-0y;
	Tue, 07 Nov 2023 09:21:50 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	Stefan Hajnoczi <stefanha@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-block@nongnu.org,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org
Subject: [PULL 14/15] xen-platform: unplug AHCI disks
Date: Tue,  7 Nov 2023 09:21:46 +0000
Message-ID: <20231107092149.404842-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231107092149.404842-1-dwmw2@infradead.org>
References: <20231107092149.404842-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

To support Xen guests using the Q35 chipset, the unplug protocol needs
to also remove AHCI disks.

Make pci_xen_ide_unplug() more generic, iterating over the children
of the PCI device and destroying the "ide-hd" devices. That works the
same for both AHCI and IDE, as does the detection of the primary disk
as unit 0 on the bus named "ide.0".

Then pci_xen_ide_unplug() can be used for both AHCI and IDE devices.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/xen/xen_platform.c | 68 +++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/hw/i386/xen/xen_platform.c b/hw/i386/xen/xen_platform.c
index e2dd1b536a..ef7d3fc05f 100644
--- a/hw/i386/xen/xen_platform.c
+++ b/hw/i386/xen/xen_platform.c
@@ -169,39 +169,60 @@ static void pci_unplug_nics(PCIBus *bus)
  *
  * [1] https://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=docs/misc/hvm-emulated-unplug.pandoc
  */
-static void pci_xen_ide_unplug(PCIDevice *d, bool aux)
+struct ide_unplug_state {
+    bool aux;
+    int nr_unplugged;
+};
+
+static int ide_dev_unplug(DeviceState *dev, void *_st)
 {
-    DeviceState *dev = DEVICE(d);
-    PCIIDEState *pci_ide;
-    int i;
+    struct ide_unplug_state *st = _st;
     IDEDevice *idedev;
     IDEBus *idebus;
     BlockBackend *blk;
+    int unit;
+
+    idedev = IDE_DEVICE(object_dynamic_cast(OBJECT(dev), "ide-hd"));
+    if (!idedev) {
+        return 0;
+    }
 
-    pci_ide = PCI_IDE(dev);
+    idebus = IDE_BUS(qdev_get_parent_bus(dev));
 
-    for (i = aux ? 1 : 0; i < 4; i++) {
-        idebus = &pci_ide->bus[i / 2];
-        blk = idebus->ifs[i % 2].blk;
+    unit = (idedev == idebus->slave);
+    assert(unit || idedev == idebus->master);
 
-        if (blk && idebus->ifs[i % 2].drive_kind != IDE_CD) {
-            if (!(i % 2)) {
-                idedev = idebus->master;
-            } else {
-                idedev = idebus->slave;
-            }
+    if (st->aux && !unit && !strcmp(BUS(idebus)->name, "ide.0")) {
+        return 0;
+    }
 
-            blk_drain(blk);
-            blk_flush(blk);
+    blk = idebus->ifs[unit].blk;
+    if (blk) {
+        blk_drain(blk);
+        blk_flush(blk);
 
-            blk_detach_dev(blk, DEVICE(idedev));
-            idebus->ifs[i % 2].blk = NULL;
-            idedev->conf.blk = NULL;
-            monitor_remove_blk(blk);
-            blk_unref(blk);
-        }
+        blk_detach_dev(blk, DEVICE(idedev));
+        idebus->ifs[unit].blk = NULL;
+        idedev->conf.blk = NULL;
+        monitor_remove_blk(blk);
+        blk_unref(blk);
+    }
+
+    object_unparent(OBJECT(dev));
+    st->nr_unplugged++;
+
+    return 0;
+}
+
+static void pci_xen_ide_unplug(PCIDevice *d, bool aux)
+{
+    struct ide_unplug_state st = { aux, 0 };
+    DeviceState *dev = DEVICE(d);
+
+    qdev_walk_children(dev, NULL, NULL, ide_dev_unplug, NULL, &st);
+    if (st.nr_unplugged) {
+        pci_device_reset(d);
     }
-    pci_device_reset(d);
 }
 
 static void unplug_disks(PCIBus *b, PCIDevice *d, void *opaque)
@@ -216,6 +237,7 @@ static void unplug_disks(PCIBus *b, PCIDevice *d, void *opaque)
 
     switch (pci_get_word(d->config + PCI_CLASS_DEVICE)) {
     case PCI_CLASS_STORAGE_IDE:
+    case PCI_CLASS_STORAGE_SATA:
         pci_xen_ide_unplug(d, aux);
         break;
 
-- 
2.41.0


