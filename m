Return-Path: <kvm+bounces-63385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E737AC64DA3
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 6ABE4242E1
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B84A32D443;
	Mon, 17 Nov 2025 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b="d8tjyaMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-108-mta217.mxroute.com (mail-108-mta217.mxroute.com [136.175.108.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D3339714
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763392999; cv=none; b=JGh7Ou49TajMv2Curvl8Siuj3PtmEh2WlJp5/zt+ZrLgq3fFKhQ3ZK/8pMzUD2ZC3JPAe9B/xuy8TtIgyGAj/xqvHSe5mGt6St+q2qDr7i4cU5nj7E8EXHoSc34kvBJ/9vL4mytxhvRJzibb11nZJ0dxiliq83iCtwjZQywTULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763392999; c=relaxed/simple;
	bh=bPlklBPRnGelVLyR+K8rFJNYZjuG4Wgq7bRsrFW200A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YD4LeR7m76gK3pBvbkJyQQ2uW6boxYokfL1y/Lc8f1ojztu+Qg5ET3z0cHoIlKd+oj1GkTQ4d/ZoVjrmcc6ym+iyw6Yth6xUzT8j+QC8NNeCnjWF7IubkHa4lh6MUEjryBrX7NiRc6++XVv7i0r9XzCleA8YMqOWIT1jy3F8iI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol; spf=pass smtp.mailfrom=josie.lol; dkim=pass (2048-bit key) header.d=josie.lol header.i=@josie.lol header.b=d8tjyaMt; arc=none smtp.client-ip=136.175.108.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=josie.lol
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=josie.lol
Received: from filter006.mxroute.com ([140.82.40.27] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta217.mxroute.com (ZoneMTA) with ESMTPSA id 19a926504ca0004eea.009
 for <kvm@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 17 Nov 2025 15:18:05 +0000
X-Zone-Loop: 6becf1612eae9db99d19aef167d78a4e7cd81909fd48
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=josie.lol;
	s=x; h=Content-Transfer-Encoding:MIME-Version:Date:Subject:Cc:To:From:Sender:
	Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References;
	bh=yp8ThmNEfdXatiuuUIM3tmyODVgdlt40nDVIwOpvegA=; b=d8tjyaMt7Q/W1mk3nBaLU3zf69
	PBECHsLt0lD5GzJRKJ0hj2FmhaUU8BLietqBsuvH81nc7LHL9eVCeJblCeWLEoieLZ6Lu9aMZ7D/d
	h/WF/L+g3EFH27XRn2aQNsQImLDTRO8XC2BBUE/cCtCZ8dMeDEdQMTPDtKUWBabuWliPEPudzFc69
	Xc/BekFh6wUtIkwv/P1UFMEtEu9+eGqPFttZ0K3XVpmsxRYJVvefUHGKi9F2itpzzXxZLIARoyz/B
	SWjx7ZxfI1gP2Uw2QI1dPX9wW1DSFhbGSXjGnI7A1ZIzdj69tBkIo6Kd7JsJSTmtZ8rrFyisjtfLY
	2vZ6n2Ng==;
From: Josephine Pfeiffer <hi@josie.lol>
To: borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Cc: david@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	svens@linux.ibm.com,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Implement CHECK_STOP support and fix GET_MP_STATE
Date: Mon, 17 Nov 2025 16:18:00 +0100
Message-ID: <20251117151800.248407-1-hi@josie.lol>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: hi@josie.lol

Add support for KVM_MP_STATE_CHECK_STOP to enable proper VM migration
and error handling for s390 guests. The CHECK_STOP state represents a
CPU that encountered a severe machine check and is halted in an error
state.

This implementation adds:
- CPUSTAT_CHECK_STOP flag to track check-stopped CPUs
- is_vcpu_check_stopped() helper macro for state checking
- kvm_s390_vcpu_check_stop() function to transition CPUs to CHECK_STOP
- Integration with Protected VM Ultravisor (PV_CPU_STATE_CHKSTP)
- Interrupt blocking for check-stopped CPUs in deliverable_irqs()
- Recovery path enabling CHECK_STOP -> OPERATING transitions
- Proper state precedence where CHECK_STOP takes priority over STOPPED

Signed-off-by: Josephine Pfeiffer <hi@josie.lol>
---
 arch/s390/include/asm/kvm_host_types.h |  1 +
 arch/s390/kvm/interrupt.c              |  3 ++
 arch/s390/kvm/kvm-s390.c               | 72 ++++++++++++++++++++++----
 arch/s390/kvm/kvm-s390.h               |  6 +++
 arch/s390/kvm/sigp.c                   |  8 ++-
 5 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
index 1394d3fb648f..a86e326a2eee 100644
--- a/arch/s390/include/asm/kvm_host_types.h
+++ b/arch/s390/include/asm/kvm_host_types.h
@@ -111,6 +111,7 @@ struct mcck_volatile_info {
 	((((sie_block)->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
 
 #define CPUSTAT_STOPPED    0x80000000
+#define CPUSTAT_CHECK_STOP 0x40000000
 #define CPUSTAT_WAIT	   0x10000000
 #define CPUSTAT_ECALL_PEND 0x08000000
 #define CPUSTAT_STOP_INT   0x04000000
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c62a868cf2b6..e09e5aff318a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -361,6 +361,9 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 	if (!active_mask)
 		return 0;
 
+	if (kvm_s390_test_cpuflags(vcpu, CPUSTAT_CHECK_STOP))
+		return 0;
+
 	if (psw_extint_disabled(vcpu))
 		active_mask &= ~IRQ_PEND_EXT_MASK;
 	if (psw_ioint_disabled(vcpu))
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 16ba04062854..25eb3bebdfea 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4465,16 +4465,17 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	int ret;
-
 	vcpu_load(vcpu);
 
-	/* CHECK_STOP and LOAD are not supported yet */
-	ret = is_vcpu_stopped(vcpu) ? KVM_MP_STATE_STOPPED :
-				      KVM_MP_STATE_OPERATING;
+	if (is_vcpu_check_stopped(vcpu))
+		mp_state->mp_state = KVM_MP_STATE_CHECK_STOP;
+	else if (is_vcpu_stopped(vcpu))
+		mp_state->mp_state = KVM_MP_STATE_STOPPED;
+	else
+		mp_state->mp_state = KVM_MP_STATE_OPERATING;
 
 	vcpu_put(vcpu);
-	return ret;
+	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
@@ -4502,7 +4503,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		rc = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_OPR_LOAD);
 		break;
 	case KVM_MP_STATE_CHECK_STOP:
-		fallthrough;	/* CHECK_STOP and LOAD are not supported yet */
+		rc = kvm_s390_vcpu_check_stop(vcpu);
+		break;
 	default:
 		rc = -ENXIO;
 	}
@@ -5488,7 +5490,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 {
 	int i, online_vcpus, r = 0, started_vcpus = 0;
 
-	if (!is_vcpu_stopped(vcpu))
+	if (!is_vcpu_stopped(vcpu) && !is_vcpu_check_stopped(vcpu))
 		return 0;
 
 	trace_kvm_s390_vcpu_start_stop(vcpu->vcpu_id, 1);
@@ -5506,7 +5508,9 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 	}
 
 	for (i = 0; i < online_vcpus; i++) {
-		if (!is_vcpu_stopped(kvm_get_vcpu(vcpu->kvm, i)))
+		struct kvm_vcpu *tmp = kvm_get_vcpu(vcpu->kvm, i);
+
+		if (!is_vcpu_stopped(tmp) && !is_vcpu_check_stopped(tmp))
 			started_vcpus++;
 	}
 
@@ -5522,7 +5526,7 @@ int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu)
 		__disable_ibs_on_all_vcpus(vcpu->kvm);
 	}
 
-	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
+	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED | CPUSTAT_CHECK_STOP);
 	/*
 	 * The real PSW might have changed due to a RESTART interpreted by the
 	 * ultravisor. We block all interrupts and let the next sie exit
@@ -5566,7 +5570,11 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 	 * now that the SIGP STOP and SIGP STOP AND STORE STATUS orders
 	 * have been fully processed. This will ensure that the VCPU
 	 * is kept BUSY if another VCPU is inquiring with SIGP SENSE.
+	 *
+	 * Clear CHECK_STOP before setting STOPPED to handle the state
+	 * transition CHECK_STOP -> STOPPED.
 	 */
+	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_CHECK_STOP);
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
 	kvm_s390_clear_stop_irq(vcpu);
 
@@ -5575,7 +5583,7 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 	for (i = 0; i < online_vcpus; i++) {
 		struct kvm_vcpu *tmp = kvm_get_vcpu(vcpu->kvm, i);
 
-		if (!is_vcpu_stopped(tmp)) {
+		if (!is_vcpu_stopped(tmp) && !is_vcpu_check_stopped(tmp)) {
 			started_vcpus++;
 			started_vcpu = tmp;
 		}
@@ -5593,6 +5601,48 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int kvm_s390_vcpu_check_stop(struct kvm_vcpu *vcpu)
+{
+	int r = 0;
+
+	/* trace: 0=stop, 1=start, 2=check-stop */
+	trace_kvm_s390_vcpu_start_stop(vcpu->vcpu_id, 2);
+	/* Only one cpu at a time may enter/leave the STOPPED/CHECK_STOP state. */
+	spin_lock(&vcpu->kvm->arch.start_stop_lock);
+
+	if (kvm_s390_test_cpuflags(vcpu, CPUSTAT_CHECK_STOP)) {
+		__disable_ibs_on_vcpu(vcpu);
+		goto out;
+	}
+
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		r = kvm_s390_pv_set_cpu_state(vcpu, PV_CPU_STATE_CHKSTP);
+		if (r) {
+			spin_unlock(&vcpu->kvm->arch.start_stop_lock);
+			return r;
+		}
+	}
+
+	/*
+	 * Clear STOPPED if it was set, CHECK_STOP takes precedence.
+	 * This allows the transition STOPPED -> CHECK_STOP.
+	 * The reverse transition CHECK_STOP -> STOPPED is handled by
+	 * kvm_s390_vcpu_stop() which clears CHECK_STOP before setting STOPPED.
+	 */
+	if (kvm_s390_test_cpuflags(vcpu, CPUSTAT_STOPPED))
+		kvm_s390_clear_cpuflags(vcpu, CPUSTAT_STOPPED);
+
+	kvm_s390_set_cpuflags(vcpu, CPUSTAT_CHECK_STOP);
+	kvm_s390_clear_stop_irq(vcpu);
+	__disable_ibs_on_vcpu(vcpu);
+
+out:
+	spin_unlock(&vcpu->kvm->arch.start_stop_lock);
+	return r;
+}
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c44fe0c3a097..6851f52bdddb 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -98,6 +98,11 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
 	return kvm_s390_test_cpuflags(vcpu, CPUSTAT_STOPPED);
 }
 
+static inline int is_vcpu_check_stopped(struct kvm_vcpu *vcpu)
+{
+	return kvm_s390_test_cpuflags(vcpu, CPUSTAT_CHECK_STOP);
+}
+
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
 	return test_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
@@ -451,6 +456,7 @@ int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr);
 int kvm_s390_vcpu_start(struct kvm_vcpu *vcpu);
 int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu);
+int kvm_s390_vcpu_check_stop(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unblock(struct kvm_vcpu *vcpu);
 bool kvm_s390_vcpu_sie_inhibited(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 55c34cb35428..03f1084f63cf 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -21,16 +21,19 @@ static int __sigp_sense(struct kvm_vcpu *vcpu, struct kvm_vcpu *dst_vcpu,
 			u64 *reg)
 {
 	const bool stopped = kvm_s390_test_cpuflags(dst_vcpu, CPUSTAT_STOPPED);
+	const bool check_stopped = kvm_s390_test_cpuflags(dst_vcpu, CPUSTAT_CHECK_STOP);
 	int rc;
 	int ext_call_pending;
 
 	ext_call_pending = kvm_s390_ext_call_pending(dst_vcpu);
-	if (!stopped && !ext_call_pending)
+	if (!stopped && !check_stopped && !ext_call_pending)
 		rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 	else {
 		*reg &= 0xffffffff00000000UL;
 		if (ext_call_pending)
 			*reg |= SIGP_STATUS_EXT_CALL_PENDING;
+		if (check_stopped)
+			*reg |= SIGP_STATUS_CHECK_STOP;
 		if (stopped)
 			*reg |= SIGP_STATUS_STOPPED;
 		rc = SIGP_CC_STATUS_STORED;
@@ -221,7 +224,8 @@ static int __sigp_sense_running(struct kvm_vcpu *vcpu,
 		return SIGP_CC_STATUS_STORED;
 	}
 
-	if (kvm_s390_test_cpuflags(dst_vcpu, CPUSTAT_RUNNING)) {
+	if (kvm_s390_test_cpuflags(dst_vcpu, CPUSTAT_RUNNING) &&
+	    !kvm_s390_test_cpuflags(dst_vcpu, CPUSTAT_CHECK_STOP)) {
 		/* running */
 		rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 	} else {
-- 
2.51.2


