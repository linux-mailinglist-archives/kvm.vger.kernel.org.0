Return-Path: <kvm+bounces-29391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5CC9AA1C5
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1ECE283D4E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240AF19D07A;
	Tue, 22 Oct 2024 12:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HPd94Juc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3AF19DFA7;
	Tue, 22 Oct 2024 12:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598777; cv=none; b=Cnqyz8rBvmme6va1awSUGeEu6vQ859rKUdQdI9EWsFtXnJcW1xVLQPjTC/5nO+PYCTd/6NW4uf3JQQ+evLrSPMslY6u/arTlWSDpciOjyriHdHNGUrzVZRdtOgdeacmyghxGwD/2ggK9sz1Udzl0oHwJ3w0eEojqiQ9WreOVkH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598777; c=relaxed/simple;
	bh=SNYB9kl8yrez8KUjM5etlo/vK5PUvW0MNO0GLb/Elmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PC4TLoqtdxqQBcLmZRaTcucr1+ACx1WR8r1Xm0OQ8T6qtbhTcXH74vmbGcsrrQh+3cOysrq+cE6ocKbUWpDOrnJc8IsV2EOZAMmI/xnetMli0c9UOa327vIxXC1UkFxjFbcn8PA5HKAPvgpDGWvvtZTj/h1SxbnPDz+5bT0HBYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HPd94Juc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HSUN029851;
	Tue, 22 Oct 2024 12:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=END8AhP18F9CTYe9n
	ifD5SEHyRSd505yRrZtToSFHPk=; b=HPd94JucWs91VUSZ0GJJyl26nf+BobLyb
	/etxPQyHvKb9aB4aDevMVvv3TJ+3dSr2kiiRSVHrisFtRf7CUJ+UA2wte4yK6enL
	mJTE+ob99p99ha8Ha2oR7vOZdUe75Y8riU6v05NQVfpwV8f+CjgNFDJy5au3Yz6h
	hURr+pGYf5caSrqZ7bYq2S+C0n01ecT4SazVNuUoYSFUVUOprWiuJJrRMN/IyJFm
	uv2aP07HpVU0vC5Ark3/oxyLOG7J50Iod++/0/+HcAdRjfd4lkfSrJy6dxzVQ47J
	9mk9F6VEdI2JyhTqcPvMJp6fcl6EApn4vwsx4X0uhW4o/ExB/DhyA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5eudry7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49M8GD9t026443;
	Tue, 22 Oct 2024 12:06:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cq3sb9ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC685946203340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB69120043;
	Tue, 22 Oct 2024 12:06:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49F122004B;
	Tue, 22 Oct 2024 12:06:08 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:08 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 06/11] s390/kvm: Stop using gmap_{en,dis}able()
Date: Tue, 22 Oct 2024 14:05:56 +0200
Message-ID: <20241022120601.167009-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4R5dQv_GcPbvK5aOlxcOA5vKLUiNlz6k
X-Proofpoint-ORIG-GUID: 4R5dQv_GcPbvK5aOlxcOA5vKLUiNlz6k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 mlxlogscore=531 mlxscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

Stop using gmap_enable(), gmap_disable(), gmap_get_enabled().

The correct guest ASCE is passed as a parameter of sie64a(), there is
no need to save the current gmap in lowcore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 2 --
 arch/s390/kvm/kvm-s390.c         | 7 +------
 arch/s390/kvm/vsie.c             | 4 +---
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 603b56bfccd3..51201b4ac93a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -750,8 +750,6 @@ struct kvm_vcpu_arch {
 	struct hrtimer    ckc_timer;
 	struct kvm_s390_pgm_info pgm;
 	struct gmap *gmap;
-	/* backup location for the currently enabled gmap when scheduled out */
-	struct gmap *enabled_gmap;
 	struct kvm_guestdbg_info_arch guestdbg;
 	unsigned long pfault_token;
 	unsigned long pfault_select;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 050710549a10..a5750c14bb4d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3719,7 +3719,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 
-	gmap_enable(vcpu->arch.enabled_gmap);
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__start_cpu_timer_accounting(vcpu);
@@ -3732,8 +3731,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__stop_cpu_timer_accounting(vcpu);
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_RUNNING);
-	vcpu->arch.enabled_gmap = gmap_get_enabled();
-	gmap_disable(vcpu->arch.enabled_gmap);
 
 }
 
@@ -3751,8 +3748,6 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	}
 	if (test_kvm_facility(vcpu->kvm, 74) || vcpu->kvm->arch.user_instr0)
 		vcpu->arch.sie_block->ictl |= ICTL_OPEREXC;
-	/* make vcpu_load load the right gmap on the first trigger */
-	vcpu->arch.enabled_gmap = vcpu->arch.gmap;
 }
 
 static bool kvm_has_pckmo_subfunc(struct kvm *kvm, unsigned long nr)
@@ -4894,7 +4889,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs,
-				     gmap_get_enabled()->asce);
+				     vcpu->arch.gmap->asce);
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(vcpu->run->s.regs.gprs,
 			       sie_page->pv_grregs,
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 35e7dd882148..d03f95e528fe 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1151,7 +1151,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	current->thread.gmap_int_code = 0;
 	barrier();
 	if (!kvm_s390_vcpu_sie_inhibited(vcpu))
-		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, gmap_get_enabled()->asce);
+		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
 	barrier();
 	vcpu->arch.sie_block->prog0c &= ~PROG_IN_SIE;
 
@@ -1296,10 +1296,8 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if (!rc)
 			rc = map_prefix(vcpu, vsie_page);
 		if (!rc) {
-			gmap_enable(vsie_page->gmap);
 			update_intervention_requests(vsie_page);
 			rc = do_vsie_run(vcpu, vsie_page);
-			gmap_enable(vcpu->arch.gmap);
 		}
 		atomic_andnot(PROG_BLOCK_SIE, &scb_s->prog20);
 
-- 
2.47.0


