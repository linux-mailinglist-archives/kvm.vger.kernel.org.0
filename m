Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86E34AF7B2
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbiBIRFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbiBIREk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C64EC05CB9E;
        Wed,  9 Feb 2022 09:04:36 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219GNEah030888;
        Wed, 9 Feb 2022 17:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EaIzEhhwyxUwe6oaZgV0jcMI1EKt713HDDrbJ3Ue9rE=;
 b=L5qCzhE6u/tUOhgiMLqUULbKkxJQG/xyTVG0MMff8dVhFGDZrCYqwwdDt8GXB0ji/PWR
 xR1zQZuaf8vJmRGZf/VLt9SXq3sgtZXrG7mPb/dGs59xkfODOlwYOuZcHZg7eHW5yM/v
 vYDGmM1xgo/RjNJHTIaU2FQ00lvSZAH6MtjmjX/zn1LXqLcRF7bvA6FPs+mah1E8m884
 R7rpqZlW/Wldx2EISTv3HYKblpwT6JB18uuVZqdu8+8QRPElytC3DnuMMIXMSG972o/3
 v6Dbd9pgJiONH7Gaw8ry4a3b2L5710/g3hAWNlZwglnk1GemKVJN398WNSoMl9Fr3CFg Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4ajkjfhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219Gp1lk018408;
        Wed, 9 Feb 2022 17:04:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e4ajkjfgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:34 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219H3PBT031692;
        Wed, 9 Feb 2022 17:04:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv9gy1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219H4Qqe35586338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 17:04:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C40E4A4054;
        Wed,  9 Feb 2022 17:04:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CBF4A405F;
        Wed,  9 Feb 2022 17:04:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 17:04:26 +0000 (GMT)
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
Subject: [PATCH v3 05/10] KVM: s390: Add optional storage key checking to MEMOP IOCTL
Date:   Wed,  9 Feb 2022 18:04:17 +0100
Message-Id: <20220209170422.1910690-6-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209170422.1910690-1-scgl@linux.ibm.com>
References: <20220209170422.1910690-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lEQOJAqWAf3ec_E8kliBRarBej-UZPBC
X-Proofpoint-GUID: dyBCtYmThax_uBCq72h0i-mfLGDNR-eE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_09,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090091
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
 arch/s390/kvm/kvm-s390.c | 30 ++++++++++++++++++++----------
 include/uapi/linux/kvm.h |  6 +++++-
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cf347e1a4f17..85763ec7bc60 100644
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
@@ -4690,17 +4696,19 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
+	}
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
@@ -4710,11 +4718,12 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
@@ -4722,15 +4731,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
index b46bcdb0cab1..44558cf4c52e 100644
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

