Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5602635E64C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347661AbhDMSYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:24:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232679AbhDMSYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 14:24:39 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DI4fqg105496;
        Tue, 13 Apr 2021 14:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S6Z9trCJxhHTBWUPqQl3zYDBAGDJzSmV4EKlCe/E4C4=;
 b=cRuAOqXyQ2NCgn/tPJ6WjIkbvXRAnQEpIwrynmoM98Ojf+d02Qui7OsVSAFGemViTrwl
 aVCKDsF2FA7CQCA5R+6qw+slG3eloqLpHyRtVaKcssMv8HjE2P3hCIVDVBO4p1vGs8gE
 A7yrKLT0DXs8mK2hwOG0f6JvG8Fx5wequsxCkNRTV2hGkAG6cR9EXdvubCBe68dP+of4
 MUwZhseVidFukDplH05b9T2raKKi2qp1qk+d3WdbOGzlhEeZ2P0IP8lPsmDusbTzHKoq
 vh/yQqL1bO3d1nNnjQXcl80z5Ij9omOYM53QpwnTlA9s3My/+hFVRHkB6T512RNWj8uh aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w87sqq79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:19 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DI6BF2112723;
        Tue, 13 Apr 2021 14:24:19 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37w87sqq6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DINTNa006662;
        Tue, 13 Apr 2021 18:24:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 37u3n89gn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 18:24:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DIODbv15991290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 18:24:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D584CA405D;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC253A405B;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7E079E0482; Tue, 13 Apr 2021 20:24:12 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 2/4] vfio-ccw: Check workqueue before doing START
Date:   Tue, 13 Apr 2021 20:24:08 +0200
Message-Id: <20210413182410.1396170-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413182410.1396170-1-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PgC-abe-jtYUxGSiacaW4J5-nh9Qt1gT
X-Proofpoint-GUID: u3da3qWCNlNWuaOhYtrVlUb6Sl6manrA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=664 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an interrupt is received via the IRQ, the bulk of the work
is stacked on a workqueue for later processing. Which means that
a concurrent START or HALT/CLEAR operation (via the async_region)
will race with this process and require some serialization.

Once we have all our locks acquired, let's just look to see if we're
in a window where the process has been started from the IRQ, but not
yet picked up by vfio-ccw to clean up an I/O. If there is, mark the
request as BUSY so it can be redriven.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_fsm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 23e61aa638e4..92d638f10b27 100644
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
2.25.1

