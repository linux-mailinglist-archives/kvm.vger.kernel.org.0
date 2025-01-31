Return-Path: <kvm+bounces-36982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3C9A23D08
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:29:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B124C16B17F
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591FF1F1512;
	Fri, 31 Jan 2025 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CcF996uO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1B1F238A;
	Fri, 31 Jan 2025 11:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322731; cv=none; b=edZvdBvrojMGYnVy9mKaz26sv/F43ZOu9Deg2v34WUHDGroDYqFXa4UfbVH6gIfg9NQFvQx6Uj1VoFY8vwtNIbjW7vpOjHON6bLb7G3MjBxztDkRVuEsAyNJaZn+KVa40mhPmlYmXbS3i8hBdK5KbEHouMTIsSmmMFIsAbfmb2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322731; c=relaxed/simple;
	bh=PzTHNr9qqKpwNf0Av53oDcqhsk8OY6Od3s7oXhPWvBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp1i/RMI5k7EWDltZWeNYauMU7e66wg3yewn/o1V3ix0MefwvD9rqNPVrO8wcOApjcjfEXBgOjZNWa/8Zrow/YJksLZGwOO+sz2WCLkROCq/SlrIonYN9BfKEhqs5lS73ggxksFo8HCU3jXN78c2eBEqEBF2HREZ2bTH7r5EBpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CcF996uO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V7Wdot009488;
	Fri, 31 Jan 2025 11:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZYM9Nc8rY8p/nTLL3
	r+i4CWuWpEZ55ZZKrZPppQc4Tg=; b=CcF996uOBvQ+ddm5EDnTov78jedDoUefg
	79bTniEvQ97xsXhTbp7zfCXf9xruFBzZ0qIDfaUz7PqV8bFuBWDxzokSRs8DZ5XG
	/sMpcprlNwC3XDDPWbFB1Lv/c1hsFFASVFsTSwjkWhFeC3LdzZebzSP3ybhHuyRI
	8TQS90UqyQQqB+5+fBU4EMw73YONy1id6fuNCJaYaJz+OPZzY0qSYEwzRMO12TIU
	HnZcpBviv2u/t1QWRRUezetNMzW62OTOlVus2wj1zLVdhZ0Ndw9jwtBmgHEYNsjt
	4sA/YiioHlTBM39CT1InR353OdKSQljfHzcNCAwq/hdfdFoGAJI1Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gt7n8v3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V81VsD013887;
	Fri, 31 Jan 2025 11:25:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44gf93b9fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPMeW56361286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8C3B2012E;
	Fri, 31 Jan 2025 11:25:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E22E2012D;
	Fri, 31 Jan 2025 11:25:22 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:22 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 06/20] KVM: s390: wrapper for KVM_BUG
Date: Fri, 31 Jan 2025 12:24:56 +0100
Message-ID: <20250131112510.48531-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: egM4dqJ3bmmpq36U7r3pGeizlGi2NwLE
X-Proofpoint-ORIG-GUID: egM4dqJ3bmmpq36U7r3pGeizlGi2NwLE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

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


