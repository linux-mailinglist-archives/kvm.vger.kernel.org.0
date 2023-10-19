Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D807CFE5F
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346388AbjJSPls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346356AbjJSPlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:41:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1237121
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=y4cEjsiuJ1bFNsoLeKKWM6n6686E9X1lvqONj/DtYQs=; b=ifFdukRbinWhGVDRnq/A05lFVT
        yRMvPZCaOprjgEjxSzFGvZEXWNAslFz/v02nsuwTcuGbTuoe87lOE+zeMrgTwkG6/h9ig70OqPSqR
        bfdxd1veEzZP6xazI37SnE2yFKvo6BmAmxHOmfpgbJmQmWgzAQikS/3Je7XInblKRqN2rQnABpZHM
        r6ALLY85CZBVonboM/IQU97amb2vBzbP0DXpc2lJwPkZcqFZXjSKQiiYdRPktO9GOD47jey1wR1Gi
        rH6C+2aLVVFDSEG1nrVG8whrh/Ri6ARPVyH8y1tnjL8ebe/pBpT+chEH4dy2J8n9B7uVQcA/77gtS
        3Q+CFtuA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8O-009yD6-0Q;
        Thu, 19 Oct 2023 15:40:28 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8N-000PvL-1Y;
        Thu, 19 Oct 2023 16:40:27 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v2 23/24] xen-platform: unplug AHCI disks
Date:   Thu, 19 Oct 2023 16:40:19 +0100
Message-Id: <20231019154020.99080-24-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231019154020.99080-1-dwmw2@infradead.org>
References: <20231019154020.99080-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

To support Xen guests using the Q35 chipset, the unplug protocol needs
to also remove AHCI disks.

Make pci_xen_ide_unplug() more generic, iterating over the children
of the PCI device and destroying the "ide-hd" devices. That works the
same for both AHCI and IDE, as does the detection of the primary disk
as unit 0 on the bus named "ide.0".

Then pci_xen_ide_unplug() can be used for both AHCI and IDE devices.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
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
2.40.1

