Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348A743C7E2
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbhJ0Krc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:47:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241507AbhJ0Kr2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635331502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dsTW88JLxmgtPXVjSysbobchSF9Z8lO6SXfy0oNtT3s=;
        b=cCVVbAVJRbTounO52FfqsmKjVShy41xLOjfuRkD8V+kos2M6MoIOwYdSZiTzFZEjw6Bkux
        jowqfHgoffGPRIQLCbJ3RN/eUKPoRpkPCsjZ0E3g6UVhRNrkFC/rvrqS5U6W9eWLiiD72q
        ixDSzVwOSYlDlCNOFdIGCaV80WJkwoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-SwsB4E-xMYmszDiSO5eE_A-1; Wed, 27 Oct 2021 06:44:59 -0400
X-MC-Unique: SwsB4E-xMYmszDiSO5eE_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2C7610A8E00;
        Wed, 27 Oct 2021 10:44:55 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 216A0100238C;
        Wed, 27 Oct 2021 10:44:48 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
        zhukeqian1@huawei.com
Cc:     alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, kevin.tian@intel.com, ashok.raj@intel.com,
        maz@kernel.org, peter.maydell@linaro.org, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, wangxingang5@huawei.com,
        jiangkunkun@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, chenxiang66@hisilicon.com,
        sumitg@nvidia.com, nicolinc@nvidia.com, vdumpa@nvidia.com,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com
Subject: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Date:   Wed, 27 Oct 2021 12:44:20 +0200
Message-Id: <20211027104428.1059740-2-eric.auger@redhat.com>
In-Reply-To: <20211027104428.1059740-1-eric.auger@redhat.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In virtualization use case, when a guest is assigned
a PCI host device, protected by a virtual IOMMU on the guest,
the physical IOMMU must be programmed to be consistent with
the guest mappings. If the physical IOMMU supports two
translation stages it makes sense to program guest mappings
onto the first stage/level (ARM/Intel terminology) while the host
owns the stage/level 2.

In that case, it is mandated to trap on guest configuration
settings and pass those to the physical iommu driver.

This patch adds a new API to the iommu subsystem that allows
to set/unset the pasid table information.

A generic iommu_pasid_table_config struct is introduced in
a new iommu.h uapi header. This is going to be used by the VFIO
user API.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v13 -> v14:
- export iommu_attach_pasid_table
- add dummy iommu_uapi_attach_pasid_table
- swap base_ptr and format in iommu_pasid_table_config

v12 -> v13:
- Fix config check

v11 -> v12:
- add argsz, name the union
---
 drivers/iommu/iommu.c      | 69 ++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h      | 27 +++++++++++++++
 include/uapi/linux/iommu.h | 54 +++++++++++++++++++++++++++++
 3 files changed, 150 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3303d707bab4..6033c263c6e6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2236,6 +2236,75 @@ int iommu_uapi_sva_unbind_gpasid(struct iommu_domain *domain, struct device *dev
 }
 EXPORT_SYMBOL_GPL(iommu_uapi_sva_unbind_gpasid);
 
+int iommu_attach_pasid_table(struct iommu_domain *domain,
+			     struct iommu_pasid_table_config *cfg)
+{
+	if (unlikely(!domain->ops->attach_pasid_table))
+		return -ENODEV;
+
+	return domain->ops->attach_pasid_table(domain, cfg);
+}
+EXPORT_SYMBOL_GPL(iommu_attach_pasid_table);
+
+int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
+				  void __user *uinfo)
+{
+	struct iommu_pasid_table_config pasid_table_data = { 0 };
+	u32 minsz;
+
+	if (unlikely(!domain->ops->attach_pasid_table))
+		return -ENODEV;
+
+	/*
+	 * No new spaces can be added before the variable sized union, the
+	 * minimum size is the offset to the union.
+	 */
+	minsz = offsetof(struct iommu_pasid_table_config, vendor_data);
+
+	/* Copy minsz from user to get flags and argsz */
+	if (copy_from_user(&pasid_table_data, uinfo, minsz))
+		return -EFAULT;
+
+	/* Fields before the variable size union are mandatory */
+	if (pasid_table_data.argsz < minsz)
+		return -EINVAL;
+
+	/* PASID and address granu require additional info beyond minsz */
+	if (pasid_table_data.version != PASID_TABLE_CFG_VERSION_1)
+		return -EINVAL;
+	if (pasid_table_data.format == IOMMU_PASID_FORMAT_SMMUV3 &&
+	    pasid_table_data.argsz <
+		offsetofend(struct iommu_pasid_table_config, vendor_data.smmuv3))
+		return -EINVAL;
+
+	/*
+	 * User might be using a newer UAPI header which has a larger data
+	 * size, we shall support the existing flags within the current
+	 * size. Copy the remaining user data _after_ minsz but not more
+	 * than the current kernel supported size.
+	 */
+	if (copy_from_user((void *)&pasid_table_data + minsz, uinfo + minsz,
+			   min_t(u32, pasid_table_data.argsz, sizeof(pasid_table_data)) - minsz))
+		return -EFAULT;
+
+	/* Now the argsz is validated, check the content */
+	if (pasid_table_data.config < IOMMU_PASID_CONFIG_TRANSLATE ||
+	    pasid_table_data.config > IOMMU_PASID_CONFIG_ABORT)
+		return -EINVAL;
+
+	return domain->ops->attach_pasid_table(domain, &pasid_table_data);
+}
+EXPORT_SYMBOL_GPL(iommu_uapi_attach_pasid_table);
+
+void iommu_detach_pasid_table(struct iommu_domain *domain)
+{
+	if (unlikely(!domain->ops->detach_pasid_table))
+		return;
+
+	domain->ops->detach_pasid_table(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_detach_pasid_table);
+
 static void __iommu_detach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d2f3435e7d17..e34a1b1c805b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -232,6 +232,8 @@ struct iommu_iotlb_gather {
  * @cache_invalidate: invalidate translation caches
  * @sva_bind_gpasid: bind guest pasid and mm
  * @sva_unbind_gpasid: unbind guest pasid and mm
+ * @attach_pasid_table: attach a pasid table
+ * @detach_pasid_table: detach the pasid table
  * @def_domain_type: device default domain type, return value:
  *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
@@ -297,6 +299,9 @@ struct iommu_ops {
 				      void *drvdata);
 	void (*sva_unbind)(struct iommu_sva *handle);
 	u32 (*sva_get_pasid)(struct iommu_sva *handle);
+	int (*attach_pasid_table)(struct iommu_domain *domain,
+				  struct iommu_pasid_table_config *cfg);
+	void (*detach_pasid_table)(struct iommu_domain *domain);
 
 	int (*page_response)(struct device *dev,
 			     struct iommu_fault_event *evt,
@@ -430,6 +435,11 @@ extern int iommu_uapi_sva_unbind_gpasid(struct iommu_domain *domain,
 					struct device *dev, void __user *udata);
 extern int iommu_sva_unbind_gpasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t pasid);
+extern int iommu_attach_pasid_table(struct iommu_domain *domain,
+				    struct iommu_pasid_table_config *cfg);
+extern int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
+					 void __user *udata);
+extern void iommu_detach_pasid_table(struct iommu_domain *domain);
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
@@ -1035,6 +1045,23 @@ iommu_aux_get_pasid(struct iommu_domain *domain, struct device *dev)
 	return -ENODEV;
 }
 
+static inline
+int iommu_attach_pasid_table(struct iommu_domain *domain,
+			     struct iommu_pasid_table_config *cfg)
+{
+	return -ENODEV;
+}
+
+static inline
+int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
+				  void __user *uinfo)
+{
+	return -ENODEV;
+}
+
+static inline
+void iommu_detach_pasid_table(struct iommu_domain *domain) {}
+
 static inline struct iommu_sva *
 iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void *drvdata)
 {
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 59178fc229ca..8c079a78dfec 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -339,4 +339,58 @@ struct iommu_gpasid_bind_data {
 	} vendor;
 };
 
+/**
+ * struct iommu_pasid_smmuv3 - ARM SMMUv3 Stream Table Entry stage 1 related
+ *     information
+ * @version: API version of this structure
+ * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
+ *         or 2-level table)
+ * @s1dss: STE s1dss (specifies the behavior when @pasid_bits != 0
+ *         and no PASID is passed along with the incoming transaction)
+ * @padding: reserved for future use (should be zero)
+ *
+ * The PASID table is referred to as the Context Descriptor (CD) table on ARM
+ * SMMUv3. Please refer to the ARM SMMU 3.x spec (ARM IHI 0070A) for full
+ * details.
+ */
+struct iommu_pasid_smmuv3 {
+#define PASID_TABLE_SMMUV3_CFG_VERSION_1 1
+	__u32	version;
+	__u8	s1fmt;
+	__u8	s1dss;
+	__u8	padding[2];
+};
+
+/**
+ * struct iommu_pasid_table_config - PASID table data used to bind guest PASID
+ *     table to the host IOMMU
+ * @argsz: User filled size of this data
+ * @version: API version to prepare for future extensions
+ * @base_ptr: guest physical address of the PASID table
+ * @format: format of the PASID table
+ * @pasid_bits: number of PASID bits used in the PASID table
+ * @config: indicates whether the guest translation stage must
+ *          be translated, bypassed or aborted.
+ * @padding: reserved for future use (should be zero)
+ * @vendor_data.smmuv3: table information when @format is
+ * %IOMMU_PASID_FORMAT_SMMUV3
+ */
+struct iommu_pasid_table_config {
+	__u32	argsz;
+#define PASID_TABLE_CFG_VERSION_1 1
+	__u32	version;
+	__u64	base_ptr;
+#define IOMMU_PASID_FORMAT_SMMUV3	1
+	__u32	format;
+	__u8	pasid_bits;
+#define IOMMU_PASID_CONFIG_TRANSLATE	1
+#define IOMMU_PASID_CONFIG_BYPASS	2
+#define IOMMU_PASID_CONFIG_ABORT	3
+	__u8	config;
+	__u8    padding[2];
+	union {
+		struct iommu_pasid_smmuv3 smmuv3;
+	} vendor_data;
+};
+
 #endif /* _UAPI_IOMMU_H */
-- 
2.26.3

