Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E9A56A4B6
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiGGN7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236387AbiGGN5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:57:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C45210FCB;
        Thu,  7 Jul 2022 06:57:47 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Db2Ud031682;
        Thu, 7 Jul 2022 13:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=61Grgpf1vJcZanhUbS8vdov7HPLOQKRnj3ErvQJZQks=;
 b=ly9u78W9k2bVn+/OH2ciICZ4FvvYNf6fnKrTRtijb17t2A8dHeifcUsKScDRRS9aQovu
 F/yqxO5Kr7L1nrGCMQ1DS9jMez3RYTf/QCODwIoTI8sgZSEYqHFd0+B/UhoaFqEb4j7R
 tDnhrFhJIerN+Ikpg1Zme5MmLuB7GolEu5ovLszkQarsPEmwXMry0Z6s5YeK4NV0ac3p
 G1lOaO9Rjxc27iatIsM37tdtKibDFgXCoTXcA0yONvfcG7jTiLdpyPLSRB49EFUpljCy
 rgq5aP0DHFL9jF36L704RFu/TvL846oZJvy6vihPKFamvYUZEDrj2NYIxd+kxPmwT+gu qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h60bw8x83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267DqedD000399;
        Thu, 7 Jul 2022 13:57:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h60bw8x7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:44 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267Du1XL000427;
        Thu, 7 Jul 2022 13:57:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3h4usd2ny0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267DvdvD8782332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:57:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A4904C04A;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57E124C046;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1A920E0246; Thu,  7 Jul 2022 15:57:39 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 03/11] vfio/ccw: Do not change FSM state in subchannel event
Date:   Thu,  7 Jul 2022 15:57:29 +0200
Message-Id: <20220707135737.720765-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707135737.720765-1-farman@linux.ibm.com>
References: <20220707135737.720765-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rm8BNaycx-hT6i1QCIw3grRkH6wtwVFl
X-Proofpoint-GUID: QPJwYqh1dJTeWmxn9j-6ToHch3TRSIZr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=640 spamscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The routine vfio_ccw_sch_event() is tasked with handling subchannel events,
specifically machine checks, on behalf of vfio-ccw. It correctly calls
cio_update_schib(), and if that fails (meaning the subchannel is gone)
it makes an FSM event call to mark the subchannel Not Operational.

If that worked, however, then it decides that if the FSM state was already
Not Operational (implying the subchannel just came back), then it should
simply change the FSM to partially- or fully-open.

Remove this trickery, since a subchannel returning will require more
probing than simply "oh all is well again" to ensure it works correctly.

Fixes: bbe37e4cb8970 ("vfio: ccw: introduce a finite state machine")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 179eb614fa5b..279ad2161f17 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -301,19 +301,11 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 	if (work_pending(&sch->todo_work))
 		goto out_unlock;
 
-	if (cio_update_schib(sch)) {
-		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
-		rc = 0;
-		goto out_unlock;
-	}
-
-	private = dev_get_drvdata(&sch->dev);
-	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
-		private->state = private->mdev ? VFIO_CCW_STATE_IDLE :
-				 VFIO_CCW_STATE_STANDBY;
-	}
 	rc = 0;
 
+	if (cio_update_schib(sch))
+		vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
+
 out_unlock:
 	spin_unlock_irqrestore(sch->lock, flags);
 
-- 
2.34.1

