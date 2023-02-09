Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F70C6904B9
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBIKZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjBIKZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205AC5EF83;
        Thu,  9 Feb 2023 02:25:15 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AAkTw023690;
        Thu, 9 Feb 2023 10:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=lgM065lolMwI775i12owCUB5/VFRyVuP79iuL/SJONg=;
 b=GzmQy5JucHk+gHZt+Ge8MlnYnPVQB6OepTsN5uNnR8tTYLrt9xUK8/ft3eKNZOvoKdac
 81AESmhBLR5gWgI4zNpUc/Y3U3JYsDFNQB4tl7QzPQQoVcygabPdEAn38REGsVV1dalq
 +nfBLIsbiOoEWCbFQGqmcmXeyxYUR2/WhHLjLCvLcr4X+LWVPrpcpQc+0pQRkm5J2ge+
 bTElxUW4prZmqMXzr8xpopK8LpagGuQ+a7VZ2wsizzJ++toF8BmJSziSnfHWV3P+CovX
 ZmTmQT/Oq2Xm44i0xDtnqR3HtNKXqalKhhP99P7couLio5dh/e+7caqs85oZ1Uvd8G2x Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxjgggsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:14 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319ADlcf010686;
        Thu, 9 Feb 2023 10:25:14 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxjgggsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318L3hLM001846;
        Thu, 9 Feb 2023 10:25:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06p0vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP7xw44630362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCD2520071;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B95A42006C;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 17/18] KVM: s390: GISA: sort out physical vs virtual pointers usage
Date:   Thu,  9 Feb 2023 11:22:59 +0100
Message-Id: <20230209102300.12254-18-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NIbBkkjsJG7yj3uA2Zo9_w1vi7O4sv2e
X-Proofpoint-GUID: ggKheKkhLw5TS9jyYt1Ff5xtRV59rtn7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the same).

In chsc_sgib(), do the virtual-physical conversion in the caller since
the caller needs to make sure it is a 31-bit address and zero has a
special meaning (disassociating the GIB).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Link: https://lore.kernel.org/r/20221107085727.1533792-1-nrb@linux.ibm.com
Message-Id: <20221107085727.1533792-1-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 1dae78deddf2..bbb280633cb8 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3099,9 +3099,9 @@ static enum hrtimer_restart gisa_vcpu_kicker(struct hrtimer *timer)
 static void process_gib_alert_list(void)
 {
 	struct kvm_s390_gisa_interrupt *gi;
+	u32 final, gisa_phys, origin = 0UL;
 	struct kvm_s390_gisa *gisa;
 	struct kvm *kvm;
-	u32 final, origin = 0UL;
 
 	do {
 		/*
@@ -3127,9 +3127,10 @@ static void process_gib_alert_list(void)
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
@@ -3413,6 +3414,7 @@ void kvm_s390_gib_destroy(void)
 
 int kvm_s390_gib_init(u8 nisc)
 {
+	u32 gib_origin;
 	int rc = 0;
 
 	if (!css_general_characteristics.aiv) {
@@ -3434,7 +3436,8 @@ int kvm_s390_gib_init(u8 nisc)
 	}
 
 	gib->nisc = nisc;
-	if (chsc_sgib((u32)(u64)gib)) {
+	gib_origin = virt_to_phys(gib);
+	if (chsc_sgib(gib_origin)) {
 		pr_err("Associating the GIB with the AIV facility failed\n");
 		free_page((unsigned long)gib);
 		gib = NULL;
-- 
2.39.1

