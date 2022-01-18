Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568AB492328
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiARJwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54906 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234293AbiARJwb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:31 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8Qrp1030489;
        Tue, 18 Jan 2022 09:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AZX9eCJ2wdSumSIdHcSVTbUMTdpS/XPwpJECKOdxoB4=;
 b=MuQVWA9/YyvwwzCDc5Fd17ibBF/bk8xfF81bsGu/kQw9WHCrimAUzhuTQ1NuhTEICl7S
 ibbeNYxBZSbvDcHuviFxg4px97IqsMoweboYXYNRqdNggV6KuSaAkEVCy+slV8y/nC4F
 YmMm6RNyiSZKUAcH+qcegtybDFDD4RvKYvvFnnUMwUSBW+XXVIhYwTOQEYs1w2/evToR
 uJIUMoORf2yer88e8CyoKu1oZeThoTIGvbX7xTEQ+p6jcmmUySYoAQdsjLNWx9bcjytA
 ghfXyq7SiCsintdz7ya94h/4tk5sxdLsWJZc32KgQHbBoHH1+1KMC1Q/bFRrqGfeyNmG 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnq02e6yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:29 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9hRqx024929;
        Tue, 18 Jan 2022 09:52:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnq02e6xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9fa6P016972;
        Tue, 18 Jan 2022 09:52:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw92mtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9h7UW49611032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:43:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB3F6A4057;
        Tue, 18 Jan 2022 09:52:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83392A404D;
        Tue, 18 Jan 2022 09:52:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:23 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 05/10] KVM: s390: Add optional storage key checking to MEMOP IOCTL
Date:   Tue, 18 Jan 2022 10:52:05 +0100
Message-Id: <20220118095210.1651483-6-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FxmPA4iVZMT21ERfp8ml3TfYl_SRpTP9
X-Proofpoint-GUID: qL0gQOj34mUI9auTdEGx1oFYdCxk0fkg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

User space needs a mechanism to perform key checked accesses when
emulating instructions.

The key can be passed as an additional argument via the flags field.
As reserved flags need to be 0, and key 0 matches all storage keys,
by default no key checking is performed, as before.
Having an additional argument is flexible, as user space can
pass the guest PSW's key, in order to make an access the same way the
CPU would, or pass another key if necessary.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 38b304e81c57..c4acdb025ff1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -32,6 +32,7 @@
 #include <linux/sched/signal.h>
 #include <linux/string.h>
 #include <linux/pgtable.h>
+#include <linux/bitfield.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
@@ -4727,9 +4728,11 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void *tmpbuf = NULL;
+	char access_key = 0;
 	int r = 0;
 	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
-				    | KVM_S390_MEMOP_F_CHECK_ONLY;
+				    | KVM_S390_MEMOP_F_CHECK_ONLY
+				    | KVM_S390_MEMOP_F_SKEYS_ACC;
 
 	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
 		return -EINVAL;
@@ -4746,14 +4749,17 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 			return -ENOMEM;
 	}
 
+	access_key = FIELD_GET(KVM_S390_MEMOP_F_SKEYS_ACC, mop->flags);
+
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_FETCH, 0);
+			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
+					    GACC_FETCH, access_key);
 			break;
 		}
-		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
+		r = read_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
+					mop->size, access_key);
 		if (r == 0) {
 			if (copy_to_user(uaddr, tmpbuf, mop->size))
 				r = -EFAULT;
@@ -4761,15 +4767,16 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
-			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
-					    mop->size, GACC_STORE, 0);
+			r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
+					    GACC_STORE, access_key);
 			break;
 		}
 		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
 			r = -EFAULT;
 			break;
 		}
-		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
+		r = write_guest_with_key(vcpu, mop->gaddr, mop->ar, tmpbuf,
+					 mop->size, access_key);
 		break;
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..e3f450b2f346 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -575,6 +575,7 @@ struct kvm_s390_mem_op {
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEYS_ACC		0x0f00ULL
 
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
-- 
2.32.0

