Return-Path: <kvm+bounces-59179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C03ABAE0E4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E8F317083D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F0624DCE6;
	Tue, 30 Sep 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O7UZeSSX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCB01EE02F;
	Tue, 30 Sep 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250040; cv=none; b=M1GTW4k6/DvAo8zodDI6wGtCz+S+eR0eXGEyBp7kivT23sxU4OsSk9+wPHi69kfJoTuiaigrrP4nKujLyzZCMsvyFuKy+MRZOTCrgwQeOpZKqx/awkq33fVoSN02h3czBaYmcR1SwYJt2OUgmJVW/Amq4diS0BpJQt8PhC9Ekfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250040; c=relaxed/simple;
	bh=JeVMKuffTltqCxQ+1VZL2ev9IMiA2A6LD5PPYQTXpx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W0GudYco+xMjNFKJzlfwdwdLHadCwJB1sFYuJvf5lKHy4zNLOnWmsrC2r+zI+2OI+OWUgIPLJgWRcDY8K4jde9TngBI9OV3agu0ilvpvxSJxR4pRzryMDnruxIArh/jVDoZHwu5RhWw+uC63Msu+Gkmh9cQjkgpRtwOPxq3/1a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O7UZeSSX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U8cBjn030156;
	Tue, 30 Sep 2025 16:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0kzkgR
	e0OgYCsVNK4qqVm0TCVY0w8qGUxBXxUwNeT8A=; b=O7UZeSSXO6FllFvBcOg1r6
	eMu/8/O4fl77dRWQnEu+hCUMf9dn+7KTa1zYmlYOcjOCNHtgfKggROluwfQq7wUL
	DPU7DCOoBNMZkhSauYYQ08VCROWsGrf/YnsYW/iuDZD8bUsYsp2Nau3gfumGiZtA
	7P8QcTZuG0Je8RYU1Vb2LXX87t4LivuDvpR/xA232KK8TXXSahtrbrUQoPxgTaIj
	W0KQ7jf44jY0ZlFS8e8FzrCkP0ZfEurVATW7ucqs+vSSHNp7GxQWO6UEmDsUE+EV
	MhoW+zabU3kA4jVDpZWRxo6tVylcyLxioZNHJz/e1o9s3SMSWMBbi+zXd1AiwWZw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7e7a8pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 16:33:56 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58UG5cwu003599;
	Tue, 30 Sep 2025 16:33:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49etmxvh7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 16:33:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58UGXo9W49414460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 16:33:50 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBE3D20040;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D4C12004B;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 1/2] KVM: s390: improve interrupt cpu for wakeup
Date: Tue, 30 Sep 2025 18:33:49 +0200
Message-ID: <20250930163350.83377-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930163350.83377-1-imbrenda@linux.ibm.com>
References: <20250930163350.83377-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PT0IhOt-eBqjJj4gIa1hrMC2nF4Kbayr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyMCBTYWx0ZWRfX36f4uPdp62zm
 mk2Ni1j6/jr3u2eT5GVpBMHEWaSyQM0JXaVcgvGuHIm5McJACF3gO15p0Ri7MWJAxs6SXTodboT
 2YECnoZoE0dFUXXIXS7WUDDZETWXauyzNz9TgYa3NB5GuZJUMhpUBgmoQ7ptrca4Q2F6HodJtZw
 r2hMMGAb1fnFk9nySfSxFBqKxYXUOe9aK3ZE0XR8ykfnj2Uy7bn8Du0mFLZPxdvLe1cbJLZgqDe
 TUJqjDEdyh0jGOdqCFzNYg4P8znK76no+VDNxZKZQl3UsJkNU8gT756auTZE20ra+5dZ/plf3z4
 xTN7UCr1mI//v041IoYu79r3fUF2Hz1lDGybAE189hFQpf0tIy/WuvXPc8dDA8K6IHw14PShQjU
 DsL6nlxTFJ5kNVKJuASUca8AQXKvbQ==
X-Proofpoint-GUID: PT0IhOt-eBqjJj4gIa1hrMC2nF4Kbayr
X-Authority-Analysis: v=2.4 cv=Jvj8bc4C c=1 sm=1 tr=0 ts=68dc0674 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=YZNRh9FhO95UtZAz9dIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270020

From: Christian Borntraeger <borntraeger@linux.ibm.com>

Turns out that picking an idle CPU for floating interrupts has some
negative side effects. The guest will keep the IO workload on its CPU
and rather use an IPI from the interrupt CPU instead of moving workload.
For example a guest with 2 vCPUs and 1 fio process might run that fio on
vcpu1. If after diag500 both vCPUs are idle then vcpu0 is woken up. The
guest will then do an IPI from vcpu0 to vcpu1.

So lets change the heuristics and prefer the last CPU that went to
sleep. This one is likely still in halt polling and can be woken up
quickly.

This patch shows significant improvements in terms of bandwidth or
cpu consumption for fio and uperf workloads and seems to be a net
win.

Link: https://lore.kernel.org/linux-s390/20250904113927.119306-1-borntraeger@linux.ibm.com/
Reviewed-by: Christoph Schlameuß <schlameuss@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kvm/interrupt.c        | 20 +++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f870d09515cc..95d15416c39d 100644
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
index 60c360c18690..b8e6f82e92c3 100644
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
2.51.0


