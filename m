Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75615A1979
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbiHYTZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHYTZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:25:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A9A52FFE;
        Thu, 25 Aug 2022 12:25:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PJAs0o017320;
        Thu, 25 Aug 2022 19:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=gPCt/V72GS8kHgQwZJseZmnga1IxHVTySW90gcQzDlA=;
 b=AGD2nQEej8hFK/vKGAQBOOzyWXrEHWujK+9grF7g4/8KQEWUsL3QU9iwgxPFkGyL7BQZ
 9wiY4rQUp36SspUShF2kT/dnMc36BbOHBfdNWKOYAPYqkJul7YVSpAR+qd+yyuWPhXCX
 mc9MTJh39e8xxiV8GtEbGC7qwhP9mawMNN5BcPx+oQbcqNmDHe6gMi5FzyNgmYA1YC73
 8RgZjPWSjaA/Ku55nIyVNQGNdolaf9ubgT3+Ud7a8JFCI/CxWhMXoTTqQ/SV1GyckFJD
 I5ofNwN+LCKXMoOsAp1QQOFIvc8hWrfMnLgktHnxwQhN0jjHINwKH/kYOJzF7xc6Al8f PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6eru0x9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 19:25:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PIroek027095;
        Thu, 25 Aug 2022 19:25:48 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6eru0x88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 19:25:48 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PJPjRO032139;
        Thu, 25 Aug 2022 19:25:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3j2pvjd0eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 19:25:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PJMdsR41877944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 19:22:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 472C84203F;
        Thu, 25 Aug 2022 19:25:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA22542041;
        Thu, 25 Aug 2022 19:25:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 19:25:41 +0000 (GMT)
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
Subject: [PATCH v2] KVM: s390: Pass initialized arg even if unused
Date:   Thu, 25 Aug 2022 21:25:40 +0200
Message-Id: <20220825192540.1560559-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cuor3FcKdD9FidWx1jsX30Ex4_9f06ZP
X-Proofpoint-GUID: eR82-M8gQ6pn8gjdpVMUKffmIcbKYz3-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250073
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
v1 -> v2
 * drop unlikely, WARN_ON_ONCE instead of WARN (thanks Heiko)

 arch/s390/kvm/gaccess.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 082ec5f2c3a5..0243b6e38d36 100644
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
@@ -504,6 +506,10 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
+		case PROT_NONE:
+			/* We should never get here, acts like termination */
+			WARN_ON_ONCE(1);
+			break;
 		case PROT_TYPE_IEP:
 			tec->b61 = 1;
 			fallthrough;
@@ -968,8 +974,10 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
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
@@ -1112,8 +1120,6 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		if (rc == PGM_PROTECTION && try_storage_prot_override)
 			rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
 							data, fragment_len, PAGE_SPO_ACC);
-		if (rc == PGM_PROTECTION)
-			prot = PROT_TYPE_KEYC;
 		if (rc)
 			break;
 		len -= fragment_len;
@@ -1123,6 +1129,10 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
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

