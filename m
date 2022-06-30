Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB18562446
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiF3UhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiF3Ug7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:36:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2559E457B3;
        Thu, 30 Jun 2022 13:36:57 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UKRxZT015636;
        Thu, 30 Jun 2022 20:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RYclvI5F/rHmJdIO9b6HJcW1LqLDp+neaHavp94TWkU=;
 b=jgZfl3W7k1m0NV+UbB8eV4oqzMGq44DtkCCONeabqqKgMg+TFyEW1pasly9crMrLMuxE
 235dlvFYMcjVCaiCvvbhVcAzJdtWlECUGPYj5cGol1uEm6K9jXZQUd7SmAwvGpG9j22k
 ZoLHSvjetNZkFGhPzFGGiTG9vdKkIA4+zbX4ytKfhedE624EX7bTjfy5Whkcx/Z/i8zI
 f7zDtzJ1lp+Wpt59UHZL2mhqFIx0pXdg6o6vDi5EYMaDuxCftPwt10bSczmLdpDijtg2
 2K/wJeuQAY2mt0vn99hCuMxj/tlnfi9Mg02Pl06QPa9qqRrJluZEkWK7TMBICD2QcKDB 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jw3858w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UKasgJ022231;
        Thu, 30 Jun 2022 20:36:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jw38587-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UKLdt3009284;
        Thu, 30 Jun 2022 20:36:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt090nmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:52 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UKanRX20054390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 20:36:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55B6011C04C;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43EC011C04A;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 06FDFE02A1; Thu, 30 Jun 2022 22:36:49 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 07/11] vfio/ccw: Update trace data for not operational event
Date:   Thu, 30 Jun 2022 22:36:43 +0200
Message-Id: <20220630203647.2529815-8-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220630203647.2529815-1-farman@linux.ibm.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EF2PK_4z_rgS7CudKcJclma7wa1N8ITc
X-Proofpoint-GUID: VlP1mOU2i1XHQtQlOfskBNCPoyyNVvgw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently cut a very basic trace whenever the FSM directs
control to the not operational routine.

Convert this to a message, so it's alongside the other configuration
related traces (create, remove, etc.), and record both the event
that brought us here and the current state of the device.
This will provide some better footprints if things go bad.

Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index bbcc5b486749..88e529a2e184 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -160,8 +160,12 @@ static void fsm_notoper(struct vfio_ccw_private *private,
 {
 	struct subchannel *sch = private->sch;
 
-	VFIO_CCW_TRACE_EVENT(2, "notoper");
-	VFIO_CCW_TRACE_EVENT(2, dev_name(&sch->dev));
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: notoper event %x state %x\n",
+			   sch->schid.cssid,
+			   sch->schid.ssid,
+			   sch->schid.sch_no,
+			   event,
+			   private->state);
 
 	/*
 	 * TODO:
-- 
2.32.0

