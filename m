Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C30D7B5D46
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 00:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbjJBWom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 18:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjJBWol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 18:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5275B4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 15:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696286631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1awiNTJbHPwF4KLgernZOq6U4A0vnzn8In3XQ7oBM7I=;
        b=Vrjpx7IytDY/kKLoJsCVBAZHfyIF/CBLnnC04bbPB5lfWc/d94dlkkKN2sNEeeJvLB3Qpo
        KASEieKB1dMlF6xZcoLktnG/7lcHWK9qmd262DQSLt/QnkID63eX/gG3xXyFDxkxdxAxBj
        44ifT3ZYTpecqdUNAKB/Wl7Jbqz8EYI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-f6WqBdJkOfW3Y01MTBghUA-1; Mon, 02 Oct 2023 18:43:48 -0400
X-MC-Unique: f6WqBdJkOfW3Y01MTBghUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A109811E7E;
        Mon,  2 Oct 2023 22:43:48 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8E3440C6EBF;
        Mon,  2 Oct 2023 22:43:46 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucong2@kylinos.cn, yishaih@nvidia.com, brett.creeley@amd.com
Subject: [PATCH] vfio: Fix smatch errors in vfio_combine_iova_ranges()
Date:   Mon,  2 Oct 2023 16:43:25 -0600
Message-Id: <20231002224325.3150842-1-alex.williamson@redhat.com>
In-Reply-To: <20230920095532.88135-1-liucong2@kylinos.cn>
References: <20230920095532.88135-1-liucong2@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

smatch reports:

vfio_combine_iova_ranges() error: uninitialized symbol 'last'.
vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_end'.
vfio_combine_iova_ranges() error: potentially dereferencing uninitialized 'comb_start'.

These errors are only reachable via invalid input, in the case of
@last when we receive an empty rb-tree or for @comb_{start,end} if the
rb-tree is empty or otherwise fails to produce a second node that
reduces the gap.  Add tests with warnings for these cases.

Reported-by: Cong Liu <liucong2@kylinos.cn>
Link: https://lore.kernel.org/all/20230920095532.88135-1-liucong2@kylinos.cn
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..e31e1952d7b8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -946,6 +946,11 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 		unsigned long last;
 
 		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
+
+		/* Empty list */
+		if (WARN_ON_ONCE(!comb_start))
+			return;
+
 		curr = comb_start;
 		while (curr) {
 			last = curr->last;
@@ -975,6 +980,11 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
 			prev = curr;
 			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
 		}
+
+		/* Empty list or no nodes to combine */
+		if (WARN_ON_ONCE(min_gap == ULONG_MAX))
+			break;
+
 		comb_start->last = comb_end->last;
 		interval_tree_remove(comb_end, root);
 		cur_nodes--;
-- 
2.40.1

