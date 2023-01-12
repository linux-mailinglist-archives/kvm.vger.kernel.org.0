Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48705667A09
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbjALP5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbjALP4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:56:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B8955A1;
        Thu, 12 Jan 2023 07:46:43 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFctKi011913;
        Thu, 12 Jan 2023 15:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XdC8GH3ZK4EuK5OfGuPY1Po0QSkN915WuoNiyho0ydQ=;
 b=n0AGQyY7cTMB/6Sj+HfNL/3zFcEYKTKSs06F7Yc9L50Zl7rW8IDqvfkl1Ln6AE7P1ZEY
 i+BYVRXr1qZAqzaGx87D3WG6KpMdB9UJbms5VDLy7wU+vaW/oPDHJImev44XHM7wq5JK
 tCzSAAkp6RyXl5uTHyzsC/LVm0X821buVtuMmRl0Q5Xv+7PXZttdc9o9MS4uRTTrIvyQ
 OYW8D19CSd2WroaThA+rh4zpjPPLCl5n2pGEArOkJXGSM+xRUq/txfN0HWZB8w1d0WYY
 9025AVIAUplkatHbcM6XMCPBqM3XcsOcUA92dWMs0v64xjGvuAy6rd1pRSmhvDXYphKW ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mb0hgq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CFeI9x018004;
        Thu, 12 Jan 2023 15:46:43 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2mb0hgp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30BMNev4032022;
        Thu, 12 Jan 2023 15:46:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n1kuc1xx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 15:46:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CFkbTs44827094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 15:46:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1257320049;
        Thu, 12 Jan 2023 15:46:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D405B2004B;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 15:46:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 6/7] s390x: Clear first stack frame and end backtrace early
Date:   Thu, 12 Jan 2023 15:45:47 +0000
Message-Id: <20230112154548.163021-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112154548.163021-1-frankja@linux.ibm.com>
References: <20230112154548.163021-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0puERrryjr-kODmQk9r0OQ-HY47jFlwD
X-Proofpoint-ORIG-GUID: _q5m8CFPSiikPheePQe1KaMUbiw_BB7r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When setting the first stack frame to 0, we can check for a 0
backchain pointer when doing backtraces to know when to stop.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/stack.c | 2 ++
 s390x/cstart64.S  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index e714e07c..9f234a12 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -22,6 +22,8 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	for (depth = 0; stack && depth < max_depth; depth++) {
 		return_addrs[depth] = (void *)stack->grs[8];
 		stack = stack->back_chain;
+		if (!stack)
+			break;
 	}
 
 	return depth;
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 666a9567..6f83da2a 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -37,6 +37,8 @@ start:
 	sam64				# Set addressing mode to 64 bit
 	/* setup stack */
 	larl	%r15, stackptr
+	/* Clear first stack frame */
+	xc      0(160,%r15), 0(%r15)
 	/* setup initial PSW mask + control registers*/
 	larl	%r1, initial_psw
 	lpswe	0(%r1)
-- 
2.34.1

