Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8EB31DBA1
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhBQOnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233505AbhBQOnI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEZBDn188842;
        Wed, 17 Feb 2021 09:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Xqc35cvasdCHclFGwPstKEi+cJfYrN17J75uqGFzP4Q=;
 b=s4o05KVW9Dl0dkHNh1DyvwULSPV6J0mQK7Kc4twrLkPpsFedchPGHLaYjSuFamV6AlIv
 +TmDIXunNuzyJIgdchIDnBAHG4eb1NtnAN4Ac4biMAEUJTkWZTSzY0VUoAH6+0JLiQAo
 BW2SExi/IbHKHjGD242VNHTk/uGLDCgY27o1hVnaQSCLYgERVbQb1fESwL9B9krFZlhc
 Z6Mi5DYgRHgQkWv7hjO2XVDlKFvSpmrAxcE+QQaTH9xI73Ploojw6yhPEeKzhjzY6eYN
 P56F2Fmr5gYN8Wdbonc3h+rIHCXhofX2Vq7AfWmUDlVPNAYLIKXy7F+Q8hp0aAaBhgzm GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s3ew3sma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:28 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEafmx003292;
        Wed, 17 Feb 2021 09:42:27 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s3ew3sk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:27 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEfcY1014573;
        Wed, 17 Feb 2021 14:42:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u8d1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgACp28443070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AD3E11C054;
        Wed, 17 Feb 2021 14:42:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 674C211C04A;
        Wed, 17 Feb 2021 14:42:21 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/8] RFC: s390x: Define STACK_FRAME_INT_SIZE macro
Date:   Wed, 17 Feb 2021 09:41:11 -0500
Message-Id: <20210217144116.3368-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217144116.3368-1-frankja@linux.ibm.com>
References: <20210217144116.3368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_12:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 spamscore=0 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using sizeof is safer than using magic constants. However, it doesn't
really fit into asm-offsets.h as it's not an offset so I'm happy to
receive suggestions on where to put it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm-offsets.c | 1 +
 s390x/macros.S          | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 96cb21cf..2658b59a 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -86,6 +86,7 @@ int main(void)
 	OFFSET(STACK_FRAME_INT_CRS, stack_frame_int, crs);
 	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
 	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
+	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
 
 	return 0;
 }
diff --git a/s390x/macros.S b/s390x/macros.S
index d7eeeb55..a7d62c6f 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -43,14 +43,14 @@
 /* Save registers on the stack (r15), so we can have stacked interrupts. */
 	.macro SAVE_REGS_STACK
 	/* Allocate a full stack frame */
-	slgfi   %r15, 32 * 8 + 4 * 8
+	slgfi   %r15, STACK_FRAME_INT_SIZE
 	/* Store registers r0 to r14 on the stack */
 	stmg    %r2, %r15, STACK_FRAME_INT_GRS0(%r15)
 	stg     %r0, STACK_FRAME_INT_GRS1(%r15)
 	stg     %r1, STACK_FRAME_INT_GRS1 + 8(%r15)
 	/* Store the gr15 value before we allocated the new stack */
 	lgr     %r0, %r15
-	algfi   %r0, 32 * 8 + 4 * 8
+	algfi   %r0, STACK_FRAME_INT_SIZE
 	stg     %r0, 13 * 8 + STACK_FRAME_INT_GRS0(%r15)
 	stg     %r0, STACK_FRAME_INT_BACKCHAIN(%r15)
 	/*
-- 
2.25.1

