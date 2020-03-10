Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD217FC96
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 14:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgCJNBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 09:01:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730311AbgCJNBt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 09:01:49 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AD0P9k147201;
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8cajr0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02AD0Uxr000802;
        Tue, 10 Mar 2020 09:01:47 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8cajqyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02AD1Xkn029878;
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2ym386sdyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 13:01:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AD1jki14746148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 13:01:45 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC95A2806D;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B79902806A;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/5] selftests: KVM: s390: fix early guest crash
Date:   Tue, 10 Mar 2020 09:01:40 -0400
Message-Id: <20200310130144.9921-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200310130144.9921-1-borntraeger@de.ibm.com>
References: <20200310130144.9921-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100087
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

