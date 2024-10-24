Return-Path: <kvm+bounces-29662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 507DD9AEE34
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 19:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FC20283186
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 17:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E821FBF7A;
	Thu, 24 Oct 2024 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l1UO1Zlj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F091CBA17;
	Thu, 24 Oct 2024 17:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729791288; cv=none; b=V1+Wz8cF0Akb0LymrFtZDg3LmqSbIIdgZTXilxhdfizRhI7M8Tl8+30w18UHF96TMDJU/tvJzCXCFxl/bqrVuhASVJ2ukxIDeAaNar1/uxOriQCqprwScsCRmx36N9Pmcp+wMEIl7TtihTK5S1zEm/2C2/gudIbF+/PSgs/HkTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729791288; c=relaxed/simple;
	bh=rIcN/tJ77E24TgIzdyNdCRzv0Q63B57oiY16bt0oe9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B0Qa0bCL/dcdTHIWaHpp6GG4Vg8wgQ6LvZ1+NCCbDvlQponlf7Ym1J3pHhMAJwjTUB9hpRsOI3bhqIX5/G4v/1Mmu251u6rhGQsUgV+G8FwTXZqeQCc42UajP237sRRN0DkpvcG7FlFM/VeXn8yumpKAf08N8fEl2nmZXI9qHJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l1UO1Zlj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49OEV4R4016737;
	Thu, 24 Oct 2024 17:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bkrHZtFIVPKjyk0yZqzq4mDtLNuAwloD58YnxqpXY
	Bg=; b=l1UO1ZljGrIJvBklEaU5varjZBc+cs7eG4C9xpGcttI5R4XEpqJHELhX0
	11TeDnBrNLpcG0i1noPpnvhTfyp8miuThVEjxP+E9kJmxpwV/CwyKSvTOzUmOfSf
	J9i1xP9tDKN86U9ZXsVVEynqcpPSGPMFdCBDZiTE6Yw58dbpbbR3QhUzuatvAqcG
	fr8MoRmOYNdaarE7oxsJKyJAd7IMSfnv0+T/xlpdBpGShX6ROqvdHJxrZVaHQx/2
	2l2fyVC7UKE142pIooYFkbsUue8m/q2Sqa1nFuw9MCLjA5C7EKGKFItbgRMnoRSr
	IA3Wc3t9dB5G7RFG/UKbO96gHV4sg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emajsxu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Oct 2024 17:34:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49OHYV42015696;
	Thu, 24 Oct 2024 17:34:31 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emajsxu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Oct 2024 17:34:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49OEVhhm012603;
	Thu, 24 Oct 2024 17:34:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42emhfhmm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Oct 2024 17:34:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49OHYToL34996514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 17:34:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42CAA20043;
	Thu, 24 Oct 2024 17:34:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3A4420040;
	Thu, 24 Oct 2024 17:34:27 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.124.210.16])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 24 Oct 2024 17:34:27 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen@kernel.org
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: PPC: Book3S HV: Mask off LPCR_MER for a vCPU before running it to avoid spurious interrupts
Date: Thu, 24 Oct 2024 23:04:14 +0530
Message-ID: <20241024173417.95395-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rPSVTr5sSj3X-4dvbPrDDS4viP9J7qZZ
X-Proofpoint-GUID: Lnn7aZiXdWYvhNRbNr-4w1job6Z0k7rX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxscore=0 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=624 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410240143

Mask off the LPCR_MER bit before running a vCPU to ensure that it is not
set if there are no pending interrupts. Running a vCPU with LPCR_MER bit
set and no pending interrupts results in L2 vCPU getting an infinite flood
of spurious interrupts. The 'if check' in kvmhv_run_single_vcpu() sets
the LPCR_MER bit if there are pending interrupts.

The spurious flood problem can be observed in 2 cases:
1. Crashing the guest while interrupt heavy workload is running
  a. Start a L2 guest and run an interrupt heavy workload (eg: ipistorm)
  b. While the workload is running, crash the guest (make sure kdump
     is configured)
  c. Any one of the vCPUs of the guest will start getting an infinite
     flood of spurious interrupts.

2. Running LTP stress tests in multiple guests at the same time
   a. Start 4 L2 guests.
   b. Start running LTP stress tests on all 4 guests at same time.
   c. In some time, any one/more of the vCPUs of any of the guests will
      start getting an infinite flood of spurious interrupts.

The root cause of both the above issues is the same:
1. A NMI is sent to a running vCPU that has LPCR_MER bit set.
2. In the NMI path, all registers are refreshed, i.e, H_GUEST_GET_STATE
   is called for all the registers.
3. When H_GUEST_GET_STATE is called for lpcr, the vcpu->arch.vcore->lpcr
   of that vCPU at L1 level gets updated with LPCR_MER set to 1, and this
   new value is always used whenever that vCPU runs, regardless of whether
   there was a pending interrupt.
4. Since LPCR_MER is set, the vCPU in L2 always jumps to the external
   interrupt handler, and this cycle never ends.

Fix the spurious flood by making sure a vCPU's LPCR_MER is always masked
before running a vCPU.

Fixes: ec0f6639fa88 ("KVM: PPC: Book3S HV nestedv2: Ensure LPCR_MER bit is passed to the L0")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
V1 -> V2:
1. Mask off the LPCR_MER in vcpu->arch.vcore->lpcr instead of resetting
it so that we avoid grabbing vcpu->arch.vcore->lock. (Suggested by
Ritesh in an internal review)

 arch/powerpc/kvm/book3s_hv.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8f7d7e37bc8c..b8701b5dde50 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5089,9 +5089,19 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
 	do {
 		accumulate_time(vcpu, &vcpu->arch.guest_entry);
+		/*
+		 * L1's copy of L2's lpcr (vcpu->arch.vcore->lpcr) can get its MER bit
+		 * unexpectedly set - for e.g. during NMI handling when all register
+		 * states are synchronized from L0 to L1. L1 needs to inform L0 about
+		 * MER=1 only when there are pending external interrupts.
+		 * kvmhv_run_single_vcpu() anyway sets MER bit if there are pending
+		 * external interrupts. Hence, mask off MER bit when passing vcore->lpcr
+		 * here as otherwise it may generate spurious interrupts in L2 KVM
+		 * causing an endless loop, which results in L2 guest getting hung.
+		 */
 		if (cpu_has_feature(CPU_FTR_ARCH_300))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
-						  vcpu->arch.vcore->lpcr);
+						  vcpu->arch.vcore->lpcr & ~LPCR_MER);
 		else
 			r = kvmppc_run_vcpu(vcpu);
 
-- 
2.47.0


