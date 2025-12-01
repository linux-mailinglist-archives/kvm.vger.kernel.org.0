Return-Path: <kvm+bounces-64995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0574CC976BA
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 265024E5CB5
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8181B313281;
	Mon,  1 Dec 2025 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UFd+UdXU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD1631282F;
	Mon,  1 Dec 2025 12:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593118; cv=none; b=DMq43WALGzHuGhYibt55sA0SJQPqqS5/ctdkIiu0gu1TJA7wmEqwN/01X+ggARPwqsKbtxQwx8LYecyFFxpBL4M4OeSKVj67AVJX7wYpg/cJFhrJql1b+iUGRUGvqr8SMcj9ncXeneylDSpwy6y+LoL4bGcbkL64MaEUPSmjZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593118; c=relaxed/simple;
	bh=4Y7Y8DjQVSUeEKJSqmscuem7J/5wxKVmn+qpN1zQIQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apgrRBhVI8mgtqAEKEWLk6cFoo9icvbvRA/mhqhCzPplXBaC51sjbpo3KSWwwyt8KMEb9OsB4pBtWkJFir7YMY8QUs5uKSA3hhTJAkuGmfEHmnX2fCtcpm0aeWfedAgVIb+O3rchYrFCP61pJpOWnGHfxKhbarAPQnzc0p1O4Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UFd+UdXU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1Bild2001393;
	Mon, 1 Dec 2025 12:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ipa9QQoo2kKDgthx0
	HWtHLmezb/RT27eHcvsJ9yqGMc=; b=UFd+UdXUNGcUzM8xr1aKVjRlDByvzy/FR
	qeYrSptwjdDfavi4GC9eKjWCq4JO0TOTI8HLMtSpgpuMQV74xZqyAgoM/+rMPYC6
	0H6MhnnNtb91Qbt/Wps9BUuwgWBifev2vo7KH64A2LKeZr3Ye2FAbPHDaX9jhPt5
	8SsQABgkR/RI6N/mvWDbjZnPquv4BIEj/8UF2Fr314Zpsr4g/+Bwc/+aq2WnFMQ4
	Pes3+DADBOQwwITOZ+WNXq6FJPAMVxdRX5I/mBBjJoLGFS3bdfKjCjfyZZOOrbHl
	/DCp0YLBkIkUb/iBoHoG3jkNZgwtzU6cgnaIMrnEM6yhVNh8iKOOw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8uf21e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1BlxFL024111;
	Mon, 1 Dec 2025 12:45:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4arb5s6jr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1Cj9Q016581006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:09 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DAC320040;
	Mon,  1 Dec 2025 12:45:09 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDE082004B;
	Mon,  1 Dec 2025 12:45:08 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:08 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 02/10] KVM: S390: Remove sca_lock
Date: Mon,  1 Dec 2025 13:33:44 +0100
Message-ID: <20251201124334.110483-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 34elYCpL0_Ikc2HqnSS6Fk_YupPb09ZM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX3AopIMgABXbS
 siC1GtsBckRQTdkZr2AErOi5qAQAAcd0xTO/YcSgvT9THqAEkUtyvW42vN2RFetKMv3gXZlZ/nd
 OndYY0sqAUfJf+mEOjrHiKVS1zhaRiqOX2i4BOb99HgCnqH8hO/IKQwe4pm3NnH1/TqblliqhCP
 48ri+VzGRrExuytAoqJBnLDScr3mfFo1N6rPtLRwNjl2wRxtH9rSkEJzSoJ1jCrdowBeL4V5UWf
 IXuwMFYgm/MAgFZC6vmWgvv+pjgPO3AWaiGNvIWbAvAeyUBr+vdU7Pd9D2MeVytJrHs5XCye/4L
 o4b01WFLKVoHxnj0El+uy8vQbnzTemQZKdob6LXQrizsxzq7lzHs1RmEZ+nGMSgqfnqnBvSdmEN
 y+tnqCO6wTde5IjdDcxAJbGPhr3xrg==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=692d8dda cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=orOFSdPoH5eG8w0NmoYA:9
X-Proofpoint-GUID: 34elYCpL0_Ikc2HqnSS6Fk_YupPb09ZM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Since we are no longer switching from a BSCA to a ESCA we can completely
get rid of the sca_lock. The write lock was only taken for that
conversion.

After removal of the lock some local code cleanups are possible.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Suggested-by: Janosch Frank <frankja@linux.ibm.com>
[frankja@linux.ibm.com: Added suggested-by tag as discussed on list]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 -
 arch/s390/kvm/gaccess.c          | 19 ++---------------
 arch/s390/kvm/interrupt.c        | 36 ++++++++------------------------
 arch/s390/kvm/kvm-s390.c         | 34 ++++++++----------------------
 4 files changed, 20 insertions(+), 70 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3cf14dd75409..22cedcaea475 100644
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
index 3651ab682fd7..41ca6b0ee7a9 100644
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
index 36394ba897f5..220d9d00c23d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -45,48 +45,34 @@ static struct kvm_s390_gib *gib;
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
@@ -98,18 +84,14 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
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
index 78468b96d250..769820e3a243 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1938,14 +1938,12 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
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
@@ -1966,9 +1964,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
 	if (!test_kvm_facility(kvm, 11))
 		return -ENXIO;
 
-	read_lock(&kvm->arch.sca_lock);
 	topo = kvm->arch.sca->utility.mtcr;
-	read_unlock(&kvm->arch.sca_lock);
 
 	return put_user(topo, (u8 __user *)attr->addr);
 }
@@ -3345,7 +3341,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	if (!sclp.has_64bscao)
 		alloc_flags |= GFP_DMA;
-	rwlock_init(&kvm->arch.sca_lock);
 	mutex_lock(&kvm_lock);
 
 	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);
@@ -3530,41 +3525,30 @@ static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
 
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
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	phys_addr_t sca_phys = virt_to_phys(sca);
 
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
-
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
-- 
2.52.0


