Return-Path: <kvm+bounces-28920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA20B99F309
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB5B31C22341
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38978212D0A;
	Tue, 15 Oct 2024 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LMl3GBR8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419641F76A5;
	Tue, 15 Oct 2024 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729010616; cv=none; b=K/ai+jrAytGME2cZ1dC1DZTopJr4e2USx4+D7hf7FGMOpuPXXNO6D6Epm7VM9tj42uKegJD1JAV/KRXWrLHjsesrQhSWs7AO1z+wTzo9qd1CqfnsOYNhGIregHQ4vxWw4qgSTTyxLPohhiMS4QTZRiQrYd1FeVOl7PR+v/y4bMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729010616; c=relaxed/simple;
	bh=QQvuMDB3i+1hQRxxMhfrS1fUCS2QiWa5R5FPahhxnCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDjGTa8IGHxkVvDE1oARLmFPSvu4HHVvN6bx0rTadfGrY3r3/veZBkS2M9Qf6ogUpQe4PX6/Ejl3iEgO36XdpuUbN0ly1cVMdkA0coFC33YqHEwLtqLXWdoKcwaLtFjK5p0L5j3fA7hA/VJeAzKkiEi61rc7jiut0tTCa5Kh7jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LMl3GBR8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FDJiNC008390;
	Tue, 15 Oct 2024 16:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=smPbVVUTPeubekiFB
	5BI/e3FMoGPpsz1X34wv6nlTYY=; b=LMl3GBR8domXCMBHAciEKRP09HA8QXCLf
	6HFOUuVWx3NyW6gFv0jLaYy68JEkdGitXcSBNXhK+IRimXh64AcwhTnkyu95Touo
	4Q37rh1AhZC4mIfdPzHbh/gbC8NepJKceTUORDqR4gg2/b6m9kvSL5cxr+3CYvIk
	wiERo9htE7TITErxtICKg7oOMSawOBTzMXXWO54b3HG0pM8pFkLwgMhbTTYwC6St
	5Olwe0HajogZ6+TB7eHMr6w8y+GnflAqmSvPFXkLm3oO00H4KSItmE/JxAghW+/6
	k3zW24QhaEah1WVH+HMrWA/A7qZ3TQNHxMUOQnLTvtXXbMcrToWtQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429s68h427-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FE4dMF001991;
	Tue, 15 Oct 2024 16:43:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284emmxav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 16:43:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FGhRsF49545568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 16:43:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 316C520040;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0952A2004B;
	Tue, 15 Oct 2024 16:43:27 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 16:43:26 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 02/11] s390/kvm: Remove kvm_arch_fault_in_page()
Date: Tue, 15 Oct 2024 18:43:17 +0200
Message-ID: <20241015164326.124987-3-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: fcOfuIXcB3I3Ax0CZ2Xalrx8EV9U60P3
X-Proofpoint-ORIG-GUID: fcOfuIXcB3I3Ax0CZ2Xalrx8EV9U60P3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150113

kvm_arch_fault_in_page() is a useless wrapper around gmap_fault(); just
use gmap_fault() directly instead.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/intercept.c |  4 ++--
 arch/s390/kvm/kvm-s390.c  | 18 +-----------------
 arch/s390/kvm/kvm-s390.h  |  1 -
 3 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b16352083ff9..5bbaadf75dc6 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -367,7 +367,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_arch_fault_in_page(vcpu, srcaddr, 0);
+	rc = gmap_fault(vcpu->arch.gmap, srcaddr, 0);
 	if (rc != 0)
 		return rc;
 
@@ -376,7 +376,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_arch_fault_in_page(vcpu, dstaddr, 1);
+	rc = gmap_fault(vcpu->arch.gmap, dstaddr, FAULT_FLAG_WRITE);
 	if (rc != 0)
 		return rc;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bb7134faaebf..08f0c80ef5e9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4579,22 +4579,6 @@ int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clo
 	return 1;
 }
 
-/**
- * kvm_arch_fault_in_page - fault-in guest page if necessary
- * @vcpu: The corresponding virtual cpu
- * @gpa: Guest physical address
- * @writable: Whether the page should be writable or not
- *
- * Make sure that a guest page has been faulted-in on the host.
- *
- * Return: Zero on success, negative error code otherwise.
- */
-long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
-{
-	return gmap_fault(vcpu->arch.gmap, gpa,
-			  writable ? FAULT_FLAG_WRITE : 0);
-}
-
 static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
 				      unsigned long token)
 {
@@ -4797,7 +4781,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
 		vcpu->stat.pfault_sync++;
-		return kvm_arch_fault_in_page(vcpu, current->thread.gmap_addr, 1);
+		return gmap_fault(vcpu->arch.gmap, current->thread.gmap_addr, FAULT_FLAG_WRITE);
 	}
 	return vcpu_post_run_fault_in_sie(vcpu);
 }
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index e680c6bf0c9d..0765ad1031c4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -394,7 +394,6 @@ int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
-long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu);
-- 
2.47.0


