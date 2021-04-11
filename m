Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6235B3BF
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbhDKLs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235500AbhDKLsO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618141678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u665zyHb8R/1cgOuxHP4CZUV9j1MYsGphNKOHq8bOZo=;
        b=cj1WEba8/OX350keOBautSmnsDXFODi9jNsaNJtBKMo+OxXburt7mr95NNSIMH8GleoUsR
        JafvWkX7yAW5SzJZFPag98vUhat1i3Y0HHsDSuS6FKjkRx22EwAqjTNhnGvxvZLf5IQbuZ
        pGWXLH0rH/ONedRPmEIJHSbebuHzDdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-LzWVkregOVSQHGvkOaCxnA-1; Sun, 11 Apr 2021 07:47:54 -0400
X-MC-Unique: LzWVkregOVSQHGvkOaCxnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FBAC5B364;
        Sun, 11 Apr 2021 11:47:51 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13C1E5C3E4;
        Sun, 11 Apr 2021 11:47:43 +0000 (UTC)
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
Subject: [PATCH v13 03/13] vfio: VFIO_IOMMU_SET_MSI_BINDING
Date:   Sun, 11 Apr 2021 13:46:49 +0200
Message-Id: <20210411114659.15051-4-eric.auger@redhat.com>
In-Reply-To: <20210411114659.15051-1-eric.auger@redhat.com>
References: <20210411114659.15051-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the VFIO_IOMMU_SET_MSI_BINDING ioctl which aim
to (un)register the guest MSI binding to the host. This latter
then can use those stage 1 bindings to build a nested stage
binding targeting the physical MSIs.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v11 -> v12:
- Share VFIO_BASE + 20 with VFIO_IOMMU_SPAPR_TCE_REMOVE
- rework returned values

v10 -> v11:
- renamed ustruct into msi_binding
- return 0 on unbind

v8 -> v9:
- merge VFIO_IOMMU_BIND_MSI/VFIO_IOMMU_UNBIND_MSI into a single
  VFIO_IOMMU_SET_MSI_BINDING ioctl
- ioctl id changed

v6 -> v7:
- removed the dev arg

v3 -> v4:
- add UNBIND
- unwind on BIND error

v2 -> v3:
- adapt to new proto of bind_guest_msi
- directly use vfio_iommu_for_each_dev

v1 -> v2:
- s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
---
 drivers/vfio/vfio_iommu_type1.c | 62 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 20 +++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 34f8dca36ebe..5e9196ec9685 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2902,6 +2902,41 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
 	return iommu_uapi_cache_invalidate(dc->domain, dev, (void __user *)arg);
 }
 
+static int
+vfio_bind_msi(struct vfio_iommu *iommu,
+	      dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_bind_guest_msi(d->domain, giova, gpa, size);
+		if (ret)
+			goto unwind;
+	}
+	goto unlock;
+unwind:
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
+		iommu_unbind_guest_msi(d->domain, giova);
+	}
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static void
+vfio_unbind_msi(struct vfio_iommu *iommu, dma_addr_t giova)
+{
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next)
+		iommu_unbind_guest_msi(d->domain, giova);
+	mutex_unlock(&iommu->lock);
+}
+
 static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
 					   struct vfio_info_cap *caps)
 {
@@ -3114,6 +3149,31 @@ static int vfio_iommu_type1_cache_invalidate(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_type1_set_msi_binding(struct vfio_iommu *iommu,
+					    unsigned long arg)
+{
+	struct vfio_iommu_type1_set_msi_binding msi_binding;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_iommu_type1_set_msi_binding,
+			    size);
+
+	if (copy_from_user(&msi_binding, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (msi_binding.argsz < minsz)
+		return -EINVAL;
+
+	if (msi_binding.flags == VFIO_IOMMU_UNBIND_MSI) {
+		vfio_unbind_msi(iommu, msi_binding.iova);
+		return 0;
+	} else if (msi_binding.flags == VFIO_IOMMU_BIND_MSI) {
+		return vfio_bind_msi(iommu, msi_binding.iova,
+				     msi_binding.gpa, msi_binding.size);
+	}
+	return -EINVAL;
+}
+
 static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 					unsigned long arg)
 {
@@ -3238,6 +3298,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_set_pasid_table(iommu, arg);
 	case VFIO_IOMMU_CACHE_INVALIDATE:
 		return vfio_iommu_type1_cache_invalidate(iommu, arg);
+	case VFIO_IOMMU_SET_MSI_BINDING:
+		return vfio_iommu_type1_set_msi_binding(iommu, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ada42121827a..afa8596c05d2 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1241,6 +1241,26 @@ struct vfio_iommu_type1_cache_invalidate {
 };
 #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 19)
 
+/**
+ * VFIO_IOMMU_SET_MSI_BINDING - _IOWR(VFIO_TYPE, VFIO_BASE + 20,
+ *			struct vfio_iommu_type1_set_msi_binding)
+ *
+ * Pass a stage 1 MSI doorbell mapping to the host so that this
+ * latter can build a nested stage2 mapping. Or conversely tear
+ * down a previously bound stage 1 MSI binding.
+ */
+struct vfio_iommu_type1_set_msi_binding {
+	__u32   argsz;
+	__u32   flags;
+#define VFIO_IOMMU_BIND_MSI	(1 << 0)
+#define VFIO_IOMMU_UNBIND_MSI	(1 << 1)
+	__u64	iova;	/* MSI guest IOVA */
+	/* Fields below are used on BIND */
+	__u64	gpa;	/* MSI guest physical address */
+	__u64	size;	/* size of stage1 mapping (bytes) */
+};
+#define VFIO_IOMMU_SET_MSI_BINDING      _IO(VFIO_TYPE, VFIO_BASE + 20)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.26.3

