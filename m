Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0463150EF
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 14:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhBINxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 08:53:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15938 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231845AbhBINvd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 08:51:33 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119DWHd2172020;
        Tue, 9 Feb 2021 08:50:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+FTc0w1vsiAc14D6ch6Syf+UBspagILGDJ+zCsUiVTM=;
 b=pTs6+3mx441soC6THKdbK8nqxSiZy14IwC5HRoxtSbGyKsR/vP/Bib89ZSlZ4S3stnAm
 gZLSIS43rJOJt2D7zr/Rr/V+mKg34aBszEB+VUz5vo7fKbhm0RX77wzDYFIuPigmccHc
 dA3b5kJ/fJO/XmeAeu1mhW/jCUZtx8o5bekQRBFFz8MuDT+cruyhNSYKunHvcANu0Nie
 d7xymASaTQ0+Bv/E/Z7AF7TjNIFmPv5FT8VL1IRurpg7MpNjgX0ztVRZrnmDLOhq+cIF
 aMX+eeV0dJT+MrEq2hevd4t+FwFiXW/uMK0LhFAiAUfYJSSQpbi9O65R8aS4LJwKh1mu Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kts6a202-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:52 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119DWv36174620;
        Tue, 9 Feb 2021 08:50:51 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kts6a1yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:51 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119DSl8d024913;
        Tue, 9 Feb 2021 13:50:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wjm21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:50:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119Doll746006682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 13:50:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 379B8A404D;
        Tue,  9 Feb 2021 13:50:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79C2EA4040;
        Tue,  9 Feb 2021 13:50:46 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 13:50:46 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 7/8] s390x: Move diag308_load_reset to stack saving
Date:   Tue,  9 Feb 2021 08:49:24 -0500
Message-Id: <20210209134925.22248-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209134925.22248-1-frankja@linux.ibm.com>
References: <20210209134925.22248-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090067
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

