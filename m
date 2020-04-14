Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8375D1A8174
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440253AbgDNPIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:08:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38008 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2440246AbgDNPIP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVmBsaDsSfvVueNHLWF+zgmzDrIT4e0N1dQCR9+yJfQ=;
        b=L03Iokhf4dRUiSWw2H+JbIAlZEKfUlypzeNogDdfY9JXWk9BMBOO31TY50GEd8RC3ZWQYM
        8jlEjxfaFMKfLoDSt5KbF1SazvNI1ipqkP9hbJOCpswBijv7mvyQ+61wOkX86Pp2u5V1aO
        E9woT03sXItFztQ0wsMBkS/fkCV3JI0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-g9_8KBY_OaC2kXKGLGhPcw-1; Tue, 14 Apr 2020 11:08:07 -0400
X-MC-Unique: g9_8KBY_OaC2kXKGLGhPcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56ACC10CE782;
        Tue, 14 Apr 2020 15:08:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3C61271A3;
        Tue, 14 Apr 2020 15:08:00 +0000 (UTC)
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
Subject: [PATCH v11 12/13] iommu/smmuv3: Implement bind/unbind_guest_msi
Date:   Tue, 14 Apr 2020 17:06:06 +0200
Message-Id: <20200414150607.28488-13-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index f4c793649152..253f96e97c11 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3377,6 +3377,47 @@ static void arm_smmu_get_resv_regions(struct devic=
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
@@ -3546,6 +3587,8 @@ static struct iommu_ops arm_smmu_ops =3D {
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

