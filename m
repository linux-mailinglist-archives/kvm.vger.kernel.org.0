Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04AC2EDADE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 09:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfKDI4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 03:56:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbfKDI4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 03:56:37 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA48qcrx063700
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 03:56:36 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w2eapmtck-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 03:56:25 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 08:54:44 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 08:54:41 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA48sedA47514050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 08:54:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDDB14C040;
        Mon,  4 Nov 2019 08:54:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A65B34C044;
        Mon,  4 Nov 2019 08:54:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Nov 2019 08:54:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH] s390x: Use loop to save and restore fprs
Date:   Mon,  4 Nov 2019 03:55:33 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19110408-0028-0000-0000-000003B26ED6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110408-0029-0000-0000-00002474C153
Message-Id: <20191104085533.2892-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=582 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's save some lines in the assembly by using a loop to save and
restore the fprs.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/cstart64.S | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 5dc1577..8e2b21e 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -99,44 +99,18 @@ memsetxc:
 	lctlg	%c0, %c0, 0(%r1)
 	/* save fprs 0-15 + fpc */
 	la	%r1, GEN_LC_SW_INT_FPRS
-	std	%f0, 0(%r1)
-	std	%f1, 8(%r1)
-	std	%f2, 16(%r1)
-	std	%f3, 24(%r1)
-	std	%f4, 32(%r1)
-	std	%f5, 40(%r1)
-	std	%f6, 48(%r1)
-	std	%f7, 56(%r1)
-	std	%f8, 64(%r1)
-	std	%f9, 72(%r1)
-	std	%f10, 80(%r1)
-	std	%f11, 88(%r1)
-	std	%f12, 96(%r1)
-	std	%f13, 104(%r1)
-	std	%f14, 112(%r1)
-	std	%f15, 120(%r1)
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8(%r1)
+	.endr
 	stfpc	GEN_LC_SW_INT_FPC
 	.endm
 
 	.macro RESTORE_REGS
 	/* restore fprs 0-15 + fpc */
 	la	%r1, GEN_LC_SW_INT_FPRS
-	ld	%f0, 0(%r1)
-	ld	%f1, 8(%r1)
-	ld	%f2, 16(%r1)
-	ld	%f3, 24(%r1)
-	ld	%f4, 32(%r1)
-	ld	%f5, 40(%r1)
-	ld	%f6, 48(%r1)
-	ld	%f7, 56(%r1)
-	ld	%f8, 64(%r1)
-	ld	%f9, 72(%r1)
-	ld	%f10, 80(%r1)
-	ld	%f11, 88(%r1)
-	ld	%f12, 96(%r1)
-	ld	%f13, 104(%r1)
-	ld	%f14, 112(%r1)
-	ld	%f15, 120(%r1)
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8(%r1)
+	.endr
 	lfpc	GEN_LC_SW_INT_FPC
 	/* restore cr0 */
 	lctlg	%c0, %c0, GEN_LC_SW_INT_CR0
-- 
2.20.1

