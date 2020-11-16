Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96A2B41FF
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgKPLBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:01:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729336AbgKPLBR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:01:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7lo2lYoAPKx166e8FDAELCUynrzAsSs9VOq9Avb3elM=;
        b=DzsCv2jdqqRDEGYiXt4CIPrFL2dB1xwbGM0o4Hm+C0I8QnbEEqbcvsSjbA/Y0mtRvu5txW
        V7P6gaMer1+kPBXHi+lGaU1QJmQkmqbqalVNRpFwvWNHV/IVECPUJih9PFX1MBZC05Vv7y
        AoefxechgE38pRHD+04ZaTtSHYBH7NI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-NF-t1dixNImr7szZc-GQUQ-1; Mon, 16 Nov 2020 06:01:12 -0500
X-MC-Unique: NF-t1dixNImr7szZc-GQUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7551F19080A4;
        Mon, 16 Nov 2020 11:01:09 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA7CA5C5AF;
        Mon, 16 Nov 2020 11:00:57 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v11 03/13] vfio: VFIO_IOMMU_SET_MSI_BINDING
Date:   Mon, 16 Nov 2020 12:00:20 +0100
Message-Id: <20201116110030.32335-4-eric.auger@redhat.com>
In-Reply-To: <20201116110030.32335-1-eric.auger@redhat.com>
References: <20201116110030.32335-1-eric.auger@redhat.com>
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
 drivers/vfio/vfio_iommu_type1.c | 63 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 20 +++++++++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 966909f542f1..bb2bc0971fb0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2657,6 +2657,41 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
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
@@ -2866,6 +2901,32 @@ static int vfio_iommu_type1_cache_invalidate(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_iommu_type1_set_msi_binding(struct vfio_iommu *iommu,
+					    unsigned long arg)
+{
+	struct vfio_iommu_type1_set_msi_binding msi_binding;
+	unsigned long minsz;
+	int ret = -EINVAL;
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
+		ret = 0;
+	} else if (msi_binding.flags == VFIO_IOMMU_BIND_MSI) {
+		ret = vfio_bind_msi(iommu, msi_binding.iova,
+				    msi_binding.gpa, msi_binding.size);
+	}
+	return ret;
+}
+
 static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 					unsigned long arg)
 {
@@ -2990,6 +3051,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 		return vfio_iommu_type1_set_pasid_table(iommu, arg);
 	case VFIO_IOMMU_CACHE_INVALIDATE:
 		return vfio_iommu_type1_cache_invalidate(iommu, arg);
+	case VFIO_IOMMU_SET_MSI_BINDING:
+		return vfio_iommu_type1_set_msi_binding(iommu, arg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0e6d94cc2ba4..b352e76cfb71 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1212,6 +1212,26 @@ struct vfio_iommu_type1_cache_invalidate {
 };
 #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 23)
 
+/**
+ * VFIO_IOMMU_SET_MSI_BINDING - _IOWR(VFIO_TYPE, VFIO_BASE + 24,
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
+#define VFIO_IOMMU_SET_MSI_BINDING      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.21.3

