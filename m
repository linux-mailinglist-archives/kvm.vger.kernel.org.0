Return-Path: <kvm+bounces-48321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFC7ACCB62
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED0AF7A56E8
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B18E19C54E;
	Tue,  3 Jun 2025 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p4TONBbD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0A5197A76;
	Tue,  3 Jun 2025 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748968593; cv=none; b=XHdLQ6CM1GdXZapTw6nQuuk3y06uM987ovMGQVluokjq7PQDRPq9R0bO6vXJN1+F6MeXbv7hwQkylJp5PVna22wu1DPrKiBYyMmGDT5X20dPd12tz4+rskA82rBjNBvILWkUMm8PIg3e4KBafOgwIWGzX5QGItwo/2QZUdHelbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748968593; c=relaxed/simple;
	bh=HN7gbw93OeuAUhmulQavUX19NnKzqopVoMYNQhpXmEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=cknaa0PAmXmj1pnrKscQmTqtJyX+Kncz41jXjM7tmjODAvBQt4+xqHmhIsr9bh1ilDO6rpi+C7SErNRGDnUvB6ng2fCzSy1VtiYVbr9pZ0pvLtInYSV5s98GOsEQKbrUPERKtWCvkaPptCwynYhR1plMy0VHwLsUakTV4O55sp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p4TONBbD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5537gAqC019535;
	Tue, 3 Jun 2025 16:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=gEbRTuaqUQUn/26Mj6nsUFHwHX+U
	rVtQW9BVn224DIE=; b=p4TONBbDERxT6COeOt/5gHdUpMPWaOp07XMYshH/YdAh
	V19h7i7983ARgODfVoqoFooowx5B6ivBdevZ6Ow/Pd/I7ozvXC5XP01w5//DskTX
	FrGYX6TIa7NOrL+RbiLoUPx4Bh5n8ZiEu5+R5OwJTrkW5uzeaDAQPkHY2BHscZJw
	CuPonXB6YMqVraiBLZd1sfbIMf/SCElcR38mKYGuASqkL0URVLD4n2FTCVH6OBrq
	Q+iJ92fb0JbTI0snsaftuJsweqSvcSL4E+enEJoKJQFyiaNAgPBlKIPXsEazcixR
	3rOva0ZvbDAL7SPFcb8W5J0LJC4NmgRH9Y93m5f48A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471geynr2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 16:36:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 553DmBQI019883;
	Tue, 3 Jun 2025 16:36:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470d3nur18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Jun 2025 16:36:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 553GaMBs50856394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Jun 2025 16:36:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 717EE2004B;
	Tue,  3 Jun 2025 16:36:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF9DC20040;
	Tue,  3 Jun 2025 16:36:21 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.43.170])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Jun 2025 16:36:21 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Tue, 03 Jun 2025 18:35:42 +0200
Subject: [PATCH v5] KVM: s390: Use ESCA instead of BSCA at VM init
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250603-rm-bsca-v5-1-f691288ada5c@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAF0kP2gC/23QTW7DIBAF4KtErEvEv6Gr3qPqgoFxg1TbLThWq
 ih37yRRa6vK8gHfk3hn1rAWbOx5d2YVl9LKNFKwTzuWDnF8R14yZaaEssJKzevAoaXII0j0zoS
 YYsfo9WfFvpxuTa9vlA+lzVP9vhUv8nr622H+OhbJBXdJgXA2eufFy0cZj6d9gWGfpoFdexa1t
 WG1iixqjFbnLHQwj6zeWKVWq8lamaULnfZ96h9Zs1onNtZwyV2XRMgS0Wv7317uY1T8OtKa830
 RBrEhp/uhzLSucSBTwKDp7+BTbzErgwJQJu8AhA+gldVUdvkBvg+nIKIBAAA=
X-Change-ID: 20250513-rm-bsca-ab1e8649aca7
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=18815;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=HN7gbw93OeuAUhmulQavUX19NnKzqopVoMYNQhpXmEI=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBn2Kq369oYHNmYdD6tvqmv24DzldZEv3jl54ezajWLB6
 nPWbS3rKGVhEONikBVTZKkWt86r6mtdOueg5TWYOaxMIEMYuDgFYCIsUowMvdzKp85UXBFZq/4n
 Z735h5D7N2L3v/e+wLhPztfAri3DlOF/0R/GeFbWvaKPVjPNOxPbNfPu3z9xyRK8k6ZOj+74ela
 FBQA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZU77Tr5pJ6sapCD3Pk74GsLfReSa0yfQ
X-Authority-Analysis: v=2.4 cv=DYMXqutW c=1 sm=1 tr=0 ts=683f248b cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=de-QwB0P1ltAAbzrJ-MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZU77Tr5pJ6sapCD3Pk74GsLfReSa0yfQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDE0NCBTYWx0ZWRfXwZ3SIlfOykiK 5e78p3ivlVrB7vEYanvnwLJ3AgkcJSSeAKfkc7ZDApwx/dE+Is2sa9JOGRHMPCTbOvdkIgoXUrW pb5C0A64TpVe256wJpPwb8TWd5FSbX2vNIzrh5OCGXTCSsV1JepBkDbiI0QgNduA5DW7MIyz+Xu
 +f1h3U+KYi++fg5ZOaHuvlaSCrO3h8F1+q2dNfvWtqM962pZJOCVNY7LCD5sFzNKQ3zlCjoDl9q +qnRu35gC57Sfh58L6DXoLow8JfGL7spH/FJboFWDD3BG+gm+H3q71hnRLbH2Cc7N6wQHfkgDcD Q6FoS6KUY9U+FxCw+nxX53HdBbNBgJaAix3cn2pC2SkHoHLR9FcJPDgQrqDyGRpqOiuEGisOVFj
 xs97cp6xzeVSx71VMEHc5KRhx0ZpVji3AiIbtKJcXGULieVUFKvHMMHQbz/Iqb0vG2PAivEI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_02,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506030144

All modern IBM Z and Linux One machines do offer support for the
Extended System Control Area (ESCA). The ESCA is available since the
z114/z196 released in 2010.
KVM needs to allocate and manage the SCA for guest VMs. Prior to this
change the SCA was setup as Basic SCA only supporting a maximum of 64
vCPUs when initializing the VM. With addition of the 65th vCPU the SCA
was needed to be converted to a ESCA.

Instead of allocating a BSCA and upgrading it for PV or when adding the
65th cpu we can always allocate the ESCA directly upon VM creation
simplifying the code in multiple places as well as completely removing
the need to convert an existing SCA.

In cases where the ESCA is not supported (z10 and earlier) the use of
the SCA entries and with that SIGP interpretation are disabled for VMs.
This increases the number of exits from the VM in multiprocessor
scenarios and thus decreases performance.
The same is true for VSIE where SIGP is currently disabled and thus no
SCA entries are used.

The only downside of the change is that we will always allocate 4 pages
for a 248 cpu ESCA instead of a single page for the BSCA per VM.
In return we can delete a bunch of checks and special handling depending
on the SCA type as well as the whole BSCA to ESCA conversion.

With that behavior change we are no longer referencing a bsca_block in
kvm->arch.sca. This will always be esca_block instead.
By specifying the type of the sca as esca_block we can simplify access
to the sca and get rid of some helpers while making the code clearer.

KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
future type definitions.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
Changes in v5:
- Revert changes to KVM_MAX_VCPUS
- Correct comments
- Link to v4: https://lore.kernel.org/r/20250602-rm-bsca-v4-1-67c09d1ee835@linux.ibm.com

Changes in v4:
- Squash patches into single patch
- Revert KVM_CAP_MAX_VCPUS to return KVM_CAP_MAX_VCPU_ID (255) again
- Link to v3: https://lore.kernel.org/r/20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com

Changes in v3:
- do not enable sigp for guests when kvm_s390_use_sca_entries() is false
  - consistently use kvm_s390_use_sca_entries() instead of sclp.has_sigpif
- Link to v2: https://lore.kernel.org/r/20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com

Changes in v2:
- properly apply checkpatch --strict (Thanks Claudio)
- some small comment wording changes
- rebased
- Link to v1: https://lore.kernel.org/r/20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com
---
 arch/s390/include/asm/kvm_host.h |   5 +-
 arch/s390/kvm/gaccess.c          |  10 +--
 arch/s390/kvm/interrupt.c        |  71 +++++------------
 arch/s390/kvm/kvm-s390.c         | 165 +++++++--------------------------------
 arch/s390/kvm/kvm-s390.h         |   9 +--
 5 files changed, 55 insertions(+), 205 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..4d651e6e8b12ecd7796070e9da659b0b2b94d302 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -631,9 +631,8 @@ struct kvm_s390_pv {
 	struct mmu_notifier mmu_notifier;
 };
 
-struct kvm_arch{
-	void *sca;
-	int use_esca;
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
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 60c360c18690f6b94e8483dab2c25f016451204b..95a876ff7aca9c632c3e361275da6781ec070c07 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -51,21 +51,11 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
 
 	BUG_ON(!kvm_s390_use_sca_entries());
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		union esca_sigp_ctrl sigp_ctrl =
-			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
-		c = sigp_ctrl.c;
-		scn = sigp_ctrl.scn;
-	} else {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
-		union bsca_sigp_ctrl sigp_ctrl =
-			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
-
-		c = sigp_ctrl.c;
-		scn = sigp_ctrl.scn;
-	}
+	c = sigp_ctrl.c;
+	scn = sigp_ctrl.scn;
 	read_unlock(&vcpu->kvm->arch.sca_lock);
 
 	if (src_id)
@@ -80,33 +70,17 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
 	BUG_ON(!kvm_s390_use_sca_entries());
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		union esca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl new_val = {0}, old_val;
-
-		old_val = READ_ONCE(*sigp_ctrl);
-		new_val.scn = src_id;
-		new_val.c = 1;
-		old_val.c = 0;
-
-		expect = old_val.value;
-		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
-	} else {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
-		union bsca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl new_val = {0}, old_val;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
+	union esca_sigp_ctrl new_val = {0}, old_val;
 
-		old_val = READ_ONCE(*sigp_ctrl);
-		new_val.scn = src_id;
-		new_val.c = 1;
-		old_val.c = 0;
+	old_val = READ_ONCE(*sigp_ctrl);
+	new_val.scn = src_id;
+	new_val.c = 1;
+	old_val.c = 0;
 
-		expect = old_val.value;
-		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
-	}
+	expect = old_val.value;
+	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
 	read_unlock(&vcpu->kvm->arch.sca_lock);
 
 	if (rc != expect) {
@@ -123,19 +97,10 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 		return;
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		union esca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
-		WRITE_ONCE(sigp_ctrl->value, 0);
-	} else {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
-		union bsca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-
-		WRITE_ONCE(sigp_ctrl->value, 0);
-	}
+	WRITE_ONCE(sigp_ctrl->value, 0);
 	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
@@ -1223,7 +1188,7 @@ int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	if (!sclp.has_sigpif)
+	if (!kvm_s390_use_sca_entries())
 		return test_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs);
 
 	return sca_ext_call_pending(vcpu, NULL);
@@ -1547,7 +1512,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	if (kvm_get_vcpu_by_id(vcpu->kvm, src_id) == NULL)
 		return -EINVAL;
 
-	if (sclp.has_sigpif && !kvm_s390_pv_cpu_get_handle(vcpu))
+	if (kvm_s390_use_sca_entries() && !kvm_s390_pv_cpu_get_handle(vcpu))
 		return sca_inject_ext_call(vcpu, src_id);
 
 	if (test_and_set_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs))
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3f3175193fd7a7a26658eb2e2533d8037447a0b4..6a2a5207e199aef9f602ff1f4d29686840da7235 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -271,7 +271,6 @@ debug_info_t *kvm_s390_dbf_uv;
 /* forward declarations */
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
-static int sca_switch_to_extended(struct kvm *kvm);
 
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
 {
@@ -631,11 +630,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_NR_VCPUS:
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
-		r = KVM_S390_BSCA_CPU_SLOTS;
+		/*
+		 * Return the same value for KVM_CAP_MAX_VCPUS and
+		 * KVM_CAP_MAX_VCPU_ID to conform with the KVM API.
+		 */
+		r = KVM_S390_ESCA_CPU_SLOTS;
 		if (!kvm_s390_use_sca_entries())
 			r = KVM_MAX_VCPUS;
-		else if (sclp.has_esca && sclp.has_64bscao)
-			r = KVM_S390_ESCA_CPU_SLOTS;
 		if (ext == KVM_CAP_NR_VCPUS)
 			r = min_t(unsigned int, num_online_cpus(), r);
 		break;
@@ -1930,13 +1931,11 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
  * Updates the Multiprocessor Topology-Change-Report bit to signal
  * the guest with a topology change.
  * This is only relevant if the topology facility is present.
- *
- * The SCA version, bsca or esca, doesn't matter as offset is the same.
  */
 static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
 {
 	union sca_utility new, old;
-	struct bsca_block *sca;
+	struct esca_block *sca;
 
 	read_lock(&kvm->arch.sca_lock);
 	sca = kvm->arch.sca;
@@ -1967,7 +1966,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
 		return -ENXIO;
 
 	read_lock(&kvm->arch.sca_lock);
-	topo = ((struct bsca_block *)kvm->arch.sca)->utility.mtcr;
+	topo = kvm->arch.sca->utility.mtcr;
 	read_unlock(&kvm->arch.sca_lock);
 
 	return put_user(topo, (u8 __user *)attr->addr);
@@ -2666,14 +2665,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (kvm_s390_pv_is_protected(kvm))
 			break;
 
-		/*
-		 *  FMT 4 SIE needs esca. As we never switch back to bsca from
-		 *  esca, we need no cleanup in the error cases below
-		 */
-		r = sca_switch_to_extended(kvm);
-		if (r)
-			break;
-
 		r = s390_disable_cow_sharing();
 		if (r)
 			break;
@@ -3314,10 +3305,7 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
 
 static void sca_dispose(struct kvm *kvm)
 {
-	if (kvm->arch.use_esca)
-		free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
-	else
-		free_page((unsigned long)(kvm->arch.sca));
+	free_pages_exact(kvm->arch.sca, sizeof(*kvm->arch.sca));
 	kvm->arch.sca = NULL;
 }
 
@@ -3331,10 +3319,9 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
-	int i, rc;
+	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
 	char debug_name[16];
-	static unsigned long sca_offset;
+	int i, rc;
 
 	rc = -EINVAL;
 #ifdef CONFIG_KVM_S390_UCONTROL
@@ -3356,17 +3343,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (!sclp.has_64bscao)
 		alloc_flags |= GFP_DMA;
 	rwlock_init(&kvm->arch.sca_lock);
-	/* start with basic SCA */
-	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
-	if (!kvm->arch.sca)
-		goto out_err;
 	mutex_lock(&kvm_lock);
-	sca_offset += 16;
-	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
-		sca_offset = 0;
-	kvm->arch.sca = (struct bsca_block *)
-			((char *) kvm->arch.sca + sca_offset);
+
+	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);
 	mutex_unlock(&kvm_lock);
+	if (!kvm->arch.sca)
+		goto out_err;
 
 	sprintf(debug_name, "kvm-%u", current->pid);
 
@@ -3548,17 +3530,10 @@ static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 	if (!kvm_s390_use_sca_entries())
 		return;
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
+	struct esca_block *sca = vcpu->kvm->arch.sca;
 
-		clear_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);
-		sca->cpu[vcpu->vcpu_id].sda = 0;
-	} else {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
-
-		clear_bit_inv(vcpu->vcpu_id, (unsigned long *) &sca->mcn);
-		sca->cpu[vcpu->vcpu_id].sda = 0;
-	}
+	clear_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
+	sca->cpu[vcpu->vcpu_id].sda = 0;
 	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
@@ -3573,105 +3548,23 @@ static void sca_add_vcpu(struct kvm_vcpu *vcpu)
 		return;
 	}
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		phys_addr_t sca_phys = virt_to_phys(sca);
-
-		sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
-		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
-		vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
-		vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
-		set_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);
-	} else {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
-		phys_addr_t sca_phys = virt_to_phys(sca);
-
-		sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
-		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
-		vcpu->arch.sie_block->scaol = sca_phys;
-		set_bit_inv(vcpu->vcpu_id, (unsigned long *) &sca->mcn);
-	}
+	struct esca_block *sca = vcpu->kvm->arch.sca;
+	phys_addr_t sca_phys = virt_to_phys(sca);
+
+	sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
+	vcpu->arch.sie_block->scaoh = sca_phys >> 32;
+	vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
+	vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
+	set_bit_inv(vcpu->vcpu_id, (unsigned long *)sca->mcn);
 	read_unlock(&vcpu->kvm->arch.sca_lock);
 }
 
-/* Basic SCA to Extended SCA data copy routines */
-static inline void sca_copy_entry(struct esca_entry *d, struct bsca_entry *s)
-{
-	d->sda = s->sda;
-	d->sigp_ctrl.c = s->sigp_ctrl.c;
-	d->sigp_ctrl.scn = s->sigp_ctrl.scn;
-}
-
-static void sca_copy_b_to_e(struct esca_block *d, struct bsca_block *s)
-{
-	int i;
-
-	d->ipte_control = s->ipte_control;
-	d->mcn[0] = s->mcn;
-	for (i = 0; i < KVM_S390_BSCA_CPU_SLOTS; i++)
-		sca_copy_entry(&d->cpu[i], &s->cpu[i]);
-}
-
-static int sca_switch_to_extended(struct kvm *kvm)
-{
-	struct bsca_block *old_sca = kvm->arch.sca;
-	struct esca_block *new_sca;
-	struct kvm_vcpu *vcpu;
-	unsigned long vcpu_idx;
-	u32 scaol, scaoh;
-	phys_addr_t new_sca_phys;
-
-	if (kvm->arch.use_esca)
-		return 0;
-
-	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!new_sca)
-		return -ENOMEM;
-
-	new_sca_phys = virt_to_phys(new_sca);
-	scaoh = new_sca_phys >> 32;
-	scaol = new_sca_phys & ESCA_SCAOL_MASK;
-
-	kvm_s390_vcpu_block_all(kvm);
-	write_lock(&kvm->arch.sca_lock);
-
-	sca_copy_b_to_e(new_sca, old_sca);
-
-	kvm_for_each_vcpu(vcpu_idx, vcpu, kvm) {
-		vcpu->arch.sie_block->scaoh = scaoh;
-		vcpu->arch.sie_block->scaol = scaol;
-		vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
-	}
-	kvm->arch.sca = new_sca;
-	kvm->arch.use_esca = 1;
-
-	write_unlock(&kvm->arch.sca_lock);
-	kvm_s390_vcpu_unblock_all(kvm);
-
-	free_page((unsigned long)old_sca);
-
-	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
-		 old_sca, kvm->arch.sca);
-	return 0;
-}
-
 static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
 {
-	int rc;
-
-	if (!kvm_s390_use_sca_entries()) {
-		if (id < KVM_MAX_VCPUS)
-			return true;
-		return false;
-	}
-	if (id < KVM_S390_BSCA_CPU_SLOTS)
-		return true;
-	if (!sclp.has_esca || !sclp.has_64bscao)
-		return false;
-
-	rc = kvm->arch.use_esca ? 0 : sca_switch_to_extended(kvm);
+	if (!kvm_s390_use_sca_entries())
+		return id < KVM_MAX_VCPUS;
 
-	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
+	return id < KVM_S390_ESCA_CPU_SLOTS;
 }
 
 /* needs disabled preemption to protect from TOD sync and vcpu_load/put */
@@ -3917,7 +3810,7 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->eca |= ECA_IB;
 	if (sclp.has_siif)
 		vcpu->arch.sie_block->eca |= ECA_SII;
-	if (sclp.has_sigpif)
+	if (kvm_s390_use_sca_entries())
 		vcpu->arch.sie_block->eca |= ECA_SIGPI;
 	if (test_kvm_facility(vcpu->kvm, 129)) {
 		vcpu->arch.sie_block->eca |= ECA_VX;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 8d3bbb2dd8d27802bbde2a7bd1378033ad614b8e..0c5e8ae07b77648d554668cc0536607545636a68 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -528,13 +528,6 @@ void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_per_ifetch_icpt(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
 
-/* support for Basic/Extended SCA handling */
-static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
-{
-	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
-
-	return &sca->ipte_control;
-}
 static inline int kvm_s390_use_sca_entries(void)
 {
 	/*
@@ -542,7 +535,7 @@ static inline int kvm_s390_use_sca_entries(void)
 	 * might use the entries. By not setting the entries and keeping them
 	 * invalid, hardware will not access them but intercept.
 	 */
-	return sclp.has_sigpif;
+	return sclp.has_sigpif && sclp.has_esca;
 }
 void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
 				     struct mcck_volatile_info *mcck_info);

---
base-commit: 546b1c9e93c2bb8cf5ed24e0be1c86bb089b3253
change-id: 20250513-rm-bsca-ab1e8649aca7

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


