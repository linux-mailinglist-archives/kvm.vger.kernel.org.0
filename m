Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789D560058D
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 05:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiJQDG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Oct 2022 23:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiJQDGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Oct 2022 23:06:24 -0400
Received: from out0-149.mail.aliyun.com (out0-149.mail.aliyun.com [140.205.0.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FDA4B0E2;
        Sun, 16 Oct 2022 20:06:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047204;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---.PeQJoS4_1665975971;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PeQJoS4_1665975971)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 11:06:12 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: debugfs: Return retval of simple_attr_open() if it fails
Date:   Mon, 17 Oct 2022 11:06:10 +0800
Message-Id: <69d64d93accd1f33691b8a383ae555baee80f943.1665975828.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <5ddb7c97d2f1edbd000020aa842b0619374e6951.1665975828.git.houwenlong.hwl@antgroup.com>
References: <5ddb7c97d2f1edbd000020aa842b0619374e6951.1665975828.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although simple_attr_open() fails only with -ENOMEM with current code
base, it would be nicer to return retval of simple_attr_open() directly
in kvm_debugfs_open().

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 virt/kvm/kvm_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4ecfa5..f7b06c1e8827 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5398,6 +5398,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 			   int (*get)(void *, u64 *), int (*set)(void *, u64),
 			   const char *fmt)
 {
+	int ret;
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
 					  inode->i_private;
 
@@ -5409,15 +5410,13 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get,
-		    kvm_stats_debugfs_mode(stat_data->desc) & 0222
-		    ? set : NULL,
-		    fmt)) {
+	ret = simple_attr_open(inode, file, get,
+			       kvm_stats_debugfs_mode(stat_data->desc) & 0222
+			       ? set : NULL, fmt);
+	if (ret)
 		kvm_put_kvm(stat_data->kvm);
-		return -ENOMEM;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int kvm_debugfs_release(struct inode *inode, struct file *file)
-- 
2.31.1

