Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD530ACAB
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 17:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBAQbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 11:31:44 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9170 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhBAQ3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 11:29:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60182c500001>; Mon, 01 Feb 2021 08:29:04 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 16:29:04 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 16:28:59 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 6/9] vfio-pci/zdev: fix possible segmentation fault issue
Date:   Mon, 1 Feb 2021 16:28:25 +0000
Message-ID: <20210201162828.5938-7-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210201162828.5938-1-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612196944; bh=XkG/uJNlxoqQQQLU1vFXpL9Q/bX6mVtZEQ+8cQ5B8Xc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=ayQxGiiqeenmoD/JrPn75P8r0BwmYVLMhD6tmP4L1HI2aaoedXroSJ20rVPg/SxBQ
         /Pt+IYuJchtXK2pQNeV7tH2iq9b7duqJMWVMF1sLH7wjByB/dTmNqGdk+s4Jn97T6W
         BmTvcZXfzd5DQR7oDa0P5BdEEvF+yq7b4j8z/BgTzGg6Yh8PI73zEsRsl4PHOwREGV
         7gA2RN2hfOY0iNbRFTXAGbu9Lu4JTS+P2briir8/ZzkFaAnqg/Qk1HDXraDWP7JOKj
         1aFG8IWlb8WDhAe3UCYKCaFNwshe47UfZYAjLGiSN8gx6IKs3WHH+E2Qb25XdDYFmH
         KodIoIKkFogEg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case allocation fails, we must behave correctly and exit with error.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_z=
dev.c
index 175096fcd902..e9ef4239ef7a 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -71,6 +71,8 @@ static int zpci_util_cap(struct zpci_dev *zdev, struct vf=
io_info_cap *caps)
 	int ret;
=20
 	cap =3D kmalloc(cap_size, GFP_KERNEL);
+	if (!cap)
+		return -ENOMEM;
=20
 	cap->header.id =3D VFIO_DEVICE_INFO_CAP_ZPCI_UTIL;
 	cap->header.version =3D 1;
@@ -94,6 +96,8 @@ static int zpci_pfip_cap(struct zpci_dev *zdev, struct vf=
io_info_cap *caps)
 	int ret;
=20
 	cap =3D kmalloc(cap_size, GFP_KERNEL);
+	if (!cap)
+		return -ENOMEM;
=20
 	cap->header.id =3D VFIO_DEVICE_INFO_CAP_ZPCI_PFIP;
 	cap->header.version =3D 1;
--=20
2.25.4

