Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F953150F1
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 14:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhBINxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 08:53:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231728AbhBINvf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 08:51:35 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119DXa50041784;
        Tue, 9 Feb 2021 08:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1w2R0H+zZaPAxNLebxHCGdeAQtUfmwDXW3jtsS2J85w=;
 b=cWo/KBEXTA0rlbcJlVnCwqUJHRUVw2pMls/cO7P1IUw1bUVBNPPfpXo8ZFtZg/SUoMCJ
 4upiVr2pemGTx4Fivew6GwZ1+uU1FsEM3XTP/qVxxo696sm49fS2/rdH9Ngo2PI6InRT
 kaPWG2UzvK3SMywmW3fhOn0sJuplrRqtv0LVnhl8Mi9YlO6v42VRx4/9x/nKvNoR2u44
 jq64rSvF4OZIwWrPeYhsi4vPmA5Lk51KiahMIMZ/gFtzYyEVN/Bl3bADvBku+kmoj3dA
 3jj3NV9lpw+MwrQDrGymETi3RtFylBQgoG0gN2zqFdf4JYssoX27Ffn1h35kIZn512MH eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ku3j1744-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:54 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119DXfEq042497;
        Tue, 9 Feb 2021 08:50:54 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ku3j1731-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:53 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119DShbi011212;
        Tue, 9 Feb 2021 13:50:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 36hqda36qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:50:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119Domki28180792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 13:50:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13F88A4053;
        Tue,  9 Feb 2021 13:50:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F307A4040;
        Tue,  9 Feb 2021 13:50:47 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 13:50:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 8/8] s390x: Remove SAVE/RESTORE_stack
Date:   Tue,  9 Feb 2021 08:49:25 -0500
Message-Id: <20210209134925.22248-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209134925.22248-1-frankja@linux.ibm.com>
References: <20210209134925.22248-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=813 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 impostorscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are no more users.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/macros.S | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/s390x/macros.S b/s390x/macros.S
index 1678c821..90a842d9 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -28,35 +28,6 @@
 	lpswe	\old_psw
 	.endm
 
-	.macro SAVE_REGS
-	/* save grs 0-15 */
-	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
-	/* save crs 0-15 */
-	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
-	/* load a cr0 that has the AFP control bit which enables all FPRs */
-	larl	%r1, initial_cr0
-	lctlg	%c0, %c0, 0(%r1)
-	/* save fprs 0-15 + fpc */
-	la	%r1, GEN_LC_SW_INT_FPRS
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8(%r1)
-	.endr
-	stfpc	GEN_LC_SW_INT_FPC
-	.endm
-
-	.macro RESTORE_REGS
-	/* restore fprs 0-15 + fpc */
-	la	%r1, GEN_LC_SW_INT_FPRS
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8(%r1)
-	.endr
-	lfpc	GEN_LC_SW_INT_FPC
-	/* restore crs 0-15 */
-	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
-	/* restore grs 0-15 */
-	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
-	.endm
-
 /* Save registers on the stack (r15), so we can have stacked interrupts. */
 	.macro SAVE_REGS_STACK
 	/* Allocate a full stack frame */
-- 
2.25.1

