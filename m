Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2223765B5D
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 20:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjG0SaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 14:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjG0SaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 14:30:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2C126B2;
        Thu, 27 Jul 2023 11:29:45 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36RI9osL020059;
        Thu, 27 Jul 2023 18:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=WlS2iZWmzd8oSKM2O+2+O6cxGQXL/tmFy/CKby501EE=;
 b=PrrVxF/5FT921lGh4Sbx0ilDbDu91I5Qan3e4iA7FuQ0Sd9VYoLcn+ActDclvjHsgXF4
 4srQWk7C1wnvBzTRvdSY2mCVHPGYvDvAYX9bJNMm/TMKd249Z1+q7WTo87yyfa6gPkPi
 aFuul3PQMxNR8MvFp2szZzKarH6ISppjo8O/J3fpmxpSmIGb+2vbBN4z2nvnXQubrCx8
 ABDJGFvbYMx8Zm3jSPvPwe1qtmcFqowq6BIx/Kn9msLP+CbHrlV5ZRMZJngfug3hRg0W
 J+ZxvokiO5241dK5wdp3zs7ZYVQa2aXcc6QbhPHvve92UP09z7BZIJUnZQaItYEf1HKb IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3wc7rtc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 18:29:44 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36RIA7kt021535;
        Thu, 27 Jul 2023 18:29:44 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3wc7rtbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 18:29:44 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36RIFZrG002639;
        Thu, 27 Jul 2023 18:29:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0txkfnuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 18:29:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36RITeXE60228078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 18:29:40 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ADB420067;
        Thu, 27 Jul 2023 18:29:40 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC8BC2004F;
        Thu, 27 Jul 2023 18:29:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 18:29:39 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Mete Durlu <meted@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: fix sthyi error handling
Date:   Thu, 27 Jul 2023 20:29:39 +0200
Message-Id: <20230727182939.2050744-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6VnCgyBAHgxSMY77m58Fb8YBJd-VmbDY
X-Proofpoint-ORIG-GUID: uuv0Rm_KP1ertc9XKbpJiXrB1r1fuJ71
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0
 clxscore=1015 mlxlogscore=793 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307270163
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
added cache handling for store hypervisor info. This also changed the
possible return code for sthyi_fill().

Instead of only returning a condition code like the sthyi instruction would
do, it can now also return a negative error value (-ENOMEM). handle_styhi()
was not changed accordingly. In case of an error, the negative error value
would incorrectly injected into the guest PSW.

Add proper error handling to prevent this, and update the comment which
describes the possible return values of sthyi_fill().

Fixes: 9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kernel/sthyi.c  | 6 +++---
 arch/s390/kvm/intercept.c | 9 ++++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/sthyi.c b/arch/s390/kernel/sthyi.c
index 4d141e2c132e..2ea7f208f0e7 100644
--- a/arch/s390/kernel/sthyi.c
+++ b/arch/s390/kernel/sthyi.c
@@ -459,9 +459,9 @@ static int sthyi_update_cache(u64 *rc)
  *
  * Fills the destination with system information returned by the STHYI
  * instruction. The data is generated by emulation or execution of STHYI,
- * if available. The return value is the condition code that would be
- * returned, the rc parameter is the return code which is passed in
- * register R2 + 1.
+ * if available. The return value is either a negative error value or
+ * the condition code that would be returned, the rc parameter is the
+ * return code which is passed in register R2 + 1.
  */
 int sthyi_fill(void *dst, u64 *rc)
 {
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 954d39adf85c..341abafb96e4 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -389,8 +389,8 @@ static int handle_partial_execution(struct kvm_vcpu *vcpu)
  */
 int handle_sthyi(struct kvm_vcpu *vcpu)
 {
-	int reg1, reg2, r = 0;
-	u64 code, addr, cc = 0, rc = 0;
+	int reg1, reg2, cc = 0, r = 0;
+	u64 code, addr, rc = 0;
 	struct sthyi_sctns *sctns = NULL;
 
 	if (!test_kvm_facility(vcpu->kvm, 74))
@@ -421,7 +421,10 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	cc = sthyi_fill(sctns, &rc);
-
+	if (cc < 0) {
+		free_page((unsigned long)sctns);
+		return cc;
+	}
 out:
 	if (!cc) {
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
-- 
2.39.2

