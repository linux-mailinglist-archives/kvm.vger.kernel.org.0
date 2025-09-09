Return-Path: <kvm+bounces-57102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A96B4AD01
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E65B3B09A0
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B054322A26;
	Tue,  9 Sep 2025 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bQfX1f1T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A468C322DAF;
	Tue,  9 Sep 2025 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418914; cv=none; b=LhTsW2B6533ryXIgCy9Y+pxR0meHGZXoKbZDUvTP2fuME/L9oAjbQJJAqHcB713HV+Yp3XTVHGORW6A+5q9grnRjhGum8fD1g08w8PtvQOZwvEGecY8WZOG818+3mda0wl2sD+UWINyghpAY/D+VtB8tEb3nFFEkcSomBG7JJa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418914; c=relaxed/simple;
	bh=zF1ZQ6RB+26uJISMSmJMJhnVKtYES5dgglmBREviGao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtaKUIhI75J4fyGfh1EqREUrKCYOql4KqT9q3cmWEppKaSol5+TOaTli3tXKzXsYsCGErEh7mxI+SIyZV/UKs1mJO1wb3O+dbb3JeSwl3mG3qwCub8aIgPcV4Kbo8oUIob9FwaUGDcW7/LVSXkhEhLJp7mNzY1kHebH4hdAYUxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bQfX1f1T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896GkTT017992;
	Tue, 9 Sep 2025 11:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hq2VMFF1b0WrGoSAz
	HpxrE9H5syU+jcM2e7O0tHEXbQ=; b=bQfX1f1TlSoaQvbMIoHKhheyXLGJdshlM
	uZXKM+y/0mgdROYdvjYwX4Id2qnTVwNeyH3xujHfh/+kLBrQNTkBGf49eiub+iFl
	B/8UzoG3Bm4k3wrq0KaVIUSvYdOv+IvHWcOL3KIUWh21YUeM4djgS7nQbK2MpkWi
	dkwAoFHD9DA8eVy1x1e6xd7X4QkSTQ8fKecdTkYOfkvvUPRqJqvIeY1oCo4GvZm9
	bMfNZh05ioRI+6fZ0dLuXoXDnLqsK7LrXZ86i0fm51K5G9bDXfk5eIWWM1Edr4DE
	J3EO36kPDlamiiXPuT/9lDZTIe5fSeMdc9o/8a5uTlXMWOqi9OiXQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukecp7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589A6Tj3010588;
	Tue, 9 Sep 2025 11:55:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910smtvmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589Bt5uu9306498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 11:55:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7413020043;
	Tue,  9 Sep 2025 11:55:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1414B20040;
	Tue,  9 Sep 2025 11:55:05 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.111.71.18])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 11:55:05 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 3/3] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Date: Tue,  9 Sep 2025 13:46:15 +0200
Message-ID: <20250909115446.90338-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909115446.90338-1-frankja@linux.ibm.com>
References: <20250909115446.90338-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX32lhu3nWjKm4
 y7TOC3Uxjh2btVrfOKqBnTXJzC5r9+XBX0kdUyN3WYereHTtGOE1x4F3O6oy8X++15n+LeHxrYS
 zloHSgbvmosU70Snra3w/Fxdez07TlkDViix+h6TnpczxxB/WTWnKa3bnittabeJbRETQuNj2nR
 0/fJpdTjI5C6wYAmh10rEe0kL7Odi/L+F2OlclvYC9bbWOWa4pLcUGg9ZlOmOFCKJdQwqrs5jMO
 trFLOtdRuRqV6LsoSPsAjEuBJkU+T94OKQiVdW427FyukAZYwXCQVRxVivmCf2Z1GE6eX4tE+az
 Frm71CIWfOC8btTeCZZQda4U3Mp86IYAtlTaMy6acAOnnNZ3AJRqott2mTQXyMcSZyK6vrJQL5p
 vDb3JKu3
X-Proofpoint-ORIG-GUID: MlIqhqC1yfgA9XF8HwrvbrhVamZoeJGt
X-Proofpoint-GUID: MlIqhqC1yfgA9XF8HwrvbrhVamZoeJGt
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c0159e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=hH8_rHouDUwXcPhP104A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
instead.

This still works because they happen to have the same integer value,
but it's a mistake, thus the fix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bf6fa8b9ca73..6d51aa5f66be 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4864,12 +4864,12 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
  * @vcpu: the vCPU whose gmap is to be fixed up
  * @gfn: the guest frame number used for memslots (including fake memslots)
  * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @flags: FOLL_* flags
+ * @foll: FOLL_* flags
  *
  * Return: 0 on success, < 0 in case of error.
  * Context: The mm lock must not be held before calling. May sleep.
  */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int fault_flags;
@@ -4883,13 +4883,13 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return vcpu_post_run_addressing_exception(vcpu);
 
-	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
 	if (vcpu->arch.gmap->pfault_enabled)
-		flags |= FOLL_NOWAIT;
+		foll |= FOLL_NOWAIT;
 	vmaddr = __gfn_to_hva_memslot(slot, gfn);
 
 try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
+	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
 
 	/* Access outside memory, inject addressing exception */
 	if (is_noslot_pfn(pfn))
@@ -4905,7 +4905,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 			return 0;
 		vcpu->stat.pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
-		flags &= ~FOLL_NOWAIT;
+		foll &= ~FOLL_NOWAIT;
 		goto try_again;
 	}
 	/* Any other error */
@@ -4925,7 +4925,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	return rc;
 }
 
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
 {
 	unsigned long gaddr_tmp;
 	gfn_t gfn;
@@ -4950,18 +4950,18 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
 		}
 		gfn = gpa_to_gfn(gaddr_tmp);
 	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
-	unsigned int flags = 0;
+	unsigned int foll = 0;
 	unsigned long gaddr;
 	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 
 	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
@@ -5003,7 +5003,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
 			break;
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
@@ -5013,7 +5013,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
+		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
-- 
2.51.0


