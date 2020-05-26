Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A321C7C53
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 23:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgEFVWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 17:22:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729925AbgEFVWN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 17:22:13 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046L2fQ9143886;
        Wed, 6 May 2020 17:22:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8srveff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 17:22:12 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 046L2kZa144679;
        Wed, 6 May 2020 17:22:12 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8srveex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 17:22:12 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 046LKkBQ004196;
        Wed, 6 May 2020 21:22:11 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 30s0g75hmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 21:22:11 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 046LM9pi27132196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 21:22:09 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A752EBE056;
        Wed,  6 May 2020 21:22:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4851BE051;
        Wed,  6 May 2020 21:22:08 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.180.129])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 21:22:08 +0000 (GMT)
From:   Jared Rossi <jrossi@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Date:   Wed,  6 May 2020 17:24:40 -0400
Message-Id: <20200506212440.31323-2-jrossi@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200506212440.31323-1-jrossi@linux.ibm.com>
References: <20200506212440.31323-1-jrossi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060170
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the explicit prefetch check when using vfio-ccw devices.
This check does not trigger in practice as all Linux channel programs
are intended to use prefetch.

It is expected that all ORBs issued by Linux will request prefetch.
Although non-prefetching ORBs are not rejected, they will prefetch
nonetheless. A warning is issued up to once per 5 seconds when a
forced prefetch occurs.

A non-prefetch ORB does not necessarily result in an error, however
frequent encounters with non-prefetch ORBs indicate that channel
programs are being executed in a way that is inconsistent with what
the guest is requesting. While there is currently no known case of an
error caused by forced prefetch, it is possible in theory that forced
prefetch could result in an error if applied to a channel program that
is dependent on non-prefetch.

Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
---
 Documentation/s390/vfio-ccw.rst |  6 ++++++
 drivers/s390/cio/vfio_ccw_cp.c  | 19 ++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index fca9c4f5bd9c..23e7d136f8b4 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -335,6 +335,12 @@ device.
 The current code allows the guest to start channel programs via
 START SUBCHANNEL, and to issue HALT SUBCHANNEL and CLEAR SUBCHANNEL.
 
+Currently all channel programs are prefetched, regardless of the
+p-bit setting in the ORB.  As a result, self modifying channel
+programs are not supported.  For this reason, IPL has to be handled as
+a special case by a userspace/guest program; this has been implemented
+in QEMU's s390-ccw bios as of QEMU 4.1.
+
 vfio-ccw supports classic (command mode) channel I/O only. Transport
 mode (HPF) is not supported.
 
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3645d1720c4b..f237480c3d43 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -8,6 +8,7 @@
  *            Xiao Feng Ren <renxiaof@linux.vnet.ibm.com>
  */
 
+#include <linux/ratelimit.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
@@ -625,23 +626,27 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
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
+	/* custom ratelimit used to avoid flood during guest IPL */
+	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
 
 	/*
-	 * XXX:
-	 * Only support prefetch enable mode now.
+	 * We only support prefetching the channel program. We assume all channel
+	 * programs executed by supported guests likewise support prefetching.
+	 * Executing a channel program that does not specify prefetching will
+	 * typically not cause an error, but a warning is issued to help identify
+	 * the problem if something does break.
 	 */
-	if (!orb->cmd.pfch)
-		return -EOPNOTSUPP;
+	if (!orb->cmd.pfch && __ratelimit(&ratelimit_state))
+		dev_warn(mdev, "Prefetching channel program even though prefetch not specified in ORB");
 
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
-- 
2.17.0

