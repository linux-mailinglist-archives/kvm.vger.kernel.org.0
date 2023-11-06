Return-Path: <kvm+bounces-770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3487E270A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29CFB1C20C02
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379AC28E30;
	Mon,  6 Nov 2023 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF0128E01
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:36:15 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE3894
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:36:13 -0800 (PST)
X-IronPort-AV: E=Sophos;i="6.03,281,1694736000"; 
   d="scan'208";a="366329800"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 14:36:12 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id E847040D42;
	Mon,  6 Nov 2023 14:36:07 +0000 (UTC)
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:61593]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.184:2525] with esmtp (Farcaster)
 id f0c356cd-5b93-449f-ac4c-7f89b55f7d62; Mon, 6 Nov 2023 14:36:07 +0000 (UTC)
X-Farcaster-Flow-ID: f0c356cd-5b93-449f-ac4c-7f89b55f7d62
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 6 Nov 2023 14:36:01 +0000
Received: from u3832b3a9db3152.ant.amazon.com (10.106.83.6) by
 mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Mon, 6 Nov 2023 14:35:58 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: <qemu-devel@nongnu.org>
CC: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>, Stefano Stabellini
	<sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, Paul
 Durrant <paul@xen.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?=
	<marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Richard
 Henderson <richard.henderson@linaro.org>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, <qemu-block@nongnu.org>,
	<xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 15/17] xen-platform: unplug AHCI disks
Date: Mon, 6 Nov 2023 14:35:05 +0000
Message-ID: <20231106143507.1060610-16-dwmw2@infradead.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231106143507.1060610-1-dwmw2@infradead.org>
References: <20231106143507.1060610-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: Bulk

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
2.34.1


