Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021C52CB536
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 07:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgLBGpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 01:45:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39260 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgLBGpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 01:45:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B26P3xj143335;
        Wed, 2 Dec 2020 06:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=EQ5e48qxUz457ErMWHJa1v5YZ7dfBdW+/4iHFac2dJk=;
 b=F2lOXEXvsJ4bKaK7YorAUdplmflz4xaNofiHseI9GT2nYJvAXzONkjACQEpzDDIU/zZ2
 fEtZNtlMRxWpgyresjK9u5Swa61WLHs2Yb9KILtngo/0Uj8K4a1eKF1i7SobyxA9NjNa
 EwPoN7Uj+riIX8n0+aglQt4tVOoQkYgA5vKgRgchHg6THv9xakCaQl1UJoX4cE5JPP3h
 IX9yaId+s9CXkWOuBrwKeoJ9UBFlbBPLngqfuDGaOB3SD4kEoPyLrVy54yvdQ60Bu7hk
 PA2ae2cBidEZguzm0ogOmIDNhlwRmeEz7LWf4MI65lLpviWy2Ibhqm8rJO2M3s4jIjhx 0g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2axn1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 06:44:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B26QQeh006726;
        Wed, 2 Dec 2020 06:44:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35404nvk2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 06:44:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B26indX021012;
        Wed, 2 Dec 2020 06:44:50 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 22:44:49 -0800
Date:   Wed, 2 Dec 2020 09:44:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] vhost_vdpa: return -EFAULT if copy_to_user() fails
Message-ID: <X8c32z5EtDsMyyIL@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020039
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The copy_to_user() function returns the number of bytes remaining to be
copied but this should return -EFAULT to the user.

Fixes: 1b48dc03e575 ("vhost: vdpa: report iova range")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vhost/vdpa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d6a37b66770b..ef688c8c0e0e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -344,7 +344,9 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
 		.last = v->range.last,
 	};
 
-	return copy_to_user(argp, &range, sizeof(range));
+	if (copy_to_user(argp, &range, sizeof(range)))
+		return -EFAULT;
+	return 0;
 }
 
 static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
-- 
2.29.2

