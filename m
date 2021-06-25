Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D533B427C
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFYL1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 07:27:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3386 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhFYL1C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 07:27:02 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PB4CRW057923;
        Fri, 25 Jun 2021 07:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=AcedcyUpZr5T9nZwK5wF2eiTun2pRQIMqHMcz5FuPMM=;
 b=Di/EvT38ULQP/0Mjcd1gMlx9QI2ETN8fLFTkIL+N2OQHZp0wFXlw7JzPJORl6UulQKEs
 GPPP6vijmHvivSvw5lgapViwfcVFrWWUMplasfK/dPnPT/FYRriLqq7E8FYFS9TGqlYq
 4QZiqoVEDjmCP2+NaebmI4XVXPiOvagOn+tI49VVrvPutEUjGJOtBrE0U8C2QBXHcE4w
 Xboew7yJRFe/wIsynvbAjUn3ezGBdZY9CUrQlES4E0Y9mRPu/yzWHIOxqj+cxYdRW6Bt
 NCYlqnno9eMgOSyl3sl6rBK5e4nJh/vh12RAOQdkJu+dStVYPL0kE1aPbRDwwvZjHbgd qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39dan2014x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:41 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15PB4tfk060390;
        Fri, 25 Jun 2021 07:24:41 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39dan2013k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:40 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15PBHIZb019905;
        Fri, 25 Jun 2021 11:24:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3998789p4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 11:24:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15PBN8Fb37945634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 11:23:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29D97AE04D;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17C07AE045;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id CCA7EE07DE; Fri, 25 Jun 2021 13:24:34 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 1/3] KVM: s390: get rid of register asm usage
Date:   Fri, 25 Jun 2021 13:24:32 +0200
Message-Id: <20210625112434.12308-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625112434.12308-1-borntraeger@de.ibm.com>
References: <20210625112434.12308-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VBeqpPB290Lr2_Izes0qzQ-nrqbZrRAW
X-Proofpoint-GUID: Uwc63NTjydeRCw-QY0t4SD0CHeYnIycy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_03:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

Using register asm statements has been proven to be very error prone,
especially when using code instrumentation where gcc may add function
calls, which clobbers register contents in an unexpected way.

Therefore get rid of register asm statements in kvm code, even though
there is currently nothing wrong with them. This way we know for sure
that this bug class won't be introduced here.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20210621140356.1210771-1-hca@linux.ibm.com
[borntraeger@de.ibm.com: checkpatch strict fix]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1296fc10f80c..876fc1f7282a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
 
 static inline int plo_test_bit(unsigned char nr)
 {
-	register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
+	unsigned long function = (unsigned long)nr | 0x100;
 	int cc;
 
 	asm volatile(
+		"	lgr	0,%[function]\n"
 		/* Parameter registers are ignored for "test bit" */
 		"	plo	0,0,0,0(0)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
 		: "=d" (cc)
-		: "d" (r0)
-		: "cc");
+		: [function] "d" (function)
+		: "cc", "0");
 	return cc == 0;
 }
 
 static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
 {
-	register unsigned long r0 asm("0") = 0;	/* query function */
-	register unsigned long r1 asm("1") = (unsigned long) query;
-
 	asm volatile(
-		/* Parameter regs are ignored */
+		"	lghi	0,0\n"
+		"	lgr	1,%[query]\n"
+		/* Parameter registers are ignored */
 		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
 		:
-		: "d" (r0), "a" (r1), [opc] "i" (opcode)
-		: "cc", "memory");
+		: [query] "d" ((unsigned long)query), [opc] "i" (opcode)
+		: "cc", "memory", "0", "1");
 }
 
 #define INSN_SORTL 0xb938
-- 
2.31.1

