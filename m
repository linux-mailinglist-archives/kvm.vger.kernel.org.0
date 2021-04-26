Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D131B36B9CA
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbhDZTJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 15:09:46 -0400
Received: from mail.savoirfairelinux.com ([208.88.110.44]:47722 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhDZTJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 15:09:44 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 15:09:44 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 96F4E9C1604;
        Mon, 26 Apr 2021 15:03:47 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id TfXJ-JMsE0YT; Mon, 26 Apr 2021 15:03:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 0A1829C1556;
        Mon, 26 Apr 2021 15:03:47 -0400 (EDT)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CeQtMkjyRRcf; Mon, 26 Apr 2021 15:03:46 -0400 (EDT)
Received: from barbarian.mtl.sfl (unknown [192.168.51.254])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id D506D9C0272;
        Mon, 26 Apr 2021 15:03:46 -0400 (EDT)
From:   Firas Ashkar <firas.ashkar@savoirfairelinux.com>
To:     gregkh@linuxfoundation.org, mst@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uio: uio_pci_generic: add memory mappings
Date:   Mon, 26 Apr 2021 15:03:46 -0400
Message-Id: <20210426190346.173919-1-firas.ashkar@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

import memory resources from underlying pci device, thus allowing
userspace applications to memory map those resources.

Signed-off-by: Firas Ashkar <firas.ashkar@savoirfairelinux.com>
---
:100644 100644 c7d681fef198 809eca95b5bb M	drivers/uio/uio_pci_generic.c
 drivers/uio/uio_pci_generic.c | 52 +++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.=
c
index c7d681fef198..809eca95b5bb 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -24,9 +24,9 @@
 #include <linux/slab.h>
 #include <linux/uio_driver.h>
=20
-#define DRIVER_VERSION	"0.01.0"
-#define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
-#define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
+#define DRIVER_VERSION "0.01.0"
+#define DRIVER_AUTHOR "Michael S. Tsirkin <mst@redhat.com>"
+#define DRIVER_DESC "Generic UIO driver for PCI 2.3 devices"
=20
 struct uio_pci_generic_dev {
 	struct uio_info info;
@@ -56,7 +56,8 @@ static int release(struct uio_info *info, struct inode =
*inode)
 }
=20
 /* Interrupt handler. Read/modify/write the command register to disable
- * the interrupt. */
+ * the interrupt.
+ */
 static irqreturn_t irqhandler(int irq, struct uio_info *info)
 {
 	struct uio_pci_generic_dev *gdev =3D to_uio_pci_generic_dev(info);
@@ -68,11 +69,12 @@ static irqreturn_t irqhandler(int irq, struct uio_inf=
o *info)
 	return IRQ_HANDLED;
 }
=20
-static int probe(struct pci_dev *pdev,
-			   const struct pci_device_id *id)
+static int probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct uio_pci_generic_dev *gdev;
+	struct uio_mem *uiomem;
 	int err;
+	int i;
=20
 	err =3D pcim_enable_device(pdev);
 	if (err) {
@@ -84,7 +86,8 @@ static int probe(struct pci_dev *pdev,
 	if (pdev->irq && !pci_intx_mask_supported(pdev))
 		return -ENOMEM;
=20
-	gdev =3D devm_kzalloc(&pdev->dev, sizeof(struct uio_pci_generic_dev), G=
FP_KERNEL);
+	gdev =3D devm_kzalloc(&pdev->dev, sizeof(struct uio_pci_generic_dev),
+			    GFP_KERNEL);
 	if (!gdev)
 		return -ENOMEM;
=20
@@ -97,8 +100,39 @@ static int probe(struct pci_dev *pdev,
 		gdev->info.irq_flags =3D IRQF_SHARED;
 		gdev->info.handler =3D irqhandler;
 	} else {
-		dev_warn(&pdev->dev, "No IRQ assigned to device: "
-			 "no support for interrupts?\n");
+		dev_warn(
+			&pdev->dev,
+			"No IRQ assigned to device: no support for interrupts?\n");
+	}
+
+	uiomem =3D &gdev->info.mem[0];
+	for (i =3D 0; i < MAX_UIO_MAPS; ++i) {
+		struct resource *r =3D &pdev->resource[i];
+
+		if (r->flags !=3D (IORESOURCE_SIZEALIGN | IORESOURCE_MEM))
+			continue;
+
+		if (uiomem >=3D &gdev->info.mem[MAX_UIO_MAPS]) {
+			dev_warn(
+				&pdev->dev,
+				"device has more than " __stringify(
+					MAX_UIO_MAPS) " I/O memory resources.\n");
+			break;
+		}
+
+		uiomem->memtype =3D UIO_MEM_PHYS;
+		uiomem->addr =3D r->start & PAGE_MASK;
+		uiomem->offs =3D r->start & ~PAGE_MASK;
+		uiomem->size =3D
+			(uiomem->offs + resource_size(r) + PAGE_SIZE - 1) &
+			PAGE_MASK;
+		uiomem->name =3D r->name;
+		++uiomem;
+	}
+
+	while (uiomem < &gdev->info.mem[MAX_UIO_MAPS]) {
+		uiomem->size =3D 0;
+		++uiomem;
 	}
=20
 	return devm_uio_register_device(&pdev->dev, &gdev->info);
--=20
2.25.1

