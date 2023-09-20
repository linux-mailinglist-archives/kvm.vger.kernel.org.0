Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B17A781E
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 11:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbjITJ4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 05:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbjITJz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 05:55:58 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754721B3;
        Wed, 20 Sep 2023 02:55:47 -0700 (PDT)
X-UUID: 0bea6bdbf676477594dbdb467c0d0cce-20230920
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:c739c935-0a34-4e37-b716-d03d5eeb1586,IP:15,
        URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,AC
        TION:release,TS:-25
X-CID-INFO: VERSION:1.1.31,REQID:c739c935-0a34-4e37-b716-d03d5eeb1586,IP:15,UR
        L:0,TC:0,Content:-25,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:-25
X-CID-META: VersionHash:0ad78a4,CLOUDID:5fb53fc3-1e57-4345-9d31-31ad9818b39f,B
        ulkID:230920175539TGB7N2JL,BulkQuantity:0,Recheck:0,SF:24|17|19|44|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 0bea6bdbf676477594dbdb467c0d0cce-20230920
X-User: liucong2@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <liucong2@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1044669435; Wed, 20 Sep 2023 17:55:37 +0800
From:   Cong Liu <liucong2@kylinos.cn>
To:     alex.williamson@redhat.com
Cc:     jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucong2@kylinos.cn
Subject: [PATCH v3] vfio: Fix uninitialized symbol and potential dereferencing errors in vfio_combine_iova_ranges
Date:   Wed, 20 Sep 2023 17:55:31 +0800
Message-Id: <20230920095532.88135-1-liucong2@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230919120456.1a68dc4d.alex.williamson@redhat.com>
References: <20230919120456.1a68dc4d.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when compiling with smatch check, the following errors were encountered:

drivers/vfio/vfio_main.c:957 vfio_combine_iova_ranges() error: uninitialized symbol 'last'.
drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_end'.
drivers/vfio/vfio_main.c:978 vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_start'.

This patch initializes the variables last, comb_end, and comb_start
to avoid compiler warnings and add proper argument checks to ensure
interval_tree_iter_first() does not return NULL.

Signed-off-by: Cong Liu <liucong2@kylinos.cn>
---
 drivers/vfio/vfio_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..ecd4dd8e6b05 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -938,12 +938,17 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			      u32 req_nodes)
 {
-	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	if (!cur_nodes || cur_nodes <= req_nodes ||
+		WARN_ON(!req_nodes || !root->rb_root.rb_node))
+		return;
+
+	struct interval_tree_node *prev, *curr;
+	struct interval_tree_node *comb_start = NULL, *comb_end = NULL;
 	unsigned long min_gap, curr_gap;
 
 	/* Special shortcut when a single range is required */
 	if (req_nodes == 1) {
-		unsigned long last;
+		unsigned long last = 0;
 
 		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
 		curr = comb_start;
-- 
2.34.1

