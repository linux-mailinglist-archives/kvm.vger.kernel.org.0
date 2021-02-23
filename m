Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203B63232B2
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhBWU7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:59:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234530AbhBWU66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 15:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=We8JebIdIv08lvztrAg99Vp4+LJV2YHe0nGSBeiTSko=;
        b=P8odJgG5PJtgFByoiix8rIOKxNrg265cB+w2M3/4+usriLYC8gjNKDT7PzBm4t5j0iM/ch
        F4Daou4kGWOt/FIWWAuiUA4bD5DXYp7m9YOyaxoklYRmasz1SFNwhRsjONfzZn9dqRGu07
        w8NXdapL2/Y+LhvK5B+Vb09cwXPM/2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-vvoyUWTKMdCEq3CSa-0zSg-1; Tue, 23 Feb 2021 15:57:27 -0500
X-MC-Unique: vvoyUWTKMdCEq3CSa-0zSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45CAA801983;
        Tue, 23 Feb 2021 20:57:24 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34ADD5D9D0;
        Tue, 23 Feb 2021 20:57:15 +0000 (UTC)
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
Subject: [PATCH v14 04/13] iommu/smmuv3: Get prepared for nested stage support
Date:   Tue, 23 Feb 2021 21:56:25 +0100
Message-Id: <20210223205634.604221-5-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When nested stage translation is setup, both s1_cfg and
s2_cfg are set.

We introduce a new smmu_domain abort field that will be set
upon guest stage1 configuration passing. If no guest stage1
config has been attached, it is ignored when writing the STE.

arm_smmu_write_strtab_ent() is modified to write both stage
fields in the STE and deal with the abort field.

In nested mode, only stage 2 is "finalized" as the host does
not own/configure the stage 1 context descriptor; guest does.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v13 -> v14:
- removed BUG_ON(ste_live && !nested) as this should never happen
- restored the old comment as there is always an abort in between
  S2 -> S1 + S2 and S1 + S2 -> S2
- remove sparse warning

v10 -> v11:
- Fix an issue reported by Shameer when switching from with vSMMU
  to without vSMMU. Despite the spec does not seem to mention it
  seems to be needed to reset the 2 high 64b when switching from
  S1+S2 cfg to S1 only. Especially dst[3] needs to be reset (S2TTB).
  On some implementations, if the S2TTB is not reset, this causes
  a C_BAD_STE error
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 55 ++++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 14e5666c25dc..085a784dfaee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1237,7 +1237,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	 * 3. Update Config, sync
 	 */
 	u64 val = le64_to_cpu(dst[0]);
-	bool ste_live = false;
+	bool s1_live = false, s2_live = false, ste_live;
+	bool abort, translate = false;
 	struct arm_smmu_device *smmu = NULL;
 	struct arm_smmu_s1_cfg *s1_cfg;
 	struct arm_smmu_s2_cfg *s2_cfg;
@@ -1277,6 +1278,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		default:
 			break;
 		}
+		translate = s1_cfg->set || s2_cfg->set;
 	}
 
 	if (val & STRTAB_STE_0_V) {
@@ -1284,23 +1286,36 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		case STRTAB_STE_0_CFG_BYPASS:
 			break;
 		case STRTAB_STE_0_CFG_S1_TRANS:
+			s1_live = true;
+			break;
 		case STRTAB_STE_0_CFG_S2_TRANS:
-			ste_live = true;
+			s2_live = true;
+			break;
+		case STRTAB_STE_0_CFG_NESTED:
+			s1_live = true;
+			s2_live = true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
-			BUG_ON(!disable_bypass);
 			break;
 		default:
 			BUG(); /* STE corruption */
 		}
 	}
 
+	ste_live = s1_live || s2_live;
+
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
 	/* Bypass/fault */
-	if (!smmu_domain || !(s1_cfg->set || s2_cfg->set)) {
-		if (!smmu_domain && disable_bypass)
+
+	if (!smmu_domain)
+		abort = disable_bypass;
+	else
+		abort = smmu_domain->abort;
+
+	if (abort || !translate) {
+		if (abort)
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
@@ -1318,11 +1333,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		return;
 	}
 
+	if (ste_live) {
+		/* First invalidate the live STE */
+		dst[0] = cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
+		arm_smmu_sync_ste_for_sid(smmu, sid);
+	}
+
 	if (s1_cfg->set) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
-		BUG_ON(ste_live);
+		BUG_ON(s1_live);
 		dst[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1341,7 +1362,14 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (s2_cfg->set) {
-		BUG_ON(ste_live);
+		u64 vttbr = s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK;
+
+		if (s2_live) {
+			u64 s2ttb = le64_to_cpu(dst[3]) & STRTAB_STE_3_S2TTB_MASK;
+
+			BUG_ON(s2ttb != vttbr);
+		}
+
 		dst[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
@@ -1351,9 +1379,12 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
 			 STRTAB_STE_2_S2R);
 
-		dst[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+		dst[3] = cpu_to_le64(vttbr);
 
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
+	} else {
+		dst[2] = 0;
+		dst[3] = 0;
 	}
 
 	if (master->ats_enabled)
@@ -2154,6 +2185,14 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
 		return 0;
 	}
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED &&
+	    (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
+	     !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
+		dev_info(smmu_domain->smmu->dev,
+			 "does not implement two stages\n");
+		return -EINVAL;
+	}
+
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ec2b77596b6a..eb0cc08e8240 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -206,6 +206,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -722,6 +723,7 @@ struct arm_smmu_domain {
 	enum arm_smmu_domain_stage	stage;
 	struct arm_smmu_s1_cfg	s1_cfg;
 	struct arm_smmu_s2_cfg	s2_cfg;
+	bool				abort;
 
 	struct iommu_domain		domain;
 
-- 
2.26.2

