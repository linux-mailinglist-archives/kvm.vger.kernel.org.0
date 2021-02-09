Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA9A3150E1
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 14:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhBINww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 08:52:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231837AbhBINvb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 08:51:31 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119Dm0Gf126293;
        Tue, 9 Feb 2021 08:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vr4Kycj4qsLBCKkAS63hmKfgiCRSaTd1pHFQ1yUBA8I=;
 b=k+n84joCIHuVp8zHY9Y3a5x/c8SlGOQFh4rrT1jNXdrvorDWP6PxaGJKyM4CyPjEInCE
 MxMZsvfNos9hYOTtLY4yoOMddU88FNiNkf3kIb5JAFutU65v6x1N558LP+i6YpN/gcUs
 3zcwc+nbeaIVR9s49EP4CRG+wZMvjzjQNFI+rXnmTHo3dqwl/+FG/ae8ND0ElUiFzcXh
 QJtvBiuG6PJfmg4xZWy6rRHGRBXIqcoOPEhjsfThHunJ2XrlTMr2+UjyT3hpL1u2gMQw
 /XJZshsU9+uQlp2PlWAU+vMAkdnsLZbumYth5z9hSAyqxko0pSeQ4TKwdkcNo3zIVQ7K Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kuke834g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:49 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119Dmu4n133720;
        Tue, 9 Feb 2021 08:50:49 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kuke833m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:48 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119DSjWv024906;
        Tue, 9 Feb 2021 13:50:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wjm1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:50:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119DoXlf35782988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 13:50:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0142A4051;
        Tue,  9 Feb 2021 13:50:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1679FA4059;
        Tue,  9 Feb 2021 13:50:43 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 13:50:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/8] RFC: s390x: Define STACK_FRAME_INT_SIZE macro
Date:   Tue,  9 Feb 2021 08:49:20 -0500
Message-Id: <20210209134925.22248-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209134925.22248-1-frankja@linux.ibm.com>
References: <20210209134925.22248-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090068
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
index a8942395..8eeb6dea 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -86,6 +86,7 @@ int main(void)
 	OFFSET(STACK_FRAME_INT_CR0, stack_frame_int, cr0);
 	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
 	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
+	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
 
 	return 0;
 }
diff --git a/s390x/macros.S b/s390x/macros.S
index 1c8a0f7c..9810d2ff 100644
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

