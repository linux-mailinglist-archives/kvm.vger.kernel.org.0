Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768FCD7992
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733243AbfJOPQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 11:16:56 -0400
Received: from 8bytes.org ([81.169.241.247]:47630 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfJOPQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 11:16:56 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6EC60398; Tue, 15 Oct 2019 17:16:54 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] vfio/type1: Initialize resv_msi_base
Date:   Tue, 15 Oct 2019 17:16:50 +0200
Message-Id: <20191015151650.30788-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

After enabling CONFIG_IOMMU_DMA on X86 a new warning appears when
compiling vfio:

drivers/vfio/vfio_iommu_type1.c: In function ‘vfio_iommu_type1_attach_group’:
drivers/vfio/vfio_iommu_type1.c:1827:7: warning: ‘resv_msi_base’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
   ~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The warning is a false positive, because the call to iommu_get_msi_cookie()
only happens when vfio_iommu_has_sw_msi() returned true. And that only
happens when it also set resv_msi_base.

But initialize the variable anyway to get rid of the warning.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 96fddc1dafc3..d864277ea16f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1658,7 +1658,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct bus_type *bus = NULL;
 	int ret;
 	bool resv_msi, msi_remap;
-	phys_addr_t resv_msi_base;
+	phys_addr_t resv_msi_base = 0;
 	struct iommu_domain_geometry geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
-- 
2.16.4

