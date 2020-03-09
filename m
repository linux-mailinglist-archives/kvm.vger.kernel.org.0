Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A5317E30B
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCIPEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:04:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726617AbgCIPEX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 11:04:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029ExI98019588;
        Mon, 9 Mar 2020 11:04:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ym648psxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:04:20 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 029F1awp056635;
        Mon, 9 Mar 2020 11:02:36 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ym648pn6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:02:36 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 029F0Qsc019769;
        Mon, 9 Mar 2020 15:00:35 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 2ym386fw1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 15:00:35 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 029F0Yvm49807852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 15:00:34 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1CA72806E;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A38A028067;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH 1/4] selftests: KVM: s390: fix early guest crash
Date:   Mon,  9 Mar 2020 11:00:23 -0400
Message-Id: <20200309150026.4329-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200309150026.4329-1-borntraeger@de.ibm.com>
References: <20200309150026.4329-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest crashes very early due to changes in the control registers
used by dynamic address translation. Let us use different registers
that will not crash the guest.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 27 +++++++++++-----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 1485bc6c8999..cbb343ad5d42 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -23,25 +23,24 @@ struct kvm_run *run;
 struct kvm_sync_regs *regs;
 static uint64_t regs_null[16];
 
-static uint64_t crs[16] = { 0x40000ULL,
-			    0x42000ULL,
-			    0, 0, 0, 0, 0,
-			    0x43000ULL,
-			    0, 0, 0, 0, 0,
-			    0x44000ULL,
-			    0, 0
-};
-
 static void guest_code_initial(void)
 {
-	/* Round toward 0 */
-	uint32_t fpc = 0x11;
+	/* set several CRs to "safe" value */
+	unsigned long cr2_59 = 0x10;	/* enable guarded storage */
+	unsigned long cr8_63 = 0x1;	/* monitor mask = 1 */
+	unsigned long cr10 = 1;		/* PER START */
+	unsigned long cr11 = -1;	/* PER END */
+
 
 	/* Dirty registers */
 	asm volatile (
-		"	lctlg	0,15,%0\n"
-		"	sfpc	%1\n"
-		: : "Q" (crs), "d" (fpc));
+		"	lghi	2,0x11\n"	/* Round toward 0 */
+		"	sfpc	2\n"		/* set fpc to !=0 */
+		"	lctlg	2,2,%0\n"
+		"	lctlg	8,8,%1\n"
+		"	lctlg	10,10,%2\n"
+		"	lctlg	11,11,%3\n"
+		: : "m" (cr2_59), "m" (cr8_63), "m" (cr10), "m" (cr11) : "2");
 	GUEST_SYNC(0);
 }
 
-- 
2.25.0

