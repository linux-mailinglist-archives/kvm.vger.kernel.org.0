Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C835B3BB
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhDKLrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235454AbhDKLrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618141656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ncaKM2D4VbRpP8QaQTDX37Dv3EM1uMD4gpHykSCe9dw=;
        b=ZnAgOBqZqWWgFN43u72uHMDFef14YZZOpXrEhNqk/kv+93YORupC3ZaKeAQiONfupPJATc
        cEhUI1jIS+KkWX4+5FlvMVI/cxowxg+MbAisYv1DNJQNm/Ujff8x5EYx6Pg/wrsrhhePr5
        kzPEcA/ZtVTGlht48t4BxC3IArAIRH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-dlY1Ds1dNK-qKmJ5PECF5Q-1; Sun, 11 Apr 2021 07:47:32 -0400
X-MC-Unique: dlY1Ds1dNK-qKmJ5PECF5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 748C0107ACC7;
        Sun, 11 Apr 2021 11:47:29 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E59885C3E4;
        Sun, 11 Apr 2021 11:47:20 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        vivek.gautam@arm.com, shameerali.kolothum.thodi@huawei.com,
        yuzenghui@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com,
        chenxiang66@hisilicon.com, vdumpa@nvidia.com,
        jiangkunkun@huawei.com
Subject: [PATCH v13 01/13] vfio: VFIO_IOMMU_SET_PASID_TABLE
Date:   Sun, 11 Apr 2021 13:46:47 +0200
Message-Id: <20210411114659.15051-2-eric.auger@redhat.com>
In-Reply-To: <20210411114659.15051-1-eric.auger@redhat.com>
References: <20210411114659.15051-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
v12 -> v13:
- reword the misleading doc comment of  VFIO_IOMMU_SET_PASID_TABLE

v11 -> v12:
- use iommu_uapi_set_pasid_table
- Rework the flags checks [Zenghui, Alex]
- use VFIO_BASE + 19 [Alex]
- rework the unwind in vfio_attach_pasid_table() [Alex]

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
 drivers/vfio/vfio_iommu_type1.c | 58 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 20 ++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 45cbfd4879a5..e575ef5dd6c6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2834,6 +2834,39 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static void
+vfio_detach_pasid_table(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next)
+		iommu_detach_pasid_table(d->domain);
+
+	mutex_unlock(&iommu->lock);
+}
+
+static int
+vfio_attach_pasid_table(struct vfio_iommu *iommu, unsigned long arg)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_uapi_attach_pasid_table(d->domain, (void __user *)arg);
+		if (ret) {
+			list_for_each_entry_continue_reverse(d, &iommu->domain_list, next)
+				iommu_detach_pasid_table(d->domain);
+			break;
+		}
+	}
+
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
 					   struct vfio_info_cap *caps)
 {
@@ -3002,6 +3035,29 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 			-EFAULT : 0;
 }
 
+static int vfio_iommu_type1_set_pasid_table(struct vfio_iommu *iommu,
+					    unsigned long arg)
+{
+	struct vfio_iommu_type1_set_pasid_table spt;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table, flags);
+
+	if (copy_from_user(&spt, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (spt.argsz < minsz)
+		return -EINVAL;
+
+	if (spt.flags == VFIO_PASID_TABLE_FLAG_SET) {
+		return vfio_attach_pasid_table(iommu, arg + minsz);
+	} else if (spt.flags == VFIO_PASID_TABLE_FLAG_UNSET) {
+		vfio_detach_pasid_table(iommu);
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 					unsigned long arg)
 {
@@ -3122,6 +3178,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_unmap_dma(iommu, arg);
 	case VFIO_IOMMU_DIRTY_PAGES:
 		return vfio_iommu_type1_dirty_pages(iommu, arg);
+	case VFIO_IOMMU_SET_PASID_TABLE:
+		return vfio_iommu_type1_set_pasid_table(iommu, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8ce36c1d53ca..c86b7b4a5064 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -1208,6 +1209,25 @@ struct vfio_iommu_type1_dirty_bitmap_get {
 
 #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/*
+ * VFIO_IOMMU_SET_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
+ *			struct vfio_iommu_type1_set_pasid_table)
+ *
+ * The SET operation passes a PASID table to the host while the
+ * UNSET operation detaches the one currently programmed. It is
+ * allowed to "SET" the table several times without unsetting as
+ * long as the table config does not stay IOMMU_PASID_CONFIG_TRANSLATE.
+ */
+struct vfio_iommu_type1_set_pasid_table {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_PASID_TABLE_FLAG_SET	(1 << 0)
+#define VFIO_PASID_TABLE_FLAG_UNSET	(1 << 1)
+	struct iommu_pasid_table_config config; /* used on SET */
+};
+
+#define VFIO_IOMMU_SET_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.26.3

