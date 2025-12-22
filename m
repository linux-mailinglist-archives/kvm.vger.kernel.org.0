Return-Path: <kvm+bounces-66509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F0CCD6D14
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6CE230B8720
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B0C34B1A4;
	Mon, 22 Dec 2025 16:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Umtb0YPe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040513469E0;
	Mon, 22 Dec 2025 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422283; cv=none; b=GccEyvkLDcTwuHQH8LO+PBQgAcg+Sv4FtLkD9CiXbTlRKUdvlQzGjv3k1c6dVPNpqWEcJ/Up/6c7UF+IIz6kPCWNhCPuu10PoNsDPa19cdYpNLanBM71gXVbSFIvhe/5uNihSZ39jN/4HiI4AdcfMS0u5HveVXqNmYc6L0TZths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422283; c=relaxed/simple;
	bh=T68P+rnQ020PCR3fNqrx8Lh6890n9g1whPkTkJKScmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es6wknB4DYv6/I/9WJcdZkVwX7dZNFevrHwVNuSSPmj40aTvq2ZqHLiD6KtYYqWzFlXtv+iSeDdtIin4PzFuXL2qfyjcA7KICbvIbIxJfHVqD6qEcXLCRaZl20Ax2L/14eyCUNralb3392DsiXESTaJWqUYSKEWzid5nYWXNwpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Umtb0YPe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM8fcAs031160;
	Mon, 22 Dec 2025 16:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ViOSbuufnWoJvrGWC
	fh0mRrQWpiPPBsxQRcz9iVD7c8=; b=Umtb0YPeqQldbwislS5wkDPe9S7pqYtbf
	t5pQ+LWDS/fvmi49kibZNO+9HBun5GdaSS9qOb2t54uRewOtlgMiHNEd6qXn1xDk
	mMdN20hRDcNrJACH8a1yM1fYayBxy5v6UmOlYnVMG4fzoBSkHoMtI2XfravdaUVa
	T5PY9GT3ECZoeAtx3iETZMtddGmJUfcLejX8cKyjZz/ko7DANDGisXehGrZ9geKV
	O6sPsxuQj1/UCyUrjlz/UHSVUyOIQqPzXUxP4XIeZWdMCSmJ+y6e4+52anYkCYD8
	waVZvU1nes/TmwOYYuLxvcjjl8ugyni/4gOL9Czweft8Xs6wTFm6Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5j7e111w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGOJt1004192;
	Mon, 22 Dec 2025 16:51:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b674mq5ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGpCYt49414516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:51:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC96720040;
	Mon, 22 Dec 2025 16:51:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D69520043;
	Mon, 22 Dec 2025 16:51:11 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:51:11 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 28/28] KVM: s390: Storage key manipulation IOCTL
Date: Mon, 22 Dec 2025 17:50:33 +0100
Message-ID: <20251222165033.162329-29-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G8YR0tk5 c=1 sm=1 tr=0 ts=69497705 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=TEVnKxO-3nxHHAUriJcA:9
X-Proofpoint-ORIG-GUID: 0eI9X2pfM2y9RhlzAMbxUBQWQkb7eZJd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX2m/mrmlkwUsL
 77piuO0M4V4JjDvSAvRVMVhHHjSG8LkhiFJ5AkubRYuOeKoXVHr2zcermJ9Tfx424r9KLCwlAdV
 vzVFvI1NjeMAxqpz+rh8R46oTe0ISxzYPluoQKzf+2+mgDMsW8Jrl6R5KSvy3E7UnjCnW7r6bC9
 tNZp/IhRRgHJvahypWAjKiajlqrFIkPYq9dChBMi8hwAKP/JYpW2XJgQammT93RKtnyNiZ7nwbD
 Ydioyg6pnoebmvucy51aiLyO23Lotmbzb+DMv0BuKGdsGZRpTuhFAvKYcbTJ88fDZXR18mwpI/D
 2Sy6IO+Ero/Al7PW/MS4pom3BrIdrFwHADfK3G+pJ4yjq9oBZ9H3TmcWyEyu/oeZWbvxdC6pKFq
 tJEWSLWqynHw2ekuuJvwInsrbzeMhRDALH21he6ddEL6vYcyeGE3o4rC2a0man49/Ymzu/Oipi5
 pJVq+/ws+RJzA7K+4rQ==
X-Proofpoint-GUID: 0eI9X2pfM2y9RhlzAMbxUBQWQkb7eZJd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

Add a new IOCTL to allow userspace to manipulate storage keys directly.

This will make it easier to write selftests related to storage keys.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 57 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 10 +++++++
 2 files changed, 67 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 47f2794af2fb..7f28b556b460 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -554,6 +554,37 @@ static void __kvm_s390_exit(void)
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
@@ -2931,6 +2962,32 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
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
index dddb781b0507..845417e56778 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1219,6 +1219,15 @@ struct kvm_vfio_spapr_tce {
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
@@ -1238,6 +1247,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
+#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyop)
 
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
-- 
2.52.0


