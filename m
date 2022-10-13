Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665035FDCF9
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJMPTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJMPTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:31 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF88B11D986
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:30 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-T7;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 07/10] drivers/vhost: assign workers to virtqueues
Date:   Thu, 13 Oct 2022 18:18:36 +0300
Message-Id: <20221013151839.689700-8-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
References: <20221013151839.689700-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add worker pointer to every virtqueue. Add routine to assing
workers to virtqueues and call it after any worker creation

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 14 ++++++++++++++
 drivers/vhost/vhost.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 09e3c4b1bd05..d80831d21fba 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -353,6 +353,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->iotlb = NULL;
 	vhost_vring_call_reset(&vq->call_ctx);
 	__vhost_vq_meta_reset(vq);
+	vq->worker = NULL;
 }
 
 static void vhost_worker_reset(struct vhost_worker *w)
@@ -667,6 +668,17 @@ static int vhost_set_workers(struct vhost_dev *dev, int n)
 	return ret;
 }
 
+static void vhost_assign_workers(struct vhost_dev *dev)
+{
+	int i, j = 0;
+
+	for (i = 0; i < dev->nvqs; i++) {
+		dev->vqs[i]->worker = &dev->workers[j];
+		if (++j == dev->nworkers)
+			j = 0;
+	}
+}
+
 /* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
@@ -689,6 +701,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	if (err)
 		goto err_worker;
 
+	vhost_assign_workers(dev);
 	return 0;
 err_worker:
 	vhost_cleanup_workers(dev);
@@ -1907,6 +1920,7 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 		}
 
 		r = vhost_set_workers(d, n);
+		vhost_assign_workers(d);
 		break;
 	default:
 		r = -ENOIOCTLCMD;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index fc365b08fc38..b9a10c85b298 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -137,6 +137,8 @@ struct vhost_virtqueue {
 	bool user_be;
 #endif
 	u32 busyloop_timeout;
+
+	struct vhost_worker *worker;
 };
 
 struct vhost_msg_node {
-- 
2.31.1

