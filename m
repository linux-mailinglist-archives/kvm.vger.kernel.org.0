Return-Path: <kvm+bounces-20619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F54191AEB4
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 20:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6E6F1F22779
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 18:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3127919B590;
	Thu, 27 Jun 2024 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="beENtNyA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B519B3D8;
	Thu, 27 Jun 2024 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719511456; cv=none; b=Af+8qQV7EFyZJ2KoB1vyW+abiuCwzwSdZ4uqFW4akyP4XgFKqqobZMtiXkgks4Gqh/5ITcwwVi9L4t+7v0NYQBKz2LKF/aOcw4iLjMpx2XXbOXaowyyr1X2n7sX5aivF9s7Cfex5z6ymZHNPODlwURQOaX45XxO0ZsrUgkdc0Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719511456; c=relaxed/simple;
	bh=xPBudM6c7EpUeLvld2BxPoWXQJ5Se924hvk1RFd3G6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq2V88Oau5UApLOr9Tl6WOx+AGCx7bwlgaRoT2qTa5O5ihCMvZ8ku6JAxSx347N59VB5xA79giBT17qMKzBylMUF4g8tiU3vqc6tOuyB1pg6zszl5eiHy/5vxayzCiuHpAC7lUqfFnbh1yJKNBV+3XG/79FH4REffi6DBxWQVZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=beENtNyA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RHt9vZ020951;
	Thu, 27 Jun 2024 18:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=GaSyLEFTZPmfQ
	v/jKB+v0N0VlfjVe3VXTictJ2evy4U=; b=beENtNyAWeWRb0u3r4Tq8+4IO+fp/
	u4AllyIFtdQNm2Zqk520FptW+x0bUFVhU0HmPJs9OQQmEQu0rzK6UwADeP2Ydp9a
	OVWon46oZq7YG+QpB7Krhjv08gTNs+BJwd9iJwPy8w7blpm62ZVcK44rT8SNQoXV
	QoNhFdMRJ73JDj/cHesNNZVkYG/xDs3EORVhrMZQ4aovEQL+5S0rbdASxpBUeurH
	QirXEPwcpqjsw6Wl3sFZ7DL5vDFH4sK463GpAIoml3O+heXr/a9dwaAM5eOD9iAb
	kaxLdqblnaj8bDCQ3F1uZb4E/VaeZ+3AL/40Z28xDvylLzuIQN3QKLCcw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401aaf0f4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:04:06 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45RI461E003618;
	Thu, 27 Jun 2024 18:04:06 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401aaf0f4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:04:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45RH1Ht7000388;
	Thu, 27 Jun 2024 18:04:05 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxbn3kpdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:04:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RI401r52101472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 18:04:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 049A120043;
	Thu, 27 Jun 2024 18:04:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20BF120040;
	Thu, 27 Jun 2024 18:03:58 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.107.18])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 18:03:57 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] arch/powerpc/kvm: Fix doorbells for nested KVM guests on PowerNV
Date: Thu, 27 Jun 2024 23:33:36 +0530
Message-ID: <20240627180342.110238-3-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627180342.110238-1-gautam@linux.ibm.com>
References: <20240627180342.110238-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1D2yhyqCjFWvCxRP6573BkfsyD0CxaOI
X-Proofpoint-GUID: 2rztb_3aQXPD9vAx38KYtkN3lVoL9WWv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_13,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270132

commit 6398326b9ba1("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
introduced an optimization to use only vcpu->doorbell_request for SMT
emulation for Power9 and above guests, but the code for nested guests 
still relies on the old way of handling doorbells, due to which an L2
guest cannot be booted with XICS with SMT>1. The command to repro
this issue is:

qemu-system-ppc64 \
	-drive file=rhel.qcow2,format=qcow2 \
	-m 20G \
	-smp 8,cores=1,threads=8 \
	-cpu  host \
	-nographic \
	-machine pseries,ic-mode=xics -accel kvm

Fix the plumbing to utilize vcpu->doorbell_request instead of vcore->dpdes 
on P9 and above.

Fixes: 6398326b9ba1 ("KVM: PPC: Book3S HV P9: Stop using vc->dpdes")
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c        |  9 ++++++++-
 arch/powerpc/kvm/book3s_hv_nested.c | 20 ++++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index cea28ac05923..0586fa636707 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4178,6 +4178,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	}
 	hvregs.hdec_expiry = time_limit;
 
+	// clear doorbell bit as hvregs already has the info
+	vcpu->arch.doorbell_request = 0;
+
 	/*
 	 * When setting DEC, we must always deal with irq_work_raise
 	 * via NMI vs setting DEC. The problem occurs right as we
@@ -4694,6 +4697,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	unsigned long flags;
 	u64 tb;
+	bool doorbell_pending;
 
 	trace_kvmppc_run_vcpu_enter(vcpu);
 
@@ -4752,6 +4756,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	 */
 	smp_mb();
 
+	doorbell_pending = !cpu_has_feature(CPU_FTR_ARCH_300) &&
+				vcpu->arch.doorbell_request;
+
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
 		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
@@ -4769,7 +4776,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 				lpcr |= LPCR_MER;
 		}
 	} else if (vcpu->arch.pending_exceptions ||
-		   vcpu->arch.doorbell_request ||
+		   doorbell_pending ||
 		   xive_interrupt_pending(vcpu)) {
 		vcpu->arch.ret = RESUME_HOST;
 		goto out;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 05f5220960c6..b34eefa6b268 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -32,7 +32,10 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	hr->pcr = vc->pcr | PCR_MASK;
-	hr->dpdes = vc->dpdes;
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		hr->dpdes = vcpu->arch.doorbell_request;
+	else
+		hr->dpdes = vc->dpdes;
 	hr->hfscr = vcpu->arch.hfscr;
 	hr->tb_offset = vc->tb_offset;
 	hr->dawr0 = vcpu->arch.dawr0;
@@ -105,7 +108,10 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
-	hr->dpdes = vc->dpdes;
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		hr->dpdes = vcpu->arch.doorbell_request;
+	else
+		hr->dpdes = vc->dpdes;
 	hr->purr = vcpu->arch.purr;
 	hr->spurr = vcpu->arch.spurr;
 	hr->ic = vcpu->arch.ic;
@@ -143,7 +149,10 @@ static void restore_hv_regs(struct kvm_vcpu *vcpu, const struct hv_guest_state *
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	vc->pcr = hr->pcr | PCR_MASK;
-	vc->dpdes = hr->dpdes;
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		vcpu->arch.doorbell_request = hr->dpdes;
+	else
+		vc->dpdes = hr->dpdes;
 	vcpu->arch.hfscr = hr->hfscr;
 	vcpu->arch.dawr0 = hr->dawr0;
 	vcpu->arch.dawrx0 = hr->dawrx0;
@@ -170,7 +179,10 @@ void kvmhv_restore_hv_return_state(struct kvm_vcpu *vcpu,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
-	vc->dpdes = hr->dpdes;
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && !vcpu->arch.doorbell_request)
+		vcpu->arch.doorbell_request = hr->dpdes;
+	else
+		vc->dpdes = hr->dpdes;
 	vcpu->arch.hfscr = hr->hfscr;
 	vcpu->arch.purr = hr->purr;
 	vcpu->arch.spurr = hr->spurr;
-- 
2.45.1


