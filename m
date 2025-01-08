Return-Path: <kvm+bounces-34821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 762B6A06425
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:16:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AB8A3A36ED
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F87204088;
	Wed,  8 Jan 2025 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ls2B6z+s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEA201017;
	Wed,  8 Jan 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360107; cv=none; b=LgiMWWYdRiS1TW8QHvciOwbGpVZ2SUGMICPlzM8Q4T7BT2SCxWgCYHifxZaeoGVT/lRlTCSdMPr/V50GXRQG6QEQHQiQyUL9MCknbEpX6LFftRYqVwmYI/P/SZ26JPuVRIupuLiizVXfaqg5egnEx5HV/UvBVZaCZ8MPllLJLlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360107; c=relaxed/simple;
	bh=ETt/xA/799Jj+J24zF+hZNALRfvBH6I1s8tdvEVHpdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2vYkGXuGhYD0OIVeNai+9EjWshFTN4QlBXXbhRZ9TYRGaartHFyBNtRxvgr8+j0i3A9Bur9QSRFkqIK+lKrYpUPaMWhKFQaf5SQg/FljiEGhJWtCCPze2QxtrQvkCugrK2FGn24jM5wqg614eJ1QDnsW/0T4N2Or+bkdJGLpoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ls2B6z+s; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508H7haF022826;
	Wed, 8 Jan 2025 18:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1xL1S2m4Fudj4F5j3
	ErBey6rBZqZJeZ2evur5glqkdk=; b=ls2B6z+slLm5HZMu4T+RxU23WF+mhEjau
	aeo6C/qekIcOVwmoZnhkoL/9YKE/pfjdetnoEArhALzpjTyQqZVmU9oDrSYxvxgr
	oDxN4ixyl8/HXPm+oacgsnEyIcBgL9zO9cJA3B649z3WK8jDsb79CweoL5+nl3rH
	Ssy0EokkaS7oxzw94YbxRtICeDR5Oiffp7zHWs/VLXWpRMIByKPlt8UKBptuGAhY
	/bltG1GXJ+odfdqWsILq3aQG6qCkPjQVyYgpVUcTDORqGKVXCqGa75Fu0pWeEjtb
	XJuRNeb1q4mn1s8ompqa/EuKWhkQ11NBDm1m0RWZikrlBxzG97rLg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441nj3aqbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508H1c93016669;
	Wed, 8 Jan 2025 18:14:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm106r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEqw059376054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B0B820040;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 647062004B;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 01/13] KVM: s390: wrapper for KVM_BUG
Date: Wed,  8 Jan 2025 19:14:39 +0100
Message-ID: <20250108181451.74383-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ztJtZv_KvcB6PLeNHOtbJSGgokopDfld
X-Proofpoint-GUID: ztJtZv_KvcB6PLeNHOtbJSGgokopDfld
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=983 phishscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

Wrap the call to KVM_BUG; this reduces code duplication and improves
readability.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d8080c27d45b..ecbdd7d41230 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4766,6 +4766,13 @@ static int vcpu_post_run_addressing_exception(struct kvm_vcpu *vcpu)
 	return kvm_s390_inject_prog_irq(vcpu, &pgm_info);
 }
 
+static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
+{
+	KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
+		"Unexpected program interrupt 0x%x, TEID 0x%016lx",
+		current->thread.gmap_int_code, current->thread.gmap_teid.val);
+}
+
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
 	unsigned int flags = 0;
@@ -4781,9 +4788,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		vcpu->stat.exit_null++;
 		break;
 	case PGM_NON_SECURE_STORAGE_ACCESS:
-		KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
-			"Unexpected program interrupt 0x%x, TEID 0x%016lx",
-			current->thread.gmap_int_code, current->thread.gmap_teid.val);
+		kvm_s390_assert_primary_as(vcpu);
 		/*
 		 * This is normal operation; a page belonging to a protected
 		 * guest has not been imported yet. Try to import the page into
@@ -4794,9 +4799,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		break;
 	case PGM_SECURE_STORAGE_ACCESS:
 	case PGM_SECURE_STORAGE_VIOLATION:
-		KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
-			"Unexpected program interrupt 0x%x, TEID 0x%016lx",
-			current->thread.gmap_int_code, current->thread.gmap_teid.val);
+		kvm_s390_assert_primary_as(vcpu);
 		/*
 		 * This can happen after a reboot with asynchronous teardown;
 		 * the new guest (normal or protected) will run on top of the
@@ -4825,9 +4828,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_FIRST_TRANS:
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
-		KVM_BUG(current->thread.gmap_teid.as != PSW_BITS_AS_PRIMARY, vcpu->kvm,
-			"Unexpected program interrupt 0x%x, TEID 0x%016lx",
-			current->thread.gmap_int_code, current->thread.gmap_teid.val);
+		kvm_s390_assert_primary_as(vcpu);
 		if (vcpu->arch.gmap->pfault_enabled) {
 			rc = gmap_fault(vcpu->arch.gmap, gaddr, flags | FAULT_FLAG_RETRY_NOWAIT);
 			if (rc == -EFAULT)
-- 
2.47.1


