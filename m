Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A12FB425
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbhASFXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 00:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbhASFJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 00:09:07 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D25C061573
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:08:17 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l23so11377038pjg.1
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrnaBA59g8hmY68FB0uGiq3ZH+VPCQ5FzAHu8kuBTi0=;
        b=z29oA79dAO5Eg7HZO4XMx7s4Ru1t6D4M4NVANOro1w57eBqbuK5z40d+Qfh6c0LbgC
         Y3SzDl9749VBiVqMUEhWNpnv6VXOKn4EbZGzPoP6p3zJNYcEoPiwNKGbZYp//xWpgCnt
         pcWIqCz/aqP67Alc6pvRiSfhwkrdZG5lEqALPS5umJQawGjAsoAUkm33kyib9HD3bZ0T
         xlXGOdq1d1gKgS5o7raqJgDN8e3wJWBej+6sG0IlKUBBLHf2n1dzUGy+NIWlJHaq0Rws
         emd0ei9stYdWFRjReNAbLbab0FE/1bD5BjdzyG2fHGjUXREk6M9UHhqEaF+Kbc3vLimJ
         bCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrnaBA59g8hmY68FB0uGiq3ZH+VPCQ5FzAHu8kuBTi0=;
        b=f3HNd4n0OtkcH3wSEXBBOu2mE4k+KNT7C2dYPzmI6SRntxKN2PI0babRGVMoyBfjVh
         VeYrFgk2B2rjkvbRV0jvzZ6xUWU+2kibSazNV40Uo4T1ZCJ+/PGV+8sLUM7jS1TctL17
         oxb9O3l50iBYtMlgNSBAcylIzsNoFdmTFrHxECghuOVWCMiOtuzRN0taD9Hlr9Ljt4DZ
         U2e8nOOHNrRX9QNDgFMTyGCVwT7VYh2PJc+SNgGDBTnvWwTaE4LhiYJ50Tj7cpcvV6KV
         +LVM0W4UmiwN0Awv/rUWEMRnyq37YRvcxKmB6ZsHbZl/jjp0WNn6Wv2il2ezrdwqJ3qM
         8h7Q==
X-Gm-Message-State: AOAM530CHMIpXR0gn6E/8qCq3LUXjV6di3RgngaUHfglsOsEp7TiG5qq
        m5i12scFIcExrUl+hWsq+Py5
X-Google-Smtp-Source: ABdhPJw4iOZN6+kzePO+c/3w2zGQ9FmnKraKZf5KGu+Sgb+AzphhRcL6QARmaJLEVogXeAFcq0yGgg==
X-Received: by 2002:a17:902:ba89:b029:dd:7fe3:ddf5 with SMTP id k9-20020a170902ba89b02900dd7fe3ddf5mr2695697pls.33.1611032896783;
        Mon, 18 Jan 2021 21:08:16 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id j6sm1101822pjd.33.2021.01.18.21.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:08:16 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 07/11] vdpa: Pass the netlink attributes to ops.dev_add()
Date:   Tue, 19 Jan 2021 13:07:52 +0800
Message-Id: <20210119050756.600-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the netlink attributes to ops.dev_add() so that we
could get some device specific attributes when creating
a vdpa device.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa.c              | 2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 ++-
 include/linux/vdpa.h             | 4 +++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 50cab930b2e5..81a099ec390e 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -443,7 +443,7 @@ static int vdpa_nl_cmd_dev_add_set_doit(struct sk_buff *skb, struct genl_info *i
 		goto err;
 	}
 
-	vdev = pdev->ops->dev_add(pdev, name, device_id);
+	vdev = pdev->ops->dev_add(pdev, name, device_id, info->attrs);
 	if (IS_ERR(vdev))
 		goto err;
 
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 1ffcef67954f..ce24a40f5b00 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -728,7 +728,8 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
 };
 
 static struct vdpa_device *
-vdpa_dev_add(struct vdpa_parent_dev *pdev, const char *name, u32 device_id)
+vdpa_dev_add(struct vdpa_parent_dev *pdev, const char *name,
+		u32 device_id, struct nlattr **attrs)
 {
 	struct vdpasim *simdev;
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index b264c627e94b..7b84badc6741 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -6,6 +6,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vhost_iotlb.h>
+#include <net/genetlink.h>
 
 /**
  * vDPA callback definition.
@@ -354,6 +355,7 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
  *		@pdev: parent device to use for device addition
  *		@name: name of the new vdpa device
  *		@device_id: device id of the new vdpa device
+ *		@attrs: device specific attributes
  *		Driver need to add a new device using vdpa_register_device() after
  *		fully initializing the vdpa device. On successful addition driver
  *		must return a valid pointer of vdpa device or ERR_PTR for the error.
@@ -364,7 +366,7 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
  */
 struct vdpa_dev_ops {
 	struct vdpa_device* (*dev_add)(struct vdpa_parent_dev *pdev, const char *name,
-				       u32 device_id);
+				       u32 device_id, struct nlattr **attrs);
 	void (*dev_del)(struct vdpa_parent_dev *pdev, struct vdpa_device *dev);
 };
 
-- 
2.11.0

