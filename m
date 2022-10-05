Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519E95F5450
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJEMU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiJEMU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:20:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D6750052;
        Wed,  5 Oct 2022 05:20:57 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295B6pPO024237;
        Wed, 5 Oct 2022 12:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=clKTTodDgibmvg6FNHQgjqGVUxVc/RnMc9ur4VRDnOk=;
 b=BXjXggM6KqRQgi0ax20J11wIWYwcUsQW8YXiaBe3OmnpcJ1macs6yvqTwKNkCaqvYfVA
 sWMuYO7UiJcmB1mM2QrOVkc0nSteiGevA8qMuLfWahxfQrNjX3gJlGdTa+28+MxYzHll
 2Imn2+4C4oLq3gEnnWoSGcSMO0x9JYX6M/46Y+FHi+zXcHCOMf/Rspjr0Cem6JC3Nd4N
 rz68O/zIq7ekpwJkalLXRR4ur1mB09+cTS11jC60f0elJvkgN5C1XVI7hNQG1msoM/c4
 UkkW/yug9NIxOWbRFhuuVf0Qw8TSTTDXVUijKLxOq9maXM/As/wKLoZLDTlAquJ3lsI/ vA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0fsnuxhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 12:20:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295C6DDK021143;
        Wed, 5 Oct 2022 12:20:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3jxd695hgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 12:20:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295CKpgK6750752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 12:20:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5310EAE04D;
        Wed,  5 Oct 2022 12:20:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1783FAE045;
        Wed,  5 Oct 2022 12:20:51 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 12:20:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [v2] KVM: s390: pv: fix external interruption loop not always detected
Date:   Wed,  5 Oct 2022 14:20:50 +0200
Message-Id: <20221005122050.60625-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3nfA9cFBNz_TGBq_IBuMMaw1EuA76EyK
X-Proofpoint-GUID: 3nfA9cFBNz_TGBq_IBuMMaw1EuA76EyK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_01,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 suspectscore=0 phishscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=884 impostorscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 arch/s390/kvm/intercept.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 88112065d941..ea43463b102e 100644
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
+ *   occured. In this case, the interrupt needs to be injected manually to
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
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		newpsw = vcpu->arch.sie_block->gpsw;
+	else {
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
2.35.3

