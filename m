Return-Path: <kvm+bounces-64374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5167BC80553
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 87EDA341ECE
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F61C30ACEC;
	Mon, 24 Nov 2025 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LME4GwW6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73511301027;
	Mon, 24 Nov 2025 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985410; cv=none; b=rnS7R27pchYVOSjCDqBALcC1ikoPYsYR3lbgzBpR2N3fkii6LISqrJCVq0EJMX0BC+lfoUfItuJ53gjrPjJriAmV0L39ZXDRiYO6rrfz7eALi7CwXysAo88QRKvDcrkFCbXKuPs4uTL00YZYZXFw5cqEmyPtiW9y7lgcy6AGrAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985410; c=relaxed/simple;
	bh=4CKFDj0hIhd8M0Kkg3C6sDxhR4ruHQPfY+uymnjUbIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrD2wdqB+2bA6WgphMQNijxpJA5i4mh67lmMjh810nVbMeqIJxvvUD4/uIUUdrFjB7bGibLUwZUWsxuP1/EawGPO2Hol1Ocg2PDdcVXnJSm6bOIOq7adoyg1CIDxEU88K6FxtFWB+n7x9/pYpOrWEShZpV2pzpN9VLUV2yJMyTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LME4GwW6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO74GXG030018;
	Mon, 24 Nov 2025 11:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JBtmXcIba2fi4czF9
	3NATfwa4x8dAL704MEsd0327Tg=; b=LME4GwW6Sdi2WHJbyaZX0FVzejqwTyOr2
	mc3VjP1gTdG0POSVLvVkrPk0rMMnPhvpP/O46ZKm8VG+sdNuSKNMGMiYaKOH5yWt
	bDKBAl/wgzWfy4gXWDL4LgHeGxDrl7Nltwgzba7s54Pzo76rOBVmdmpJTmY+6MQw
	IqazQxtO0s8hkztbCPTTPnrXkiT7o23zMG71vlm89kyY1nRy+Kgm0nS9tDErZ9jR
	W86Yi4F0QmGfiYmcPkPyKLzKNqRu/zVRQaqyf4HcAm6Z6tVfhZaory+CTf1I3oLw
	TpkdZjFI4Mk0QPtH3Or4409CAcKgniA0RLhLREsOCWB4ia34kW9Uw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uuywwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOBoNFh019002;
	Mon, 24 Nov 2025 11:56:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aksqjdg6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:44 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBufYZ60752372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4344820040;
	Mon, 24 Nov 2025 11:56:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C863020043;
	Mon, 24 Nov 2025 11:56:39 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 23/23] KVM: s390: Storage key manipulation IOCTL
Date: Mon, 24 Nov 2025 12:55:54 +0100
Message-ID: <20251124115554.27049-24-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX82mj0qypoptu
 +aprt+KzxaXW86mQutFJ4m7SGxekQNPMGeMj50zlFqOL+6TY1n/+t5SJ1JLP4wttul1dSNpRf2A
 tRhqSNfMwXrQC0TLpe9uXYy9Rx7JDlB+1s8s8UNlO6GO2KlFBXnJV0r/+W1JTDIVmcJ6mXzvd0r
 4fMDkK79IKWpBAdYNLRsbkTS4KALES9/xlfEgmqTpoJ3tvFRE+cX4A/gi5mtM4NlDJ3RfGj7tTb
 maGfnw2o1QXkE6G6BdU2oQ+ifRfURTT0vnhOWVQ0PoY4r0KxhcwfaBagqoEjUnLKxurnlIPCjC1
 qEsuGEnaz8fhHXEkj0bg5s7qNz6sunlXW5Xd/kqrl7t7T+BG75KvUnVmMmWF3+yPncfJAtVoONB
 WjkTN/r2Pg4hfCKlC37gFvjaFZEhxA==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=692447fd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=TEVnKxO-3nxHHAUriJcA:9
X-Proofpoint-ORIG-GUID: i1GTqE48D6lTcHTHQeA0AkqdEpHlCTed
X-Proofpoint-GUID: i1GTqE48D6lTcHTHQeA0AkqdEpHlCTed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

Add a new IOCTL to allow userspace to manipulate storage keys directly.

This will make it easier to write selftests related to storage keys.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 57 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 10 +++++++
 2 files changed, 67 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b7dc1d601fb8..e8e3c8cf75fa 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -555,6 +555,37 @@ static void __kvm_s390_exit(void)
 	debug_unregister(kvm_s390_dbf_uv);
 }
 
+static int kvm_s390_keyop(struct kvm_s390_mmu_cache *mc, struct kvm *kvm, int op,
+			  unsigned long addr, union skey skey)
+{
+	union asce asce = kvm->arch.gmap->asce;
+	gfn_t gfn = gpa_to_gfn(addr);
+	int r;
+
+	guard(read_lock)(&kvm->mmu_lock);
+
+	switch (op) {
+	case KVM_S390_KEYOP_SSKE:
+		r = dat_cond_set_storage_key(mc, asce, gfn, skey, &skey, 0, 0, 0);
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
@@ -2930,6 +2961,32 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 			r = -EFAULT;
 		break;
 	}
+	case KVM_S390_KEYOP: {
+		struct kvm_s390_mmu_cache *mc;
+		struct kvm_s390_keyop kop;
+		union skey skey;
+
+		if (copy_from_user(&kop, argp, sizeof(kop))) {
+			r = -EFAULT;
+			break;
+		}
+		skey.skey = kop.key;
+
+		mc = kvm_s390_new_mmu_cache();
+		if (!mc)
+			return -ENOMEM;
+
+		r = kvm_s390_keyop(mc, kvm, kop.operation, kop.user_addr, skey);
+		kvm_s390_free_mmu_cache(mc);
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
index 52f6000ab020..402098d20134 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1208,6 +1208,15 @@ struct kvm_vfio_spapr_tce {
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
@@ -1227,6 +1236,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
+#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyop)
 
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
-- 
2.51.1


