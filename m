Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC336C84C
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhD0PHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:07:51 -0400
Received: from mail.savoirfairelinux.com ([208.88.110.44]:33586 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbhD0PHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 11:07:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id D60449C141B;
        Tue, 27 Apr 2021 11:06:58 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZaogdT5ilxkI; Tue, 27 Apr 2021 11:06:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7262C9C142A;
        Tue, 27 Apr 2021 11:06:58 -0400 (EDT)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id swTp57AS6AwL; Tue, 27 Apr 2021 11:06:58 -0400 (EDT)
Received: from barbarian.mtl.sfl (unknown [192.168.51.254])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 4AF7A9C141B;
        Tue, 27 Apr 2021 11:06:58 -0400 (EDT)
From:   Firas Ashkar <firas.ashkar@savoirfairelinux.com>
To:     gregkh@linuxfoundation.org, mst@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Firas Ashkar <firas.ashkar@savoirfairelinux.com>
Subject: [PATCH] uio: uio_pci_generic: add memory resource mappings
Date:   Tue, 27 Apr 2021 11:06:46 -0400
Message-Id: <20210427150646.3074218-1-firas.ashkar@savoirfairelinux.com>
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

