Return-Path: <kvm+bounces-48180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97291ACB9B8
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 18:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5B57189B0F9
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 16:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBF02253EA;
	Mon,  2 Jun 2025 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MylGOMap"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DF82236E8;
	Mon,  2 Jun 2025 16:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748882294; cv=none; b=S9t9JOR/4pmarPje+iAcn2pPJFOO8ZRCfZejcL/DiA0EhY7a8rU+RULPyx/roICdQwGoqUvl5fxxnVwLi3RJMr5YMFc0zIfOO0j0p1vWJwmxAXPGKy4EbDk5HEu2WCus80fB1BLc2BIqFeo9tebJQyiighHOH0buDqVofvgZUAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748882294; c=relaxed/simple;
	bh=rXsvwSThKZhRhy1BQSlE64rTZLu9+hAdC/WMzpdLB4M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=e/2WYebyAZl/Sk6iEeZwcER0cxd4PGrQmWrFMyUhmNTImo5PetTuMUDGYYXVP+nZskRKxkeqvuD0aNuVoMDJhy98Wg2E9jUVAuOaC2lp3J7EEZNgJxD8ft9+CcVSZljOEsF+jO2BiXq6fNTh4Wuamuf03D1ClCML2gdWP/EcIsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MylGOMap; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5529lJFG021647;
	Mon, 2 Jun 2025 16:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=UVMbLdalhBrs2lfslv+nFyhI/Vv4
	BOC+hjpLba8cnrI=; b=MylGOMapxhLcxMK3aW2pX6XU5OspvLXyrCBJd2XKm3p5
	Z9Ohpke05kHjLbMh+x+gjAjeXO3TlEP761NmW1OQyA7w+CGJ8C3A+ecCJHnekzH0
	Q2PZXoaxgYKQtQolp4DemXshlBVWoJrdKZKVTTM28Ep73sc3x84h62xTtPEs4BFZ
	raLty6N1fkKcBQcXZQtk4M33zFgr07cWPR+KXJfwLuckGnCHfCA+JWX7UhmTesXi
	elyW1Lqbr+KVFUzTJmG55C6N2afVsvqh1ewip+Ia7EuuHkcqPoG6tSsw56GLT+dP
	lElkdE2HODqn9BKSh713V3OMaqChkxKFtW+FoO2iZw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ysgd2byc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 16:38:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 552F1iOM022530;
	Mon, 2 Jun 2025 16:38:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 470c3t779f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Jun 2025 16:38:05 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 552Gc2A356689064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Jun 2025 16:38:02 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 054BF20043;
	Mon,  2 Jun 2025 16:38:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4445320040;
	Mon,  2 Jun 2025 16:38:01 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.87.151.85])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Jun 2025 16:38:01 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 02 Jun 2025 18:34:44 +0200
Subject: [PATCH v4] KVM: s390: Use ESCA instead of BSCA at VM init
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250602-rm-bsca-v4-1-67c09d1ee835@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAKPSPWgC/23MSw6CMBSF4a2Qji3pm+LIfRgHfSFNBEyrDYawd
 wuJQozDc3O/fwLRBe8iOBYTCC756Ic+D3YogGlVf3XQ27wBQYQjjikMHdTRKKg0dlKwWhlVgfx
 9D67x41o6X/JufXwM4bWGE16unwb7NhKGCApDNBJcSSHR6eb751h63ZVm6MDSSWRv682SbB11i
 lNrEa3ZP0t3lpDN0mw5tljUFZWNaX7tPM9vivJ62RoBAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=19383;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=rXsvwSThKZhRhy1BQSlE64rTZLu9+hAdC/WMzpdLB4M=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDBm2lzN/qd0MaLnu5vztXMZ8q8Y3RxIFD6lMv52nnhRfe
 G6PQIB4RykLgxgXg6yYIku1uHVeVV/r0jkHLa/BzGFlAhnCwMUpABM5cJ7hv6v1lOCcaTKTNyxW
 2pTXI7jZetU91Tu6uozVgrn5Ei1t+xkZXi5scnddsa43cGfNi+f7+U49VDG+vJ356tT7Ewzi/Ni
 r+AA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=GdwXnRXL c=1 sm=1 tr=0 ts=683dd36e cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=de-QwB0P1ltAAbzrJ-MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GMBjYl8sLnv8CwtDLzWIK4kkQhJraZB4
X-Proofpoint-ORIG-GUID: GMBjYl8sLnv8CwtDLzWIK4kkQhJraZB4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDEzNSBTYWx0ZWRfX8EM5HKwkUX1/ jG+d/s5rdBZY3h7Yo/I+dJbhmb+Ea6U4h6r+CBxD0jV1FQWQGiD9aroeOMOz+zRNXaISCwA9mg2 RbALaKkT6vThu1NHoOAPAXTjzbjJcMuJksKXfmLTjMRa/jUvl80qpVeoT5wF7QGtB1JiXmB7vmJ
 Sb7ix6hqAntk/9iB1Ta6ynJpkEGwLCf1TK24UBwF1YMV3eH+dQhaYdJVy8YV33+OqSMdGeSXcuW LqLNmPpg0fyTavccBEWynrUmlnsNwi5+mphibal0awpH1kQ6Ci1zHtSfc/bAwuqxcm9IOXBxKda o74mXeUr0ZezWcNT+Dtk61f32Bx1lOPj5WcqSQcLdJ0A/pgMkDq/4K0FM4YwlGz99pvVoFYj2Kb
 GSjboHAWl4uvHCvU3BE/DWpem34Uomd6tKkV8IQcAUsXjSmk/SYF/39SNKaQwuEt+ZGHKBau
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2506020135

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
 arch/s390/include/asm/kvm_host.h       |   7 +-
 arch/s390/include/asm/kvm_host_types.h |   2 +
 arch/s390/kvm/gaccess.c                |  10 +-
 arch/s390/kvm/interrupt.c              |  71 ++++----------
 arch/s390/kvm/kvm-s390.c               | 167 ++++++---------------------------
 arch/s390/kvm/kvm-s390.h               |   9 +-
 6 files changed, 58 insertions(+), 208 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..2a2b557357c8e40c82022eb338c3e98aa8f03a2b 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -27,8 +27,6 @@
 #include <asm/isc.h>
 #include <asm/guarded_storage.h>
 
-#define KVM_MAX_VCPUS 255
-
 #define KVM_INTERNAL_MEM_SLOTS 1
 
 /*
@@ -631,9 +629,8 @@ struct kvm_s390_pv {
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
diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..9697db9576f6c39a6689251f85b4b974c344769a 100644
--- a/arch/s390/include/asm/kvm_host_types.h
+++ b/arch/s390/include/asm/kvm_host_types.h
@@ -6,6 +6,8 @@
 #include <linux/atomic.h>
 #include <linux/types.h>
 
+#define KVM_MAX_VCPUS 256
+
 #define KVM_S390_BSCA_CPU_SLOTS 64
 #define KVM_S390_ESCA_CPU_SLOTS 248
 
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
index 3f3175193fd7a7a26658eb2e2533d8037447a0b4..4f6c31b452be49d7dd731a4b953c676bf48ee6cb 100644
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
+		 * KVM_CAP_MAX_VCPU_ID to pass the kvm_create_max_vcpus selftest.
+		 */
+		r = KVM_S390_ESCA_CPU_SLOTS;
 		if (!kvm_s390_use_sca_entries())
-			r = KVM_MAX_VCPUS;
-		else if (sclp.has_esca && sclp.has_64bscao)
-			r = KVM_S390_ESCA_CPU_SLOTS;
+			r = KVM_MAX_VCPUS - 1;
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
base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
change-id: 20250513-rm-bsca-ab1e8649aca7

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


