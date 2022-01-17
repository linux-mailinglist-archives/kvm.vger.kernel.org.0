Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148A8490D0F
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbiAQRAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241464AbiAQQ76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:59:58 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGX2oK015010
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=P/H0MyIfIVUpdvmbF1HicsT4XWPNWrQ+7U3v/fJi0iI=;
 b=VBf0pylh5nXld7tm/C3q0Bq9KDGbF8MrjXiupgVzYO5w4rgZpvbAzQO1G5jdPCgCnOTy
 +6zTNjgJt4q+XlXUxUAl2Xl4KcMQmnDFkYSFGyZgfPAu88brtTheT6FIrwjILAIPsz8G
 I2tPKerdiJBUqBtdAElQQn8v8Tbhycu1940DRYflxaKrPCrInGO8GW+JwW7CdX6xruiT
 KJ93dazbSkeV3zmy983AqpOpaS+WZU5WNVVwmmuf/BTvGEPnaAHlaAEwypWh925WYCme
 3rwSlpK4aRvnnSH7HurPeq1fXirfw39XX/oEssQEXGmXs1794cj3pB8P039aHSJldKr3 vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnbjghjr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:58 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HFx5HJ017600
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnbjghjqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGkvWX019640;
        Mon, 17 Jan 2022 16:59:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw956y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxp4H26477010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD4BCA405B;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71A4AA405C;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 03/13] s390x: sie: Add PV fields to SIE control block
Date:   Mon, 17 Jan 2022 17:59:39 +0100
Message-Id: <20220117165949.75964-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1tOYNtEqBBDmoxacGGxDQyHVKxp4S1ms
X-Proofpoint-ORIG-GUID: 3ZZ08TL4EcCqswNJWOFGD2AzYAJjAs6L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

We need those fields for format 4 SIE tests (protected VMs).

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.h | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index f34e3c80..c6eb6441 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -38,7 +38,13 @@ struct kvm_s390_sie_block {
 	uint8_t		reserved08[4];		/* 0x0008 */
 #define PROG_IN_SIE (1<<0)
 	uint32_t	prog0c;			/* 0x000c */
-	uint8_t		reserved10[16];		/* 0x0010 */
+union {
+		uint8_t	reserved10[16];		/* 0x0010 */
+		struct {
+			uint64_t	pv_handle_cpu;
+			uint64_t	pv_handle_config;
+		};
+	};
 #define PROG_BLOCK_SIE	(1<<0)
 #define PROG_REQUEST	(1<<1)
 	uint32_t 	prog20;		/* 0x0020 */
@@ -87,10 +93,22 @@ struct kvm_s390_sie_block {
 #define ICPT_PARTEXEC	0x38
 #define ICPT_IOINST	0x40
 #define ICPT_KSS	0x5c
+#define ICPT_INT_ENABLE	0x64
+#define ICPT_PV_INSTR	0x68
+#define ICPT_PV_NOTIFY	0x6c
+#define ICPT_PV_PREF	0x70
 	uint8_t		icptcode;		/* 0x0050 */
 	uint8_t		icptstatus;		/* 0x0051 */
 	uint16_t	ihcpu;			/* 0x0052 */
-	uint8_t		reserved54[2];		/* 0x0054 */
+	uint8_t		reserved54;		/* 0x0054 */
+#define IICTL_CODE_NONE		 0x00
+#define IICTL_CODE_MCHK		 0x01
+#define IICTL_CODE_EXT		 0x02
+#define IICTL_CODE_IO		 0x03
+#define IICTL_CODE_RESTART	 0x04
+#define IICTL_CODE_SPECIFICATION 0x10
+#define IICTL_CODE_OPERAND	 0x11
+	uint8_t		iictl;			/* 0x0055 */
 	uint16_t	ipa;			/* 0x0056 */
 	uint32_t	ipb;			/* 0x0058 */
 	uint32_t	scaoh;			/* 0x005c */
@@ -112,7 +130,7 @@ struct kvm_s390_sie_block {
 #define ECB3_RI  0x01
 	uint8_t    	ecb3;			/* 0x0063 */
 	uint32_t	scaol;			/* 0x0064 */
-	uint8_t		reserved68;		/* 0x0068 */
+	uint8_t		sdf;			/* 0x0068 */
 	uint8_t    	epdx;			/* 0x0069 */
 	uint8_t    	reserved6a[2];		/* 0x006a */
 	uint32_t	todpr;			/* 0x006c */
@@ -128,9 +146,15 @@ struct kvm_s390_sie_block {
 #define HPID_KVM	0x4
 #define HPID_VSIE	0x5
 	uint8_t		hpid;			/* 0x00b8 */
-	uint8_t		reservedb9[11];		/* 0x00b9 */
-	uint16_t	extcpuaddr;		/* 0x00c4 */
-	uint16_t	eic;			/* 0x00c6 */
+	uint8_t		reservedb9[7];		/* 0x00b9 */
+	union {
+		struct {
+			uint32_t	eiparams;	/* 0x00c0 */
+			uint16_t	extcpuaddr;	/* 0x00c4 */
+			uint16_t	eic;		/* 0x00c6 */
+		};
+		uint64_t	mcic;			/* 0x00c0 */
+	} __attribute__ ((__packed__));
 	uint32_t	reservedc8;		/* 0x00c8 */
 	uint16_t	pgmilc;			/* 0x00cc */
 	uint16_t	iprcc;			/* 0x00ce */
@@ -152,7 +176,10 @@ struct kvm_s390_sie_block {
 #define CRYCB_FORMAT2 0x00000003
 	uint32_t	crycbd;			/* 0x00fc */
 	uint64_t	gcr[16];		/* 0x0100 */
-	uint64_t	gbea;			/* 0x0180 */
+	union {
+		uint64_t	gbea;			/* 0x0180 */
+		uint64_t	sidad;
+	};
 	uint8_t		reserved188[8];		/* 0x0188 */
 	uint64_t   	sdnxo;			/* 0x0190 */
 	uint8_t    	reserved198[8];		/* 0x0198 */
-- 
2.31.1

