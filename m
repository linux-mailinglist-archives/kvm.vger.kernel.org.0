Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468B7694015
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 09:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBMIzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 03:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjBMIza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 03:55:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1924713519;
        Mon, 13 Feb 2023 00:55:27 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8ROB0005608;
        Mon, 13 Feb 2023 08:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=vc5bnivazqi4IuLKE4LfqGEDmEbxQU26YsrWUeGFmZ8=;
 b=Azihh8ljpkXhq0KW9EHGUVFiBXlGFDPiVGXM6y80/QLExQMJpNQSVvfHL53k2c6QPeM6
 u0xpfq2UiYx+c6NO/wmiFEf2tHeAGsdcvYzKjuTnQNC5efV9US2dLADdRmC/9efM/wr7
 +3KLi4JeVOHoWLXqjsfwd1MgpIR2yG/cCuZuCqF+JXSG8SYesM2nz7k0IQF1MN/iKloH
 FIFdiyYP4cqs7qOlU+1Ld5nGaG7kIhf3H8bfXgJoUfdeFRPnmB8LFg/9M7DllgUri7X/
 m25LbSu0pOMrKn7QeGxn039/1t0X4EOFkYBUI/DOOMJ2iTQcc8tEI28oIOEhSEqDPT2W gg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqhqa8jmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:55:25 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1mR6r021570;
        Mon, 13 Feb 2023 08:55:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3np2n6hsnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 08:55:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31D8tKYQ41419110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 08:55:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFCBE20043;
        Mon, 13 Feb 2023 08:55:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C9C72004B;
        Mon, 13 Feb 2023 08:55:20 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 08:55:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 1/1] KVM: s390: pv: fix external interruption loop not always detected
Date:   Mon, 13 Feb 2023 09:55:20 +0100
Message-Id: <20230213085520.100756-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213085520.100756-1-nrb@linux.ibm.com>
References: <20230213085520.100756-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SEYn8seTjyw7lwfnEocWaM2Uab3uIPnc
X-Proofpoint-ORIG-GUID: SEYn8seTjyw7lwfnEocWaM2Uab3uIPnc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130076
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
2.39.1

