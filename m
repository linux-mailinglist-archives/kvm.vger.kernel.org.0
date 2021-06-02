Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3054B398579
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 11:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhFBJpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 05:45:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232199AbhFBJps (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 05:45:48 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1529YK6J071536;
        Wed, 2 Jun 2021 05:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=64HNf+sRUTdnPsioN/jnG7VbtoWicowH8lrDOMJtUJ0=;
 b=famX0c12jyYosYyQLniG3K8/NjjYUle8SuAfUHHCoVPIZWnqvW/SNZMzqa/JquNp+RgC
 XlAv2ZRF5m8PxOPX5/qGeSRsWIQVu9hwodiZtGB9FvHtyKeCpEj/RO+s6CtaEkfw46+D
 mu4KKD4FJSF2QRX9cNeU+Dl3/ztDsZr5SFCAY/C3CNi4W71m5oKmmvUXaTLWoPeIvr7I
 U/KeQ0Hvi1kqsY6vn67zOeSLvCVTucpxXenbY7rgCWOJpwmCQorp2POC/YNXf1PnsCLM
 UV2EC77hr1FKgCDzXrrH1MUOCRrQBiFj/4l3O2yI+y9FoO5HpoWK15MgshbsnCfFKPtk dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38x76frn64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 05:44:04 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1529ZmIg076417;
        Wed, 2 Jun 2021 05:44:04 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38x76frn59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 05:44:04 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1529i2F9014451;
        Wed, 2 Jun 2021 09:44:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 38w413rk0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 09:44:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1529hxf528770684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 09:43:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62E6EA4040;
        Wed,  2 Jun 2021 09:43:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9975A404D;
        Wed,  2 Jun 2021 09:43:58 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 09:43:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: sie: Only overwrite r3 if it isn't needed anymore
Date:   Wed,  2 Jun 2021 09:43:52 +0000
Message-Id: <20210602094352.11647-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jQBYNSaifPsFuhtEPf0gp6PhkYHRWIJ8
X-Proofpoint-ORIG-GUID: VDWdd1Bf_1ewCeQYq6E0jL3PQmOnTZmi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_05:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=758
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lmg overwrites r3 which we later use to reference the fprs and fpc.
Let's do the lmg at the end where overwriting is fine.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

Finding this took me longer than I'd like to admit. :)

---
 s390x/cpu.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/cpu.S b/s390x/cpu.S
index e2ad56c8..82b5e25d 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -81,11 +81,11 @@ sie64a:
 	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
 
 	# Load guest's gprs, fprs and fpc
-	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
 	.endr
 	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
+	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
 
 	# Move scb ptr into r14 for the sie instruction
 	lg	%r14,__SF_SIE_CONTROL(%r15)
-- 
2.30.2

