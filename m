Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD166CDB3C
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjC2NwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 09:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjC2NwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 09:52:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0809110F2;
        Wed, 29 Mar 2023 06:52:19 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDlm8G003300;
        Wed, 29 Mar 2023 13:52:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=PalkQPaFzDUqS4MmwM/oY7YjDqKacwIdmQ+1ljE2las=;
 b=LVCEfJusUPc9xpd8UL4HlHu3khUHEm1lPI1L8BJnQ/Ju/2PNYJT1ec3xtO4N8Ys7XgUn
 9iD8GUM0A429DC4TLN+Ksp3Lp+GqzSlayvPPhMNcEkP0FWPwKbRZQQHuhz5/Y7Hbx3Tb
 5gRf7hPqT9XcDX3ch60zJ38V2g6ISs4CITSbMbdudJDJJXOcL9xYlZyPGf3/zsIhr50C
 owlYLqxjKLHIgWFb84acYGlg5/1iGTa9Y57V54GIonnuPsscBg/6eoGHqBLInFsjrY3+
 EUF49L/6ZXdfnbmQPNGFtcKfpwynKPwwJLfudLzi9i0l3Y3zCudiPFZ55h+4RplOXip/ vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmph8g380-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:52:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TDmxR9008081;
        Wed, 29 Mar 2023 13:52:18 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmph8g36e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:52:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SMXOJV010293;
        Wed, 29 Mar 2023 13:52:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6n0x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:52:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TDqBqR43843932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 13:52:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80E7F20043;
        Wed, 29 Mar 2023 13:52:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07E8B20040;
        Wed, 29 Mar 2023 13:52:11 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.75.165])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 13:52:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 1/1] KVM: s390: pv: fix external interruption loop not always detected
Date:   Wed, 29 Mar 2023 15:51:29 +0200
Message-Id: <20230329135129.77385-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230329135129.77385-1-frankja@linux.ibm.com>
References: <20230329135129.77385-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M0zFpnCri0R8Oa7vZ9JW4aqJW57_KkPA
X-Proofpoint-ORIG-GUID: x-IRKM9i-MvBKMYyCKi-cmdc5cpZm05z
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_07,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

To determine whether the guest has caused an external interruption loop
upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
be inspected to see whether external interrupts are enabled.

Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
PV, KVM can only access the encrypted guest lowcore and hence the
ext_new_psw must not be taken from guest lowcore.

handle_external_interrupt() incorrectly did that and hence was not able
to reliably tell whether an external interruption loop is happening or
not. False negatives cause spurious failures of my kvm-unit-test
for extint loops[1] under PV.

Since code 20 is only caused under PV if and only if the guest's
ext_new_psw is enabled for external interrupts, false positive detection
of a external interruption loop can not happen.

Fix this issue by instead looking at the guest PSW in the state
description. Since the PSW swap for external interrupt is done by the
ultravisor before the intercept is caused, this reliably tells whether
the guest is enabled for external interrupts in the ext_new_psw.

Also update the comments to explain better what is happening.

[1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")
Link: https://lore.kernel.org/r/20230213085520.100756-2-nrb@linux.ibm.com
Message-Id: <20230213085520.100756-2-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 0ee02dae14b2..2cda8d9d7c6e 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -271,10 +271,18 @@ static int handle_prog(struct kvm_vcpu *vcpu)
  * handle_external_interrupt - used for external interruption interceptions
  * @vcpu: virtual cpu
  *
- * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
- * the new PSW does not have external interrupts disabled. In the first case,
- * we've got to deliver the interrupt manually, and in the second case, we
- * drop to userspace to handle the situation there.
+ * This interception occurs if:
+ * - the CPUSTAT_EXT_INT bit was already set when the external interrupt
+ *   occurred. In this case, the interrupt needs to be injected manually to
+ *   preserve interrupt priority.
+ * - the external new PSW has external interrupts enabled, which will cause an
+ *   interruption loop. We drop to userspace in this case.
+ *
+ * The latter case can be detected by inspecting the external mask bit in the
+ * external new psw.
+ *
+ * Under PV, only the latter case can occur, since interrupt priorities are
+ * handled in the ultravisor.
  */
 static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -285,10 +293,18 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_external_interrupt++;
 
-	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
-	if (rc)
-		return rc;
-	/* We can not handle clock comparator or timer interrupt with bad PSW */
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		newpsw = vcpu->arch.sie_block->gpsw;
+	} else {
+		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * Clock comparator or timer interrupt with external interrupt enabled
+	 * will cause interrupt loop. Drop to userspace.
+	 */
 	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
 	    (newpsw.mask & PSW_MASK_EXT))
 		return -EOPNOTSUPP;
-- 
2.39.2

