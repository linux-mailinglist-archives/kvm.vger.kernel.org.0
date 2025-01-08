Return-Path: <kvm+bounces-34825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9AE1A0642B
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9E37167B15
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBDF6203713;
	Wed,  8 Jan 2025 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kbHfBR/J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86276202C4E;
	Wed,  8 Jan 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360109; cv=none; b=dr1Z0G1RX1/vQqd3+K4lmp3ye3Wty4vzr9Budb0iJtlM+yn5OUsI0hKc3DPiZq2+SU4GVnHo/2otB/GsRZn/LOQg9/Y699QDJKZS7TUBZgsGPcRRA9wQtljNzjNkih+mfiKHOsuhso/O7fsufi+ACRHv2cW8y6jUIcI+NAmYhDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360109; c=relaxed/simple;
	bh=HiER/4QeKMtOMjnknlIMhX1FegG+NqFgpu8Zr9NDe+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJGp79y+Wo43yREZi0Af8g+mrR371qSeKESwrQoPZ4XKzid9JNTkN6HHN1yLm1spFjLUXh6Xfx9YWVitIDupLfuVgCCxMrbTxlhlgdkMkA3+yFLzQJaKbmeH9qai7UNQPZCtEit1EexqfDUnl6SUjeLy5GA2k1pIO1/1rJtkCsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kbHfBR/J; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508E6b8G000831;
	Wed, 8 Jan 2025 18:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=96kG7Seh7JaCM16zv
	ih/S051p+WJs5UzzSL6fxQOFMs=; b=kbHfBR/JcfGELr2cjbbb4Rb1nEZ7zJDyJ
	jtPNTESH9LQZZAgX+Me5AX3DNeeNRrdEh82c4iKJTNFTISSzQHo/mp3l6MpOjJZh
	NeHUqFHo5PCRKNg1v+ZFR9bKwBdP4BQpV2C8RY17UW/2MuyJ7kd/K0yKXe+ZAylF
	ck0xBjqemr0Q90mr0P2mZ4jvirV52kMePwzp/gAY03FJHnmT/b1BNz31+63iw20g
	ZuRhX/DCMVD+dJdv6sOHmek/cfDCfevPWUmLNsDeJhZZTiJxu6tq1LI9vOrP6qg3
	gbsVmsq+QObimqPvl2kxYWric86hTmbNEv9qRiadAMuBin8KO1f/Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441tu5h3qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508HDX6r015903;
	Wed, 8 Jan 2025 18:14:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm106s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEqMe59376056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B59842004B;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F6DE20043;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 02/13] KVM: s390: fake memslots for ucontrol VMs
Date: Wed,  8 Jan 2025 19:14:40 +0100
Message-ID: <20250108181451.74383-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1xYJf43InE-L9osZOIvvzYTEDHusKLKm
X-Proofpoint-ORIG-GUID: 1xYJf43InE-L9osZOIvvzYTEDHusKLKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080148

Create fake memslots for ucontrol VMs. The fake memslots identity-map
userspace.

Now memslots will always be present, and ucontrol is not a special case
anymore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 42 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ecbdd7d41230..797b8503c162 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -59,6 +59,7 @@
 #define LOCAL_IRQS 32
 #define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
 			   (KVM_MAX_VCPUS + LOCAL_IRQS))
+#define UCONTROL_SLOT_SIZE SZ_4T
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
@@ -3326,6 +3327,23 @@ void kvm_arch_free_vm(struct kvm *kvm)
 	__kvm_arch_free_vm(kvm);
 }
 
+static void kvm_s390_ucontrol_ensure_memslot(struct kvm *kvm, unsigned long addr)
+{
+	struct kvm_userspace_memory_region2 region = {
+		.slot = addr / UCONTROL_SLOT_SIZE,
+		.memory_size = UCONTROL_SLOT_SIZE,
+		.guest_phys_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
+		.userspace_addr = ALIGN_DOWN(addr, UCONTROL_SLOT_SIZE),
+	};
+	struct kvm_memory_slot *slot;
+
+	mutex_lock(&kvm->slots_lock);
+	slot = gfn_to_memslot(kvm, addr);
+	if (!slot)
+		__kvm_set_memory_region(kvm, &region);
+	mutex_unlock(&kvm->slots_lock);
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
@@ -3430,6 +3448,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type & KVM_VM_S390_UCONTROL) {
 		kvm->arch.gmap = NULL;
 		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
+		/* pre-initialize a bunch of memslots; the amount is arbitrary */
+		for (i = 0; i < 32; i++)
+			kvm_s390_ucontrol_ensure_memslot(kvm, i * UCONTROL_SLOT_SIZE);
 	} else {
 		if (sclp.hamax == U64_MAX)
 			kvm->arch.mem_limit = TASK_SIZE_MAX;
@@ -5704,6 +5725,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 #ifdef CONFIG_KVM_S390_UCONTROL
 	case KVM_S390_UCAS_MAP: {
 		struct kvm_s390_ucas_mapping ucasmap;
+		unsigned long a;
 
 		if (copy_from_user(&ucasmap, argp, sizeof(ucasmap))) {
 			r = -EFAULT;
@@ -5715,6 +5737,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			break;
 		}
 
+		a = ALIGN_DOWN(ucasmap.user_addr, UCONTROL_SLOT_SIZE);
+		while (a < ucasmap.user_addr + ucasmap.length) {
+			kvm_s390_ucontrol_ensure_memslot(vcpu->kvm, a);
+			a += UCONTROL_SLOT_SIZE;
+		}
 		r = gmap_map_segment(vcpu->arch.gmap, ucasmap.user_addr,
 				     ucasmap.vcpu_addr, ucasmap.length);
 		break;
@@ -5852,10 +5879,18 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	gpa_t size;
+	gpa_t size = new->npages * PAGE_SIZE;
 
-	if (kvm_is_ucontrol(kvm))
-		return -EINVAL;
+	if (kvm_is_ucontrol(kvm)) {
+		if (change != KVM_MR_CREATE || new->flags)
+			return -EINVAL;
+		if (new->userspace_addr != new->base_gfn * PAGE_SIZE)
+			return -EINVAL;
+		if (!IS_ALIGNED(new->userspace_addr | size, UCONTROL_SLOT_SIZE))
+			return -EINVAL;
+		if (new->id != new->userspace_addr / UCONTROL_SLOT_SIZE)
+			return -EINVAL;
+	}
 
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
@@ -5872,7 +5907,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (new->userspace_addr & 0xffffful)
 			return -EINVAL;
 
-		size = new->npages * PAGE_SIZE;
 		if (size & 0xffffful)
 			return -EINVAL;
 
-- 
2.47.1


