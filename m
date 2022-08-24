Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565FC59FAAC
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 14:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiHXM6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiHXM60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 08:58:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BFD979E6;
        Wed, 24 Aug 2022 05:58:25 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OCv9VW011828;
        Wed, 24 Aug 2022 12:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=xpeuA/gVNbFDVbnwhd5uP1sycDEY6zoMLly7uoTpo0E=;
 b=YyfxGMCvbdsZhel3H29Zu87bDy5iz1UqHYI8c37I5WvuWopdJHD6y5WmSWt4Tv1kPAWg
 QmKQRj4vvmkysTD4FR4Ml+6/IIHjyCzzpxM+TuvTcF9mpu+tXh+VY2r2dAcbmw/WnpZn
 bvxwD90UsbLZD+C6REJ+iDwRLTpXgEmMywg4OwkND6VIGZmLpAaTo6sNs7hlkY6WgWhV
 CyfDQLmJ/bO42qq1oR54M+XmleRx/CZhAfwrsmCDWh5tokKNW1Eh0fEV0EVA2B40Dpxt
 5fbuaBI6ZYr4tM4N+whwV3gyui3plim3qKxLYnNjtrkv8+pZ5/eWwlMg50I+nGp3EwNN VA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5meq80np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 12:58:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27OCrAV1032585;
        Wed, 24 Aug 2022 12:58:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88w58g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 12:58:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27OCwILd31719910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 12:58:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9D534203F;
        Wed, 24 Aug 2022 12:58:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 924ED42041;
        Wed, 24 Aug 2022 12:58:18 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Aug 2022 12:58:18 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [v1] KVM: s390: pv: fix external interruption loop not always detected
Date:   Wed, 24 Aug 2022 14:58:18 +0200
Message-Id: <20220824125818.15904-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yAKHeNhJSlDPB8Fu0umuWdd1-1a38G7u
X-Proofpoint-ORIG-GUID: yAKHeNhJSlDPB8Fu0umuWdd1-1a38G7u
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_06,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 phishscore=0 bulkscore=0 impostorscore=0 mlxlogscore=774
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

[1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 88112065d941..bf875da86289 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -285,9 +285,14 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_external_interrupt++;
 
-	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
-	if (rc)
-		return rc;
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		newpsw = vcpu->arch.sie_block->gpsw;
+	else {
+		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
+		if (rc)
+			return rc;
+	}
+
 	/* We can not handle clock comparator or timer interrupt with bad PSW */
 	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
 	    (newpsw.mask & PSW_MASK_EXT))
-- 
2.35.3

