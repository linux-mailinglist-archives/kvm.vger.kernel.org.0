Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92771A81BA
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437490AbgDNPMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:12:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436738AbgDNPHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGZKlh4Y3iYusjFkAozB1BrSL7TWS1xxMSS4nCN5u3I=;
        b=VR4V7gUXvadkobUxCScdU2uzItLUf8N9ipgFVNcy9l4Q3TkmJYRwrzB5QKo5CcmYu/HZtY
        BVGZqHRBlF5QagNj5bm8mXj8iIf/3xQU15rTe9RolNxFoDPuNpeIRBxROtUzjEojsZPq+J
        sHfNgcRxMxOws1rUHoZtgaRYgaQcGnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-oN7FE4DZPF2iCVNJOZ74QA-1; Tue, 14 Apr 2020 11:07:32 -0400
X-MC-Unique: oN7FE4DZPF2iCVNJOZ74QA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E2D38017F5;
        Tue, 14 Apr 2020 15:07:29 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1840F271A3;
        Tue, 14 Apr 2020 15:07:24 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        shameerali.kolothum.thodi@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        peter.maydell@linaro.org, zhangfei.gao@gmail.com, tn@semihalf.com,
        zhangfei.gao@foxmail.com, bbhushan2@marvell.com
Subject: [PATCH v11 07/13] iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
Date:   Tue, 14 Apr 2020 17:06:01 +0200
Message-Id: <20200414150607.28488-8-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With nested stage support, soon we will need to invalidate
S1 contexts and ranges tagged with an unmanaged asid, this
latter being managed by the guest. So let's introduce 2 helpers
that allow to invalidate with externally managed ASIDs

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 21bcf2536320..4ec2106be301 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2307,13 +2307,18 @@ static int arm_smmu_atc_inv_domain(struct arm_smm=
u_domain *smmu_domain,
 }
=20
 /* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
+
+static void __arm_smmu_tlb_inv_context(struct arm_smmu_domain *smmu_doma=
in,
+				       int ext_asid)
 {
-	struct arm_smmu_domain *smmu_domain =3D cookie;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
 	struct arm_smmu_cmdq_ent cmd;
=20
-	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >=3D 0) { /* guest stage 1 invalidation */
+		cmd.opcode	=3D CMDQ_OP_TLBI_NH_ASID;
+		cmd.tlbi.asid	=3D ext_asid;
+		cmd.tlbi.vmid	=3D smmu_domain->s2_cfg->vmid;
+	} else if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	=3D CMDQ_OP_TLBI_NH_ASID;
 		cmd.tlbi.asid	=3D smmu_domain->s1_cfg->cd.asid;
 		cmd.tlbi.vmid	=3D 0;
@@ -2334,9 +2339,17 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_atc_inv_domain(smmu_domain, 0, 0, 0);
 }
=20
-static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
+static void arm_smmu_tlb_inv_context(void *cookie)
+{
+	struct arm_smmu_domain *smmu_domain =3D cookie;
+
+	__arm_smmu_tlb_inv_context(smmu_domain, -1);
+}
+
+static void __arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
 				   size_t granule, bool leaf,
-				   struct arm_smmu_domain *smmu_domain)
+				   struct arm_smmu_domain *smmu_domain,
+				   int ext_asid)
 {
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
 	unsigned long start =3D iova, end =3D iova + size, num_pages =3D 0, tg =
=3D 0;
@@ -2351,7 +2364,11 @@ static void arm_smmu_tlb_inv_range(unsigned long i=
ova, size_t size,
 	if (!size)
 		return;
=20
-	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >=3D 0) {  /* guest stage 1 invalidation */
+		cmd.opcode	=3D CMDQ_OP_TLBI_NH_VA;
+		cmd.tlbi.asid	=3D ext_asid;
+		cmd.tlbi.vmid	=3D smmu_domain->s2_cfg->vmid;
+	} else if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	=3D CMDQ_OP_TLBI_NH_VA;
 		cmd.tlbi.asid	=3D smmu_domain->s1_cfg->cd.asid;
 	} else {
@@ -2411,6 +2428,13 @@ static void arm_smmu_tlb_inv_range(unsigned long i=
ova, size_t size,
 	arm_smmu_atc_inv_domain(smmu_domain, 0, start, size);
 }
=20
+static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
+				   size_t granule, bool leaf,
+				   struct arm_smmu_domain *smmu_domain)
+{
+	__arm_smmu_tlb_inv_range(iova, size, granule, leaf, smmu_domain, -1);
+}
+
 static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gath=
er,
 					 unsigned long iova, size_t granule,
 					 void *cookie)
--=20
2.20.1

