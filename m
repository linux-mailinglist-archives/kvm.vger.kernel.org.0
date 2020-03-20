Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CF18D441
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 17:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgCTQVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 12:21:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25795 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbgCTQVR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 12:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584721276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXG84dHL0m4cU/Qn0Lqwx5Wj56OC04pQ0TdubjShMr8=;
        b=Efz02iCVYVvLvrZ12HilRvENS5JcnD2N0xSEbEeFJnw6wXRSswWjMoL0G8EvwblDpGqmhC
        cEI4WlXamh1SBbKMEEiF6NZpVgosPaq9t8baATtaCZNaKvUnwpWbDZjUpTAQBFxmFWCJk/
        dvP0+xmC5Pj2u7SUaeRTD1t/vKxRpuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-Pi0HcnQSPJ6M84wPvl51YQ-1; Fri, 20 Mar 2020 12:21:13 -0400
X-MC-Unique: Pi0HcnQSPJ6M84wPvl51YQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1B381005510;
        Fri, 20 Mar 2020 16:21:09 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85DEC60BFB;
        Fri, 20 Mar 2020 16:20:59 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     marc.zyngier@arm.com, peter.maydell@linaro.org,
        zhangfei.gao@gmail.com
Subject: [PATCH v10 11/11] vfio: Document nested stage control
Date:   Fri, 20 Mar 2020 17:19:11 +0100
Message-Id: <20200320161911.27494-12-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VFIO API was enhanced to support nested stage control: a bunch of
new iotcls, one DMA FAULT region and an associated specific IRQ.

Let's document the process to follow to set up nested mode.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- new names for SET_MSI_BINDING and SET_PASID_TABLE
- new layout for the DMA FAULT memory region and specific IRQ

v2 -> v3:
- document the new fault API

v1 -> v2:
- use the new ioctl names
- add doc related to fault handling
---
 Documentation/driver-api/vfio.rst | 77 +++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api=
/vfio.rst
index f1a4d3c3ba0b..563ebcec9224 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -239,6 +239,83 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
=20
+IOMMU Dual Stage Control
+------------------------
+
+Some IOMMUs support 2 stages/levels of translation. "Stage" corresponds =
to
+the ARM terminology while "level" corresponds to Intel's VTD terminology=
. In
+the following text we use either without distinction.
+
+This is useful when the guest is exposed with a virtual IOMMU and some
+devices are assigned to the guest through VFIO. Then the guest OS can us=
e
+stage 1 (IOVA -> GPA), while the hypervisor uses stage 2 for VM isolatio=
n
+(GPA -> HPA).
+
+The guest gets ownership of the stage 1 page tables and also owns stage =
1
+configuration structures. The hypervisor owns the root configuration str=
ucture
+(for security reason), including stage 2 configuration. This works as lo=
ng
+configuration structures and page table format are compatible between th=
e
+virtual IOMMU and the physical IOMMU.
+
+Assuming the HW supports it, this nested mode is selected by choosing th=
e
+VFIO_TYPE1_NESTING_IOMMU type through:
+
+ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
+
+This forces the hypervisor to use the stage 2, leaving stage 1 available=
 for
+guest usage.
+
+Once groups are attached to the container, the guest stage 1 translation
+configuration data can be passed to VFIO by using
+
+ioctl(container, VFIO_IOMMU_SET_PASID_TABLE, &pasid_table_info);
+
+This allows to combine the guest stage 1 configuration structure along w=
ith
+the hypervisor stage 2 configuration structure. Stage 1 configuration
+structures are dependent on the IOMMU type.
+
+As the stage 1 translation is fully delegated to the HW, translation fau=
lts
+encountered during the translation process need to be propagated up to
+the virtualizer and re-injected into the guest.
+
+The userspace must be prepared to receive faults. The VFIO-PCI device
+exposes one dedicated DMA FAULT region: it contains a ring buffer and
+its header that allows to manage the head/tail indices. The region is
+identified by the following index/subindex:
+- VFIO_REGION_TYPE_NESTED/VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT
+
+The DMA FAULT region exposes a VFIO_REGION_INFO_CAP_PRODUCER_FAULT
+region capability that allows the userspace to retrieve the ABI version
+of the fault records filled by the host.
+
+On top of that region, the userspace can be notified whenever a fault
+occurs at the physical level. It can use the VFIO_IRQ_TYPE_NESTED/
+VFIO_IRQ_SUBTYPE_DMA_FAULT specific IRQ to attach the eventfd to be
+signalled.
+
+The ring buffer containing the fault records can be mmapped. When
+the userspace consumes a fault in the queue, it should increment
+the consumer index to allow new fault records to replace the used ones.
+
+The queue size and the entry size can be retrieved in the header.
+The tail index should never overshoot the producer index as in any
+other circular buffer scheme. Also it must be less than the queue size
+otherwise the change fails.
+
+When the guest invalidates stage 1 related caches, invalidations must be
+forwarded to the host through
+ioctl(container, VFIO_IOMMU_CACHE_INVALIDATE, &inv_data);
+Those invalidations can happen at various granularity levels, page, cont=
ext, ...
+
+The ARM SMMU specification introduces another challenge: MSIs are transl=
ated by
+both the virtual SMMU and the physical SMMU. To build a nested mapping f=
or the
+IOVA programmed into the assigned device, the guest needs to pass its IO=
VA/MSI
+doorbell GPA binding to the host. Then the hypervisor can build a nested=
 stage 2
+binding eventually translating into the physical MSI doorbell.
+
+This is achieved by calling
+ioctl(container, VFIO_IOMMU_SET_MSI_BINDING, &guest_binding);
+
 VFIO User API
 ------------------------------------------------------------------------=
-------
=20
--=20
2.20.1

