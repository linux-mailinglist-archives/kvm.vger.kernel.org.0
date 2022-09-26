Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEDD5E9B52
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 09:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiIZH6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 03:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiIZH6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 03:58:23 -0400
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A55EC4C;
        Mon, 26 Sep 2022 00:54:24 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id UGC00119;
        Mon, 26 Sep 2022 15:54:19 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201604.home.langchao.com (10.100.2.4) with Microsoft SMTP Server id
 15.1.2507.12; Mon, 26 Sep 2022 15:54:18 +0800
From:   Deming Wang <wangdeming@inspur.com>
To:     <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] vfio: Use filp instead of fd
Date:   Mon, 26 Sep 2022 02:54:07 -0400
Message-ID: <20220926065407.2389-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.200.104.82]
tUid:   2022926155419394452db38c06c56392253e0135b5d34
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function of kvm_vfio_group_set_spapr_tce and kvm_vfio_group_del
use fd indirectly.But,it only be used for fd.file. So,we can directly
use the struct of file instead.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 virt/kvm/vfio.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ce1b01d02c51..3be84d82f905 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -178,11 +178,11 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_group *kvg;
-	struct fd f;
+	struct file *filp;
 	int ret;
 
-	f = fdget(fd);
-	if (!f.file)
+	filp = fget(fd);
+	if (!filp)
 		return -EBADF;
 
 	ret = -ENOENT;
@@ -190,7 +190,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		if (kvg->file != f.file)
+		if (kvg->file != filp)
 			continue;
 
 		list_del(&kvg->node);
@@ -207,7 +207,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 
 	mutex_unlock(&kv->lock);
 
-	fdput(f);
+	fput(filp);
 
 	kvm_vfio_update_coherency(dev);
 
@@ -221,14 +221,14 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	struct kvm_vfio_spapr_tce param;
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_group *kvg;
-	struct fd f;
+	struct file *filp;
 	int ret;
 
 	if (copy_from_user(&param, arg, sizeof(struct kvm_vfio_spapr_tce)))
 		return -EFAULT;
 
-	f = fdget(param.groupfd);
-	if (!f.file)
+	filp = fget(param.groupfd);
+	if (!filp)
 		return -EBADF;
 
 	ret = -ENOENT;
@@ -238,13 +238,13 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	list_for_each_entry(kvg, &kv->group_list, node) {
 		struct iommu_group *grp;
 
-		if (kvg->file != f.file)
+		if (kvg->file != filp)
 			continue;
 
 		grp = kvm_vfio_file_iommu_group(kvg->file);
 		if (WARN_ON_ONCE(!grp)) {
 			ret = -EIO;
-			goto err_fdput;
+			goto err_fput;
 		}
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
@@ -252,9 +252,9 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 		break;
 	}
 
-err_fdput:
+err_fput:
 	mutex_unlock(&kv->lock);
-	fdput(f);
+	fput(filp);
 	return ret;
 }
 #endif
-- 
2.27.0

