Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661094DA6A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 21:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfFTTkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 15:40:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726169AbfFTTkp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jun 2019 15:40:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KJblN5039949;
        Thu, 20 Jun 2019 15:40:29 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t8fv9hfbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jun 2019 15:40:29 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5KJUqLP014311;
        Thu, 20 Jun 2019 19:40:28 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 2t4ra6kmaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jun 2019 19:40:28 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5KJeQkl61931974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 19:40:26 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1715A136051;
        Thu, 20 Jun 2019 19:40:26 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BFAE13604F;
        Thu, 20 Jun 2019 19:40:25 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.ibm.com (unknown [9.85.195.114])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 20 Jun 2019 19:40:25 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, alifm@linux.ibm.com
Subject: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a channel program
Date:   Thu, 20 Jun 2019 15:40:24 -0400
Message-Id: <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561055076.git.alifm@linux.ibm.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=860 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a small window where it's possible that an interrupt can
arrive and can call cp_free, while we are still processing a channel
program (i.e allocating memory, pinnging pages, translating
addresses etc). This can lead to allocating and freeing at the same
time and can cause memory corruption.

Let's not call cp_free if we are currently processing a channel program.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---

I have been running my test overnight with this patch and I haven't
seen the stack traces that I mentioned about earlier. I would like
to get some reviews on this and also if this is the right thing to
do?

Thanks
Farhan

 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 66a66ac..61ece3f 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final)
+		if (is_final && private->state != VFIO_CCW_STATE_CP_PROCESSING)
 			cp_free(&private->cp);
 	}
 	mutex_lock(&private->io_mutex);
-- 
2.7.4

