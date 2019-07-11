Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2665602
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfGKLul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:50:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbfGKLuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:50:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B3A33307D91E;
        Thu, 11 Jul 2019 11:50:39 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA5BB600CD;
        Thu, 11 Jul 2019 11:50:35 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        peter.maydell@linaro.org, vincent.stehle@arm.com,
        zhangfei.gao@gmail.com
Subject: [PATCH v9 05/14] iommu/smmuv3: Dynamically allocate s1_cfg and s2_cfg
Date:   Thu, 11 Jul 2019 13:49:50 +0200
Message-Id: <20190711114959.15675-6-eric.auger@redhat.com>
In-Reply-To: <20190711114959.15675-1-eric.auger@redhat.com>
References: <20190711114959.15675-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 11 Jul 2019 11:50:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for the introduction of nested configuration
let's turn s1_cfg and s2_cfg fields into pointers which are
dynamically allocated depending on the smmu_domain stage.

In nested mode, s1_cfg will only be allocated when setting up
S1 translation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 88 +++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 476d9bc7bc29..8139ebe09ec7 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -644,10 +644,8 @@ struct arm_smmu_domain {
 	bool				non_strict;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg		*s1_cfg;
+	struct arm_smmu_s2_cfg		*s2_cfg;
 
 	struct iommu_domain		domain;
 
@@ -1175,17 +1173,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (smmu_domain) {
-		switch (smmu_domain->stage) {
-		case ARM_SMMU_DOMAIN_S1:
-			s1_cfg = &smmu_domain->s1_cfg;
-			break;
-		case ARM_SMMU_DOMAIN_S2:
-		case ARM_SMMU_DOMAIN_NESTED:
-			s2_cfg = &smmu_domain->s2_cfg;
-			break;
-		default:
-			break;
-		}
+		s1_cfg = smmu_domain->s1_cfg;
+		s2_cfg = smmu_domain->s2_cfg;
 	}
 
 	if (val & STRTAB_STE_0_V) {
@@ -1597,11 +1586,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
-		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
+		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
 		cmd.tlbi.vmid	= 0;
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
 	}
 
 	/*
@@ -1628,10 +1617,10 @@ static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
-		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
+		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
 	}
 
 	do {
@@ -1712,26 +1701,29 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_s1_cfg *s1_cfg = smmu_domain->s1_cfg;
+	struct arm_smmu_s2_cfg *s2_cfg = smmu_domain->s2_cfg;
 
 	iommu_put_dma_cookie(domain);
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
 
-	/* Free the CD and ASID, if we allocated them */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		struct arm_smmu_s1_cfg *cfg = &smmu_domain->s1_cfg;
-
-		if (cfg->cdptr) {
+	if (s1_cfg) {
+		/* Free the CD and ASID, if we allocated them */
+		if (s1_cfg->cdptr) {
 			dmam_free_coherent(smmu_domain->smmu->dev,
 					   CTXDESC_CD_DWORDS << 3,
-					   cfg->cdptr,
-					   cfg->cdptr_dma);
+					   s1_cfg->cdptr,
+					   s1_cfg->cdptr_dma);
 
-			arm_smmu_bitmap_free(smmu->asid_map, cfg->cd.asid);
+			arm_smmu_bitmap_free(smmu->asid_map,
+					     s1_cfg->cd.asid);
 		}
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			arm_smmu_bitmap_free(smmu->vmid_map, cfg->vmid);
+		kfree(s1_cfg);
+	}
+	if (s2_cfg) {
+		if (s2_cfg->vmid)
+			arm_smmu_bitmap_free(smmu->vmid_map, s2_cfg->vmid);
+		kfree(s2_cfg);
 	}
 
 	kfree(smmu_domain);
@@ -1743,11 +1735,16 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 	int ret;
 	int asid;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	struct arm_smmu_s1_cfg *cfg = &smmu_domain->s1_cfg;
+	struct arm_smmu_s1_cfg *cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+
+	if (!cfg)
+		return -ENOMEM;
 
 	asid = arm_smmu_bitmap_alloc(smmu->asid_map, smmu->asid_bits);
-	if (asid < 0)
-		return asid;
+	if (asid < 0) {
+		ret = asid;
+		goto out_free_cfg;
+	}
 
 	cfg->cdptr = dmam_alloc_coherent(smmu->dev, CTXDESC_CD_DWORDS << 3,
 					 &cfg->cdptr_dma,
@@ -1762,28 +1759,41 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 	cfg->cd.ttbr	= pgtbl_cfg->arm_lpae_s1_cfg.ttbr[0];
 	cfg->cd.tcr	= pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 	cfg->cd.mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair[0];
+	smmu_domain->s1_cfg = cfg;
 	return 0;
 
 out_free_asid:
 	arm_smmu_bitmap_free(smmu->asid_map, asid);
+out_free_cfg:
+	kfree(cfg);
 	return ret;
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
-	int vmid;
+	int vmid, ret;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
+	struct arm_smmu_s2_cfg *cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+
+	if (!cfg)
+		return -ENOMEM;
 
 	vmid = arm_smmu_bitmap_alloc(smmu->vmid_map, smmu->vmid_bits);
-	if (vmid < 0)
-		return vmid;
+	if (vmid < 0) {
+		ret = vmid;
+		goto out_free_cfg;
+	}
 
 	cfg->vmid	= (u16)vmid;
 	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
 	cfg->vtcr	= pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	smmu_domain->s2_cfg = cfg;
 	return 0;
+
+out_free_cfg:
+	kfree(cfg);
+	return ret;
 }
 
 static int arm_smmu_domain_finalise(struct iommu_domain *domain)
@@ -2003,7 +2013,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_enable_ats(master);
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
-		arm_smmu_write_ctx_desc(smmu, &smmu_domain->s1_cfg);
+		arm_smmu_write_ctx_desc(smmu, smmu_domain->s1_cfg);
 
 	arm_smmu_install_ste_for_dev(master);
 out_unlock:
-- 
2.20.1

