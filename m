Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C022F3310DE
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhCHOd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229805AbhCHOdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:47 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXhLY067643;
        Mon, 8 Mar 2021 09:33:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Jmn+A8Owzkv7CkZQ9Soe1eVVGmvw7OKjuzH6ILBUoVo=;
 b=Y+TgKCVRIr171P63tijwBJsnFZgI7fc7nPby7HW2v4KxqH3AI0Xj6SOcSklRUI6eEOBN
 vRIsFr2iyWtzUiOQQZ4oydaVNtAYzNValzlzV5xvBey/3OAbFJyat+Pch3ED0dgbcpz5
 dxXE7FpysAGnQjeLwyIxTzKxVOfQ/YgX0wNTPFO097mv6jkugGIv1ULEJagqLnj+5f6r
 TVp7E2yeRSo+p13uZIUT3CH4c+kEoEnn+nQxY20wBUx8jnoLGsKO8tO9XlZcxe9NC1aG
 o8DrcvFE2l/7hAWycs5tB3Ds1EeJ+P2GkwhQVeRJkCRvvag5OjNAwprYKqm0O3H58edM 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nke8ewa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:46 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXkoN068007;
        Mon, 8 Mar 2021 09:33:46 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nke8ev9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:46 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EX7NZ012688;
        Mon, 8 Mar 2021 14:33:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3741c8hw9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXe4G35848526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3306A4057;
        Mon,  8 Mar 2021 14:33:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A2AFA404D;
        Mon,  8 Mar 2021 14:33:40 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:40 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 07/16] s390x: Fix fpc store address in RESTORE_REGS_STACK
Date:   Mon,  8 Mar 2021 15:31:38 +0100
Message-Id: <20210308143147.64755-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
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
2.29.2

