Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4375FDCFF
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJMPTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJMPTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:39 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA07CF9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:35 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwM-00B3Aa-Lc;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 03/10] drivers/vhost: adjust vhost to flush all workers
Date:   Thu, 13 Oct 2022 18:18:32 +0300
Message-Id: <20221013151839.689700-4-andrey.zhadchenko@virtuozzo.com>
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

Make vhost_dev_flush support several workers and flush
them simultaneously

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/vhost.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40cc50c33c66..5dae8e8f8163 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -246,15 +246,19 @@ static void vhost_work_queue_at_worker(struct vhost_worker *w,
 
 void vhost_dev_flush(struct vhost_dev *dev)
 {
-	struct vhost_flush_struct flush;
+	struct vhost_flush_struct flush[VHOST_MAX_WORKERS];
+	int i, nworkers;
 
-	if (dev->workers[0].worker) {
-		init_completion(&flush.wait_event);
-		vhost_work_init(&flush.work, vhost_flush_work);
+	nworkers = READ_ONCE(dev->nworkers);
 
-		vhost_work_queue(dev, &flush.work);
-		wait_for_completion(&flush.wait_event);
+	for (i = 0; i < nworkers; i++) {
+		init_completion(&flush[i].wait_event);
+		vhost_work_init(&flush[i].work, vhost_flush_work);
+		vhost_work_queue_at_worker(&dev->workers[i], &flush[i].work);
 	}
+
+	for (i = 0; i < nworkers; i++)
+		wait_for_completion(&flush[i].wait_event);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_flush);
 
-- 
2.31.1

