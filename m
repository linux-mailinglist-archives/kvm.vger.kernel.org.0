Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E9718D3CC
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgCTQL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:29 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25747 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgCTQL0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UupNCCxt4n1UUir8pm0L2/8EWRBOSv9Ad1mpCsKanlQ=;
        b=LTd0t+/4h0F9d+59WIxpmMMr/OUyCbt8n8IgMNlja0fs9P4/azWY3Bvcb6FSmG9b27uh/C
        LRwPefRO2sHsi+V+D9VdVigLcK5QshMiOkOooLXSERjySE0TxN26pxNBV10apF9vqIsXHd
        Rdq9LiCc0taLRSKxFkecBCq9omiABsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-NQQs-AD-MQ26fpjdPqUm-w-1; Fri, 20 Mar 2020 12:11:23 -0400
X-MC-Unique: NQQs-AD-MQ26fpjdPqUm-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85A57101C81E;
        Fri, 20 Mar 2020 16:10:56 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDDF75C1D8;
        Fri, 20 Mar 2020 16:10:52 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 08/13] iommu/smmuv3: Implement cache_invalidate
Date:   Fri, 20 Mar 2020 17:09:27 +0100
Message-Id: <20200320160932.27222-9-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement domain-selective and page-selective IOTLB invalidations.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v7 -> v8:
- ASID based invalidation using iommu_inv_pasid_info
- check ARCHID/PASID flags in addr based invalidation
- use __arm_smmu_tlb_inv_context and __arm_smmu_tlb_inv_range_nosync

v6 -> v7
- check the uapi version

v3 -> v4:
- adapt to changes in the uapi
- add support for leaf parameter
- do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
  anymore

v2 -> v3:
- replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync

v1 -> v2:
- properly pass the asid
---
 drivers/iommu/arm-smmu-v3.c | 53 +++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 39deddea6ae5..538e368c2e13 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3407,6 +3407,58 @@ static void arm_smmu_detach_pasid_table(struct iom=
mu_domain *domain)
 	mutex_unlock(&smmu_domain->init_mutex);
 }
=20
+static int
+arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *de=
v,
+			  struct iommu_cache_invalidate_info *inv_info)
+{
+	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
+	struct arm_smmu_device *smmu =3D smmu_domain->smmu;
+
+	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
+		return -EINVAL;
+
+	if (!smmu)
+		return -EINVAL;
+
+	if (inv_info->version !=3D IOMMU_CACHE_INVALIDATE_INFO_VERSION_1)
+		return -EINVAL;
+
+	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB) {
+		if (inv_info->granularity =3D=3D IOMMU_INV_GRANU_PASID) {
+			struct iommu_inv_pasid_info *info =3D
+				&inv_info->pasid_info;
+
+			if (!(info->flags & IOMMU_INV_PASID_FLAGS_ARCHID) ||
+			     (info->flags & IOMMU_INV_PASID_FLAGS_PASID))
+				return -EINVAL;
+
+			__arm_smmu_tlb_inv_context(smmu_domain, info->archid);
+
+		} else if (inv_info->granularity =3D=3D IOMMU_INV_GRANU_ADDR) {
+			struct iommu_inv_addr_info *info =3D &inv_info->addr_info;
+			size_t size =3D info->nb_granules * info->granule_size;
+			bool leaf =3D info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
+
+			if (!(info->flags & IOMMU_INV_ADDR_FLAGS_ARCHID) ||
+			     (info->flags & IOMMU_INV_ADDR_FLAGS_PASID))
+				return -EINVAL;
+
+			__arm_smmu_tlb_inv_range(info->addr, size,
+						 info->granule_size, leaf,
+						  smmu_domain, info->archid);
+
+			arm_smmu_cmdq_issue_sync(smmu);
+		} else {
+			return -EINVAL;
+		}
+	}
+	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
+	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static struct iommu_ops arm_smmu_ops =3D {
 	.capable		=3D arm_smmu_capable,
 	.domain_alloc		=3D arm_smmu_domain_alloc,
@@ -3427,6 +3479,7 @@ static struct iommu_ops arm_smmu_ops =3D {
 	.put_resv_regions	=3D generic_iommu_put_resv_regions,
 	.attach_pasid_table	=3D arm_smmu_attach_pasid_table,
 	.detach_pasid_table	=3D arm_smmu_detach_pasid_table,
+	.cache_invalidate	=3D arm_smmu_cache_invalidate,
 	.pgsize_bitmap		=3D -1UL, /* Restricted during device attach */
 };
=20
--=20
2.20.1

