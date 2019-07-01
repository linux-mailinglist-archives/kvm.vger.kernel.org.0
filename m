Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97A45C10D
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 18:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfGAQYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 12:24:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727227AbfGAQYL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 12:24:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61GNptR096041;
        Mon, 1 Jul 2019 12:23:55 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tfkhf0qrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 12:23:55 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x61GJK4l007577;
        Mon, 1 Jul 2019 16:23:53 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 2tdym6r3cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 16:23:53 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61GNpAX35324180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 16:23:51 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11FDCBE051;
        Mon,  1 Jul 2019 16:23:51 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E513BE04F;
        Mon,  1 Jul 2019 16:23:50 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.42])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 16:23:50 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [RFC v1 4/4] vfio-ccw: Don't call cp_free if we are processing a channel program
Date:   Mon,  1 Jul 2019 12:23:46 -0400
Message-Id: <31c3c29e3e9c4f0312f9363a1c3a5d22b74f68cb.1561997809.git.alifm@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=835 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010198
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a small window where it's possible that we could be working
on an interrupt (queued in the workqueue) and setting up a channel
program (i.e allocating memory, pinning pages, translating address).
This can lead to allocating and freeing the channel program at the
same time and can cause memory corruption.

Let's not call cp_free if we are currently processing a channel program.
The only way we know for sure that we don't have a thread setting
up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 4e3a903..0357165 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final)
+		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
 			cp_free(&private->cp);
 	}
 	mutex_lock(&private->io_mutex);
-- 
2.7.4

