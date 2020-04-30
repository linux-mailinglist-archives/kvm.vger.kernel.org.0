Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B1B1C0936
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 23:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgD3V1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 17:27:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgD3V1f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 17:27:35 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UL2uad075500;
        Thu, 30 Apr 2020 17:27:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqb9uyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 17:27:35 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03UL35mS076513;
        Thu, 30 Apr 2020 17:27:34 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqb9uyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 17:27:34 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03ULOWTx005915;
        Thu, 30 Apr 2020 21:27:33 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 30mcu70mty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 21:27:33 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03ULRWJQ18940256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 21:27:32 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D86278060;
        Thu, 30 Apr 2020 21:27:32 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8096F7805C;
        Thu, 30 Apr 2020 21:27:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.180.191])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 21:27:31 +0000 (GMT)
From:   Jared Rossi <jrossi@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Date:   Thu, 30 Apr 2020 17:29:59 -0400
Message-Id: <20200430212959.13070-2-jrossi@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200430212959.13070-1-jrossi@linux.ibm.com>
References: <20200430212959.13070-1-jrossi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_12:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the explicit prefetch check when using vfio-ccw devices.
This check is not needed in practice as all Linux channel programs
are intended to use prefetch.

It is expected that all ORBs issued by Linux will request prefetch.
Although non-prefetching ORBs are not rejected, they will prefetch
nonetheless. A warning is issued up to once per 5 seconds when a
forced prefetch occurs.

A non-prefetch ORB does not necessarily result in an error, however
frequent encounters with non-prefetch ORBs indicates that channel
programs are being executed in a way that is inconsistent with what
the guest is requesting. While there are currently no known errors
caused by forced prefetch, it is possible in theory that forced
prefetch could result in an error if applied to a channel program
that is dependent on non-prefetch.

Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
---
 Documentation/s390/vfio-ccw.rst |  4 ++++
 drivers/s390/cio/vfio_ccw_cp.c  | 16 +++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index fca9c4f5bd9c..8f71071f4403 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -335,6 +335,10 @@ device.
 The current code allows the guest to start channel programs via
 START SUBCHANNEL, and to issue HALT SUBCHANNEL and CLEAR SUBCHANNEL.
 
+Currently all channel programs are prefetched, regardless of the
+p-bit setting in the ORB.  As a result, self modifying channel
+programs are not supported (IPL is handled as a special case).
+
 vfio-ccw supports classic (command mode) channel I/O only. Transport
 mode (HPF) is not supported.
 
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3645d1720c4b..48802e9827b6 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -8,6 +8,7 @@
  *            Xiao Feng Ren <renxiaof@linux.vnet.ibm.com>
  */
 
+#include <linux/ratelimit.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
@@ -625,23 +626,20 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
  * the target channel program from @orb->cmd.iova to the new ccwchain(s).
  *
  * Limitations:
- * 1. Supports only prefetch enabled mode.
- * 2. Supports idal(c64) ccw chaining.
- * 3. Supports 4k idaw.
+ * 1. Supports idal(c64) ccw chaining.
+ * 2. Supports 4k idaw.
  *
  * Returns:
  *   %0 on success and a negative error value on failure.
  */
 int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 {
+	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
 
-	/*
-	 * XXX:
-	 * Only support prefetch enable mode now.
-	 */
-	if (!orb->cmd.pfch)
-		return -EOPNOTSUPP;
+	/* All Linux channel programs are expected to support prefetching */
+	if (!orb->cmd.pfch && __ratelimit(&ratelimit_state))
+		printk(KERN_WARNING "vfio_ccw_cp: prefetch will be forced\n");
 
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
-- 
2.17.0

