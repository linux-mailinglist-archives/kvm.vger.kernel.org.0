Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B937CD2224
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 09:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfJJHxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 03:53:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727130AbfJJHxo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Oct 2019 03:53:44 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9A7rbJq004672
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 03:53:42 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vhx4dcedq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 03:53:39 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 10 Oct 2019 08:52:42 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 10 Oct 2019 08:52:38 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9A7qbbR41615564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 07:52:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AC9DAE053;
        Thu, 10 Oct 2019 07:52:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3656AAE04D;
        Thu, 10 Oct 2019 07:52:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Oct 2019 07:52:37 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D8F05E0174; Thu, 10 Oct 2019 09:52:36 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH] selftests: kvm: make syncregs more reliable on s390
Date:   Thu, 10 Oct 2019 09:52:36 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101007-0016-0000-0000-000002B6C504
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101007-0017-0000-0000-00003317CF89
Message-Id: <20191010075236.100247-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910100074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

similar to commit 2c57da356800 ("selftests: kvm: fix sync_regs_test with
newer gccs") and commit 204c91eff798a ("KVM: selftests: do not blindly
clobber registers in guest asm") we better do not rely on gcc leaving
r11 untouched.  We can write the simple ucall inline and have the guest
code completely as small assembler function.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../testing/selftests/kvm/s390x/sync_regs_test.c  | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index d5290b4ad636..04d6abe68961 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -25,12 +25,15 @@
 
 static void guest_code(void)
 {
-	register u64 stage asm("11") = 0;
-
-	for (;;) {
-		GUEST_SYNC(0);
-		asm volatile ("ahi %0,1" : : "r"(stage));
-	}
+	/*
+	 * we embed diag 501 here instead of a ucall as the called function
+	 * could mess with the content of r11 when doing the hypercall
+	 */
+	asm volatile (
+		"0:	diag 0,0,0x501\n"
+		"	ahi 11,1\n"
+		"	j 0b\n"
+	);
 }
 
 #define REG_COMPARE(reg) \
-- 
2.21.0

