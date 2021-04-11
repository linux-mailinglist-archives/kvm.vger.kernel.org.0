Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DD335B379
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhDKLOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:14:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235229AbhDKLOk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618139664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4nfTOAv1VAbr17wgYI1/lkjKc9UT659NiLgHzl0C0/s=;
        b=bdAmLjWZjBa6ZOSvUtaN+31Z2Sc/+MAXX1SHa3mN//nTcpFOUgGN3VCTjkYwXAe9eoYsBV
        /nJSCX6hRCcDw1LJNRiF15/d3Fl/xc9FGUOAA8MVXWd/K8EY140IsRHPLGMCeJOYDq8Wqd
        ZxIVG2xhCxT2LeTpUiTZ99U7vzefURk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-zxIpQfcYOQul3zCyiV_6iA-1; Sun, 11 Apr 2021 07:14:22 -0400
X-MC-Unique: zxIpQfcYOQul3zCyiV_6iA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75FBB802B4F;
        Sun, 11 Apr 2021 11:14:19 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3276D100164A;
        Sun, 11 Apr 2021 11:14:01 +0000 (UTC)
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
Subject: [PATCH v15 08/12] dma-iommu: Implement NESTED_MSI cookie
Date:   Sun, 11 Apr 2021 13:12:24 +0200
Message-Id: <20210411111228.14386-9-eric.auger@redhat.com>
In-Reply-To: <20210411111228.14386-1-eric.auger@redhat.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up to now, when the type was UNMANAGED, we used to
allocate IOVA pages within a reserved IOVA MSI range.

If both the host and the guest are exposed with SMMUs, each
would allocate an IOVA. The guest allocates an IOVA (gIOVA)
to map onto the guest MSI doorbell (gDB). The Host allocates
another IOVA (hIOVA) to map onto the physical doorbell (hDB).

So we end up with 2 unrelated mappings, at S1 and S2:
         S1             S2
gIOVA    ->     gDB
               hIOVA    ->    hDB

The PCI device would be programmed with hIOVA.
No stage 1 mapping would existing, causing the MSIs to fault.

iommu_dma_bind_guest_msi() allows to pass gIOVA/gDB
to the host so that gIOVA can be used by the host instead of
re-allocating a new hIOVA.

         S1           S2
gIOVA    ->    gDB    ->    hDB

this time, the PCI device can be programmed with the gIOVA MSI
doorbell which is correctly mapped through both stages.

Nested mode is not compatible with HW MSI regions as in that
case gDB and hDB should have a 1-1 mapping. This check will
be done when attaching each device to the IOMMU domain.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v14 -> v15:
Took into account Zenghui's comments
- remove duplicated mutex.h inclusion
- introduce iommu_dma_get_nested_msi_page(), take the spinlock there
- add a comment saying the msi_lock only is used in nested mode
- take the msi_lock in other places
- fix prot
- check the S1 granule is smaller than S2 one
- remove s2_unamp
- do not init msi_iova in nested mode

v10 -> v11:
- fix compilation if !CONFIG_IOMMU_DMA

v7 -> v8:
- correct iommu_dma_(un)bind_guest_msi when
  !CONFIG_IOMMU_DMA
- Mentioned nested mode is not compatible with HW MSI regions
  in commit message
- protect with msi_lock on unbind

v6 -> v7:
- removed device handle

v3 -> v4:
- change function names; add unregister
- protect with msi_lock

v2 -> v3:
- also store the device handle on S1 mapping registration.
  This garantees we associate the associated S2 mapping binds
  to the correct physical MSI controller.

v1 -> v2:
- unmap stage2 on put()
---
 drivers/iommu/dma-iommu.c | 180 +++++++++++++++++++++++++++++++++++++-
 include/linux/dma-iommu.h |  16 ++++
 2 files changed, 192 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index af765c813cc8..9d77c62208bd 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -29,12 +29,15 @@
 struct iommu_dma_msi_page {
 	struct list_head	list;
 	dma_addr_t		iova;
+	dma_addr_t		gpa;
 	phys_addr_t		phys;
+	size_t			s1_granule;
 };
 
 enum iommu_dma_cookie_type {
 	IOMMU_DMA_IOVA_COOKIE,
 	IOMMU_DMA_MSI_COOKIE,
+	IOMMU_DMA_NESTED_MSI_COOKIE,
 };
 
 struct iommu_dma_cookie {
@@ -46,6 +49,8 @@ struct iommu_dma_cookie {
 		dma_addr_t		msi_iova;
 	};
 	struct list_head		msi_page_list;
+	/* used in nested mode only */
+	spinlock_t			msi_lock;
 
 	/* Domain for flush queue callback; NULL if flush queue not in use */
 	struct iommu_domain		*fq_domain;
@@ -87,6 +92,7 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu_dma_cookie_type type)
 
 	cookie = kzalloc(sizeof(*cookie), GFP_KERNEL);
 	if (cookie) {
+		spin_lock_init(&cookie->msi_lock);
 		INIT_LIST_HEAD(&cookie->msi_page_list);
 		cookie->type = type;
 	}
@@ -120,14 +126,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
  *
  * Users who manage their own IOVA allocation and do not want DMA API support,
  * but would still like to take advantage of automatic MSI remapping, can use
- * this to initialise their own domain appropriately. Users should reserve a
+ * this to initialise their own domain appropriately. Users may reserve a
  * contiguous IOVA region, starting at @base, large enough to accommodate the
  * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
- * used by the devices attached to @domain.
+ * used by the devices attached to @domain. The other way round is to provide
+ * usable iova pages through the iommu_dma_bind_guest_msi API (nested stages
+ * use case)
  */
 int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 {
 	struct iommu_dma_cookie *cookie;
+	int nesting, ret;
 
 	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
 		return -EINVAL;
@@ -135,11 +144,17 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 	if (domain->iova_cookie)
 		return -EEXIST;
 
-	cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);
+	if (!ret && nesting)
+		cookie = cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
+	else
+		cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+
 	if (!cookie)
 		return -ENOMEM;
 
-	cookie->msi_iova = base;
+	if (!nesting)
+		cookie->msi_iova = base;
 	domain->iova_cookie = cookie;
 	return 0;
 }
@@ -163,15 +178,116 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 	if (cookie->type == IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
 		put_iova_domain(&cookie->iovad);
 
+	spin_lock(&cookie->msi_lock);
 	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
+		if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE && msi->phys) {
+			size_t size = cookie_msi_granule(cookie);
+
+			WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
+		}
 		list_del(&msi->list);
 		kfree(msi);
 	}
+	spin_unlock(&cookie->msi_lock);
 	kfree(cookie);
 	domain->iova_cookie = NULL;
 }
 EXPORT_SYMBOL(iommu_put_dma_cookie);
 
+/**
+ * iommu_dma_bind_guest_msi - Allows to pass the stage 1
+ * binding of a virtual MSI doorbell used by @dev.
+ *
+ * @domain: domain handle
+ * @giova: guest iova
+ * @gpa: gpa of the virtual doorbell
+ * @size: size of the granule used for the stage1 mapping
+ *
+ * In nested stage use case, the user can provide IOVA/IPA bindings
+ * corresponding to a guest MSI stage 1 mapping. When the host needs
+ * to map its own MSI doorbells, it can use @gpa as stage 2 input
+ * and map it onto the physical MSI doorbell.
+ */
+int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			     dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iommu_dma_msi_page *msi;
+	int ret = 0;
+
+	if (!cookie)
+		return -EINVAL;
+
+	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
+		return -EINVAL;
+
+	/*
+	 * we currently do not support S1 granule larger than S2 one
+	 * as this would oblige to have multiple S2 mappings for a
+	 * single S1 one
+	 */
+	if (size > cookie_msi_granule(cookie))
+		return -EINVAL;
+
+	giova = giova & ~(dma_addr_t)(size - 1);
+	gpa = gpa & ~(phys_addr_t)(size - 1);
+
+	spin_lock(&cookie->msi_lock);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		if (msi->iova == giova)
+			goto unlock; /* this page is already registered */
+	}
+
+	msi = kzalloc(sizeof(*msi), GFP_ATOMIC);
+	if (!msi) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	msi->iova = giova;
+	msi->gpa = gpa;
+	msi->s1_granule = size;
+	list_add(&msi->list, &cookie->msi_page_list);
+unlock:
+	spin_unlock(&cookie->msi_lock);
+	return ret;
+}
+EXPORT_SYMBOL(iommu_dma_bind_guest_msi);
+
+void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
+{
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iommu_dma_msi_page *msi;
+
+	if (!cookie)
+		return;
+
+	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
+		return;
+
+	spin_lock(&cookie->msi_lock);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		dma_addr_t aligned_giova =
+			giova & ~(dma_addr_t)(msi->s1_granule - 1);
+
+		if (msi->iova == aligned_giova) {
+			if (msi->phys) {
+				/* unmap the stage 2 */
+				size_t size = cookie_msi_granule(cookie);
+
+				WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
+			}
+			list_del(&msi->list);
+			kfree(msi);
+			break;
+		}
+	}
+	spin_unlock(&cookie->msi_lock);
+}
+EXPORT_SYMBOL(iommu_dma_unbind_guest_msi);
+
 /**
  * iommu_dma_get_resv_regions - Reserved region driver helper
  * @dev: Device from iommu_get_resv_regions()
@@ -1300,6 +1416,58 @@ void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 size)
 		 dev_name(dev));
 }
 
+/*
+ * iommu_dma_get_nested_msi_page - Returns a nested stage MSI page
+ * mapping translating into the physical doorbell address @msi_addr
+ *
+ * In nested mode, the userspace provides the guest
+ * gIOVA - gDB stage 1 mappings. When we need to build a stage 2
+ * mapping for a physical doorbell (@msi_addr), we look up
+ * for an unused S1 mapping and map the gDB onto @msi_addr
+ */
+static struct iommu_dma_msi_page *
+iommu_dma_get_nested_msi_page(struct iommu_domain *domain,
+			      phys_addr_t msi_addr)
+{
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iommu_dma_msi_page *iter, *msi_page = NULL;
+	size_t size = cookie_msi_granule(cookie);
+	int prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
+
+	spin_lock(&cookie->msi_lock);
+	list_for_each_entry(iter, &cookie->msi_page_list, list)
+		if (iter->phys == msi_addr) {
+			msi_page = iter;
+			goto unlock;
+		}
+
+	/*
+	 * No nested mapping exists for the physical doorbell,
+	 * look for an unused S1 mapping
+	 */
+	list_for_each_entry(iter, &cookie->msi_page_list, list) {
+		int ret;
+
+		if (iter->phys)
+			continue;
+
+		/* do the stage 2 mapping */
+		ret = iommu_map_atomic(domain, iter->gpa, msi_addr, size, prot);
+		if (ret) {
+			pr_warn_once("MSI S2 mapping 0x%llx -> 0x%llx failed (%d)\n",
+				     iter->gpa, msi_addr, ret);
+			goto unlock;
+		}
+		iter->phys = msi_addr;
+		msi_page = iter;
+		goto unlock;
+	}
+	pr_warn_once("No usable S1 MSI mapping found\n");
+unlock:
+	spin_unlock(&cookie->msi_lock);
+	return msi_page;
+}
+
 static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 		phys_addr_t msi_addr, struct iommu_domain *domain)
 {
@@ -1310,6 +1478,10 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 	size_t size = cookie_msi_granule(cookie);
 
 	msi_addr &= ~(phys_addr_t)(size - 1);
+
+	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE)
+		return iommu_dma_get_nested_msi_page(domain, msi_addr);
+
 	list_for_each_entry(msi_page, &cookie->msi_page_list, list)
 		if (msi_page->phys == msi_addr)
 			return msi_page;
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index 706b68d1359b..7bd785e68477 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
 #include <linux/msi.h>
+#include <uapi/linux/iommu.h>
 
 /* Domain management interface for IOMMU drivers */
 int iommu_get_dma_cookie(struct iommu_domain *domain);
@@ -36,6 +37,9 @@ void iommu_dma_compose_msi_msg(struct msi_desc *desc,
 			       struct msi_msg *msg);
 
 void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
+int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			     dma_addr_t iova, phys_addr_t gpa, size_t size);
+void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova);
 
 void iommu_dma_free_cpu_cached_iovas(unsigned int cpu,
 		struct iommu_domain *domain);
@@ -77,6 +81,18 @@ static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
 {
 }
 
+static inline int
+iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			 dma_addr_t iova, phys_addr_t gpa, size_t size)
+{
+	return -ENODEV;
+}
+
+static inline void
+iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
+{
+}
+
 static inline void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list)
 {
 }
-- 
2.26.3

