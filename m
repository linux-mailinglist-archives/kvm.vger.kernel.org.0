Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C867218D3B4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgCTQK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:10:29 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40196 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727521AbgCTQK3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lizqgzebhUehQOqguh40frwH8O2jQCU1iag5uMPGqqo=;
        b=AV3GDKTcnkSTIAz2ANKEAU4jNAG1dCxGDoaSgGevIy5RQZqDmq+Y8eTPUeoniLm3IUC5UV
        XKiI1WkfBbyn3lPojbyeBEJtTsrV6A+IoegjeEQIAOn+fKQ3ZFvUf93LjOjNG9ayfnr7hL
        ngOqzo8gePUWLGPttL0sz/qst8yoatA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-TBTPVY4cM--Uo84hUFhhEQ-1; Fri, 20 Mar 2020 12:10:24 -0400
X-MC-Unique: TBTPVY4cM--Uo84hUFhhEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9C75477;
        Fri, 20 Mar 2020 16:10:21 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 586C65F700;
        Fri, 20 Mar 2020 16:10:13 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 05/13] iommu/smmuv3: Get prepared for nested stage support
Date:   Fri, 20 Mar 2020 17:09:24 +0100
Message-Id: <20200320160932.27222-6-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When nested stage translation is setup, both s1_cfg and
s2_cfg are allocated.

We introduce a new smmu domain abort field that will be set
upon guest stage1 configuration passing.

arm_smmu_write_strtab_ent() is modified to write both stage
fields in the STE and deal with the abort field.

In nested mode, only stage 2 is "finalized" as the host does
not own/configure the stage 1 context descriptor; guest does.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v7 -> v8:
- rebase on 8be39a1a04c1 iommu/arm-smmu-v3: Add a master->domain
  pointer
- restore live checks for not nested cases and add s1_live and
  s2_live to be more previse. Remove bypass local variable.
  In STE live case, move the ste to abort state and send a
  CFGI_STE before updating the rest of the fields.
- check s2ttb in case of live s2

v4 -> v5:
- reset ste.abort on detach

v3 -> v4:
- s1_cfg.nested_abort and nested_bypass removed.
- s/ste.nested/ste.abort
- arm_smmu_write_strtab_ent modifications with introduction
  of local abort, bypass and translate local variables
- comment updated
---
 drivers/iommu/arm-smmu-v3.c | 62 +++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 8b3083c5f27b..7d00244fe725 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -223,6 +223,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
=20
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -721,6 +722,7 @@ struct arm_smmu_domain {
 	enum arm_smmu_domain_stage	stage;
 	struct arm_smmu_s1_cfg		*s1_cfg;
 	struct arm_smmu_s2_cfg		*s2_cfg;
+	bool				abort;
=20
 	struct iommu_domain		domain;
=20
@@ -1807,8 +1809,10 @@ static void arm_smmu_write_strtab_ent(struct arm_s=
mmu_master *master, u32 sid,
 	 * three cases at the moment:
 	 *
 	 * 1. Invalid (all zero) -> bypass/fault (init)
-	 * 2. Bypass/fault -> translation/bypass (attach)
-	 * 3. Translation/bypass -> bypass/fault (detach)
+	 * 2. Bypass/fault -> single stage translation/bypass (attach)
+	 * 3. single stage Translation/bypass -> bypass/fault (detach)
+	 * 4. S2 -> S1 + S2 (attach_pasid_table)
+	 * 5. S1 + S2 -> S2 (detach_pasid_table)
 	 *
 	 * Given that we can't update the STE atomically and the SMMU
 	 * doesn't read the thing in a defined order, that leaves us
@@ -1819,7 +1823,8 @@ static void arm_smmu_write_strtab_ent(struct arm_sm=
mu_master *master, u32 sid,
 	 * 3. Update Config, sync
 	 */
 	u64 val =3D le64_to_cpu(dst[0]);
-	bool ste_live =3D false;
+	bool abort, translate, s1_live =3D false, s2_live =3D false, ste_live;
+	bool nested =3D false;
 	struct arm_smmu_device *smmu =3D NULL;
 	struct arm_smmu_s1_cfg *s1_cfg =3D NULL;
 	struct arm_smmu_s2_cfg *s2_cfg =3D NULL;
@@ -1839,6 +1844,7 @@ static void arm_smmu_write_strtab_ent(struct arm_sm=
mu_master *master, u32 sid,
 	if (smmu_domain) {
 		s1_cfg =3D smmu_domain->s1_cfg;
 		s2_cfg =3D smmu_domain->s2_cfg;
+		nested =3D (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_NESTED);
 	}
=20
 	if (val & STRTAB_STE_0_V) {
@@ -1846,23 +1852,34 @@ static void arm_smmu_write_strtab_ent(struct arm_=
smmu_master *master, u32 sid,
 		case STRTAB_STE_0_CFG_BYPASS:
 			break;
 		case STRTAB_STE_0_CFG_S1_TRANS:
+			s1_live =3D true;
+			break;
 		case STRTAB_STE_0_CFG_S2_TRANS:
-			ste_live =3D true;
+			s2_live =3D true;
+			break;
+		case STRTAB_STE_0_CFG_NESTED:
+			s1_live =3D true;
+			s2_live =3D true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
-			BUG_ON(!disable_bypass);
 			break;
 		default:
 			BUG(); /* STE corruption */
 		}
 	}
=20
+	ste_live =3D s1_live || s2_live;
+
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val =3D STRTAB_STE_0_V;
=20
 	/* Bypass/fault */
-	if (!smmu_domain || !(s1_cfg || s2_cfg)) {
-		if (!smmu_domain && disable_bypass)
+
+	abort =3D (!smmu_domain && disable_bypass) || smmu_domain->abort;
+	translate =3D s1_cfg || s2_cfg;
+
+	if (abort || !translate) {
+		if (abort)
 			val |=3D FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
 			val |=3D FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
@@ -1880,8 +1897,18 @@ static void arm_smmu_write_strtab_ent(struct arm_s=
mmu_master *master, u32 sid,
 		return;
 	}
=20
+	/* S1 or S2 translation */
+
+	BUG_ON(ste_live && !nested);
+
+	if (ste_live) {
+		/* First invalidate the live STE */
+		dst[0] =3D cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
+		arm_smmu_sync_ste_for_sid(smmu, sid);
+	}
+
 	if (s1_cfg) {
-		BUG_ON(ste_live);
+		BUG_ON(s1_live);
 		dst[1] =3D cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1900,7 +1927,14 @@ static void arm_smmu_write_strtab_ent(struct arm_s=
mmu_master *master, u32 sid,
 	}
=20
 	if (s2_cfg) {
-		BUG_ON(ste_live);
+		u64 vttbr =3D s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK;
+
+		if (s2_live) {
+			u64 s2ttb =3D le64_to_cpu(dst[3] & STRTAB_STE_3_S2TTB_MASK);
+
+			BUG_ON(s2ttb !=3D vttbr);
+		}
+
 		dst[2] =3D cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
@@ -1910,7 +1944,7 @@ static void arm_smmu_write_strtab_ent(struct arm_sm=
mu_master *master, u32 sid,
 			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
 			 STRTAB_STE_2_S2R);
=20
-		dst[3] =3D cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+		dst[3] =3D cpu_to_le64(vttbr);
=20
 		val |=3D FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
 	}
@@ -2602,6 +2636,14 @@ static int arm_smmu_domain_finalise(struct iommu_d=
omain *domain,
 		return 0;
 	}
=20
+	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_NESTED &&
+	    (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
+	     !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
+		dev_info(smmu_domain->smmu->dev,
+			 "does not implement two stages\n");
+		return -EINVAL;
+	}
+
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
 		smmu_domain->stage =3D ARM_SMMU_DOMAIN_S2;
--=20
2.20.1

