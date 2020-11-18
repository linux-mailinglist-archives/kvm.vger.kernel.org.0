Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1281A2B7C87
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 12:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgKRLX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 06:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727916AbgKRLXX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 06:23:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605698601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AaxiXR0nhGbQSwGqLCbOgbQ09ThFHFsZIWZ9xXu+JUE=;
        b=XfkfoTVCCOWqOTtKXevBe5ZMPXOai37YY2n+vcKPXRqXyhNWmG6fxd3j3qgQ+wyd4mcrqL
        g5z4w145z7wdWPU6bKaiXG52EaDQXW4l/8ybbHOY0DS0yflpR2Az9haZ58yM/iPw4uIeGQ
        H0foFnuyk9nqvtYo2+0zVuo24fnAg3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-2Pb5q2gbMmWf2qxvUrK-xg-1; Wed, 18 Nov 2020 06:23:17 -0500
X-MC-Unique: 2Pb5q2gbMmWf2qxvUrK-xg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F4C364092;
        Wed, 18 Nov 2020 11:23:15 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9EDA51512;
        Wed, 18 Nov 2020 11:23:10 +0000 (UTC)
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
Subject: [PATCH v13 09/15] dma-iommu: Implement NESTED_MSI cookie
Date:   Wed, 18 Nov 2020 12:21:45 +0100
Message-Id: <20201118112151.25412-10-eric.auger@redhat.com>
In-Reply-To: <20201118112151.25412-1-eric.auger@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 drivers/iommu/dma-iommu.c | 142 +++++++++++++++++++++++++++++++++++++-
 include/linux/dma-iommu.h |  16 +++++
 2 files changed, 155 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 0cbcd3fc3e7e..a14ecad6b79b 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
 #include <linux/vmalloc.h>
@@ -27,12 +28,15 @@
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
@@ -44,6 +48,7 @@ struct iommu_dma_cookie {
 		dma_addr_t		msi_iova;
 	};
 	struct list_head		msi_page_list;
+	spinlock_t			msi_lock;
 
 	/* Domain for flush queue callback; NULL if flush queue not in use */
 	struct iommu_domain		*fq_domain;
@@ -62,6 +67,7 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu_dma_cookie_type type)
 
 	cookie = kzalloc(sizeof(*cookie), GFP_KERNEL);
 	if (cookie) {
+		spin_lock_init(&cookie->msi_lock);
 		INIT_LIST_HEAD(&cookie->msi_page_list);
 		cookie->type = type;
 	}
@@ -95,14 +101,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
  *
  * Users who manage their own IOVA allocation and do not want DMA API support,
  * but would still like to take advantage of automatic MSI remapping, can use
- * this to initialise their own domain appropriately. Users should reserve a
+ * this to initialise their own domain appropriately. Users may reserve a
  * contiguous IOVA region, starting at @base, large enough to accommodate the
  * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
- * used by the devices attached to @domain.
+ * used by the devices attached to @domain. The other way round is to provide
+ * usable iova pages through the iommu_dma_bind_doorbell API (nested stages
+ * use case)
  */
 int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 {
 	struct iommu_dma_cookie *cookie;
+	int nesting, ret;
 
 	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
 		return -EINVAL;
@@ -110,7 +119,12 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 	if (domain->iova_cookie)
 		return -EEXIST;
 
-	cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+	ret =  iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);
+	if (!ret && nesting)
+		cookie = cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
+	else
+		cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+
 	if (!cookie)
 		return -ENOMEM;
 
@@ -131,6 +145,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 {
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iommu_dma_msi_page *msi, *tmp;
+	bool s2_unmap = false;
 
 	if (!cookie)
 		return;
@@ -138,7 +153,15 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 	if (cookie->type == IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
 		put_iova_domain(&cookie->iovad);
 
+	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE)
+		s2_unmap = true;
+
 	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
+		if (s2_unmap && msi->phys) {
+			size_t size = cookie_msi_granule(cookie);
+
+			WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
+		}
 		list_del(&msi->list);
 		kfree(msi);
 	}
@@ -147,6 +170,92 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL(iommu_put_dma_cookie);
 
+/**
+ * iommu_dma_bind_guest_msi - Allows to pass the stage 1
+ * binding of a virtual MSI doorbell used by @dev.
+ *
+ * @domain: domain handle
+ * @iova: guest iova
+ * @gpa: gpa of the virtual doorbell
+ * @size: size of the granule used for the stage1 mapping
+ *
+ * In nested stage use case, the user can provide IOVA/IPA bindings
+ * corresponding to a guest MSI stage 1 mapping. When the host needs
+ * to map its own MSI doorbells, it can use @gpa as stage 2 input
+ * and map it onto the physical MSI doorbell.
+ */
+int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			     dma_addr_t iova, phys_addr_t gpa, size_t size)
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
+	iova = iova & ~(dma_addr_t)(size - 1);
+	gpa = gpa & ~(phys_addr_t)(size - 1);
+
+	spin_lock(&cookie->msi_lock);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		if (msi->iova == iova)
+			goto unlock; /* this page is already registered */
+	}
+
+	msi = kzalloc(sizeof(*msi), GFP_ATOMIC);
+	if (!msi) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	msi->iova = iova;
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
@@ -1210,6 +1319,33 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 		if (msi_page->phys == msi_addr)
 			return msi_page;
 
+	/*
+	 * In nested stage mode, we do not allocate an MSI page in
+	 * a range provided by the user. Instead, IOVA/IPA bindings are
+	 * individually provided. We reuse thise IOVAs to build the
+	 * GIOVA -> GPA -> MSI HPA nested stage mapping.
+	 */
+	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE) {
+		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
+			if (!msi_page->phys) {
+				int ret;
+
+				/* do the stage 2 mapping */
+				ret = iommu_map(domain,
+						msi_page->gpa, msi_addr, size,
+						IOMMU_MMIO | IOMMU_WRITE);
+				if (ret) {
+					pr_warn("MSI S2 mapping failed (%d)\n",
+						ret);
+					return NULL;
+				}
+				msi_page->phys = msi_addr;
+				return msi_page;
+			}
+		pr_warn("%s no MSI binding found\n", __func__);
+		return NULL;
+	}
+
 	msi_page = kzalloc(sizeof(*msi_page), GFP_KERNEL);
 	if (!msi_page)
 		return NULL;
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index 2112f21f73d8..f112ecdb4af6 100644
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
 
 #else /* CONFIG_IOMMU_DMA */
 
@@ -74,6 +78,18 @@ static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
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
2.21.3

