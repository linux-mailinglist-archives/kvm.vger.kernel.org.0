Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F222424F7E
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbhJGIxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:53:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13134 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240446AbhJGIxt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:53:49 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19777BZ7001491;
        Thu, 7 Oct 2021 04:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qIqV9OFC2fV8dmhXf+OZz/BdC/59VX+ZNCkVDNXuV+k=;
 b=g5iJuBlhMEJNoSG33oBXHXuo3bDVMx6IHRSq4VIjiOd7BRUG300exUFCILYWwc++XhG6
 pkC27WGKQk6E6e3fmhtLInR9rxV2vB1sdQuLDfERa1lqEVzKyHq5MJ5csJoyfFxYbyDa
 2bp+l7uDynFNvNbM13fqZ/ZGWta8jjpFYNKVlr2SBeFRJPgPcw0fZ5IbCreDVjpJ6NgG
 8Q23Hth6vgPljCz4u4c2AGudJNkCwjflw6+BEddm16Y/k10x0603edqSUEAuB1R0eRjz
 u+K3ie7S0tnZR/9bsolKaSS2ijaKoNx4BZ090M+Vp2IsEYTjqV3ZNF7u/pwzrly/xVSw /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhu9hbeqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:51:55 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1978Db3O004564;
        Thu, 7 Oct 2021 04:51:55 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhu9hbeq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:51:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978fuHB014185;
        Thu, 7 Oct 2021 08:51:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3bhepcxtp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:51:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978kOsH54984996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:46:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBA5AE072;
        Thu,  7 Oct 2021 08:51:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE9EAE055;
        Thu,  7 Oct 2021 08:51:41 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:51:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 1/9] s390x: uv: Tolerate 0x100 query return code
Date:   Thu,  7 Oct 2021 08:50:19 +0000
Message-Id: <20211007085027.13050-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TIydDbkP0j4PzKxzVopEKG2hi_z99NmT
X-Proofpoint-GUID: Cgj65tUxJbBpH0dxzrOJc-KxDFho_Ut_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 malwarescore=0 impostorscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RC 0x100 is not an error but a notice that we could have gotten more
data from the Ultravisor if we had asked for it. So let's tolerate
them in our tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 4 +++-
 s390x/uv-host.c  | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index f05ae4c3..44ad2154 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -71,7 +71,9 @@ static void test_query(void)
 
 	uvcb.header.len = sizeof(uvcb);
 	cc = uv_call(0, (u64)&uvcb);
-	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
+	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
+	       (cc == 1 && uvcb.header.rc == 0x100),
+		"successful query");
 
 	/*
 	 * These bits have been introduced with the very first
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 28035707..4b72c24d 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -385,7 +385,7 @@ static void test_init(void)
 
 static void test_query(void)
 {
-	int i = 0;
+	int i = 0, cc;
 
 	uvcb_qui.header.cmd = UVC_CMD_QUI;
 	uvcb_qui.header.len = sizeof(uvcb_qui);
@@ -400,8 +400,10 @@ static void test_query(void)
 	report(uvcb_qui.header.rc == 0x100, "insf length");
 
 	uvcb_qui.header.len = sizeof(uvcb_qui);
-	uv_call(0, (uint64_t)&uvcb_qui);
-	report(uvcb_qui.header.rc == UVC_RC_EXECUTED, "successful query");
+	cc = uv_call(0, (uint64_t)&uvcb_qui);
+	report((!cc && uvcb_qui.header.rc == UVC_RC_EXECUTED) ||
+	       (cc == 1 && uvcb_qui.header.rc == 0x100),
+		"successful query");
 
 	for (i = 0; cmds[i].name; i++)
 		report(uv_query_test_call(cmds[i].call_bit), "%s", cmds[i].name);
-- 
2.30.2

