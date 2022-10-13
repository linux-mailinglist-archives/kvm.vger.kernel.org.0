Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F455FDD03
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJMPTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJMPTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:46 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76ADF4A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:41 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-V5;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 08/10] drivers/vhost: add API to queue work at virtqueue's worker
Date:   Thu, 13 Oct 2022 18:18:37 +0300
Message-Id: <20221013151839.689700-9-andrey.zhadchenko@virtuozzo.com>
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

Add routines to queue works on virtqueue assigned workers

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 22 ++++++++++++++++++++++
 drivers/vhost/vhost.h |  5 +++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d80831d21fba..fbf5fae1a6bf 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -272,6 +272,17 @@ static void vhost_worker_flush(struct vhost_worker *w)
        wait_for_completion(&flush.wait_event);
 }
 
+void vhost_work_flush_vq(struct vhost_virtqueue *vq)
+{
+       struct vhost_worker *w = READ_ONCE(vq->worker);
+
+       if (!w)
+               return;
+
+       vhost_worker_flush(w);
+}
+EXPORT_SYMBOL_GPL(vhost_work_flush_vq);
+
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	struct vhost_worker *w = &dev->workers[0];
@@ -283,6 +294,17 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 }
 EXPORT_SYMBOL_GPL(vhost_work_queue);
 
+void vhost_work_vqueue(struct vhost_virtqueue *vq, struct vhost_work *work)
+{
+       struct vhost_worker *w = READ_ONCE(vq->worker);
+
+       if (!w)
+               return;
+
+       vhost_work_queue_at_worker(w, work);
+}
+EXPORT_SYMBOL_GPL(vhost_work_vqueue);
+
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b9a10c85b298..bedf8b9d99de 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -141,6 +141,11 @@ struct vhost_virtqueue {
 	struct vhost_worker *worker;
 };
 
+/* Queue the work on virtqueue assigned worker */
+void vhost_work_vqueue(struct vhost_virtqueue *vq, struct vhost_work *work);
+/* Flush virtqueue assigned worker */
+void vhost_work_flush_vq(struct vhost_virtqueue *vq);
+
 struct vhost_msg_node {
   union {
 	  struct vhost_msg msg;
-- 
2.31.1

