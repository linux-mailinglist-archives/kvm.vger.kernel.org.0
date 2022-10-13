Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074265FDCF8
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJMPTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiJMPTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:32 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF44B10F8A1
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:30 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-NW;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 04/10] drivers/vhost: rework cgroups attachment to be worker aware
Date:   Thu, 13 Oct 2022 18:18:33 +0300
Message-Id: <20221013151839.689700-5-andrey.zhadchenko@virtuozzo.com>
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

Rework vhost_attach_cgroups to manipulate specified worker.
Implement vhost_worker_flush as we need to flush specific worker.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5dae8e8f8163..e6bcb2605ee0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -262,6 +262,16 @@ void vhost_dev_flush(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_dev_flush);
 
+static void vhost_worker_flush(struct vhost_worker *w)
+{
+       struct vhost_flush_struct flush;
+
+       init_completion(&flush.wait_event);
+       vhost_work_init(&flush.work, vhost_flush_work);
+       vhost_work_queue_at_worker(w, &flush.work);
+       wait_for_completion(&flush.wait_event);
+}
+
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	struct vhost_worker *w = &dev->workers[0];
@@ -559,14 +569,14 @@ static void vhost_attach_cgroups_work(struct vhost_work *work)
 	s->ret = cgroup_attach_task_all(s->owner, current);
 }
 
-static int vhost_attach_cgroups(struct vhost_dev *dev)
+static int vhost_worker_attach_cgroups(struct vhost_worker *w)
 {
 	struct vhost_attach_cgroups_struct attach;
 
 	attach.owner = current;
 	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
-	vhost_work_queue(dev, &attach.work);
-	vhost_dev_flush(dev);
+	vhost_work_queue_at_worker(w, &attach.work);
+	vhost_worker_flush(w);
 	return attach.ret;
 }
 
@@ -634,7 +644,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 		dev->nworkers = 1;
 		wake_up_process(worker); /* avoid contributing to loadavg */
 
-		err = vhost_attach_cgroups(dev);
+		err = vhost_worker_attach_cgroups(&dev->workers[0]);
 		if (err)
 			goto err_cgroup;
 	}
-- 
2.31.1

