Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5772AAD9
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfEZQLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 12:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfEZQLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 12:11:43 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 238F43082200;
        Sun, 26 May 2019 16:11:42 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-67.ams2.redhat.com [10.36.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43A755D72A;
        Sun, 26 May 2019 16:11:38 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        peter.maydell@linaro.org, vincent.stehle@arm.com
Subject: [PATCH v8 15/29] iommu/smmuv3: Introduce __arm_smmu_tlb_inv_asid/s1_range_nosync
Date:   Sun, 26 May 2019 18:09:50 +0200
Message-Id: <20190526161004.25232-16-eric.auger@redhat.com>
In-Reply-To: <20190526161004.25232-1-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sun, 26 May 2019 16:11:42 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce helpers to invalidate a given asid/vmid or invalidate
address ranges associated to a given asid/vmid.

S1 helpers will be used to invalidate stage 1 caches upon
userspace request, in nested mode.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 drivers/iommu/arm-smmu-v3.c | 98 ++++++++++++++++++++++++++++---------
 1 file changed, 74 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index d770977bfc92..724b86ab9a80 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1601,20 +1601,15 @@ static void arm_smmu_tlb_sync(void *cookie)
 	arm_smmu_cmdq_issue_sync(smmu_domain->smmu);
 }
 
-static void arm_smmu_tlb_inv_context(void *cookie)
+static void __arm_smmu_tlb_inv_asid(struct arm_smmu_domain *smmu_domain,
+				    u16 vmid, u16 asid)
 {
-	struct arm_smmu_domain *smmu_domain = cookie;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	struct arm_smmu_cmdq_ent cmd;
+	struct arm_smmu_cmdq_ent cmd = {};
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
-		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
-		cmd.tlbi.vmid	= 0;
-	} else {
-		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
-	}
+	cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
+	cmd.tlbi.vmid	= vmid;
+	cmd.tlbi.asid	= asid;
 
 	/*
 	 * NOTE: when io-pgtable is in non-strict mode, we may get here with
@@ -1626,32 +1621,87 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_cmdq_issue_sync(smmu);
 }
 
-static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
-					  size_t granule, bool leaf, void *cookie)
+static void __arm_smmu_tlb_inv_vmid(struct arm_smmu_domain *smmu_domain,
+				    u16 vmid)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
+	cmd.tlbi.vmid	= vmid;
+
+	/* See DSB related comment in __arm_smmu_tlb_inv_asid */
+	arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+	arm_smmu_cmdq_issue_sync(smmu);
+}
+
+static void arm_smmu_tlb_inv_context(void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	struct arm_smmu_cmdq_ent cmd = {
-		.tlbi = {
-			.leaf	= leaf,
-			.addr	= iova,
-		},
-	};
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
-		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
+		__arm_smmu_tlb_inv_asid(smmu_domain, 0,
+					smmu_domain->s1_cfg->cd.asid);
 	} else {
-		cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
+		__arm_smmu_tlb_inv_vmid(smmu_domain,
+					smmu_domain->s2_cfg->vmid);
 	}
+}
 
+static void
+__arm_smmu_tlb_inv_s1_range_nosync(struct arm_smmu_domain *smmu_domain,
+				   u16 vmid, u16 asid, unsigned long iova,
+				   size_t size, size_t granule, bool leaf)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
+	cmd.tlbi.vmid	= vmid;
+	cmd.tlbi.asid	= asid;
+	cmd.tlbi.addr	= iova;
+	cmd.tlbi.leaf	= leaf;
 	do {
 		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
 		cmd.tlbi.addr += granule;
 	} while (size -= granule);
 }
 
+static void
+__arm_smmu_tlb_inv_s2_range_nosync(struct arm_smmu_domain *smmu_domain,
+				   u16 vmid, unsigned long iova, size_t size,
+				   size_t granule, bool leaf)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
+	cmd.tlbi.vmid	= vmid;
+	cmd.tlbi.addr	= iova;
+	cmd.tlbi.leaf	= leaf;
+	do {
+		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+		cmd.tlbi.addr += granule;
+	} while (size -= granule);
+}
+
+static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
+					  size_t granule, bool leaf,
+					  void *cookie)
+{
+	struct arm_smmu_domain *smmu_domain = cookie;
+
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+		__arm_smmu_tlb_inv_s1_range_nosync(smmu_domain, 0,
+						   smmu_domain->s1_cfg->cd.asid,
+						   iova, size, granule, leaf);
+	} else {
+		__arm_smmu_tlb_inv_s2_range_nosync(smmu_domain,
+						   smmu_domain->s2_cfg->vmid,
+						   iova, size, granule, leaf);
+	}
+}
+
 static const struct iommu_gather_ops arm_smmu_gather_ops = {
 	.tlb_flush_all	= arm_smmu_tlb_inv_context,
 	.tlb_add_flush	= arm_smmu_tlb_inv_range_nosync,
-- 
2.20.1

