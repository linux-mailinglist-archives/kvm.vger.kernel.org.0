Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAD136CC2E
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 22:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhD0ULe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 16:11:34 -0400
Received: from mail.savoirfairelinux.com ([208.88.110.44]:48822 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhD0ULe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 16:11:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EF7369C02D0;
        Tue, 27 Apr 2021 16:10:49 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id PINCznNH0R6Y; Tue, 27 Apr 2021 16:10:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 670A29C0D2A;
        Tue, 27 Apr 2021 16:10:49 -0400 (EDT)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6pLUmLbSCXfx; Tue, 27 Apr 2021 16:10:49 -0400 (EDT)
Received: from barbarian.mtl.sfl (unknown [192.168.51.254])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 3DA1E9C02D0;
        Tue, 27 Apr 2021 16:10:49 -0400 (EDT)
From:   Firas Ashkar <firas.ashkar@savoirfairelinux.com>
To:     gregkh@linuxfoundation.org, mst@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Firas Ashkar <firas.ashkar@savoirfairelinux.com>
Subject: [PATCH v2] uio: uio_pci_generic: add memory resource mappings
Date:   Tue, 27 Apr 2021 16:10:46 -0400
Message-Id: <20210427201046.4005820-1-firas.ashkar@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

import memory resources from underlying pci device, thus allowing
userspace applications to memory map those resources.

without this change, current implementation, does not populate the
memory maps and are not shown under the corresponding sysfs uio entry:

root@apalis-imx8:~# echo "ad00 0122" > \
			/sys/bus/pci/drivers/uio_pci_generic/new_id
[   55.736433] uio_pci_generic 0000:01:00.0: enabling device (0000 -> 000=
2)
root@apalis-imx8:~# ls -lsrt /sys/class/uio/uio0/
     0 -rw-r--r--    1 root     root          4096 Apr 27 18:52 uevent
     0 -r--r--r--    1 root     root          4096 Apr 27 18:52 version
     0 -r--r--r--    1 root     root          4096 Apr 27 18:52 suppliers
     0 lrwxrwxrwx    1 root     root             0 Apr 27 18:52 subsystem
-> ../../../../../../../../../class/uio
     0 drwxr-xr-x    2 root     root             0 Apr 27 18:52 power
     0 -r--r--r--    1 root     root          4096 Apr 27 18:52 name
     0 -r--r--r--    1 root     root          4096 Apr 27 18:52 event
     0 lrwxrwxrwx    1 root     root             0 Apr 27 18:52 device
-> ../../../0000:01:00.0
     0 -r--r--r--    1 root     root          4096 Apr 27 18:52 dev
     0 -r--r--r--    1 root     root          4096 Apr 27 18:52 consumers
root@apalis-imx8:~#

with the proposed changed, have following instead:
root@apalis-imx8:~# ls -lsrt /sys/class/uio/uio0/
     0 -rw-r--r--    1 root     root          4096 Apr 27 19:06 uevent
     0 -r--r--r--    1 root     root          4096 Apr 27 19:06 version
     0 -r--r--r--    1 root     root          4096 Apr 27 19:06 suppliers
     0 lrwxrwxrwx    1 root     root             0 Apr 27 19:06 subsystem
-> ../../../../../../../../../class/uio
     0 drwxr-xr-x    2 root     root             0 Apr 27 19:06 power
     0 -r--r--r--    1 root     root          4096 Apr 27 19:06 name
     0 drwxr-xr-x    4 root     root             0 Apr 27 19:06 maps
     0 -r--r--r--    1 root     root          4096 Apr 27 19:06 event
     0 lrwxrwxrwx    1 root     root             0 Apr 27 19:06 device
-> ../../../0000:01:00.0
     0 -r--r--r--    1 root     root          4096 Apr 27 19:06 dev
     0 -r--r--r--    1 root     root          4096 Apr 27 19:06 consumers
root@apalis-imx8:~#

root@apalis-imx8:~# ls -lsrt /sys/class/uio/uio0/maps/
     0 drwxr-xr-x    2 root     root             0 Apr 27 19:07 map1
     0 drwxr-xr-x    2 root     root             0 Apr 27 19:07 map0
root@apalis-imx8:~#

root@apalis-imx8:~# cat /sys/class/uio/uio0/maps/map1/addr
0x0000000062000000
root@apalis-imx8:~#

root@apalis-imx8:~# cat /sys/class/uio/uio0/maps/map1/size
0x0000000000200000
root@apalis-imx8:~#

tested on AltaData ARINC 429 MiniPCIE module on imx8qm-apalis-ixora-v1.2

Signed-off-by: Firas Ashkar <firas.ashkar@savoirfairelinux.com>
---

Notes:
    Changes in V2
    * add detailed description why this change is needed
    * add test hardware name and version

:100644 100644 c7d681fef198 efc43869131d M	drivers/uio/uio_pci_generic.c
 drivers/uio/uio_pci_generic.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.=
c
index c7d681fef198..efc43869131d 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -72,7 +72,9 @@ static int probe(struct pci_dev *pdev,
 			   const struct pci_device_id *id)
 {
 	struct uio_pci_generic_dev *gdev;
+	struct uio_mem *uiomem;
 	int err;
+	int i;
=20
 	err =3D pcim_enable_device(pdev);
 	if (err) {
@@ -101,6 +103,36 @@ static int probe(struct pci_dev *pdev,
 			 "no support for interrupts?\n");
 	}
=20
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
+	}
+
 	return devm_uio_register_device(&pdev->dev, &gdev->info);
 }
=20
--=20
2.25.1

