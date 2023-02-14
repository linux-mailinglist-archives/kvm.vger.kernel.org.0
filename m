Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F8E69637B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 13:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjBNM2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 07:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjBNM2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 07:28:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3C09771;
        Tue, 14 Feb 2023 04:28:50 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EBPXXC030964;
        Tue, 14 Feb 2023 12:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+UBOpxfP0uR0jDm/I3/JmfGZNedlHYGjkkbV/1FpxLQ=;
 b=EYb2YiQt+KufshAWjgqIl1HSC4sM2/C4YsFTJT7CrVbrmv6cYpgXWiw46U9ly1mloaCj
 F90k0t8YGXaovRDCnabfmr9ieW88we6thpllzjkv6TOuOo29fJg6NAYYI2kSC5X7BvEu
 mhHPOXhXJHHWh2cUt0/8usDwlQtcXFJYgcefZTOfri16CxxaAvejZ66WCnspKnISdlEY
 s+2ZAJeC3dZS2949fSSF1G0VzAccC5u3BypqCTg6Rg916I0Jgn9Q5gXoWIVe+VXaHfbV
 ZiQEI2ne4c2PvKTOfLMma7PNtFeRXYboiWZcqt+/RMYhm13MwWlExJcvI/WsGNCUAqGL LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nr9dthctw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 12:28:49 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31ECSmXe022272;
        Tue, 14 Feb 2023 12:28:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nr9dthctf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 12:28:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31E99mwP003928;
        Tue, 14 Feb 2023 12:28:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3np2n6awxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Feb 2023 12:28:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31ECSg2v38273356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 12:28:43 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0A720040;
        Tue, 14 Feb 2023 12:28:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79F702004B;
        Tue, 14 Feb 2023 12:28:42 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Feb 2023 12:28:42 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
Subject: [PATCH v3 1/1] KVM: s390: vsie: clarifications on setting the APCB
Date:   Tue, 14 Feb 2023 13:28:41 +0100
Message-Id: <20230214122841.13066-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214122841.13066-1-pmorel@linux.ibm.com>
References: <20230214122841.13066-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 41LB4dwi9edqGDOZo1Y1HFIwBvlHbqMi
X-Proofpoint-GUID: O7NpWym1WsXiNBimyQBwd7KchqcEy83K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_07,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The APCB is part of the CRYCB.
The calculation of the APCB origin can be done by adding
the APCB offset to the CRYCB origin.

Current code makes confusing transformations, converting
the CRYCB origin to a pointer to calculate the APCB origin.

Let's make things simpler and keep the CRYCB origin to make
these calculations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 50 +++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b6a0219e470a..8d6b765abf29 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -138,11 +138,15 @@ static int prepare_cpuflags(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 }
 /* Copy to APCB FORMAT1 from APCB FORMAT0 */
 static int setup_apcb10(struct kvm_vcpu *vcpu, struct kvm_s390_apcb1 *apcb_s,
-			unsigned long apcb_o, struct kvm_s390_apcb1 *apcb_h)
+			unsigned long crycb_gpa, struct kvm_s390_apcb1 *apcb_h)
 {
 	struct kvm_s390_apcb0 tmp;
+	unsigned long apcb_gpa;
 
-	if (read_guest_real(vcpu, apcb_o, &tmp, sizeof(struct kvm_s390_apcb0)))
+	apcb_gpa = crycb_gpa + offsetof(struct kvm_s390_crypto_cb, apcb0);
+
+	if (read_guest_real(vcpu, apcb_gpa, &tmp,
+			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
 	apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
@@ -157,15 +161,19 @@ static int setup_apcb10(struct kvm_vcpu *vcpu, struct kvm_s390_apcb1 *apcb_s,
  * setup_apcb00 - Copy to APCB FORMAT0 from APCB FORMAT0
  * @vcpu: pointer to the virtual CPU
  * @apcb_s: pointer to start of apcb in the shadow crycb
- * @apcb_o: pointer to start of original apcb in the guest2
+ * @crycb_gpa: guest physical address to start of original guest crycb
  * @apcb_h: pointer to start of apcb in the guest1
  *
  * Returns 0 and -EFAULT on error reading guest apcb
  */
 static int setup_apcb00(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
-			unsigned long apcb_o, unsigned long *apcb_h)
+			unsigned long crycb_gpa, unsigned long *apcb_h)
 {
-	if (read_guest_real(vcpu, apcb_o, apcb_s,
+	unsigned long apcb_gpa;
+
+	apcb_gpa = crycb_gpa + offsetof(struct kvm_s390_crypto_cb, apcb0);
+
+	if (read_guest_real(vcpu, apcb_gpa, apcb_s,
 			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
@@ -178,16 +186,20 @@ static int setup_apcb00(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
  * setup_apcb11 - Copy the FORMAT1 APCB from the guest to the shadow CRYCB
  * @vcpu: pointer to the virtual CPU
  * @apcb_s: pointer to start of apcb in the shadow crycb
- * @apcb_o: pointer to start of original guest apcb
+ * @crycb_gpa: guest physical address to start of original guest crycb
  * @apcb_h: pointer to start of apcb in the host
  *
  * Returns 0 and -EFAULT on error reading guest apcb
  */
 static int setup_apcb11(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
-			unsigned long apcb_o,
+			unsigned long crycb_gpa,
 			unsigned long *apcb_h)
 {
-	if (read_guest_real(vcpu, apcb_o, apcb_s,
+	unsigned long apcb_gpa;
+
+	apcb_gpa = crycb_gpa + offsetof(struct kvm_s390_crypto_cb, apcb1);
+
+	if (read_guest_real(vcpu, apcb_gpa, apcb_s,
 			    sizeof(struct kvm_s390_apcb1)))
 		return -EFAULT;
 
@@ -200,7 +212,7 @@ static int setup_apcb11(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
  * setup_apcb - Create a shadow copy of the apcb.
  * @vcpu: pointer to the virtual CPU
  * @crycb_s: pointer to shadow crycb
- * @crycb_o: pointer to original guest crycb
+ * @crycb_gpa: guest physical address of original guest crycb
  * @crycb_h: pointer to the host crycb
  * @fmt_o: format of the original guest crycb.
  * @fmt_h: format of the host crycb.
@@ -211,50 +223,46 @@ static int setup_apcb11(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
  * Return 0 or an error number if the guest and host crycb are incompatible.
  */
 static int setup_apcb(struct kvm_vcpu *vcpu, struct kvm_s390_crypto_cb *crycb_s,
-	       const u32 crycb_o,
+	       const u32 crycb_gpa,
 	       struct kvm_s390_crypto_cb *crycb_h,
 	       int fmt_o, int fmt_h)
 {
-	struct kvm_s390_crypto_cb *crycb;
-
-	crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;
-
 	switch (fmt_o) {
 	case CRYCB_FORMAT2:
-		if ((crycb_o & PAGE_MASK) != ((crycb_o + 256) & PAGE_MASK))
+		if ((crycb_gpa & PAGE_MASK) != ((crycb_gpa + 256) & PAGE_MASK))
 			return -EACCES;
 		if (fmt_h != CRYCB_FORMAT2)
 			return -EINVAL;
 		return setup_apcb11(vcpu, (unsigned long *)&crycb_s->apcb1,
-				    (unsigned long) &crycb->apcb1,
+				    crycb_gpa,
 				    (unsigned long *)&crycb_h->apcb1);
 	case CRYCB_FORMAT1:
 		switch (fmt_h) {
 		case CRYCB_FORMAT2:
 			return setup_apcb10(vcpu, &crycb_s->apcb1,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_gpa,
 					    &crycb_h->apcb1);
 		case CRYCB_FORMAT1:
 			return setup_apcb00(vcpu,
 					    (unsigned long *) &crycb_s->apcb0,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_gpa,
 					    (unsigned long *) &crycb_h->apcb0);
 		}
 		break;
 	case CRYCB_FORMAT0:
-		if ((crycb_o & PAGE_MASK) != ((crycb_o + 32) & PAGE_MASK))
+		if ((crycb_gpa & PAGE_MASK) != ((crycb_gpa + 32) & PAGE_MASK))
 			return -EACCES;
 
 		switch (fmt_h) {
 		case CRYCB_FORMAT2:
 			return setup_apcb10(vcpu, &crycb_s->apcb1,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_gpa,
 					    &crycb_h->apcb1);
 		case CRYCB_FORMAT1:
 		case CRYCB_FORMAT0:
 			return setup_apcb00(vcpu,
 					    (unsigned long *) &crycb_s->apcb0,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_gpa,
 					    (unsigned long *) &crycb_h->apcb0);
 		}
 	}
-- 
2.31.1

