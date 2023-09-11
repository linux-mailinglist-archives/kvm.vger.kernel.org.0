Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157C579B5C7
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjIKUrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbjIKJlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:41:32 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97584FD;
        Mon, 11 Sep 2023 02:41:24 -0700 (PDT)
X-UUID: 8088b58ee61d4d0490327a99affca73d-20230911
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:316025f9-2973-41d4-90df-6fb23f8d9b2a,IP:5,U
        RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:16
X-CID-INFO: VERSION:1.1.31,REQID:316025f9-2973-41d4-90df-6fb23f8d9b2a,IP:5,URL
        :0,TC:0,Content:-5,EDM:25,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:16
X-CID-META: VersionHash:0ad78a4,CLOUDID:ed74b2be-14cc-44ca-b657-2d2783296e72,B
        ulkID:2309111741135Y7Z3OCS,BulkQuantity:0,Recheck:0,SF:24|17|19|43|102,TC:
        nil,Content:0,EDM:5,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
        :0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-UUID: 8088b58ee61d4d0490327a99affca73d-20230911
X-User: liucong2@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <liucong2@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1026707665; Mon, 11 Sep 2023 17:41:11 +0800
From:   Cong Liu <liucong2@kylinos.cn>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cong Liu <liucong2@kylinos.cn>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix build error in function vfio_combine_iova_ranges
Date:   Mon, 11 Sep 2023 17:41:02 +0800
Message-Id: <20230911094103.57771-1-liucong2@kylinos.cn>
X-Mailer: git-send-email 2.34.1
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

this patch fix these error.

Signed-off-by: Cong Liu <liucong2@kylinos.cn>
---
 drivers/vfio/vfio_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..0a9620409696 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -938,12 +938,13 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			      u32 req_nodes)
 {
-	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	struct interval_tree_node *prev, *curr;
+	struct interval_tree_node *comb_start, *comb_end;
 	unsigned long min_gap, curr_gap;
 
 	/* Special shortcut when a single range is required */
 	if (req_nodes == 1) {
-		unsigned long last;
+		unsigned long last = 0;
 
 		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
 		curr = comb_start;
-- 
2.34.1

