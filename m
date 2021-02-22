Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02E32127C
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 10:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhBVJAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 04:00:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229934AbhBVJAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 04:00:00 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11M8whfB141485;
        Mon, 22 Feb 2021 03:59:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vuRLhnrN0FZn6h/Va0uxgrip9AUObOGa8pIcB5cKFpY=;
 b=Uk4+MlTJ3sCIHdSGLsoMSKZsYFBAvHilEnzQ3jEuga8Lc4tL3fuOYLHwgtYVGIgT8SOW
 KICz+xVSkWbvlUtpa4SFJYAPyQ/OFM/NUeQkFvpUee3icFmOwzw2VfLzHnisf84HkBBp
 AbGNPKyb96QF19Hl5qCEvn+TPbFjOdibrHj3Ydh7N39JoIFiUucejQTbNUzCKTSTTbDE
 i6HhQh4rLADLb+rbhcuX5WwFkI3+sIJ8PU8977zCeNqWfyK4/OxC1NmjVfhFIZQbnETi
 h21EzVxIpj1K1RFqq+Ehw6GJTbEDG+ecXznBlkLvtn6zC5uvQW6W9JEAGVf5cmaLRUUP og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36v9jt81eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 03:59:18 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11M8x2Pc143321;
        Mon, 22 Feb 2021 03:59:16 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36v9jt81c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 03:59:16 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8wDdO029103;
        Mon, 22 Feb 2021 08:59:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt281exx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8wvMK14025056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:58:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69559AE04D;
        Mon, 22 Feb 2021 08:59:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA9ECAE053;
        Mon, 22 Feb 2021 08:59:08 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/7] s390x: Fix fpc store address in RESTORE_REGS_STACK
Date:   Mon, 22 Feb 2021 03:57:50 -0500
Message-Id: <20210222085756.14396-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222085756.14396-1-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-18,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The efpc stores in bits 32-63 of a register and we store a full 8
bytes to have the stack 8 byte aligned. This means that the fpc is
stored at offset 4 but we load it from offset 0. Lets replace efpc
with stfpc and get rid of the stg to store at offset 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/macros.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/s390x/macros.S b/s390x/macros.S
index 37a6a63e..e51a557a 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -54,8 +54,7 @@
 	.endr
 	/* Save fpc, but keep stack aligned on 64bits */
 	slgfi   %r15, 8
-	efpc	%r0
-	stg	%r0, 0(%r15)
+	stfpc	0(%r15)
 	.endm
 
 /* Restore the register in reverse order */
-- 
2.25.1

