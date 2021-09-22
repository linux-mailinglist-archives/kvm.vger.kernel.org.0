Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2B1414288
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhIVHVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231426AbhIVHUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:37 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M6fQ8F007698;
        Wed, 22 Sep 2021 03:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tVUxvXQEv/IA5jflOPoATXZeUFH4XUk9bmACzRnvkEI=;
 b=VnS7V9QiLD1k3rB9VfU6YiWGrq9/QkHA8n8KWLjC1+nwIRLI0SNEkw+x1GPoWjf+F7Fm
 yzR9403OUAlWyw0oTWGLzTLe4U+j8GsbGhls5lPv5aM/W98vRWhj6QENK2VHZkXm/W82
 6Xl0iASVaS74GtBkaBM//et1Ct7LJwHvhRKHh4UMDTqhHT2olutffGG1nVgLytdOde/K
 7y4TX1sTbwgxxFDOszmRZkzWHPvPmdDcLw6gepwU0cnfCIPpsRtW9NLjEdhwTOvu/Top
 t3qG/kyOS7OCAIv+m2tjyoLsS741/JRk3pb+0+SjBK5WPu/+JYv/M9PyG/fCw1VetXYn +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yeh0twx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:07 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M6wFCn006442;
        Wed, 22 Sep 2021 03:19:07 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yeh0tw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:06 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M774UV012471;
        Wed, 22 Sep 2021 07:19:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3b7q69ubbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:19:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7J0Y240763864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:19:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5CBCA4051;
        Wed, 22 Sep 2021 07:19:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18DB7A4055;
        Wed, 22 Sep 2021 07:19:00 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 8/9] s390x: Add sthyi cc==0 r2+1 verification
Date:   Wed, 22 Sep 2021 07:18:10 +0000
Message-Id: <20210922071811.1913-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k2QngRA3HbkIWKRBschk2XnvVhY7I9mt
X-Proofpoint-GUID: QvLWwR-cCOss4AMm5hwoq7KMhnvuC4er
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On success r2 + 1 should be 0, let's also check for that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/sthyi.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/s390x/sthyi.c b/s390x/sthyi.c
index db90b56f..4b153bf4 100644
--- a/s390x/sthyi.c
+++ b/s390x/sthyi.c
@@ -24,16 +24,16 @@ static inline int sthyi(uint64_t vaddr, uint64_t fcode, uint64_t *rc,
 {
 	register uint64_t code asm("0") = fcode;
 	register uint64_t addr asm("2") = vaddr;
-	register uint64_t rc3 asm("3") = 0;
+	register uint64_t rc3 asm("3") = 42;
 	int cc = 0;
 
-	asm volatile(".insn rre,0xB2560000,%[r1],%[r2]\n"
-		     "ipm	 %[cc]\n"
-		     "srl	 %[cc],28\n"
-		     : [cc] "=d" (cc)
-		     : [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1),
-		       [r2] "i" (r2)
-		     : "memory", "cc", "r3");
+	asm volatile(
+		".insn   rre,0xB2560000,%[r1],%[r2]\n"
+		"ipm     %[cc]\n"
+		"srl     %[cc],28\n"
+		: [cc] "=d" (cc), "+d" (rc3)
+		: [code] "d" (code), [addr] "a" (addr), [r1] "i" (r1), [r2] "i" (r2)
+		: "memory", "cc");
 	if (rc)
 		*rc = rc3;
 	return cc;
@@ -139,16 +139,18 @@ static void test_fcode0(void)
 	struct sthyi_hdr_sctn *hdr;
 	struct sthyi_mach_sctn *mach;
 	struct sthyi_par_sctn *par;
+	uint64_t rc = 42;
 
 	/* Zero destination memory. */
 	memset(pagebuf, 0, PAGE_SIZE);
 
 	report_prefix_push("fcode 0");
-	sthyi((uint64_t)pagebuf, 0, NULL, 0, 2);
+	sthyi((uint64_t)pagebuf, 0, &rc, 0, 2);
 	hdr = (void *)pagebuf;
 	mach = (void *)pagebuf + hdr->INFMOFF;
 	par = (void *)pagebuf + hdr->INFPOFF;
 
+	report(!rc, "r2 + 1 == 0");
 	test_fcode0_hdr(hdr);
 	test_fcode0_mach(mach);
 	test_fcode0_par(par);
-- 
2.30.2

