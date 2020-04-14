Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8D1A816C
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440235AbgDNPIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:08:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59262 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2440228AbgDNPH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 11:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lr2hx0ovKzPSgkmlzTqsTyKLkb7WnJkFJ806uC26PBw=;
        b=APyb7RCUWPJdtmWi91nak15tOZUiO1aeVLV0DO52/+n+XzyDzqZ+3IaAySAeWE6dScP8RC
        volbI5B8sW314AxckHZjPjZqWXvv1HfAekEo3+8+aDa8lIKgxCNGLZYRDQol48o4Dn9F8M
        BEMUa8ojq1KhcW7ogXOgG/ckMrCKrhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-S082tG5SNXeKg2DlYw57vw-1; Tue, 14 Apr 2020 11:07:52 -0400
X-MC-Unique: S082tG5SNXeKg2DlYw57vw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F12091005509;
        Tue, 14 Apr 2020 15:07:49 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B15719C69;
        Tue, 14 Apr 2020 15:07:45 +0000 (UTC)
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
Subject: [PATCH v11 10/13] iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
Date:   Tue, 14 Apr 2020 17:06:04 +0200
Message-Id: <20200414150607.28488-11-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
index 38854c3e4083..f157d1de614b 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2896,6 +2896,37 @@ static void arm_smmu_detach_dev(struct arm_smmu_ma=
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
@@ -2937,6 +2968,16 @@ static int arm_smmu_attach_dev(struct iommu_domain=
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

