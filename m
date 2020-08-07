Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD123F3A2
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 22:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHGUO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 16:14:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725893AbgHGUO4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 16:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596831294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QsmSdkCrL05ggCwSUu92b6yNnGSlgdi5jfgLpMXvbbI=;
        b=gbhLZdiZP3Iq6eDlfqe1zGo4Yvoc3rWpZ91B4E7kiT3tGznwDwrQrS8a8K+uh/ehzNwKVd
        X4f1zJI/t0BNd/gdT3HsMtEswGK+1A6Vo+LLzCbT7WthgeAvBQSCuy/N2/X1HJq2ypuD9J
        SgDlM1AUwmIf7cYMGFUfpUjHKK3nbx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-OpsRlMl1MaagiEOmJ52jiw-1; Fri, 07 Aug 2020 16:14:52 -0400
X-MC-Unique: OpsRlMl1MaagiEOmJ52jiw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF5BD57;
        Fri,  7 Aug 2020 20:14:51 +0000 (UTC)
Received: from gimli.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69A605F207;
        Fri,  7 Aug 2020 20:14:48 +0000 (UTC)
Subject: [PATCH] vfio/type1: Add proper error unwind for vfio_iommu_replay()
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 07 Aug 2020 14:14:48 -0600
Message-ID: <159683127474.1965.16929121291974112960.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_iommu_replay() function does not currently unwind on error,
yet it does pin pages, perform IOMMU mapping, and modify the vfio_dma
structure to indicate IOMMU mapping.  The IOMMU mappings are torn down
when the domain is destroyed, but the other actions go on to cause
trouble later.  For example, the iommu->domain_list can be empty if we
only have a non-IOMMU backed mdev attached.  We don't currently check
if the list is empty before getting the first entry in the list, which
leads to a bogus domain pointer.  If a vfio_dma entry is erroneously
marked as iommu_mapped, we'll attempt to use that bogus pointer to
retrieve the existing physical page addresses.

This is the scenario that uncovered this issue, attempting to hot-add
a vfio-pci device to a container with an existing mdev device and DMA
mappings, one of which could not be pinned, causing a failure adding
the new group to the existing container and setting the conditions
for a subsequent attempt to explode.

To resolve this, we can first check if the domain_list is empty so
that we can reject replay of a bogus domain, should we ever encounter
this inconsistent state again in the future.  The real fix though is
to add the necessary unwind support, which means cleaning up the
current pinning if an IOMMU mapping fails, then walking back through
the r-b tree of DMA entries, reading from the IOMMU which ranges are
mapped, and unmapping and unpinning those ranges.  To be able to do
this, we also defer marking the DMA entry as IOMMU mapped until all
entries are processed, in order to allow the unwind to know the
disposition of each entry.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   71 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e1c00de50ff9..d60432569209 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1424,13 +1424,16 @@ static int vfio_bus_type(struct device *dev, void *data)
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
-	struct vfio_domain *d;
+	struct vfio_domain *d = NULL;
 	struct rb_node *n;
 	unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	int ret;
 
 	/* Arbitrarily pick the first domain in the list for lookups */
-	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	if (!list_empty(&iommu->domain_list))
+		d = list_first_entry(&iommu->domain_list,
+				     struct vfio_domain, next);
+
 	n = rb_first(&iommu->dma_list);
 
 	for (; n; n = rb_next(n)) {
@@ -1448,6 +1451,11 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				phys_addr_t p;
 				dma_addr_t i;
 
+				if (WARN_ON(!d)) { /* mapped w/o a domain?! */
+					ret = -EINVAL;
+					goto unwind;
+				}
+
 				phys = iommu_iova_to_phys(d->domain, iova);
 
 				if (WARN_ON(!phys)) {
@@ -1477,7 +1485,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				if (npage <= 0) {
 					WARN_ON(!npage);
 					ret = (int)npage;
-					return ret;
+					goto unwind;
 				}
 
 				phys = pfn << PAGE_SHIFT;
@@ -1486,14 +1494,67 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 
 			ret = iommu_map(domain->domain, iova, phys,
 					size, dma->prot | domain->prot);
-			if (ret)
-				return ret;
+			if (ret) {
+				if (!dma->iommu_mapped)
+					vfio_unpin_pages_remote(dma, iova,
+							phys >> PAGE_SHIFT,
+							size >> PAGE_SHIFT,
+							true);
+				goto unwind;
+			}
 
 			iova += size;
 		}
+	}
+
+	/* All dmas are now mapped, defer to second tree walk for unwind */
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+
 		dma->iommu_mapped = true;
 	}
+
 	return 0;
+
+unwind:
+	for (; n; n = rb_prev(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+		dma_addr_t iova;
+
+		if (dma->iommu_mapped) {
+			iommu_unmap(domain->domain, dma->iova, dma->size);
+			continue;
+		}
+
+		iova = dma->iova;
+		while (iova < dma->iova + dma->size) {
+			phys_addr_t phys, p;
+			size_t size;
+			dma_addr_t i;
+
+			phys = iommu_iova_to_phys(domain->domain, iova);
+			if (!phys) {
+				iova += PAGE_SIZE;
+				continue;
+			}
+
+			size = PAGE_SIZE;
+			p = phys + size;
+			i = iova + size;
+			while (i < dma->iova + dma->size &&
+			       p == iommu_iova_to_phys(domain->domain, i)) {
+				size += PAGE_SIZE;
+				p += PAGE_SIZE;
+				i += PAGE_SIZE;
+			}
+
+			iommu_unmap(domain->domain, iova, size);
+			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
+						size >> PAGE_SHIFT, true);
+		}
+	}
+
+	return ret;
 }
 
 /*

