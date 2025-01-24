Return-Path: <kvm+bounces-36544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB481A1B866
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 501F716903F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 15:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E84156238;
	Fri, 24 Jan 2025 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="C7++pApb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DF378F57;
	Fri, 24 Jan 2025 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737731158; cv=none; b=hBBWlQ+V9UcKU7dYMP90zL+BLK+u5WufMKF8ei3W/3HPXwEkrT77kM67aI2BrrL1RkVZF6+68AfnZ1nb3swHUyRf+NA4YO9lo3GUkfkzNVwLC1GqIWBhUlMRpaXGX0Q4lpdProewslELDndT3fVZj3bRdExMMkZf1TsdSSor34c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737731158; c=relaxed/simple;
	bh=RXrKOghBdoxlAm1TOxIq4MYTj/FZX2ZSOvZy+kH6Ro0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jFkbFjYd8jU1TVAR2JCA5fdDzc/Bb4qJHosnGtGiVT49vgo6gidB4HZa8FkbQZhVn/V5bCYLOrmt0dPl8YZ+acQT2NJIJ8LUvbtgbSFl6U2DKroUB2GSF4wr2uLhFYDLM9Vpi074G0dTrnaMsCOmM30+yhQR5dnJxgf1ybKOsb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=C7++pApb; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737731156; x=1769267156;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XlTDsnQoodBIwILVQwR5ogYN5C106rc27ZM2C6oIKEM=;
  b=C7++pApbIOQsKgdRJKt4lOxnCqx/4vX98G8T1K07v+f/f9HF393husJa
   76ldzWvLnJ+1KW+So88TOyNWt3uhXSyzJ0VA9a7rMpHjliVH0ZnfMVYvn
   m1ArvK/2VYDMsXq8sYveEbEaEURS010810YaJRTeGadAT6AyREKy/YAo5
   c=;
X-IronPort-AV: E=Sophos;i="6.13,231,1732579200"; 
   d="scan'208";a="166725375"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 15:05:53 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:3302]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.23.16:2525] with esmtp (Farcaster)
 id 09577ee1-3da1-4993-b3f6-dee7b2de7820; Fri, 24 Jan 2025 15:05:52 +0000 (UTC)
X-Farcaster-Flow-ID: 09577ee1-3da1-4993-b3f6-dee7b2de7820
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 24 Jan 2025 15:05:52 +0000
Received: from EX19MTAUEA002.ant.amazon.com (10.252.134.9) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Fri, 24 Jan 2025 15:05:51 +0000
Received: from email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.134.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Fri, 24 Jan 2025 15:05:51 +0000
Received: from dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com (dev-dsk-fgriffo-1c-69b51a13.eu-west-1.amazon.com [10.13.244.152])
	by email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com (Postfix) with ESMTPS id 1160640A31;
	Fri, 24 Jan 2025 15:05:48 +0000 (UTC)
From: Fred Griffoul <fgriffo@amazon.co.uk>
To: <kvm@vger.kernel.org>
CC: <griffoul@gmail.com>, <vkuznets@redhat.com>, Fred Griffoul
	<fgriffo@amazon.co.uk>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant
	<paul@xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: Update Xen TSC leaves during CPUID emulation
Date: Fri, 24 Jan 2025 15:05:39 +0000
Message-ID: <20250124150539.69975-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The Xen emulation in KVM modifies certain CPUID leaves to expose
TSC information to the guest.

Previously, these CPUID leaves were updated whenever guest time changed,
but this conflicts with KVM_SET_CPUID/KVM_SET_CPUID2 ioctls which reject
changes to CPUID entries on running vCPUs.

Fix this by updating the TSC information directly in the CPUID emulation
handler instead of modifying the vCPU's CPUID entries.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/cpuid.c | 16 ++++++++++++++++
 arch/x86/kvm/x86.c   |  3 +--
 arch/x86/kvm/x86.h   |  1 +
 arch/x86/kvm/xen.c   | 23 -----------------------
 arch/x86/kvm/xen.h   | 13 +++++++++++--
 5 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index edef30359c19..689882326618 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -2005,6 +2005,22 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		} else if (function == 0x80000007) {
 			if (kvm_hv_invtsc_suppressed(vcpu))
 				*edx &= ~feature_bit(CONSTANT_TSC);
+		} else if (IS_ENABLED(CONFIG_KVM_XEN) &&
+			   kvm_xen_is_tsc_leaf(vcpu, function)) {
+			/*
+			 * Update guest TSC frequency information is necessary.
+			 * Ignore failures, there is no sane value that can be
+			 * provided if KVM can't get the TSC frequency.
+			 */
+			if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu))
+				kvm_guest_time_update(vcpu);
+
+			if (index == 1) {
+				*ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
+				*edx = vcpu->arch.hv_clock.tsc_shift;
+			} else if (index == 2) {
+				*eax = vcpu->arch.hw_tsc_khz;
+			}
 		}
 	} else {
 		*eax = *ebx = *ecx = *edx = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..ed33a18e8ac1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3170,7 +3170,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
 }

-static int kvm_guest_time_update(struct kvm_vcpu *v)
+int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags, tgt_tsc_khz;
 	unsigned seq;
@@ -3253,7 +3253,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				   &vcpu->hv_clock.tsc_shift,
 				   &vcpu->hv_clock.tsc_to_system_mul);
 		vcpu->hw_tsc_khz = tgt_tsc_khz;
-		kvm_xen_update_tsc_info(v);
 	}

 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7a87c5fc57f1..5fdf32ba9406 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -362,6 +362,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 u64 get_kvmclock_ns(struct kvm *kvm);
 uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm);
 bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
+int kvm_guest_time_update(struct kvm_vcpu *v);

 int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 	gva_t addr, void *val, unsigned int bytes,
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..ed5c2f088361 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -2247,29 +2247,6 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }

-void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *entry;
-	u32 function;
-
-	if (!vcpu->arch.xen.cpuid.base)
-		return;
-
-	function = vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3);
-	if (function > vcpu->arch.xen.cpuid.limit)
-		return;
-
-	entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
-	if (entry) {
-		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
-		entry->edx = vcpu->arch.hv_clock.tsc_shift;
-	}
-
-	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
-	if (entry)
-		entry->eax = vcpu->arch.hw_tsc_khz;
-}
-
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.xen.xen_lock);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f5841d9000ae..8238d64127eb 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,7 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__

+#include <asm/xen/cpuid.h>
 #include <asm/xen/hypervisor.h>

 #ifdef CONFIG_KVM_XEN
@@ -35,7 +36,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
-void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);

 static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
 {
@@ -50,6 +50,14 @@ static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
 		kvm_xen_inject_vcpu_vector(vcpu);
 }

+static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function)
+{
+	return static_branch_unlikely(&kvm_xen_enabled.key) &&
+		vcpu->arch.xen.cpuid.base &&
+		function <= vcpu->arch.xen.cpuid.limit &&
+		function == (vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3));
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -157,8 +165,9 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 	return false;
 }

-static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function)
 {
+	return false;
 }
 #endif

--
2.40.1


