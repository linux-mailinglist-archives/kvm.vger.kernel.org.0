Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC6F1589
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbfKFL5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 06:57:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfKFL5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 06:57:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6BsBC5061334;
        Wed, 6 Nov 2019 11:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=QVEFup4AnIoDyOHVkZA0dQXS1IbWCtRajrTPgCoUWZk=;
 b=AAj4HeqDaK7eGF1Wk0zlu/g+kDbsR3UIJS7mmk/XbMbdwDv5gyrsMIxWXrouYnhJpnbQ
 HU0r1jFUkkeVz4suntwMLrHtEl3REKYeOXgl7AODNwEVpzxUhjMPiWeEZ3YuPdnHBbhm
 WJyPH5J2nKQLVP9NxVwnwnx6pWu6Xy3WM63LYynuNug2GpBhLzN2JumEsiC5KIsPiw3m
 o5cLNRTMwstUiLku4qcRJKhKvBWhxGkWSWus7jwdWsFHUVoojd7F+eoj8efCHwXdGzKM
 Z85FY3G3osH6VohTZW2sf2RME5T/VZR6giYX1XO39t56KeCKWW6HKvlmJONZHsiwnfcY ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117u5pfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:57:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Bv7WY057904;
        Wed, 6 Nov 2019 11:57:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w31639squ-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 11:57:13 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6BtkeA002264;
        Wed, 6 Nov 2019 11:55:46 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 03:55:46 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH RESEND v2 3/4] cpuidle-haltpoll: ensure cpu_halt_poll_us in right scope
Date:   Wed,  6 Nov 2019 19:55:01 +0800
Message-Id: <1573041302-4904-4-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As user can adjust guest_halt_poll_grow_start and guest_halt_poll_ns
which leads to cpu_halt_poll_us beyond the two boundaries. This patch
ensures cpu_halt_poll_us in that scope.

If guest_halt_poll_shrink is 0, shrink the cpu_halt_poll_us to
guest_halt_poll_grow_start instead of 0. To disable poll we can set
guest_halt_poll_ns to 0.

If user wrongly set guest_halt_poll_grow_start > guest_halt_poll_ns > 0,
guest_halt_poll_ns take precedency and poll time is a fixed value of
guest_halt_poll_ns.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 660859d..4a39df4 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -97,32 +97,30 @@ static int haltpoll_select(struct cpuidle_driver *drv,
 
 static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
 {
-	unsigned int val;
+	unsigned int val = dev->poll_limit_ns;
 	u64 block_ns = block_us*NSEC_PER_USEC;
 
 	/* Grow cpu_halt_poll_us if
-	 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
+	 * cpu_halt_poll_us < block_ns <= guest_halt_poll_us
 	 */
-	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
+	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns &&
+	    guest_halt_poll_grow)
 		val = dev->poll_limit_ns * guest_halt_poll_grow;
-
-		if (val < guest_halt_poll_grow_start)
-			val = guest_halt_poll_grow_start;
-		if (val > guest_halt_poll_ns)
-			val = guest_halt_poll_ns;
-
-		dev->poll_limit_ns = val;
-	} else if (block_ns > guest_halt_poll_ns &&
-		   guest_halt_poll_allow_shrink) {
+	else if (block_ns > guest_halt_poll_ns &&
+		 guest_halt_poll_allow_shrink) {
 		unsigned int shrink = guest_halt_poll_shrink;
 
-		val = dev->poll_limit_ns;
 		if (shrink == 0)
-			val = 0;
+			val = guest_halt_poll_grow_start;
 		else
 			val /= shrink;
-		dev->poll_limit_ns = val;
 	}
+	if (val < guest_halt_poll_grow_start)
+		val = guest_halt_poll_grow_start;
+	if (val > guest_halt_poll_ns)
+		val = guest_halt_poll_ns;
+
+	dev->poll_limit_ns = val;
 }
 
 /**
-- 
1.8.3.1

