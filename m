Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0636333CE
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 17:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfFCPoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 11:44:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbfFCPoD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 11:44:03 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53Fc9Rk135549;
        Mon, 3 Jun 2019 11:43:43 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw4hw6hmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 11:43:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x539gXxu027142;
        Mon, 3 Jun 2019 09:47:50 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2suh090wj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 09:47:50 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53FglTw37618036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 15:42:47 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6314124058;
        Mon,  3 Jun 2019 15:42:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B72CB124054;
        Mon,  3 Jun 2019 15:42:47 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.18])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon,  3 Jun 2019 15:42:47 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, farman@linux.ibm.com, alifm@linux.ibm.com,
        pasic@linux.ibm.com
Subject: [PATCH v1 1/1] vfio-ccw: Destroy kmem cache region on module exit
Date:   Mon,  3 Jun 2019 11:42:47 -0400
Message-Id: <c0f39039d28af39ea2939391bf005e3495d890fd.1559576250.git.alifm@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559576250.git.alifm@linux.ibm.com>
References: <cover.1559576250.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free the vfio_ccw_cmd_region on module exit.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---

I guess I missed this earlier while reviewing, but should'nt 
we destroy the vfio_ccw_cmd_region on module exit, as well?

 drivers/s390/cio/vfio_ccw_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 66a66ac..9cee9f2 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -299,6 +299,7 @@ static void __exit vfio_ccw_sch_exit(void)
 	css_driver_unregister(&vfio_ccw_sch_driver);
 	isc_unregister(VFIO_CCW_ISC);
 	kmem_cache_destroy(vfio_ccw_io_region);
+	kmem_cache_destroy(vfio_ccw_cmd_region);
 	destroy_workqueue(vfio_ccw_work_q);
 }
 module_init(vfio_ccw_sch_init);
-- 
2.7.4

