Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824055BDE3C
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiITHcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiITHcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:32:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058FE5C9E0;
        Tue, 20 Sep 2022 00:32:10 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7C0Ak005828;
        Tue, 20 Sep 2022 07:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=lCZTiM3nGoxQyg4TriCgaJ7Ni50ZCoeazIAdurTY4uo=;
 b=mX7F1zNgxBIn99rY4wSlbaXQeFFFmRPDZc0TkrbLXMZyqiLdbcPaKyBlnzyv8EcN/7/Q
 7LKLpVtO/4S1yWOELwJlSWQsiZQs4pgfa1EZysByVxlKkL1Qte4KVVeP3GUYI3B9zmyZ
 Mo4hYwpLDkipfpRHNzO4FtlmG8U2vZ699jRHS0tj8Z77qxMBavWIlkE03tkN/uVXRTbE
 aGmMFPRTWzfTQCruOYrggDhNaGN3TPba099h0LIa8F2HsHz+Z6KtkqNcjA4BTDVQP4/1
 GOk4jJgdh4YqS7tJT2PExMP/DWtsO8XtY3yFHBuIXf3gBmF5R3QHz5uisi411bwj6u/y lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu8hw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:10 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7DIhn012802;
        Tue, 20 Sep 2022 07:32:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu8hun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7L6UL029483;
        Tue, 20 Sep 2022 07:32:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3jn5v8kgb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7W3kc39977278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1BC111C050;
        Tue, 20 Sep 2022 07:32:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D75F011C04A;
        Tue, 20 Sep 2022 07:32:02 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 04/11] lib/s390x: fix SMP setup bug
Date:   Tue, 20 Sep 2022 07:30:28 +0000
Message-Id: <20220920073035.29201-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H8Pepv9jxR4mJpmdFBBdXK7QXzuAN0k8
X-Proofpoint-GUID: lkbms8x9Cstsvcoa6xszT75Eidfny9KT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=868 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

The lowcore pointer pointing to the current CPU (THIS_CPU) was not
initialized for the boot CPU. The pointer is needed for correct
interrupt handling, which is needed in the setup process before the
struct cpu array is allocated.

The bug went unnoticed because some environments (like qemu/KVM) clear
all memory and don't write anything in the lowcore area before starting
the payload. The pointer thus pointed to 0, an area of memory also not
used. Other environments will write to memory before starting the
payload, causing the unit tests to crash at the first interrupt.

Fix by assigning a temporary struct cpu before the rest of the setup
process, and assigning the pointer to the correct allocated struct
during smp initialization.

Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220818152114.213135-1-imbrenda@linux.ibm.com
Message-Id: <20220818152114.213135-1-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/io.c  | 9 +++++++++
 lib/s390x/smp.c | 1 +
 2 files changed, 10 insertions(+)

diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index a4f1b113..fb7b7dda 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -33,6 +33,15 @@ void puts(const char *s)
 
 void setup(void)
 {
+	struct cpu this_cpu_tmp = { 0 };
+
+	/*
+	 * Set a temporary empty struct cpu for the boot CPU, needed for
+	 * correct interrupt handling in the setup process.
+	 * smp_setup will allocate and set the permanent one.
+	 */
+	THIS_CPU = &this_cpu_tmp;
+
 	setup_args_progname(ipl_args);
 	setup_facilities();
 	sclp_read_info();
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 0d98c17d..03d6d2a4 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -353,6 +353,7 @@ void smp_setup(void)
 			cpus[0].stack = stackptr;
 			cpus[0].lowcore = (void *)0;
 			cpus[0].active = true;
+			THIS_CPU = &cpus[0];
 		}
 	}
 	spin_unlock(&lock);
-- 
2.34.1

