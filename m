Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926C296DB5
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463021AbgJWLaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 07:30:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462965AbgJWLaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 07:30:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NBOsSl131525;
        Fri, 23 Oct 2020 11:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=9kf8P27vyBYNLjGzKO/Jue2/64fmWTjPZNf2k5fKmhc=;
 b=TNJkekHOIZJkGE8PQeteOXT9/QZzO75g69x/3tecYzA5a26/GsCvAPMCGoSI1T7stUAe
 vn/emSRZwmIOAwuBlm/URzTM3IXdgCcdwnlQqS3PKmhL6HYg3ni8EODNGSI/4U3EYmZj
 URqL0R8k+Nn2Swmnq0EPyHB6rvH7OkNyK60f7NwoJBLerlqS5WqGnmunRnDk3UHZeluR
 R2Pz1AvqxfRJbvwH7UjxO4XTJVsUfxMi+k3Vs9zKCu3AXoGvx1WlUJuLnJ+OfRJwAw08
 Mz05agl56NwfZLSdUC4xqFYCYi5Osw1gcTnCnaMqOsNpp76Lo23DbDzZnPFBlBYBu73x pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 349jrq2s4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 11:29:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NBPl33123798;
        Fri, 23 Oct 2020 11:29:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 348ah1w9em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 11:29:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09NBTsiL031037;
        Fri, 23 Oct 2020 11:29:54 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 04:29:53 -0700
Date:   Fri, 23 Oct 2020 14:29:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] vfio/fsl-mc: prevent underflow in vfio_fsl_mc_mmap()
Message-ID: <20201023112947.GF282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=981
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=993 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My static analsysis tool complains that the "index" can be negative.
There are some checks in do_mmap() which try to prevent underflows but
I don't know if they are sufficient for this situation.  Either way,
making "index" unsigned is harmless so let's do it just to be safe.

Fixes: 67247289688d ("vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 21f22e3da11f..f27e25112c40 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -472,7 +472,7 @@ static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
 {
 	struct vfio_fsl_mc_device *vdev = device_data;
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
-	int index;
+	unsigned int index;
 
 	index = vma->vm_pgoff >> (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT);
 
-- 
2.28.0

