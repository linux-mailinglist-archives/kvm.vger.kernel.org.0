Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CDF3232B5
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhBWU7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:59:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234530AbhBWU7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 15:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXo5Ny5RPqrxMbmK96jXWOW3+XmwgeCaBu6QZll4YCc=;
        b=fY+FYC/3MQ3TjUEO4lfR/sWRyrbbriuOMolJcfT0fOmlIrpXFhAa20CgpN7MEkOT+NtSvv
        nj0LX8kAYSfsrKQTKdLZNc6H3vwJ2VcWv4SdeEcW1/uVnOvaPCI5IkeOCO2kkCaX1GEOIv
        HFYybNCZCTYXYBMjpFUEHzc2Uvrf/yQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-wwYdtQDkNc6HcgElWlgCjw-1; Tue, 23 Feb 2021 15:57:48 -0500
X-MC-Unique: wwYdtQDkNc6HcgElWlgCjw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC68E760;
        Tue, 23 Feb 2021 20:57:45 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47F495D9D0;
        Tue, 23 Feb 2021 20:57:35 +0000 (UTC)
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
Subject: [PATCH v14 06/13] iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
Date:   Tue, 23 Feb 2021 21:56:27 +0100
Message-Id: <20210223205634.604221-7-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With nested stage support, soon we will need to invalidate
S1 contexts and ranges tagged with an unmanaged asid, this
latter being managed by the guest. So let's introduce 2 helpers
that allow to invalidate with externally managed ASIDs

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v13 -> v14
- Actually send the NH_ASID command (reported by Xingang Wang)
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 38 ++++++++++++++++-----
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5579ec4fccc8..4c19a1114de4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1843,9 +1843,9 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 }
 
 /* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
+static void __arm_smmu_tlb_inv_context(struct arm_smmu_domain *smmu_domain,
+				       int ext_asid)
 {
-	struct arm_smmu_domain *smmu_domain = cookie;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_cmdq_ent cmd;
 
@@ -1856,7 +1856,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	 * insertion to guarantee those are observed before the TLBI. Do be
 	 * careful, 007.
 	 */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >= 0) { /* guest stage 1 invalidation */
+		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
+		cmd.tlbi.asid	= ext_asid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
+		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+		arm_smmu_cmdq_issue_sync(smmu);
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		arm_smmu_tlb_inv_asid(smmu, smmu_domain->s1_cfg.cd.asid);
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
@@ -1867,6 +1873,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_atc_inv_domain(smmu_domain, 0, 0, 0);
 }
 
+static void arm_smmu_tlb_inv_context(void *cookie)
+{
+	struct arm_smmu_domain *smmu_domain = cookie;
+
+	__arm_smmu_tlb_inv_context(smmu_domain, -1);
+}
+
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 				     unsigned long iova, size_t size,
 				     size_t granule,
@@ -1926,9 +1939,10 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
-					  size_t granule, bool leaf,
-					  struct arm_smmu_domain *smmu_domain)
+static void
+arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
+			      size_t granule, bool leaf, int ext_asid,
+			      struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_cmdq_ent cmd = {
 		.tlbi = {
@@ -1936,7 +1950,12 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 		},
 	};
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >= 0) {  /* guest stage 1 invalidation */
+		cmd.opcode	= smmu_domain->smmu->features & ARM_SMMU_FEAT_E2H ?
+				  CMDQ_OP_TLBI_EL2_VA : CMDQ_OP_TLBI_NH_VA;
+		cmd.tlbi.asid	= ext_asid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	= smmu_domain->smmu->features & ARM_SMMU_FEAT_E2H ?
 				  CMDQ_OP_TLBI_EL2_VA : CMDQ_OP_TLBI_NH_VA;
 		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
@@ -1944,6 +1963,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 		cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 	}
+
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 
 	/*
@@ -1982,7 +2002,7 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
-	arm_smmu_tlb_inv_range_domain(iova, size, granule, false, cookie);
+	arm_smmu_tlb_inv_range_domain(iova, size, granule, false, -1, cookie);
 }
 
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
@@ -2523,7 +2543,7 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 
 	arm_smmu_tlb_inv_range_domain(gather->start,
 				      gather->end - gather->start + 1,
-				      gather->pgsize, true, smmu_domain);
+				      gather->pgsize, true, -1, smmu_domain);
 }
 
 static phys_addr_t
-- 
2.26.2

