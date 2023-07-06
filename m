Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C94749FFA
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbjGFOy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 10:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbjGFOy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 10:54:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3331730;
        Thu,  6 Jul 2023 07:54:29 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 366ElTTe016755;
        Thu, 6 Jul 2023 14:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=G9WTq9pgi478SHWTcbW7p9G+EaQLNwDgdLwUsfwFH80=;
 b=a52Kumxvk0Qp/MHulkgPcXdIUSCpxvaE0JxOuHi5wtSuhRjACammiMDHXkwnxhH/Fslf
 YIrGqI9gqEOT5Xa6rrZqg2nmwqJwmiNRNJGLt10tEd2l4Pv+EJiIXBuk7cH2UafTShT3
 vD3NK6kEQBPYPOeIfn2/SsFcxVQcijak5a8m9x+giGb/cpl4OWqcsebOh3jipH8A2xjR
 e88NmrN/iG/4GEyxYQSnHbquYb+g8yIaEZxnB9pgK9SVTjODWiKDbOpPr8NH6ap5IuzI
 XVK75K6S3OC0FVqhhxGFVSfRDRymde1pYqu4makPKcgkiz8bTikV9HXugp1L5Co37H83 1w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rnypfg4uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jul 2023 14:54:14 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 366APqIF031685;
        Thu, 6 Jul 2023 14:54:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3rjbs4tg9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Jul 2023 14:54:12 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 366Es7BT57803030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jul 2023 14:54:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA4620043;
        Thu,  6 Jul 2023 14:54:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 548AB20040;
        Thu,  6 Jul 2023 14:54:07 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jul 2023 14:54:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH] KVM: s390: Don't WARN on PV validities
Date:   Thu,  6 Jul 2023 14:53:35 +0000
Message-Id: <20230706145335.136910-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QA0HXiJslPzt7_CRZpmbmsVwR1Meo0id
X-Proofpoint-GUID: QA0HXiJslPzt7_CRZpmbmsVwR1Meo0id
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-06_11,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307060130
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Validities usually indicate KVM errors and as such we want to print a
message with a high priority to alert users that a validity
occurred. With the introduction of Protected VMs it's become very easy
to trigger validities via IOCTLs if the VM is in PV mode.

An optimal solution would be to return EINVALs to all IOCTLs that
could result in such a situation. Unfortunately there are quite a lot
of ways to trigger PV validities since the number of allowed SCB data
combinations are very limited by FW in order to provide the guest's
security.

Let's only log those validities to the KVM sysfs log and skip the
WARN_ONCE(). This way we get a longish lasting log entry.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

int -> ext:
 * Fixed range
 * Extended commit message 

---
 arch/s390/kvm/intercept.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 954d39adf85c..f3c1220fd1e2 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -97,9 +97,15 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
 		  current->pid, vcpu->kvm);
 
-	/* do not warn on invalid runtime instrumentation mode */
-	WARN_ONCE(viwhy != 0x44, "kvm: unhandled validity intercept 0x%x\n",
-		  viwhy);
+	/*
+	 * Do not warn on:
+	 *  - invalid runtime instrumentation mode
+	 *  - PV related validities since they can be triggered by userspace
+	 *    PV validities are in the 0x2XXX range
+	 */
+	WARN_ONCE(viwhy != 0x44 &&
+		  ((viwhy < 0x2000) || (viwhy >= 0x3000)),
+		  "kvm: unhandled validity intercept 0x%x\n", viwhy);
 	return -EINVAL;
 }
 
-- 
2.34.1

