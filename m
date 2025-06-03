Return-Path: <kvm+bounces-48324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD9F7ACCB8F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C260C16AD3B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123661DE2A5;
	Tue,  3 Jun 2025 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U8Izts36"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6727C1DDA1B;
	Tue,  3 Jun 2025 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748969871; cv=none; b=mIezVAZg2KCFxaQBHfGVoLr2UrIHEPNtY04/fDtC/Ff8yZQLVKMxusQsOByzgcSBHXUNZMvvvydEp4jShGZEYJQwyEIS3VAYyaMeqIoXlbNg7DsJ+gPlP6jHv5juqDNrx1iboNld6sFYN2p5H1y1HPFcUpKMpJGvxWnMemTk56A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748969871; c=relaxed/simple;
	bh=YkOJx7nU9babQvLei80aGUeDiwUQYhsjD+D8YMm9qUc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=riOfFIfif0nKDYyUKtvwQz5mwJV5JbyUN4s8o/+8o4/WlNFc03r/jJYSxiaQKiOgyqRNWVwougCMD49d5HvlBsG3liI27hL/cw/AHle7GUtqjZJ5quT2ChtkxrTua9irIgYAQRBjWpC2EonB1saYCzm1np4sn0WlafgDvGEM/IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U8Izts36; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553G8jEV019321;
	Tue, 3 Jun 2025 16:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=lHYtJs5DnylKbz7LQmUREW/jjZTD
	KKUDbmjvKbRSfm0=; b=U8Izts36Jau0Uplwh3lVOFnbUtNlMg+lzNhJmctu4cwC
	khbD2dcD1s7Wn+3EYxSjM6Q1ZDUP4uXgGz9UdvCyRlYTxc0LHThZPpFNLJFB3Tzq
	JjT33641e7LWQRrSLCG3yHVajjLAbXL6z6VcN6EQWWpcblop6vAWgaWWH+2L83GF
	XMajjtyEcCq0VI5OIeUKhDASwCQ2IRUtt4uBbmCORbi9s558a9mpoFu1LoS5+N/M
	e/H3kEHH4nNpuUWNwogNBM9CSd9T/0J4Tpy0BKrTgnrAUQjWRMAnznF5Onpba2DQ
	2aCAXFMaIUzvjhQyjS5FWxRKR9vIlOkpmsNIDkiDTg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geynu4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 16:57:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 553DwSiJ022527;
	Tue, 3 Jun 2025 16:57:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 470c3tc03f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 16:57:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 553Gvfsv46662134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 16:57:41 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 595BF2004D;
	Tue,  3 Jun 2025 16:57:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC05D2004B;
	Tue,  3 Jun 2025 16:57:40 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.43.170])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 16:57:40 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Tue, 03 Jun 2025 18:56:48 +0200
Subject: [PATCH] KVM: S390: Remove sca_lock
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250603-rm-sca-lock-v1-1-9793548480ea@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAE8pP2gC/0XMQQ7CIBCF4auQWYsBFKpcxXQxTEcl2lahNiZN7
 y5tFy7/l7xvgswpcgYvJkg8xhz7roTeCaA7djeWsSkNRhmrnDIytTITymdPD9lUpJnQWBM0lMc
 r8TV+V+1Sb534/SnosI1/04tVtPqwiGEhMWg+ueMZCSs/2gUMmFlS37Zx8GJ0e22hnucfkXTqM
 LUAAAA=
X-Change-ID: 20250602-rm-sca-lock-d7c1eca252b1
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9405;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=YkOJx7nU9babQvLei80aGUeDiwUQYhsjD+D8YMm9qUc=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBn2mi2PWJS2/HqU9zG+9Mjnil1p279VpPAfNbK9ZGH8b
 sWjK+G7O0pZGMS4GGTFFFmqxa3zqvpal845aHkNZg4rE8gQBi5OAZjIAzVGhnc3m081fe/61zPV
 qWPjxkD+fYkHztoszwx4mmAz6eEk/vkM/x2u7fM/r+0YYV0ez6Oa+T07vLnS3Fr/6GFnFpWAoL9
 MHAA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GW4BSVZadBcl-JXJWOj4Ys3xFY-bDG3t
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=683f298a cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=HuE_NSwBh0w7oDnXugYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GW4BSVZadBcl-JXJWOj4Ys3xFY-bDG3t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDE0NCBTYWx0ZWRfXyWozJVre66W8 wgjAIFetPo3dK34q/X3P9asq2KpPmMFt5ffaYwYYapXnOXO0IP4HwAkH+u2pOKwGjF6yNWUsIOw rObxRUE6i4RlAernj5Rg2pDb6q1PsM9oSAFPbfhWbBPkKSjjmYTAvozRHq8tRmtltXtiZmgtXvN
 aRQdYefqhRwp7o8nFubMOPlQHaz6ksREmQweUr7klZFMqGRZI2elGeynWU4tQA7Qu3FsrtzwSDV 7ck1NrtJhFgaCMIo19H/wBx0sUDUif3+XuQb3nCJdlSciqnMVfk75zBKXaWLKgrQ1S6c7m08X6Z qqhehjY1Du79K0Gch4S/772J3S3NdlmCvQmbeQCs4zEXtQ9Ujs7UmAoOmPGBH7STLK/PmULSLFa
 qMgpfMzldZ837N7qsavNY33uN4yImzbIOEz0OiCHbARPNIAo2X7iNYy/Pao2tIMShn0NCH/Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_02,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=994 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506030144

Since we are no longer switching from a BSCA to a ESCA we can completely
get rid of the sca_lock. The write lock was only taken for that
conversion.

After removal of the lock some local code cleanups are possible.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
The patch depends on "KVM: s390: Use ESCA instead of BSCA at VM init"

Link: https://lore.kernel.org/r/20250603-rm-bsca-v5-1-f691288ada5c@linux.ibm.com

Checkpatch fails for a already preexisting BUG macro.
---
 arch/s390/include/asm/kvm_host.h |  1 -
 arch/s390/kvm/gaccess.c          | 19 ++-----------------
 arch/s390/kvm/interrupt.c        | 29 ++++++++++-------------------
 arch/s390/kvm/kvm-s390.c         | 27 ++++++++-------------------
 4 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 4d651e6e8b12ecd7796070e9da659b0b2b94d302..b6761a9aaed73233dc4138462c71cf0cdf2ef56a 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -633,7 +633,6 @@ struct kvm_s390_pv {
 
 struct kvm_arch {
 	struct esca_block *sca;
-	rwlock_t sca_lock;
 	debug_info_t *dbf;
 	struct kvm_s390_float_interrupt float_int;
 	struct kvm_device *flic;
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index ee37d397d9218a4d33c7a33bd877d0b974ca9003..2285ef6d19e752b4de77daf2f643305698f3a130 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -108,14 +108,9 @@ struct aste {
 
 int ipte_lock_held(struct kvm *kvm)
 {
-	if (sclp.has_siif) {
-		int rc;
+	if (sclp.has_siif)
+		return kvm->arch.sca->ipte_control.kh != 0;
 
-		read_lock(&kvm->arch.sca_lock);
-		rc = kvm->arch.sca->ipte_control.kh != 0;
-		read_unlock(&kvm->arch.sca_lock);
-		return rc;
-	}
 	return kvm->arch.ipte_lock_count != 0;
 }
 
@@ -128,19 +123,16 @@ static void ipte_lock_simple(struct kvm *kvm)
 	if (kvm->arch.ipte_lock_count > 1)
 		goto out;
 retry:
-	read_lock(&kvm->arch.sca_lock);
 	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		if (old.k) {
-			read_unlock(&kvm->arch.sca_lock);
 			cond_resched();
 			goto retry;
 		}
 		new = old;
 		new.k = 1;
 	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
-	read_unlock(&kvm->arch.sca_lock);
 out:
 	mutex_unlock(&kvm->arch.ipte_mutex);
 }
@@ -153,14 +145,12 @@ static void ipte_unlock_simple(struct kvm *kvm)
 	kvm->arch.ipte_lock_count--;
 	if (kvm->arch.ipte_lock_count)
 		goto out;
-	read_lock(&kvm->arch.sca_lock);
 	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		new = old;
 		new.k = 0;
 	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
-	read_unlock(&kvm->arch.sca_lock);
 	wake_up(&kvm->arch.ipte_wq);
 out:
 	mutex_unlock(&kvm->arch.ipte_mutex);
@@ -171,12 +161,10 @@ static void ipte_lock_siif(struct kvm *kvm)
 	union ipte_control old, new, *ic;
 
 retry:
-	read_lock(&kvm->arch.sca_lock);
 	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		if (old.kg) {
-			read_unlock(&kvm->arch.sca_lock);
 			cond_resched();
 			goto retry;
 		}
@@ -184,14 +172,12 @@ static void ipte_lock_siif(struct kvm *kvm)
 		new.k = 1;
 		new.kh++;
 	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
-	read_unlock(&kvm->arch.sca_lock);
 }
 
 static void ipte_unlock_siif(struct kvm *kvm)
 {
 	union ipte_control old, new, *ic;
 
-	read_lock(&kvm->arch.sca_lock);
 	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
@@ -200,7 +186,6 @@ static void ipte_unlock_siif(struct kvm *kvm)
 		if (!new.kh)
 			new.k = 0;
 	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
-	read_unlock(&kvm->arch.sca_lock);
 	if (!new.kh)
 		wake_up(&kvm->arch.ipte_wq);
 }
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 95a876ff7aca9c632c3e361275da6781ec070c07..58c5a6734dc733b6ede600d0ea4e445d4772b581 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -44,35 +44,28 @@ static struct kvm_s390_gib *gib;
 /* handle external calls via sigp interpretation facility */
 static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
 {
-	int c, scn;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
 	if (!kvm_s390_test_cpuflags(vcpu, CPUSTAT_ECALL_PEND))
 		return 0;
 
 	BUG_ON(!kvm_s390_use_sca_entries());
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	struct esca_block *sca = vcpu->kvm->arch.sca;
-	union esca_sigp_ctrl sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
-
-	c = sigp_ctrl.c;
-	scn = sigp_ctrl.scn;
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 
 	if (src_id)
-		*src_id = scn;
+		*src_id = sigp_ctrl.scn;
 
-	return c;
+	return sigp_ctrl.c;
 }
 
 static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 {
-	int expect, rc;
-
-	BUG_ON(!kvm_s390_use_sca_entries());
-	read_lock(&vcpu->kvm->arch.sca_lock);
 	struct esca_block *sca = vcpu->kvm->arch.sca;
 	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 	union esca_sigp_ctrl new_val = {0}, old_val;
+	int expect, rc;
+
+	BUG_ON(!kvm_s390_use_sca_entries());
 
 	old_val = READ_ONCE(*sigp_ctrl);
 	new_val.scn = src_id;
@@ -81,7 +74,6 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
 	expect = old_val.value;
 	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 
 	if (rc != expect) {
 		/* another external call is pending */
@@ -93,15 +85,14 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
 static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 {
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
+
 	if (!kvm_s390_use_sca_entries())
 		return;
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	struct esca_block *sca = vcpu->kvm->arch.sca;
-	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
 	WRITE_ONCE(sigp_ctrl->value, 0);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
 int psw_extint_disabled(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a2a5207e199aef9f602ff1f4d29686840da7235..0163f2632eb7a396e6ff9f76fb4e53f58a3e4c9e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1937,14 +1937,12 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
 	union sca_utility new, old;
 	struct esca_block *sca;
 
-	read_lock(&kvm->arch.sca_lock);
 	sca = kvm->arch.sca;
 	old = READ_ONCE(sca->utility);
 	do {
 		new = old;
 		new.mtcr = val;
 	} while (!try_cmpxchg(&sca->utility.val, &old.val, new.val));
-	read_unlock(&kvm->arch.sca_lock);
 }
 
 static int kvm_s390_set_topo_change_indication(struct kvm *kvm,
@@ -1965,9 +1963,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
 	if (!test_kvm_facility(kvm, 11))
 		return -ENXIO;
 
-	read_lock(&kvm->arch.sca_lock);
 	topo = kvm->arch.sca->utility.mtcr;
-	read_unlock(&kvm->arch.sca_lock);
 
 	return put_user(topo, (u8 __user *)attr->addr);
 }
@@ -3342,7 +3338,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	if (!sclp.has_64bscao)
 		alloc_flags |= GFP_DMA;
-	rwlock_init(&kvm->arch.sca_lock);
 	mutex_lock(&kvm_lock);
 
 	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);
@@ -3527,36 +3522,30 @@ static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
 
 static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+
 	if (!kvm_s390_use_sca_entries())
 		return;
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	struct esca_block *sca = vcpu->kvm->arch.sca;
 
 	clear_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
 	sca->cpu[vcpu->vcpu_id].sda = 0;
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
 static void sca_add_vcpu(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_s390_use_sca_entries()) {
-		phys_addr_t sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
-
-		/* we still need the basic sca for the ipte control */
-		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
-		vcpu->arch.sie_block->scaol = sca_phys;
-		return;
-	}
-	read_lock(&vcpu->kvm->arch.sca_lock);
 	struct esca_block *sca = vcpu->kvm->arch.sca;
 	phys_addr_t sca_phys = virt_to_phys(sca);
 
-	sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
+	/* we still need the sca header for the ipte control */
 	vcpu->arch.sie_block->scaoh = sca_phys >> 32;
 	vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
 	vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
+
+	if (!kvm_s390_use_sca_entries())
+		return;
+
 	set_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
+	sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
 }
 
 static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)

---
base-commit: 0a4b866d08c6adaea2f4592d31edac6deeb4dcbd
change-id: 20250602-rm-sca-lock-d7c1eca252b1
prerequisite-change-id: 20250513-rm-bsca-ab1e8649aca7:v5
prerequisite-patch-id: e9e66d612c16d9bbfb0c6377d333d88e50a6078b

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


