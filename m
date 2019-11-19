Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC68102139
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 10:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKSJxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 04:53:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbfKSJxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 04:53:47 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ9qbeD077396
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:53:46 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2way30xpcd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:53:46 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 19 Nov 2019 09:53:44 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 19 Nov 2019 09:53:42 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJ9reV228967070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 09:53:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D127252050;
        Tue, 19 Nov 2019 09:53:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 915F552057;
        Tue, 19 Nov 2019 09:53:40 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 2/3] s390x: sclp: add service call instruction wrapper
Date:   Tue, 19 Nov 2019 10:53:38 +0100
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
References: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111909-0008-0000-0000-000003333F8D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111909-0009-0000-0000-00004A525D5D
Message-Id: <1574157219-22052-3-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_02:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=1
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a wrapper for the service call instruction, and use it for SCLP
interactions instead of using inline assembly everywhere.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 13 +++++++++++++
 lib/s390x/sclp.c         |  7 +------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 96cca2e..b3caff6 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -269,4 +269,17 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
 	return cc;
 }
 
+static inline int servc(uint32_t command, unsigned long sccb)
+{
+	int cc;
+
+	asm volatile(
+		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
+		"       ipm     %0\n"
+		"       srl     %0,28"
+		: "=&d" (cc) : "d" (command), "a" (sccb)
+		: "cc", "memory");
+	return cc;
+}
+
 #endif
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 123b639..4054d0e 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -116,12 +116,7 @@ int sclp_service_call(unsigned int command, void *sccb)
 	int cc;
 
 	sclp_setup_int();
-	asm volatile(
-		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
-		"       ipm     %0\n"
-		"       srl     %0,28"
-		: "=&d" (cc) : "d" (command), "a" (__pa(sccb))
-		: "cc", "memory");
+	cc = servc(command, __pa(sccb));
 	sclp_wait_busy();
 	if (cc == 3)
 		return -1;
-- 
2.7.4

