Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87118D3D1
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgCTQLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51905 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727629AbgCTQLe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zxd29eTS8xRyZDHVGco/W0/BoszLtNWQ2VxQiI4ykEk=;
        b=JadTXKQG0h5glBiK3O+qDrRkjG9EC74lRinm+6A69pgCisWf0aaPkUKeeHTNF6XB4wAO4o
        UdOsi+wByuY2UxDVpozAmd3skqmcxx9jYx//ziucogn6goRB86y5OhYPLFaGXwS2IOa+Yh
        9r6gA6kOirF3nVOf2AoukrN14u1L2X8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Yiykauy_M4Gg9g7pn3E38A-1; Fri, 20 Mar 2020 12:11:31 -0400
X-MC-Unique: Yiykauy_M4Gg9g7pn3E38A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0FEB107ACC9;
        Fri, 20 Mar 2020 16:11:20 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A35135C1D8;
        Fri, 20 Mar 2020 16:11:14 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 12/13] iommu/smmuv3: Implement bind/unbind_guest_msi
Date:   Fri, 20 Mar 2020 17:09:31 +0100
Message-Id: <20200320160932.27222-13-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bind/unbind_guest_msi() callbacks check the domain
is NESTED and redirect to the dma-iommu implementation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v6 -> v7:
- remove device handle argument
---
 drivers/iommu/arm-smmu-v3.c | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 106f9c563823..c98ee8edf5cf 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3371,6 +3371,47 @@ static void arm_smmu_get_resv_regions(struct devic=
e *dev,
 	iommu_dma_get_resv_regions(dev, head);
 }
=20
+static int
+arm_smmu_bind_guest_msi(struct iommu_domain *domain,
+			dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
+	struct arm_smmu_device *smmu;
+	int ret =3D -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	smmu =3D smmu_domain->smmu;
+	if (!smmu)
+		goto out;
+
+	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
+		goto out;
+
+	ret =3D iommu_dma_bind_guest_msi(domain, giova, gpa, size);
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
+static void
+arm_smmu_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
+{
+	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
+	struct arm_smmu_device *smmu;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	smmu =3D smmu_domain->smmu;
+	if (!smmu)
+		goto unlock;
+
+	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
+		goto unlock;
+
+	iommu_dma_unbind_guest_msi(domain, giova);
+unlock:
+	mutex_unlock(&smmu_domain->init_mutex);
+}
+
 static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 				       struct iommu_pasid_table_config *cfg)
 {
@@ -3540,6 +3581,8 @@ static struct iommu_ops arm_smmu_ops =3D {
 	.attach_pasid_table	=3D arm_smmu_attach_pasid_table,
 	.detach_pasid_table	=3D arm_smmu_detach_pasid_table,
 	.cache_invalidate	=3D arm_smmu_cache_invalidate,
+	.bind_guest_msi		=3D arm_smmu_bind_guest_msi,
+	.unbind_guest_msi	=3D arm_smmu_unbind_guest_msi,
 	.pgsize_bitmap		=3D -1UL, /* Restricted during device attach */
 };
=20
--=20
2.20.1

