Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEBE7996B0
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 09:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbjIIHKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Sep 2023 03:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245437AbjIIHKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Sep 2023 03:10:04 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCA61BFF
        for <kvm@vger.kernel.org>; Sat,  9 Sep 2023 00:10:00 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RjPFf5q41z1M96X;
        Sat,  9 Sep 2023 15:08:06 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 9 Sep
 2023 15:09:57 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <kvm@vger.kernel.org>, <kwankhede@nvidia.com>, <kraxel@redhat.com>,
        <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH 3/3] vfio/mbochs: Fix the null-ptr-deref bug in mbochs_dev_init()
Date:   Sat, 9 Sep 2023 15:09:52 +0800
Message-ID: <20230909070952.80081-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230909070952.80081-1-ruanjinjie@huawei.com>
References: <20230909070952.80081-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if kstrdup() fails in kobject_set_name_varg() in dev_set_name(), the
strchr() in kobject_add() of device_add() will cause null-ptr-deref below.
So check the err of dev_set_name().

Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 samples/vfio-mdev/mbochs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 3764d1911b51..b7f8518cd48a 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1430,7 +1430,9 @@ static int __init mbochs_dev_init(void)
 	}
 	mbochs_dev.class = mbochs_class;
 	mbochs_dev.release = mbochs_device_release;
-	dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
+	ret = dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
+	if (ret)
+		goto err_put;
 
 	ret = device_register(&mbochs_dev);
 	if (ret)
-- 
2.34.1

