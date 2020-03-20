Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC22618D3D4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCTQLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:39 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21815 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727677AbgCTQLh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TnDoNnd4YsR8NC/JFy6W/OCirBwOrncQkzNJmNWOGZw=;
        b=cJzqgELp/nj7f6jvhuPLqt2KxUGhoJNCtFytuuvHzn6OMB9+f1e7b93jV6ad+tXpjWP6m8
        PSI/Skads8cLjqG7tmEnEPG2r5/zo8lGvYUz0LOklAhMuFczalYDxsI0pm94r7PNukDWKl
        t4gXM5LP/48hllUnfwEEuz4vNBV/usU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-hoqmHRsnMiCwN9mQx_aLrw-1; Fri, 20 Mar 2020 12:11:32 -0400
X-MC-Unique: hoqmHRsnMiCwN9mQx_aLrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 229D71137850;
        Fri, 20 Mar 2020 16:11:14 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D1095C1D8;
        Fri, 20 Mar 2020 16:11:10 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 11/13] iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI regions
Date:   Fri, 20 Mar 2020 17:09:30 +0100
Message-Id: <20200320160932.27222-12-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 84dce0b2e935..106f9c563823 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2921,6 +2921,23 @@ static bool arm_smmu_share_msi_domain(struct iommu=
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
@@ -2965,10 +2982,12 @@ static int arm_smmu_attach_dev(struct iommu_domai=
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

