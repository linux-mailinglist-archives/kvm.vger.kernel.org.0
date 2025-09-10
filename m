Return-Path: <kvm+bounces-57226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EAFBB51FD0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45366483FD8
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCB3340DBA;
	Wed, 10 Sep 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WcrMnF44"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1832527A919;
	Wed, 10 Sep 2025 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527677; cv=none; b=csQZXI8GMz1AjoeXF+DWaWsQ4ITpgmAEApN74p1t7MramGkjipCZOSfVvrDryCA0uoxyXQvP+Lbj8xDI+f4U6nHv3Rdctlg6KfNg6mZL4N6ba9fNPIOqNQZdP7XeHyJqjfytej3qYU3rqo6STdocoDQRiWpqduuf5nllDEn/DJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527677; c=relaxed/simple;
	bh=gAd7lT7p7rlQ9mUv81LiFwgxhm1c3IKeLboD4iYo36k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcRoS8MBmyqCcdO8uBVA54stEFR9RKN5t8j4z5OzJYHgj3TKGLmIhnailaIjYtFNusOeWxcKTj+NL5IlGCH1IOp7HnYCvDyVaVXgNKI98Pa6xaGnmKye7ZM0TlMZRCjVWpc/2RdUnk7jYLOe0LJUQWG2hz+9W48i7EmgjcFTtMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WcrMnF44; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AEQa4l003803;
	Wed, 10 Sep 2025 18:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VUpTHOqTuYrmng7iF
	eUO5chwr6D+J3inAEbLIl02C8E=; b=WcrMnF448F0WSeZuOdzu+hmb+1xY+OIQx
	oaRWQ6rMhA+aotkCDWNsQSFKlkFb2JIRBwA0cLkrEki1nXEtt7t4FFXzLveU3VwX
	dPoF8xtnEKUPwZA6QxC+6EDaDKvBbAZcLtvu1/3t41k7teBBnjYd6puJV7SXNDD+
	Sw+L4U/FzE+LJoAvzRMWEcaKVKHyNb7IEtSMKTne+Ug9Jaan/NGaIobhTvOCVe9z
	1WChoRekMAIbrHVlyM2KN79AtLTR1Bx85BVwb+GJ1b57QqSG1Z4i5KDLVOci3ROq
	04KmuJRAimel2c8NeixBl1lz5IWnjeNZopBh52ELY6CrG/tZYjapA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsyge8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:52 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AHFNY3010588;
	Wed, 10 Sep 2025 18:07:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn1t1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7mK043843982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A17320040;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C81D12004B;
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
Subject: [PATCH v2 05/20] KVM: s390: Add helper functions for fault handling
Date: Wed, 10 Sep 2025 20:07:31 +0200
Message-ID: <20250910180746.125776-6-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfXxikXEF3CsoEa
 WXOi/nxdaGyXjadU1sgbVrwKWAKZkJ6jSFyxTb9bOxI8m4DJDZrx6YJsnxOO2JtrxgfvdWqW5UJ
 RxgW3jaDjDt/xyZ9m4/vIMQpbnKb1d6wC52A5zAOn5YTr3cHxcbf9fhbnBO+fPOUyIHqeQ+uOD2
 wDThOhWyyDrihDl4BdwSGw2Sre9qxvZwAEsn2XBeRswHBlp1SgyW/ZTW+wF2rnNZZThEFOmbnFu
 IwGthJgBcbPbTfPpc2MK5KMB7AvVJyyCdEHLB31oLLU7ZqC1IAaZDOUX1//3vPAssG0rEjl6NXg
 vZgXSwMSlECY4z5hhsI5yNJrI2ZmBnThvlA4F4FfupZl9ar/eJm5UhWoi3wlMNpzCcSe4RvWtI2
 Pit4SVJ4
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c1be78 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=WPezbfR20Hw7WzwRVcgA:9
X-Proofpoint-GUID: Dm0WNXrRUdVpLd1VDvBv-_KL_4BD1gVZ
X-Proofpoint-ORIG-GUID: Dm0WNXrRUdVpLd1VDvBv-_KL_4BD1gVZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

Add some helper functions for handling multiple guest faults at the
same time.

This will be needed for VSIE, where a nested guest access also needs to
access all the page tables that map it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.h  | 14 ++++++++++
 arch/s390/kvm/kvm-s390.c | 44 +++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h | 56 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+)

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 3fde45a151f2..9c82f7460821 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -457,4 +457,18 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
 			  unsigned long saddr, unsigned long *datptr);
 
+static inline int __kvm_s390_faultin_read_gpa(struct kvm *kvm, struct guest_fault *f, gpa_t gaddr,
+					      unsigned long *val)
+{
+	phys_addr_t phys_addr;
+	int rc;
+
+	rc = __kvm_s390_faultin_gfn(kvm, f, gpa_to_gfn(gaddr), false);
+	if (!rc) {
+		phys_addr = PFN_PHYS(f->pfn) | offset_in_page(gaddr);
+		*val = *(unsigned long *)phys_to_virt(phys_addr);
+	}
+	return rc;
+}
+
 #endif /* __KVM_S390_GACCESS_H */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 61aa64886c36..af8a62abec48 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4858,6 +4858,50 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
 		current->thread.gmap_int_code, current->thread.gmap_teid.val);
 }
 
+/**
+ * __kvm_s390_faultin_gfn() - fault in and pin a guest address
+ * @kvm: the guest
+ * @guest_fault: will be filled with information on the pin operation
+ * @gfn: guest frame
+ * @wr: if true indicates a write access
+ *
+ * Fault in and pin a guest address using absolute addressing, and without
+ * marking the page referenced.
+ *
+ * Context: Called with mm->mmap_lock in read mode.
+ *
+ * Return:
+ * * 0 in case of success,
+ * * -EFAULT if reading using the virtual address failed,
+ * * -EINTR if a signal is pending,
+ * * -EAGAIN if FOLL_NOWAIT was specified, but IO is needed
+ * * PGM_ADDRESSING if the guest address lies outside of guest memory.
+ */
+int __kvm_s390_faultin_gfn(struct kvm *kvm, struct guest_fault *guest_fault, gfn_t gfn, bool wr)
+{
+	struct kvm_memory_slot *slot;
+	kvm_pfn_t pfn;
+	int foll;
+
+	foll = wr ? FOLL_WRITE : 0;
+	slot = gfn_to_memslot(kvm, gfn);
+	pfn = __kvm_faultin_pfn(slot, gfn, foll, &guest_fault->writable, &guest_fault->page);
+	if (is_noslot_pfn(pfn))
+		return PGM_ADDRESSING;
+	if (is_sigpending_pfn(pfn))
+		return -EINTR;
+	if (pfn == KVM_PFN_ERR_NEEDS_IO)
+		return -EAGAIN;
+	if (is_error_pfn(pfn))
+		return -EFAULT;
+
+	guest_fault->pfn = pfn;
+	guest_fault->gfn = gfn;
+	guest_fault->write_attempt = wr;
+	guest_fault->valid = true;
+	return 0;
+}
+
 /*
  * __kvm_s390_handle_dat_fault() - handle a dat fault for the gmap of a vcpu
  * @vcpu: the vCPU whose gmap is to be fixed up
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c44fe0c3a097..dabcf65f58ff 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -22,6 +22,15 @@
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
+struct guest_fault {
+	gfn_t gfn;		/* Guest frame */
+	kvm_pfn_t pfn;		/* Host PFN */
+	struct page *page;	/* Host page */
+	bool writable;		/* Mapping is writable */
+	bool write_attempt;	/* Write access attempted */
+	bool valid;		/* This entry contains valid data */
+};
+
 static inline void kvm_s390_fpu_store(struct kvm_run *run)
 {
 	fpu_stfpc(&run->s.regs.fpc);
@@ -464,12 +473,59 @@ int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
 int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
 int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, unsigned int prot,
 			     unsigned long bits);
+int __kvm_s390_faultin_gfn(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool wr);
 
 static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
 {
 	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
 }
 
+static inline void release_faultin_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
+					    int n, bool ignore)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
+					 guest_faults[i].write_attempt);
+		guest_faults[i].page = NULL;
+	}
+}
+
+static inline bool __kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
+							 struct guest_fault *guest_faults, int n,
+							 bool unsafe)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		if (!guest_faults[i].valid)
+			continue;
+		if ((unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn)) ||
+		    (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))) {
+			release_faultin_multiple(kvm, guest_faults, n, true);
+			return true;
+		}
+	}
+	return false;
+}
+
+static inline int __kvm_s390_faultin_gfn_range(struct kvm *kvm, struct guest_fault *guest_faults,
+					       gfn_t start, int n_pages, bool write_attempt)
+{
+	int i, rc = 0;
+
+	for (i = 0; !rc && i < n_pages; i++)
+		rc = __kvm_s390_faultin_gfn(kvm, guest_faults + i, start + i, write_attempt);
+	return rc;
+}
+
+#define release_faultin_array(kvm, array, ignore) \
+	release_faultin_multiple(kvm, array, ARRAY_SIZE(array), ignore)
+
+#define __kvm_s390_fault_array_needs_retry(kvm, seq, array, unsafe) \
+	__kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), unsafe)
+
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
 
-- 
2.51.0


