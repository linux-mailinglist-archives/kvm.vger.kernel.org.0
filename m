Return-Path: <kvm+bounces-36900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD991A22ABD
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DA817A2CFB
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F9C91BD00C;
	Thu, 30 Jan 2025 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nVWDM4tI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF731B6D0F;
	Thu, 30 Jan 2025 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230689; cv=none; b=GKECeyhS+LLGrsJyFRlcO9XeME5krynt+tYlXUnr0KdRon+StI8NLyhqWW1HpnS/frNBfp9hnrySgVwbB1+Hkr50lwQrEgs76QdBLGwc6vxlHKwFoGC6RvyRp7t0+moeF3ZYEhCMn7ndcHRaf1pGJGAfMw4gnupz2PSYZInl4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230689; c=relaxed/simple;
	bh=PzTHNr9qqKpwNf0Av53oDcqhsk8OY6Od3s7oXhPWvBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+4L+rx98k/zt1rMIi2HFv+BI49Y2Ta6UdfUPwHX3j3tyhUa1Yab4D8HW+CXXW/Bz8XmrFDA4hRdlbBeL5x9igdQcDju7PsNN2gFAsooyI5j8XPHZlt8mm+S/A3tiIZQN2+I4hdmdufsaWUtyMxlNv9/kldcd5LMoS5Vxitoi4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nVWDM4tI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U20fXO019614;
	Thu, 30 Jan 2025 09:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZYM9Nc8rY8p/nTLL3
	r+i4CWuWpEZ55ZZKrZPppQc4Tg=; b=nVWDM4tIJ/SCI64j/Lk/2REoq9DIrhzOC
	A7T1V7tb+yrFXMaeNR1AIHZ2Z4Ic1xfqUcRWpOjthLZd+ZJFBQQdlTQbS9q+Kclz
	4U1+GvrJKqPkLqhI0nBj2lRMPxIdLVhi/60C/+1UQhDiJsH44HETjXabgSjz4n86
	5eR06OqaRUReL1Ki5Wr7/3KFW1uohxl/HgBQBpNGKqCTaRBjNkbBOfQALSliVZF3
	zAhb+X7z+ONCJ8KMiLC6dEgMA4c3ZYbQk1h+ZS9hYvU07s7wfCBhqld/Vi5+bbPO
	4LSZFs863BawnxUEPuoAq2qlmCeh35WF4sqDkxGOUoe/PIZHE57Qg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g08ysnnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U8wcIX019213;
	Thu, 30 Jan 2025 09:51:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9n5fkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pKXh16974202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:20 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7756620142;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 555A820141;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 06/20] KVM: s390: wrapper for KVM_BUG
Date: Thu, 30 Jan 2025 10:50:59 +0100
Message-ID: <20250130095113.166876-7-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: JmxhxOKryvI0OglDZvry3d21UTgd9KS5
X-Proofpoint-ORIG-GUID: JmxhxOKryvI0OglDZvry3d21UTgd9KS5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300069

Wrap the call to KVM_BUG; this reduces code duplication and improves
readability.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20250123144627.312456-3-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-3-imbrenda@linux.ibm.com>
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


