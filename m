Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261C6424F88
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbhJGIyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 04:54:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240614AbhJGIyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 04:54:08 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1976ubHm017929;
        Thu, 7 Oct 2021 04:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZACorKK8MIXh5CREQAwQlyoV64Ohx8HweHvXAvo5SEI=;
 b=SFYuuK1VFoiY+YHS0chJ1PyZXKAYccMSuao6TLp2qWltxD66xBrLG6t8Q/fP850wRwaq
 XV3bPbWIexc59XPsNWTmTQVnmMX31ZT+I26SBCvXj9jeG2C3aSaUJW00ZN3elQ0gOtt4
 zzEX5rABrTeb/3/+US6IW6Dq7gBaq37jiGa47PPNWt2asJ3UM2dxT0Uks84Me9rdq1rS
 i/73v9QNcJSZh0B0Z577jRr9iyN89dhFT6pYD2wNepZ/wIREDCqY9FPFHMucW5jLgAl0
 Oq5Cf81BxNotlRc0DEvSVDkBmWVKwJ3rXsTzaJXizwiM3DrRlXEZthJJDsksmXoMq14e zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd790b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:14 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1977SKj4024707;
        Thu, 7 Oct 2021 04:52:13 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsd78yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 04:52:13 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1978ptJx014908;
        Thu, 7 Oct 2021 08:52:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3bef2aap0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 08:52:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1978keXm36700554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 08:46:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 106E9AE070;
        Thu,  7 Oct 2021 08:52:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77416AE077;
        Thu,  7 Oct 2021 08:52:01 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Oct 2021 08:52:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 7/9] s390x: Add sthyi cc==0 r2+1 verification
Date:   Thu,  7 Oct 2021 08:50:25 +0000
Message-Id: <20211007085027.13050-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007085027.13050-1-frankja@linux.ibm.com>
References: <20211007085027.13050-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YMVvroKvHdRNUb7T_cI4hdNth_x579pH
X-Proofpoint-GUID: t5dH7Meo2UPYK5_vZnVU562WdIx8ILPm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On success r2 + 1 should be 0, let's also check for that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

