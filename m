Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88292099EA
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389951AbgFYGhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 02:37:21 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9181 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgFYGhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 02:37:20 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ef446130000>; Wed, 24 Jun 2020 23:37:07 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 24 Jun 2020 23:37:20 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 24 Jun 2020 23:37:20 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 25 Jun
 2020 06:37:19 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 25 Jun 2020 06:37:20 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.59.206]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ef4461f0005>; Wed, 24 Jun 2020 23:37:20 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     John Hubbard <jhubbard@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH v2] vfio/spapr_tce: convert get_user_pages() --> pin_user_pages()
Date:   Wed, 24 Jun 2020 23:37:17 -0700
Message-ID: <20200625063717.834923-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593067027; bh=T8kM6kIhzYlig7AUGzoS+A4qc/UX6U40K3WHpkS7F4M=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=PzYJ3lae3MPcCxOUNX59NTfx3uUcrmR2uRJaVRYyA3k0Wp4+0gX7xyZqXFse1JxWq
         0R9PMXLvoFGX731TeqEDRI/WZWNQUtRkW2t+mONUCcpiprl0dgUjuKXzrjsqZ8iceE
         8Y/Y6aU4kBZxJrs0CiS/pCXAxi11FP0ISPiAK8s39RzVzTr3nSJzR6wuEMIs4j9MMh
         HZ+87EQp1abZ2ixJK+7Olm10PPuvjY9TsJ5s4i/UrvkGe0WBGfh/BkgFcWbsi81xYb
         IdzPSrwWhvM6hdcsFyn9kMDPBZPYatjs8tJ4+dePb4XL2eiSN7rYDD6B3lIasQ1Ixn
         NOMJ8IW9Cg5Hg==
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

Changes since v1: rebased onto Linux-5.8-rc2.

thanks,
John Hubbard

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
2.27.0

