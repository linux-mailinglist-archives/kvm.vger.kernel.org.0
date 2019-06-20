Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2C34DC58
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 23:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFTVRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 17:17:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfFTVRY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jun 2019 17:17:24 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KL8Ydf136938
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 17:17:23 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t8ht3r935-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 17:17:23 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Thu, 20 Jun 2019 22:07:15 +0100
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Jun 2019 22:07:13 +0100
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5KL7BmR58065178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 21:07:11 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7150D6A057;
        Thu, 20 Jun 2019 21:07:11 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0B456A04D;
        Thu, 20 Jun 2019 21:07:10 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.ibm.com (unknown [9.85.195.114])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 20 Jun 2019 21:07:10 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com
Cc:     pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, alifm@linux.ibm.com
Subject: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a channel program
Date:   Thu, 20 Jun 2019 17:07:09 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561055076.git.alifm@linux.ibm.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062021-0016-0000-0000-000009C42E34
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011299; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01220866; UDB=6.00642273; IPR=6.01002004;
 MB=3.00027397; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-20 21:07:14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062021-0017-0000-0000-000043B85401
Message-Id: <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=758 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200152
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

