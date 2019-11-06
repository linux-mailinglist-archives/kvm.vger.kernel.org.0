Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2630F11CA
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbfKFJKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:10:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731631AbfKFJJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:09:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA698eQS115926;
        Wed, 6 Nov 2019 09:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=Z5cM7OxDMmHXMNVS03rtcEV1AuDRRTLHQfvZ7yXT3XA=;
 b=FDVg98sKQ+FA88I49PM9+wbl1KeVTiawHXqKEwFUfkwHOmgzlR0owvji/PZNjMS0pqV7
 mfVCHvEw/DAT0O/riEig/c1TE66A1GyUAO4wdT0leg48S89wPs9ppYo6iLs7Kbr3wC27
 ApXcQFzgdO3lh3YHo7BPa2m5Srm74bsVXlnhV7iTPjZFsFcQjzRlP6kOxGCxMyZecGHT
 iqMd8zJKYUOxNlMvP0nW0YAOoSdJ0hNq7mhCOjfuv79YM3HwOpoZvx9Zd5L80fSOjXE7
 HDNjLQLeoka/sX+gJp6QLsVuH9TYaX6oNHJyUM2WnOd0iW6ZMcMIfVfVcli0qR6kyW8Q cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117u4gny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA698qnP015260;
        Wed, 6 Nov 2019 09:09:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w31631dwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 09:09:29 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA699SAk013641;
        Wed, 6 Nov 2019 09:09:28 GMT
Received: from z2.cn.oracle.com (/10.182.71.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 01:09:28 -0800
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        rafael.j.wysocki@intel.com, joao.m.martins@oracle.com,
        mtosatti@redhat.com, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v2 3/4] cpuidle-haltpoll: ensure cpu_halt_poll_us in right scope
Date:   Wed,  6 Nov 2019 17:08:51 +0800
Message-Id: <1573031332-2121-4-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
References: <1573031332-2121-1-git-send-email-zhenzhong.duan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060096
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
index 660859d..d0b38b53 100644
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
+			guest_halt_poll_allow_shrink) {
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

