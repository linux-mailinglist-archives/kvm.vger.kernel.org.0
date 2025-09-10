Return-Path: <kvm+bounces-57225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C58B51FCF
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70CC5482E54
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F96340DB3;
	Wed, 10 Sep 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RUyJZBSs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C98338F26;
	Wed, 10 Sep 2025 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527677; cv=none; b=ATB8xgCIGmHk7HKbHEcFWqnN+xYJVLw3GHcBZ8gWeKbF5qYdIDk6D43GOPbNYbW6mxv+VNwozVWHYgxQBQr58XGNmuGnohuD1kgRCRfxXVZbwa3s0de2YzwiLz+YzgPYcYDLFerQ5CWyMlezHy0x/3OunKtaWtrv46MkKDyhU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527677; c=relaxed/simple;
	bh=+nLp+U7KHxMoH+IWKKw7aSwZ9/kw2Frlrls/NhsXFbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEfMLS69Bsl0peEKeqvj70fnWgL634sVUXNlRhA0UFbPnQJ7mATc10Feqxqf7m31D00YH42bJ9p5FQbdOjHGZDW61Nn8RY+3aPnSLKp7JhUKKf+e9nQxH/INoNh+B44yHhJdnyExCzTQdIhKlLayTTXqReKhuDknqPGS47+xJA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RUyJZBSs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AG7hvX011739;
	Wed, 10 Sep 2025 18:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1bD5IaS+rvcxX5ZEO
	dacjSvZ7fF4HqgcLyfTab3vn04=; b=RUyJZBSs+I1h759EDpQ0pQnXj1D7q/qCr
	0CrkDW1abbRArjdgV7jBP6+9MxwZkqLodwepsZkzdJm8z0FNgmVUyoqVx/3EoTh9
	PDedvGk0VpsyMkn5uU1xhPeTVaKgfxAQGY/NfJB5ngY9ux6lxUp9jM9viD0M+1lX
	X+HLwYDyL05kiN/qM65th1mpiGMWEG/ncRv9igABHnF/cgWu+91k+X3uRqhNtIFI
	dni4nXPbzwue2ap/lcbvISFoQrdrwDSh00HoQolkPE4sVa9/9+YUMIZqq/5ho8jk
	RfAwXfS3hYyHZeLD8CBFPBtVXip8kU1RN1/36itM2zSsa2AscEMqw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xyd4uv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGV4ig020465;
	Wed, 10 Sep 2025 18:07:51 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp1205u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:51 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7lNA23134676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0F2F20040;
	Wed, 10 Sep 2025 18:07:47 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B15120049;
	Wed, 10 Sep 2025 18:07:47 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:47 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 04/20] KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
Date: Wed, 10 Sep 2025 20:07:30 +0200
Message-ID: <20250910180746.125776-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: YhHPE_BXtxkuioXRYF5TQs9u43-Pfvs1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX+/D2OmKHfULI
 EDgIlEDZMStXT++2Y3z6TvPZrMk/sMcF7Y76Qgh6TdbREdJuFXWOeCDBC+NHm8u9GMnptPOEB3F
 Cb5E+fKOTAQiNOkKyupDzuJEA76R/O9MdbY0WSG0imlIpcwKTfiHwtRdBLzta9dPtYfYsi0Jcgm
 1EYyhIV7LVgFouC8J/8URd0JDVe89G4OOsThFQPxRJBpagpI4AnXrmqaA0awpIqrwab6qztgAw3
 x+nCzouCGlEx9h8sSA5FMdz6wJYx000Xq94moQglPL76OS1On4JHCbaKn+7u7rSc4NM9ufYwTEl
 yaMdB6R1EKvySHug6lI1SG7bYPFW7PeVVebPzeZLY26JlwPpheTN4ldDki3MOrOg3D6XswKuKsc
 i/rKnf0I
X-Proofpoint-GUID: YhHPE_BXtxkuioXRYF5TQs9u43-Pfvs1
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c1be79 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=sWpJ-_il0aw9mM0vlR0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235

Enable KVM_GENERIC_MMU_NOTIFIER, for now with empty placeholder callbacks.

Also enable KVM_MMU_LOCKLESS_AGING and define KVM_HAVE_MMU_RWLOCK.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/Kconfig            |  3 ++-
 arch/s390/kvm/kvm-s390.c         | 45 +++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cb89e54ada25..9cc61deaaf29 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/isc.h>
 #include <asm/guarded_storage.h>
 
+#define KVM_HAVE_MMU_RWLOCK
 #define KVM_MAX_VCPUS 255
 
 #define KVM_INTERNAL_MEM_SLOTS 1
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index cae908d64550..e86332b26511 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -29,7 +29,8 @@ config KVM
 	select HAVE_KVM_INVALID_WAKEUPS
 	select HAVE_KVM_NO_POLL
 	select KVM_VFIO
-	select MMU_NOTIFIER
+	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMU_LOCKLESS_AGING
 	help
 	  Support hosting paravirtualized guest machines using the SIE
 	  virtualization capability on the mainframe. This should work
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4280b25b6b04..61aa64886c36 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4917,7 +4917,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
 	if (!rc)
 		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
-	scoped_guard(spinlock, &vcpu->kvm->mmu_lock) {
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
 		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
 	}
 	mmap_read_unlock(vcpu->arch.gmap->mm);
@@ -6097,6 +6097,49 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.51.0


