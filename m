Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A6335B3D6
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhDKLtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 07:49:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235613AbhDKLtA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 07:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618141724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xucYuCl5K1mWx3617CZ/wFEan4m2BNoR8BpLKGBpX28=;
        b=ZkHgMp3LdFgnYHWHcDfUIvYJ+WXe/D4JUjznrHzOSg9f8aS45ykmogtoqy6gR+DBo6BJLK
        DSWzDFmzsqBlot+NJnxZf1M3rOMiTASLt8166y7irBc9wz3f/fSUWGGzlaXBGKWOFpjPlG
        eodbTKyaMcigb7wrEkhJ5Y76MeGzY0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-BTEAAPHvND-Uc-Ts57am1g-1; Sun, 11 Apr 2021 07:48:39 -0400
X-MC-Unique: BTEAAPHvND-Uc-Ts57am1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07A7218397A6;
        Sun, 11 Apr 2021 11:48:36 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B010C5C266;
        Sun, 11 Apr 2021 11:48:27 +0000 (UTC)
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
Subject: [PATCH v13 07/13] vfio: Use capability chains to handle device specific irq
Date:   Sun, 11 Apr 2021 13:46:53 +0200
Message-Id: <20210411114659.15051-8-eric.auger@redhat.com>
In-Reply-To: <20210411114659.15051-1-eric.auger@redhat.com>
References: <20210411114659.15051-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

Caps the number of irqs with fixed indexes and uses capability chains
to chain device specific irqs.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
[Eric: Put cap_offset at the end of the vfio_irq_info struct,
remove GFX IRQ at the moment and remove any reference to this latter
in the commit message]

---
---
 include/uapi/linux/vfio.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ca8cc796e254..0728b6f3f348 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -708,11 +708,27 @@ struct vfio_irq_info {
 #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
 #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
 #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
+#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info supports caps */
 	__u32	index;		/* IRQ index */
 	__u32	count;		/* Number of IRQs within this index */
+	__u32	cap_offset;	/* Offset within info struct of first cap */
 };
 #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE + 9)
 
+/*
+ * The irq type capability allows IRQs unique to a specific device or
+ * class of devices to be exposed.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IRQ_INFO_CAP_TYPE      3
+
+struct vfio_irq_info_cap_type {
+	struct vfio_info_cap_header header;
+	__u32 type;     /* global per bus driver */
+	__u32 subtype;  /* type specific */
+};
+
 /**
  * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct vfio_irq_set)
  *
@@ -814,7 +830,8 @@ enum {
 	VFIO_PCI_MSIX_IRQ_INDEX,
 	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_REQ_IRQ_INDEX,
-	VFIO_PCI_NUM_IRQS
+	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5 use   */
+				/* device specific cap to define content */
 };
 
 /*
-- 
2.26.3

