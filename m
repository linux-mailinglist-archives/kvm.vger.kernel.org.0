Return-Path: <kvm+bounces-35854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B247A157D8
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA7D73A8868
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65EC51AB537;
	Fri, 17 Jan 2025 19:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eVM4pImi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF11A83EA;
	Fri, 17 Jan 2025 19:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140991; cv=none; b=EQ6uIHuPKOHXLODo0FwwZ5zs2OR7N7ReKUt87QYfvEx1CBUK/XL51nzTs3a9mpcgw0T++9a5XsLWej13i+LQ2u7Vd1riB7CJq/pqp9YzMzGutujZJjudRZPBVBMyHvEiL/ZDFaxzBTD/w8BEbGqDEvDGeaboJBczZOE0X3KTPiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140991; c=relaxed/simple;
	bh=YWrN26Q06z2zDMtzs29Y8BGMBC5XIugAOFPv+3aWr8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1yKgVhfk8xE7ytm8ww9ZSf6LSGKGISc06Zok9do23vZCyUVca+GZQqS1NQxI18268XJ5Qmt2lqcH7LFnnmqvsW8NIb7U8GbezwojiWGL3npYoPI6J3qyDv7y2yME3XmeOFM+lsGsYUZnSRaLPMyFIcjp8WdUv+eBQMgcYGRhXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eVM4pImi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HDATa3017931;
	Fri, 17 Jan 2025 19:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=E11ioWaOR7e1eHrXY
	564gjouzoDJUvI3X8eIaY4Sl18=; b=eVM4pImikJei8TwrB20Ey5CeOvrcF5xsd
	Z7NX2JrGKqGof2qgfLmcc/fay/K7gIE2537gfFw9S7Bock3QK3XeuXsQOcpd6QCg
	TkzSCmN7vueZp4pJv6M2TqETqoj+ci79LmDDXJx2lbzKr0kHolZv/57Dwa6EEafP
	7oHE/9jZzHD0ppZAspbQQXi+iz8zD5SuveWI7ewA70D8kj57WykC9l7IJbVD/ItO
	3a4W9XaJjnSqENxKTuhMD/t4Dz2yQTWCGPQ/4ToRrklBCmGO3dxvPXxaUc2Z5ba9
	BppoqrDcsWML++IT/ti2M8UuJWUlObju+Tjgtjbuep06nV2b3N3xw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb4r4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ75l7027927;
	Fri, 17 Jan 2025 19:09:44 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447bxb4r4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIMpmu007462;
	Fri, 17 Jan 2025 19:09:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443ynmbnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9dKf47251786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C185B20040;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B4792004D;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 03/15] KVM: s390: fake memslot for ucontrol VMs
Date: Fri, 17 Jan 2025 20:09:26 +0100
Message-ID: <20250117190938.93793-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A9ECGkRnWqDf_2W79RJNRxcNHvLXIIsn
X-Proofpoint-GUID: Po6CqD0bLzXfVJtt5ErFOeF_LRIGa_pl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

Create a fake memslot for ucontrol VMs. The fake memslot identity-maps
userspace.

Now memslots will always be present, and ucontrol is not a special case
anymore.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   |  2 +-
 arch/s390/include/asm/kvm_host.h |  2 ++
 arch/s390/kvm/kvm-s390.c         | 15 ++++++++++++++-
 arch/s390/kvm/kvm-s390.h         |  2 ++
 4 files changed, 19 insertions(+), 2 deletions(-)

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
index ecbdd7d41230..58cc7f7444e5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3428,8 +3428,18 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
@@ -5854,7 +5864,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
-	if (kvm_is_ucontrol(kvm))
+	if (kvm_is_ucontrol(kvm) && new->id < KVM_USER_MEM_SLOTS)
 		return -EINVAL;
 
 	/* When we are protected, we should not change the memory slots */
@@ -5906,6 +5916,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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


