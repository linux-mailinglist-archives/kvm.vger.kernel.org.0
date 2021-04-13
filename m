Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2BC35E64A
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347658AbhDMSYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:24:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347641AbhDMSYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 14:24:39 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DI3MUR027164;
        Tue, 13 Apr 2021 14:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=JknBCAuHiEO/f4AcObmnnjS/47X+qsGrgkJ/mGxwTF8=;
 b=go4s8ipcUgsOpjFfV2tth5dT8L3fZxT08Wb6PIxUc+gJLQqu2KlrvJKeM4QfmKP4mkH5
 SEl6fwN13CeC0XKEN4HcZAEcZoV4GZnpXxiNbg5mbwyFtvtFM2RHAwZQOJ6HUb0cL9Tj
 WD5ZtzRmxhJPi4z3JptJMSDLyp/Ob7RWznx3JLFAFnnQv3OTdUKYpCUonJ4MKHw3QwK2
 Gam5aQrUoCr/+cebQIVCiYyKOjd3JZ5LNbc6xHkgvH635rlrwGb+J3hV4NOo75TV6KjL
 wYoj8jwUVq9g5SLCq5u0Y42SEk1cpbw6iAW7VPMVQukAzP42+/5wjfVYFC4KvqZ/uXRP pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w9gycv7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DI4SQj031294;
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w9gycv6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DIMqou006039;
        Tue, 13 Apr 2021 18:24:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37u39hjuj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 18:24:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DIODVQ41877780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 18:24:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB5894204B;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D640542047;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 82637E0519; Tue, 13 Apr 2021 20:24:12 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 4/4] vfio-ccw: Reset FSM state to IDLE before io_mutex
Date:   Tue, 13 Apr 2021 20:24:10 +0200
Message-Id: <20210413182410.1396170-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413182410.1396170-1-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YlwmDeBo9gQmTXRNlofM271f2TK-V-xw
X-Proofpoint-ORIG-GUID: 2OE1hblWcxXqnE8M0ncBUCLeI8frrHrZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=859
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today, the stacked call to vfio_ccw_sch_io_todo() does three things:

1) Update a solicited IRB with CP information, and release the CP
if the interrupt was the end of a START operation.
2) Copy the IRB data into the io_region, under the protection of
the io_mutex
3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
vfio-ccw can accept more work.

The trouble is that step 3 is (A) invoked for both solicited and
unsolicited interrupts, and (B) sitting after the mutex for step 2.
This second piece becomes a problem if it processes an interrupt
for a CLEAR SUBCHANNEL while another thread initiates a START,
thus allowing the CP and FSM states to get out of sync. That is:

	CPU 1				CPU 2
	fsm_do_clear()
	fsm_irq()
					fsm_io_request()
					fsm_io_helper()
	vfio_ccw_sch_io_todo()
					fsm_irq()
					vfio_ccw_sch_io_todo()

Let's move the reset of the FSM state to the point where the
channel_program struct is cleaned up, which is only done for
solicited interrupts anyway.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8c625b530035..e51318f23ca8 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -94,16 +94,15 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
+		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
 			cp_free(&private->cp);
+			private->state = VFIO_CCW_STATE_IDLE;
+		}
 	}
 	mutex_lock(&private->io_mutex);
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->mdev && is_final)
-		private->state = VFIO_CCW_STATE_IDLE;
-
 	if (private->io_trigger)
 		eventfd_signal(private->io_trigger, 1);
 }
-- 
2.25.1

