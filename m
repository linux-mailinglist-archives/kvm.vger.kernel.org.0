Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F376211E807
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfLMQTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:19:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728120AbfLMQTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psjmWWDdVhLhKwDb1Wq8yYWFEUJUVcwEEB0iH9Xv/kA=;
        b=Nfy7zHBJEdilzAJnjb4XMffrbB907kyCRzm0FbdKOlR9dknJ7U9w/dq8+qrD2eW03mMf+5
        A+75QNNc22NM6Y9BC0QCgjlLTALzM2slucuOp1RXkvmrMvOtKjmKG36snfFCOamCt740X6
        ceYM0N4R9ij/Qmy9CdXPaXLevg92IM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-XiV1IY8PM82PJ_OyDAlfBg-1; Fri, 13 Dec 2019 11:19:50 -0500
X-MC-Unique: XiV1IY8PM82PJ_OyDAlfBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE9211856A65;
        Fri, 13 Dec 2019 16:19:48 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 070AE19C4F;
        Fri, 13 Dec 2019 16:19:37 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 08/12] hw/ide/piix: Use ARRAY_SIZE() instead of magic numbers
Date:   Fri, 13 Dec 2019 17:17:49 +0100
Message-Id: <20191213161753.8051-9-philmd@redhat.com>
In-Reply-To: <20191213161753.8051-1-philmd@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using magic numbers is dangerous because the structures PCIIDEState
might be modified and this source file consuming the "ide/pci.h"
header would be out of sync, eventually accessing out of bound
array members.
Use the ARRAY_SIZE() to keep the source file sync.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 hw/ide/piix.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/hw/ide/piix.c b/hw/ide/piix.c
index ffeff4e095..ab23613a44 100644
--- a/hw/ide/piix.c
+++ b/hw/ide/piix.c
@@ -87,10 +87,9 @@ static const MemoryRegionOps piix_bmdma_ops =3D {
=20
 static void bmdma_setup_bar(PCIIDEState *d)
 {
-    int i;
-
     memory_region_init(&d->bmdma_bar, OBJECT(d), "piix-bmdma-container",=
 16);
-    for(i =3D 0;i < 2; i++) {
+
+    for (size_t i =3D 0; i < ARRAY_SIZE(d->bmdma); i++) {
         BMDMAState *bm =3D &d->bmdma[i];
=20
         memory_region_init_io(&bm->extra_io, OBJECT(d), &piix_bmdma_ops,=
 bm,
@@ -107,9 +106,8 @@ static void piix_ide_reset(DeviceState *dev)
     PCIIDEState *d =3D PCI_IDE(dev);
     PCIDevice *pd =3D PCI_DEVICE(d);
     uint8_t *pci_conf =3D pd->config;
-    int i;
=20
-    for (i =3D 0; i < 2; i++) {
+    for (size_t i =3D 0; i < ARRAY_SIZE(d->bus); i++) {
         ide_bus_reset(&d->bus[i]);
     }
=20
@@ -132,10 +130,10 @@ static void pci_piix_init_ports(PCIIDEState *d) {
         {0x1f0, 0x3f6, 14},
         {0x170, 0x376, 15},
     };
-    int i;
=20
-    for (i =3D 0; i < 2; i++) {
-        ide_bus_new(&d->bus[i], sizeof(d->bus[i]), DEVICE(d), i, 2);
+    for (size_t i =3D 0; i < ARRAY_SIZE(d->bus); i++) {
+        ide_bus_new(&d->bus[i], sizeof(d->bus[i]), DEVICE(d), i,
+                    ARRAY_SIZE(d->bus[0].ifs));
         ide_init_ioport(&d->bus[i], NULL, port_info[i].iobase,
                         port_info[i].iobase2);
         ide_init2(&d->bus[i], isa_get_irq(NULL, port_info[i].isairq));
@@ -163,14 +161,13 @@ static void pci_piix_ide_realize(PCIDevice *dev, Er=
ror **errp)
=20
 int pci_piix3_xen_ide_unplug(DeviceState *dev, bool aux)
 {
-    PCIIDEState *pci_ide;
+    PCIIDEState *pci_ide =3D PCI_IDE(dev);
     DriveInfo *di;
-    int i;
     IDEDevice *idedev;
+    const size_t idedev_max =3D ARRAY_SIZE(pci_ide->bus)
+                            * ARRAY_SIZE(pci_ide->bus[0].ifs);
=20
-    pci_ide =3D PCI_IDE(dev);
-
-    for (i =3D aux ? 1 : 0; i < 4; i++) {
+    for (size_t i =3D aux ? 1 : 0; i < idedev_max; i++) {
         di =3D drive_get_by_index(IF_IDE, i);
         if (di !=3D NULL && !di->media_cd) {
             BlockBackend *blk =3D blk_by_legacy_dinfo(di);
@@ -210,9 +207,8 @@ PCIDevice *pci_piix3_xen_ide_init(PCIBus *bus, DriveI=
nfo **hd_table, int devfn)
 static void pci_piix_ide_exitfn(PCIDevice *dev)
 {
     PCIIDEState *d =3D PCI_IDE(dev);
-    unsigned i;
=20
-    for (i =3D 0; i < 2; ++i) {
+    for (size_t i =3D 0; i < ARRAY_SIZE(d->bmdma); ++i) {
         memory_region_del_subregion(&d->bmdma_bar, &d->bmdma[i].extra_io=
);
         memory_region_del_subregion(&d->bmdma_bar, &d->bmdma[i].addr_iop=
ort);
     }
--=20
2.21.0

