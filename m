Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31122FB41A
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbhASFYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 00:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388204AbhASFKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 00:10:44 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB55C061796
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:08:32 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y8so9834411plp.8
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RADXly6HG+PYDpCqLXRZWwmhkpi+THQigpZFKjj79E0=;
        b=hdIVRGDx1eZ2GZAUtF9TXfCjHL0A61xJ7yUIPcaxGXzr+C+jwd44tFOdwvMbWgIhZa
         46OBX8LK/+MRRJosbjtmwJ+4Rzcgfgm3THj5W1yNejXzksIkbsIJDWWlUk9becxuqvtM
         HYjgArsRYUr5YTHXEhqwSGR0pENLTqqeGyPt+aLnTWsY/mGhD4VJ+/V8boVopz1HSeb5
         uUObLphRA1+I0VbYcKC/b9e2hmvSp4BDFXM3DD5l2eZYegM2L13niYRzcPJRfNmV7POK
         eplsd8nG5Vx0qHr/1M2JyLAZXyoaWipUPWyfgwHJrXzyWP+7+8GexAI+EvVj/vY2eFsm
         KuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RADXly6HG+PYDpCqLXRZWwmhkpi+THQigpZFKjj79E0=;
        b=H6v0JRHau0XpabHlAgCtKzyVT6XGoYqZoUmt/Dnsrp7L9TjQLPzkp3gTLn0EyYp7eO
         oakyktDM45cK7V+9RGKa9MC2Q3trjXq+rCmkAvrWpWTo1i2xbTeNUyFDO+cFtugEM3xC
         UbHhVNc44g4AswkbjMNkUXTmPjR1Pz5gy7F/CYJ5iXZcpVfg4SjAiw4EpcNrcnl3AGe+
         uyviMfopd9LQ+EfT8V75gRXY1RHIgNw6gOOdGhrnhou/DuzXuYmqGOxF/QKVt53bafFo
         WtIk/ktoINV16G0ra0zIDc7I+dR/vTSnfwvFFp9GM2LxcrD7YFjTLqMn5zVAsTr4Vk7D
         96Nw==
X-Gm-Message-State: AOAM533Fu9WxV5sTXJpRTrQhWmSxgITQs/XeGmnSDrmrUX3E7iKGOQHc
        vugP53DFusru2X/CwHLxHP3z
X-Google-Smtp-Source: ABdhPJysogckolByLTKMcr/MxZWQSFurvpfGyyWGzWHvCzD/JKR8cENOWIzhEm94G+0EqqY2cZ1ADQ==
X-Received: by 2002:a17:902:7202:b029:de:8483:506c with SMTP id ba2-20020a1709027202b02900de8483506cmr2934737plb.52.1611032911992;
        Mon, 18 Jan 2021 21:08:31 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id u68sm16497823pfb.70.2021.01.18.21.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:08:31 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 11/11] vduse: Introduce a workqueue for irq injection
Date:   Tue, 19 Jan 2021 13:07:56 +0800
Message-Id: <20210119050756.600-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119050756.600-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces a dedicated workqueue for irq injection
so that we are able to do some performance tuning for it.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/eventfd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_user/eventfd.c
index dbffddb08908..caf7d8d68ac0 100644
--- a/drivers/vdpa/vdpa_user/eventfd.c
+++ b/drivers/vdpa/vdpa_user/eventfd.c
@@ -18,6 +18,7 @@
 #include "eventfd.h"
 
 static struct workqueue_struct *vduse_irqfd_cleanup_wq;
+static struct workqueue_struct *vduse_irq_wq;
 
 static void vduse_virqfd_shutdown(struct work_struct *work)
 {
@@ -57,7 +58,7 @@ static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
 	__poll_t flags = key_to_poll(key);
 
 	if (flags & EPOLLIN)
-		schedule_work(&virqfd->inject);
+		queue_work(vduse_irq_wq, &virqfd->inject);
 
 	if (flags & EPOLLHUP) {
 		spin_lock(&vq->irq_lock);
@@ -165,11 +166,18 @@ int vduse_virqfd_init(void)
 	if (!vduse_irqfd_cleanup_wq)
 		return -ENOMEM;
 
+	vduse_irq_wq = alloc_workqueue("vduse-irq", WQ_SYSFS | WQ_UNBOUND, 0);
+	if (!vduse_irq_wq) {
+		destroy_workqueue(vduse_irqfd_cleanup_wq);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 void vduse_virqfd_exit(void)
 {
+	destroy_workqueue(vduse_irq_wq);
 	destroy_workqueue(vduse_irqfd_cleanup_wq);
 }
 
-- 
2.11.0

