Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D497B1506EE
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgBCNUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728301AbgBCNUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:09 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DG3q5105475
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xx3cya4dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:08 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DGQZa108581
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:07 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xx3cya4cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:07 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DFUfw014176;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 2xw0y690q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK4eH52494648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:04 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B28B62806F;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE0202805C;
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
Subject: [RFCv2 17/37] KVM: s390: protvirt: Add machine-check interruption injection controls
Date:   Mon,  3 Feb 2020 08:19:37 -0500
Message-Id: <20200203131957.383915-18-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

The following fields are added to the sie control block type 4:
     - Machine Check Interruption Code (mcic)
     - External Damage Code (edc)
     - Failing Storage Address (faddr)

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 33 +++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 5e85358d9090..f5ca53574406 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -268,16 +268,31 @@ struct kvm_s390_sie_block {
 #define HPID_VSIE	0x5
 	__u8	hpid;			/* 0x00b8 */
 	__u8	reservedb9[7];		/* 0x00b9 */
-	__u32	eiparams;		/* 0x00c0 */
-	__u16	extcpuaddr;		/* 0x00c4 */
-	__u16	eic;			/* 0x00c6 */
+	union {
+		struct {
+			__u32	eiparams;	/* 0x00c0 */
+			__u16	extcpuaddr;	/* 0x00c4 */
+			__u16	eic;		/* 0x00c6 */
+		};
+		__u64	mcic;			/* 0x00c0 */
+	} __packed;
 	__u32	reservedc8;		/* 0x00c8 */
-	__u16	pgmilc;			/* 0x00cc */
-	__u16	iprcc;			/* 0x00ce */
-	__u32	dxc;			/* 0x00d0 */
-	__u16	mcn;			/* 0x00d4 */
-	__u8	perc;			/* 0x00d6 */
-	__u8	peratmid;		/* 0x00d7 */
+	union {
+		struct {
+			__u16	pgmilc;		/* 0x00cc */
+			__u16	iprcc;		/* 0x00ce */
+		};
+		__u32	edc;			/* 0x00cc */
+	} __packed;
+	union {
+		struct {
+			__u32	dxc;		/* 0x00d0 */
+			__u16	mcn;		/* 0x00d4 */
+			__u8	perc;		/* 0x00d6 */
+			__u8	peratmid;	/* 0x00d7 */
+		};
+		__u64	faddr;			/* 0x00d0 */
+	} __packed;
 	__u64	peraddr;		/* 0x00d8 */
 	__u8	eai;			/* 0x00e0 */
 	__u8	peraid;			/* 0x00e1 */
-- 
2.24.0

