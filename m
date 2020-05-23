Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5C1DF3E5
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 03:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgEWBnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 21:43:49 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11739 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbgEWBnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 21:43:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec87f430000>; Fri, 22 May 2020 18:41:23 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 22 May 2020 18:43:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 22 May 2020 18:43:48 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 23 May
 2020 01:43:48 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sat, 23 May 2020 01:43:48 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.52.1]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ec87fd40001>; Fri, 22 May 2020 18:43:48 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     Souptick Joarder <jrdr.linux@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH 1/1] vfio/spapr_tce: convert get_user_pages() --> pin_user_pages()
Date:   Fri, 22 May 2020 18:43:47 -0700
Message-ID: <20200523014347.193290-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590198083; bh=aNxPaUMw4B6W9o4OKROyKEN8taVDg0VgvpxK29EQarg=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=fAaH855X8qd9w/i41ulaTLwkNv7vNOo/uAIWw0g6ZIauJPn0I+dJ3tJBHQcvOiBHA
         /vQ2YrtqSNTbDY8zUKLuTFkGmAeGsYxXuGOCEUdUHEr/4+6L/cAhKxV31BOww26dfK
         EyAxjd/weu4sdSe5uy9jw+qi7/HLDMOlEHv5YoVoTkVJwXsg8JUDSMBlNxIMvB+WRQ
         TxtyMvrGfITDKeQVf5kOy0iYmNI2Dy6aUBnHDyPqTJYqndA/lj8uBb4Ib7ajcJceMY
         TAr8Cxhf0YHDO8J99+Gt55xHt0q9+YSRpsaa/LWtJTnkOD2apoN4WUWfePUblIkKJe
         whxoekKWcJLEA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This code was using get_user_pages*(), in a "Case 2" scenario
(DMA/RDMA), using the categorization from [1]. That means that it's
time to convert the get_user_pages*() + put_page() calls to
pin_user_pages*() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small
part of fixing a long-standing disconnect between pinning pages, and
file systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Hi,

I'm compile-tested this, but am not able to run-time test, so any
testing help is much appreciated!

thanks,
John Hubbard
NVIDIA

 drivers/vfio/vfio_iommu_spapr_tce.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_=
spapr_tce.c
index 16b3adc508db..fe888b5dcc00 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -383,7 +383,7 @@ static void tce_iommu_unuse_page(struct tce_container *=
container,
 	struct page *page;
=20
 	page =3D pfn_to_page(hpa >> PAGE_SHIFT);
-	put_page(page);
+	unpin_user_page(page);
 }
=20
 static int tce_iommu_prereg_ua_to_hpa(struct tce_container *container,
@@ -486,7 +486,7 @@ static int tce_iommu_use_page(unsigned long tce, unsign=
ed long *hpa)
 	struct page *page =3D NULL;
 	enum dma_data_direction direction =3D iommu_tce_direction(tce);
=20
-	if (get_user_pages_fast(tce & PAGE_MASK, 1,
+	if (pin_user_pages_fast(tce & PAGE_MASK, 1,
 			direction !=3D DMA_TO_DEVICE ? FOLL_WRITE : 0,
 			&page) !=3D 1)
 		return -EFAULT;
--=20
2.26.2

