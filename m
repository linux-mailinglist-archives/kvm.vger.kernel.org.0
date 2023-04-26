Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952D96EF4BC
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbjDZMwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 08:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbjDZMwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 08:52:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7177C359E;
        Wed, 26 Apr 2023 05:52:38 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCVXBb008891;
        Wed, 26 Apr 2023 12:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=qu7FA3s44B3/zqMfTelpRqTXazoscEo1xo9TkjcxFF0=;
 b=UDK0ebwnvmo1/dGM2RlSiz81WnyJOhgWrw2eiF9MgolOPTjYEhIU+RKSf1jojfBVFw+T
 vxMNmPQW1IQmyB864KNrofjyMdupZkAvP4F6ima9sWbXx3hl3Vxea2SZjOHLms2iRDLp
 KRGhH6JwoGR637Isk+/drTUOYotDLk225/A2WaNgTXTLzhBYkqMa4VZg3Z1Iq4sMzdCj
 1/pFYX9+P+u7iqe/4NypmcZwp15tfSbL9xDy6Zj/JfPOgQ0QDrQOnnnN7hXJsWp/ydyM
 bpmxbv/+scyAErbriqkcVi/1BJTJd8kkTPqiWjgSsJ1o/4DFQrQPbh8KIQyQOXwHnJQI cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73sus47q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:37 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QCpUNs031081;
        Wed, 26 Apr 2023 12:52:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q73sus461-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QCTK4d015115;
        Wed, 26 Apr 2023 12:52:34 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q47771xur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 12:52:33 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QCqUVu47972654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 12:52:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C1FB20049;
        Wed, 26 Apr 2023 12:52:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDEEB20040;
        Wed, 26 Apr 2023 12:52:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.39.26])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 12:52:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 2/3] KVM: s390: vsie: clarifications on setting the APCB
Date:   Wed, 26 Apr 2023 14:51:18 +0200
Message-Id: <20230426125119.11472-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230426125119.11472-1-frankja@linux.ibm.com>
References: <20230426125119.11472-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o-LBliDWtRcD7d8R2obYtlP94ANNU696
X-Proofpoint-GUID: 9MKNmmSsFJ60A1z-doIuHbMmxZilcUBS
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

The APCB is part of the CRYCB.
The calculation of the APCB origin can be done by adding
the APCB offset to the CRYCB origin.

Current code makes confusing transformations, converting
the CRYCB origin to a pointer to calculate the APCB origin.

Let's make things simpler and keep the CRYCB origin to make
these calculations.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230214122841.13066-2-pmorel@linux.ibm.com
Message-Id: <20230214122841.13066-2-pmorel@linux.ibm.com>
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
2.40.0

