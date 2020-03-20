Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC718D3D3
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgCTQLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30640 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727672AbgCTQLh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A6IbVHowGVmCEtJxEyB0XyhD6b7mHixP1jCoZdykCEQ=;
        b=TCgfcLNpFcKCrNCO5g3Mvi1wPof0VjmTw2kIKjV3toZpTL1XjDkHh5qBCTu8LZ6Zwe6Uec
        dEZMROlpPqPVKsgEdJC08++tBqgZLHEEJTn4ZIJCouTniutsRV+U/bkYlytEvkeRvcW0NA
        kkd8aKFJv8IQrri9BRHGaE1DVCk7gPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-rLwQWradNPqRmW3o5iE7BA-1; Fri, 20 Mar 2020 12:11:32 -0400
X-MC-Unique: rLwQWradNPqRmW3o5iE7BA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C589801FC5;
        Fri, 20 Mar 2020 16:11:10 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66345C1D8;
        Fri, 20 Mar 2020 16:11:03 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 10/13] iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
Date:   Fri, 20 Mar 2020 17:09:29 +0100
Message-Id: <20200320160932.27222-11-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In nested mode we enforce the rule that all devices belonging
to the same iommu_domain share the same msi_domain.

Indeed if there were several physical MSI doorbells being used
within a single iommu_domain, it becomes really difficult to
resolve the nested stage mapping translating into the correct
physical doorbell. So let's forbid this situation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 41 +++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 538e368c2e13..84dce0b2e935 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2890,6 +2890,37 @@ static void arm_smmu_detach_dev(struct arm_smmu_ma=
ster *master)
 	arm_smmu_install_ste_for_dev(master);
 }
=20
+static bool arm_smmu_share_msi_domain(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
+	struct irq_domain *irqd =3D dev_get_msi_domain(dev);
+	struct arm_smmu_master *master;
+	unsigned long flags;
+	bool share =3D false;
+
+	if (!irqd)
+		return true;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct irq_domain *d =3D dev_get_msi_domain(master->dev);
+
+		if (!d)
+			continue;
+		if (irqd !=3D d) {
+			dev_info(dev, "Nested mode forbids to attach devices "
+				 "using different physical MSI doorbells "
+				 "to the same iommu_domain");
+			goto unlock;
+		}
+	}
+	share =3D true;
+unlock:
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	return share;
+}
+
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct devic=
e *dev)
 {
 	int ret =3D 0;
@@ -2931,6 +2962,16 @@ static int arm_smmu_attach_dev(struct iommu_domain=
 *domain, struct device *dev)
 		ret =3D -EINVAL;
 		goto out_unlock;
 	}
+	/*
+	 * In nested mode we must check all devices belonging to the
+	 * domain share the same physical MSI doorbell. Otherwise nested
+	 * stage MSI binding is not supported.
+	 */
+	if (smmu_domain->stage =3D=3D ARM_SMMU_DOMAIN_NESTED &&
+		!arm_smmu_share_msi_domain(domain, dev)) {
+		ret =3D -EINVAL;
+		goto out_unlock;
+	}
=20
 	master->domain =3D smmu_domain;
=20
--=20
2.20.1

