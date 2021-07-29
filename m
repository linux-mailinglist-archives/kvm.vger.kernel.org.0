Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ECC3D9E8D
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 09:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhG2HgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 03:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhG2HgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 03:36:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3022C0613CF
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k4-20020a17090a5144b02901731c776526so14232812pjm.4
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ezTwUwcHdLzbLJ6Qex8t9bSwQh5nV4gM1nW+onIqamc=;
        b=aJeeKmO1iUSf5ulfQYOmU/f6LrJOJ/xpojaG8sp5MHHhsHcHMnmIPAHKBLhJjNXk9I
         SdMsytyS3rpG7e6wxN4paTE8aVeoxADQ2Qq2VajHXG4r7NSce8dZXAAfl9JaBWANBaRx
         62S32j4gMEjGzd6F2uS/UK4OCyD90ujkUW/g8osNQTriob7uuqrBY8QD40XGCDT+tN2r
         S96uxeNvFTeXzWXlZhJR4HK9PQRPgGSR4ZaMIRepsa9zFFjt3FCL/aHCfKqU1O86lhtV
         BKjZynlYbYg8IdfiD8WOoifTvfmhUBkRhWKiO7j2lB54h5a/mglAbeZ0WzkX2aAkZUz9
         Nm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ezTwUwcHdLzbLJ6Qex8t9bSwQh5nV4gM1nW+onIqamc=;
        b=s0P8rPUulpiDVL1D1L2ndSU2dw4XaowANGhuKkyDxn/PR5ML1JLhLMI+vTgILWH3XT
         tZVBc4PnpybB+UT8f5idlo+sGtb9UK8nV6wLg1iYqKhIVXQa/0YJU+eoDexSAwvpRI/b
         /eY6r61A393+0FBlni2rALNH6SbPRTATDoQQ1A+4h8Pu+AfjjpJ6COC3+KQ2RmsCGRet
         gpNEOF5evztwavDvCBTdNz03bKo9OZkoOngbv+9pVgEisW5Orp/9ulDRo8r2r/d1mQnJ
         63+L57K1nTqg8dfbmH1AamKOOWguc/spdtVACC3oHjpD391/+jwXBYFUDvNerhGCKhoW
         9a4Q==
X-Gm-Message-State: AOAM532HecrdpMcXS7VArL20rQHFHixuOuHo5On5iE1JGhJT9WnYwxBW
        l7vzNYwn17R05yrn66L1JxWC
X-Google-Smtp-Source: ABdhPJy5HgYXGcMdvwyyUChEjHwAKCF6yZJqkhXxctPNS68GNGc1IbWVQnCkOAkuA+3j2foct0eGxg==
X-Received: by 2002:a17:902:a9c6:b029:129:8fdb:698f with SMTP id b6-20020a170902a9c6b02901298fdb698fmr3526952plr.15.1627544173432;
        Thu, 29 Jul 2021 00:36:13 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id y10sm2148879pjy.18.2021.07.29.00.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:12 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 03/17] vdpa: Fix code indentation
Date:   Thu, 29 Jul 2021 15:34:49 +0800
Message-Id: <20210729073503.187-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use tabs to indent the code instead of spaces.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 include/linux/vdpa.h | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 7c49bc5a2b71..406d53a606ac 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -43,17 +43,17 @@ struct vdpa_vq_state_split {
  * @last_used_idx: used index
  */
 struct vdpa_vq_state_packed {
-        u16	last_avail_counter:1;
-        u16	last_avail_idx:15;
-        u16	last_used_counter:1;
-        u16	last_used_idx:15;
+	u16	last_avail_counter:1;
+	u16	last_avail_idx:15;
+	u16	last_used_counter:1;
+	u16	last_used_idx:15;
 };
 
 struct vdpa_vq_state {
-     union {
-          struct vdpa_vq_state_split split;
-          struct vdpa_vq_state_packed packed;
-     };
+	union {
+		struct vdpa_vq_state_split split;
+		struct vdpa_vq_state_packed packed;
+	};
 };
 
 struct vdpa_mgmt_dev;
@@ -131,7 +131,7 @@ struct vdpa_iova_range {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				@state: pointer to returned state (last_avail_idx)
- * @get_vq_notification: 	Get the notification area for a virtqueue
+ * @get_vq_notification:	Get the notification area for a virtqueue
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns the notifcation area
@@ -342,25 +342,24 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
 
 static inline void vdpa_reset(struct vdpa_device *vdev)
 {
-        const struct vdpa_config_ops *ops = vdev->config;
+	const struct vdpa_config_ops *ops = vdev->config;
 
 	vdev->features_valid = false;
-        ops->set_status(vdev, 0);
+	ops->set_status(vdev, 0);
 }
 
 static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
 {
-        const struct vdpa_config_ops *ops = vdev->config;
+	const struct vdpa_config_ops *ops = vdev->config;
 
 	vdev->features_valid = true;
-        return ops->set_features(vdev, features);
+	return ops->set_features(vdev, features);
 }
 
-
 static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
 				   void *buf, unsigned int len)
 {
-        const struct vdpa_config_ops *ops = vdev->config;
+	const struct vdpa_config_ops *ops = vdev->config;
 
 	/*
 	 * Config accesses aren't supposed to trigger before features are set.
-- 
2.11.0

