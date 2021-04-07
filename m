Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B2D356C50
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352295AbhDGMjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:39:24 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3393 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352310AbhDGMjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 08:39:08 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FFkQg34lSz5XXB;
        Wed,  7 Apr 2021 20:36:11 +0800 (CST)
Received: from [10.174.179.84] (10.174.179.84) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 7 Apr 2021 20:38:56 +0800
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
CC:     <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <zhongbaisong@huawei.com>
From:   zhongbaisong <zhongbaisong@huawei.com>
Subject: [PATCH -next] s390/protvirt: fix error return code in uv_info_init()
Organization: huawei
Message-ID: <2f7d62a4-3e75-b2b4-951b-75ef8ef59d16@huawei.com>
Date:   Wed, 7 Apr 2021 20:38:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.84]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
---
  arch/s390/kernel/uv.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index cbfbeab57c3b..370f664580af 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -460,8 +460,10 @@ static int __init uv_info_init(void)
  		goto out_kobj;

  	uv_query_kset = kset_create_and_add("query", NULL, uv_kobj);
-	if (!uv_query_kset)
+	if (!uv_query_kset) {
+		rc = -ENOMEM;
  		goto out_ind_files;
+	}

  	rc = sysfs_create_group(&uv_query_kset->kobj, &uv_query_attr_group);
  	if (!rc)

