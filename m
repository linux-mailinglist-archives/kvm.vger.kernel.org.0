Return-Path: <kvm+bounces-70064-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDr0Inw+gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70064-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:29:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADFDDD95B
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BE73830C00F4
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E57B3F0758;
	Tue,  3 Feb 2026 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRHcFM22"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892C3EF0C3;
	Tue,  3 Feb 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142677; cv=none; b=Pg/OBHzKloVO/HS1W10UPIV8eS8DwVB7jbXWT7ucBFSsx+K0hUDZVBT8fIrcga8KKtMwREl9u/v+tCZ1CMwpbNWOMsgx4LkV4lVnr84rdEcmwMWU+ilR7sbNqT6pF4Q+L5KWnQw5SI3Y18+rii9aAE649Hcaicj140hFxFLHjpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142677; c=relaxed/simple;
	bh=FjSpOUFqM7dbnvpoaEWIFOrNUeXGSOriDiDTxrz25UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apN5nFC61elbtqGiyTwmdpbfT4Qr4NahFpIWbSNv35DikgDMDCw2c7LCpwKZ/hSWrpHeO+UJ0+X83j3cqN5JD0Mul5b5+RZoxYlrUTbE56EvIkHmxyONKmrAtHvcAQH1tiSFN99f75/BsQ2SzUs2Yj9oxoXfFe522Ta4Nm8jAG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRHcFM22; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142676; x=1801678676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FjSpOUFqM7dbnvpoaEWIFOrNUeXGSOriDiDTxrz25UM=;
  b=GRHcFM22mkfjeX0l2idVvBbsSoXHFtGKU7yuNhdOoKVVxxF1cwJEnCUo
   NXdhT8wDI7JO3I8QJ3kdRqhJGfyf7E9Tbx9xJXQUAQUiHw3bi46F4w2Ob
   lIxVqpLtJ3Y3fYeAS8kxkSpZescl/T3jmQiduWUuHSowNzbG0m+f/Jcdu
   yFIltpgSD7hM2TnsJ5h6WFKQD7vLjj+zxUCPv4N+DzfviF9RIRWefyzah
   uR6rWMIUFcvJ6vI3CVhDTduLlFCyelnmm0sLu8H2xUWCwWEGC4vXBA0Og
   8zW7r+1ViAL2AcY49/9zMuQv42fuBrYAIrPhcnacjAtzA/o4XMuclhkbX
   w==;
X-CSE-ConnectionGUID: 1CcTnZfGQZa1eBKoHB6IJg==
X-CSE-MsgGUID: KiDKSLBBSBSsfsbVDcaL2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745886"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745886"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:49 -0800
X-CSE-ConnectionGUID: bCxIVc83SBCHctIYb2RyiA==
X-CSE-MsgGUID: yn/xD6ADSXiVLhiUniyKGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605562"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:48 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 31/32] KVM: selftests: Add tests for nVMX to vmx_apic_timer_virt
Date: Tue,  3 Feb 2026 10:17:14 -0800
Message-ID: <122f9c32d232ca6a6e569ef164161feb64c1f624.1770116051.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70064-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0ADFDDD95B
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support nVMX for vmx_apic_timer_virt.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../kvm/x86/vmx_apic_timer_virt_test.c        | 207 +++++++++++++++++-
 1 file changed, 199 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
index ea465e9825d8..61aaf6faabce 100644
--- a/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
@@ -16,6 +16,15 @@
 
 #include <linux/math64.h>
 
+static bool nested;
+
+#define L2_GUEST_STACK_SIZE 256
+static unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+static uint64_t l2_tsc_offset;
+static uint64_t l2_tsc_multiplier;
+static uint64_t l2_tsc_khz;
+
 static uint64_t host_tsc_khz;
 static uint64_t max_guest_tsc_khz;
 
@@ -143,14 +152,15 @@ static void deadline_int_mask_test(void)
 
 static void deadline_hlt_test(void)
 {
+	uint64_t tsc_khz = nested ? l2_tsc_khz : guest_tsc_khz;
 	uint64_t tsc = rdtsc();
 	/* 1 msec future. */
-	uint64_t future = tsc + guest_tsc_khz;
+	uint64_t future = tsc + tsc_khz + 1;
 	uint64_t deadlines[] = {
 		1ull,
 		2ull,
 		/* pick a positive value between [0, tsc]. */
-		tsc > guest_tsc_khz ? tsc - guest_tsc_khz : tsc / 2 + 1,
+		tsc > tsc_khz ? tsc - tsc_khz : tsc / 2 + 1,
 		tsc,
 		/* If overflow, pick near future value > tsc. */
 		future > tsc ? future : ~0ull / 2 + tsc / 2,
@@ -168,10 +178,134 @@ static void guest_code(void)
 	deadline_int_test();
 	deadline_hlt_test();
 
-	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_TSCDEADLINE |
-			 APIC_LVT_MASKED | TIMER_VECTOR);
-	deadline_no_int_test();
-	deadline_int_mask_test();
+	/* L1 doesn't emulate LVTT entry so that mask is not supported. */
+	if (!nested) {
+		x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_TSCDEADLINE |
+				 APIC_LVT_MASKED | TIMER_VECTOR);
+		deadline_no_int_test();
+		deadline_int_mask_test();
+	}
+
+	if (nested)
+		vmcall();
+	else
+		GUEST_DONE();
+}
+
+static void skip_guest_instruction(void)
+{
+	uint64_t guest_rip, length;
+
+	GUEST_ASSERT(!vmread(GUEST_RIP, &guest_rip));
+	GUEST_ASSERT(!vmread(VM_EXIT_INSTRUCTION_LEN, &length));
+
+	GUEST_ASSERT(!vmwrite(GUEST_RIP, guest_rip + length));
+	GUEST_ASSERT(!vmwrite(VM_EXIT_INSTRUCTION_LEN, 0));
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+	union vmx_ctrl_msr ctls_msr, ctls2_msr;
+	uint64_t pin, ctls, ctls2, ctls3;
+	bool launch, done;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	prepare_vmcs(vmx_pages, guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* Check prerequisites */
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS, &ctls_msr.val));
+	GUEST_ASSERT(ctls_msr.clr & CPU_BASED_HLT_EXITING);
+	GUEST_ASSERT(ctls_msr.clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
+	GUEST_ASSERT(ctls_msr.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS);
+
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ctls2_msr.val));
+	GUEST_ASSERT(ctls2_msr.clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ctls3));
+	GUEST_ASSERT(ctls3 & TERTIARY_EXEC_GUEST_APIC_TIMER);
+
+	pin = vmreadz(PIN_BASED_VM_EXEC_CONTROL);
+	pin |= PIN_BASED_EXT_INTR_MASK;
+	GUEST_ASSERT(!vmwrite(PIN_BASED_VM_EXEC_CONTROL, pin));
+
+	ctls = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	ctls |= CPU_BASED_HLT_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
+		CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_TPR_SHADOW |
+		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
+		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	GUEST_ASSERT(!vmwrite(CPU_BASED_VM_EXEC_CONTROL, ctls));
+
+	/* guest apic timer requires virtual interrutp delivery */
+	ctls2 = vmreadz(SECONDARY_VM_EXEC_CONTROL);
+	ctls2 |= SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+		SECONDARY_EXEC_APIC_REGISTER_VIRT |
+		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+	vmwrite(SECONDARY_VM_EXEC_CONTROL, ctls2);
+
+	ctls3 = vmreadz(TERTIARY_VM_EXEC_CONTROL);
+	ctls3 |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+	GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls3));
+
+	/*
+	 * We don't emulate apic registers(including APIC_LVTT) for simplicity.
+	 * Directly set vector for timer interrupt instead.
+	 */
+	GUEST_ASSERT(!vmwrite(GUEST_APIC_TIMER_VECTOR, TIMER_VECTOR));
+
+	GUEST_ASSERT(!vmwrite(TSC_OFFSET, l2_tsc_offset));
+	if (l2_tsc_multiplier) {
+		GUEST_ASSERT(!vmwrite(TSC_MULTIPLIER, l2_tsc_multiplier));
+
+		GUEST_ASSERT(!vmread(SECONDARY_VM_EXEC_CONTROL, &ctls2));
+		ctls2 |= SECONDARY_EXEC_TSC_SCALING;
+		GUEST_ASSERT(!vmwrite(SECONDARY_VM_EXEC_CONTROL, ctls2));
+	} else {
+		GUEST_ASSERT(!vmread(SECONDARY_VM_EXEC_CONTROL, &ctls2));
+		ctls2 &= ~SECONDARY_EXEC_TSC_SCALING;
+		GUEST_ASSERT(!vmwrite(SECONDARY_VM_EXEC_CONTROL, ctls2));
+	}
+
+	/* launch L2 */
+	launch = true;
+	done = false;
+
+	while (!done) {
+		uint64_t reason;
+
+		if (launch) {
+			GUEST_ASSERT(!vmlaunch());
+			launch = false;
+		} else
+			GUEST_ASSERT(!vmresume());
+
+		GUEST_ASSERT(!vmread(VM_EXIT_REASON, &reason));
+
+		switch (reason) {
+		case EXIT_REASON_HLT: {
+			uint64_t phy, tsc;
+
+			skip_guest_instruction();
+			GUEST_ASSERT(!vmread(GUEST_DEADLINE_PHY, &phy));
+
+			/* Don't wait for more than 1 sec. */
+			tsc = rdtsc();
+			if (tsc < phy && tsc < ~0ULL - guest_tsc_khz)
+				GUEST_ASSERT(tsc + guest_tsc_khz * 1000 >= tsc);
+
+			while (tsc <= phy)
+				tsc = rdtsc();
+			break;
+		}
+		case EXIT_REASON_VMCALL:
+			done = true;
+			break;
+		default:
+			GUEST_FAIL("unexpected exit reason 0x%lx", reason);
+			break;
+		}
+	}
 
 	GUEST_DONE();
 }
@@ -209,9 +343,17 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	if (nested) {
+		vm_vaddr_t vmx_pages_gva = 0;
+
+		vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+		vcpu_alloc_vmx(vm, &vmx_pages_gva);
+		vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	} else
+		vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	if (guest_tsc_khz__) {
+		uint64_t l1_tsc_multiplier;
 		int ret;
 
 		ret = __vcpu_ioctl(vcpu, KVM_SET_TSC_KHZ, (void *)guest_tsc_khz__);
@@ -221,7 +363,34 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
 		}
 
 		guest_tsc_khz = guest_tsc_khz__;
-	}
+
+		/*
+		 * Pick same to L1 tsc multplier.  Any value to exercise
+		 * corner cases is okay.
+		 */
+		l1_tsc_multiplier = ((__uint128_t)guest_tsc_khz__ *
+				     (1ULL << 48)) / host_tsc_khz;
+		l2_tsc_multiplier = l1_tsc_multiplier;
+		/*
+		 * l1_multiplier * l2_multiplier needs to be represented in
+		 * the host.
+		 */
+		if ((__uint128_t)l1_tsc_multiplier * l2_tsc_multiplier >
+		    ((__uint128_t)1ULL << (63 + 48))) {
+
+			l2_tsc_multiplier = ((__uint128_t)1ULL << (63 + 48)) /
+				l1_tsc_multiplier;
+			if (!l2_tsc_multiplier)
+				l1_tsc_multiplier = 1;
+		}
+
+		l2_tsc_khz = ((__uint128_t)l2_tsc_multiplier * guest_tsc_khz__) >> 48;
+		if (!l2_tsc_khz) {
+			l2_tsc_multiplier = 1ULL << 48;
+			l2_tsc_khz = guest_tsc_khz__;
+		}
+	} else
+		l2_tsc_khz = host_tsc_khz;
 
 	if (tsc_offset) {
 		uint64_t offset;
@@ -237,6 +406,9 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
 		offset = -rdtsc();
 		vcpu_device_attr_set(vcpu, KVM_VCPU_TSC_CTRL,
 				     KVM_VCPU_TSC_OFFSET, &offset);
+
+		/* Pick a non-zero value */
+		l2_tsc_offset = offset;
 	}
 
 	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_TSC_DEADLINE_TIMER);
@@ -245,10 +417,18 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
 
 	sync_global_to_guest(vm, host_tsc_khz);
 	sync_global_to_guest(vm, guest_tsc_khz);
+	sync_global_to_guest(vm, nested);
+	sync_global_to_guest(vm, l2_tsc_offset);
+	sync_global_to_guest(vm, l2_tsc_multiplier);
+	sync_global_to_guest(vm, l2_tsc_khz);
 	run_vcpu(vcpu);
 
 	kvm_vm_free(vm);
 
+	l2_tsc_offset = 0;
+	l2_tsc_multiplier = 0;
+	l2_tsc_khz = 0;
+
 	return 0;
 }
 
@@ -313,5 +493,16 @@ int main(int argc, char *argv[])
 
 	test();
 
+	ctls.val = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	if (ctls.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
+		ctls3 = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS3);
+	else
+		ctls3 = 0;
+	if (kvm_cpu_has(X86_FEATURE_VMX) &&
+	    ctls3 & TERTIARY_EXEC_GUEST_APIC_TIMER) {
+		nested = true;
+		test();
+	}
+
 	return 0;
 }
-- 
2.45.2


