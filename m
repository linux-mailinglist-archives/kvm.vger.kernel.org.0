Return-Path: <kvm+bounces-41443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 194B0A67C75
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32EE6176BF4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C54F213245;
	Tue, 18 Mar 2025 18:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Go0wJVVU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42642135A1;
	Tue, 18 Mar 2025 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324393; cv=none; b=aXQp31+uBhN/ByW9UyKRLYDAOrnRbo1JeZQ/U8qP6VCCTWov6vLJ713nSjUnLxXuFDTI+f8YuIpx978FXrUmoUtrvAZAnQzI9MUMoqlh65r5Fkg3nmazEA13DpFEZBJQeGaGb+SoC1TdZbCwlmqsvKrOs8miGZXYlniiIlwz3W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324393; c=relaxed/simple;
	bh=d93zN9n3FJRkxdrKu8hHcSiBVmznnvCF8rCtnl9+kG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qin15hPuHne1NcqAS/6GwjIW7Mj+X2LXU2u8WbViCyDZGt8bwTbVQXpjwWb8bgsGxutCxuaV0dpAVUdNPNlW7BisJflmQBVkD79ZJV/KBk/HrEH35p3W5DWvLngxWBiPvIh4Md4RzaRukZ74hPhPA8MjQ8Fd5MiW/0DrfAA3DaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Go0wJVVU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ICSOlZ031039;
	Tue, 18 Mar 2025 18:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/KEqAu
	E383pTXtCkY4ttfo/jrWsvC7tblEPon9Bgd24=; b=Go0wJVVUzb0P5KWO1P50WT
	2qeHLp/AuGWZgudUU+ufQWWujGgCRuNdvjgbRyw1rXejEstFcYbHKVYTfA0xwni+
	WDWl1d30ijSjKRxuzvExdvz1j1ABRiihlcHGLKKx3Pm9HzwqPXRr/i+EjnQ4LbN3
	goc+hGHyHp8pGzXo1bfhBs7j0oORT0l9gSeK1Bq/obZue7vAmU0zkh4KntwlsirM
	8FPlNY8LZVEBiZv/Hq+Xj/QyZMKUE4Z+Qn6SdlgWqopqRXw4/6BCzaakwYybamAL
	842tm7eX0iIMhTK+/MWNQci9LW8E5ZzrrcNndOWDZqqszuqPqMpKLbTtvWnfeebg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45f8v7j5yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:44 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52IGLnOm023197;
	Tue, 18 Mar 2025 18:59:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dp3knad7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IIxdWd53281030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 18:59:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96C0220043;
	Tue, 18 Mar 2025 18:59:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13AD920040;
	Tue, 18 Mar 2025 18:59:39 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.51.150])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 18:59:38 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC 3/5] KVM: s390: Shadow VSIE SCA in guest-1
Date: Tue, 18 Mar 2025 19:59:20 +0100
Message-ID: <20250318-vsieie-v1-3-6461fcef3412@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pofmoc3-oZ5sMHSo5NjSQEBvCvu3zzv6
X-Proofpoint-ORIG-GUID: pofmoc3-oZ5sMHSo5NjSQEBvCvu3zzv6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503180137

Introduce a new shadow_sca function into kvm_s390_handle_vsie.
kvm_s390_handle_vsie is called within guest-1 when guest-2 initiates the
VSIE.

shadow_sca and unshadow_sca create and manage ssca_block structs in
guest-1 memory. References to the created ssca_blocks are kept within an
array and limited to the number of cpus. This ensures each VSIE in
execution can have its own SCA. Having the amount of shadowed SCAs
configurable above this is left to another patch.

SCAOL/H in the VSIE control block are overwritten with references to the
shadow SCA. The original SCA pointer is saved in the vsie_page and
restored on VSIE exit. This limits the amount of change in the
preexisting VSIE pin and shadow functions.

The shadow SCA contains the addresses of the original guest-3 SCA as
well as the original VSIE control blocks. With these addresses the
machine can directly monitor the intervention bits within the original
SCA entries.

The ssca_blocks are also kept within a radix tree to reuse already
existing ssca_blocks efficiently. While the radix tree and array with
references to the ssca_blocks are held in kvm_s390_vsie.
The use of the ssca_blocks is tracked using an ref_count on the block
itself.

No strict mapping between the guest-1 vcpu and guest-3 vcpu is enforced.
Instead each VSIE entry updates the shadow SCA creating a valid mapping
for all cpus currently in VSIE.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  22 +++-
 arch/s390/kvm/vsie.c             | 264 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 281 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 0aca5fa01f3d772c3b3dd62a22134c0d4cb9dc22..4ab196caa9e79e4c4d295d23fed65e1a142e6ab1 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -29,6 +29,7 @@
 #define KVM_S390_BSCA_CPU_SLOTS 64
 #define KVM_S390_ESCA_CPU_SLOTS 248
 #define KVM_MAX_VCPUS 255
+#define KVM_S390_MAX_VCPUS 256
 
 #define KVM_INTERNAL_MEM_SLOTS 1
 
@@ -137,13 +138,23 @@ struct esca_block {
 
 /*
  * The shadow sca / ssca needs to cover both bsca and esca depending on what the
- * guest uses so we use KVM_S390_ESCA_CPU_SLOTS.
+ * guest uses so we allocate space for 256 entries that are defined in the
+ * architecture.
  * The header part of the struct must not cross page boundaries.
  */
 struct ssca_block {
 	__u64	osca;
 	__u64	reserved08[7];
-	struct ssca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
+	struct ssca_entry cpu[KVM_S390_MAX_VCPUS];
+};
+
+/*
+ * Store the vsie ssca block and accompanied management data.
+ */
+struct ssca_vsie {
+	struct ssca_block ssca;			/* 0x0000 */
+	__u8	reserved[0x2200 - 0x2040];	/* 0x2040 */
+	atomic_t ref_count;			/* 0x2200 */
 };
 
 /*
@@ -953,12 +964,19 @@ struct sie_page2 {
 
 struct vsie_page;
 
+/*
+ * vsie_pages, sscas and accompanied management vars
+ */
 struct kvm_s390_vsie {
 	struct mutex mutex;
 	struct radix_tree_root addr_to_page;
 	int page_count;
 	int next;
 	struct vsie_page *pages[KVM_MAX_VCPUS];
+	struct rw_semaphore ssca_lock;
+	struct radix_tree_root osca_to_ssca;
+	int ssca_count;
+	struct ssca_vsie *sscas[KVM_MAX_VCPUS];
 };
 
 struct kvm_s390_gisa_iam {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index a78df3a4f353093617bc166ed8f4dd332fd6b08e..0327c4964d27e493932a2b90b62c5a27b0a95446 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -25,6 +25,8 @@
 #include "gaccess.h"
 #include "gmap.h"
 
+#define SSCA_PAGEORDER 2
+
 enum vsie_page_flags {
 	VSIE_PAGE_IN_USE = 0,
 };
@@ -63,7 +65,8 @@ struct vsie_page {
 	 * looked up by other CPUs.
 	 */
 	unsigned long flags;			/* 0x0260 */
-	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
+	u64 sca_o;				/* 0x0268 */
+	__u8 reserved[0x0700 - 0x0270];		/* 0x0270 */
 	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
@@ -595,6 +598,236 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return rc;
 }
 
+/* fill the shadow system control area */
+static void init_ssca(struct vsie_page *vsie_page, struct ssca_vsie *ssca)
+{
+	u64 sca_o_hva = vsie_page->sca_o;
+	unsigned int bit, cpu_slots;
+	struct ssca_entry *cpu;
+	void *ossea_hva;
+	int is_esca;
+	u64 *mcn;
+
+	/* set original SIE control block address */
+	ssca->ssca.osca = virt_to_phys((void *)sca_o_hva);
+	WARN_ON_ONCE(ssca->ssca.osca & 0x000f);
+
+	/* use ECB of shadow scb to determine SCA type */
+	is_esca = (vsie_page->scb_s.ecb2 & ECB2_ESCA);
+	cpu_slots = is_esca ? KVM_S390_MAX_VCPUS : KVM_S390_BSCA_CPU_SLOTS;
+	mcn = is_esca ? ((struct esca_block *)sca_o_hva)->mcn :
+			&((struct bsca_block *)sca_o_hva)->mcn;
+
+	/*
+	 * For every enabled sigp entry in the original sca we need to populate
+	 * the corresponding shadow sigp entry with the address of the shadow
+	 * state description and the address of the original sigp entry.
+	 */
+	for_each_set_bit_inv(bit, (unsigned long *)mcn, cpu_slots) {
+		cpu = &ssca->ssca.cpu[bit];
+		if (is_esca)
+			ossea_hva = &((struct esca_block *)sca_o_hva)->cpu[bit];
+		else
+			ossea_hva = &((struct bsca_block *)sca_o_hva)->cpu[bit];
+		cpu->ossea = virt_to_phys(ossea_hva);
+		/* cpu->ssda is set in update_entry_ssda() when vsie is entered */
+	}
+}
+
+/* remove running scb pointer to ssca */
+static void update_entry_ssda_remove(struct vsie_page *vsie_page, struct ssca_vsie *ssca)
+{
+	struct ssca_entry *cpu = &ssca->ssca.cpu[vsie_page->scb_s.icpua & 0xff];
+
+	WRITE_ONCE(cpu->ssda, 0);
+}
+
+/* add running scb pointer to ssca */
+static void update_entry_ssda_add(struct vsie_page *vsie_page, struct ssca_vsie *ssca)
+{
+	struct ssca_entry *cpu = &ssca->ssca.cpu[vsie_page->scb_s.icpua & 0xff];
+	phys_addr_t scb_s_hpa = virt_to_phys(&vsie_page->scb_s);
+
+	WRITE_ONCE(cpu->ssda, scb_s_hpa);
+}
+
+/*
+ * Try to find the address of an existing shadow system control area.
+ * @kvm:  pointer to the kvm struct
+ * @sca_o_hva: original system control area address; guest-1 virtual
+ *
+ * Called with ssca_lock held.
+ */
+static struct ssca_vsie *get_existing_ssca(struct kvm *kvm, u64 sca_o_hva)
+{
+	struct ssca_vsie *ssca = radix_tree_lookup(&kvm->arch.vsie.osca_to_ssca, sca_o_hva);
+
+	if (ssca)
+		WARN_ON_ONCE(atomic_inc_return(&ssca->ref_count) < 1);
+	return ssca;
+}
+
+/*
+ * Try to find an currently unused ssca_vsie from the vsie struct.
+ * @kvm:  pointer to the kvm struct
+ *
+ * Called with ssca_lock held.
+ */
+static struct ssca_vsie *get_free_existing_ssca(struct kvm *kvm)
+{
+	struct ssca_vsie *ssca;
+	int i;
+
+	for (i = kvm->arch.vsie.ssca_count - 1; i >= 0; i--) {
+		ssca = kvm->arch.vsie.sscas[i];
+		if (atomic_inc_return(&ssca->ref_count) == 1)
+			return ssca;
+		atomic_dec(&ssca->ref_count);
+	}
+	return ERR_PTR(-EFAULT);
+}
+
+/*
+ * Get a existing or new shadow system control area (ssca).
+ * @kvm:  pointer to the kvm struct
+ * @vsie_page:  the current vsie_page
+ *
+ * May sleep.
+ */
+static struct ssca_vsie *get_ssca(struct kvm *kvm, struct vsie_page *vsie_page)
+{
+	u64 sca_o_hva = vsie_page->sca_o;
+	phys_addr_t sca_o_hpa = virt_to_phys((void *)sca_o_hva);
+	struct ssca_vsie *ssca, *ssca_new = NULL;
+
+	/* get existing ssca */
+	down_read(&kvm->arch.vsie.ssca_lock);
+	ssca = get_existing_ssca(kvm, sca_o_hva);
+	up_read(&kvm->arch.vsie.ssca_lock);
+	if (ssca)
+		return ssca;
+
+	/*
+	 * Allocate new ssca, it will likely be needed below.
+	 * We want at least #online_vcpus shadows, so every VCPU can execute the
+	 * VSIE in parallel. (Worst case all single core VMs.)
+	 */
+	if (kvm->arch.vsie.ssca_count < atomic_read(&kvm->online_vcpus)) {
+		BUILD_BUG_ON(offsetof(struct ssca_block, cpu) != 64);
+		BUILD_BUG_ON(offsetof(struct ssca_vsie, ref_count) != 0x2200);
+		BUILD_BUG_ON(sizeof(struct ssca_vsie) > ((1UL << SSCA_PAGEORDER)-1) * PAGE_SIZE);
+		ssca_new = (struct ssca_vsie *)__get_free_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+								SSCA_PAGEORDER);
+		if (!ssca_new) {
+			ssca = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+		init_ssca(vsie_page, ssca_new);
+	}
+
+	/* enter write lock and recheck to make sure ssca has not been created by other cpu */
+	down_write(&kvm->arch.vsie.ssca_lock);
+	ssca = get_existing_ssca(kvm, sca_o_hva);
+	if (ssca)
+		goto out;
+
+	/* check again under write lock if we are still under our ssca_count limit */
+	if (ssca_new && kvm->arch.vsie.ssca_count < atomic_read(&kvm->online_vcpus)) {
+		/* make use of ssca just created */
+		ssca = ssca_new;
+		ssca_new = NULL;
+
+		kvm->arch.vsie.sscas[kvm->arch.vsie.ssca_count] = ssca;
+		kvm->arch.vsie.ssca_count++;
+	} else {
+		/* reuse previously created ssca for different osca */
+		ssca = get_free_existing_ssca(kvm);
+		/* with nr_vcpus sscas one must be free */
+		if (IS_ERR(ssca))
+			goto out;
+
+		radix_tree_delete(&kvm->arch.vsie.osca_to_ssca,
+				  (u64)phys_to_virt(ssca->ssca.osca));
+		memset(ssca, 0, sizeof(struct ssca_vsie));
+		init_ssca(vsie_page, ssca);
+	}
+	atomic_set(&ssca->ref_count, 1);
+
+	/* virt_to_phys(sca_o_hva) == ssca->osca */
+	radix_tree_insert(&kvm->arch.vsie.osca_to_ssca, sca_o_hva, ssca);
+	WRITE_ONCE(ssca->ssca.osca, sca_o_hpa);
+
+out:
+	up_write(&kvm->arch.vsie.ssca_lock);
+	if (ssca_new)
+		free_pages((unsigned long)ssca_new, SSCA_PAGEORDER);
+	return ssca;
+}
+
+/*
+ * Unshadow the sca on vsie exit.
+ * @vcpu:  pointer to the current vcpu struct
+ * @vsie_page:  the current vsie_page
+ */
+static void unshadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+{
+	struct ssca_vsie *ssca;
+
+	down_read(&vcpu->kvm->arch.vsie.ssca_lock);
+	ssca = radix_tree_lookup(&vcpu->kvm->arch.vsie.osca_to_ssca,
+				 vsie_page->sca_o);
+	if (ssca) {
+		update_entry_ssda_remove(vsie_page, ssca);
+		vsie_page->scb_s.scaoh = vsie_page->sca_o >> 32;
+		vsie_page->scb_s.scaol = vsie_page->sca_o;
+		vsie_page->scb_s.osda = 0;
+		atomic_dec(&ssca->ref_count);
+	}
+	up_read(&vcpu->kvm->arch.vsie.ssca_lock);
+}
+
+/*
+ * Shadow the sca on vsie enter.
+ * @vcpu:  pointer to the current vcpu struct
+ * @vsie_page:  the current vsie_page
+ */
+static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+{
+	phys_addr_t scb_o_hpa, sca_s_hpa;
+	struct ssca_vsie *ssca;
+	u64 sca_o_hva;
+
+	/* only shadow sca when vsie_sigpif is enabled */
+	if (!vcpu->kvm->arch.use_vsie_sigpif)
+		return 0;
+
+	sca_o_hva = (u64)vsie_page->scb_s.scaoh << 32 | vsie_page->scb_s.scaol;
+	/* skip if the guest does not have an sca */
+	if (!sca_o_hva)
+		return 0;
+
+	scb_o_hpa = virt_to_phys(vsie_page->scb_o);
+	WRITE_ONCE(vsie_page->scb_s.osda, scb_o_hpa);
+	vsie_page->sca_o = sca_o_hva;
+
+	ssca = get_ssca(vcpu->kvm, vsie_page);
+	if (WARN_ON(IS_ERR(ssca)))
+		return PTR_ERR(ssca);
+
+	/* update shadow control block sca references to shadow sca */
+	update_entry_ssda_add(vsie_page, ssca);
+	sca_s_hpa = virt_to_phys(ssca);
+	if (sclp.has_64bscao) {
+		WARN_ON_ONCE(sca_s_hpa & 0x003f);
+		vsie_page->scb_s.scaoh = (u64)sca_s_hpa >> 32;
+	} else {
+		WARN_ON_ONCE(sca_s_hpa & 0x000f);
+	}
+	vsie_page->scb_s.scaol = (u64)sca_s_hpa;
+
+	return 0;
+}
+
 void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 				 unsigned long end)
 {
@@ -699,6 +932,9 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 
 	hpa = (u64) scb_s->scaoh << 32 | scb_s->scaol;
 	if (hpa) {
+		/* with vsie_sigpif scaoh/l was pointing to g1 ssca_block but
+		 * should have been reset in unshadow_sca()
+		 */
 		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
 		vsie_page->sca_gpa = 0;
 		scb_s->scaol = 0;
@@ -775,6 +1011,9 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if (rc)
 			goto unpin;
 		vsie_page->sca_gpa = gpa;
+		/* with vsie_sigpif scaoh and scaol will be overwritten
+		 * in shadow_sca to point to g1 ssca_block instead
+		 */
 		scb_s->scaoh = (u32)((u64)hpa >> 32);
 		scb_s->scaol = (u32)(u64)hpa;
 	}
@@ -1490,12 +1729,17 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 		goto out_unpin_scb;
 	rc = pin_blocks(vcpu, vsie_page);
 	if (rc)
-		goto out_unshadow;
+		goto out_unshadow_scb;
+	rc = shadow_sca(vcpu, vsie_page);
+	if (rc)
+		goto out_unpin_blocks;
 	register_shadow_scb(vcpu, vsie_page);
 	rc = vsie_run(vcpu, vsie_page);
 	unregister_shadow_scb(vcpu);
+	unshadow_sca(vcpu, vsie_page);
+out_unpin_blocks:
 	unpin_blocks(vcpu, vsie_page);
-out_unshadow:
+out_unshadow_scb:
 	unshadow_scb(vcpu, vsie_page);
 out_unpin_scb:
 	unpin_scb(vcpu, vsie_page, scb_addr);
@@ -1510,12 +1754,15 @@ void kvm_s390_vsie_init(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.vsie.mutex);
 	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
+	init_rwsem(&kvm->arch.vsie.ssca_lock);
+	INIT_RADIX_TREE(&kvm->arch.vsie.osca_to_ssca, GFP_KERNEL_ACCOUNT);
 }
 
 /* Destroy the vsie data structures. To be called when a vm is destroyed. */
 void kvm_s390_vsie_destroy(struct kvm *kvm)
 {
 	struct vsie_page *vsie_page;
+	struct ssca_vsie *ssca;
 	int i;
 
 	mutex_lock(&kvm->arch.vsie.mutex);
@@ -1531,6 +1778,17 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
 	}
 	kvm->arch.vsie.page_count = 0;
 	mutex_unlock(&kvm->arch.vsie.mutex);
+
+	down_write(&kvm->arch.vsie.ssca_lock);
+	for (i = 0; i < kvm->arch.vsie.ssca_count; i++) {
+		ssca = kvm->arch.vsie.sscas[i];
+		kvm->arch.vsie.sscas[i] = NULL;
+		radix_tree_delete(&kvm->arch.vsie.osca_to_ssca,
+				  (u64)phys_to_virt(ssca->ssca.osca));
+		free_pages((unsigned long)ssca, SSCA_PAGEORDER);
+	}
+	kvm->arch.vsie.ssca_count = 0;
+	up_write(&kvm->arch.vsie.ssca_lock);
 }
 
 void kvm_s390_vsie_kick(struct kvm_vcpu *vcpu)

-- 
2.48.1

