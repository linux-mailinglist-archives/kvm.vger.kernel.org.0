Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487181D179D
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389002AbgEMO3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:29:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388740AbgEMO3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:29:44 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DEA8Ig071505;
        Wed, 13 May 2020 10:29:44 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101m23555-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:43 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04DEA8Q3071527;
        Wed, 13 May 2020 10:29:43 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3101m2353k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 10:29:43 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04DEL0s0030083;
        Wed, 13 May 2020 14:29:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3100ubgq3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 May 2020 14:29:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04DETaji25690322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 14:29:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0938642049;
        Wed, 13 May 2020 14:29:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F33A042042;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 13 May 2020 14:29:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A6917E02BA; Wed, 13 May 2020 16:29:35 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v2 1/4] vfio-ccw: Do not reset FSM state for unsolicited interrupts
Date:   Wed, 13 May 2020 16:29:31 +0200
Message-Id: <20200513142934.28788-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513142934.28788-1-farman@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_06:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=762 adultscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The interrupt handler in vfio_ccw_sch_io_todo() presumes that every
interrupt should reset the FSM state back to IDLE. But this means
that an unsolicited interrupt will cause the FSM to be reset, such
that an in-flight I/O (either still being built, or out on the wire)
will cause a solicited interrupt for which vfio-ccw is no longer
expecting.

Example IRB, while state=CP_PROCESSING:

  irb.w0=00c00011 irb.cpa=02f420f8 irb.w2=85000000

Simply check that the interrupt is solicited before touching the
FSM state.

Fixes: bbe37e4cb8970 ("vfio: ccw: introduce a finite state machine")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 339a6bc0339b..7dd3efa1ccb8 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -98,7 +98,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->mdev && is_final)
+	if (private->mdev && scsw_is_solicited(&irb->scsw) && is_final)
 		private->state = VFIO_CCW_STATE_IDLE;
 
 	if (private->io_trigger)
-- 
2.17.1

