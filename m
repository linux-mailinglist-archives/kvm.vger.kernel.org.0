Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330F92B41A4
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 11:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgKPKpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 05:45:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729499AbgKPKpQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 05:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605523515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QE1szO8OV1xDFKb+wSnyAiSU7kUqkqlMSoqIskMXHyg=;
        b=Qnzw6Uvla6Dz3r8NG4sy2JF+Nu0kZOG/WBso5KKBViXiY1Vt68VbNVeK0oWORcj5kHYJV/
        cw9DiEZCguIdZmI2GqW33GnCfCtP5lc89FDphyO72yNHiHY4tpNf7HvhJAzZHwYpmr56gR
        bR3htK/0Hcob8os93eJhvQ0aeViHnTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-BB4NcFKMM7Kq8NwwcPiiPQ-1; Mon, 16 Nov 2020 05:45:14 -0500
X-MC-Unique: BB4NcFKMM7Kq8NwwcPiiPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C06EC18BA281;
        Mon, 16 Nov 2020 10:45:11 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0F955C5AF;
        Mon, 16 Nov 2020 10:44:59 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com
Subject: [PATCH v12 15/15] iommu/smmuv3: Add PASID cache invalidation per PASID
Date:   Mon, 16 Nov 2020 11:43:16 +0100
Message-Id: <20201116104316.31816-16-eric.auger@redhat.com>
In-Reply-To: <20201116104316.31816-1-eric.auger@redhat.com>
References: <20201116104316.31816-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to cascade guest CFGI_CD, let's add PASID cache invalidation
per PASID.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6549c3ee6af6..eb0e09936803 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3002,9 +3002,19 @@ arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
 		} else {
 			return -EINVAL;
 		}
-	}
-	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
-	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
+	} else if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID) {
+		if (inv_info->granularity == IOMMU_INV_GRANU_PASID) {
+			struct iommu_inv_pasid_info *info =
+				&inv_info->granu.pasid_info;
+
+			if (!info->flags & IOMMU_INV_PASID_FLAGS_PASID)
+				return -EINVAL;
+
+			arm_smmu_sync_cd(smmu_domain, info->pasid, true);
+		} else {
+			return -ENOENT;
+		}
+	} else { /* IOMMU_CACHE_INV_TYPE_DEV_IOTLB */
 		return -ENOENT;
 	}
 	return 0;
-- 
2.21.3

