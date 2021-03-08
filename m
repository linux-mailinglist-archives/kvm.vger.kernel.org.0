Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD73310EA
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCHOe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:34:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230039AbhCHOdw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:52 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXlRb060024;
        Mon, 8 Mar 2021 09:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=A52HV3bIqhS58uBtsO1RgpH5Y0BHs9ji2fQCIQV+Nbg=;
 b=OomnHId9xBv8BiJkya6FvEzx0LdYt10g7lr02jIOzIE29z7KksSKgH07O6qvEKw2CNNV
 gN+D9m72QdzkQo2uFiA6EOYXTrMIYJ4zzmBQlOu7N1NFZj7Y7AJcB4eeijvMQUUidIEs
 dSyTOBVfph1y4s0pggMl0flyPt0Sz2oYxdlheTrYXwBJgHYI57v4imTXv5srI70c9Wg/
 ruq9m+t5oYWkyI9hQLO9aIRDQ8KwdC9Xgtoass/M8jLKFDKpCG9E1ZOknA6xnC03JP9f
 3dsbqgaF4o5vkbi1kfjgPILkXCueeqMenqYivac+IK8+QBcQCQP1t/qLm+CZG3TJ4D8U FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nqbg50d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:52 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXp59060478;
        Mon, 8 Mar 2021 09:33:51 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nqbg4x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:51 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXFMh017709;
        Mon, 8 Mar 2021 14:33:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3741c8102a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXhpS57409838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CE22A4040;
        Mon,  8 Mar 2021 14:33:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7683A404D;
        Mon,  8 Mar 2021 14:33:42 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 12/16] s390x: Move diag308_load_reset to stack saving
Date:   Mon,  8 Mar 2021 15:31:43 +0100
Message-Id: <20210308143147.64755-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By moving the last user of SAVE/RESTORE_REGS to the macros that use
the stack we can finally remove these macros.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
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
2.29.2

