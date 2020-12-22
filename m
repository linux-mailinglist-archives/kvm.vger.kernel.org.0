Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767DC2E0C1D
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgLVOyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 09:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgLVOyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 09:54:32 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EA3C0611CC
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 06:53:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x12so7534655plr.10
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 06:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rk3Zr0O5adDtcKDEPjgvkHO0z8gks3DD0R510gfQviI=;
        b=D1szuUExD6TpnQNRaVTujQbjLXwWr6+baESrAmj1vKA8Re+touRhSZ9m3brhKAqQh/
         W7MXeqBNVFH4kKZjsKXehNNuXmDYgNlvevhXFoF7wMCxY7+4ti8UheIN2Q9i73pIu1+a
         c7bsYSI6NwYEwUA25wPKeMoiIEPL092esHAqm7FeIFODOp0D4HjJXGw+dG2R9Yk1YJzO
         bhIRQiAIT3WOdmU0uVFMBtWimFVE905jm7v88TVO/rSiduJ6D4sgAOP0PkUsveELfK1d
         CXd79gRVp0g2qAVdMe723y3efhkOJ0lyFpUT4XBS+QYQyTsWdJlGT6sxt4bAt/k7BFmJ
         pi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rk3Zr0O5adDtcKDEPjgvkHO0z8gks3DD0R510gfQviI=;
        b=mA9DjM+9qF+n6OBd0F0xrJhuseBN9v0AsYTxZm4xXq7/aRCuf6/QILDWT8JE3GrvEA
         ruX/dCwscZhqQRGC1C3pQ1lt6QMW+geOxqAITZvtDddXdrxHOEUJhxS7yea8XdCY3g7M
         z3a/Xf4nFidOQCNHa5k1z1DBVd+t0cEz+RvHaf2vRWPcXQuyUYTLeuSUOBkfLWGbdXf2
         jXAp7thBfCXXOYtw7A/Xnldp/0/4kJ7JInVWuQHH+lRqlHbp9N/1Nx5eZeKQ8kKgFYqF
         D4UWFxdZWoM5+08zrfdWUCzTH4o1sWKGhkXz4HqX9joQRi6Bh1b3blmwWmpFUQHA6/Gc
         cazg==
X-Gm-Message-State: AOAM531vT1BOvEGIaJYZyiNUox6EmtWuCI88hjggHBkCTziIQGXeLHbY
        W0aHcf/etxyXWYv1BZjhD0Cu
X-Google-Smtp-Source: ABdhPJxQ33ZTSV1IvBRM48/KwG/7AoWwf9usxAJPW0lMoFTcM1C2UfJqPW7jl9CPakjJyJtP08tyYQ==
X-Received: by 2002:a17:90a:98f:: with SMTP id 15mr21654432pjo.60.1608648810848;
        Tue, 22 Dec 2020 06:53:30 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id o32sm21850106pgm.10.2020.12.22.06.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:53:30 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 04/13] vdpa: Remove the restriction that only supports virtio-net devices
Date:   Tue, 22 Dec 2020 22:52:12 +0800
Message-Id: <20201222145221.711-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With VDUSE, we should be able to support all kinds of virtio devices.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 29ed4173f04e..448be7875b6d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -22,6 +22,7 @@
 #include <linux/nospec.h>
 #include <linux/vhost.h>
 #include <linux/virtio_net.h>
+#include <linux/virtio_blk.h>
 
 #include "vhost.h"
 
@@ -185,26 +186,6 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	return 0;
 }
 
-static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
-				      struct vhost_vdpa_config *c)
-{
-	long size = 0;
-
-	switch (v->virtio_id) {
-	case VIRTIO_ID_NET:
-		size = sizeof(struct virtio_net_config);
-		break;
-	}
-
-	if (c->len == 0)
-		return -EINVAL;
-
-	if (c->len > size - c->off)
-		return -E2BIG;
-
-	return 0;
-}
-
 static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 				  struct vhost_vdpa_config __user *c)
 {
@@ -215,7 +196,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 	buf = kvzalloc(config.len, GFP_KERNEL);
 	if (!buf)
@@ -243,7 +224,7 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
 
 	if (copy_from_user(&config, c, size))
 		return -EFAULT;
-	if (vhost_vdpa_config_validate(v, &config))
+	if (config.len == 0)
 		return -EINVAL;
 	buf = kvzalloc(config.len, GFP_KERNEL);
 	if (!buf)
@@ -1025,10 +1006,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int r;
 
-	/* Currently, we only accept the network devices. */
-	if (ops->get_device_id(vdpa) != VIRTIO_ID_NET)
-		return -ENOTSUPP;
-
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!v)
 		return -ENOMEM;
-- 
2.11.0

