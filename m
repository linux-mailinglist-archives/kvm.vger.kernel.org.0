Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817DC321279
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 10:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBVJAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 04:00:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230053AbhBVJAI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 04:00:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11M8wfjD006403;
        Mon, 22 Feb 2021 03:59:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+FTc0w1vsiAc14D6ch6Syf+UBspagILGDJ+zCsUiVTM=;
 b=kPTNIXS6XUM4y9za9Szz6VFBqk5SquZBx+xgvQxnmbBlSDgJOXPgFHK7R6v+YG8xl404
 JPn6suMhLt2cL6HWe/AoLFp4yLjVdd7bLb5d2Tm3nntcxQIseMwblvMC1DGJubDZsxVf
 Uv7lQDGGadcJ4FcJd1xIKH4aoH2Weo8gqk7hH0Ar2o5l9rKHWbTrOXWy3BcctfTU/L5F
 AkkiOway6lG9Ht3rYGV7fpZ5QlXYfn7I9+snoDFLoffj5Wug9ie+jOt35NHH1Yox93HW
 YrqY/rNXAYy+58dUP6eZux9gz/+rQZ9EyQdUNSrr+y1Op7xrJLPCTAY0mosbi8+1Fcei QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36v9jx81fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 03:59:26 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11M8x8a7010321;
        Mon, 22 Feb 2021 03:59:25 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36v9jx815y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 03:59:25 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8vBAM024170;
        Mon, 22 Feb 2021 08:59:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 36tt288rbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8xDlZ20906444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:59:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B49CCAE045;
        Mon, 22 Feb 2021 08:59:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02E33AE04D;
        Mon, 22 Feb 2021 08:59:13 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/7] s390x: Move diag308_load_reset to stack saving
Date:   Mon, 22 Feb 2021 03:57:55 -0500
Message-Id: <20210222085756.14396-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222085756.14396-1-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-18,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 spamscore=0 mlxscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102220071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By moving the last user of SAVE/RESTORE_REGS to the macros that use
the stack we can finally remove these macros.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/cpu.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/s390x/cpu.S b/s390x/cpu.S
index 5267f029..e2ad56c8 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -18,7 +18,7 @@
  */
 .globl diag308_load_reset
 diag308_load_reset:
-	SAVE_REGS
+	SAVE_REGS_STACK
 	/* Backup current PSW mask, as we have to restore it on success */
 	epsw	%r0, %r1
 	st	%r0, GEN_LC_SW_INT_PSW
@@ -31,6 +31,7 @@ diag308_load_reset:
 	ogr	%r0, %r1
 	/* Store it at the reset PSW location (real 0x0) */
 	stg	%r0, 0
+	stg     %r15, GEN_LC_SW_INT_GRS + 15 * 8
 	/* Do the reset */
 	diag    %r0,%r2,0x308
 	/* Failure path */
@@ -40,7 +41,8 @@ diag308_load_reset:
 	/* load a cr0 that has the AFP control bit which enables all FPRs */
 0:	larl	%r1, initial_cr0
 	lctlg	%c0, %c0, 0(%r1)
-	RESTORE_REGS
+	lg      %r15, GEN_LC_SW_INT_GRS + 15 * 8
+	RESTORE_REGS_STACK
 	lhi	%r2, 1
 	larl	%r0, 1f
 	stg	%r0, GEN_LC_SW_INT_PSW + 8
-- 
2.25.1

