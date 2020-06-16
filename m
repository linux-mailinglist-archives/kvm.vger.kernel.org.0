Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE311FBF68
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 21:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbgFPTvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 15:51:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730183AbgFPTvB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 15:51:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GJ7PqH145980;
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q23tc694-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05GJmeTQ007358;
        Tue, 16 Jun 2020 15:51:01 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q23tc68g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 15:51:00 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05GJnqlZ016464;
        Tue, 16 Jun 2020 19:50:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 31mpe7jd8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 19:50:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05GJoto942008594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 19:50:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F64FA4057;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CE08A4055;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Jun 2020 19:50:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id EE7D7E02B1; Tue, 16 Jun 2020 21:50:54 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v3 3/3] vfio-ccw: Check workqueue before doing START
Date:   Tue, 16 Jun 2020 21:50:53 +0200
Message-Id: <20200616195053.99253-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200616195053.99253-1-farman@linux.ibm.com>
References: <20200616195053.99253-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_12:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 cotscore=-2147483648 impostorscore=0 mlxlogscore=476 adultscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an interrupt is received via the IRQ, the bulk of the work is
stacked on a workqueue for later processing. Which means that concurrent
START or a HALT/CLEAR operation (via the async_region) will race with
this process and require some serialization.

Once we have all our locks acquired, let's just look to see if we're
in a window where the process has been started from the IRQ, but not
yet picked up by vfio-ccw to clean up an I/O. If there is, mark the
request as BUSY so it can be redriven after we have a chance to breathe.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index f0952192480e..9dc5b4d549b3 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -28,6 +28,11 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 
 	spin_lock_irqsave(sch->lock, flags);
 
+	if (work_pending(&private->io_work)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
 	if (!orb) {
 		ret = -EIO;
-- 
2.17.1

