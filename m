Return-Path: <kvm+bounces-36373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16931A1A5FE
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:47:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FFE87A5247
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF9B212D96;
	Thu, 23 Jan 2025 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZxWOHOyO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62359210F7E;
	Thu, 23 Jan 2025 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643601; cv=none; b=IhKNCQaPTtM556ivXL8JYaLra1tnHzZ2ehlUY5EaPDnwzEscKC3098SvgHFWFhb2TGgm8jYd6u5kDrLFD7imSMW2yhqFD8c7hGRhk3yJiKTxOKJL3+cc44b8vaHLPiZWy+jAFUp9vFmTYQmCgjBvZYzeNtN2LGAGwilOlNPFK68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643601; c=relaxed/simple;
	bh=8kY5gfo60/iNrnoO+GWLny1i9ko1hyOQzYmBti1B54o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP4kMVq3ki811dc73CT4vl46jco6yKDN6xJHiJiON6cYgP4lT36WpVJV/TkyhRIcZ0PiliOA6mh0lpB9wjVDwEXMPYuk3VsONxOu33WhJWAKFwevw2+HacHLzhlKTj6M7SHrYU5TZGQj86DjUKLpiXoRvRazQPi0r29pxXAx8g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZxWOHOyO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NBI1dZ027435;
	Thu, 23 Jan 2025 14:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=d6LoJT9ko5DRzLzUi
	AJxG3HZ0QzGf2faMvhvzpmY1Q4=; b=ZxWOHOyO3yfqdiWIavB3Bdf4CwPTCtmn4
	ddeapzCGl2j9+IpQfe2NWBG0FuzKwm1XPmqFM4S0aQTMWRMrAMHB0iIXAzpZRnWV
	YuKZUqVwds9FHxR6mmXtVgppnoiMgyAboe7JoAfkrauTQ4YlA5IYXzrNdZhF+QMC
	6bEu10NdX3RNRgHq25Z3cJe3UyxAvJVP+mzAboETJBP6o9E+V+ejQr/qBrBcLHjP
	/TU+5WMcITNNYG8ImCzwY8QEOdCGGbAmlzky/pPUHidK/WSsNxFpwXTlPVli0swv
	MYoVmpFJRhf/JC/B803j2Ry0w60TsjJ+W2l05pvf0F8Vjg4oW/L6Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b2xyp49a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:34 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEgRcj024572;
	Thu, 23 Jan 2025 14:46:33 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b2xyp494-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NCBLiC020986;
	Thu, 23 Jan 2025 14:46:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1nksw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkTP632702978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CC1620040;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 376542004B;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 03/15] KVM: s390: fake memslot for ucontrol VMs
Date: Thu, 23 Jan 2025 15:46:15 +0100
Message-ID: <20250123144627.312456-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123144627.312456-1-imbrenda@linux.ibm.com>
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QbkYhjyzagzsa8vA3dfvgO8CqESZqwn-
X-Proofpoint-ORIG-GUID: 6uf9ML3Qc4zfqRLrseCvcSf0gCoL15mk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501230108

Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
userspace.

Now memslots will always be present, and ucontrol is not a special case
anymore.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   |  2 +-
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 16 +++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  2 ++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f15b61317aad..cc98115a96d7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1419,7 +1419,7 @@ fetch) is injected in the guest.
 S390:
 ^^^^^
 
-Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
+Returns -EINVAL or -EEXIST if the VM has the KVM_VM_S390_UCONTROL flag set.
 Returns -EINVAL if called on a protected VM.
 
 4.36 KVM_SET_TSS_ADDR
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
index ecbdd7d41230..2d63bee23f44 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3428,8 +3428,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
+		guard(mutex)(&kvm->slots_lock);
+		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);
 	} else {
 		if (sclp.hamax == U64_MAX)
 			kvm->arch.mem_limit = TASK_SIZE_MAX;
@@ -5854,7 +5865,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
-	if (kvm_is_ucontrol(kvm))
+	if (kvm_is_ucontrol(kvm) && new->id < KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
 	/* When we are protected, we should not change the memory slots */
@@ -5906,6 +5917,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.48.1


