Return-Path: <kvm+bounces-29389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C33A9AA1BE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F3FE28397D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39BA19E826;
	Tue, 22 Oct 2024 12:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VTH1HxOH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8B19D890;
	Tue, 22 Oct 2024 12:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598775; cv=none; b=uA3HJShXUhG9ns6m6tuGXst5VpzNSdif9GePt2kjrtS0Hi+LgnpNLq9iNSoWRvEBqZyJjDW5gpNYRJMt/SLv5otXJSBKJCansJjjLRidWK+2ZsqkIapHnOPAO8q+jtcTyb9+xqqPit+OYFNKOVE5fyYiu0oqf5iXCSUxekoOPlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598775; c=relaxed/simple;
	bh=QQvuMDB3i+1hQRxxMhfrS1fUCS2QiWa5R5FPahhxnCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xwzd5Q23GIDhswNLwV2lKsBW8TFskL32vJB1qSRzBxrz8r+fB8GSLG2Us+lgqT3Qu2EtwJjSDy0ycEVZLMdh+3TH9aWzSl8/YrNApk4lCitdbx4zbRT32+GuPVO17AkGyBmuas3qg6RE0SKojv1bQ0AAulYFDtMmxKsvQHnZg64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VTH1HxOH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HCRO005367;
	Tue, 22 Oct 2024 12:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=smPbVVUTPeubekiFB
	5BI/e3FMoGPpsz1X34wv6nlTYY=; b=VTH1HxOHia+uxp2ywIGK1LKs8ybLr2ivJ
	zar4CA/1gLzU3acoW65jf15HTT4pcJpaTWAYcgLTkJK/DFvDh8O9E/7DXpTZT2z5
	fpQUdk+nVSfiZFLDEeXe/PLi5/U83VTAdHP4UveWX+65BnJ8P26CFZvWVPDZ40qr
	MF4WbFidlXY8uPbozCWloRBKoUrxs22MRLN+2L172SwvOMRVjphAOThu6OqxNEYz
	vvstuFpm8pfZlxvdBp3OhJfhb8a+jNuHLffwfUmUutUGgL1K0f1XEE5ff6F7UvbB
	SwEjkkPkT+8FKrp7uizBVTo7PhwiiKmo/OnQIId1tWnRHpiHqaXPA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5fcnqer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49M9M438009312;
	Tue, 22 Oct 2024 12:06:09 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42cr3mu3xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC65g443975096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB9A920040;
	Tue, 22 Oct 2024 12:06:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96BE72004B;
	Tue, 22 Oct 2024 12:06:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:03 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 02/11] s390/kvm: Remove kvm_arch_fault_in_page()
Date: Tue, 22 Oct 2024 14:05:52 +0200
Message-ID: <20241022120601.167009-3-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 9nGNns7ZY--qaPU5mnPegO9Rbu9VzTaQ
X-Proofpoint-GUID: 9nGNns7ZY--qaPU5mnPegO9Rbu9VzTaQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

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


