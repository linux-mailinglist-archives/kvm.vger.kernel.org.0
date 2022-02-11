Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9654B2CC9
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352636AbiBKSWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:22:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344468AbiBKSW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:22:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0772196;
        Fri, 11 Feb 2022 10:22:26 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BHSiuL017416;
        Fri, 11 Feb 2022 18:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=B3NjpAqJS+7+xYQ3GwJvA+tXJxEEOVApLK2sh4yC31I=;
 b=r/7LyF+XS+uZPmdjAJG082iYSUknTwXlFQSNF8TifqsdqO5m4D0yOggVKNH2PwcYiJ7N
 y/vT8OiOcHtM0JKoFOw9feD2RjwPtB+HWxhHIxyXsLR5ZHQ61HaiHvjyyJXoNMsqjieA
 +1tOBTjjWyvuStVWtUO2SAXBlFjmDVCV5POxBo/c5nyAckFffrMLCguyj0GQ7VBLegOK
 RVQs6iKENMEkfxyXWJ+tJrZpVTbRz/P7+7l3BO2+UghL0g4DJ928aWPBjwVWuB5+lr/k
 C7ITNiB1LgMlp32oZS1lJJvPV0olHMzPGsoMPfPvhNV2fvWH+aGdSWvRdPgOaUM8/cfr 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5v7y91n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BIFcSc003076;
        Fri, 11 Feb 2022 18:22:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5v7y91mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BICJuV020538;
        Fri, 11 Feb 2022 18:22:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gva44dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BIMJXn36569528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 18:22:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABCBD5204E;
        Fri, 11 Feb 2022 18:22:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 428D352054;
        Fri, 11 Feb 2022 18:22:19 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v4 05/10] KVM: s390: Add optional storage key checking to MEMOP IOCTL
Date:   Fri, 11 Feb 2022 19:22:10 +0100
Message-Id: <20220211182215.2730017-6-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-1-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YeDpvl0kUzZjyMZapEtPxvXU1TwduhVy
X-Proofpoint-GUID: gVr-8CH-y3PD_ts-obhMapEgqVp2AJgr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

User space needs a mechanism to perform key checked accesses when
emulating instructions.

The key can be passed as an additional argument.
Having an additional argument is flexible, as user space can
pass the guest PSW's key, in order to make an access the same way the
CPU would, or pass another key if necessary.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 31 +++++++++++++++++++++----------
 include/uapi/linux/kvm.h |  6 +++++-
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index fdbd6c1dc709..c31b40abfa23 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2359,6 +2359,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 	return r;
 }
 
+static bool access_key_invalid(u8 access_key)
+{
+	return access_key > 0xf;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -4692,17 +4697,21 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	void *tmpbuf = NULL;
 	int r = 0;
 	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
-				    | KVM_S390_MEMOP_F_CHECK_ONLY;
+				    | KVM_S390_MEMOP_F_CHECK_ONLY
+				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
 
 	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
 		return -EINVAL;
-
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
-
 	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EINVAL;
-
+	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
+		if (access_key_invalid(mop->key))
+			return -EINVAL;
+	} else {
+		mop->key = 0;
+	}
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
@@ -4712,11 +4721,12 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_FETCH, 0);
+			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
+					    GACC_FETCH, mop->key);
 			break;
 		}
-		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
+		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
+					mop->size, mop->key);
 		if (r == 0) {
 			if (copy_to_user(uaddr, tmpbuf, mop->size))
 				r = -EFAULT;
@@ -4724,15 +4734,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_STORE, 0);
+			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
+					    GACC_STORE, mop->key);
 			break;
 		}
 		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
 			r = -EFAULT;
 			break;
 		}
-		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
+		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
+					 mop->size, mop->key);
 		break;
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..4566f429db2c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -562,7 +562,10 @@ struct kvm_s390_mem_op {
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
 	union {
-		__u8 ar;	/* the access register number */
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key, ignored if flag unset */
+		};
 		__u32 sida_offset; /* offset into the sida */
 		__u8 reserved[32]; /* should be set to 0 */
 	};
@@ -575,6 +578,7 @@ struct kvm_s390_mem_op {
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
 
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
-- 
2.32.0

