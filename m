Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD3A1A8193
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436822AbgDNPIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:08:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35146 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440240AbgDNPIH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 11:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C8QBtK6nf8dMq00mzJuRC3wnQo9tCeCO/0M31V5xp/s=;
        b=RQ0+dCxHObuPntbGT4RFXDFQP977UaTa/RWm3oBFe8dR4EiWxIhlMb+TZpFYB2DF30qlvS
        8L53XbHfC3gtL2L0gmHUX96bRyNxA1WIK25DyyH7Chy1DlrNWAcqTVzVA2GLFUYck9Jp/o
        TrBBsaQAvLk8+3W+uwJYj2CDPhd9Ck0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-VlwdYdX3OMyCDijdDEu_Xg-1; Tue, 14 Apr 2020 11:08:03 -0400
X-MC-Unique: VlwdYdX3OMyCDijdDEu_Xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D79413F8;
        Tue, 14 Apr 2020 15:08:00 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54E8819C69;
        Tue, 14 Apr 2020 15:07:50 +0000 (UTC)
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
Subject: [PATCH v11 11/13] iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI regions
Date:   Tue, 14 Apr 2020 17:06:05 +0200
Message-Id: <20200414150607.28488-12-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested mode currently is not compatible with HW MSI reserved regions.
Indeed MSI transactions targeting this MSI doorbells bypass the SMMU.

Let's check nested mode is not attempted in such configuration.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index f157d1de614b..f4c793649152 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2927,6 +2927,23 @@ static bool arm_smmu_share_msi_domain(struct iommu=
_domain *domain,
 	return share;
 }
=20
+static bool arm_smmu_has_hw_msi_resv_region(struct device *dev)
+{
+	struct iommu_resv_region *region;
+	bool has_msi_resv_region =3D false;
+	LIST_HEAD(resv_regions);
+
+	iommu_get_resv_regions(dev, &resv_regions);
+	list_for_each_entry(region, &resv_regions, list) {
+		if (region->type =3D=3D IOMMU_RESV_MSI) {
+			has_msi_resv_region =3D true;
+			break;
+		}
+	}
+	iommu_put_resv_regions(dev, &resv_regions);
+	return has_msi_resv_region;
+}
+
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct devic=
e *dev)
 {
 	int ret =3D 0;
@@ -2971,10 +2988,12 @@ static int arm_smmu_attach_dev(struct iommu_domai=
n *domain, struct device *dev)
 	/*
 	 * In nested mode we must check all devices belonging to the
 	 * domain share the same physical MSI doorbell. Otherwise nested
-	 * stage MSI binding is not supported.
+	 * stage MSI binding is not supported. Also nested mode is not
+	 * compatible with MSI HW reserved regions.
 	 */
 	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_NESTED &&
-		!arm_smmu_share_msi_domain(domain, dev)) {
+		(!arm_smmu_share_msi_domain(domain, dev) ||
+		 arm_smmu_has_hw_msi_resv_region(dev))) {
 		ret =3D -EINVAL;
 		goto out_unlock;
 	}
--=20
2.20.1

