Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7322B41A3
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 11:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgKPKpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 05:45:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729478AbgKPKpH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 05:45:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605523505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J365g9amxfHNaIhoB+DyJsHd1Y/JeA2NVDjF1YFACgg=;
        b=IaGDVxauCGJqoSC/VOI7XzQKptoc2kksm7Hf+EQYNfMks7FNg3ZHwK6d5Hen7k2kWkeLOd
        pQ7GILARCMeovEpy8VgrFnxSxP+SEK9PL6mqJZW0Ku1c0EynoIQaLkuLXfxmmWIr2x3eED
        djK/Jad04qFKiF6QJi6kb3vSNYxrB4A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-N5Xa--IUNeWdjFRhsI0QPw-1; Mon, 16 Nov 2020 05:45:02 -0500
X-MC-Unique: N5Xa--IUNeWdjFRhsI0QPw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7408DEC1A2;
        Mon, 16 Nov 2020 10:44:59 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8C105C5AF;
        Mon, 16 Nov 2020 10:44:54 +0000 (UTC)
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
Subject: [PATCH v12 14/15] iommu/smmuv3: Accept configs with more than one context descriptor
Date:   Mon, 16 Nov 2020 11:43:15 +0100
Message-Id: <20201116104316.31816-15-eric.auger@redhat.com>
In-Reply-To: <20201116104316.31816-1-eric.auger@redhat.com>
References: <20201116104316.31816-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 31a2500bde32..6549c3ee6af6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2901,11 +2901,12 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 		if (smmu_domain->s1_cfg)
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
 
 		smmu_domain->s1_cfg = kzalloc(sizeof(*smmu_domain->s1_cfg),
@@ -2916,6 +2917,8 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 		}
 
 		smmu_domain->s1_cfg->cdcfg.cdtab_dma = cfg->base_ptr;
+		smmu_domain->s1_cfg->s1cdmax = cfg->pasid_bits;
+		smmu_domain->s1_cfg->s1fmt = cfg->vendor_data.smmuv3.s1fmt;
 		smmu_domain->abort = false;
 		break;
 	default:
-- 
2.21.3

