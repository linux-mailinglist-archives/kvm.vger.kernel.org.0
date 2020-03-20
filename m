Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF3218D3BD
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgCTQLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:50575 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgCTQLU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CfkwkXd978FVQfp2tm/Q77JARSBPMPBee3xOehCW3DA=;
        b=eUTHQuUmr/6UVExqLozRdRBlpAuKckISTnad6LIKRBH6b210T7l7262snYzNqNg8UX//WR
        L8vkzRwfe+6XfIvP8nhDEKQKhdqw7IPTC0aSUM53GzX+7cwXEgzjywkM5XWNHbpSdtF7+e
        duKkJKgigyluWpG/dsEIoh+dVCJ+WLY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-w8SAdKAhNbCv2E32Sbkhtw-1; Fri, 20 Mar 2020 12:11:15 -0400
X-MC-Unique: w8SAdKAhNbCv2E32Sbkhtw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77A4C1088386;
        Fri, 20 Mar 2020 16:10:52 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 703785C545;
        Fri, 20 Mar 2020 16:10:45 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 07/13] iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
Date:   Fri, 20 Mar 2020 17:09:26 +0100
Message-Id: <20200320160932.27222-8-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 92a1a5ac5b50..39deddea6ae5 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2301,13 +2301,18 @@ static int arm_smmu_atc_inv_domain(struct arm_smm=
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
@@ -2328,9 +2333,17 @@ static void arm_smmu_tlb_inv_context(void *cookie)
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
@@ -2345,7 +2358,11 @@ static void arm_smmu_tlb_inv_range(unsigned long i=
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
@@ -2405,6 +2422,13 @@ static void arm_smmu_tlb_inv_range(unsigned long i=
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

