Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192CC2FD180
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbhATMvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:51:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388488AbhATLoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:44:24 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KBVg61173909;
        Wed, 20 Jan 2021 06:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YsztOlHfLiOvcDQxGPeoPu4supOISAUJzc/Mkybzi4A=;
 b=HRlFvPAi5AaA0ondap/eyk6hqC6Fv1l+1UYqJNE0Ez/4ApWsTatntC2YBsZyn0XLYfPH
 9UsQXc5a9tcq4M51sOtQ3Swh/GSo0Jt7FfTJ7psfLRy4sP3hOa4nVCT4Lsomth2FOPuG
 Q7zVi7cpcuFaZV9gTSg72qAKu+Ejq+X0gA79F0V33eT7DJVmjPvP7TkFmZhbeornn8d9
 +8AA9ziSKiu+NJ2coe+EXBOBQymmKKNiVx0egvQK/gtfH2vHX6oWNdDQfNxiObiRn66i
 Jh7+3iFRdMSuZNv5/YHy3jLxXcRmekFAj0TVqDZqhDFAAXOBIATn4H5cmvAxVm2QSjfv xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366jtphnm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:44 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KBVwqV174717;
        Wed, 20 Jan 2021 06:43:43 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366jtphnke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:43 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KBfMSo001718;
        Wed, 20 Jan 2021 11:43:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3668p90912-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:43:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KBhdiF32899532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 11:43:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2280AE055;
        Wed, 20 Jan 2021 11:43:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17E4EAE051;
        Wed, 20 Jan 2021 11:43:38 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 11:43:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 11/11] s390x: Fix uv_call() exception behavior
Date:   Wed, 20 Jan 2021 06:41:58 -0500
Message-Id: <20210120114158.104559-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120114158.104559-1-frankja@linux.ibm.com>
References: <20210120114158.104559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a program exception we usually skip the instruction that caused the
exception and continue. That won't work for UV calls since a "brc
3,0b" will retry the instruction if the CC is > 1. Let's forgo the brc
when checking for privilege exceptions and use a uv_call_once().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/asm/uv.h | 24 ++++++++++++++++--------
 s390x/uv-guest.c   |  6 +++---
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 4c2fc48..39d2dc0 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -50,19 +50,12 @@ struct uv_cb_share {
 	u64 reserved28;
 } __attribute__((packed))  __attribute__((aligned(8)));
 
-static inline int uv_call(unsigned long r1, unsigned long r2)
+static inline int uv_call_once(unsigned long r1, unsigned long r2)
 {
 	int cc;
 
-	/*
-	 * The brc instruction will take care of the cc 2/3 case where
-	 * we need to continue the execution because we were
-	 * interrupted. The inline assembly will only return on
-	 * success/error i.e. cc 0/1.
-	*/
 	asm volatile(
 		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
-		"		brc	3,0b\n"
 		"		ipm	%[cc]\n"
 		"		srl	%[cc],28\n"
 		: [cc] "=d" (cc)
@@ -71,4 +64,19 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
+static inline int uv_call(unsigned long r1, unsigned long r2)
+{
+	int cc;
+
+	/*
+	 * CC 2 and 3 tell us to re-execute because the instruction
+	 * hasn't yet finished.
+	 */
+	do {
+		cc = uv_call_once(r1, r2);
+	} while (cc > 1);
+
+	return cc;
+}
+
 #endif
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index e51b85e..9954444 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -29,7 +29,7 @@ static void test_priv(void)
 	uvcb.len = sizeof(struct uv_cb_qui);
 	expect_pgm_int();
 	enter_pstate();
-	uv_call(0, (u64)&uvcb);
+	uv_call_once(0, (u64)&uvcb);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 
@@ -38,7 +38,7 @@ static void test_priv(void)
 	uvcb.len = sizeof(struct uv_cb_share);
 	expect_pgm_int();
 	enter_pstate();
-	uv_call(0, (u64)&uvcb);
+	uv_call_once(0, (u64)&uvcb);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 
@@ -47,7 +47,7 @@ static void test_priv(void)
 	uvcb.len = sizeof(struct uv_cb_share);
 	expect_pgm_int();
 	enter_pstate();
-	uv_call(0, (u64)&uvcb);
+	uv_call_once(0, (u64)&uvcb);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 
-- 
2.25.1

