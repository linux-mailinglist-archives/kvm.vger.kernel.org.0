Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF1388969
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbhESI3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:29:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245141AbhESI3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:29:07 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J8QVKm190783;
        Wed, 19 May 2021 04:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eQKOggv4DWgwYGAY7j/1cjfUTAj0c0ZbEQzNKxxYJ+k=;
 b=NTs6bOh1v2rPa5EaihVpUzUI26Y9YKq2sUWUENQjcTXpBQzqOjhD/F/jqKsp537Y0fhB
 BdICF6ceBCyk9ffQEdZJyulgaT8etcjQLycaWJ1RFF71TMAdNYPnej3t/yTycxkUKQaM
 f0xp837SYeCY6TtAHrXU6KvgA/oUk1OKMrry2mSZHlMJ/nPDyoy/iCGDqM9OCBKVLt89
 LFN/4UOgn8/NCK3L5EJA6jDO27MP76uopso8VbaTD/eLUEDvamLrQ5V9Ur407/YnbBHN
 WsXgWD9m3ggtafFjBt4nxV8QUMI0b2lL35PaRROd/6jN6Ebvj8YTSrQbvfEPExXvPhB7 HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38my5vg12w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:47 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14J8QaeO191006;
        Wed, 19 May 2021 04:27:47 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38my5vg124-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 04:27:47 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J8RLod025853;
        Wed, 19 May 2021 08:27:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 38j5jgsy9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 08:27:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J8REsg17629690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 08:27:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E928442047;
        Wed, 19 May 2021 08:27:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3274A42041;
        Wed, 19 May 2021 08:27:41 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 08:27:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/3] lib: s390x: sclp: Extend feature probing
Date:   Wed, 19 May 2021 08:26:47 +0000
Message-Id: <20210519082648.46803-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210519082648.46803-1-frankja@linux.ibm.com>
References: <20210519082648.46803-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WRoERFRrdLbtYGlsp8pPkFx9Atzc42pS
X-Proofpoint-ORIG-GUID: X0hz5FdpO_A1pboIFqxN7byKpgJMAtdK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190059
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
index f11c2035..291924b0 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -129,6 +129,13 @@ CPUEntry *sclp_get_cpu_entries(void)
 	return (CPUEntry *)(_read_info + read_info->offset_cpu);
 }
 
+static bool sclp_feat_check(int byte, int bit)
+{
+	uint8_t *rib = (uint8_t *)read_info;
+
+	return !!(rib[byte] & (0x80 >> bit));
+}
+
 void sclp_facilities_setup(void)
 {
 	unsigned short cpu0_addr = stap();
@@ -140,6 +147,14 @@ void sclp_facilities_setup(void)
 	cpu = sclp_get_cpu_entries();
 	if (read_info->offset_cpu > 134)
 		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_BIT_GSLS);
+	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_BIT_KSS);
+	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
+	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);
+	sclp_facilities.has_esca = sclp_feat_check(116, SCLP_FEAT_116_BIT_ESCA);
+	sclp_facilities.has_ibs = sclp_feat_check(117, SCLP_FEAT_117_BIT_IBS);
+	sclp_facilities.has_pfmfi = sclp_feat_check(117, SCLP_FEAT_117_BIT_PFMFI);
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
index 85231333..115bd2fa 100644
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
 
+#define SCLP_FEAT_85_BIT_GSLS		7
+#define SCLP_FEAT_98_BIT_KSS		0
+#define SCLP_FEAT_116_BIT_64BSCAO	7
+#define SCLP_FEAT_116_BIT_CMMA		6
+#define SCLP_FEAT_116_BIT_ESCA		3
+#define SCLP_FEAT_117_BIT_PFMFI		6
+#define SCLP_FEAT_117_BIT_IBS		5
+
 typedef struct ReadInfo {
 	SCCBHeader h;
 	uint16_t rnmax;
-- 
2.30.2

