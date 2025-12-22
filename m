Return-Path: <kvm+bounces-66492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB1ECD6CCB
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:21:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F24BD30146D7
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C95E33DEFA;
	Mon, 22 Dec 2025 16:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nNlsQfvd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1ED33B6CF;
	Mon, 22 Dec 2025 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422258; cv=none; b=fmgMKl4U9imxY+cSyCNPQYEY//fS0zqezi6XL00C2QcEv47udfeE0xY6ScQYo+n8JCRNzxgOBSMHcCx1dLEzi7UjoBCZAGVyUY/yTSOBB/CcfPfsZNRVmOQLYluhKQUsE9rUgyK3i4QRtQ8Jjix8f2t8vom8JuA3+e/3hcOAlo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422258; c=relaxed/simple;
	bh=8UkpGTWwtwpBCmzbEuC+cxDdvga6PTHi3Kdv9DBkpd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lsg1z/LSdj8JEYQmZIzxB3bHifjUVQ/adJWqcaFb/LhK5Fu+v/ayfCawOrCc2LPQgu0kCPP9pOZbAjWzRdRM3xNKB+bS/3wRLOrLnovozGGeBrXp7VTCdsNGWDC9EwpWdwDXwRKwD/gX1twRqz5eRpDegTfZPPodQPJDfizaGCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nNlsQfvd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMB2l0t009244;
	Mon, 22 Dec 2025 16:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lwTngDyaNYF1vtCdZ
	/G6YT4Oibj8h9KDMYrxj6jl/Wg=; b=nNlsQfvde9MPOjFBvN4aCqAzYS32thaR9
	zA61zTvCcXcYTAFK/xT81VPmt8abuFFfVBMEivQL+3iO6ohyfh8q8wNGJlqkK5/4
	MLAF5u//BgrlOqye8PcPkfllAFg7E756m5SLkciSNI21pY4lRXYatxAV3lg7xQ/j
	ePX5S1BS+wFnL/G7dO0A+BXZ9ErV6Mvg1+sddpeBRbG4B/xURZsk0N6voBx6YoLL
	0I7vnPqcPp6cB7jPdPPJ187834YslqHq8cZhI/041tkhhWet5lGexUs4y+eVJ0p9
	MpAC8d69z0JEGu7IkDAvuvTCneNIQnB+KGj0RuPUulTEiSdBmJB6A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh4969g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGWSRN005259;
	Mon, 22 Dec 2025 16:50:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b67mjy3j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:52 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGomkM51183874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:48 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A85420043;
	Mon, 22 Dec 2025 16:50:48 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FFB120040;
	Mon, 22 Dec 2025 16:50:47 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:47 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 10/28] KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
Date: Mon, 22 Dec 2025 17:50:15 +0100
Message-ID: <20251222165033.162329-11-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=bulBxUai c=1 sm=1 tr=0 ts=694976ed cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=sWpJ-_il0aw9mM0vlR0A:9
X-Proofpoint-ORIG-GUID: gQx8teKQmE3nWEQf_ZXii7oWBRcHvmt9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX9rpQV49u2xtt
 slI8cPukGjdUTfK7XZeX7TRdHDEDYeqRG9C03BVIK9D+xS7baFD9zdTrw/k4JAQjtzyFRYnzTGy
 Czxd2BpDYZ5Iw+bXrEGt/wEftwt03S3VW5P6OArLESxEWQ7Kswxn96elRyKGSxjJMQh8N5TlWxJ
 13oTe+BD2eQn5X0sRNxvcMZfIkoWo2qDUi67E8azUhN3xIgNsvrW09U45JiJrkYzZOuWl4i2gi5
 r186DbaTjNFk07cE6l7OAqwY+oqcEu1GyGf2vnqeq7Ud6CkP7zQ7Q5zy+khEIYOIfBIjZp6Q9Qw
 RkPzkkeMOauxPj7Fgxit+99AM2NVdEYZkPH6LG9+6q70yu3zPRpWWM9oAV/nidB7/yHdkSP0A4f
 T48SY8v90kLxd8pRMnd6KEbZ3u/hTYfVMTPAcpb8mr0vCifpGoINefU+f6e5CY5Ei7kXfujInGl
 GR/k7pl2nq+jGQ20uNw==
X-Proofpoint-GUID: gQx8teKQmE3nWEQf_ZXii7oWBRcHvmt9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

Enable KVM_GENERIC_MMU_NOTIFIER, for now with empty placeholder callbacks.

Also enable KVM_MMU_LOCKLESS_AGING and define KVM_HAVE_MMU_RWLOCK.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/Kconfig            |  2 ++
 arch/s390/kvm/kvm-s390.c         | 45 +++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3dbddb7c60a9..6ba99870fc32 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/isc.h>
 #include <asm/guarded_storage.h>
 
+#define KVM_HAVE_MMU_RWLOCK
 #define KVM_MAX_VCPUS 255
 
 #define KVM_INTERNAL_MEM_SLOTS 1
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index f4ec8c1ce214..917ac740513e 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -30,6 +30,8 @@ config KVM
 	select KVM_VFIO
 	select MMU_NOTIFIER
 	select VIRT_XFER_TO_GUEST_WORK
+	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMU_LOCKLESS_AGING
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cd39b2f099ca..ec92e6361eab 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4805,7 +4805,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
 	if (!rc)
 		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
-	scoped_guard(spinlock, &vcpu->kvm->mmu_lock) {
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
 		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
 	}
 	mmap_read_unlock(vcpu->arch.gmap->mm);
@@ -6021,6 +6021,49 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	return;
 }
 
+/**
+ * kvm_test_age_gfn() - test young
+ * @kvm: the kvm instance
+ * @range: the range of guest addresses whose young status needs to be cleared
+ *
+ * Context: called by KVM common code without holding the kvm mmu lock
+ * Return: true if any page in the given range is young, otherwise 0.
+ */
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+/**
+ * kvm_age_gfn() - clear young
+ * @kvm: the kvm instance
+ * @range: the range of guest addresses whose young status needs to be cleared
+ *
+ * Context: called by KVM common code without holding the kvm mmu lock
+ * Return: true if any page in the given range was young, otherwise 0.
+ */
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+/**
+ * kvm_unmap_gfn_range() - Unmap a range of guest addresses
+ * @kvm: the kvm instance
+ * @range: the range of guest page frames to invalidate
+ *
+ * This function always returns false because every DAT table modification
+ * has to use the appropriate DAT table manipulation instructions, which will
+ * keep the TLB coherent, hence no additional TLB flush is ever required.
+ *
+ * Context: called by KVM common code with the kvm mmu write lock held
+ * Return: false
+ */
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return false;
+}
+
 static inline unsigned long nonhyp_mask(int i)
 {
 	unsigned int nonhyp_fai = (sclp.hmfai << i * 2) >> 30;
-- 
2.52.0


