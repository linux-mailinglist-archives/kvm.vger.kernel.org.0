Return-Path: <kvm+bounces-63895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8895BC7599F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 3BBF52A511
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:19:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04DAE3A79B4;
	Thu, 20 Nov 2025 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Cv9FkwNC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC93A1CF4;
	Thu, 20 Nov 2025 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658965; cv=none; b=JphYbLKPX+bUJBfudPBoJGHjegNXpdxwGtjuqIryO2Fu9+6yKFpmIIkqDSoYDm5si0tJ8RpxBp5sRBpANepouZw1HFm33RJeI+xeBTr73z9rD8c0kfB4iAcN8EUfYdyDhGQoJW5lN0lVZgbGWnUtBw5uWJjORLzsvIv1w6L8Sno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658965; c=relaxed/simple;
	bh=9/XGXZbVrrrbHZGQm2z3Er12l9KTyaztqVzHuOUY0Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJSaCrEsSlCULNDj+c8qQlR3+AgrqfpbE6il8N5bCVxwwRdi1BUdykVDNPebP1j5LlvWnzVBwrEBdkEGdqAIHIewTVtUX0lWdE8AUs/RTRmo/V0gX5XuyFjENJCErS/cxx68uapUbMdqissS0MkIC4dARlo8xJ5vLsu7UwQUEHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Cv9FkwNC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKBv8hH007044;
	Thu, 20 Nov 2025 17:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Q5BgJ9yd0kjSFSkjR
	HUunnRp8UfhNyqvkTWSU8BFoHw=; b=Cv9FkwNCagU/dAiOG2ArKykW8zg3m6BHN
	aZ//VJGN1YRChwocPbWjvzO2XGvkI/ZYqwlzBojkOBgwvCZ1x2S7jnZvCN1y3Wtj
	CQ+aHi0KA0z/UX3IOxT1pAs7T3jrYR5sm3dE1R7vdl0i1NNbjQtA5jaQwGJoV/v9
	3VtpsemymPoO09BYSRoQyQgi3RtromheF1Wc7hDboqr3u/U/jDBmTJKuz8VUx0c6
	gD3qjMO28qfu/EEDSPPVSBKwzFFa6EEQUftv/QHj4VDypkncR/wyry+EmtOnNQgG
	rOyc3YFDeiJBp6LOHxg590iG4R1Gsh6I+CyJZEHy7QIqdgb4p7yWA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmsxbkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:00 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKGUuIo010406;
	Thu, 20 Nov 2025 17:16:00 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af3usfsbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:15:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHFuwc57409878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:15:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D07B2004D;
	Thu, 20 Nov 2025 17:15:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F19320043;
	Thu, 20 Nov 2025 17:15:54 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:15:54 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 05/23] KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
Date: Thu, 20 Nov 2025 18:15:26 +0100
Message-ID: <20251120171544.96841-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120171544.96841-1-imbrenda@linux.ibm.com>
References: <20251120171544.96841-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VWY_odSwCPZCI6vvT4d8WTOmTdknijfz
X-Authority-Analysis: v=2.4 cv=Rv3I7SmK c=1 sm=1 tr=0 ts=691f4cd0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=sWpJ-_il0aw9mM0vlR0A:9
X-Proofpoint-GUID: VWY_odSwCPZCI6vvT4d8WTOmTdknijfz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX21g8tVE+QpPM
 ks+OZtX+r4BaVOunfDKNIbCAhaIj8fGGYWDQTgfyUVyuo0RmD+MHl98j4881AZatd6xOotumaEs
 qvZmGL9Rgc7Erbvl+a2HujYdaCb0kqE2surN3H4u3bmB6jvSrAh+/ndIDKWRRqXEFA+iZgoyQgC
 RLCP0EeAzr0bbNm8NKhmkAXrSSRpJzEjfLsQCcIxm0NHBlammEbdsrBwIjwYP1PoY8hnMIF6Vmu
 FWoqthUKR84uKFXCOC9/KWLb6LMRUAl7CjCMpgRZkU4lWwSsb7x5vELOZELIBlbO4Sx4iAmgevb
 6L+bA3aREUqnjf5PAyRuwByzqwrmkoYuQKtbkXtOYaSUTKzkq1eGweZfVcoAYh8Rm2EELCNLbus
 Nox62iJ1+O0RD6SngYgUt5EhJpFAMg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

Enable KVM_GENERIC_MMU_NOTIFIER, for now with empty placeholder callbacks.

Also enable KVM_MMU_LOCKLESS_AGING and define KVM_HAVE_MMU_RWLOCK.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/Kconfig            |  3 ++-
 arch/s390/kvm/kvm-s390.c         | 45 +++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c2ba3d4398c5..f5f87dae0dd9 100644
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
index 16ba04062854..2e34f993e3c5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4918,7 +4918,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
 	if (!rc)
 		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
-	scoped_guard(spinlock, &vcpu->kvm->mmu_lock) {
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
 		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
 	}
 	mmap_read_unlock(vcpu->arch.gmap->mm);
@@ -6125,6 +6125,49 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.51.1


