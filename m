Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF253AEAB5
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhFUOGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:06:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229790AbhFUOGR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:06:17 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LE30DR083781;
        Mon, 21 Jun 2021 10:04:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5q39wVgWkoFymBF9j6J2Hp0k6GZxpxhCSW78VZSap9g=;
 b=Z30E5Nthk5bXMrWFRUg/mX29AC8AowGUhA6MCZGupKty+BFAD/4dLfavsTam+954jPTX
 kzNrBQfXaG6JjfUFIkxWKwp2MGkqFH6ELRE2og1EIOBgZMHjQ2jsMsGijeZ15L5P7sJn
 Opx4hAHXmFDvbiQ0lQ5/82a+bCo5ts7v/qp/n//d1uTA6SCu7CbelJX5xrsiDaIST2or
 TU8F0ResAvu7o+iESY3iIigVsBX1i5Mgz/O/3qY7yCCx3NLI3oMJSGiA8O2AWWBj1bi/
 uUYqJ3v7Ei5jofpjnpmfhpc+TMa/3b+Z9l8zEv6bBhCZLR1F7Meo9qQIncdQphlkp1cm fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39atfbupd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:04:02 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LE31M0084544;
        Mon, 21 Jun 2021 10:04:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39atfbupbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 10:04:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LE3fuJ011481;
        Mon, 21 Jun 2021 14:03:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3998788xka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 14:03:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LE3uPu34668958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 14:03:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 790E052052;
        Mon, 21 Jun 2021 14:03:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3EEB852050;
        Mon, 21 Jun 2021 14:03:56 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: get rid of register asm usage
Date:   Mon, 21 Jun 2021 16:03:56 +0200
Message-Id: <20210621140356.1210771-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: esnSWSs1MF9jr4TDKz-ziSGDV_SVa8bK
X-Proofpoint-ORIG-GUID: 59X_dXGFuzBv1j3MdVQdNQ-679Yn6_x4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1011 mlxlogscore=999 spamscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using register asm statements has been proven to be very error prone,
especially when using code instrumentation where gcc may add function
calls, which clobbers register contents in an unexpected way.

Therefore get rid of register asm statements in kvm code, even though
there is currently nothing wrong with them. This way we know for sure
that this bug class won't be introduced here.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1296fc10f80c..4b7b24f07790 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
 
 static inline int plo_test_bit(unsigned char nr)
 {
-	register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
+	unsigned long function = (unsigned long) nr | 0x100;
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
2.25.1

