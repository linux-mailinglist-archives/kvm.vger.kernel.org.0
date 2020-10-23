Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327A8296DC5
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 13:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463085AbgJWLfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 07:35:37 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44820 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463005AbgJWLfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 07:35:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NBZBam038615;
        Fri, 23 Oct 2020 11:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=MZC7JzA0X48T2AyIDafeWsyEuoX/erVd04kR6+/WI6w=;
 b=ycyNbGIShAyaP6gtNubm3VeF9kduIaWjCbMRE9WBE7ZybGeVm8EEKEIIa3gvPpm/6JpR
 yS3fpNRcrpbu9hV0tieqMBwE+oHOTrzFpdVS1/+AuR9q2lsEuyR8AXvk2gzeCzpiqdLr
 3Z38ov1i8L/M6rmbPULb1anQdPZ1RqyeaCksO+hnjzGYxA+QuaP9mZZpbr8N79io7dG1
 Jqkke4Cay4weLjCoyOByzctch60yXSvP2z28v7FZl/Ao68bgmQXBqjG7H+O1tOJQuT/U
 EsN10ULx5ID0FMUUYDF+TZ4KF8dOEbCOvj6UwvlbqFz5d53JMnl58+PVzbiqnW97V4ep Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4bas0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 11:35:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NBPlEm123836;
        Fri, 23 Oct 2020 11:35:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 348ah1we9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 11:35:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09NBZLCU011502;
        Fri, 23 Oct 2020 11:35:21 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 04:34:57 -0700
Date:   Fri, 23 Oct 2020 14:34:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] vfio/fsl-mc: return -EFAULT if copy_to_user() fails
Message-ID: <20201023113450.GH282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The copy_to_user() function returns the number of bytes remaining to be
copied, but this code should return -EFAULT.

Fixes: df747bcd5b21 ("vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 0113a980f974..21f22e3da11f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -248,7 +248,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 		info.size = vdev->regions[info.index].size;
 		info.flags = vdev->regions[info.index].flags;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+		return 0;
 	}
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{
@@ -267,7 +269,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 		info.flags = VFIO_IRQ_INFO_EVENTFD;
 		info.count = 1;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+		return 0;
 	}
 	case VFIO_DEVICE_SET_IRQS:
 	{
-- 
2.28.0

