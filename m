Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B8435B364
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbhDKLNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:13:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235455AbhDKLNl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618139605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4MRTBriUvDsWoAKPG21Y5ko0Ss3BMOgxkWYlZi8C70U=;
        b=AsCsYUQvErLHuKGSR2K0YkGPllPIL0fGziFlHPq6wE2u6dHmxAWNZox4uO1oKTmlkKx+6I
        U+c2QvUOMa1nsrwfjYfH6Hl8rR7cxFVyXmQbTlWsE0ryywnku+fGQnG0lxLDTNataWvO6Y
        SMTmwsakZypgWtr15lwmvua0RyYjwnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-QaoSahq2NECQ4uRbduRryQ-1; Sun, 11 Apr 2021 07:13:21 -0400
X-MC-Unique: QaoSahq2NECQ4uRbduRryQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 925EF5B378;
        Sun, 11 Apr 2021 11:13:18 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CA38101E24A;
        Sun, 11 Apr 2021 11:13:11 +0000 (UTC)
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
Subject: [PATCH v15 03/12] iommu/smmuv3: Allow s1 and s2 configs to coexist
Date:   Sun, 11 Apr 2021 13:12:19 +0200
Message-Id: <20210411111228.14386-4-eric.auger@redhat.com>
In-Reply-To: <20210411111228.14386-1-eric.auger@redhat.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In true nested mode, both s1_cfg and s2_cfg will coexist.
Let's remove the union and add a "set" field in each
config structure telling whether the config is set and needs
to be applied when writing the STE. In legacy nested mode,
only the second stage is used. In true nested mode, both stages
are used and the S1 config is "set" when the guest passes
its pasid table.

No functional change intended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v13 -> v14:
- slight reword of the commit message

v12 -> v13:
- does not dynamically allocate s1-cfg and s2_cfg anymore. Add
  the set field
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 43 +++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++--
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 53abad8fdd91..22fb39a9ef31 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1239,8 +1239,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	u64 val = le64_to_cpu(dst[0]);
 	bool ste_live = false;
 	struct arm_smmu_device *smmu = NULL;
-	struct arm_smmu_s1_cfg *s1_cfg = NULL;
-	struct arm_smmu_s2_cfg *s2_cfg = NULL;
+	struct arm_smmu_s1_cfg *s1_cfg;
+	struct arm_smmu_s2_cfg *s2_cfg;
 	struct arm_smmu_domain *smmu_domain = NULL;
 	struct arm_smmu_cmdq_ent prefetch_cmd = {
 		.opcode		= CMDQ_OP_PREFETCH_CFG,
@@ -1255,13 +1255,24 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (smmu_domain) {
+		s1_cfg = &smmu_domain->s1_cfg;
+		s2_cfg = &smmu_domain->s2_cfg;
+
 		switch (smmu_domain->stage) {
 		case ARM_SMMU_DOMAIN_S1:
-			s1_cfg = &smmu_domain->s1_cfg;
+			s1_cfg->set = true;
+			s2_cfg->set = false;
 			break;
 		case ARM_SMMU_DOMAIN_S2:
+			s1_cfg->set = false;
+			s2_cfg->set = true;
+			break;
 		case ARM_SMMU_DOMAIN_NESTED:
-			s2_cfg = &smmu_domain->s2_cfg;
+			/*
+			 * Actual usage of stage 1 depends on nested mode:
+			 * legacy (2d stage only) or true nested mode
+			 */
+			s2_cfg->set = true;
 			break;
 		default:
 			break;
@@ -1288,7 +1299,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	val = STRTAB_STE_0_V;
 
 	/* Bypass/fault */
-	if (!smmu_domain || !(s1_cfg || s2_cfg)) {
+	if (!smmu_domain || !(s1_cfg->set || s2_cfg->set)) {
 		if (!smmu_domain && disable_bypass)
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
@@ -1307,7 +1318,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		return;
 	}
 
-	if (s1_cfg) {
+	if (s1_cfg->set) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
@@ -1329,7 +1340,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			FIELD_PREP(STRTAB_STE_0_S1FMT, s1_cfg->s1fmt);
 	}
 
-	if (s2_cfg) {
+	if (s2_cfg->set) {
 		BUG_ON(ste_live);
 		dst[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
@@ -2020,24 +2031,24 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_s1_cfg *s1_cfg = &smmu_domain->s1_cfg;
+	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 
 	iommu_put_dma_cookie(domain);
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
 
 	/* Free the CD and ASID, if we allocated them */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		struct arm_smmu_s1_cfg *cfg = &smmu_domain->s1_cfg;
-
+	if (s1_cfg->set) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
-		if (cfg->cdcfg.cdtab)
+		if (s1_cfg->cdcfg.cdtab)
 			arm_smmu_free_cd_tables(smmu_domain);
-		arm_smmu_free_asid(&cfg->cd);
+		arm_smmu_free_asid(&s1_cfg->cd);
 		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			arm_smmu_bitmap_free(smmu->vmid_map, cfg->vmid);
+	}
+	if (s2_cfg->set) {
+		if (s2_cfg->vmid)
+			arm_smmu_bitmap_free(smmu->vmid_map, s2_cfg->vmid);
 	}
 
 	kfree(smmu_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 59af0bbd2f7b..ec2b77596b6a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -598,12 +598,14 @@ struct arm_smmu_s1_cfg {
 	struct arm_smmu_ctx_desc	cd;
 	u8				s1fmt;
 	u8				s1cdmax;
+	bool				set;
 };
 
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 	u64				vttbr;
 	u64				vtcr;
+	bool				set;
 };
 
 struct arm_smmu_strtab_cfg {
@@ -718,10 +720,8 @@ struct arm_smmu_domain {
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg	s1_cfg;
+	struct arm_smmu_s2_cfg	s2_cfg;
 
 	struct iommu_domain		domain;
 
-- 
2.26.3

