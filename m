Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D781F59FE5F
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiHXPbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 11:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiHXPa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 11:30:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1FADEB2;
        Wed, 24 Aug 2022 08:30:26 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OFDjwh024804;
        Wed, 24 Aug 2022 15:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AlgD0tRJZancLsm5tjdFdyG0SXTnhtFLMqnPKtXUupo=;
 b=iW9lv4HWZjY1FZWRcPPxN6V8AaZ8PFc3be9arX09imaJcQvoz96h8HAObp0421lteM2L
 2HpfofsPOBzZyxQl0fmy9hwX92ousYPstawghhZqLRIkvGgI3unYswcxTcjEdIQ9CqaI
 S5EC7C077WcT/NJm4+n9Q3am9b0w63C5PKItUUJcve866XscHFn6Nun2RVVkJhwvzWoI
 qn/jcEMmcS1yQZMaF8D8ODE+VImAgTwenpcgPPIoSVp7QK7UJHNh12M4f5CsWjn1Ma9A
 ujcLl5WjFJjqxXG2b9nc7wndr2Oh1DKOVfY8quxhKnu5kPnaLoixYwnAf2gybldLEHKl Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5pemrgwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 15:30:22 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27OFDinv024795;
        Wed, 24 Aug 2022 15:30:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5pemrgw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 15:30:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27OFLLt7008739;
        Wed, 24 Aug 2022 15:30:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3j2q88w9pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 15:30:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27OFUGu631981862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 15:30:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2021CAE055;
        Wed, 24 Aug 2022 15:30:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3370AE051;
        Wed, 24 Aug 2022 15:30:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Aug 2022 15:30:15 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Pass initialized arg even if unused
Date:   Wed, 24 Aug 2022 17:30:11 +0200
Message-Id: <20220824153011.4004573-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4e7T6gqiij7L_CGOGcuryjplXCHzmwma
X-Proofpoint-ORIG-GUID: 6TBa3dtzGeF1ThkojpgOzt90lCDzYBxm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This silences smatch warnings reported by kbuild bot:
arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.

This is because it cannot tell that the value is not used in this case.
The trans_exc* only examine prot if code is PGM_PROTECTION.
Pass a dummy value for other codes.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 082ec5f2c3a5..89186701116a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -489,6 +489,8 @@ enum prot_type {
 	PROT_TYPE_ALC  = 2,
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
+	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
+	PROT_NONE,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -503,6 +505,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 
 	switch (code) {
 	case PGM_PROTECTION:
+		WARN(unlikely(prot == PROT_NONE), "Invalid prot argument");
 		switch (prot) {
 		case PROT_TYPE_IEP:
 			tec->b61 = 1;
@@ -519,6 +522,8 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 		case PROT_TYPE_DAT:
 			tec->b61 = 1;
 			break;
+		case PROT_NONE:
+			/* We should never get here, acts like termination */
 		}
 		if (terminate) {
 			tec->b56 = 0;
@@ -968,8 +973,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 				return rc;
 		} else {
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
-			if (kvm_is_error_gpa(vcpu->kvm, gpa))
+			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
+				prot = PROT_NONE;
+			}
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
@@ -1112,8 +1119,6 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		if (rc == PGM_PROTECTION && try_storage_prot_override)
 			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
 							data, fragment_len, PAGE_SPO_ACC);
-		if (rc == PGM_PROTECTION)
-			prot = PROT_TYPE_KEYC;
 		if (rc)
 			break;
 		len -= fragment_len;
@@ -1123,6 +1128,10 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	if (rc > 0) {
 		bool terminate = (mode == GACC_STORE) && (idx > 0);
 
+		if (rc == PGM_PROTECTION)
+			prot = PROT_TYPE_KEYC;
+		else
+			prot = PROT_NONE;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:
-- 
2.34.1

