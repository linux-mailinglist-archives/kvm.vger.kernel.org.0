Return-Path: <kvm+bounces-64994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F17C975CF
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 83E373447BB
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609EE313276;
	Mon,  1 Dec 2025 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dRiwiVNi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAD628BA95;
	Mon,  1 Dec 2025 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593118; cv=none; b=QzJhGqzxd42vWHmW2q3dQA9/tzdEY3e0j8ls0dNRVGBDgSZpPQ6oXBhlA0AQ76ewSR0PjdvLQ4nQxzuIlDJo2upTkQJe7XqZzusuPEQeLMV12ysIckJbFXnvv1eHKfwBeHkWydKX01T+/5e+5dXEz5FqmJAjP/2odl99zK+JKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593118; c=relaxed/simple;
	bh=HHugOHAdUyXMHNDLygjENGgSpQKyHhEuIvXtI6m3jPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFXf2SMJzxYaAcZj78cgOa4PY3+KEOf5CBRV5z3qcy/K22OYJulJ0MoaGRbcG6Q93Bf8DkFI3zm5FHSPKhNzuBL5NWtgqDz/ToEyJToRKekSOBIc+Ec6KlCo4G2LYK83Wklx4IhjOP6CGEUw0bIRZlk9bnQUhMkp3vpfvO8zgJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dRiwiVNi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AULpOGP029507;
	Mon, 1 Dec 2025 12:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=M0aPXezcbwGgwQSWh
	kx5AMyYuxIr0Yf1ziwS6tIs2IM=; b=dRiwiVNivBWylhlxZqxzM9CGmxVXrNKpG
	RkVlhUNghdt180YKYgUqbJZcMudU45XzS+y9TW6/eb+XmWXYCVTfuw6nEpbLSmbA
	i13IsvpIEhf+e99SI7/7VRFt3MrygNMpiFVBbGj+EqpHyz8dhhhCt8ROJ9D45ySj
	ZNb6LoRZyXL60cng5Cv7O++fmHhyw7knrWtMtnLEy+2rlriGI6TthVIUb/nJE+lu
	r33AmtwSHfG3nRXZxCQTEUBCjKL5OeLBb4wdkLoZyej3XsNZmVOo9lmtfds86jLG
	lkizXlyJAzihzuBE8iUCC4pim71hZzMzdxVdCy4H23lREKVvM9Mtw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8uf21c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1AI81R003838;
	Mon, 1 Dec 2025 12:45:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ardcje61d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1Cj8ht54395168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABB4420043;
	Mon,  1 Dec 2025 12:45:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3184720040;
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
Subject: [GIT PULL 01/10] KVM: s390: Use ESCA instead of BSCA at VM init
Date: Mon,  1 Dec 2025 13:33:43 +0100
Message-ID: <20251201124334.110483-2-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: cR7mncgmS8luui3GazvFJkFMPpezWF-n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX+MMJt8K39Dlc
 4Xhg1LPOFG6wb7lO5q+MhmnOCgoBYkmDRTcG4q75T4zK0t3q2iruGI6OXKTmGzN1Se4q4os35Pz
 aQWTQI+cVrvN6oleJZPR6mt70XHrA7aGmltMtSUcZqoKTRIb/OhgOj+itndbpiR2omuVHfy818P
 q/iPv/xBKzlpI33AMTK5+tucgosdiHMsLsXDa28awxFz50v7a0/XQhhK/J5uEnRpfpK7oBGeaKi
 nrCRnczofr3YpO2DXwkDKhs12sFb1/JjWyBCp2hhyhLNdS6wtVspa36VMNJOiLwX3NzaQpFXJiF
 Bl+msBtPYllOj9xq6LhhUNZ5pJ8nTMveMcKHK0XgMRHgrRhAirYgVDVHe/4IM/lLmGRscRIP73l
 Rp5DA07HaGO7QzgUsjsw10zauWFAkw==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=692d8dd9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=de-QwB0P1ltAAbzrJ-MA:9
X-Proofpoint-GUID: cR7mncgmS8luui3GazvFJkFMPpezWF-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

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

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   5 +-
 arch/s390/kvm/gaccess.c          |  10 +-
 arch/s390/kvm/interrupt.c        |  78 +++++---------
 arch/s390/kvm/kvm-s390.c         | 170 +++++++------------------------
 arch/s390/kvm/kvm-s390.h         |   9 +-
 5 files changed, 67 insertions(+), 205 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c2ba3d4398c5..3cf14dd75409 100644
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
index 21c2e61fece4..3651ab682fd7 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -113,7 +113,7 @@ int ipte_lock_held(struct kvm *kvm)
 		int rc;
 
 		read_lock(&kvm->arch.sca_lock);
-		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
+		rc = kvm->arch.sca->ipte_control.kh != 0;
 		read_unlock(&kvm->arch.sca_lock);
 		return rc;
 	}
@@ -130,7 +130,7 @@ static void ipte_lock_simple(struct kvm *kvm)
 		goto out;
 retry:
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		if (old.k) {
@@ -155,7 +155,7 @@ static void ipte_unlock_simple(struct kvm *kvm)
 	if (kvm->arch.ipte_lock_count)
 		goto out;
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		new = old;
@@ -173,7 +173,7 @@ static void ipte_lock_siif(struct kvm *kvm)
 
 retry:
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		if (old.kg) {
@@ -193,7 +193,7 @@ static void ipte_unlock_siif(struct kvm *kvm)
 	union ipte_control old, new, *ic;
 
 	read_lock(&kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(kvm);
+	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
 		new = old;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c62a868cf2b6..36394ba897f5 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -45,6 +45,8 @@ static struct kvm_s390_gib *gib;
 /* handle external calls via sigp interpretation facility */
 static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
 {
+	union esca_sigp_ctrl sigp_ctrl;
+	struct esca_block *sca;
 	int c, scn;
 
 	if (!kvm_s390_test_cpuflags(vcpu, CPUSTAT_ECALL_PEND))
@@ -52,21 +54,11 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
 
 	BUG_ON(!kvm_s390_use_sca_entries());
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		union esca_sigp_ctrl sigp_ctrl =
-			sca->cpu[vcpu->vcpu_id].sigp_ctrl;
+	sca = vcpu->kvm->arch.sca;
+	sigp_ctrl = sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
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
@@ -77,37 +69,23 @@ static int sca_ext_call_pending(struct kvm_vcpu *vcpu, int *src_id)
 
 static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 {
+	union esca_sigp_ctrl old_val, new_val = {0};
+	union esca_sigp_ctrl *sigp_ctrl;
+	struct esca_block *sca;
 	int expect, rc;
 
 	BUG_ON(!kvm_s390_use_sca_entries());
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		union esca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl new_val = {0}, old_val;
+	sca = vcpu->kvm->arch.sca;
+	sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
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
-	} else {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
-		union bsca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl new_val = {0}, old_val;
-
-		old_val = READ_ONCE(*sigp_ctrl);
-		new_val.scn = src_id;
-		new_val.c = 1;
-		old_val.c = 0;
-
-		expect = old_val.value;
-		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
-	}
+	expect = old_val.value;
+	rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
 	read_unlock(&vcpu->kvm->arch.sca_lock);
 
 	if (rc != expect) {
@@ -120,23 +98,17 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 
 static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 {
+	union esca_sigp_ctrl *sigp_ctrl;
+	struct esca_block *sca;
+
 	if (!kvm_s390_use_sca_entries())
 		return;
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_ECALL_PEND);
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		union esca_sigp_ctrl *sigp_ctrl =
-			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
+	sca = vcpu->kvm->arch.sca;
+	sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
 
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
 
@@ -1224,7 +1196,7 @@ int kvm_s390_ext_call_pending(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	if (!sclp.has_sigpif)
+	if (!kvm_s390_use_sca_entries())
 		return test_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs);
 
 	return sca_ext_call_pending(vcpu, NULL);
@@ -1549,7 +1521,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	if (kvm_get_vcpu_by_id(vcpu->kvm, src_id) == NULL)
 		return -EINVAL;
 
-	if (sclp.has_sigpif && !kvm_s390_pv_cpu_get_handle(vcpu))
+	if (kvm_s390_use_sca_entries() && !kvm_s390_pv_cpu_get_handle(vcpu))
 		return sca_inject_ext_call(vcpu, src_id);
 
 	if (test_and_set_bit(IRQ_PEND_EXT_EXTERNAL, &li->pending_irqs))
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 16ba04062854..78468b96d250 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -272,7 +272,6 @@ debug_info_t *kvm_s390_dbf_uv;
 /* forward declarations */
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 			      unsigned long end);
-static int sca_switch_to_extended(struct kvm *kvm);
 
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
 {
@@ -632,11 +631,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
@@ -1931,13 +1932,11 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -1968,7 +1967,7 @@ static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
 		return -ENXIO;
 
 	read_lock(&kvm->arch.sca_lock);
-	topo = ((struct bsca_block *)kvm->arch.sca)->utility.mtcr;
+	topo = kvm->arch.sca->utility.mtcr;
 	read_unlock(&kvm->arch.sca_lock);
 
 	return put_user(topo, (u8 __user *)attr->addr);
@@ -2667,14 +2666,6 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
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
 		mmap_write_lock(kvm->mm);
 		r = gmap_helper_disable_cow_sharing();
 		mmap_write_unlock(kvm->mm);
@@ -3317,10 +3308,7 @@ static void kvm_s390_crypto_init(struct kvm *kvm)
 
 static void sca_dispose(struct kvm *kvm)
 {
-	if (kvm->arch.use_esca)
-		free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
-	else
-		free_page((unsigned long)(kvm->arch.sca));
+	free_pages_exact(kvm->arch.sca, sizeof(*kvm->arch.sca));
 	kvm->arch.sca = NULL;
 }
 
@@ -3334,10 +3322,9 @@ void kvm_arch_free_vm(struct kvm *kvm)
 
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
@@ -3359,17 +3346,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (!sclp.has_64bscao)
 		alloc_flags |= GFP_DMA;
 	rwlock_init(&kvm->arch.sca_lock);
-	/* start with basic SCA */
-	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
+	mutex_lock(&kvm_lock);
+
+	kvm->arch.sca = alloc_pages_exact(sizeof(*kvm->arch.sca), alloc_flags);
+	mutex_unlock(&kvm_lock);
 	if (!kvm->arch.sca)
 		goto out_err;
-	mutex_lock(&kvm_lock);
-	sca_offset += 16;
-	if (sca_offset + sizeof(struct bsca_block) > PAGE_SIZE)
-		sca_offset = 0;
-	kvm->arch.sca = (struct bsca_block *)
-			((char *) kvm->arch.sca + sca_offset);
-	mutex_unlock(&kvm_lock);
 
 	sprintf(debug_name, "kvm-%u", current->pid);
 
@@ -3548,27 +3530,25 @@ static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
 
 static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct esca_block *sca;
+
 	if (!kvm_s390_use_sca_entries())
 		return;
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
+	sca = vcpu->kvm->arch.sca;
 
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
 
 static void sca_add_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct esca_block *sca;
+	phys_addr_t sca_phys;
+
 	if (!kvm_s390_use_sca_entries()) {
-		phys_addr_t sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
+		sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
 
 		/* we still need the basic sca for the ipte control */
 		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
@@ -3576,105 +3556,23 @@ static void sca_add_vcpu(struct kvm_vcpu *vcpu)
 		return;
 	}
 	read_lock(&vcpu->kvm->arch.sca_lock);
-	if (vcpu->kvm->arch.use_esca) {
-		struct esca_block *sca = vcpu->kvm->arch.sca;
-		phys_addr_t sca_phys = virt_to_phys(sca);
+	sca = vcpu->kvm->arch.sca;
+	sca_phys = virt_to_phys(sca);
 
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
+	if (!kvm_s390_use_sca_entries())
+		return id < KVM_MAX_VCPUS;
 
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
-
-	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
+	return id < KVM_S390_ESCA_CPU_SLOTS;
 }
 
 /* needs disabled preemption to protect from TOD sync and vcpu_load/put */
@@ -3920,7 +3818,7 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->eca |= ECA_IB;
 	if (sclp.has_siif)
 		vcpu->arch.sie_block->eca |= ECA_SII;
-	if (sclp.has_sigpif)
+	if (kvm_s390_use_sca_entries())
 		vcpu->arch.sie_block->eca |= ECA_SIGPI;
 	if (test_kvm_facility(vcpu->kvm, 129)) {
 		vcpu->arch.sie_block->eca |= ECA_VX;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c44fe0c3a097..65c950760993 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -570,13 +570,6 @@ void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu);
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
@@ -584,7 +577,7 @@ static inline int kvm_s390_use_sca_entries(void)
 	 * might use the entries. By not setting the entries and keeping them
 	 * invalid, hardware will not access them but intercept.
 	 */
-	return sclp.has_sigpif;
+	return sclp.has_sigpif && sclp.has_esca;
 }
 void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
 				     struct mcck_volatile_info *mcck_info);
-- 
2.52.0


