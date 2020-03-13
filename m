Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993F8183873
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgCLST6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:19:58 -0400
Received: from foss.arm.com ([217.140.110.172]:39520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgCLST6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:19:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 184A130E;
        Thu, 12 Mar 2020 11:19:58 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC9F43F67D;
        Thu, 12 Mar 2020 11:19:56 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org,
        Eric Auger <eric.auger@redhat.com>
Subject: [RFC PATCH] vfio: Ignore -ENODEV when getting MSI cookie
Date:   Thu, 12 Mar 2020 18:19:50 +0000
Message-Id: <20200312181950.60664-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we try to get an MSI cookie for a VFIO device, that can fail if
CONFIG_IOMMU_DMA is not set. In this case iommu_get_msi_cookie() returns
-ENODEV, and that should not be fatal.

Ignore that case and proceed with the initialisation.

This fixes VFIO with a platform device on the Calxeda Midway (no MSIs).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

not sure this is the right fix, or we should rather check if the
platform doesn't support MSIs at all (which doesn't seem to be easy
to do).
Or is this because arm-smmu.c always reserves an IOMMU_RESV_SW_MSI
region?

Also this seems to be long broken, actually since Eric introduced MSI
support in 4.10-rc3, but at least since the initialisation order was
fixed with f6810c15cf9.

Grateful for any insight.

Cheers,
Andre

 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a177bf2c6683..467e217ef09a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1786,7 +1786,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	if (resv_msi) {
 		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
-		if (ret)
+		if (ret && ret != -ENODEV)
 			goto out_detach;
 	}
 
-- 
2.17.1

