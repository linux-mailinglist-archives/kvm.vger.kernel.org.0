Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAA545A078
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhKWKnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234042AbhKWKnV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:21 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAH7RN024427;
        Tue, 23 Nov 2021 10:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lDjRCLRRnq9/ED4cahjbi1c3AtEFMb/fCQuwTX1wQ2o=;
 b=eRvSv8MRba4sqTglj6WRByIlYsiUwS2FhXWPlH2brR5dtfADEOOBrXOg7Tq7OE4a1eXr
 OLcGzyBB70Cc1vXCPE97S5VCISunAA3CdmO2tCuRa3c11Opc5bcvT5VfrVX/grHk0vko
 qbzylNsx9ETY541zkNAW3cnImEkpyYKj4sqqPB5LxFVzFLoRswaeou9/h0qKgv3t3kx9
 bXdIkrHYHtD0THlDqsprSti9Gibs0vlLSj4QMaYA0cKDq1ltjEStYLZdnrYOkML5O2Xu
 sZhyF1fzH/7uaDpHhgmUeEX6Mnl+QfI9eWwnhAqf2Dtsb5wZjTHfnAuRA0v0QxkqBh84 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxdqrc51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:13 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANAZf0n022396;
        Tue, 23 Nov 2021 10:40:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgxdqrc3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:12 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAb1lL009768;
        Tue, 23 Nov 2021 10:40:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3cerna5kjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAe6W633161618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:40:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3206A406D;
        Tue, 23 Nov 2021 10:40:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE922A404D;
        Tue, 23 Nov 2021 10:40:05 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/8] s390x: sie: Add PV fields to SIE control block
Date:   Tue, 23 Nov 2021 10:39:50 +0000
Message-Id: <20211123103956.2170-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tD6AvXB7DZyr75gWZ00WufQkJq6ODdI1
X-Proofpoint-ORIG-GUID: tEr5R9DVrTK9kqAEOeezcRaFaeTo3Njz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need those fields for format 4 SIE tests (protected VMs).

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.32.0

