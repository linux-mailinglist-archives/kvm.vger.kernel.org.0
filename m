Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3420419A98D
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 12:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbgDAK1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 06:27:34 -0400
Received: from foss.arm.com ([217.140.110.172]:48212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgDAK1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 06:27:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 722E11FB;
        Wed,  1 Apr 2020 03:27:30 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 239CC3F52E;
        Wed,  1 Apr 2020 03:27:29 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] vfio: Ignore -ENODEV when getting MSI cookie
Date:   Wed,  1 Apr 2020 11:27:24 +0100
Message-Id: <20200401102724.161712-1-andre.przywara@arm.com>
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

Fixes: f6810c15cf973f ("iommu/arm-smmu: Clean up early-probing workarounds")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9fdfae1cb17a..85b32c325282 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1787,7 +1787,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	if (resv_msi) {
 		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
-		if (ret)
+		if (ret && ret != -ENODEV)
 			goto out_detach;
 	}
 
-- 
2.17.1

