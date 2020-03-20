Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4F118D418
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgCTQUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:20:02 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:36229 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727317AbgCTQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqrZ5PAivz8D0DNnQlULxvOl6hsl7punh73vFXG+XJQ=;
        b=bfFZOk7BWsH8CzDW6/gEQOVASUkV0gLxA3wLtnT2DiIvecDeaHsHzwieorgDOOpXMh2N8g
        KWlESlBlJ8M9UrXJtb3XsnEDPwNNY0sfXLgK5SvTqvMAlYPrKFr+j1yraiWisR/YZ7CuBb
        kHiplQA8NSc5btlUG7hZUclSOyf9pao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-HCiK2-sHOu2SSnIYOI-GIg-1; Fri, 20 Mar 2020 12:19:56 -0400
X-MC-Unique: HCiK2-sHOu2SSnIYOI-GIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42559149C1;
        Fri, 20 Mar 2020 16:19:32 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91F1760BFB;
        Fri, 20 Mar 2020 16:19:25 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
Date:   Fri, 20 Mar 2020 17:19:01 +0100
Message-Id: <20200320161911.27494-2-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Liu, Yi L" <yi.l.liu@linux.intel.com>

This patch adds an VFIO_IOMMU_SET_PASID_TABLE ioctl
which aims to pass the virtual iommu guest configuration
to the host. This latter takes the form of the so-called
PASID table.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v8 -> v9:
- Merge VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE into a single
  VFIO_IOMMU_SET_PASID_TABLE ioctl.

v6 -> v7:
- add a comment related to VFIO_IOMMU_DETACH_PASID_TABLE

v3 -> v4:
- restore ATTACH/DETACH
- add unwind on failure

v2 -> v3:
- s/BIND_PASID_TABLE/SET_PASID_TABLE

v1 -> v2:
- s/BIND_GUEST_STAGE/BIND_PASID_TABLE
- remove the struct device arg
---
 drivers/vfio/vfio_iommu_type1.c | 56 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 19 +++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
index a177bf2c6683..bfacbd876ee1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2172,6 +2172,43 @@ static int vfio_iommu_iova_build_caps(struct vfio_=
iommu *iommu,
 	return ret;
 }
=20
+static void
+vfio_detach_pasid_table(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		iommu_detach_pasid_table(d->domain);
+	}
+	mutex_unlock(&iommu->lock);
+}
+
+static int
+vfio_attach_pasid_table(struct vfio_iommu *iommu,
+			struct vfio_iommu_type1_set_pasid_table *ustruct)
+{
+	struct vfio_domain *d;
+	int ret =3D 0;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret =3D iommu_attach_pasid_table(d->domain, &ustruct->config);
+		if (ret)
+			goto unwind;
+	}
+	goto unlock;
+unwind:
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
+		iommu_detach_pasid_table(d->domain);
+	}
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -2276,6 +2313,25 @@ static long vfio_iommu_type1_ioctl(void *iommu_dat=
a,
=20
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd =3D=3D VFIO_IOMMU_SET_PASID_TABLE) {
+		struct vfio_iommu_type1_set_pasid_table ustruct;
+
+		minsz =3D offsetofend(struct vfio_iommu_type1_set_pasid_table,
+				    config);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz)
+			return -EINVAL;
+
+		if (ustruct.flags & VFIO_PASID_TABLE_FLAG_SET)
+			return vfio_attach_pasid_table(iommu, &ustruct);
+		else if (ustruct.flags & VFIO_PASID_TABLE_FLAG_UNSET) {
+			vfio_detach_pasid_table(iommu);
+			return 0;
+		} else
+			return -EINVAL;
 	}
=20
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..e032a1fe6ed9 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
=20
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
=20
 #define VFIO_API_VERSION	0
=20
@@ -794,6 +795,24 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
=20
+/**
+ * VFIO_IOMMU_SET_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
+ *			struct vfio_iommu_type1_set_pasid_table)
+ *
+ * The SET operation passes a PASID table to the host while the
+ * UNSET operation detaches the one currently programmed. Setting
+ * a table while another is already programmed replaces the old table.
+ */
+struct vfio_iommu_type1_set_pasid_table {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_PASID_TABLE_FLAG_SET	(1 << 0)
+#define VFIO_PASID_TABLE_FLAG_UNSET	(1 << 1)
+	struct iommu_pasid_table_config config; /* used on SET */
+};
+
+#define VFIO_IOMMU_SET_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU --------=
 */
=20
 /*
--=20
2.20.1

