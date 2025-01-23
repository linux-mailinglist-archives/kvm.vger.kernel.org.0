Return-Path: <kvm+bounces-36374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4901A1A5FA
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69D883AA4C7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 14:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C82212F9A;
	Thu, 23 Jan 2025 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pHg5lomh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EE220F971;
	Thu, 23 Jan 2025 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643602; cv=none; b=GVIvxCgY9MJP1t3KT9LeyIXgzgWPv5avuKnPM5MYlTgBR0qAlxfc8wD9pW/T4Fh6N5l1OMJsuCdTmSh3+npixoASeKauXum5bWlcY7PSGjn+JOtnYMs0JN96P21JCl8CErdLvKTB3l7k8c/xfXcZj6AB/+QEHaP1ArZyO//RglE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643602; c=relaxed/simple;
	bh=2xuQ4KozImQs+XszIczakzFKzIdO/kqIxVnz7/vNPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKooP7MB1Vtb9/L1qL5V6d6jQfNFB1GdBXc0xSuJquVQ0emhBLhG2MasCdmZdLLXKnf1qzjjQirpp0SOItoFUowdPfVwIJ4OwXOnTRM96ag33vywKKez3UYwqiwQz3Tk9N/3MtRy1cDYkPZmXBR21yNMVuZNzeUs1zxtDaVysIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pHg5lomh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NBjZXJ021030;
	Thu, 23 Jan 2025 14:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5vYISw+lfULO63wkd
	CLlhsYRmrRGSDrbE0mRRtqPU0I=; b=pHg5lomhmtAy/PxXudbxx8OEFccp1GHA/
	suyVwOFsex/UJnopm3oMA/dJwpSXAAo4q1nPr7CO+YFukyo9/skfqvbX8xerRixB
	XSIv8xnAW6DZRNLzXPPP2YuEx2V2GW4+aRK5rOsF4nyTnvMFtcxCayzigalfQNvS
	a6Wzp6JbUxTvLfC9+8harhU733i6piWLJ3kKmHg2vMdJBAfyTK4Bt6uveKGNawyK
	2hZ3HM6DHzEVCd43p8uXYzOAE7eoR21ZGwFARWXZG/u1gxV7zxHGtFbIRfjLJ4y8
	bEFdNXP+hH/QZyciYQaa0msiTFsqJ2VV+/kHmWtjYkzXR9kgnM2qg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bbu9bh69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:34 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NEcA7L005118;
	Thu, 23 Jan 2025 14:46:33 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bbu9bh63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NBkxd2032266;
	Thu, 23 Jan 2025 14:46:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 448rujwmcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 14:46:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NEkTSn32702976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 14:46:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31E8F20040;
	Thu, 23 Jan 2025 14:46:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0CDC20043;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 14:46:28 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com, pbonzini@redhat.com
Subject: [PATCH v4 02/15] KVM: s390: wrapper for KVM_BUG
Date: Thu, 23 Jan 2025 15:46:14 +0100
Message-ID: <20250123144627.312456-3-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: l5e63R66OT67iL3iEEHu9IMrzvcbc_5Y
X-Proofpoint-ORIG-GUID: 7qN69K7-IKjXA50rV4woiXHm-_-EcKyl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230108

Wrap the call to KVM_BUG; this reduces code duplication and improves
readability.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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
2.48.1


