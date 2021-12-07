Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42846C033
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhLGQFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238770AbhLGQFh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:37 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7DrpUL016278;
        Tue, 7 Dec 2021 16:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sJJr9MPZ11zeCkhErEWt1AG3Co3buTdxJoLX9eKNdy4=;
 b=SE5AQttmHzoAU2fb2dwAeL76s7PLh0KPmZgZwsHI/ZVEH96Mr2UM6UUrwqE3o63oN+TX
 5thVOV+sSER6HwuFh+MrTS5dgMFfu6yor2L1U40s/RinoqeRn5ksalzVCq1TwB7CIdcD
 RbmX78ctsNzxVxXB8FNeHt6cxmVQ8Q+UDqAxuJm+BukDKyS7mEWvf3KTQ0EwlLEA5pi4
 62kK6YBS8I9API6M9J8hU1iKhKd2o39JN2ftS8BLA+r6hIw397qU8nG3IH7QR4n5kmSo
 GyKKNngTTVjSvR8shGar/hM8veodo3eIyQevqvzbC7wphTsAtl9M2JfYDKSxNU+UdWCq Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct8w6u0g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Dw50W029793;
        Tue, 7 Dec 2021 16:02:06 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ct8w6u0f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FrCTn005590;
        Tue, 7 Dec 2021 16:02:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyar2q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G20XK29229366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:02:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 060464C040;
        Tue,  7 Dec 2021 16:02:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF47F4C050;
        Tue,  7 Dec 2021 16:01:58 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:01:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 02/10] s390x: sie: Add PV fields to SIE control block
Date:   Tue,  7 Dec 2021 15:59:57 +0000
Message-Id: <20211207160005.1586-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207160005.1586-1-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yJbPnqOsGkoPnONHX2AeYtMyqPqlnhER
X-Proofpoint-ORIG-GUID: pKdLQtfDjoYUFfFHnqgtVZ7ZmOKAZ6q2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need those fields for format 4 SIE tests (protected VMs).

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

