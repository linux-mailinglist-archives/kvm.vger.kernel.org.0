Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B8A682FCB
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 15:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbjAaOx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 09:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjAaOxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 09:53:25 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2EFEF8D;
        Tue, 31 Jan 2023 06:53:20 -0800 (PST)
Received: from kwepemi100025.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4P5nxB2Hc2zJqd4;
        Tue, 31 Jan 2023 22:48:46 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 kwepemi100025.china.huawei.com (7.221.188.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 31 Jan 2023 22:53:14 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <arei.gonglei@huawei.com>, <yechuan@huawei.com>,
        <huangzhichao@huawei.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Longpeng <longpeng2@huawei.com>
Subject: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
Date:   Tue, 31 Jan 2023 22:53:10 +0800
Message-ID: <20230131145310.2069-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi100025.china.huawei.com (7.221.188.158)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

We must cleanup all memory maps when closing the vdpa fds, otherwise
some critical resources (e.g. memory, iommu map) will leaked if the
userspace exits unexpectedly (e.g. kill -9).

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 drivers/vhost/vdpa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a527eeeac637..37477cffa5aa 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
 		vhost_vdpa_remove_as(v, asid);
 }
 
+static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
+{
+	struct vhost_vdpa_as *as;
+	u32 asid;
+
+	for (asid = 0; asid < v->vdpa->nas; asid++) {
+		as = asid_to_as(v, asid);
+		if (as)
+			vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
+	}
+}
+
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
 			     struct vhost_iotlb *iotlb,
 			     u64 iova, u64 size, u64 uaddr, u32 perm)
@@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
+	vhost_vdpa_clean_map(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
-- 
2.23.0

