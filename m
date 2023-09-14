Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB9B79FFB6
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbjINJKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237228AbjINJJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:09:40 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8412139;
        Thu, 14 Sep 2023 02:09:01 -0700 (PDT)
X-UUID: 1c10806fc6a2477797bbdc4a75863193-20230914
X-CID-O-RULE: Release_Ham
X-CID-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.31,REQID:c6b0fdcc-ab64-4c5c-8592-8d6db75f07b6,IP:10,
        URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:-5
X-CID-INFO: VERSION:1.1.31,REQID:c6b0fdcc-ab64-4c5c-8592-8d6db75f07b6,IP:10,UR
        L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:0ad78a4,CLOUDID:b2eaee13-4929-4845-9571-38c601e9c3c9,B
        ulkID:230914170851LIPAIP83,BulkQuantity:0,Recheck:0,SF:38|24|17|19|44|102,
        TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
        ,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 1c10806fc6a2477797bbdc4a75863193-20230914
X-User: liucong2@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw
        (envelope-from <liucong2@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 901895803; Thu, 14 Sep 2023 17:08:50 +0800
From:   Cong Liu <liucong2@kylinos.cn>
To:     jgg@ziepe.ca, Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucong2@kylinos.cn
Subject: [PATCH v2] vfio: Fix uninitialized symbol and potential dereferencing errors in vfio_combine_iova_ranges
Date:   Thu, 14 Sep 2023 17:08:39 +0800
Message-Id: <20230914090839.196314-1-liucong2@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZQGs6F5y3YzlAJaL@ziepe.ca>
References: <ZQGs6F5y3YzlAJaL@ziepe.ca>
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
 drivers/vfio/vfio_main.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..96d2f3030ebb 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -938,14 +938,17 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
+		if (!comb_start)
+			return;
 		curr = comb_start;
 		while (curr) {
 			last = curr->last;
@@ -963,6 +966,10 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 		prev = NULL;
 		min_gap = ULONG_MAX;
 		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
+		if (!curr) {
+			/* No more ranges to combine */
+			break;
+		}
 		while (curr) {
 			if (prev) {
 				curr_gap = curr->start - prev->last;
@@ -975,6 +982,10 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			prev = curr;
 			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
 		}
+		if (!comb_start || !comb_end) {
+			/* No more ranges to combine */
+			break;
+		}
 		comb_start->last = comb_end->last;
 		interval_tree_remove(comb_end, root);
 		cur_nodes--;
-- 
2.34.1
While this may seem somewhat verbose, I am unsure how to refactor this function.
