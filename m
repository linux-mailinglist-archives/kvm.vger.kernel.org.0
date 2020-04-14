Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B591A8162
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440189AbgDNPHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:07:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436671AbgDNPHL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 11:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cw0OrE+CqCByeR2/vQexE3lPH3X+hKiB17EQO1/ksD8=;
        b=Vss5qfhqvIphiqpFKaj+U0JsWg/sJspZ2DACRw09ZbL9CSnt5BA0S9CkS8stx3OOpIqlRD
        ieYH4ucSddcE5l8C3iBHGF96zTjgdtDSpVhXWHHuM1QpX5tbV4elt0nDiv94Qj/XyMIeye
        +hgZVrunsWN88WueBgAPyzQWSAJqKWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-rvzh2P9zM9afk0iZkQMsZg-1; Tue, 14 Apr 2020 11:07:06 -0400
X-MC-Unique: rvzh2P9zM9afk0iZkQMsZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45CC31088384;
        Tue, 14 Apr 2020 15:07:03 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EFA6271B2;
        Tue, 14 Apr 2020 15:06:56 +0000 (UTC)
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
Subject: [PATCH v11 04/13] iommu/smmuv3: Dynamically allocate s1_cfg and s2_cfg
Date:   Tue, 14 Apr 2020 17:05:58 +0200
Message-Id: <20200414150607.28488-5-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for the introduction of nested stages
let's turn s1_cfg and s2_cfg fields into pointers which are
dynamically allocated depending on the smmu_domain stage.

In nested mode, both stages will coexist and s1_cfg will
be allocated when the guest configuration gets passed.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 94 ++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index ac7009348749..da3739bb7323 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -719,10 +719,8 @@ struct arm_smmu_domain {
 	atomic_t			nr_ats_masters;
=20
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg		*s1_cfg;
+	struct arm_smmu_s2_cfg		*s2_cfg;
=20
 	struct iommu_domain		domain;
=20
@@ -1598,9 +1596,9 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_=
domain *smmu_domain,
 	unsigned int idx;
 	struct arm_smmu_l1_ctx_desc *l1_desc;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
-	struct arm_smmu_ctx_desc_cfg *cdcfg =3D &smmu_domain->s1_cfg.cdcfg;
+	struct arm_smmu_ctx_desc_cfg *cdcfg =3D &smmu_domain->s1_cfg->cdcfg;
=20
-	if (smmu_domain->s1_cfg.s1fmt =3D=3D STRTAB_STE_0_S1FMT_LINEAR)
+	if (smmu_domain->s1_cfg->s1fmt =3D=3D STRTAB_STE_0_S1FMT_LINEAR)
 		return cdcfg->cdtab + ssid * CTXDESC_CD_DWORDS;
=20
 	idx =3D ssid >> CTXDESC_SPLIT;
@@ -1635,7 +1633,7 @@ static int arm_smmu_write_ctx_desc(struct arm_smmu_=
domain *smmu_domain,
 	__le64 *cdptr;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
=20
-	if (WARN_ON(ssid >=3D (1 << smmu_domain->s1_cfg.s1cdmax)))
+	if (WARN_ON(ssid >=3D (1 << smmu_domain->s1_cfg->s1cdmax)))
 		return -E2BIG;
=20
 	cdptr =3D arm_smmu_get_cd_ptr(smmu_domain, ssid);
@@ -1700,7 +1698,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu=
_domain *smmu_domain)
 	size_t l1size;
 	size_t max_contexts;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
-	struct arm_smmu_s1_cfg *cfg =3D &smmu_domain->s1_cfg;
+	struct arm_smmu_s1_cfg *cfg =3D smmu_domain->s1_cfg;
 	struct arm_smmu_ctx_desc_cfg *cdcfg =3D &cfg->cdcfg;
=20
 	max_contexts =3D 1 << cfg->s1cdmax;
@@ -1748,7 +1746,7 @@ static void arm_smmu_free_cd_tables(struct arm_smmu=
_domain *smmu_domain)
 	int i;
 	size_t size, l1size;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
-	struct arm_smmu_ctx_desc_cfg *cdcfg =3D &smmu_domain->s1_cfg.cdcfg;
+	struct arm_smmu_ctx_desc_cfg *cdcfg =3D &smmu_domain->s1_cfg->cdcfg;
=20
 	if (cdcfg->l1_desc) {
 		size =3D CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
@@ -1839,17 +1837,8 @@ static void arm_smmu_write_strtab_ent(struct arm_s=
mmu_master *master, u32 sid,
 	}
=20
 	if (smmu_domain) {
-		switch (smmu_domain->stage) {
-		case ARM_SMMU_DOMAIN_S1:
-			s1_cfg =3D &smmu_domain->s1_cfg;
-			break;
-		case ARM_SMMU_DOMAIN_S2:
-		case ARM_SMMU_DOMAIN_NESTED:
-			s2_cfg =3D &smmu_domain->s2_cfg;
-			break;
-		default:
-			break;
-		}
+		s1_cfg =3D smmu_domain->s1_cfg;
+		s2_cfg =3D smmu_domain->s2_cfg;
 	}
=20
 	if (val & STRTAB_STE_0_V) {
@@ -2286,11 +2275,11 @@ static void arm_smmu_tlb_inv_context(void *cookie=
)
=20
 	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	=3D CMDQ_OP_TLBI_NH_ASID;
-		cmd.tlbi.asid	=3D smmu_domain->s1_cfg.cd.asid;
+		cmd.tlbi.asid	=3D smmu_domain->s1_cfg->cd.asid;
 		cmd.tlbi.vmid	=3D 0;
 	} else {
 		cmd.opcode	=3D CMDQ_OP_TLBI_S12_VMALL;
-		cmd.tlbi.vmid	=3D smmu_domain->s2_cfg.vmid;
+		cmd.tlbi.vmid	=3D smmu_domain->s2_cfg->vmid;
 	}
=20
 	/*
@@ -2324,10 +2313,10 @@ static void arm_smmu_tlb_inv_range(unsigned long =
iova, size_t size,
=20
 	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	=3D CMDQ_OP_TLBI_NH_VA;
-		cmd.tlbi.asid	=3D smmu_domain->s1_cfg.cd.asid;
+		cmd.tlbi.asid	=3D smmu_domain->s1_cfg->cd.asid;
 	} else {
 		cmd.opcode	=3D CMDQ_OP_TLBI_S2_IPA;
-		cmd.tlbi.vmid	=3D smmu_domain->s2_cfg.vmid;
+		cmd.tlbi.vmid	=3D smmu_domain->s2_cfg->vmid;
 	}
=20
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2477,22 +2466,24 @@ static void arm_smmu_domain_free(struct iommu_dom=
ain *domain)
 {
 	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
+	struct arm_smmu_s1_cfg *s1_cfg =3D smmu_domain->s1_cfg;
+	struct arm_smmu_s2_cfg *s2_cfg =3D smmu_domain->s2_cfg;
=20
 	iommu_put_dma_cookie(domain);
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
=20
 	/* Free the CD and ASID, if we allocated them */
-	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1) {
-		struct arm_smmu_s1_cfg *cfg =3D &smmu_domain->s1_cfg;
-
-		if (cfg->cdcfg.cdtab) {
+	if (s1_cfg) {
+		if (s1_cfg->cdcfg.cdtab) {
 			arm_smmu_free_cd_tables(smmu_domain);
-			arm_smmu_bitmap_free(smmu->asid_map, cfg->cd.asid);
+			arm_smmu_bitmap_free(smmu->asid_map, s1_cfg->cd.asid);
 		}
-	} else {
-		struct arm_smmu_s2_cfg *cfg =3D &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			arm_smmu_bitmap_free(smmu->vmid_map, cfg->vmid);
+		kfree(s1_cfg);
+	}
+	if (s2_cfg) {
+		if (s2_cfg->vmid)
+			arm_smmu_bitmap_free(smmu->vmid_map, s2_cfg->vmid);
+		kfree(s2_cfg);
 	}
=20
 	kfree(smmu_domain);
@@ -2505,15 +2496,21 @@ static int arm_smmu_domain_finalise_s1(struct arm=
_smmu_domain *smmu_domain,
 	int ret;
 	int asid;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
-	struct arm_smmu_s1_cfg *cfg =3D &smmu_domain->s1_cfg;
+	struct arm_smmu_s1_cfg *cfg =3D kzalloc(sizeof(*cfg), GFP_KERNEL);
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =3D &pgtbl_cfg->arm_lpae_s1=
_cfg.tcr;
=20
+	if (!cfg)
+		return -ENOMEM;
+
 	asid =3D arm_smmu_bitmap_alloc(smmu->asid_map, smmu->asid_bits);
-	if (asid < 0)
-		return asid;
+	if (asid < 0) {
+		ret =3D asid;
+		goto out_free_cfg;
+	}
=20
 	cfg->s1cdmax =3D master->ssid_bits;
=20
+	smmu_domain->s1_cfg =3D cfg;
 	ret =3D arm_smmu_alloc_cd_tables(smmu_domain);
 	if (ret)
 		goto out_free_asid;
@@ -2544,6 +2541,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_s=
mmu_domain *smmu_domain,
 	arm_smmu_free_cd_tables(smmu_domain);
 out_free_asid:
 	arm_smmu_bitmap_free(smmu->asid_map, asid);
+out_free_cfg:
+	kfree(cfg);
+	smmu_domain->s1_cfg =3D NULL;
 	return ret;
 }
=20
@@ -2551,14 +2551,19 @@ static int arm_smmu_domain_finalise_s2(struct arm=
_smmu_domain *smmu_domain,
 				       struct arm_smmu_master *master,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
-	int vmid;
+	int vmid, ret;
 	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
-	struct arm_smmu_s2_cfg *cfg =3D &smmu_domain->s2_cfg;
+	struct arm_smmu_s2_cfg *cfg =3D kzalloc(sizeof(*cfg), GFP_KERNEL);
 	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
=20
+	if (!cfg)
+		return -ENOMEM;
+
 	vmid =3D arm_smmu_bitmap_alloc(smmu->vmid_map, smmu->vmid_bits);
-	if (vmid < 0)
-		return vmid;
+	if (vmid < 0) {
+		ret =3D vmid;
+		goto out_free_cfg;
+	}
=20
 	vtcr =3D &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
 	cfg->vmid	=3D (u16)vmid;
@@ -2570,7 +2575,12 @@ static int arm_smmu_domain_finalise_s2(struct arm_=
smmu_domain *smmu_domain,
 			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
 			  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
 			  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
+	smmu_domain->s2_cfg =3D cfg;
 	return 0;
+
+out_free_cfg:
+	kfree(cfg);
+	return ret;
 }
=20
 static int arm_smmu_domain_finalise(struct iommu_domain *domain,
@@ -2848,10 +2858,10 @@ static int arm_smmu_attach_dev(struct iommu_domai=
n *domain, struct device *dev)
 		ret =3D -ENXIO;
 		goto out_unlock;
 	} else if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_S1 &&
-		   master->ssid_bits !=3D smmu_domain->s1_cfg.s1cdmax) {
+		   master->ssid_bits !=3D smmu_domain->s1_cfg->s1cdmax) {
 		dev_err(dev,
 			"cannot attach to incompatible domain (%u SSID bits !=3D %u)\n",
-			smmu_domain->s1_cfg.s1cdmax, master->ssid_bits);
+			smmu_domain->s1_cfg->s1cdmax, master->ssid_bits);
 		ret =3D -EINVAL;
 		goto out_unlock;
 	}
--=20
2.20.1

