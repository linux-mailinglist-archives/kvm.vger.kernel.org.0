Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5C354E14
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244357AbhDFHle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244308AbhDFHlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367Y9wQ028762
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=xLMPfE7cfoLUNXkFz/SqLWlrCO9SFJ5H5vrh+Osrskw=;
 b=bwJMUurPekxAfuVSmtkE7Rpxoyi09+EVi9RjbFlsikV/EwINPRtayjdPxg5+dLqQq9Ap
 ohmpTWTx60AOv4H55afbNPZBjAOK2cWn9HubuvvaKQ1NKY7gmp9M9xXWtKSLi4Hpb+ec
 gYPai/YBSxe3N5nZhMeZDeTRVr79X/8oeOFa9FKXVU/8ZQ8vedfiHLNaWVuUmq8PUMzX
 qHMFyn7salomm3lWyNIDtD1eua6Cj30zvFUgq8hYeLApEw5/qxyHGX/vjGTcjb67XibP
 /kjcGawzc4tdpsRoMMztP9nyh5HSRbkaQ9xaCj3KYfuQc04aezlxQN+HME9oQjwFcj6G MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:06 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367YTWv029677
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:05 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5tyk6ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:05 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wvog016107;
        Tue, 6 Apr 2021 07:41:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 37q2n2sx82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367f0Wp24903966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:41:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8B6B4C050;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FD744C059;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 14/16] s390x: css: issuing SSCH when the channel is status pending
Date:   Tue,  6 Apr 2021 09:40:51 +0200
Message-Id: <1617694853-6881-15-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SNdbYtPO5USPXWWLy-C-jGRSTkYTrarx
X-Proofpoint-GUID: e2b5k5xn9YUZwziPftV30eXzA8lSGNI9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=974 priorityscore=1501 adultscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We await CC=1 when we issue a SSCH on a channel with status pending.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h |  2 ++
 s390x/css.c     | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 08b2974..3eb6957 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -90,6 +90,8 @@ struct scsw {
 #define SCSW_ESW_FORMAT		0x04000000
 #define SCSW_SUSPEND_CTRL	0x08000000
 #define SCSW_KEY		0xf0000000
+#define SCSW_SSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_START | SCSW_SC_PENDING | SCSW_SC_SECONDARY | \
+				 SCSW_SC_PRIMARY)
 	uint32_t ctrl;
 	uint32_t ccw_addr;
 #define SCSW_DEVS_DEV_END	0x04
diff --git a/s390x/css.c b/s390x/css.c
index f8c6688..52264f2 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -258,6 +258,15 @@ static void ssch_orb_fcx(void)
 	orb->ctrl = tmp;
 }
 
+static void ssch_status_pending(void)
+{
+	assert(ssch(test_device_sid, orb) == 0);
+	report(ssch(test_device_sid, orb) == 1, "CC = 1");
+	/* now we clear the status */
+	assert(tsch(test_device_sid, &irb) == 0);
+	check_io_completion(test_device_sid, SCSW_SSCH_COMPLETED);
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
 	{ "orb cpa zero", ssch_orb_cpa_zero },
@@ -269,6 +278,7 @@ static struct tests ssh_tests[] = {
 	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
 	{ "ORB extensions", ssch_orb_extension},
 	{ "FC extensions", ssch_orb_fcx},
+	{ "status pending before ssch", ssch_status_pending},
 	{ NULL, NULL }
 };
 
-- 
2.17.1

