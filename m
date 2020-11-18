Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B5F2B7C90
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 12:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgKRLX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 06:23:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727925AbgKRLX7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 06:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605698638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMV1y86LEZa3kYwZ8iP5D6nppr21q5lgJ0OynKLwxhg=;
        b=dHPyeeAJfj/hrecpurTxBv3QQ4AmiV5ibdYPZiMGx60HKruE8DDKqT2cmxH/WmQzE//p8I
        rTdF2w1lsLPr/ieBNGimQFkPnxmGVJybCKGskHQnitF6D8QndBAuQDFMstrswuVJTIyJ8H
        uysxpZWib2xLxmlr7gL1+6cMlbZXkkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-ARgRYGBNPxCWe6YeN5iJ6Q-1; Wed, 18 Nov 2020 06:23:56 -0500
X-MC-Unique: ARgRYGBNPxCWe6YeN5iJ6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BE05873115;
        Wed, 18 Nov 2020 11:23:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17EEE51512;
        Wed, 18 Nov 2020 11:23:40 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v13 14/15] iommu/smmuv3: Accept configs with more than one context descriptor
Date:   Wed, 18 Nov 2020 12:21:50 +0100
Message-Id: <20201118112151.25412-15-eric.auger@redhat.com>
In-Reply-To: <20201118112151.25412-1-eric.auger@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for vSVA, let's accept userspace provided configs
with more than one CD. We check the max CD against the host iommu
capability and also the format (linear versus 2 level).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 977c22d08612..ed64699a4a0d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2905,14 +2905,17 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 		if (smmu_domain->s1_cfg.set)
 			goto out;
 
-		/*
-		 * we currently support a single CD so s1fmt and s1dss
-		 * fields are also ignored
-		 */
-		if (cfg->pasid_bits)
+		list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+			if (cfg->pasid_bits > master->ssid_bits)
+				goto out;
+		}
+		if (cfg->vendor_data.smmuv3.s1fmt == STRTAB_STE_0_S1FMT_64K_L2 &&
+				!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB))
 			goto out;
 
 		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
+		smmu_domain->s1_cfg.s1cdmax = cfg->pasid_bits;
+		smmu_domain->s1_cfg.s1fmt = cfg->vendor_data.smmuv3.s1fmt;
 		smmu_domain->s1_cfg.set = true;
 		smmu_domain->abort = false;
 		break;
-- 
2.21.3

