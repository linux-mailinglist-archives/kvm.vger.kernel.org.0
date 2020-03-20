Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D692318D3CD
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgCTQLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:11:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43733 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgCTQLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584720691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YUAN7qBs0VZEH/PMZVsgPBipECF/v8dpbZxwQkQwjv4=;
        b=hAHsLM6dJ2pt1aPrW7QeblJwwGiurwi/aH9d5dMzVXUdjLC8gsAwhGYB9soyLBN7eDkhiW
        wuDI8r6ZhMXbIZKTRjCxPKpBRDz9371SQwctmLo5p4rYF0Qggm7HID7SHX2byL9xgImBcN
        /lrglYpIm+WF18QjWTwTE1vC8elSUSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-hyCiiMF7P0q8VMyWi0hURw-1; Fri, 20 Mar 2020 12:11:29 -0400
X-MC-Unique: hyCiiMF7P0q8VMyWi0hURw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F4DF102CE14;
        Fri, 20 Mar 2020 16:11:03 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE68A5C1D8;
        Fri, 20 Mar 2020 16:10:56 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 09/13] dma-iommu: Implement NESTED_MSI cookie
Date:   Fri, 20 Mar 2020 17:09:28 +0100
Message-Id: <20200320160932.27222-10-eric.auger@redhat.com>
In-Reply-To: <20200320160932.27222-1-eric.auger@redhat.com>
References: <20200320160932.27222-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
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
index a2e96a5fd9a7..b9db87a92c4c 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -20,6 +20,7 @@
 #include <linux/irq.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
 #include <linux/vmalloc.h>
@@ -28,12 +29,15 @@
 struct iommu_dma_msi_page {
 	struct list_head	list;
 	dma_addr_t		iova;
+	dma_addr_t		gpa;
 	phys_addr_t		phys;
+	size_t			s1_granule;
 };
=20
 enum iommu_dma_cookie_type {
 	IOMMU_DMA_IOVA_COOKIE,
 	IOMMU_DMA_MSI_COOKIE,
+	IOMMU_DMA_NESTED_MSI_COOKIE,
 };
=20
 struct iommu_dma_cookie {
@@ -45,6 +49,7 @@ struct iommu_dma_cookie {
 		dma_addr_t		msi_iova;
 	};
 	struct list_head		msi_page_list;
+	spinlock_t			msi_lock;
=20
 	/* Domain for flush queue callback; NULL if flush queue not in use */
 	struct iommu_domain		*fq_domain;
@@ -63,6 +68,7 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu=
_dma_cookie_type type)
=20
 	cookie =3D kzalloc(sizeof(*cookie), GFP_KERNEL);
 	if (cookie) {
+		spin_lock_init(&cookie->msi_lock);
 		INIT_LIST_HEAD(&cookie->msi_page_list);
 		cookie->type =3D type;
 	}
@@ -96,14 +102,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
  *
  * Users who manage their own IOVA allocation and do not want DMA API su=
pport,
  * but would still like to take advantage of automatic MSI remapping, ca=
n use
- * this to initialise their own domain appropriately. Users should reser=
ve a
+ * this to initialise their own domain appropriately. Users may reserve =
a
  * contiguous IOVA region, starting at @base, large enough to accommodat=
e the
  * number of PAGE_SIZE mappings necessary to cover every MSI doorbell ad=
dress
- * used by the devices attached to @domain.
+ * used by the devices attached to @domain. The other way round is to pr=
ovide
+ * usable iova pages through the iommu_dma_bind_doorbell API (nested sta=
ges
+ * use case)
  */
 int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 {
 	struct iommu_dma_cookie *cookie;
+	int nesting, ret;
=20
 	if (domain->type !=3D IOMMU_DOMAIN_UNMANAGED)
 		return -EINVAL;
@@ -111,7 +120,12 @@ int iommu_get_msi_cookie(struct iommu_domain *domain=
, dma_addr_t base)
 	if (domain->iova_cookie)
 		return -EEXIST;
=20
-	cookie =3D cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+	ret =3D  iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);
+	if (!ret && nesting)
+		cookie =3D cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
+	else
+		cookie =3D cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+
 	if (!cookie)
 		return -ENOMEM;
=20
@@ -132,6 +146,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain=
)
 {
 	struct iommu_dma_cookie *cookie =3D domain->iova_cookie;
 	struct iommu_dma_msi_page *msi, *tmp;
+	bool s2_unmap =3D false;
=20
 	if (!cookie)
 		return;
@@ -139,7 +154,15 @@ void iommu_put_dma_cookie(struct iommu_domain *domai=
n)
 	if (cookie->type =3D=3D IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
 		put_iova_domain(&cookie->iovad);
=20
+	if (cookie->type =3D=3D IOMMU_DMA_NESTED_MSI_COOKIE)
+		s2_unmap =3D true;
+
 	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
+		if (s2_unmap && msi->phys) {
+			size_t size =3D cookie_msi_granule(cookie);
+
+			WARN_ON(iommu_unmap(domain, msi->gpa, size) !=3D size);
+		}
 		list_del(&msi->list);
 		kfree(msi);
 	}
@@ -148,6 +171,92 @@ void iommu_put_dma_cookie(struct iommu_domain *domai=
n)
 }
 EXPORT_SYMBOL(iommu_put_dma_cookie);
=20
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
+	struct iommu_dma_cookie *cookie =3D domain->iova_cookie;
+	struct iommu_dma_msi_page *msi;
+	int ret =3D 0;
+
+	if (!cookie)
+		return -EINVAL;
+
+	if (cookie->type !=3D IOMMU_DMA_NESTED_MSI_COOKIE)
+		return -EINVAL;
+
+	iova =3D iova & ~(dma_addr_t)(size - 1);
+	gpa =3D gpa & ~(phys_addr_t)(size - 1);
+
+	spin_lock(&cookie->msi_lock);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		if (msi->iova =3D=3D iova)
+			goto unlock; /* this page is already registered */
+	}
+
+	msi =3D kzalloc(sizeof(*msi), GFP_ATOMIC);
+	if (!msi) {
+		ret =3D -ENOMEM;
+		goto unlock;
+	}
+
+	msi->iova =3D iova;
+	msi->gpa =3D gpa;
+	msi->s1_granule =3D size;
+	list_add(&msi->list, &cookie->msi_page_list);
+unlock:
+	spin_unlock(&cookie->msi_lock);
+	return ret;
+}
+EXPORT_SYMBOL(iommu_dma_bind_guest_msi);
+
+void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t =
giova)
+{
+	struct iommu_dma_cookie *cookie =3D domain->iova_cookie;
+	struct iommu_dma_msi_page *msi;
+
+	if (!cookie)
+		return;
+
+	if (cookie->type !=3D IOMMU_DMA_NESTED_MSI_COOKIE)
+		return;
+
+	spin_lock(&cookie->msi_lock);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		dma_addr_t aligned_giova =3D
+			giova & ~(dma_addr_t)(msi->s1_granule - 1);
+
+		if (msi->iova =3D=3D aligned_giova) {
+			if (msi->phys) {
+				/* unmap the stage 2 */
+				size_t size =3D cookie_msi_granule(cookie);
+
+				WARN_ON(iommu_unmap(domain, msi->gpa, size) !=3D size);
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
@@ -1175,6 +1284,33 @@ static struct iommu_dma_msi_page *iommu_dma_get_ms=
i_page(struct device *dev,
 		if (msi_page->phys =3D=3D msi_addr)
 			return msi_page;
=20
+	/*
+	 * In nested stage mode, we do not allocate an MSI page in
+	 * a range provided by the user. Instead, IOVA/IPA bindings are
+	 * individually provided. We reuse thise IOVAs to build the
+	 * GIOVA -> GPA -> MSI HPA nested stage mapping.
+	 */
+	if (cookie->type =3D=3D IOMMU_DMA_NESTED_MSI_COOKIE) {
+		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
+			if (!msi_page->phys) {
+				int ret;
+
+				/* do the stage 2 mapping */
+				ret =3D iommu_map(domain,
+						msi_page->gpa, msi_addr, size,
+						IOMMU_MMIO | IOMMU_WRITE);
+				if (ret) {
+					pr_warn("MSI S2 mapping failed (%d)\n",
+						ret);
+					return NULL;
+				}
+				msi_page->phys =3D msi_addr;
+				return msi_page;
+			}
+		pr_warn("%s no MSI binding found\n", __func__);
+		return NULL;
+	}
+
 	msi_page =3D kzalloc(sizeof(*msi_page), GFP_KERNEL);
 	if (!msi_page)
 		return NULL;
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index 2112f21f73d8..d4317c7ecf58 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
 #include <linux/msi.h>
+#include <uapi/linux/iommu.h>
=20
 /* Domain management interface for IOMMU drivers */
 int iommu_get_dma_cookie(struct iommu_domain *domain);
@@ -36,6 +37,9 @@ void iommu_dma_compose_msi_msg(struct msi_desc *desc,
 			       struct msi_msg *msg);
=20
 void iommu_dma_get_resv_regions(struct device *dev, struct list_head *li=
st);
+int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			     dma_addr_t iova, phys_addr_t gpa, size_t size);
+void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t =
giova);
=20
 #else /* CONFIG_IOMMU_DMA */
=20
@@ -74,6 +78,18 @@ static inline void iommu_dma_compose_msi_msg(struct ms=
i_desc *desc,
 {
 }
=20
+static inline int
+iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			 dma_addr_t iova, phys_addr_t gpa, size_t size)
+{
+	return -ENODEV;
+}
+
+static inline void
+iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova=
);
+{
+}
+
 static inline void iommu_dma_get_resv_regions(struct device *dev, struct=
 list_head *list)
 {
 }
--=20
2.20.1

