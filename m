Return-Path: <kvm+bounces-36984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE50A23D0A
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:29:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3149D7A4746
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BE21C3316;
	Fri, 31 Jan 2025 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DOZUKMlH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58101F238D;
	Fri, 31 Jan 2025 11:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322732; cv=none; b=AXbUV0yLUTThaHOnT46K96afsyQ3nRIMrX60BJZaAdvVfez3veGdqfgJPCMiI7h5IsdI+FIMXG3IAvKMBwTJOwk218dP/HCVIzm8xqBO8TenuOIz/3TwvmKxkjTdXA2rSe39O9DfZsKxKZjKNgbCh2OtafDoIe0X3TOROORiY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322732; c=relaxed/simple;
	bh=5kErglAGaiLpjTasLdpYtxcLS/MucM5ogAdGQcpeTV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTaB2A85sXJnVvpZdRGIFBA+X2P1ANIwFdFR/2Xzkpb9Mw7gmnfY7MoCzo2LJEnPBkyFCR2Dn1cpDzFXRCr2us1Y+ZVHvdB2bfsouxxj1p01U+mYI/Ovrw3oLBlTTq1H3R5wK4Oz4EI8owELSdQJvrmTvQKIyb5c5pViHpUc9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DOZUKMlH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V5Nk5J013095;
	Fri, 31 Jan 2025 11:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QBPgYjCXwiQR38I0U
	2pO+KdWV2NZ0ToHb8moivvDEo8=; b=DOZUKMlHt+XIXnby2KdsmvKLf84G9Uu4F
	NXsABv+sR1diECuoRaesMzM2t5JHWtlXn34EL7aKCbX6Pxn8pYjnLx4nIi57uHuQ
	ypzWIsuCsoQNFPV0Yvp7t/SFlnG5qG6YXm6Uu+GWtQMyCIuZLiFBPKNlpHl81gcq
	nhO1b0yAbHFbyyfDJyu/+fohpf4oUNDLHaEZGsmtaSyaJ3gZG2kiFX1SASxEvSWQ
	Iwe627sAwTK4aBGXsGCpnEof7QElALH2CDwCylbOZj1l5bDsLu/opsoHGnulVLen
	dJEE+hY0ysleW5eFCZ/sd1A3Ih69aAd3egghJFB5ZrVY6R5gLLDig==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44grb79b57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V89Jx1016101;
	Fri, 31 Jan 2025 11:25:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gfaub8qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:27 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPNPu20316566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 331E92012E;
	Fri, 31 Jan 2025 11:25:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9E952012F;
	Fri, 31 Jan 2025 11:25:22 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:22 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 07/20] KVM: s390: fake memslot for ucontrol VMs
Date: Fri, 31 Jan 2025 12:24:57 +0100
Message-ID: <20250131112510.48531-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xKRY60wOZbP3HFTV0ATx3laXTV6BXEme
X-Proofpoint-ORIG-GUID: xKRY60wOZbP3HFTV0ATx3laXTV6BXEme
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2501310083

Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
userspace.

Now memslots will always be present, and ucontrol is not a special case
anymore.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-4-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-4-imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   |  2 +-
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 17 ++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  2 ++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0d1c3a820ce6..2b52eb77e29c 100644
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
index 4581388411b7..9a367866cab0 100644
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
index ecbdd7d41230..fc44002a7b04 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3428,8 +3428,20 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
+		mutex_lock(&kvm->slots_lock);
+		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);
+		mutex_unlock(&kvm->slots_lock);
 	} else {
 		if (sclp.hamax == U64_MAX)
 			kvm->arch.mem_limit = TASK_SIZE_MAX;
@@ -5854,7 +5866,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
-	if (kvm_is_ucontrol(kvm))
+	if (kvm_is_ucontrol(kvm) && new->id < KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
 	/* When we are protected, we should not change the memory slots */
@@ -5906,6 +5918,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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


