Return-Path: <kvm+bounces-62541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 02ABEC48447
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7C2C83498A7
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C999C29E0F6;
	Mon, 10 Nov 2025 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EZmuxGP2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769822868A6;
	Mon, 10 Nov 2025 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795074; cv=none; b=PIOsoILeaiRvLFWB2fu+6cWMBhFCA4mrjZxLYhYFasCEhEJT7RSGbikNWB7h4tmjuctcH08M4wjq9qTzyMrndFK4sLcrao+4cRo1fG/UqovbjS40Ni7GZcQy7u9HrzulmyH6OoRfsZjZJxekpbB8s2Ay/3dPfQKK+tqCFelziGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795074; c=relaxed/simple;
	bh=XX1ccUMha4K85dbWyWCE4OrPKfwRp5hMkhFZLUtgDLM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EQpYPPp4iwT/GZZv+QCY/J8qUU19aq3c/bQN4Cm+edkWsy9TJgsthV8f7RV88JPT4R4h43MHIr1a3eJcaIaq6UQRaUIByt87Qp35/n/4jtspXsLUDPnQcdlPuv/CFEv/O9CG8w1k9SAW8xwUv3vSbQUcAnKDS1lntSBuEf7rWKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EZmuxGP2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA8FH5b019399;
	Mon, 10 Nov 2025 17:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/Va80I
	vEWYpsXhHTk0zvq47a8OoIKZLBq7FfR03MdHY=; b=EZmuxGP2oZ4Mhe8TcKqEto
	8l8gwVbu+qBQ0xmnkxwb9QEFS/2YlLgIY5iGvJLvXLVYo82bKt3ZrMEPcl4ojmc9
	wQPastr3Ecb1lx4v4ehJJJexWm/s/88kw81RBwT2hjLbjVlWjj2NGiuQCBXHJhnb
	g3XW6IFC/7tiueQyyG2lXxkjjib3gucVkkqIMk9/rWe/3Im/ikLv/Dd0n4FpPTPc
	AL1nYMDPLQZp12G75zi1AF7wDd6dTEdooSH4RjYo/M1nKi554fJW3ADRP32xxmOB
	tijMhnXtB3x99iD1h0vdI+CQ1ZZ9bZcCRfO3OjB/q34HFzAEbqo3AOwLBjzbJAVQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m7ym30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:41 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGYBRP007309;
	Mon, 10 Nov 2025 17:17:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdj6h1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHb1553608850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:37 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D59020040;
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E7F620043;
	Mon, 10 Nov 2025 17:17:36 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:36 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:47 +0100
Subject: [PATCH RFC v2 07/11] KVM: s390: Shadow VSIE SCA in guest-1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
In-Reply-To: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=31547;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=XX1ccUMha4K85dbWyWCE4OrPKfwRp5hMkhFZLUtgDLM=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctpFLv8mPRFROdcg0CJo/e/vgePnLt2Q/7Jx6o2fz
 eK7ZZned5SyMIhxMciKKbJUi1vnVfW1Lp1z0PIazBxWJpAhDFycAjCRfbcY/lmLmv+Ttchc4MXW
 Edl8q7dz6p7MB7xRf0966r594vvoeCEjw2yJI6sOPHy34IqYiMlt4ZOfbt36WCn/QuL/sbl/Vpt
 xrmEHAA==
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=69121e35 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=LxK-g1n_-iAJHyck4i8A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: diFXEwVBvtaCVhOPX5UWPkAQmaU0qc8R
X-Proofpoint-ORIG-GUID: diFXEwVBvtaCVhOPX5UWPkAQmaU0qc8R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfX/b1A+6gBgDtY
 RY193NLnPA5BMa0sWnsZAgPwJXKJVsA5/W9yuu4OxvHpBTZikLO3SBokmHPnwhGrSQLR9zh7fBw
 itUOXyOSkYgZRnvDwqrMNnzq27r3LeAQovKAcr/FYSAlGL9zKsWXUvVyOzfJsKJZIf8QXgxtXoV
 s4ikwMAmRUS17e0uKnx7CAUNQFEdUk+b7z5zCjGdpZheDpBCRyI7hO0Mnus9nHptjBlckqD6Uq0
 PbLb0XKAXvkjQja61qkGLQbyryBMUG4u9RPXEGKmMHirUvzsd3E+94Z4c49JWZa7uiQK+XCTiGy
 m65H0k50KpYos9etfjCrwYpKNLtNZpf5HgqAB8AdN9EIl5Hhirhl2ykWCZyi5q7S07FpJU6MQbk
 h5BmhnILJ3CTHX9818Z46NsWi1qUnw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

Restructure kvm_s390_handle_vsie() to create a guest-1 shadow of the SCA
if guest-2 attempts to enter SIE with an SCA. If the SCA is used the
vsie_pages are stored in a new vsie_sca struct instead of the arch vsie
struct.

When the VSIE-Interpretation-Extension Facility is active (minimum z17)
the shadow SCA (ssca_block) will be created and shadows of all CPUs
defined in the configuration are created.
SCAOL/H in the VSIE control block are overwritten with references to the
shadow SCA.

The shadow SCA contains the addresses of the original guest-3 SCA as
well as the original VSIE control blocks. With these addresses the
machine can directly monitor the intervention bits within the original
SCA entries, enabling it to handle SENSE_RUNNING and EXTERNAL_CALL sigp
instructions without exiting VSIE.

The original SCA will be pinned in guest-2 memory and only be unpinned
before reuse. This means some pages might still be pinned even after the
guest 3 VM does no longer exist.

The ssca_blocks are also kept within a radix tree to reuse already
existing ssca_blocks efficiently. While the radix tree and array with
references to the ssca_blocks are held in the vsie_sca struct.
The use of vsie_scas is tracked using an ref_count.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h       |  11 +-
 arch/s390/include/asm/kvm_host_types.h |   5 +-
 arch/s390/kvm/kvm-s390.c               |   6 +-
 arch/s390/kvm/kvm-s390.h               |   2 +-
 arch/s390/kvm/vsie.c                   | 672 ++++++++++++++++++++++++++++-----
 5 files changed, 596 insertions(+), 100 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 647014edd3de8abc15067e7203c4855c066c53ad..191b23edf0ac7e9a3e1fd9cdc6fc4c9a9e6769f8 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -597,13 +597,22 @@ struct sie_page2 {
 };
 
 struct vsie_page;
+struct vsie_sca;
 
+/*
+ * vsie_pages, scas and accompanied management vars
+ */
 struct kvm_s390_vsie {
 	struct mutex mutex;
 	struct radix_tree_root addr_to_page;
 	int page_count;
 	int next;
-	struct vsie_page *pages[KVM_MAX_VCPUS];
+	struct vsie_page *pages[KVM_S390_MAX_VSIE_VCPUS];
+	struct rw_semaphore ssca_lock;
+	struct radix_tree_root osca_to_sca;
+	int sca_count;
+	int sca_next;
+	struct vsie_sca *scas[KVM_S390_MAX_VSIE_VCPUS];
 };
 
 struct kvm_s390_gisa_iam {
diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
index ce52608449735d6ca629008c554e7df09f97e67b..3141a7163518c8fc1584c36efe216ff237722b7e 100644
--- a/arch/s390/include/asm/kvm_host_types.h
+++ b/arch/s390/include/asm/kvm_host_types.h
@@ -6,6 +6,9 @@
 #include <linux/atomic.h>
 #include <linux/types.h>
 
+#define KVM_S390_MAX_VSIE_VCPUS 256
+#define KVM_S390_MAX_SCA_PAGES 5
+
 #define KVM_S390_BSCA_CPU_SLOTS 64
 #define KVM_S390_ESCA_CPU_SLOTS 248
 
@@ -102,7 +105,7 @@ struct esca_block {
 struct ssca_block {
 	__u64	osca;
 	__u64	reserved08[7];
-	struct ssca_entry cpu[KVM_MAX_VCPUS];
+	struct ssca_entry cpu[KVM_S390_MAX_VSIE_VCPUS];
 };
 
 /*
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ab672aa93f758711af4defb13875fd49a6609758..e3fc53e33e90be7dab75f73ebd0b949c13d22939 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -470,6 +470,9 @@ static void __init kvm_s390_cpu_feat_init(void)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_IBS);
 	if (sclp.has_kss)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_KSS);
+	if (sclp.has_vsie_sigpif)
+		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_SIGPIF);
+
 	/*
 	 * KVM_S390_VM_CPU_FEAT_SKEY: Wrong shadow of PTE.I bits will make
 	 * all skey handling functions read/set the skey from the PGSTE
@@ -484,9 +487,6 @@ static void __init kvm_s390_cpu_feat_init(void)
 	 * For KVM_S390_VM_CPU_FEAT_SKEY, KVM_S390_VM_CPU_FEAT_CMMA and
 	 * KVM_S390_VM_CPU_FEAT_PFMFI, all PTE.I and PGSTE bits have to be
 	 * correctly shadowed. We can do that for the PGSTE but not for PTE.I.
-	 *
-	 * KVM_S390_VM_CPU_FEAT_SIGPIF: Wrong SCB addresses in the SCA. We
-	 * cannot easily shadow the SCA because of the ipte lock.
 	 */
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 65c950760993467398b68f3763d6f81f52c52385..0e33f00cd63e8b9f261a0c52add86560f2918d05 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -577,7 +577,7 @@ static inline int kvm_s390_use_sca_entries(void)
 	 * might use the entries. By not setting the entries and keeping them
 	 * invalid, hardware will not access them but intercept.
 	 */
-	return sclp.has_sigpif && sclp.has_esca;
+	return sclp.has_sigpif;
 }
 void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
 				     struct mcck_volatile_info *mcck_info);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index e86fef0fa3919668902c766813991572c2311b09..72c794945be916cc107aba74e1609d3b4780d4b9 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -26,6 +26,12 @@
 
 enum vsie_page_flags {
 	VSIE_PAGE_IN_USE = 0,
+	VSIE_PAGE_PINNED = 1,
+};
+
+enum vsie_sca_flags {
+	VSIE_SCA_ESCA = 0,
+	VSIE_SCA_PINNED = 1,
 };
 
 struct vsie_page {
@@ -62,7 +68,9 @@ struct vsie_page {
 	 * looked up by other CPUs.
 	 */
 	unsigned long flags;			/* 0x0260 */
-	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
+	/* vsie system control area */
+	struct vsie_sca *sca;			/* 0x0268 */
+	__u8 reserved[0x0700 - 0x0270];		/* 0x0270 */
 	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
@@ -72,6 +80,41 @@ struct kvm_address_pair {
 	hpa_t hpa;
 };
 
+/*
+ * Store the vsie system configuration data.
+ */
+struct vsie_sca {
+	/* calculated guest addresses of the sca */
+	gpa_t			sca_gpa;
+	atomic_t		ref_count;
+	/* defined in enum vsie_sca_flags */
+	unsigned long		flags;
+	unsigned long		sca_o_nr_pages;
+	struct kvm_address_pair	sca_o_pages[KVM_S390_MAX_SCA_PAGES];
+	u64			mcn[4];
+	struct ssca_block	*ssca;
+	int			page_count;
+	int			page_next;
+	struct vsie_page	*pages[KVM_S390_MAX_VSIE_VCPUS];
+};
+
+static inline bool use_vsie_sigpif(struct kvm *kvm)
+{
+	return kvm->arch.use_vsie_sigpif;
+}
+
+static inline bool use_vsie_sigpif_for(struct kvm *kvm, struct vsie_page *vsie_page)
+{
+	return use_vsie_sigpif(kvm) &&
+	       (vsie_page->scb_o->eca & ECA_SIGPI) &&
+	       (vsie_page->scb_o->ecb & ECB_SRSI);
+}
+
+static inline bool sie_uses_esca(struct kvm_s390_sie_block *scb)
+{
+	return (scb->ecb2 & ECB2_ESCA);
+}
+
 /**
  * gmap_shadow_valid() - check if a shadow guest address space matches the
  *                       given properties and is still valid
@@ -630,6 +673,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		scb_s->ictl |= ICTL_ISKE | ICTL_SSKE | ICTL_RRBE;
 
 	scb_s->icpua = scb_o->icpua;
+	write_scao(scb_s, virt_to_phys(vsie_page->sca->ssca));
+	scb_s->osda = virt_to_phys(scb_o);
 
 	if (!(atomic_read(&scb_s->cpuflags) & CPUSTAT_SM))
 		new_mso = READ_ONCE(scb_o->mso) & 0xfffffffffff00000UL;
@@ -681,6 +726,8 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* Instruction Execution Prevention */
 	if (test_kvm_facility(vcpu->kvm, 130))
 		scb_s->ecb2 |= scb_o->ecb2 & ECB2_IEP;
+	/* extended SCA */
+	scb_s->ecb2 |= scb_o->ecb2 & ECB2_ESCA;
 	/* Guarded Storage */
 	if (test_kvm_facility(vcpu->kvm, 133)) {
 		scb_s->ecb |= scb_o->ecb & ECB_GS;
@@ -713,12 +760,250 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return rc;
 }
 
+/* Called with ssca_lock held. */
+static void unpin_sca(struct kvm *kvm, struct vsie_sca *sca)
+{
+	if (!test_bit(VSIE_SCA_PINNED, &sca->flags))
+		return;
+
+	unpin_guest_pages(kvm, sca->sca_o_pages, sca->sca_o_nr_pages);
+	sca->sca_o_nr_pages = 0;
+
+	__clear_bit(VSIE_SCA_PINNED, &sca->flags);
+}
+
+/* pin g2s original sca in g1 memory */
+static int pin_sca(struct kvm *kvm, struct vsie_page *vsie_page, struct vsie_sca *sca)
+{
+	bool is_esca = sie_uses_esca(vsie_page->scb_o);
+	int nr_pages = KVM_S390_MAX_SCA_PAGES;
+
+	if (test_bit(VSIE_SCA_PINNED, &sca->flags))
+		return 0;
+
+	if (!is_esca) {
+		nr_pages = 1;
+		if ((sca->sca_gpa & ~PAGE_MASK) + sizeof(struct bsca_block) > PAGE_SIZE)
+			nr_pages = 2;
+	}
+
+	sca->sca_o_nr_pages = pin_guest_pages(kvm, sca->sca_gpa, nr_pages, sca->sca_o_pages);
+	if (WARN_ON_ONCE(sca->sca_o_nr_pages != nr_pages)) {
+		set_validity_icpt(&vsie_page->scb_s, 0x0034U);
+		return -EIO;
+	}
+	__set_bit(VSIE_SCA_PINNED, &sca->flags);
+
+	return 0;
+}
+
+static void get_sca_entry_addr(struct kvm *kvm, struct vsie_page *vsie_page, struct vsie_sca *sca,
+			       u16 cpu_nr, gpa_t *gpa, hpa_t *hpa)
+{
+	hpa_t offset;
+	int pn;
+
+	/*
+	 * We cannot simply access the hva since the esca_block has typically
+	 * 4 pages (arch max 5 pages) that might not be continuous in g1 memory.
+	 * The bsca_block may also be stretched over two pages. Only the header
+	 * is guaranteed to be on the same page.
+	 */
+	if (test_bit(VSIE_SCA_ESCA, &sca->flags))
+		offset = offsetof(struct esca_block, cpu[cpu_nr]);
+	else
+		offset = offsetof(struct bsca_block, cpu[cpu_nr]);
+	pn = ((vsie_page->sca->sca_gpa & ~PAGE_MASK) + offset) >> PAGE_SHIFT;
+	if (WARN_ON_ONCE(pn > sca->sca_o_nr_pages))
+		return;
+
+	if (gpa)
+		*gpa = sca->sca_o_pages[pn].gpa + offset;
+	if (hpa)
+		*hpa = sca->sca_o_pages[pn].hpa + offset;
+}
+
+/*
+ * Try to find the address of an existing shadow system control area.
+ * @sca_o_gpa: original system control area address; guest-2 physical
+ *
+ * Called with ssca_lock held.
+ */
+static struct vsie_sca *get_existing_vsie_sca(struct kvm *kvm, hpa_t sca_o_gpa)
+{
+	struct vsie_sca *sca = radix_tree_lookup(&kvm->arch.vsie.osca_to_sca, sca_o_gpa);
+
+	if (sca)
+		WARN_ON_ONCE(atomic_inc_return(&sca->ref_count) < 1);
+	return sca;
+}
+
+/*
+ * Try to find an currently unused ssca_vsie from the vsie struct.
+ *
+ * Called with ssca_lock held.
+ */
+static struct vsie_sca *get_free_existing_vsie_sca(struct kvm *kvm)
+{
+	struct vsie_sca *sca;
+	int i, ref_count;
+
+	for (i = 0; i >= kvm->arch.vsie.sca_count; i++) {
+		sca = kvm->arch.vsie.scas[kvm->arch.vsie.sca_next];
+		kvm->arch.vsie.sca_next++;
+		kvm->arch.vsie.sca_next %= kvm->arch.vsie.sca_count;
+		ref_count = atomic_inc_return(&sca->ref_count);
+		WARN_ON_ONCE(ref_count < 1);
+		if (ref_count == 1)
+			return sca;
+		atomic_dec(&sca->ref_count);
+	}
+	return ERR_PTR(-EFAULT);
+}
+
+static void destroy_vsie_sca(struct kvm *kvm, struct vsie_sca *sca)
+{
+	radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
+	if (sca->ssca)
+		free_pages_exact(sca->ssca, sca->page_count);
+	sca->ssca = NULL;
+	free_page((unsigned long)sca);
+}
+
+static void put_vsie_sca(struct vsie_sca *sca)
+{
+	if (!sca)
+		return;
+
+	WARN_ON_ONCE(atomic_dec_return(&sca->ref_count) < 0);
+}
+
+/*
+ * Pin and get an existing or new guest system control area.
+ *
+ * May sleep.
+ */
+static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
+				     gpa_t sca_addr)
+{
+	struct vsie_sca *sca, *sca_new = NULL;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned int max_sca;
+	int rc;
+
+	rc = validate_scao(vcpu, vsie_page->scb_o, vsie_page->sca_gpa);
+	if (rc)
+		return ERR_PTR(rc);
+
+	/* get existing sca */
+	down_read(&kvm->arch.vsie.ssca_lock);
+	sca = get_existing_vsie_sca(kvm, sca_addr);
+	up_read(&kvm->arch.vsie.ssca_lock);
+	if (sca)
+		return sca;
+
+	/*
+	 * Allocate new ssca, it will likely be needed below.
+	 * We want at least #online_vcpus shadows, so every VCPU can execute the
+	 * VSIE in parallel. (Worst case all single core VMs.)
+	 */
+	max_sca = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
+	if (kvm->arch.vsie.sca_count < max_sca) {
+		BUILD_BUG_ON(sizeof(struct vsie_sca) > PAGE_SIZE);
+		sca_new = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!sca_new)
+			return ERR_PTR(-ENOMEM);
+
+		if (use_vsie_sigpif(vcpu->kvm)) {
+			BUILD_BUG_ON(offsetof(struct ssca_block, cpu) != 64);
+			sca_new->ssca = alloc_pages_exact(sizeof(*sca_new->ssca),
+							  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+			if (!sca_new->ssca) {
+				free_page((unsigned long)sca);
+				sca_new = NULL;
+				return ERR_PTR(-ENOMEM);
+			}
+		}
+	}
+
+	/* enter write lock and recheck to make sure ssca has not been created by other cpu */
+	down_write(&kvm->arch.vsie.ssca_lock);
+	sca = get_existing_vsie_sca(kvm, sca_addr);
+	if (sca)
+		goto out;
+
+	/* check again under write lock if we are still under our sca_count limit */
+	if (sca_new && kvm->arch.vsie.sca_count < max_sca) {
+		/* make use of vsie_sca just created */
+		sca = sca_new;
+		sca_new = NULL;
+
+		kvm->arch.vsie.scas[kvm->arch.vsie.sca_count] = sca;
+	} else {
+		/* reuse previously created vsie_sca allocation for different osca */
+		sca = get_free_existing_vsie_sca(kvm);
+		/* with nr_vcpus scas one must be free */
+		if (IS_ERR(sca))
+			goto out;
+
+		unpin_sca(kvm, sca);
+		radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
+		memset(sca, 0, sizeof(struct vsie_sca));
+	}
+
+	/* use ECB of shadow scb to determine SCA type */
+	if (sie_uses_esca(vsie_page->scb_o))
+		__set_bit(VSIE_SCA_ESCA, &sca->flags);
+	sca->sca_gpa = sca_addr;
+	sca->pages[vsie_page->scb_o->icpua] = vsie_page;
+
+	if (sca->sca_gpa != 0) {
+		/*
+		 * The pinned original sca will only be unpinned lazily to limit the
+		 * required amount of pins/unpins on each vsie entry/exit.
+		 * The unpin is done in the reuse vsie_sca allocation path above and
+		 * kvm_s390_vsie_destroy().
+		 */
+		rc = pin_sca(kvm, vsie_page, sca);
+		if (rc) {
+			sca = ERR_PTR(rc);
+			goto out;
+		}
+	}
+
+	atomic_set(&sca->ref_count, 1);
+	radix_tree_insert(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa, sca);
+
+out:
+	up_write(&kvm->arch.vsie.ssca_lock);
+	if (sca_new)
+		destroy_vsie_sca(kvm, sca_new);
+	return sca;
+}
+
+static void kvm_s390_vsie_gmap_donotify(struct gmap *gmap, unsigned long start,
+					unsigned long end, struct vsie_page *cur_page)
+{
+	unsigned long prefix;
+
+	if (!cur_page)
+		return;
+	if (READ_ONCE(cur_page->gmap) != gmap)
+		return;
+	prefix = cur_page->scb_s.prefix << GUEST_PREFIX_SHIFT;
+	/* with mso/msl, the prefix lies at an offset */
+	prefix += cur_page->scb_s.mso;
+	if (prefix <= end && start <= prefix + 2 * PAGE_SIZE - 1)
+		prefix_unmapped_sync(cur_page);
+}
+
 void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 				 unsigned long end)
 {
 	struct kvm *kvm = gmap->private;
-	struct vsie_page *cur;
-	unsigned long prefix;
+	struct vsie_page *cur_page;
+	struct vsie_sca *sca;
+	unsigned int cpu_nr;
 	int i;
 
 	if (!gmap_is_shadow(gmap))
@@ -728,16 +1013,17 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 	 * therefore we can safely reference them all the time.
 	 */
 	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
-		cur = READ_ONCE(kvm->arch.vsie.pages[i]);
-		if (!cur)
-			continue;
-		if (READ_ONCE(cur->gmap) != gmap)
+		cur_page = READ_ONCE(kvm->arch.vsie.pages[i]);
+		kvm_s390_vsie_gmap_donotify(gmap, start, end, cur_page);
+	}
+	for (i = 0; i < kvm->arch.vsie.sca_count; i++) {
+		sca = READ_ONCE(kvm->arch.vsie.scas[i]);
+		if (!sca && atomic_read(&sca->ref_count))
 			continue;
-		prefix = cur->scb_s.prefix << GUEST_PREFIX_SHIFT;
-		/* with mso/msl, the prefix lies at an offset */
-		prefix += cur->scb_s.mso;
-		if (prefix <= end && start <= prefix + 2 * PAGE_SIZE - 1)
-			prefix_unmapped_sync(cur);
+		for_each_set_bit_inv(cpu_nr, (unsigned long *)sca->mcn, KVM_S390_MAX_VSIE_VCPUS) {
+			cur_page = sca->pages[cpu_nr];
+			kvm_s390_vsie_gmap_donotify(gmap, start, end, cur_page);
+		}
 	}
 }
 
@@ -789,13 +1075,6 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	hpa_t hpa;
 
-	hpa = read_scao(vcpu->kvm, scb_s);
-	if (hpa) {
-		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
-		vsie_page->sca_gpa = 0;
-		write_scao(scb_s, 0);
-	}
-
 	hpa = scb_s->itdba;
 	if (hpa) {
 		unpin_guest_page(vcpu->kvm, vsie_page->itdba_gpa, hpa);
@@ -847,20 +1126,6 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	gpa_t gpa;
 	int rc = 0;
 
-	gpa = read_scao(vcpu->kvm, scb_o);
-	if (gpa) {
-		rc = validate_scao(vcpu, scb_o, gpa);
-		if (!rc) {
-			rc = pin_guest_page(vcpu->kvm, gpa, &hpa);
-			if (rc)
-				rc = set_validity_icpt(scb_s, 0x0034U);
-		}
-		if (rc)
-			goto unpin;
-		vsie_page->sca_gpa = gpa;
-		write_scao(scb_s, hpa);
-	}
-
 	gpa = READ_ONCE(scb_o->itdba) & ~0xffUL;
 	if (gpa && (scb_s->ecb & ECB_TE)) {
 		if (gpa < 2 * PAGE_SIZE) {
@@ -948,14 +1213,18 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 }
 
 /* unpin the scb provided by guest 2, marking it as dirty */
-static void unpin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
-		      gpa_t gpa)
+static void unpin_scb(struct kvm *kvm, struct vsie_page *vsie_page)
 {
-	hpa_t hpa = virt_to_phys(vsie_page->scb_o);
+	hpa_t hpa;
+
+	if (!test_bit(VSIE_PAGE_PINNED, &vsie_page->flags))
+		return;
 
+	hpa = virt_to_phys(vsie_page->scb_o);
 	if (hpa)
-		unpin_guest_page(vcpu->kvm, gpa, hpa);
+		unpin_guest_page(kvm, vsie_page->scb_gpa, hpa);
 	vsie_page->scb_o = NULL;
+	clear_bit(VSIE_PAGE_PINNED, &vsie_page->flags);
 }
 
 /*
@@ -964,19 +1233,22 @@ static void unpin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
  * Returns: - 0 if the scb was pinned.
  *          - > 0 if control has to be given to guest 2
  */
-static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
-		   gpa_t gpa)
+static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	hpa_t hpa;
 	int rc;
 
-	rc = pin_guest_page(vcpu->kvm, gpa, &hpa);
+	if (test_bit(VSIE_PAGE_PINNED, &vsie_page->flags))
+		return 0;
+
+	rc = pin_guest_page(vcpu->kvm, vsie_page->scb_gpa, &hpa);
 	if (rc) {
 		rc = kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 		WARN_ON_ONCE(rc);
 		return 1;
 	}
 	vsie_page->scb_o = phys_to_virt(hpa);
+	__set_bit(VSIE_PAGE_PINNED, &vsie_page->flags);
 	return 0;
 }
 
@@ -1453,75 +1725,129 @@ static void put_vsie_page(struct vsie_page *vsie_page)
 	clear_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
 }
 
+static void free_vsie_page(struct vsie_page *vsie_page)
+{
+	free_page((unsigned long)vsie_page);
+}
+
+static struct vsie_page *malloc_vsie_page(struct kvm *kvm)
+{
+	struct vsie_page *vsie_page;
+
+	vsie_page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
+	if (!vsie_page)
+		return ERR_PTR(-ENOMEM);
+
+	/* Mark it as invalid until it resides in the tree. */
+	vsie_page->scb_gpa = ULONG_MAX;
+	return vsie_page;
+}
+
 /*
  * Get or create a vsie page for a scb address.
  *
+ * Original control blocks are pinned when the vsie_page pointing to them is
+ * returned.
+ * Newly created vsie_pages only have vsie_page->scb_gpa and vsie_page->sca_gpa
+ * set.
+ *
  * Returns: - address of a vsie page (cached or new one)
  *          - NULL if the same scb address is already used by another VCPU
  *          - ERR_PTR(-ENOMEM) if out of memory
  */
-static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
+static struct vsie_page *get_vsie_page(struct kvm_vcpu *vcpu, unsigned long addr)
 {
-	struct vsie_page *vsie_page;
-	int nr_vcpus;
+	struct vsie_page *vsie_page, *vsie_page_new;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned int max_vsie_page;
+	int rc, pages_idx;
+	gpa_t sca_addr;
 
-	rcu_read_lock();
 	vsie_page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
-	rcu_read_unlock();
-	if (vsie_page) {
-		if (try_get_vsie_page(vsie_page)) {
-			if (vsie_page->scb_gpa == addr)
-				return vsie_page;
-			/*
-			 * We raced with someone reusing + putting this vsie
-			 * page before we grabbed it.
-			 */
-			put_vsie_page(vsie_page);
-		}
+	if (vsie_page && try_get_vsie_page(vsie_page)) {
+		if (vsie_page->scb_gpa == addr)
+			return vsie_page;
+		/*
+		 * We raced with someone reusing + putting this vsie
+		 * page before we grabbed it.
+		 */
+		put_vsie_page(vsie_page);
 	}
 
-	/*
-	 * We want at least #online_vcpus shadows, so every VCPU can execute
-	 * the VSIE in parallel.
-	 */
-	nr_vcpus = atomic_read(&kvm->online_vcpus);
+	max_vsie_page = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
+
+	/* allocate new vsie_page - we will likely need it */
+	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {
+		vsie_page_new = malloc_vsie_page(kvm);
+		if (IS_ERR(vsie_page_new))
+			return vsie_page_new;
+	}
 
 	mutex_lock(&kvm->arch.vsie.mutex);
-	if (kvm->arch.vsie.page_count < nr_vcpus) {
-		vsie_page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
-		if (!vsie_page) {
-			mutex_unlock(&kvm->arch.vsie.mutex);
-			return ERR_PTR(-ENOMEM);
-		}
-		__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
-		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = vsie_page;
+	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {
+		pages_idx = kvm->arch.vsie.page_count;
+		vsie_page = vsie_page_new;
+		vsie_page_new = NULL;
+		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = vsie_page_new;
 		kvm->arch.vsie.page_count++;
 	} else {
 		/* reuse an existing entry that belongs to nobody */
+		if (vsie_page_new)
+			free_vsie_page(vsie_page_new);
 		while (true) {
 			vsie_page = kvm->arch.vsie.pages[kvm->arch.vsie.next];
-			if (try_get_vsie_page(vsie_page))
+			if (try_get_vsie_page(vsie_page)) {
+				pages_idx = kvm->arch.vsie.next;
 				break;
+			}
 			kvm->arch.vsie.next++;
-			kvm->arch.vsie.next %= nr_vcpus;
+			kvm->arch.vsie.next %= max_vsie_page;
 		}
+
+		unpin_scb(kvm, vsie_page);
 		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
 					  vsie_page->scb_gpa >> 9);
 	}
-	/* Mark it as invalid until it resides in the tree. */
-	vsie_page->scb_gpa = ULONG_MAX;
+
+	vsie_page->scb_gpa = addr;
+	rc = pin_scb(vcpu, vsie_page);
+	if (rc) {
+		vsie_page->scb_gpa = ULONG_MAX;
+		free_vsie_page(vsie_page);
+		mutex_unlock(&kvm->arch.vsie.mutex);
+		return ERR_PTR(-ENOMEM);
+	}
+	sca_addr = read_scao(kvm, vsie_page->scb_o);
+	vsie_page->sca_gpa = sca_addr;
+	__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
 
 	/* Double use of the same address or allocation failure. */
 	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9,
 			      vsie_page)) {
+		unpin_scb(kvm, vsie_page);
 		put_vsie_page(vsie_page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
 	}
-	vsie_page->scb_gpa = addr;
 	mutex_unlock(&kvm->arch.vsie.mutex);
 
+	/*
+	 * If the vsie cb does use a sca we store the vsie_page within the
+	 * vsie_sca later. But we need to allocate an empty page to leave no
+	 * hole in the arch.vsie.pages.
+	 */
+	if (sca_addr) {
+		vsie_page_new = malloc_vsie_page(kvm);
+		if (IS_ERR(vsie_page_new)) {
+			unpin_scb(kvm, vsie_page);
+			put_vsie_page(vsie_page);
+			return vsie_page_new;
+		}
+		kvm->arch.vsie.pages[pages_idx] = vsie_page_new;
+		vsie_page_new = NULL;
+	}
+
 	memset(&vsie_page->scb_s, 0, sizeof(struct kvm_s390_sie_block));
 	release_gmap_shadow(vsie_page);
 	vsie_page->fault_addr = 0;
@@ -1529,11 +1855,124 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	return vsie_page;
 }
 
+static struct vsie_page *get_vsie_page_cpu_nr(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
+					      gpa_t scb_o_gpa, u16 cpu_nr)
+{
+	struct vsie_page *vsie_page_n;
+
+	vsie_page_n = get_vsie_page(vcpu, scb_o_gpa);
+	if (IS_ERR(vsie_page_n))
+		return vsie_page_n;
+	shadow_scb(vcpu, vsie_page_n);
+	vsie_page_n->scb_s.eca |= vsie_page->scb_o->eca & ECA_SIGPI;
+	vsie_page_n->scb_s.ecb |= vsie_page->scb_o->ecb & ECB_SRSI;
+	put_vsie_page(vsie_page_n);
+	WARN_ON_ONCE(!((u64)vsie_page_n->scb_gpa & PAGE_MASK));
+	WARN_ON_ONCE(!((u64)vsie_page_n & PAGE_MASK));
+
+	return vsie_page_n;
+}
+
+/*
+ * Fill the shadow system control area used for vsie sigpif.
+ */
+static int init_ssca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct vsie_sca *sca)
+{
+	hpa_t sca_o_entry_hpa, osca = sca->sca_o_pages[0].hpa;
+	bool is_esca = sie_uses_esca(vsie_page->scb_o);
+	unsigned int cpu_nr, cpu_slots;
+	struct vsie_page *vsie_page_n;
+	gpa_t scb_o_gpa;
+	int i;
+
+	/* copy mcn to detect updates */
+	if (is_esca)
+		for (i = 0; i < 4; i++)
+			sca->mcn[i] = ((struct esca_block *)phys_to_virt(osca))->mcn[i];
+	else
+		sca->mcn[0] = ((struct bsca_block *)phys_to_virt(osca))->mcn;
+
+	/* pin and make minimal shadow for ALL scb in the sca */
+	cpu_slots = is_esca ? KVM_S390_MAX_VSIE_VCPUS : KVM_S390_BSCA_CPU_SLOTS;
+	for_each_set_bit_inv(cpu_nr, (unsigned long *)&vsie_page->sca->mcn, cpu_slots) {
+		get_sca_entry_addr(vcpu->kvm, vsie_page, sca, cpu_nr, NULL, &sca_o_entry_hpa);
+		if (is_esca)
+			scb_o_gpa = ((struct esca_entry *)sca_o_entry_hpa)->sda;
+		else
+			scb_o_gpa = ((struct bsca_entry *)sca_o_entry_hpa)->sda;
+
+		if (vsie_page->scb_s.icpua == cpu_nr)
+			vsie_page_n = vsie_page;
+		else
+			vsie_page_n = get_vsie_page_cpu_nr(vcpu, vsie_page, scb_o_gpa, cpu_nr);
+		if (IS_ERR(vsie_page_n))
+			goto err;
+
+		if (!sca->pages[vsie_page_n->scb_o->icpua])
+			sca->pages[vsie_page_n->scb_o->icpua] = vsie_page_n;
+		WARN_ON_ONCE(sca->pages[vsie_page_n->scb_o->icpua] != vsie_page_n);
+		sca->ssca->cpu[cpu_nr].ssda = virt_to_phys(&vsie_page_n->scb_s);
+		sca->ssca->cpu[cpu_nr].ossea = sca_o_entry_hpa;
+	}
+
+	sca->ssca->osca = osca;
+	return 0;
+
+err:
+	for_each_set_bit_inv(cpu_nr, (unsigned long *)&vsie_page->sca->mcn, cpu_slots) {
+		sca->ssca->cpu[cpu_nr].ssda = 0;
+		sca->ssca->cpu[cpu_nr].ossea = 0;
+	}
+	return PTR_ERR(vsie_page_n);
+}
+
+/*
+ * Shadow the sca on vsie enter.
+ */
+static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct vsie_sca *sca)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	int rc;
+
+	vsie_page->sca = sca;
+	if (!sca)
+		return false;
+
+	if (!sca->pages[vsie_page->scb_o->icpua])
+		sca->pages[vsie_page->scb_o->icpua] = vsie_page;
+	WARN_ON_ONCE(sca->pages[vsie_page->scb_o->icpua] != vsie_page);
+
+	if (!sca->ssca)
+		return false;
+	if (!use_vsie_sigpif_for(vcpu->kvm, vsie_page))
+		return false;
+
+	/* skip if the guest does not have an usable sca */
+	if (!sca->ssca->osca) {
+		rc = init_ssca(vcpu, vsie_page, sca);
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * only shadow sigpif if we actually have a sca that we can properly
+	 * shadow with vsie_sigpif
+	 */
+	scb_s->eca |= vsie_page->scb_o->eca & ECA_SIGPI;
+	scb_s->ecb |= vsie_page->scb_o->ecb & ECB_SRSI;
+
+	WRITE_ONCE(scb_s->osda, virt_to_phys(vsie_page->scb_o));
+	write_scao(scb_s, virt_to_phys(sca->ssca));
+
+	return false;
+}
+
 int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 {
 	struct vsie_page *vsie_page;
-	unsigned long scb_addr;
-	int rc;
+	struct vsie_sca *sca = NULL;
+	gpa_t scb_addr;
+	int rc = 0;
 
 	vcpu->stat.instruction_sie++;
 	if (!test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_SIEF2))
@@ -1554,31 +1993,45 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	vsie_page = get_vsie_page(vcpu->kvm, scb_addr);
+	/* get the vsie_page including the vsie control block */
+	vsie_page = get_vsie_page(vcpu, scb_addr);
 	if (IS_ERR(vsie_page))
 		return PTR_ERR(vsie_page);
-	else if (!vsie_page)
+	if (!vsie_page)
 		/* double use of sie control block - simply do nothing */
 		return 0;
 
-	rc = pin_scb(vcpu, vsie_page, scb_addr);
-	if (rc)
-		goto out_put;
+	/* get the vsie_sca including references to the original sca and all cbs */
+	if (vsie_page->sca_gpa) {
+		sca = get_vsie_sca(vcpu, vsie_page, vsie_page->sca_gpa);
+		if (IS_ERR(sca)) {
+			rc = PTR_ERR(sca);
+			goto out_put_vsie_page;
+		}
+	}
+
+	/* shadow scb and sca for vsie_run */
 	rc = shadow_scb(vcpu, vsie_page);
 	if (rc)
-		goto out_unpin_scb;
+		goto out_put_vsie_sca;
+	rc = shadow_sca(vcpu, vsie_page, sca);
+	if (rc)
+		goto out_unshadow_scb;
+
 	rc = pin_blocks(vcpu, vsie_page);
 	if (rc)
-		goto out_unshadow;
+		goto out_unshadow_scb;
 	register_shadow_scb(vcpu, vsie_page);
+
 	rc = vsie_run(vcpu, vsie_page);
+
 	unregister_shadow_scb(vcpu);
 	unpin_blocks(vcpu, vsie_page);
-out_unshadow:
+out_unshadow_scb:
 	unshadow_scb(vcpu, vsie_page);
-out_unpin_scb:
-	unpin_scb(vcpu, vsie_page, scb_addr);
-out_put:
+out_put_vsie_sca:
+	put_vsie_sca(sca);
+out_put_vsie_page:
 	put_vsie_page(vsie_page);
 
 	return rc < 0 ? rc : 0;
@@ -1589,27 +2042,58 @@ void kvm_s390_vsie_init(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.vsie.mutex);
 	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
+	init_rwsem(&kvm->arch.vsie.ssca_lock);
+	INIT_RADIX_TREE(&kvm->arch.vsie.osca_to_sca, GFP_KERNEL_ACCOUNT);
+}
+
+static void kvm_s390_vsie_destroy_page(struct kvm *kvm, struct vsie_page *vsie_page)
+{
+	if (!vsie_page)
+		return;
+	unpin_scb(kvm, vsie_page);
+	release_gmap_shadow(vsie_page);
+	/* free the radix tree entry */
+	if (vsie_page->scb_gpa != ULONG_MAX)
+		radix_tree_delete(&kvm->arch.vsie.addr_to_page,
+				  vsie_page->scb_gpa >> 9);
+	free_vsie_page(vsie_page);
 }
 
 /* Destroy the vsie data structures. To be called when a vm is destroyed. */
 void kvm_s390_vsie_destroy(struct kvm *kvm)
 {
 	struct vsie_page *vsie_page;
-	int i;
+	struct vsie_sca *sca;
+	int i, j;
 
 	mutex_lock(&kvm->arch.vsie.mutex);
 	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
 		vsie_page = kvm->arch.vsie.pages[i];
 		kvm->arch.vsie.pages[i] = NULL;
-		release_gmap_shadow(vsie_page);
-		/* free the radix tree entry */
-		if (vsie_page->scb_gpa != ULONG_MAX)
-			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
-					  vsie_page->scb_gpa >> 9);
-		free_page((unsigned long)vsie_page);
+		kvm_s390_vsie_destroy_page(kvm, vsie_page);
 	}
-	kvm->arch.vsie.page_count = 0;
 	mutex_unlock(&kvm->arch.vsie.mutex);
+	down_write(&kvm->arch.vsie.ssca_lock);
+	for (i = 0; i < kvm->arch.vsie.sca_count; i++) {
+		sca = kvm->arch.vsie.scas[i];
+		kvm->arch.vsie.scas[i] = NULL;
+
+		mutex_lock(&kvm->arch.vsie.mutex);
+		for (j = 0; j < KVM_S390_MAX_VSIE_VCPUS; j++) {
+			vsie_page = sca->pages[j];
+			sca->pages[j] = NULL;
+			kvm_s390_vsie_destroy_page(kvm, vsie_page);
+		}
+		sca->page_count = 0;
+		mutex_unlock(&kvm->arch.vsie.mutex);
+
+		unpin_sca(kvm, sca);
+		atomic_set(&sca->ref_count, 0);
+		radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
+		free_pages_exact(sca, sizeof(*sca));
+	}
+	kvm->arch.vsie.sca_count = 0;
+	up_write(&kvm->arch.vsie.ssca_lock);
 }
 
 void kvm_s390_vsie_kick(struct kvm_vcpu *vcpu)

-- 
2.51.1


