Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A284E3D9E95
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 09:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhG2Hg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 03:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbhG2HgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 03:36:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C964C061799
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:20 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so9038072pjv.3
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 00:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VIBGZakN9k8BoO8YLMnCoI0EQ62bM67Edlzhv2usKjY=;
        b=YB4ZBkJ2UbGmacd15CUj5610iSRVIyAVm76CETlhwePaAGMy1nP4wVboLGC4DJ45kw
         wS034hRrqM5JbLcfYkHr4l64Vo3/J7EvtnF4ZFGz4XKOPCmyEorUa6O2v/DEV3nMMEBS
         u61bKP+sFu957CxpAsLhY0E5+ZnndnrsVtCqI36OjNoRLVQnERyMUuw0KViH6f22atFV
         UXjKMFPdgNpgcD4LFCaQHABx2iEsyXCpIIxTpPuUla8nJAobGV+MuufDJkoSesH1Nm60
         n0AnQe+Eu0XBc/6JOLDRrzfVdrvAKRjfv4rTmabJC9d1ZMzG1tTMB2NX42dPf7u6CP2o
         +Eaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VIBGZakN9k8BoO8YLMnCoI0EQ62bM67Edlzhv2usKjY=;
        b=e3TCTwhyKi5/2cf4wjbs5kvKRsxIoWEwi4DW854j7tVAN3N3Y8SitH0Q0nS5OoNLdF
         /TTgtm5Ncart8Xdtq2o4c2ERCdP/Sf6kcZtstpx1+MXXua5pi87FT2E8BOCcG+zt2WpP
         MzJ+1lCM0u2yLruMfkO36ixqq2qobi1iKBhsmYWo8J0zC37i883fSiMvIGUB1ol+ACNi
         FoxxwHjoMju55GkyE8OTWQiVie6O53+0s7IBvPG/lgWJLLllYRf1+15j+3/qEm+aS3i2
         ngc0IMtZsoG/ngViJEEehOfY5Almkn9T3wKUlQxXFhqB3LSr+0BZHiWvjX+pmsCOJWjJ
         fz6Q==
X-Gm-Message-State: AOAM531S1SPlj/U4b3lqAio9lQeqMZC3UxtXtJekNNzPqIxgMS8CWZGg
        kO3t62ZErzmiukfTW82O5eHR
X-Google-Smtp-Source: ABdhPJxTWwlUeqHVaW44eybtOYtbAcCrpe+XMQRRaXjatyWL8/OnDv5TWZQAFglLde0iZkvroMKDbQ==
X-Received: by 2002:aa7:87cd:0:b029:32e:7954:2872 with SMTP id i13-20020aa787cd0000b029032e79542872mr3825545pfo.0.1627544179762;
        Thu, 29 Jul 2021 00:36:19 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id v15sm2469337pff.105.2021.07.29.00.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:19 -0700 (PDT)
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
Subject: [PATCH v10 04/17] vdpa: Fail the vdpa_reset() if fail to set device status to zero
Date:   Thu, 29 Jul 2021 15:34:50 +0800
Message-Id: <20210729073503.187-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-read the device status to ensure it's set to zero during
resetting. Otherwise, fail the vdpa_reset() after timeout.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 include/linux/vdpa.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 406d53a606ac..d1a80ef05089 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -6,6 +6,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/vhost_iotlb.h>
+#include <linux/delay.h>
 
 /**
  * struct vdpa_calllback - vDPA callback definition.
@@ -340,12 +341,24 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
 	return vdev->dma_dev;
 }
 
-static inline void vdpa_reset(struct vdpa_device *vdev)
+#define VDPA_RESET_TIMEOUT_MS 1000
+
+static inline int vdpa_reset(struct vdpa_device *vdev)
 {
 	const struct vdpa_config_ops *ops = vdev->config;
+	int timeout = 0;
 
 	vdev->features_valid = false;
 	ops->set_status(vdev, 0);
+	while (ops->get_status(vdev)) {
+		timeout += 20;
+		if (timeout > VDPA_RESET_TIMEOUT_MS)
+			return -EIO;
+
+		msleep(20);
+	}
+
+	return 0;
 }
 
 static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
-- 
2.11.0

