Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7C7816C4
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 04:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbjHSClJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 22:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244190AbjHSCkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 22:40:40 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06EE3AB2;
        Fri, 18 Aug 2023 19:40:38 -0700 (PDT)
Received: from dggpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RSNH45yJrz1L972;
        Sat, 19 Aug 2023 10:39:12 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 19 Aug 2023 10:40:36 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 19 Aug
 2023 10:40:35 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <brett.creeley@amd.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <horms@kernel.org>,
        <shannon.nelson@amd.com>, <yangyingliang@huawei.com>
Subject: [PATCH -next] vfio/pds: fix return value in pds_vfio_get_lm_file()
Date:   Sat, 19 Aug 2023 10:37:16 +0800
Message-ID: <20230819023716.3469037-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

anon_inode_getfile() never returns NULL pointer, it will return
ERR_PTR() when it fails, so replace the check with IS_ERR().

Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/vfio/pci/pds/lm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index aec75574cab3..79fe2e66bb49 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -31,7 +31,7 @@ pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
 	/* Create file */
 	lm_file->filep =
 		anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
-	if (!lm_file->filep)
+	if (IS_ERR(lm_file->filep))
 		goto out_free_file;
 
 	stream_open(lm_file->filep->f_inode, lm_file->filep);
-- 
2.25.1

