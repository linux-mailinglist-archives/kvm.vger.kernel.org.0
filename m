Return-Path: <kvm+bounces-53975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 954E0B1B280
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E57317A8E81
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 11:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E9E2580CF;
	Tue,  5 Aug 2025 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xgwn8NEr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3B0242D95;
	Tue,  5 Aug 2025 11:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754392497; cv=none; b=eRQcEQNq38O0sFg1tfr4uIGYO+FQxIeb97lwQoMc17LQgz9odUrTZOZXChNA0MDgp9s3QCShnZpXDW1n4h8PGLO+F7pZdZav5SCThForeQK+qurBZNZnmvsTNSKKNrJQ7t5HA8jXtNofXKYoDTeBn4Kr/w1xZfIvBbh9ziPfxRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754392497; c=relaxed/simple;
	bh=fT4PVjbIttQ+I2fOgnz7uxbClH9nkzTOZRn6wzEwXZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A97tS5GcW1sKSdTWjOjXG7BRDF4eJmIlNWG1TXumPt6n4kt0MxHpagK5ZOX41JTAGtqm7oUUYMJPaHdR3UhdJVw2Y3MaeeyYSCLtHWyAyOKiQOqDqCS6eV+0kqLWMMLkR9UfWyWXGlPyIdbLvv/Dy8VD+9636FSFDj687TOAuKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xgwn8NEr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5759BDVN029477;
	Tue, 5 Aug 2025 11:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eeoNbR0P8N0+CAzaa
	g6/xKSEmPLfNNvdbz6DqfYnHE4=; b=Xgwn8NErHhhoRHZojd4F0xJi6UslNmTLp
	V04eqooXx3jdxOmKRieZYaAr3562rZNgqjV9cbsdYtW6nEN0fLXSZfFJ8QclvbBK
	B62BXKo+pmp0ZHaqc/M+TEaLRHHo/sJ0zp0POVZZfiuEgn1ocCkrh0zr17KyNDgv
	49HpuiD7/Kba2nQOkkM3z67OhjZ/1SsDgfy/wHWEO5rLS24h7aAq8Ioild49WcoE
	eH2wCaESiNgHuYTmxCvcptLJ2+5AH4eRu/sPI53LNy5Y0bNM9mid/G2EPpL3+cdr
	oJd793kEhyrx3CL5imh870PKIMi9fVbdfAuc5ZNEuvb1YxHK0h7hA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48a4aa22gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:14:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5759AGdB009533;
	Tue, 5 Aug 2025 11:14:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489x0p23t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 11:14:50 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575BEk7o53281054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 11:14:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9A3420040;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B39722004E;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 11:14:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v1 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Date: Tue,  5 Aug 2025 13:14:46 +0200
Message-ID: <20250805111446.40937-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805111446.40937-1-imbrenda@linux.ibm.com>
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sO-VHp9bQhYLmnaiaGpIMBnGRc7pe3G-
X-Authority-Analysis: v=2.4 cv=dNummPZb c=1 sm=1 tr=0 ts=6891e7ac cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=IkDFlU1nzIcPcoZqbnMA:9
X-Proofpoint-ORIG-GUID: sO-VHp9bQhYLmnaiaGpIMBnGRc7pe3G-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA3OSBTYWx0ZWRfX7SwsANoqEonD
 Txivh6pmbg9zAgrSFP0Ruj5QH0sOLnz4mZTnClF7fQaDGpjWQ66orfme1vv4ZpzNU8qUNyg3jTL
 3CdXPLzZ+Ug7p6VSX72SoTU+onfCH3OInI17YUPQaWPjR0EFHiJhxdjCDkAM9+BAozCO4+Mxng+
 YeuQbx24YhP5/Qx1z2ipQkzRGUK1RR4+KLnVWPZJzcRtmEEmnhhH+vjxanMgLd80w86885/62EV
 ehNg+yREyHa49LH32TepD/oVIT6FQ9djjP7WPbSrM0jcGiw/CgUnZKVut0CTxM9SRUjuMAlJYui
 3RAOG1VirXg2h3aERUQrbtDK/4JwdbYnhlc/HW+QmDXXOzvbgNvVfSZQ2sjNEk4CffYXKiaVosC
 p0j+T8XgjiY1RyAvdVbjNebI3JDfJe/Hh9Ql5L2EtZGtRv8L7poHO/Fm7qhOCCwhFueeH4zR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 mlxscore=0 clxscore=1011 mlxlogscore=886
 malwarescore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050079

Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
instead.

This still works because they happen to have the same integer value,
but it's a mistake, thus the fix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
---
 arch/s390/kvm/kvm-s390.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d5ad10791c25..d41d77f2c7cd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4954,13 +4954,13 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
 
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
@@ -5002,7 +5002,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
 			break;
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
@@ -5012,7 +5012,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
+		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
-- 
2.50.1


