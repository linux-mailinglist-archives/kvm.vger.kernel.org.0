Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADC61EDF1
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 09:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiKGI5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 03:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiKGI5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 03:57:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA036167CE;
        Mon,  7 Nov 2022 00:57:33 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77SOi1011918;
        Mon, 7 Nov 2022 08:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=F+Y+mUpQRfC0L4FjD3P+zxYwZIHz8W1xZryoB01mvzA=;
 b=tOtHtbbmLgmx57H3pej1yeNXA259KTlVqQFK4r1kKWgF0OSGO+Vi/il88HQpuPUCAIfO
 2mlZc81blXNVi26o+Lw2I5Z56MIP/fG2AEb5uDSL6mwDPHIvNA2j84VD3BG9M//VcLr8
 8mhDdi1tzCSIZ16qga80E1Rq1S+rvnOC8WllnzTcW3IFY5ubVdUq777GWZSX4rsvcHo5
 A6FJJ7mhuvSUm76n4mm28/QHoO0twp0InoI+0f47745m74toA6RtQDPCOaRAOQnOdCsw
 39bBovu/q5VRLG8JvLlMZz/1w+mqLmBK+biANollthrjQ3ePJFdEmPsgQ5JP/WZ4s2jj NQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1teux92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 08:57:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A78p1Uj025764;
        Mon, 7 Nov 2022 08:57:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3kngqda9v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 08:57:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A78plIH43843886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 08:51:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17F1EA4051;
        Mon,  7 Nov 2022 08:57:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1F07A404D;
        Mon,  7 Nov 2022 08:57:27 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 08:57:27 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pasic@linux.ibm.com, akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        mimu@linux.ibm.com, vneethv@linux.ibm.com, oberpar@linux.ibm.com
Subject: [PATCH v1] KVM: s390: GISA: sort out physical vs virtual pointers usage
Date:   Mon,  7 Nov 2022 09:57:27 +0100
Message-Id: <20221107085727.1533792-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pxFb1Zd7Jj975ATAWmLPbyqhDt3HhA1I
X-Proofpoint-ORIG-GUID: pxFb1Zd7Jj975ATAWmLPbyqhDt3HhA1I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix virtual vs physical address confusion (which currently are the same).

In chsc_sgib(), do the virtual-physical conversion in the caller since
the caller needs to make sure it is a 31-bit address and zero has a
special meaning (disassociating the GIB).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ab569faf0df2..ae018217eac8 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3104,9 +3104,9 @@ static enum hrtimer_restart gisa_vcpu_kicker(struct hrtimer *timer)
 static void process_gib_alert_list(void)
 {
 	struct kvm_s390_gisa_interrupt *gi;
+	u32 final, gisa_phys, origin = 0UL;
 	struct kvm_s390_gisa *gisa;
 	struct kvm *kvm;
-	u32 final, origin = 0UL;
 
 	do {
 		/*
@@ -3132,9 +3132,10 @@ static void process_gib_alert_list(void)
 		 * interruptions asap.
 		 */
 		while (origin & GISA_ADDR_MASK) {
-			gisa = (struct kvm_s390_gisa *)(u64)origin;
+			gisa_phys = origin;
+			gisa = phys_to_virt(gisa_phys);
 			origin = gisa->next_alert;
-			gisa->next_alert = (u32)(u64)gisa;
+			gisa->next_alert = gisa_phys;
 			kvm = container_of(gisa, struct sie_page2, gisa)->kvm;
 			gi = &kvm->arch.gisa_int;
 			if (hrtimer_active(&gi->timer))
@@ -3418,6 +3419,7 @@ void kvm_s390_gib_destroy(void)
 
 int kvm_s390_gib_init(u8 nisc)
 {
+	u32 gib_origin;
 	int rc = 0;
 
 	if (!css_general_characteristics.aiv) {
@@ -3439,7 +3441,8 @@ int kvm_s390_gib_init(u8 nisc)
 	}
 
 	gib->nisc = nisc;
-	if (chsc_sgib((u32)(u64)gib)) {
+	gib_origin = virt_to_phys(gib);
+	if (chsc_sgib(gib_origin)) {
 		pr_err("Associating the GIB with the AIV facility failed\n");
 		free_page((unsigned long)gib);
 		gib = NULL;
-- 
2.37.3

