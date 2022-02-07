Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7D34AC700
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346143AbiBGROS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357942AbiBGRAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:00:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFEAC0401DF;
        Mon,  7 Feb 2022 09:00:10 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxXVj005809;
        Mon, 7 Feb 2022 17:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v0k2Fn83Q9jwPu2f5J44ZhN//xaqGG7q6985B3Mjp0M=;
 b=F2BWRwMAtWrV75d+wSWxOc9Sizbhl6fdVYJ/bO+lQSSNtdoaR1C1sQJU/5JQONe8hdHI
 TWnolaikPUqiCptSc+Ev3o9mvuTbQqWO2dn6VRlLkuw5ehnavKFjEOILmx6rKhPAbLDE
 y9C1YjacLEuCtEVG+IQygKs7S/zOR95bCFOGixJvZV3nXJeqVFkxIYaYPmlD1vN/B2LH
 OZEZqGDdjPdbSvYFNH00y0M5ZiPblRSU6YL4ZC1AijajKQ4tsm91uVxdFyb7ygnOAaOO
 WAgLJKm04L70Wjwu7KnCT0KVsDDErNFYoU5CPJUGBGRx2KdFcaTtTRWh1c4UeekrXWxy jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kq2507-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:08 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217H07jC008593;
        Mon, 7 Feb 2022 17:00:07 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kq24xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:07 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217GqWLc006978;
        Mon, 7 Feb 2022 17:00:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygpvwfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217GnxsC27656502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 16:49:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F18EA404D;
        Mon,  7 Feb 2022 17:00:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A52A2A406D;
        Mon,  7 Feb 2022 17:00:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 17:00:01 +0000 (GMT)
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
Subject: [PATCH v2 05/11] KVM: s390: Add optional storage key checking to MEMOP IOCTL
Date:   Mon,  7 Feb 2022 17:59:24 +0100
Message-Id: <20220207165930.1608621-6-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207165930.1608621-1-scgl@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V8SwZ-5yEPJvola0t1EHqbHZDiy2FcYN
X-Proofpoint-ORIG-GUID: pIzfdm8ewaG83g4kesIysorSUuJ9twrw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070103
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
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 49 +++++++++++++++++++++++++++++++---------
 include/uapi/linux/kvm.h |  8 +++++--
 2 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cf347e1a4f17..71e61fb3f0d9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -32,6 +32,7 @@
 #include <linux/sched/signal.h>
 #include <linux/string.h>
 #include <linux/pgtable.h>
+#include <linux/bitfield.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
@@ -2359,6 +2360,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
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
@@ -4687,34 +4693,54 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
+	u8 access_key = 0, ar = 0;
 	void *tmpbuf = NULL;
+	bool check_reserved;
 	int r = 0;
 	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
-				    | KVM_S390_MEMOP_F_CHECK_ONLY;
+				    | KVM_S390_MEMOP_F_CHECK_ONLY
+				    | KVM_S390_MEMOP_F_SKEY_PROTECTION;
 
-	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
+	if (mop->flags & ~supported_flags || !mop->size)
 		return -EINVAL;
-
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
-
 	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EINVAL;
-
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
 			return -ENOMEM;
 	}
+	ar = mop->ar;
+	mop->ar = 0;
+	if (ar >= NUM_ACRS)
+		return -EINVAL;
+	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
+		access_key = mop->key;
+		mop->key = 0;
+		if (access_key_invalid(access_key))
+			return -EINVAL;
+	}
+	/*
+	 * Check that reserved/unused == 0, but only for extensions,
+	 * so we stay backward compatible.
+	 * This gives us more design flexibility for future extensions, i.e.
+	 * we can add functionality without adding a flag.
+	 */
+	check_reserved = mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION;
+	if (check_reserved && memchr_inv(&mop->reserved, 0, sizeof(mop->reserved)))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_FETCH, 0);
+			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
+					    GACC_FETCH, access_key);
 			break;
 		}
-		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
+		r = read_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
+					mop->size, access_key);
 		if (r == 0) {
 			if (copy_to_user(uaddr, tmpbuf, mop->size))
 				r = -EFAULT;
@@ -4722,15 +4748,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_STORE, 0);
+			r = check_gva_range(vcpu, mop->gaddr, ar, mop->size,
+					    GACC_STORE, access_key);
 			break;
 		}
 		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
 			r = -EFAULT;
 			break;
 		}
-		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
+		r = write_guest_with_key(vcpu, mop->gaddr, ar, tmpbuf,
+					 mop->size, access_key);
 		break;
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b46bcdb0cab1..5771b026fbc0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -562,9 +562,12 @@ struct kvm_s390_mem_op {
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
 	union {
-		__u8 ar;	/* the access register number */
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key to use for storage key protection */
+		};
 		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* should be set to 0 */
+		__u8 reserved[32]; /* must be set to 0 */
 	};
 };
 /* types for kvm_s390_mem_op->op */
@@ -575,6 +578,7 @@ struct kvm_s390_mem_op {
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
 
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
-- 
2.32.0

