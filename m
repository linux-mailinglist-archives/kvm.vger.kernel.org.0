Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E215FDD01
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJMPTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 11:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiJMPTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 11:19:39 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68031112AB5
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 08:19:35 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oizwN-00B3Aa-2N;
        Thu, 13 Oct 2022 17:18:57 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     virtualization@lists.linux-foundation.org
Cc:     andrey.zhadchenko@virtuozzo.com, mst@redhat.com,
        jasonwang@redhat.com, kvm@vger.kernel.org, stefanha@redhat.com,
        sgarzare@redhat.com, den@virtuozzo.com, ptikhomirov@virtuozzo.com
Subject: [RFC PATCH v2 10/10] drivers/vhost: queue vhost_blk works at vq workers
Date:   Thu, 13 Oct 2022 18:18:39 +0300
Message-Id: <20221013151839.689700-11-andrey.zhadchenko@virtuozzo.com>
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

Update vhost_blk to queue works on virtqueue workers. Together
with previous changes this allows us to split virtio blk requests
across several threads.

                        | randread, IOPS | randwrite, IOPS |
8vcpu, 1 kernel worker  |      576k      |      575k       |
8vcpu, 2 kernel workers |      803k      |      779k       |

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 drivers/vhost/blk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
index 42acdef452b3..f7db891ee985 100644
--- a/drivers/vhost/blk.c
+++ b/drivers/vhost/blk.c
@@ -161,13 +161,12 @@ static inline int vhost_blk_set_status(struct vhost_blk_req *req, u8 status)
 static void vhost_blk_req_done(struct bio *bio)
 {
 	struct vhost_blk_req *req = bio->bi_private;
-	struct vhost_blk *blk = req->blk;
 
 	req->bio_err = blk_status_to_errno(bio->bi_status);
 
 	if (atomic_dec_and_test(&req->bio_nr)) {
 		llist_add(&req->llnode, &req->blk_vq->llhead);
-		vhost_work_queue(&blk->dev, &req->blk_vq->work);
+		vhost_work_vqueue(&req->blk_vq->vq, &req->blk_vq->work);
 	}
 
 	bio_put(bio);
-- 
2.31.1

