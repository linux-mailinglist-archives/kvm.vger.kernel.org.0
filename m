Return-Path: <kvm+bounces-56822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99971B43A5B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 13:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 264804E2B93
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0DBC2DEA96;
	Thu,  4 Sep 2025 11:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GwgoJECF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7BA2C21C5;
	Thu,  4 Sep 2025 11:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756985977; cv=none; b=cpgY3qdDx+Xxmf4MDoVmej+wfNOfgmswUpqy9fG9EuVeySHxF0FIy5NlJ9Zym90Qkwhd8hLWjQeRxVF+4UL6BBc/BDKjZymmRrk8zVDVlmThV/tICKjBsfS7SBYUD1XGXWy6T601WKM7NwBj2YsLk6MhGR1sgkNfv85VurFkTtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756985977; c=relaxed/simple;
	bh=M46UU1tIHZy0eX3aoyugvPUZJ2kQKeF4+naupJNksvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LNCU/9EYQxZ6f6tPes3Zydl5xuOO9HqOGcFkTuaLYoPAA/c/JF3P6YiD4oFQ9S8NDiM1aJENi2Fzs8KIpiOPTkgg1Luei/ax2xtmXikjb3nADLGPuYvUsFnF3ulLxxd/CWAjBZzTTPBT2WU2PnUjcwGTWJa5ZE20Veu+3jS/DsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GwgoJECF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5841fp3U027125;
	Thu, 4 Sep 2025 11:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=jOdHlHLTzlTXgXIY0XPb73c/a7GizaF4qGFSA8TOg
	dI=; b=GwgoJECFy/f+BUo6vsHKsrdDQSp2mF2uNRxnQbnywrg7tsUv3uQuIKUKl
	g1A7wxg1wVLpttdWJP+49rS23YGGHp5nNt6S20id08s34R2bVhjsmSvP+sfpT/gc
	uD8N2jaoPo2YXsm9izgAT6DTAUQst/PAixiMGPtRf1zPGMi6RT9TiBZvNVTF9QCH
	w+jaEfnVvo8t1Ex0ckd7jSeOJF5vakkMGiDos6D9AaMrLyK5oZ/vDqjf/WFnzahu
	0rzbHVf8brftS9++4LNp2JgkC2JvV1HptgDOECAyI22VgcZD8QkiaxXpHwJ/gZmO
	iZDVzCuDOSUwJEMLcZa/TXHZCVNqw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usua9c82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 11:39:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5847oObF017634;
	Thu, 4 Sep 2025 11:39:33 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48vc10vd2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Sep 2025 11:39:33 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 584BdVsf41157210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Sep 2025 11:39:32 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD59E58058;
	Thu,  4 Sep 2025 11:39:31 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98C3F58057;
	Thu,  4 Sep 2025 11:39:29 +0000 (GMT)
Received: from li-6365fdcc-3484-11b2-a85c-9bfb6e0c0d76.ibm.com.com (unknown [9.87.130.193])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  4 Sep 2025 11:39:29 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Janosch Frank <frankja@linux.vnet.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: improve interrupt cpu for wakeup
Date: Thu,  4 Sep 2025 13:39:27 +0200
Message-ID: <20250904113927.119306-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cTRmZG7y2LPQirKo-wB9-ZdzjH3tr1hj
X-Authority-Analysis: v=2.4 cv=U6uSDfru c=1 sm=1 tr=0 ts=68b97a75 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=96_l8XAYGo8_1cjTnkcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX8afDW8j+TMqq
 YVZOqLcusnnSzZzrtuEXWi8gUAY2KrreEKpgV4A31Hm7YNWCHyZL52fvwjXCVtiw/WMUlte5wpK
 6+avhc0Vk5QhFVBkWyYvmlvNJ/rKr0BrDhVIrDIJKnm/8Gc+R9fhQY7StA+rMfilD/h4eOFmE0Q
 L3vJYyFoZRbDAl5A/uLLBFtTLJGKgEx2/mugf3HucsQrjOHaV11c4Q+fnNKqcM+EvF5pQanZVr8
 PYHYuqXUiUj2WABgJ2950DZawm4p/DEnkfEs6lvgp0xRFeOjpC/QJFl6eVIRn2Y7rocsCFd572U
 TXrxmxl3+Z6SRvawT07DL2dyGqkREfAbF2RLsLviY6ndF6smZCs/pBNPy9q/ZPom4LLSR9jGhKe
 SNxS3Tgp
X-Proofpoint-ORIG-GUID: cTRmZG7y2LPQirKo-wB9-ZdzjH3tr1hj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034

Turns out that picking an idle CPU for floating interrupts has some
negative side effects. The guest will keep the IO workload on its CPU
and rather use an IPI from the interrupt CPU instead of moving workload.
For example a guest with 2 vCPUss and 1 fio process might run that fio on
vcpu1. If after diag500 both vCPUs are idle then vcpu0 is woken up. The
guest will then do an IPI from vcpu0 to vcpu1.

So lets change the heuristics and prefer the last CPU that went to
sleep. This one is likely still in halt polling and can be woken up
quickly.

This patch shows significant improvements in terms of bandwidth or
cpu consumption for fio and uperf workloads and seems to be a net
win.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kvm/interrupt.c        | 20 +++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f870d09515cc1..95d15416c39d2 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -356,7 +356,7 @@ struct kvm_s390_float_interrupt {
 	int counters[FIRQ_MAX_COUNT];
 	struct kvm_s390_mchk_info mchk;
 	struct kvm_s390_ext_info srv_signal;
-	int next_rr_cpu;
+	int last_sleep_cpu;
 	struct mutex ais_lock;
 	u8 simm;
 	u8 nimm;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 60c360c18690f..b8e6f82e92c3f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1322,6 +1322,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 4, "enabled wait: %llu ns", sltime);
 no_timer:
 	kvm_vcpu_srcu_read_unlock(vcpu);
+	vcpu->kvm->arch.float_int.last_sleep_cpu = vcpu->vcpu_idx;
 	kvm_vcpu_halt(vcpu);
 	vcpu->valid_wakeup = false;
 	__unset_cpu_idle(vcpu);
@@ -1948,18 +1949,15 @@ static void __floating_irq_kick(struct kvm *kvm, u64 type)
 	if (!online_vcpus)
 		return;
 
-	/* find idle VCPUs first, then round robin */
-	sigcpu = find_first_bit(kvm->arch.idle_mask, online_vcpus);
-	if (sigcpu == online_vcpus) {
-		do {
-			sigcpu = kvm->arch.float_int.next_rr_cpu++;
-			kvm->arch.float_int.next_rr_cpu %= online_vcpus;
-			/* avoid endless loops if all vcpus are stopped */
-			if (nr_tries++ >= online_vcpus)
-				return;
-		} while (is_vcpu_stopped(kvm_get_vcpu(kvm, sigcpu)));
+	for (sigcpu = kvm->arch.float_int.last_sleep_cpu; ; sigcpu++) {
+		sigcpu %= online_vcpus;
+		dst_vcpu = kvm_get_vcpu(kvm, sigcpu);
+		if (!is_vcpu_stopped(dst_vcpu))
+			break;
+		/* avoid endless loops if all vcpus are stopped */
+		if (nr_tries++ >= online_vcpus)
+			return;
 	}
-	dst_vcpu = kvm_get_vcpu(kvm, sigcpu);
 
 	/* make the VCPU drop out of the SIE, or wake it up if sleeping */
 	switch (type) {
-- 
2.43.5


