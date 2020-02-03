Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100921506DC
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgBCNUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41170 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbgBCNUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:09 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DICrb080982
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm9cr1rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:08 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DIOUw085017
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm9cr1qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:08 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DHi2p006668;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2xw0y6n926-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK4B652691336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:04 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71FCF28071;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E67B2806D;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 14/37] KVM: s390: protvirt: Add interruption injection controls
Date:   Mon,  3 Feb 2020 08:19:34 -0500
Message-Id: <20200203131957.383915-15-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=869 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

Define the interruption injection codes and the related fields in the
sie control block for PVM interruption injection.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 58845b315be0..a45d10d87a8a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -222,7 +222,15 @@ struct kvm_s390_sie_block {
 	__u8	icptcode;		/* 0x0050 */
 	__u8	icptstatus;		/* 0x0051 */
 	__u16	ihcpu;			/* 0x0052 */
-	__u8	reserved54[2];		/* 0x0054 */
+	__u8	reserved54;		/* 0x0054 */
+#define IICTL_CODE_NONE		 0x00
+#define IICTL_CODE_MCHK		 0x01
+#define IICTL_CODE_EXT		 0x02
+#define IICTL_CODE_IO		 0x03
+#define IICTL_CODE_RESTART	 0x04
+#define IICTL_CODE_SPECIFICATION 0x10
+#define IICTL_CODE_OPERAND	 0x11
+	__u8	iictl;			/* 0x0055 */
 	__u16	ipa;			/* 0x0056 */
 	__u32	ipb;			/* 0x0058 */
 	__u32	scaoh;			/* 0x005c */
@@ -259,7 +267,8 @@ struct kvm_s390_sie_block {
 #define HPID_KVM	0x4
 #define HPID_VSIE	0x5
 	__u8	hpid;			/* 0x00b8 */
-	__u8	reservedb9[11];		/* 0x00b9 */
+	__u8	reservedb9[7];		/* 0x00b9 */
+	__u32	eiparams;		/* 0x00c0 */
 	__u16	extcpuaddr;		/* 0x00c4 */
 	__u16	eic;			/* 0x00c6 */
 	__u32	reservedc8;		/* 0x00c8 */
@@ -275,8 +284,16 @@ struct kvm_s390_sie_block {
 	__u8	oai;			/* 0x00e2 */
 	__u8	armid;			/* 0x00e3 */
 	__u8	reservede4[4];		/* 0x00e4 */
-	__u64	tecmc;			/* 0x00e8 */
-	__u8	reservedf0[12];		/* 0x00f0 */
+	union {
+		__u64	tecmc;		/* 0x00e8 */
+		struct {
+			__u16	subchannel_id;	/* 0x00e8 */
+			__u16	subchannel_nr;	/* 0x00ea */
+			__u32	io_int_parm;	/* 0x00ec */
+			__u32	io_int_word;	/* 0x00f0 */
+		};
+	} __packed;
+	__u8	reservedf4[8];		/* 0x00f4 */
 #define CRYCB_FORMAT_MASK 0x00000003
 #define CRYCB_FORMAT0 0x00000000
 #define CRYCB_FORMAT1 0x00000001
-- 
2.24.0

