Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324BF5FDCFB
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJMPTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJMPTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:32 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6C611E45A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:30 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-Jg;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 02/10] drivers/vhost: use array to store workers
Date:   Thu, 13 Oct 2022 18:18:31 +0300
Message-Id: <20221013151839.689700-3-andrey.zhadchenko@virtuozzo.com>
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

We want to support several vhost workers. The first step is to
rework vhost to use array of workers rather than single pointer.
Update creation and cleanup routines.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 75 +++++++++++++++++++++++++++++++------------
 drivers/vhost/vhost.h | 10 +++++-
 2 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..40cc50c33c66 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -231,11 +231,24 @@ void vhost_poll_stop(struct vhost_poll *poll)
 }
 EXPORT_SYMBOL_GPL(vhost_poll_stop);
 
+static void vhost_work_queue_at_worker(struct vhost_worker *w,
+				       struct vhost_work *work)
+{
+	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
+		/* We can only add the work to the list after we're
+		 * sure it was not in the list.
+		 * test_and_set_bit() implies a memory barrier.
+		 */
+		llist_add(&work->node, &w->work_list);
+		wake_up_process(w->worker);
+	}
+}
+
 void vhost_dev_flush(struct vhost_dev *dev)
 {
 	struct vhost_flush_struct flush;
 
-	if (dev->worker) {
+	if (dev->workers[0].worker) {
 		init_completion(&flush.wait_event);
 		vhost_work_init(&flush.work, vhost_flush_work);
 
@@ -247,17 +260,12 @@ EXPORT_SYMBOL_GPL(vhost_dev_flush);
 
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
-	if (!dev->worker)
+	struct vhost_worker *w = &dev->workers[0];
+
+	if (!w->worker)
 		return;
 
-	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
-		/* We can only add the work to the list after we're
-		 * sure it was not in the list.
-		 * test_and_set_bit() implies a memory barrier.
-		 */
-		llist_add(&work->node, &dev->work_list);
-		wake_up_process(dev->worker);
-	}
+	vhost_work_queue_at_worker(w, work);
 }
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
@@ -333,9 +341,29 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	__vhost_vq_meta_reset(vq);
 }
 
+static void vhost_worker_reset(struct vhost_worker *w)
+{
+	init_llist_head(&w->work_list);
+	w->worker = NULL;
+}
+
+void vhost_cleanup_workers(struct vhost_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->nworkers; ++i) {
+		WARN_ON(!llist_empty(&dev->workers[i].work_list));
+		kthread_stop(dev->workers[i].worker);
+		vhost_worker_reset(&dev->workers[i]);
+	}
+
+	dev->nworkers = 0;
+}
+
 static int vhost_worker(void *data)
 {
-	struct vhost_dev *dev = data;
+	struct vhost_worker *w = data;
+	struct vhost_dev *dev = w->dev;
 	struct vhost_work *work, *work_next;
 	struct llist_node *node;
 
@@ -350,7 +378,7 @@ static int vhost_worker(void *data)
 			break;
 		}
 
-		node = llist_del_all(&dev->work_list);
+		node = llist_del_all(&w->work_list);
 		if (!node)
 			schedule();
 
@@ -473,7 +501,6 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -485,6 +512,11 @@ void vhost_dev_init(struct vhost_dev *dev,
 	INIT_LIST_HEAD(&dev->pending_list);
 	spin_lock_init(&dev->iotlb_lock);
 
+	dev->nworkers = 0;
+	for (i = 0; i < VHOST_MAX_WORKERS; ++i) {
+		dev->workers[i].dev = dev;
+		vhost_worker_reset(&dev->workers[i]);
+	}
 
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
@@ -594,7 +626,8 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 			goto err_worker;
 		}
 
-		dev->worker = worker;
+		dev->workers[0].worker = worker;
+		dev->nworkers = 1;
 		wake_up_process(worker); /* avoid contributing to loadavg */
 
 		err = vhost_attach_cgroups(dev);
@@ -608,9 +641,10 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 
 	return 0;
 err_cgroup:
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
+	dev->nworkers = 0;
+	if (dev->workers[0].worker) {
+		kthread_stop(dev->workers[0].worker);
+		dev->workers[0].worker = NULL;
 	}
 err_worker:
 	vhost_detach_mm(dev);
@@ -693,6 +727,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 			eventfd_ctx_put(dev->vqs[i]->call_ctx.ctx);
 		vhost_vq_reset(dev, dev->vqs[i]);
 	}
+
 	vhost_dev_free_iovecs(dev);
 	if (dev->log_ctx)
 		eventfd_ctx_put(dev->log_ctx);
@@ -704,10 +739,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->iotlb = NULL;
 	vhost_clear_msg(dev);
 	wake_up_interruptible_poll(&dev->wait, EPOLLIN | EPOLLRDNORM);
-	WARN_ON(!llist_empty(&dev->work_list));
-	if (dev->worker) {
-		kthread_stop(dev->worker);
-		dev->worker = NULL;
+	if (dev->use_worker) {
+		vhost_cleanup_workers(dev);
 		dev->kcov_handle = 0;
 	}
 	vhost_detach_mm(dev);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107af08..fc365b08fc38 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -25,6 +25,13 @@ struct vhost_work {
 	unsigned long		flags;
 };
 
+#define VHOST_MAX_WORKERS 4
+struct vhost_worker {
+	struct task_struct *worker;
+	struct llist_head work_list;
+	struct vhost_dev *dev;
+};
+
 /* Poll a file (eventfd or socket) */
 /* Note: there's nothing vhost specific about this structure. */
 struct vhost_poll {
@@ -148,7 +155,8 @@ struct vhost_dev {
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
 	struct llist_head work_list;
-	struct task_struct *worker;
+	struct vhost_worker workers[VHOST_MAX_WORKERS];
+	int nworkers;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;
-- 
2.31.1

