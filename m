Return-Path: <kvm+bounces-36903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23567A22AC2
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 377EB166C70
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DCB1BEF90;
	Thu, 30 Jan 2025 09:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KXAIK7aq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E941B87C2;
	Thu, 30 Jan 2025 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230691; cv=none; b=Mb4q/0eEK3DlcSRNybhEhw0OiAkd1/luTwOvOvxjPyvghlH1xLg2A9iIY641l/aCpWvvBqNnA0dGHy3bVEkY2LEfRmGdPawpl9rMYmQIY16dBxzqBja077hrWMtZPyzlaaxMJqRzxnfjYXAaw4bV5tNMuBjuSP55HExaKAewdeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230691; c=relaxed/simple;
	bh=5kErglAGaiLpjTasLdpYtxcLS/MucM5ogAdGQcpeTV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jvi+i6973E8d3G2SzoxCK9DutGXfSZSoX1CCwQLSkmUrcZk8WYWLocmqyKGAmT5x4NninXJF0r4MSSr7wubij5vKdo4WhooNxt8rC+EaVIxLVFP6VI25XPWZdLzKv9P+LhPIhSCTgO7ugliY4tRPoYQ+Nv7HuqlTUMaw1WCt3w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KXAIK7aq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U0DEmH024350;
	Thu, 30 Jan 2025 09:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QBPgYjCXwiQR38I0U
	2pO+KdWV2NZ0ToHb8moivvDEo8=; b=KXAIK7aqTPYmyiB+wsnPvvDGZHrGeLRW3
	7Ozs6lmte0Qw8scuGcnLkechbS3Z8/jcwz1OM7XxK/ZrDNGyzF97n6jD8cBjcGzX
	lC0Q4GmEljtdOimEQJeLT72sxpp6vqSDrpxrE0tndChBCsJEvnO36ajllIJTjdT+
	XKjSJGV0+1dYxUiSYgnYRpncYIrcMc0lk9qlqcKrcugGTMHk+es/hWQ+EIz93eR1
	41T5PaDsPvVin1ApeQczUn3qnvotpUkxaSK5MYD/YUmIeg7Xltbbym0mNvAXP9Fb
	7T4FCwxKBEycKOB6OmhWJjSCVckWO8KNAMd+/cOvGkIBfiitJ+3tg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44fpm1msk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U70qbh012444;
	Thu, 30 Jan 2025 09:51:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44danydndm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pK4n34865786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A449620141;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 811532013E;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 07/20] KVM: s390: fake memslot for ucontrol VMs
Date: Thu, 30 Jan 2025 10:51:00 +0100
Message-ID: <20250130095113.166876-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yr5qqJIb92JO_i_S8C6aZJgrA73P1Q2t
X-Proofpoint-GUID: yr5qqJIb92JO_i_S8C6aZJgrA73P1Q2t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300073

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


