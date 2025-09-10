Return-Path: <kvm+bounces-57233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F26B51FDD
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94B82483FE0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A33343205;
	Wed, 10 Sep 2025 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WR3K1CH4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE50341AC4;
	Wed, 10 Sep 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527681; cv=none; b=mZ7Hhu5/11R6VFmr6uSJ0ZEzTTf/dOKjoKnQHzsYHLYxF4tpPQk3nbahvzoyxnSPsKio5XwNqteQQtLlyTtdWQjSKUwv8uYolk61x9fvRHAP/PN1lyiR3X1B1Su4cwjGvMeQFANTu84JAnu030YY7vO3kmMdCZS/LRvqj5etJ4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527681; c=relaxed/simple;
	bh=HEqeVFJ1Zph/3GIhmizpLYkFvLvXxfiKzX+//nw+++Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCLP9BKrcX90zuYgULtYHZsxD45sj9utFuAiqjBn1MK1RH8UtvGpTbxIdtntWFGqZmRKWfi4yMQoysLM/tbFT8HJ12MaL/R4jM6R7zN6wNpBj+M0Hfn31Q1UIL7el7HqybtY9BY/pSdXBA2zNMFu5GlyJKC+m1qxBUmUmicU6nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WR3K1CH4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AHt0m5001261;
	Wed, 10 Sep 2025 18:07:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FrhqFHApu9yb43i+a
	hMifZfegeDB5yeRK76+NGjyB1c=; b=WR3K1CH41QHsBx+5bckhVZ86QHQ/BX7x7
	cG/48iQOAODfix4P+MufvMi2D/HI4rlp7okIcfqTDLL6U+Q8ija+RCiom7zqKX/6
	fEU0Q1vLb131YmjYdeDBioDBX1mZEpcoec82e+57BbprHJEuK99xIZZxUN6WkPiy
	35THa8msZ2mvaywn7cL6WuwwSizRgSFQgcbdC/NULpyeRCnCt6NnUjmiu9D08EvA
	TLE7c7P1P12Fwy+Iv2HJS1lLPBjF7CC4WD23+gtxHxdi0jDUk016lVLMqKQYSRL1
	vtA5z9zruX6ISjGZ12C95BVEclfsatVKfoJ2UpGpmVOFQ7bBsdgKA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx015p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AHBI1f010605;
	Wed, 10 Sep 2025 18:07:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn1t21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7qYC53084516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D36620040;
	Wed, 10 Sep 2025 18:07:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 175722004B;
	Wed, 10 Sep 2025 18:07:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 20/20] KVM: s390: Storage key manipulation IOCTL
Date: Wed, 10 Sep 2025 20:07:46 +0200
Message-ID: <20250910180746.125776-21-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910180746.125776-1-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yTBOi2w6-saZsPvlIYpciuEMVRaaH-L5
X-Proofpoint-ORIG-GUID: yTBOi2w6-saZsPvlIYpciuEMVRaaH-L5
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c1be7d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=N5kM_U_PssS2alYBWGgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfXznsD7U4ks5k2
 C8AJkLlGbLayD1wDTvA/5nmxw/587kcm6LfX+Us5mQ3hWvBSPCR9NCcuTyxjHhi4Do7EF43mzuI
 xhRHdjl9+qWqdu9XzwFN/cAdJkbMq13nI+B+lftvVb6nm6XVo0gYH/EZHOhTWb3N+Dj2Z+qF7z0
 8fdNYYlKuD9CPCjBozsla7tqgzSdtZEGV+RpWBbLrG2IcYnxZuS4c9pZ1h4mH/sMunT2DY6ijoh
 pHWs0UzQ5/bgK7+MkSizBpjUyR/vAsWw1ioVzhxpa/bjLzknHPC+2XmTsyCmv7Xb/+jAUdTWn6I
 O/gJbb/LOdSHxOAhnJmROMCqn1HxzqsxtpfF5iPlpzbAz/eZDuN0kwvgW0i1ncGKFMSZVeXluEu
 WcsTsmck
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

Add a new IOCTL to allow userspace to manipulate storage keys directly.

This will make it easier to write selftests related to storage keys.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 48 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 10 +++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 52b1709f0423..daf34b668aa8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -553,6 +553,34 @@ static void __kvm_s390_exit(void)
 	debug_unregister(kvm_s390_dbf_uv);
 }
 
+static int kvm_s390_keyop(struct kvm *kvm, int op, unsigned long addr, union skey skey)
+{
+	union asce asce = kvm->arch.gmap->asce;
+	gfn_t gfn = gpa_to_gfn(addr);
+	int r;
+
+	switch (op) {
+	case KVM_S390_KEYOP_SSKE:
+		r = dat_cond_set_storage_key(asce, gfn, skey, &skey, 0, 0, 0);
+		if (r >= 0)
+			return skey.skey;
+		break;
+	case KVM_S390_KEYOP_ISKE:
+		r = dat_get_storage_key(asce, gfn, &skey);
+		if (!r)
+			return skey.skey;
+		break;
+	case KVM_S390_KEYOP_RRBE:
+		r = dat_reset_reference_bit(asce, gfn);
+		if (r > 0)
+			return r << 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return r;
+}
+
 /* Section: device related */
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
@@ -2929,6 +2957,26 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			r = -EFAULT;
 		break;
 	}
+	case KVM_S390_KEYOP: {
+		struct kvm_s390_keyop kop;
+		union skey skey;
+
+		if (copy_from_user(&kop, argp, sizeof(kop))) {
+			r = -EFAULT;
+			break;
+		}
+		skey.skey = kop.key;
+
+		r = kvm_s390_keyop(kvm, kop.operation, kop.user_addr, skey);
+		if (r < 0)
+			break;
+
+		kop.key = r;
+		r = 0;
+		if (copy_to_user(argp, &kop, sizeof(kop)))
+			r = -EFAULT;
+		break;
+	}
 	case KVM_S390_ZPCI_OP: {
 		struct kvm_s390_zpci_op args;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7a4c35ff03fe..ac4b72924934 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1205,6 +1205,15 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
+#define KVM_S390_KEYOP_SSKE 0x01
+#define KVM_S390_KEYOP_ISKE 0x02
+#define KVM_S390_KEYOP_RRBE 0x03
+struct kvm_s390_keyop {
+	__u64 user_addr;
+	__u8  key;
+	__u8  operation;
+};
+
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
@@ -1224,6 +1233,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
+#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyop)
 
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
-- 
2.51.0


