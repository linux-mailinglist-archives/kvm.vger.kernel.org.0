Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEF760C7D0
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 11:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiJYJUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 05:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJYJTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 05:19:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546DD16D895;
        Tue, 25 Oct 2022 02:13:30 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P8jQm1011200;
        Tue, 25 Oct 2022 09:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=C0968ZWBFOazVrjsAN8FV+ygdlEqrbRRvFakZwWPuxQ=;
 b=QQkJ+mWh0KB8c6FPuFg+IMZj2WKtEAXzGBPHH83avUBcwclFhfH4XuST5Z6S4psoQDtR
 +R6fElzaN0cFixqFdgxObIqZpBx/q2pwBymLEscQdkpSj96+QaV7APm84lbk1JTFHfb8
 QihaUsks6XrZ6IgqQdgGO7d6oZCsw1jRkKi0fU1eo4BDBZWmyYFM3aMo/3vGxOikMBQy
 DcUV7rl8uU9VtfNy77qPrZvje7xRgoi86vxsQHNs1IX5ymVei1wOUOodcQCrBM5wHnaI
 eZLdvHywyhkVUkSVDdD53pJgaxCxpPe9TJRUhNK+7whr6RF+DR7pJQoXmUBzOPQ02zC+ JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keaxbvha8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 09:13:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29P8s67M001398;
        Tue, 25 Oct 2022 09:13:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keaxbvh98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 09:13:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P96ZYr030525;
        Tue, 25 Oct 2022 09:13:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugasxtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 09:13:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P9DwMQ39453098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 09:13:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B20A0A405C;
        Tue, 25 Oct 2022 09:13:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E0E6A405F;
        Tue, 25 Oct 2022 09:13:23 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.30.119])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 09:13:23 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com
Subject: [PATCH v2 1/1] KVM: s390: vsie: clarifications on setting the APCB
Date:   Tue, 25 Oct 2022 11:13:19 +0200
Message-Id: <20221025091319.37110-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025091319.37110-1-pmorel@linux.ibm.com>
References: <20221025091319.37110-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aOgpyQooVVThW98wDdjjs3QBYBYX4XBi
X-Proofpoint-ORIG-GUID: qq6We6T3Yp6DnOux9guixK9lK1g_kdML
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=878 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250052
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
---
 arch/s390/kvm/vsie.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 94138f8f0c1c..f37851c9b1ab 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -138,9 +138,12 @@ static int prepare_cpuflags(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 }
 /* Copy to APCB FORMAT1 from APCB FORMAT0 */
 static int setup_apcb10(struct kvm_vcpu *vcpu, struct kvm_s390_apcb1 *apcb_s,
-			unsigned long apcb_o, struct kvm_s390_apcb1 *apcb_h)
+			unsigned long crycb_o, struct kvm_s390_apcb1 *apcb_h)
 {
 	struct kvm_s390_apcb0 tmp;
+	unsigned long apcb_o;
+
+	apcb_o = crycb_o + offsetof(struct kvm_s390_crypto_cb, apcb0);
 
 	if (read_guest_real(vcpu, apcb_o, &tmp, sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
@@ -157,14 +160,18 @@ static int setup_apcb10(struct kvm_vcpu *vcpu, struct kvm_s390_apcb1 *apcb_s,
  * setup_apcb00 - Copy to APCB FORMAT0 from APCB FORMAT0
  * @vcpu: pointer to the virtual CPU
  * @apcb_s: pointer to start of apcb in the shadow crycb
- * @apcb_o: pointer to start of original apcb in the guest2
+ * @crycb_o: real guest address to start of original guest crycb
  * @apcb_h: pointer to start of apcb in the guest1
  *
  * Returns 0 and -EFAULT on error reading guest apcb
  */
 static int setup_apcb00(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
-			unsigned long apcb_o, unsigned long *apcb_h)
+			unsigned long crycb_o, unsigned long *apcb_h)
 {
+	unsigned long apcb_o;
+
+	apcb_o = crycb_o + offsetof(struct kvm_s390_crypto_cb, apcb0);
+
 	if (read_guest_real(vcpu, apcb_o, apcb_s,
 			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
@@ -178,15 +185,19 @@ static int setup_apcb00(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
  * setup_apcb11 - Copy the FORMAT1 APCB from the guest to the shadow CRYCB
  * @vcpu: pointer to the virtual CPU
  * @apcb_s: pointer to start of apcb in the shadow crycb
- * @apcb_o: pointer to start of original guest apcb
+ * @crycb_o: real guest address to start of original guest crycb
  * @apcb_h: pointer to start of apcb in the host
  *
  * Returns 0 and -EFAULT on error reading guest apcb
  */
 static int setup_apcb11(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
-			unsigned long apcb_o,
+			unsigned long crycb_o,
 			unsigned long *apcb_h)
 {
+	unsigned long apcb_o;
+
+	apcb_o = crycb_o + offsetof(struct kvm_s390_crypto_cb, apcb1);
+
 	if (read_guest_real(vcpu, apcb_o, apcb_s,
 			    sizeof(struct kvm_s390_apcb1)))
 		return -EFAULT;
@@ -200,7 +211,7 @@ static int setup_apcb11(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
  * setup_apcb - Create a shadow copy of the apcb.
  * @vcpu: pointer to the virtual CPU
  * @crycb_s: pointer to shadow crycb
- * @crycb_o: pointer to original guest crycb
+ * @crycb_o: real address of original guest crycb
  * @crycb_h: pointer to the host crycb
  * @fmt_o: format of the original guest crycb.
  * @fmt_h: format of the host crycb.
@@ -215,10 +226,6 @@ static int setup_apcb(struct kvm_vcpu *vcpu, struct kvm_s390_crypto_cb *crycb_s,
 	       struct kvm_s390_crypto_cb *crycb_h,
 	       int fmt_o, int fmt_h)
 {
-	struct kvm_s390_crypto_cb *crycb;
-
-	crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;
-
 	switch (fmt_o) {
 	case CRYCB_FORMAT2:
 		if ((crycb_o & PAGE_MASK) != ((crycb_o + 256) & PAGE_MASK))
@@ -226,18 +233,18 @@ static int setup_apcb(struct kvm_vcpu *vcpu, struct kvm_s390_crypto_cb *crycb_s,
 		if (fmt_h != CRYCB_FORMAT2)
 			return -EINVAL;
 		return setup_apcb11(vcpu, (unsigned long *)&crycb_s->apcb1,
-				    (unsigned long) &crycb->apcb1,
+				    crycb_o,
 				    (unsigned long *)&crycb_h->apcb1);
 	case CRYCB_FORMAT1:
 		switch (fmt_h) {
 		case CRYCB_FORMAT2:
 			return setup_apcb10(vcpu, &crycb_s->apcb1,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_o,
 					    &crycb_h->apcb1);
 		case CRYCB_FORMAT1:
 			return setup_apcb00(vcpu,
 					    (unsigned long *) &crycb_s->apcb0,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_o,
 					    (unsigned long *) &crycb_h->apcb0);
 		}
 		break;
@@ -248,13 +255,13 @@ static int setup_apcb(struct kvm_vcpu *vcpu, struct kvm_s390_crypto_cb *crycb_s,
 		switch (fmt_h) {
 		case CRYCB_FORMAT2:
 			return setup_apcb10(vcpu, &crycb_s->apcb1,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_o,
 					    &crycb_h->apcb1);
 		case CRYCB_FORMAT1:
 		case CRYCB_FORMAT0:
 			return setup_apcb00(vcpu,
 					    (unsigned long *) &crycb_s->apcb0,
-					    (unsigned long) &crycb->apcb0,
+					    crycb_o,
 					    (unsigned long *) &crycb_h->apcb0);
 		}
 	}
-- 
2.31.1

