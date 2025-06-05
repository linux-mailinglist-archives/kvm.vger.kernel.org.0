Return-Path: <kvm+bounces-48558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4D0ACF3E1
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 263261896E28
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD641F1315;
	Thu,  5 Jun 2025 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="euHQSqWE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85E33062;
	Thu,  5 Jun 2025 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749140067; cv=none; b=kKsTJ88+08hq/IEhikd/HVuMYhPDh7x3GLyuovpV+rc2OvLR4ulta1G5dP2AIe3TZCOdZp/GZd+r9ztvMtZr+i4UNIzJFClihJsC4PwjKx70GuLQ9p3amzxO/BPVMKRvl5eBgVZgd2CT/xBl1r1R/64J1fYgtarZE1DKVj6LW7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749140067; c=relaxed/simple;
	bh=pVX5HnWt7soZKI76VpAuR7l9oM3Xv8fenf4xTOb05lc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=F/xJftlSL+73kLPNPWNXs8OPuklwvi1ZnyIbk5yEKqVC+sK+SyeB4ErNd3SSd718+t+tSTzn4CxUehpVYX0dVhnpYQiCePlHJjyG40NAnOmnyMzklnHbCTauwcsd1OKb/KiVLCwoQzoq9f/noue2RNs3/owCboDWuKesdLfXYH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=euHQSqWE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55592fQA029660;
	Thu, 5 Jun 2025 16:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=yeCEzxagU6bdOO8TyCMsW96lOLkr
	fycKQZ/Qy7B+eZs=; b=euHQSqWEre/lK3xItY+BsfL4Foi4X9jPDN+orco4IW8Q
	x4wiHvv/3qwdgy6rhih04COb62jX/c0/FEftfl5Kir+YDRTf+nZw91zsf11rAQj8
	QCD0NVNy/Sv1fxNtOCZNM+u2gs+V6x3ZJD2uP6daPAADavvivpQEZQgg7+KEVLeC
	Wfrw9TggAIRjpq31t6oDT/y3atgoNkh5YBykOrM4FOzAcsbDpsALS9SE0j06OreS
	Cp51bZao3v7sRh6LD/HfPUFWtI0XFTS9tYOS1BIZc11Xh6LMVHNSZLhmkyT+sj88
	bS6fCZK5nLfs1eBYHt+D+Li0LfVEhHWUJa/eAlV4+w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf01s72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 16:14:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 555D3IDd031636;
	Thu, 5 Jun 2025 16:14:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470cg05kac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 16:14:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 555GEHe054723008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 16:14:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B25E12004F;
	Thu,  5 Jun 2025 16:14:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2079E20049;
	Thu,  5 Jun 2025 16:14:17 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.87.153.243])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Jun 2025 16:14:17 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Thu, 05 Jun 2025 18:14:05 +0200
Subject: [PATCH v2] KVM: S390: Remove sca_lock
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-rm-sca-lock-v2-1-74922f4f946e@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAEzCQWgC/1XOQQ6CMBAF0KuQri2hpVjKynsYFm0ZdaKAtkAwh
 Lvbgolx+SeZ9/9CPDgET6pkIQ4m9Nh3IfBDQuxNd1eg2IRMeMaL7Jhx6lrqraaP3t5pIy0Dq3n
 BDSPh4+nggvOmnes9O3iNAR32488MFVEsWB5FE0ltGJRHobTVsppkBI32QG3ftjhUCVgpmQChh
 FQk8jf0Q+/e2/aJbf53Zv43c2KUUSVVXohSlBno0wO7cU7RtGnASb2u6we7NfLYCQEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9908;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=pVX5HnWt7soZKI76VpAuR7l9oM3Xv8fenf4xTOb05lc=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBmOhyJ8FCzsnr9+5e+f2e0pJFC4p8rgs6Vir+t9T4OwT
 6zCO706SlkYxLgYZMUUWarFrfOq+lqXzjloeQ1mDisTyBAGLk4BmMi1N4wMjzRWWyxKa+l66/4m
 atvuS9HWy7XuhiziVjiwr21KNf+fowx/uPuvbTm5f6KrdZDm1+bm4lXK7frhy9pupeUbZap/fdT
 GBgA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lyTkYOm7mtynNxoe-u6u8a35HAegZ2kb
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=6841c25f cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=HuE_NSwBh0w7oDnXugYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lyTkYOm7mtynNxoe-u6u8a35HAegZ2kb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDE0MCBTYWx0ZWRfXwpDzuKmDT7OS CZfd+swhNNav5wLZb5kl79HmUFmFi7vTQiMlhza7uIGfIaAwYi9Dhef5DEjiEw0GrZMnAZbBq3A FFDu2MyNaI1Jnp7805apF1BSW0+tEgmkvXCNHnBzDy0XuNL/UALkdej02GcZCyQOZ+pMMWrSii+
 5o5KA8UKRSl2GtJh/dqgve7sYiSACBvkrlrHtPlELy6WSDpM0pQZ17DcYwitfhuIEqs001LK9d+ F1Z0WrDDY6sLu3KcOmLob16KzRSf64yOH5mavgzIO9pGx+fWndXc3VgdhZ4ATxauKcricZ+hoN2 7rnhwZeoft8SOJPxBq8PFZTH+9jXMfsrcFLS57hVyHT9y9jtRjMc5CKmimJCY9/rRggGWdmv26M
 IoluO9W+n26cBAcTvAHAm9Q5YM7OrssCUT6ehbximfw8N5SVSg18XYrWTcwcyBccjOe6PYzZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_04,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050140

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
Changes in v2:
- rebase on 20250513-rm-bsca-ab1e8649aca7:v7
- directly init new_val with correct value in sca_inject_ext_call()
- Link to v1: https://lore.kernel.org/r/20250603-rm-sca-lock-v1-1-9793548480ea@linux.ibm.com
---
 arch/s390/include/asm/kvm_host.h |  1 -
 arch/s390/kvm/gaccess.c          | 19 ++-----------------
 arch/s390/kvm/interrupt.c        | 36 +++++++++---------------------------
 arch/s390/kvm/kvm-s390.c         | 34 +++++++++-------------------------
 4 files changed, 20 insertions(+), 70 deletions(-)

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
index 586c0c5ecf131c2298e662aa85d4c9ae127738d9..6fdb4d04316a70d122636312ed119f0d2d3a698e 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -109,14 +109,9 @@ struct aste {
 
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
 
@@ -129,19 +124,16 @@ static void ipte_lock_simple(struct kvm *kvm)
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
@@ -154,14 +146,12 @@ static void ipte_unlock_simple(struct kvm *kvm)
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
@@ -172,12 +162,10 @@ static void ipte_lock_siif(struct kvm *kvm)
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
@@ -185,14 +173,12 @@ static void ipte_lock_siif(struct kvm *kvm)
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
@@ -201,7 +187,6 @@ static void ipte_unlock_siif(struct kvm *kvm)
 		if (!new.kh)
 			new.k = 0;
 	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
-	read_unlock(&kvm->arch.sca_lock);
 	if (!new.kh)
 		wake_up(&kvm->arch.ipte_wq);
 }
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f2d29c99253b6f2e804ebc9055ac5447efb9a427..283af13314a292d9b7ae71580592d913544d10fe 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -44,48 +44,34 @@ static struct kvm_s390_gib *gib;
 /* handle external calls via sigp interpretation facility */
 static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
 {
-	union esca_sigp_ctrl sigp_ctrl;
-	struct esca_block *sca;
-	int c, scn;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
 	if (!kvm_s390_test_cpuflags(vcpu, CPUSTAT_ECALL_PEND))
 		return 0;
 
 	BUG_ON(!kvm_s390_use_sca_entries());
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	sca = vcpu->kvm->arch.sca;
-	sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
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
-	union esca_sigp_ctrl old_val, new_val = {0};
-	union esca_sigp_ctrl *sigp_ctrl;
-	struct esca_block *sca;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
+	union esca_sigp_ctrl old_val, new_val = {.scn = src_id, .c = 1};
 	int expect, rc;
 
 	BUG_ON(!kvm_s390_use_sca_entries());
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	sca = vcpu->kvm->arch.sca;
-	sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
 	old_val = READ_ONCE(*sigp_ctrl);
-	new_val.scn = src_id;
-	new_val.c = 1;
 	old_val.c = 0;
 
 	expect = old_val.value;
 	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 
 	if (rc != expect) {
 		/* another external call is pending */
@@ -97,18 +83,14 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
 static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 {
-	union esca_sigp_ctrl *sigp_ctrl;
-	struct esca_block *sca;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
 	if (!kvm_s390_use_sca_entries())
 		return;
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	sca = vcpu->kvm->arch.sca;
-	sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
 	WRITE_ONCE(sigp_ctrl->value, 0);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
 int psw_extint_disabled(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 93b0497c7618e34009b15d291e33dc425e46992f..b04307b762017ee57625c4c35327f0afd9eb43b1 100644
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
@@ -3344,7 +3340,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	if (!sclp.has_64bscao)
 		alloc_flags |= GFP_DMA;
-	rwlock_init(&kvm->arch.sca_lock);
 	mutex_lock(&kvm_lock);
 
 	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);
@@ -3529,41 +3524,30 @@ static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
 
 static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 {
-	struct esca_block *sca;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
 
 	if (!kvm_s390_use_sca_entries())
 		return;
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	sca = vcpu->kvm->arch.sca;
 
 	clear_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
 	sca->cpu[vcpu->vcpu_id].sda = 0;
-	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
 static void sca_add_vcpu(struct kvm_vcpu *vcpu)
 {
-	struct esca_block *sca;
-	phys_addr_t sca_phys;
-
-	if (!kvm_s390_use_sca_entries()) {
-		sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
-
-		/* we still need the basic sca for the ipte control */
-		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
-		vcpu->arch.sie_block->scaol = sca_phys;
-		return;
-	}
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	sca = vcpu->kvm->arch.sca;
-	sca_phys = virt_to_phys(sca);
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	phys_addr_t sca_phys = virt_to_phys(sca);
 
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
base-commit: ec7714e4947909190ffb3041a03311a975350fe0
change-id: 20250602-rm-sca-lock-d7c1eca252b1
prerequisite-change-id: 20250513-rm-bsca-ab1e8649aca7:v7
prerequisite-patch-id: 52dadcc65bc9fddfee7499ed55a3fa909051ab1c

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


