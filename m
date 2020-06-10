Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7617B1F50B9
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 11:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgFJJBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 05:01:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51298 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgFJJBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 05:01:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A8udnF120664;
        Wed, 10 Jun 2020 09:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=UzV7BGBI0LNcf2w3aD2vO/2rGl64hgFteuySfYtV4YM=;
 b=mFt9tzzp2LD1ykbmhrFfb6U9M/TYw9CygDYESgzwZupwQY9ASDDjDLOFSkJUJE0E9RkO
 2W7TCRBs65A1b6+x7Z5Cdej3k4+XVcTlk4ePQPKG8IVxRu0A/3yrwvYblCBibnKAW61e
 gD9SObkOE4+loSoCk03YEAxiG8Pw1ZB+OcdSzfS09O8E1Ax7MmnWobJp/EjOU1cJAlgC
 0vhwbMBB4MqILg5j24tuwO9evkiMhJXe6rAAkbCSxVthjhe16c6/UfIC6CDfxvu74Oid
 IXYpwS/OHMCzZ7vOx18VPqUd5RK7zRnUUp+Wr2nSKEDjXT74FnUM1Gbw6X91AKmGE6da aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31g3sn14y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 09:01:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A8vjnp053786;
        Wed, 10 Jun 2020 08:59:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31gn2y4d36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 08:59:00 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05A8wxpC013936;
        Wed, 10 Jun 2020 08:58:59 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jun 2020 01:58:59 -0700
Date:   Wed, 10 Jun 2020 11:58:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] vhost_vdpa: Fix potential underflow in vhost_vdpa_mmap()
Message-ID: <20200610085852.GB5439@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "vma->vm_pgoff" variable is an unsigned long so if it's larger than
INT_MAX then "index" can be negative leading to an underflow.  Fix this
by changing the type of "index" to "unsigned long".

Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7580e34f76c10..a54b60d6623f0 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -818,7 +818,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vdpa_notification_area notify;
-	int index = vma->vm_pgoff;
+	unsigned long index = vma->vm_pgoff;
 
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 		return -EINVAL;
-- 
2.26.2

