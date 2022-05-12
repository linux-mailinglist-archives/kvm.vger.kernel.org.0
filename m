Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7C2524DDF
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354186AbiELNKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354188AbiELNKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:10:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803C24F223;
        Thu, 12 May 2022 06:10:32 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CC1wOV004224;
        Thu, 12 May 2022 13:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IsYIoKJ9cEQwxoyHMoaEW3qJ9wQum8a1pqagyIatf7I=;
 b=bY1XzxCjtTHN1lAuSJpR3dW07pLQKYr849yu8TzHRiUMGcBA1DrybVJWzKQ7F/Yv7m4C
 mKX6L3VNiQlMhWhk2VXYpKS0hIaxbw+JcMFKwDwe7BPwfUYFbMKYZXo++v/lIks8gO/U
 eMTTAVtOmykk50SjXm6yAKg7ZXrUSC0sbw+8VobuHlDl7gWVBAUceqnYTEe52phI0IJv
 eH64gnahYACOxZUb292EX/x4a9EukgQJD0MEsQgyyIUQBMDGEFU3dPtu6CtmY4459Fap
 dPe6lWXkjxl3CvF+1+eeklOVyqW/VrpsIGYzX1nu2WMoS2upyzDsDEKRZdn1T16g0vOK zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11vr1r10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:10:32 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CC244p004665;
        Thu, 12 May 2022 13:10:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11vr1qys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:10:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CD3Uki028511;
        Thu, 12 May 2022 13:10:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3g0kn78w47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:10:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CDAP8m33685908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 13:10:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4999AE056;
        Thu, 12 May 2022 13:10:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E228AE04D;
        Thu, 12 May 2022 13:10:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 13:10:25 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: s390: Don't indicate suppression on dirtying, failing memop
Date:   Thu, 12 May 2022 15:10:17 +0200
Message-Id: <20220512131019.2594948-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220512131019.2594948-1-scgl@linux.ibm.com>
References: <20220512131019.2594948-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: asT-5bzCxO9EBOVJOeKQGHprEUJo7oOo
X-Proofpoint-ORIG-GUID: tjNBglsIc9n5_qBUmZsHAqdhal8jxyRU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_10,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 spamscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205120061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If user space uses a memop to emulate an instruction and that
memop fails, the execution of the instruction ends.
Instruction execution can end in different ways, one of which is
suppression, which requires that the instruction execute like a no-op.
A writing memop that spans multiple pages and fails due to key
protection may have modified guest memory, as a result, the likely
correct ending is termination. Therefore, do not indicate a
suppressing instruction ending in this case.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/s390/kvm/gaccess.c        | 22 ++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a900cdbc62e..b6aba4f50db7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3754,12 +3754,18 @@ in case of KVM_S390_MEMOP_F_CHECK_ONLY), the ioctl returns a positive
 error number indicating the type of exception. This exception is also
 raised directly at the corresponding VCPU if the flag
 KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
+On protection exceptions, unless specified otherwise, the injected
+translation-exception identifier (TEID) indicates suppression.
 
 If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
 protection is also in effect and may cause exceptions if accesses are
 prohibited given the access key designated by "key"; the valid range is 0..15.
 KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
 is > 0.
+Since the accessed memory may span multiple pages and those pages might have
+different storage keys, it is possible that a protection exception occurs
+after memory has been modified. In this case, if the exception is injected,
+the TEID does not indicate suppression.
 
 Absolute read/write:
 ^^^^^^^^^^^^^^^^^^^^
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index d53a183c2005..227ed0009354 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -491,8 +491,8 @@ enum prot_type {
 	PROT_TYPE_IEP  = 4,
 };
 
-static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
-		     u8 ar, enum gacc_mode mode, enum prot_type prot)
+static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
+			    enum gacc_mode mode, enum prot_type prot, bool terminate)
 {
 	struct kvm_s390_pgm_info *pgm = &vcpu->arch.pgm;
 	struct trans_exc_code_bits *tec;
@@ -520,6 +520,11 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 			tec->b61 = 1;
 			break;
 		}
+		if (terminate) {
+			tec->b56 = 0;
+			tec->b60 = 0;
+			tec->b61 = 0;
+		}
 		fallthrough;
 	case PGM_ASCE_TYPE:
 	case PGM_PAGE_TRANSLATION:
@@ -552,6 +557,12 @@ static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 	return code;
 }
 
+static int trans_exc(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
+		     enum gacc_mode mode, enum prot_type prot)
+{
+	return trans_exc_ending(vcpu, code, gva, ar, mode, prot, false);
+}
+
 static int get_vcpu_asce(struct kvm_vcpu *vcpu, union asce *asce,
 			 unsigned long ga, u8 ar, enum gacc_mode mode)
 {
@@ -1109,8 +1120,11 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		data += fragment_len;
 		ga = kvm_s390_logical_to_effective(vcpu, ga + fragment_len);
 	}
-	if (rc > 0)
-		rc = trans_exc(vcpu, rc, ga, ar, mode, prot);
+	if (rc > 0) {
+		bool terminate = (mode == GACC_STORE) && (idx > 0);
+
+		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
+	}
 out_unlock:
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
-- 
2.32.0

