Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BBCA7D6E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 10:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfIDIP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 04:15:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfIDIP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 04:15:26 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 45B61153C0B3115A301A;
        Wed,  4 Sep 2019 16:15:24 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 16:15:17 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <linux-s390@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] vfio-ccw: fix error return code in vfio_ccw_sch_init()
Date:   Wed, 4 Sep 2019 08:33:15 +0000
Message-ID: <20190904083315.105600-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix to return negative error code -ENOMEM from the memory alloc failed
error handling case instead of 0, as done elsewhere in this function.

Fixes: 60e05d1cf087 ("vfio-ccw: add some logging")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 45e792f6afd0..e401a3d0aa57 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -317,15 +317,19 @@ static int __init vfio_ccw_sch_init(void)
 					sizeof(struct ccw_io_region), 0,
 					SLAB_ACCOUNT, 0,
 					sizeof(struct ccw_io_region), NULL);
-	if (!vfio_ccw_io_region)
+	if (!vfio_ccw_io_region) {
+		ret = -ENOMEM;
 		goto out_err;
+	}
 
 	vfio_ccw_cmd_region = kmem_cache_create_usercopy("vfio_ccw_cmd_region",
 					sizeof(struct ccw_cmd_region), 0,
 					SLAB_ACCOUNT, 0,
 					sizeof(struct ccw_cmd_region), NULL);
-	if (!vfio_ccw_cmd_region)
+	if (!vfio_ccw_cmd_region) {
+		ret = -ENOMEM;
 		goto out_err;
+	}
 
 	isc_register(VFIO_CCW_ISC);
 	ret = css_driver_register(&vfio_ccw_sch_driver);



