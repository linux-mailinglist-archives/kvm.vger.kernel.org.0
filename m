Return-Path: <kvm+bounces-35644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E47AA13916
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:34:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 870153A7AA1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9141DE891;
	Thu, 16 Jan 2025 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RdXyfU47"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041941DE2C4;
	Thu, 16 Jan 2025 11:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027250; cv=none; b=dX3IXAEWqYIScqRdiBhWLgz9VzGZZGwMMeeMXIWp7f3kULzI6TCxD5Hf2rG9IIiW1SCkiQXkzawd35NNTNFLOLpAcD9Icpu0EfSGzigKF+9hROlZY57kZzvUtpcPCc9QDV1cotewrUxGl8SivfttjOhV7pirXJi7uyj08XPM1aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027250; c=relaxed/simple;
	bh=eK3c6WjkPhcG19uEEQi1Q76gLCK9jceb7JkSPkVag2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoXo3fAaWulLAUDvDGhOokiUKV7QGOD7klhgcEU40RqGOCRpYQUSmBmTk7TwJdso5oQwBx8iuyRnc2OPWlgzwb/Tz0IbL9MqxkcFlkfpdMYBNZBBJTWLugWKBIoJ5NMTC/j4DB5PAdNGFpxCrx+uzjr/2AZkt3oIbrrE/oTHh6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RdXyfU47; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FNxAnx029787;
	Thu, 16 Jan 2025 11:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=v7QfzRkA3szVnK7hV
	o2dbOUjaKNMjOPd750SqUW4lyA=; b=RdXyfU47xOAwBC8LiFhcdrb7eBxzX2mWz
	BAu+cdppAhMKvoJreWnzEPOu1XGNym/T2bV73va//80P31uP2C87u2WslJch9fdK
	YX2RL+VzB1iycdr7kR2aSSscPLu7lz3+Hmb5hRGz/17L8RLObmS7S0ht4W5zSuLc
	c7sW3OsHBOdaJ53srW6oMGAwmIZOj9a8Cco0308jmmvY8oDHeiqVHkcc6bWmSACl
	2Wxg58xAANqQfxDc53800ZnLU2jflndyLvElfT41aem9ex9BmzpN9ILh/2XjVsXF
	b1dvp/gW3VrSe0goRm50VFdMxFg05CEf/rYIu5NhWWHt+jfCOKRKw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5htree-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:02 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBY1S5011781;
	Thu, 16 Jan 2025 11:34:01 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5htrea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GASDJ5000874;
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k5b0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXvLS54788534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:33:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55B0420040;
	Thu, 16 Jan 2025 11:33:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1596C2004E;
	Thu, 16 Jan 2025 11:33:57 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:57 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 04/15] KVM: s390: fake memslot for ucontrol VMs
Date: Thu, 16 Jan 2025 12:33:44 +0100
Message-ID: <20250116113355.32184-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KuQpVRVKYpVzjpQ37hDIGPelHrKQthPb
X-Proofpoint-GUID: c1WrCEQYyTD3TexmqTz6TzXtrZngcwK2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160086

Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
userspace.

Now memslots will always be present, and ucontrol is not a special case
anymore.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 15 ++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  2 ++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 97c7c8127543..9df37361bc64 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -30,6 +30,8 @@
 #define KVM_S390_ESCA_CPU_SLOTS 248
 #define KVM_MAX_VCPUS 255
 
+#define KVM_INTERNAL_MEM_SLOTS 1
+
 /*
  * These seem to be used for allocating ->chip in the routing table, which we
  * don't use. 1 is as small as we can get to reduce the needed memory. If we
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index fda2c1121093..c9496d23470c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3429,8 +3429,18 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	VM_EVENT(kvm, 3, "vm created with type %lu", type);
 
 	if (type & KVM_VM_S390_UCONTROL) {
+		struct kvm_userspace_memory_region2 fake_memslot = {
+			.slot = KVM_S390_UCONTROL_MEMSLOT,
+			.guest_phys_addr = 0,
+			.userspace_addr = 0,
+			.memory_size = ALIGN_DOWN(TASK_SIZE, _SEGMENT_SIZE),
+			.flags = 0,
+		};
+
 		kvm->arch.gmap = NULL;
 		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
+		/* one flat fake memslot covering the whole address-space */
+		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);
 	} else {
 		if (sclp.hamax == U64_MAX)
 			kvm->arch.mem_limit = TASK_SIZE_MAX;
@@ -5855,7 +5865,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
-	if (kvm_is_ucontrol(kvm))
+	if (kvm_is_ucontrol(kvm) && new->id < KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
 	/* When we are protected, we should not change the memory slots */
@@ -5907,6 +5917,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	int rc = 0;
 
+	if (kvm_is_ucontrol(kvm))
+		return;
+
 	switch (change) {
 	case KVM_MR_DELETE:
 		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 597d7a71deeb..30736ac16f84 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -20,6 +20,8 @@
 #include <asm/processor.h>
 #include <asm/sclp.h>
 
+#define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
+
 static inline void kvm_s390_fpu_store(struct kvm_run *run)
 {
 	fpu_stfpc(&run->s.regs.fpc);
-- 
2.47.1


