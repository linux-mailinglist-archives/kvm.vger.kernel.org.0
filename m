Return-Path: <kvm+bounces-46976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7B28ABBCBC
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 13:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AF683ADEAB
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 11:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1997827586E;
	Mon, 19 May 2025 11:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PJPwWKiu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBED2750E3;
	Mon, 19 May 2025 11:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747654675; cv=none; b=cNGomb0GtdkSlAwt2WEgQFaSgFINnlHlbVCLL5lZyuQNFZOMjCkS9EfvOJo9zWl0V6zGOqtGB6khqJEnje05bcMyHcdga0XQ6JnijxpJjiLPLacf1SZq0nlZpEB5eWJUtxqRAW9JvR4iH0U70PbtSBHBl7VzXoqPsaTFtKaGwV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747654675; c=relaxed/simple;
	bh=Nw7nrJEaI2VPPAxTJ3wzkm4ATHRDS8sbeeasO5Ka6GU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ntDp5w8XCeDgj/IocfmF8AdzUEOmT8wk+FJyUV6HJzXvbBuwb7w3WzVQOTvvn8lxhhuJh3Z1qLJqbecxgOIpT25jYRQzDfd4loOXtD7B35+fJg4qviaZsf2wGbe0bhB+1isPIBNQKdQuLyiOC6/YmoOFcHZmy2eero0vcIC4NF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PJPwWKiu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J9F5TD016740;
	Mon, 19 May 2025 11:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ztipBq
	FfK/xkEmZ1apT3aFbL5eHhI4LDf8/ws+FyONE=; b=PJPwWKiu2eNSyUOqcIggNP
	cB9+WBntHM0EG4LtEuLqebdZTVd8DSjIgOdDNq2nHnZqiZU8AjM0DQAFmkWlDlw+
	mqOWCT2DEojJCKfibzqXhI5yGYVl+4g8yc1tPB/RKFWPTs5zepMb/eAFtYXFbc8P
	84ZWqbYIGPqTkiBjUIBrcS3R/FN9zGjaAVHO5UYhdLe1gIQVyiSbAJTRWiNRvMZs
	4R5dNbOLH5BJeg3MVC/MDcBRLHifq14hmIeuJ1RGSmQaxcSgyh8YNapbfs8SOjwW
	t40bTu8Jj7rzywpoYrh4U2U7phTHmHxAhuUtWjBTi/RB+8fqKzXai5G8QmGKe1LA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46r1ujrkra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 11:37:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54J9Qb3H013862;
	Mon, 19 May 2025 11:37:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q4st6n95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 11:37:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54JBbH2d34865822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 11:37:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0F2A204BB;
	Mon, 19 May 2025 11:37:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C38A204C2;
	Mon, 19 May 2025 11:37:17 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.40.56])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 May 2025 11:37:17 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 19 May 2025 13:36:11 +0200
Subject: [PATCH v2 3/3] KVM: s390: Specify kvm->arch.sca as esca_block
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250519-rm-bsca-v2-3-e3ea53dd0394@linux.ibm.com>
References: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
In-Reply-To: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4244;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=Nw7nrJEaI2VPPAxTJ3wzkm4ATHRDS8sbeeasO5Ka6GU=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBna4q+d3r5RNp7S5NQ0Jfzou9aNPt+/S0tPTiu9/zmOU
 33fNp6jHaUsDGJcDLJiiizV4tZ5VX2tS+cctLwGM4eVCWQIAxenAEyEy4Hhf1aZ8YEPlo6LtEUS
 fY+ln2uarup876v2hcQTzyfarrma9YHhf/5UrZDaLtZTDyvXP9nf+vxmc3nzmi8izEqG8699lrz
 pzwMA
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qsmeoS-8U7l62BSzJOzgpFEr85vDvCYy
X-Authority-Analysis: v=2.4 cv=BcvY0qt2 c=1 sm=1 tr=0 ts=682b180e cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=3ptpGn01cE8ERRY_Xe4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEwOSBTYWx0ZWRfX/zIsNPvNgANc PKFWPH8u3ByzRNqnl+JT84BepmOAfw8Zv9tWdvBpjEXsYlpISsO/bAK5lY9rNyJlFdPw6+0crxG hw15yhU6RB4e1Fw2MKL7XfoJjWoBSIWPuHdacQv1bUS/1f+e8O3d7O3v4CP//dPM+K3wSN16UgN
 p+T3DnVZXWa0bZIsfJk2VNS+QLqjREgsAmbm22+MBTJxbegrgu/CAZrPhpZxrgiVMnN2BiBt85V gHsUyjc+xt08xUCdvmunoe5huZ/CEKrrGCCEMz/qcYqd475R3AnsU7fcimSkn8eKRd5vI3Sd/iW ownYKVlNkWGTkCbwxsDezfcD4G0FLuKog4e1YfXawtP9hBL/gXoa+Bp3lSz3IXqtztzbvtB3IMA
 r2Su1xRCd6mhaNI6xCSq39bNVZ9lFTI8m09DoHheaPf3SHCaXiM4h9SyIcz8P7Q2spVMVJsO
X-Proofpoint-ORIG-GUID: qsmeoS-8U7l62BSzJOzgpFEr85vDvCYy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=825 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505190109

We are no longer referencing a bsca_block in kvm->arch.sca. This will
always be esca_block instead.
By specifying the type of the sca as esca_block we can simplify access
to the sca and get rid of some helpers while making the code clearer.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 ++--
 arch/s390/kvm/gaccess.c          | 10 +++++-----
 arch/s390/kvm/kvm-s390.c         |  4 ++--
 arch/s390/kvm/kvm-s390.h         |  7 -------
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index d03e354a63d9c931522c1a1607eba8685c24527f..2a2b557357c8e40c82022eb338c3e98aa8f03a2b 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -629,8 +629,8 @@ struct kvm_s390_pv {
 	struct mmu_notifier mmu_notifier;
 };
 
-struct kvm_arch{
-	void *sca;
+struct kvm_arch {
+	struct esca_block *sca;
 	rwlock_t sca_lock;
 	debug_info_t *dbf;
 	struct kvm_s390_float_interrupt float_int;
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index f6fded15633ad87f6b02c2c42aea35a3c9164253..ee37d397d9218a4d33c7a33bd877d0b974ca9003 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -112,7 +112,7 @@ int ipte_lock_held(struct kvm *kvm)
 		int rc;
 
 		read_lock(&kvm->arch.sca_lock);
-		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
+		rc = kvm->arch.sca->ipte_control.kh != 0;
 		read_unlock(&kvm->arch.sca_lock);
 		return rc;
 	}
@@ -129,7 +129,7 @@ static void ipte_lock_simple(struct kvm *kvm)
 		goto out;
 retry:
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		if (old.k) {
@@ -154,7 +154,7 @@ static void ipte_unlock_simple(struct kvm *kvm)
 	if (kvm->arch.ipte_lock_count)
 		goto out;
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		new = old;
@@ -172,7 +172,7 @@ static void ipte_lock_siif(struct kvm *kvm)
 
 retry:
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		if (old.kg) {
@@ -192,7 +192,7 @@ static void ipte_unlock_siif(struct kvm *kvm)
 	union ipte_control old, new, *ic;
 
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		new = old;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 321745580c57dd21070eb5bc30ebab263da7d329..83b4836154893a83523d93f61bd45b1685002b9c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1964,7 +1964,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
 		return -ENXIO;
 
 	read_lock(&kvm->arch.sca_lock);
-	topo = ((struct esca_block *)kvm->arch.sca)->utility.mtcr;
+	topo = kvm->arch.sca->utility.mtcr;
 	read_unlock(&kvm->arch.sca_lock);
 
 	return put_user(topo, (u8 __user *)attr->addr);
@@ -3303,7 +3303,7 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
 
 static void sca_dispose(struct kvm *kvm)
 {
-	free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
+	free_pages_exact(kvm->arch.sca, sizeof(*kvm->arch.sca));
 	kvm->arch.sca = NULL;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 2c8e177e4af8f2dab07fd42a904cefdea80f6855..0c5e8ae07b77648d554668cc0536607545636a68 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -528,13 +528,6 @@ void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_per_ifetch_icpt(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
 
-/* support for Basic/Extended SCA handling */
-static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
-{
-	struct esca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
-
-	return &sca->ipte_control;
-}
 static inline int kvm_s390_use_sca_entries(void)
 {
 	/*

-- 
2.49.0


