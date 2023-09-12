Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5419079C1C5
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 03:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbjILBk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 21:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbjILBki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 21:40:38 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2F71F3A05;
        Mon, 11 Sep 2023 18:17:53 -0700 (PDT)
X-UUID: fd1f1503926f43ed813b6d93c41cccfd-20230912
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:2163a5a7-a836-4095-9297-32296930c1c8,IP:5,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:-15
X-CID-INFO: VERSION:1.1.31,REQID:2163a5a7-a836-4095-9297-32296930c1c8,IP:5,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-15
X-CID-META: VersionHash:0ad78a4,CLOUDID:e815b8be-14cc-44ca-b657-2d2783296e72,B
        ulkID:2309111741135Y7Z3OCS,BulkQuantity:2,Recheck:0,SF:24|17|19|44|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI
        :0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-UUID: fd1f1503926f43ed813b6d93c41cccfd-20230912
X-User: liucong2@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <liucong2@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1067619403; Tue, 12 Sep 2023 09:07:38 +0800
From:   Cong Liu <liucong2@kylinos.cn>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucong2@kylinos.cn
Subject: [PATCH] fix build error in function vfio_combine_iova_ranges
Date:   Tue, 12 Sep 2023 09:07:36 +0800
Message-Id: <20230912010736.19481-1-liucong2@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911124431.5e09f53b.alex.williamson@redhat.com>
References: <20230911124431.5e09f53b.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 40732e8ed4c6..68a0a5081161 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -938,12 +938,13 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			      u32 req_nodes)
 {
-	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
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

I'm very sorry, I compiled the code on another machine and then copied the wrong patch.
