Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B324E5FDD02
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJMPTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJMPTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:39 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6DDC7D
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:36 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwN-00B3Aa-0Z;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 09/10] drivers/vhost: allow polls to be bound to workers via vqs
Date:   Thu, 13 Oct 2022 18:18:38 +0300
Message-Id: <20221013151839.689700-10-andrey.zhadchenko@virtuozzo.com>
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

Allow vhost polls to be associated with vqs so we can queue them
on assigned workers.
If polls are not associated with specific vqs queue them on the first
virtqueue.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 24 ++++++++++++++++--------
 drivers/vhost/vhost.h |  4 +++-
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index fbf5fae1a6bf..9c35908ebc4f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -170,7 +170,7 @@ static int vhost_poll_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync,
 	if (!(key_to_poll(key) & poll->mask))
 		return 0;
 
-	if (!poll->dev->use_worker)
+	if (!poll->vq->dev->use_worker)
 		work->fn(work);
 	else
 		vhost_poll_queue(poll);
@@ -185,19 +185,27 @@ void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn)
 }
 EXPORT_SYMBOL_GPL(vhost_work_init);
 
-/* Init poll structure */
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev)
+{
+       vhost_poll_init_vq(poll, fn, mask, dev->vqs[0]);
+}
+EXPORT_SYMBOL_GPL(vhost_poll_init);
+
+
+/* Init poll structure */
+void vhost_poll_init_vq(struct vhost_poll *poll, vhost_work_fn_t fn,
+                    __poll_t mask, struct vhost_virtqueue *vq)
 {
 	init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
 	init_poll_funcptr(&poll->table, vhost_poll_func);
 	poll->mask = mask;
-	poll->dev = dev;
+	poll->vq = vq;
 	poll->wqh = NULL;
 
 	vhost_work_init(&poll->work, fn);
 }
-EXPORT_SYMBOL_GPL(vhost_poll_init);
+EXPORT_SYMBOL_GPL(vhost_poll_init_vq);
 
 /* Start polling a file. We add ourselves to file's wait queue. The caller must
  * keep a reference to a file until after vhost_poll_stop is called. */
@@ -314,7 +322,7 @@ EXPORT_SYMBOL_GPL(vhost_has_work);
 
 void vhost_poll_queue(struct vhost_poll *poll)
 {
-	vhost_work_queue(poll->dev, &poll->work);
+	vhost_work_vqueue(poll->vq, &poll->work);
 }
 EXPORT_SYMBOL_GPL(vhost_poll_queue);
 
@@ -564,8 +572,8 @@ void vhost_dev_init(struct vhost_dev *dev,
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
-			vhost_poll_init(&vq->poll, vq->handle_kick,
-					EPOLLIN, dev);
+			vhost_poll_init_vq(&vq->poll, vq->handle_kick,
+					EPOLLIN, vq);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_dev_init);
@@ -1837,7 +1845,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	mutex_unlock(&vq->mutex);
 
 	if (pollstop && vq->handle_kick)
-		vhost_dev_flush(vq->poll.dev);
+		vhost_dev_flush(d);
 	return r;
 }
 EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bedf8b9d99de..fd0943de4d4f 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -40,7 +40,7 @@ struct vhost_poll {
 	wait_queue_entry_t	wait;
 	struct vhost_work	work;
 	__poll_t		mask;
-	struct vhost_dev	*dev;
+	struct vhost_virtqueue	*vq;
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
@@ -49,6 +49,8 @@ bool vhost_has_work(struct vhost_dev *dev);
 
 void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 		     __poll_t mask, struct vhost_dev *dev);
+void vhost_poll_init_vq(struct vhost_poll *poll, vhost_work_fn_t fn,
+		     __poll_t mask, struct vhost_virtqueue *vq);
 int vhost_poll_start(struct vhost_poll *poll, struct file *file);
 void vhost_poll_stop(struct vhost_poll *poll);
 void vhost_poll_queue(struct vhost_poll *poll);
-- 
2.31.1

