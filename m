Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09E818D3B7
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCTQK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:10:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25839 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbgCTQK6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qNA5aYoFFTWk4slxWzSfvQ1Qh90A3U7K6OR2so8J14k=;
        b=S6tLtswteMFO9qZ78bufscPaL09IEAKfpwsenGEDJgs4X91omQfMvSn+08tRloIHfXfbxX
        GF2DSsXxNgwQYaED6JAD4zud6rHNOyAFguMawXu3qu52RI16t0W7wtzWcOHtXdGB0xEnos
        6dxq11qxTnGrsIoTPGtEKVtkGGuqRMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-ngq5oKnmNhGtGl3qU7nq9Q-1; Fri, 20 Mar 2020 12:10:54 -0400
X-MC-Unique: ngq5oKnmNhGtGl3qU7nq9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 164C81083E91;
        Fri, 20 Mar 2020 16:10:45 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C3165F700;
        Fri, 20 Mar 2020 16:10:21 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 06/13] iommu/smmuv3: Implement attach/detach_pasid_table
Date:   Fri, 20 Mar 2020 17:09:25 +0100
Message-Id: <20200320160932.27222-7-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On attach_pasid_table() we program STE S1 related info set
by the guest into the actual physical STEs. At minimum
we need to program the context descriptor GPA and compute
whether the stage1 is translated/bypassed or aborted.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v7 -> v8:
- remove smmu->features check, now done on domain finalize

v6 -> v7:
- check versions and comment the fact we don't need to take
  into account s1dss and s1fmt
v3 -> v4:
- adapt to changes in iommu_pasid_table_config
- different programming convention at s1_cfg/s2_cfg/ste.abort

v2 -> v3:
- callback now is named set_pasid_table and struct fields
  are laid out differently.

v1 -> v2:
- invalidate the STE before changing them
- hold init_mutex
- handle new fields
---
 drivers/iommu/arm-smmu-v3.c | 98 +++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 7d00244fe725..92a1a5ac5b50 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3287,6 +3287,102 @@ static void arm_smmu_get_resv_regions(struct devi=
ce *dev,
 	iommu_dma_get_resv_regions(dev, head);
 }
=20
+static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
+				       struct iommu_pasid_table_config *cfg)
+{
+	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
+	struct arm_smmu_master *master;
+	struct arm_smmu_device *smmu;
+	unsigned long flags;
+	int ret =3D -EINVAL;
+
+	if (cfg->format !=3D IOMMU_PASID_FORMAT_SMMUV3)
+		return -EINVAL;
+
+	if (cfg->version !=3D PASID_TABLE_CFG_VERSION_1 ||
+	    cfg->smmuv3.version !=3D PASID_TABLE_SMMUV3_CFG_VERSION_1)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+
+	smmu =3D smmu_domain->smmu;
+
+	if (!smmu)
+		goto out;
+
+	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
+		goto out;
+
+	switch (cfg->config) {
+	case IOMMU_PASID_CONFIG_ABORT:
+		kfree(smmu_domain->s1_cfg);
+		smmu_domain->s1_cfg =3D NULL;
+		smmu_domain->abort =3D true;
+		break;
+	case IOMMU_PASID_CONFIG_BYPASS:
+		kfree(smmu_domain->s1_cfg);
+		smmu_domain->s1_cfg =3D NULL;
+		smmu_domain->abort =3D false;
+		break;
+	case IOMMU_PASID_CONFIG_TRANSLATE:
+		/* we do not support S1 <-> S1 transitions */
+		if (smmu_domain->s1_cfg)
+			goto out;
+
+		/*
+		 * we currently support a single CD so s1fmt and s1dss
+		 * fields are also ignored
+		 */
+		if (cfg->pasid_bits)
+			goto out;
+
+		smmu_domain->s1_cfg =3D kzalloc(sizeof(*smmu_domain->s1_cfg),
+					      GFP_KERNEL);
+		if (!smmu_domain->s1_cfg) {
+			ret =3D -ENOMEM;
+			goto out;
+		}
+
+		smmu_domain->s1_cfg->cdcfg.cdtab_dma =3D cfg->base_ptr;
+		smmu_domain->abort =3D false;
+		break;
+	default:
+		goto out;
+	}
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head)
+		arm_smmu_install_ste_for_dev(master);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret =3D 0;
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
+static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain =3D to_smmu_domain(domain);
+	struct arm_smmu_master *master;
+	unsigned long flags;
+
+	mutex_lock(&smmu_domain->init_mutex);
+
+	if (smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
+		goto unlock;
+
+	kfree(smmu_domain->s1_cfg);
+	smmu_domain->s1_cfg =3D NULL;
+	smmu_domain->abort =3D true;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head)
+		arm_smmu_install_ste_for_dev(master);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+unlock:
+	mutex_unlock(&smmu_domain->init_mutex);
+}
+
 static struct iommu_ops arm_smmu_ops =3D {
 	.capable		=3D arm_smmu_capable,
 	.domain_alloc		=3D arm_smmu_domain_alloc,
@@ -3305,6 +3401,8 @@ static struct iommu_ops arm_smmu_ops =3D {
 	.of_xlate		=3D arm_smmu_of_xlate,
 	.get_resv_regions	=3D arm_smmu_get_resv_regions,
 	.put_resv_regions	=3D generic_iommu_put_resv_regions,
+	.attach_pasid_table	=3D arm_smmu_attach_pasid_table,
+	.detach_pasid_table	=3D arm_smmu_detach_pasid_table,
 	.pgsize_bitmap		=3D -1UL, /* Restricted during device attach */
 };
=20
--=20
2.20.1

