Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8921331DBAA
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhBQOn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233568AbhBQOnM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:12 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEVcI8007727;
        Wed, 17 Feb 2021 09:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+FTc0w1vsiAc14D6ch6Syf+UBspagILGDJ+zCsUiVTM=;
 b=PMVKeinTWoQj+ej9ro36uNIx8jA6hG3GfF4IHw8wTI86X/KpU9++iLoKBGsCdf4ZLSJ9
 9EVBYqypDyM2Ks6lDH5/7kNsss4h+QnaGKnqnmhpBcvhV6FcSMKvVrCxv1JmkcGYQJY8
 lo5/nQSMEwYqbx5yKRJ14+I4iE8Vx8s36+GX+1QFTo2iRA9kuep449xymuVZJoy0f7yl
 T5bfB/u9cGsR72jGfoF0Y5YbsWBiSt55OzYyiZeraeOskub3EeTUqaB1uuRi008fW6uY
 Bmm6zq8N1B5zgdlrmPgmKveYDX7rZTiknLfbX4KBukqRt2N8LXXxWxfzse22P4Vw0Kyr Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s4uk0sjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:31 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEWXvb011150;
        Wed, 17 Feb 2021 09:42:31 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s4uk0shj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:31 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEXbxe029102;
        Wed, 17 Feb 2021 14:42:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 36p6d89y6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgPbF36110822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8569511C04A;
        Wed, 17 Feb 2021 14:42:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C846F11C04C;
        Wed, 17 Feb 2021 14:42:24 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 7/8] s390x: Move diag308_load_reset to stack saving
Date:   Wed, 17 Feb 2021 09:41:15 -0500
Message-Id: <20210217144116.3368-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217144116.3368-1-frankja@linux.ibm.com>
References: <20210217144116.3368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_11:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170109
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

