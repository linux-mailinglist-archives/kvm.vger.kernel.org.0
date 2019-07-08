Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C479E62A2C
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 22:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404885AbfGHUKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 16:10:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404880AbfGHUKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jul 2019 16:10:49 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68K7M9b105152
        for <kvm@vger.kernel.org>; Mon, 8 Jul 2019 16:10:48 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tma9559c6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 16:10:47 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Mon, 8 Jul 2019 21:10:47 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Jul 2019 21:10:44 +0100
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68KAhDR59441576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 20:10:43 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3A21BE054;
        Mon,  8 Jul 2019 20:10:42 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 753BABE04F;
        Mon,  8 Jul 2019 20:10:42 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.103])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Jul 2019 20:10:42 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing a channel program
Date:   Mon,  8 Jul 2019 16:10:37 -0400
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19070820-0016-0000-0000-000009CBCF6F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011397; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229353; UDB=6.00647438; IPR=6.01010612;
 MB=3.00027639; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-08 20:10:45
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070820-0017-0000-0000-000043F0EE56
Message-Id: <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=731 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080250
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

