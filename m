Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220963791F2
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241050AbhEJPGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:06:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231680AbhEJPDJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:03:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AEXpFo030860;
        Mon, 10 May 2021 11:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RhAkAzTfiP5TBRtnalaZ84J0Q13aIlnimPS5PsYww0Y=;
 b=QQEUljb9sS2Zjm3P3LZX3+TRkiuTDvXweI5nZZjwBLfXh5ZKmME8UZH4/pF0rBvai9Sl
 LdJ5ehS/P2fwaGv/3gfh7YiHtXpZ51sZQ2HnPTuCVuEwGHesuuIFZvnPb6abZsEhVG3/
 IIyuayMApC0ch3sfqqheQ8b0zIwsTIQOoPvDxwpsxIASBkcxkZXCA48onpnwj/IXF0m0
 KF5qD144ohxQgdv+bE7g785OdUdDaOWTTdlc7PK9my5WzV/i9wvEs8ffOq6veFLHq5Mz
 uxZlF+68XpYjiIyiYYALyOHCEejDcOfH+ucDePtlINbMZn/9Pg9nZPdaoAMR3NlMiCYT mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f5ytjpxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:03 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AEXoJ2030788;
        Mon, 10 May 2021 11:02:03 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f5ytjpw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:03 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AEsA3k031396;
        Mon, 10 May 2021 15:02:00 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 38dhwh9216-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 15:02:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AF1Vft25559352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 15:01:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F9CDAE053;
        Mon, 10 May 2021 15:01:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCA9DAE045;
        Mon, 10 May 2021 15:01:56 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 15:01:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH 2/4] lib: s390x: sclp: Extend feature probing
Date:   Mon, 10 May 2021 15:00:13 +0000
Message-Id: <20210510150015.11119-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510150015.11119-1-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h190A5q9sqM25CZIPk-fPfbL0JBzLaxG
X-Proofpoint-GUID: p0rp2OJ-kR6jmLt5MiKGfU0rijPt72Qo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lets grab more of the feature bits from SCLP read info so we can use
them in the cpumodel tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp.c | 20 ++++++++++++++++++++
 lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index f11c2035..f25cfdb2 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (CPUEntry *)(_read_info + read_info->offset_cpu);
 }
 
+static bool sclp_feat_check(int byte, int mask)
+{
+	uint8_t *rib = (uint8_t *)read_info;
+
+	return !!(rib[byte] & mask);
+}
+
 void sclp_facilities_setup(void)
 {
 	unsigned short cpu0_addr = stap();
@@ -140,6 +147,14 @@ void sclp_facilities_setup(void)
 	cpu = sclp_get_cpu_entries();
 	if (read_info->offset_cpu > 134)
 		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_MASK_GSLS);
+	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_MASK_KSS);
+	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_MASK_CMMA);
+	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_MASK_64BSCAO);
+	sclp_facilities.has_esca = sclp_feat_check(116, SCLP_FEAT_116_MASK_ESCA);
+	sclp_facilities.has_ibs = sclp_feat_check(117, SCLP_FEAT_117_MASK_IBS);
+	sclp_facilities.has_pfmfi = sclp_feat_check(117, SCLP_FEAT_117_MASK_PFMFI);
+
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		/*
 		 * The logic for only reading the facilities from the
@@ -150,6 +165,11 @@ void sclp_facilities_setup(void)
 		 */
 		if (cpu->address == cpu0_addr) {
 			sclp_facilities.has_sief2 = cpu->feat_sief2;
+			sclp_facilities.has_skeyi = cpu->feat_skeyi;
+			sclp_facilities.has_siif = cpu->feat_siif;
+			sclp_facilities.has_sigpif = cpu->feat_sigpif;
+			sclp_facilities.has_ib = cpu->feat_ib;
+			sclp_facilities.has_cei = cpu->feat_cei;
 			break;
 		}
 	}
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 85231333..48df1260 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -94,9 +94,19 @@ typedef struct CPUEntry {
 	uint8_t reserved0;
 	uint8_t : 4;
 	uint8_t feat_sief2 : 1;
+	uint8_t feat_skeyi : 1;
+	uint8_t : 2;
+	uint8_t : 2;
+	uint8_t feat_gpere : 1;
+	uint8_t feat_siif : 1;
+	uint8_t feat_sigpif : 1;
 	uint8_t : 3;
-	uint8_t features_res2 [SCCB_CPU_FEATURE_LEN - 1];
-	uint8_t reserved2[6];
+	uint8_t reserved2[3];
+	uint8_t : 2;
+	uint8_t feat_ib : 1;
+	uint8_t feat_cei : 1;
+	uint8_t : 4;
+	uint8_t reserved3[6];
 	uint8_t type;
 	uint8_t reserved1;
 } __attribute__((packed)) CPUEntry;
@@ -105,10 +115,32 @@ extern struct sclp_facilities sclp_facilities;
 
 struct sclp_facilities {
 	uint64_t has_sief2 : 1;
+	uint64_t has_skeyi : 1;
+	uint64_t has_gpere : 1;
+	uint64_t has_siif : 1;
+	uint64_t has_sigpif : 1;
+	uint64_t has_ib : 1;
+	uint64_t has_cei : 1;
+
 	uint64_t has_diag318 : 1;
-	uint64_t : 62;
+	uint64_t has_gsls : 1;
+	uint64_t has_cmma : 1;
+	uint64_t has_64bscao : 1;
+	uint64_t has_esca : 1;
+	uint64_t has_kss : 1;
+	uint64_t has_pfmfi : 1;
+	uint64_t has_ibs : 1;
+	uint64_t : 64 - 15;
 };
 
+#define SCLP_FEAT_85_MASK_GSLS		(1 << 7)
+#define SCLP_FEAT_98_MASK_KSS		(1 << 0)
+#define SCLP_FEAT_116_MASK_64BSCAO	(1 << 7)
+#define SCLP_FEAT_116_MASK_CMMA		(1 << 6)
+#define SCLP_FEAT_116_MASK_ESCA		(1 << 3)
+#define SCLP_FEAT_117_MASK_PFMFI	(1 << 6)
+#define SCLP_FEAT_117_MASK_IBS		(1 << 5)
+
 typedef struct ReadInfo {
 	SCCBHeader h;
 	uint16_t rnmax;
-- 
2.30.2

