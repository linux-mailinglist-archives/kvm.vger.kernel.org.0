Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA00F5ACE07
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 10:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiIEImB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 04:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiIEIl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 04:41:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796A7FFA;
        Mon,  5 Sep 2022 01:41:56 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2858Qrud015938;
        Mon, 5 Sep 2022 08:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9UVYFgAh52ib3j1YI92FCeEQVdbURKw9mP4lweIvr0k=;
 b=DxM5DSlf0liBUCP0qKi5JSYwrrHVviKSNkLQsH7Oq669nrMypLkj00+3w1jmfMLlpo+H
 kgbI70QpevVaVV1B+HbYoSmtSmKrI4ZS2Ol3GAB4ITQ05U2WtXwPzEddXa0PRiPcxYM9
 oVzVuANphJbK77wQzzXuOZU4Y7ey+Z6SgHtLg2t8ytTDjnsKTDi52c1+OVTCJFS4mHST
 AJSvNNmmHJgfWy8/UoJnQGvhPuSWNNUpviHLJMz8qHA01nl70r2NjoO8JokVTRjn3Wus
 d49OIcfNYRPsugHoZxY67ZnfSCXmkOAlh2JwBwOFK0M+ndTLqLUstZmRqGAdk6xdYV4k ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jddkxrcdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 08:41:56 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2858S6Xi020143;
        Mon, 5 Sep 2022 08:41:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jddkxrcd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 08:41:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2858a6Yw012606;
        Mon, 5 Sep 2022 08:41:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3jbxj8t5dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 08:41:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2858foZj43123062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 08:41:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11368A4051;
        Mon,  5 Sep 2022 08:41:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75506A4040;
        Mon,  5 Sep 2022 08:41:49 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.66.232])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Sep 2022 08:41:49 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com
Subject: [PATCH] KVM: s390: vsie: fix crycb virtual vs physical usage
Date:   Mon,  5 Sep 2022 10:41:48 +0200
Message-Id: <20220905084148.234821-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qzyyhsdbhk_HKC3RJSbea-c0eDXaVkWo
X-Proofpoint-GUID: _dYIp8JSws_NfReCVE7EP-nm6mZwofKx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_05,2022-09-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare VSIE for architectural changes where lowmem kernel real and
kernel virtual address are different.

When we get the original crycb from the guest crycb we can use the
phys_to_virt transformation, which will use the host transformations,
but we must use an offset to calculate the guest real address apcb
and give it to read_guest_real().

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

