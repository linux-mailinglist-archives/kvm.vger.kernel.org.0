Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808905FDCFC
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJMPTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJMPTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:33 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E40111D9A0
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:30 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-PP;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 05/10] drivers/vhost: rework worker creation
Date:   Thu, 13 Oct 2022 18:18:34 +0300
Message-Id: <20221013151839.689700-6-andrey.zhadchenko@virtuozzo.com>
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

Add function to create a vhost worker and add it into the device.
Rework vhost_dev_set_owner

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 68 +++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index e6bcb2605ee0..219ad453ca27 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -617,53 +617,65 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
-/* Caller should have device mutex */
-long vhost_dev_set_owner(struct vhost_dev *dev)
+static int vhost_add_worker(struct vhost_dev *dev)
 {
+	struct vhost_worker *w = &dev->workers[dev->nworkers];
 	struct task_struct *worker;
 	int err;
 
+	if (dev->nworkers == VHOST_MAX_WORKERS)
+		return -E2BIG;
+
+	worker = kthread_create(vhost_worker, w,
+				"vhost-%d-%d", current->pid, dev->nworkers);
+	if (IS_ERR(worker))
+		return PTR_ERR(worker);
+
+	w->worker = worker;
+	wake_up_process(worker); /* avoid contributing to loadavg */
+
+	err = vhost_worker_attach_cgroups(w);
+	if (err)
+		goto cleanup;
+
+	dev->nworkers++;
+	return 0;
+
+cleanup:
+	kthread_stop(worker);
+	w->worker = NULL;
+
+	return err;
+}
+
+/* Caller should have device mutex */
+long vhost_dev_set_owner(struct vhost_dev *dev)
+{
+	int err;
+
 	/* Is there an owner already? */
-	if (vhost_dev_has_owner(dev)) {
-		err = -EBUSY;
-		goto err_mm;
-	}
+	if (vhost_dev_has_owner(dev))
+		return -EBUSY;
 
 	vhost_attach_mm(dev);
 
 	dev->kcov_handle = kcov_common_handle();
 	if (dev->use_worker) {
-		worker = kthread_create(vhost_worker, dev,
-					"vhost-%d", current->pid);
-		if (IS_ERR(worker)) {
-			err = PTR_ERR(worker);
-			goto err_worker;
-		}
-
-		dev->workers[0].worker = worker;
-		dev->nworkers = 1;
-		wake_up_process(worker); /* avoid contributing to loadavg */
-
-		err = vhost_worker_attach_cgroups(&dev->workers[0]);
+		err = vhost_add_worker(dev);
 		if (err)
-			goto err_cgroup;
+			goto err_mm;
 	}
 
 	err = vhost_dev_alloc_iovecs(dev);
 	if (err)
-		goto err_cgroup;
+		goto err_worker;
 
 	return 0;
-err_cgroup:
-	dev->nworkers = 0;
-	if (dev->workers[0].worker) {
-		kthread_stop(dev->workers[0].worker);
-		dev->workers[0].worker = NULL;
-	}
 err_worker:
-	vhost_detach_mm(dev);
-	dev->kcov_handle = 0;
+	vhost_cleanup_workers(dev);
 err_mm:
+	vhost_detach_mm(dev);
+	dev->kcov_handle = 0;
 	return err;
 }
 EXPORT_SYMBOL_GPL(vhost_dev_set_owner);
-- 
2.31.1

