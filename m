Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEABF3232C2
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhBWVCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 16:02:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233880AbhBWVAg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 16:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6KSpT1FbOAqYUqrvBZJhhKgkhDwdTSNDdC2+YnJkNps=;
        b=bXOKe/VxlurgsRZvoQjFQ5nH2+TN0SDFZW6foTMiIbi8sEug1FJ7DR+b+wBJyf74PxQetS
        u7e1ZjHuIXeWY4XF/OHcA8PqN/o9j9zvtmm1xy4MiX306jqcwuijb7lVbx4F7kFQZwPscv
        Ha7r+egPonYiKeV41Z6bbUj0bWXtelQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-DZIK0oIfPQCxpvlqgmZyDg-1; Tue, 23 Feb 2021 15:59:04 -0500
X-MC-Unique: DZIK0oIfPQCxpvlqgmZyDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60C9F80197D;
        Tue, 23 Feb 2021 20:59:01 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FBCB5D9D0;
        Tue, 23 Feb 2021 20:58:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
Subject: [PATCH v14 12/13] iommu/smmuv3: report additional recoverable faults
Date:   Tue, 23 Feb 2021 21:56:33 +0100
Message-Id: <20210223205634.604221-13-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up to now we have only reported translation faults. Now that
the guest can induce some configuration faults, let's report them
too. Add propagation for BAD_SUBSTREAMID, CD_FETCH, BAD_CD, WALK_EABT.
We also fix the transcoding for some existing translation faults.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  4 ++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f783c2804872..332d31c0680f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1472,6 +1472,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	u32 perm = 0;
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
+	u8 type = FIELD_GET(EVTQ_0_ID, evt[0]);
 	u32 sid = FIELD_GET(EVTQ_0_SID, evt[0]);
 	struct iommu_fault_event fault_evt = { };
 	struct iommu_fault *flt = &fault_evt.fault;
@@ -1524,9 +1525,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	} else {
 		flt->type = IOMMU_FAULT_DMA_UNRECOV;
 		flt->event = (struct iommu_fault_unrecoverable) {
-			.reason = reason,
-			.flags = IOMMU_FAULT_UNRECOV_ADDR_VALID |
-				 IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID,
 			.perm = perm,
 			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
 			.fetch_addr = FIELD_GET(EVTQ_3_IPA, evt[3]),
@@ -1536,6 +1534,43 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 			flt->event.flags |= IOMMU_FAULT_UNRECOV_PASID_VALID;
 			flt->event.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
 		}
+
+		switch (type) {
+		case EVT_ID_TRANSLATION_FAULT:
+			flt->event.reason = IOMMU_FAULT_REASON_PTE_FETCH;
+			flt->event.flags |= IOMMU_FAULT_UNRECOV_ADDR_VALID;
+			break;
+		case EVT_ID_ADDR_SIZE_FAULT:
+			flt->event.reason = IOMMU_FAULT_REASON_OOR_ADDRESS;
+			flt->event.flags |= IOMMU_FAULT_UNRECOV_ADDR_VALID;
+			break;
+		case EVT_ID_ACCESS_FAULT:
+			flt->event.reason = IOMMU_FAULT_REASON_ACCESS;
+			flt->event.flags |= IOMMU_FAULT_UNRECOV_ADDR_VALID;
+			break;
+		case EVT_ID_PERMISSION_FAULT:
+			flt->event.reason = IOMMU_FAULT_REASON_PERMISSION;
+			flt->event.flags |= IOMMU_FAULT_UNRECOV_ADDR_VALID;
+			break;
+		case EVT_ID_BAD_SUBSTREAMID:
+			flt->event.reason = IOMMU_FAULT_REASON_PASID_INVALID;
+			break;
+		case EVT_ID_CD_FETCH:
+			flt->event.reason = IOMMU_FAULT_REASON_PASID_FETCH;
+			flt->event.flags |= IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID;
+			break;
+		case EVT_ID_BAD_CD:
+			flt->event.reason = IOMMU_FAULT_REASON_BAD_PASID_ENTRY;
+			break;
+		case EVT_ID_WALK_EABT:
+			flt->event.reason = IOMMU_FAULT_REASON_WALK_EABT;
+			flt->event.flags |= IOMMU_FAULT_UNRECOV_ADDR_VALID |
+					    IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID;
+			break;
+		default:
+			/* TODO: report other unrecoverable faults. */
+			return -EFAULT;
+		}
 	}
 
 	ret = iommu_report_device_fault(master->dev, &fault_evt);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index eb0cc08e8240..9c37dbec75b2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -378,6 +378,10 @@
 
 #define EVTQ_0_ID			GENMASK_ULL(7, 0)
 
+#define EVT_ID_BAD_SUBSTREAMID		0x08
+#define EVT_ID_CD_FETCH			0x09
+#define EVT_ID_BAD_CD			0x0a
+#define EVT_ID_WALK_EABT		0x0b
 #define EVT_ID_TRANSLATION_FAULT	0x10
 #define EVT_ID_ADDR_SIZE_FAULT		0x11
 #define EVT_ID_ACCESS_FAULT		0x12
-- 
2.26.2

