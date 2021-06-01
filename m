Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2CD396F39
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhFAIrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:47:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233516AbhFAIrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 04:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622537127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpp86MKQOz0QZsgGameycFz6/zr05nCyS0wGULJidQo=;
        b=ZmS+xUmQQMPbGV893iyo4FzNfExDSVg2RyNarFlhe3hITlJymIEbgWLusHxmefA50V53wT
        xM3ym2qWEL4iBGaw4PzIyRnHAcsp0sxAXqhb7jU4rfrCOVl0X/S5cAgJ4avBR2gZM87WGv
        byMBnK3BaCSaBMdmsm/1WVUc6OEe28s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-Fm1-Ruf2O6maY4LjyoKtBg-1; Tue, 01 Jun 2021 04:45:26 -0400
X-MC-Unique: Fm1-Ruf2O6maY4LjyoKtBg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A8C710509DF;
        Tue,  1 Jun 2021 08:45:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A81AA101E5AF;
        Tue,  1 Jun 2021 08:45:21 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
Subject: [PATCH 2/4] virtio-pci library: introduce vp_modern_get_driver_features()
Date:   Tue,  1 Jun 2021 16:45:01 +0800
Message-Id: <20210601084503.34724-3-jasowang@redhat.com>
In-Reply-To: <20210601084503.34724-1-jasowang@redhat.com>
References: <20210601084503.34724-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduce a helper to get driver/guest features from the
device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 21 +++++++++++++++++++++
 include/linux/virtio_pci_modern.h      |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 54f297028586..e11ed748e661 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -383,6 +383,27 @@ u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev)
 }
 EXPORT_SYMBOL_GPL(vp_modern_get_features);
 
+/*
+ * vp_modern_get_driver_features - get driver features from device
+ * @mdev: the modern virtio-pci device
+ *
+ * Returns the driver features read from the device
+ */
+u64 vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
+
+	u64 features;
+
+	vp_iowrite32(0, &cfg->guest_feature_select);
+	features = vp_ioread32(&cfg->guest_feature);
+	vp_iowrite32(1, &cfg->guest_feature_select);
+	features |= ((u64)vp_ioread32(&cfg->guest_feature) << 32);
+
+	return features;
+}
+EXPORT_SYMBOL_GPL(vp_modern_get_driver_features);
+
 /*
  * vp_modern_set_features - set features to device
  * @mdev: the modern virtio-pci device
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index 6a95b58fd0f4..eb2bd9b4077d 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -79,6 +79,7 @@ static inline void vp_iowrite64_twopart(u64 val,
 }
 
 u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev);
+u64 vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev);
 void vp_modern_set_features(struct virtio_pci_modern_device *mdev,
 		     u64 features);
 u32 vp_modern_generation(struct virtio_pci_modern_device *mdev);
-- 
2.25.1

