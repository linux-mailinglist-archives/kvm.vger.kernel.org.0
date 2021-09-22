Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636BD414285
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhIVHVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233215AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M5TmRt024821;
        Wed, 22 Sep 2021 03:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jayG4sjHlcqlJtBRpjoozO+/1jT7Mf9MKETnMX4iE5Q=;
 b=YtEHqYo67FXcqQESwqNUN/vv4/kKhymmTnrxtxb8l4zAsmVhDH1wP19nc2TvHKS0z+Mv
 cbkJswKf+in9QXx18zJNFJGXJmVO95fOA8cf7J7tdX7BqwnDzA2BdkBkPojkc4Jf2VU8
 8wzT5PrAkSNXFpGAnf1eZUdu+/GsiwtvTf8G/vE98BAzavESSAzgIV01W1UjcVuyqsfv
 46ocQFwGcScWwx6NWMG7VjyIg0puot7SpX2FCi5VSi5UM2MAyoaljKU/7gGqekxwhbX2
 QnNlb2lwJ8GTl1QFFmzwZCY1boikDslWyTnXWNu4zGFkrnvawVcISyj5N9TQCAytgas7 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7xd1j1bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:00 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M6o9YE032268;
        Wed, 22 Sep 2021 03:18:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7xd1j1b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:18:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M77xRa030153;
        Wed, 22 Sep 2021 07:18:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3b7q6qugp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:18:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7Is905177990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:18:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10689A404D;
        Wed, 22 Sep 2021 07:18:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CF83A4057;
        Wed, 22 Sep 2021 07:18:53 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:53 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/9] s390x: uv: Tolerate 0x100 query return code
Date:   Wed, 22 Sep 2021 07:18:03 +0000
Message-Id: <20210922071811.1913-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iBLB5ks_wryGRUPJxP3aw0Po3RIxAfxv
X-Proofpoint-ORIG-GUID: tR4hiN3njITHVBIeS21y-YC2jXf-smGJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RC 0x100 is not an error but a notice that we could have gotten more
data from the Ultravisor if we had asked for it. So let's tolerate
them in our tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-guest.c | 4 ++--
 s390x/uv-host.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index f05ae4c3..e7446e03 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -70,8 +70,8 @@ static void test_query(void)
 	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
 
 	uvcb.header.len = sizeof(uvcb);
-	cc = uv_call(0, (u64)&uvcb);
-	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
+	uv_call(0, (u64)&uvcb);
+	report(uvcb.header.rc == UVC_RC_EXECUTED || uvcb.header.rc == 0x100, "successful query");
 
 	/*
 	 * These bits have been introduced with the very first
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 28035707..66a11160 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -401,7 +401,7 @@ static void test_query(void)
 
 	uvcb_qui.header.len = sizeof(uvcb_qui);
 	uv_call(0, (uint64_t)&uvcb_qui);
-	report(uvcb_qui.header.rc == UVC_RC_EXECUTED, "successful query");
+	report(uvcb_qui.header.rc == UVC_RC_EXECUTED || uvcb_qui.header.rc == 0x100, "successful query");
 
 	for (i = 0; cmds[i].name; i++)
 		report(uv_query_test_call(cmds[i].call_bit), "%s", cmds[i].name);
-- 
2.30.2

