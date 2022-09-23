Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173305E7A3B
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 14:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiIWMKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 08:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiIWMIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 08:08:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CE31CFD3;
        Fri, 23 Sep 2022 05:04:39 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NARM8U010663;
        Fri, 23 Sep 2022 12:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pVhb+/hRQCFI3WeJTb62FCQqGsIpKtRH0G5H2vvYADE=;
 b=abwQhiaVkyG19xCPPsDoyDtU7tYrg2lO+D/Bzs7MHeA9kPs81LvvipkG3B4K8HDma7I/
 0MEy2P8n5Cgtp3nOaMyE1Gm4leDuKJUmToMRbbvAWD5ONMMHHlB+Mbf9SZehtMdpEShT
 jXYVhCBshJT8qsax/b+WiVR4sGjSK+AIyzA39SQ0LNWyQqzbW+zErbaxNwK9BDAvN33U
 migF9cxzkNrkJRiyU+/FhhdmEaB+aJxI+X++25FidZw8MI6PiyuknBXgvodUNd6Gz05O
 pi7ePmprc20TxLJYBli2oANot71iGcJ9m6WV6jztu+G+FFAtqSfrV9TIM7TpVTZdwTaG JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsb29jmqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:39 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NBU8st020762;
        Fri, 23 Sep 2022 12:04:39 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsb29jmpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NBp9xE027741;
        Fri, 23 Sep 2022 12:04:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3jn5gj7wa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NC4Xxx19333622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:04:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61F1DAE053;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05EB3AE045;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.171.28.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 2/4] KVM: s390: Pass initialized arg even if unused
Date:   Fri, 23 Sep 2022 14:04:10 +0200
Message-Id: <20220923120412.15294-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220923120412.15294-1-frankja@linux.ibm.com>
References: <20220923120412.15294-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G2MAH8v-ruQAefo--DvoJQJTM6uFqzCv
X-Proofpoint-GUID: OpwKad3tYLd8gxN4CqyOGpmiO2zUbpTr
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

This silences smatch warnings reported by kbuild bot:
arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.

This is because it cannot tell that the value is not used in this case.
The trans_exc* only examine prot if code is PGM_PROTECTION.
Pass a dummy value for other codes.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220825192540.1560559-1-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
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
2.37.3

