Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0A135B381
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhDKLP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:15:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235550AbhDKLPZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618139709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHO13892Sc/pn1nrfrHUdgvE8cfwTYSOauSey3LVh60=;
        b=GBj9slC/Oxk4nhcTg2p/MuniUJUjqKTNKLKQsXAXqpN9xuYV8lQCu0nwqAqTMebpN4kFlZ
        b2bhKNbqWwZixYL6PmKmIdL7tHN6NhEdPnGsQZiXa2YEYQVILsqlwyZjou5TDCOkUiPP/i
        SsnqYzxNQ2tOFrVA217Sq1PHhtoKPN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-955poRalORSeRVRrmOX-tQ-1; Sun, 11 Apr 2021 07:15:07 -0400
X-MC-Unique: 955poRalORSeRVRrmOX-tQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD17610054F6;
        Sun, 11 Apr 2021 11:15:04 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58C0C100164A;
        Sun, 11 Apr 2021 11:14:52 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        vivek.gautam@arm.com, shameerali.kolothum.thodi@huawei.com,
        yuzenghui@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com,
        chenxiang66@hisilicon.com, vdumpa@nvidia.com,
        jiangkunkun@huawei.com
Subject: [PATCH v15 12/12] iommu/smmuv3: report additional recoverable faults
Date:   Sun, 11 Apr 2021 13:12:28 +0200
Message-Id: <20210411111228.14386-13-eric.auger@redhat.com>
In-Reply-To: <20210411111228.14386-1-eric.auger@redhat.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up to now we have only reported translation faults. Now that
the guest can induce some configuration faults, let's report them
too. Add propagation for BAD_SUBSTREAMID, CD_FETCH, BAD_CD, WALK_EABT.
We also fix the transcoding for some existing translation faults.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v14 -> v15:
- adapt to removal of IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID
  in [PATCH v13 10/10] iommu/arm-smmu-v3: Add stall support for
  platform devices
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 40 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  4 +++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3b0a67434f7d..d5c39c8e95b0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1473,6 +1473,7 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	u32 perm = 0;
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
+	u8 type = FIELD_GET(EVTQ_0_ID, evt[0]);
 	u32 sid = FIELD_GET(EVTQ_0_SID, evt[0]);
 	struct iommu_fault_event fault_evt = { };
 	struct iommu_fault *flt = &fault_evt.fault;
@@ -1525,8 +1526,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	} else {
 		flt->type = IOMMU_FAULT_DMA_UNRECOV;
 		flt->event = (struct iommu_fault_unrecoverable) {
-			.reason = reason,
-			.flags = IOMMU_FAULT_UNRECOV_ADDR_VALID,
 			.perm = perm,
 			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
 		};
@@ -1535,6 +1534,43 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
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
 
 	mutex_lock(&smmu->streams_mutex);
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
2.26.3

