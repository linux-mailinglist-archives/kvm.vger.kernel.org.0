Return-Path: <kvm+bounces-28915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F09CA99F2FF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC7D1C217EF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAC01FAEEE;
	Tue, 15 Oct 2024 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Rxg1s+TK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990CB1F76AC;
	Tue, 15 Oct 2024 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010615; cv=none; b=GhvCE7W4iUB3lFKG0Iy8ethaKp+dyyCTsO4QkrysEwaiCQcyJU9nGPKVI94wu42CVVUw/6HtrcV4OSLDd2ChM9i34gUK3qt3B5pj4Kil2xU+HSIvKJcxj1A6ROg0HM/cRLovcMYyJ8+VemeoQzwqgAWN35fFANF5K2qUmd/3Wks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010615; c=relaxed/simple;
	bh=kT4zk9z21wrdHKXfV1g/GKAsZZM+f6ovKFhpjkJtAb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1WmBh28SeVtCHPNlPLRq1KpCIWVjl73csZ3pmtn+FZMQtxAzk8yLS2u7etFrrdxlhGYtMZVJigyQtXdX+gJJM5TBtq3mqMLfLi5jNRX9BsWyO5tyjul39JXfl4sAiWsTykepF1qpmd0Qp+3WIgIHUE34bZeAAAzBl3ZttaDD80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Rxg1s+TK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FGQYvF019569;
	Tue, 15 Oct 2024 16:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ISMevC/t9VZZMZv48
	gp/v+tTh8H+6JLghhUezTk6Boc=; b=Rxg1s+TKFMw8soUzgolZvehM0vHB/VwCd
	vRGk0TZtt/w4VSlpctmu1AwYtY+DWLy7HgRASbAa7rlgf0tY1bI8pn/lCqC6x19y
	3IesLetLTZTJSDnVUIK92hhWWTEJI0pISWZ1GpyIsCnJsrl0zuDXLKAssozJ1I5E
	T0xDSgch33qt8x/e9qAOETT8+BgUneUIQwGneX017q5KlSOfcqGt3Q3ixcoBS+TA
	PwLgzRw3VQjX5ubFjYit7w8TuYCxWuJgY6PMZPqJnkz27MW0cz5nHG+ESteSFnWt
	IdetM6wdyv0QVUSv7RDkPlxL1FKk0Ht9XXZH0I0oaQzVYT/cqjdvg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429uwjg2gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:32 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDfnV2006674;
	Tue, 15 Oct 2024 16:43:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4283erw4c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhSwN50069772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00B9720040;
	Tue, 15 Oct 2024 16:43:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDC572004B;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 06/11] s390/kvm: Stop using gmap_{en,dis}able()
Date: Tue, 15 Oct 2024 18:43:21 +0200
Message-ID: <20241015164326.124987-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015164326.124987-1-imbrenda@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4uhVyAa4UzdxKKO3uM6y5Drv81cT-m-L
X-Proofpoint-ORIG-GUID: 4uhVyAa4UzdxKKO3uM6y5Drv81cT-m-L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=489 adultscore=0 clxscore=1015 mlxscore=0
 phishscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

Stop using gmap_enable(), gmap_disable(), gmap_get_enabled().

The correct guest ASCE is passed as a parameter of sie64a(), there is
no need to save the current gmap in lowcore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 7 +------
 arch/s390/kvm/vsie.c     | 4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cfe3f8182aa5..df778a4a011d 100644
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
@@ -4891,7 +4886,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
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


