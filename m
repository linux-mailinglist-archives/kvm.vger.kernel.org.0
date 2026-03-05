Return-Path: <kvm+bounces-72918-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJUYDe/DqWm2EQEAu9opvQ
	(envelope-from <kvm+bounces-72918-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:57:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88515216A2C
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DAE9A31AD1CE
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D770A47CC6D;
	Thu,  5 Mar 2026 17:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbPo3t3g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B57438FF9;
	Thu,  5 Mar 2026 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732700; cv=none; b=RQ4qjiB+afd1qogMzyxOgkqxH9a7vIzq0qhbF59OLiYZlX6lSCkJqSKY7V509QlkvkSkoFRJQ5wvx/dIIv/jKV9Tp9EyOpX/FvmrYxfQJWknwW1ySU1kOZWwww1LNaTBm1QupRD88A5SPotwRDIWpSLzJu9U8W90rX62aCekmkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732700; c=relaxed/simple;
	bh=nL3oFzrlfSMxpuut0on0gxF6pM5Gl8ZNnOb/qRUnp3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5fZZkOAmJcLDQjnK/0NxiCu3iZpQRmc187O/bHKtpamu5PQHG1JqDXy/uMHgSfXeocupy1MeUfIk/rumrH5SO+3OL1aazM3CdCIzF8N2sr5RabSpgSZTns536pUY3oMqUHxXsZ10lg4kyfWr4h1+p06KhyaUbJxd3hK1difpCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbPo3t3g; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732695; x=1804268695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nL3oFzrlfSMxpuut0on0gxF6pM5Gl8ZNnOb/qRUnp3k=;
  b=lbPo3t3gy+qD5n629DqOq44ZgwW+ion1UMCtAwbb4lRaSGJThLyp1CCz
   EnjliLd2WTahOosyZp+TLBAh7fSqcyh02OYmMIs2BjzWMgil3nbatL0BF
   zaCbmx1xMxx4bkeebOfYhBwybfED/tKhS2kKSNnS4e+0HeVrdPV6bCIfG
   Eu7omfMxvF940YlAChLx/LstAJ35QCe/PRLEhJv5ydG50X7epXQpft3Ws
   LlM5F1iOBpO8xJnP7uv6Yk/0617Se17WlmSt7soj8/CJj89EhQlZcJIh/
   GrJzjGPimzYNJ83GmZeaadYv028H1VY8RH9dHcBvopZdNAs5B3LlG4RDb
   Q==;
X-CSE-ConnectionGUID: aGdUp7jFTyWO6EbREsk4FA==
X-CSE-MsgGUID: P0yFHGkNQ5+QaB5qrZ5I7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701150"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701150"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:54 -0800
X-CSE-ConnectionGUID: 7IhUO+paQtCCaJp7smhynA==
X-CSE-MsgGUID: pW5ItRRoT3GU2AXhRuJK6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256647693"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:54 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 33/36] KVM: selftests: Add tests for nVMX to vmx_apic_timer_virt
Date: Thu,  5 Mar 2026 09:44:13 -0800
Message-ID: <3ad6662c156f05747f3ff8e6d0d29b80be62e112.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88515216A2C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72918-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support nVMX for vmx_apic_timer_virt.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- Fix compile error.
---
 .../kvm/x86/vmx_apic_timer_virt_test.c        | 209 +++++++++++++++++-
 1 file changed, 201 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_timer_virt_test.c
index 3eb544363570..2779d0cac7ee 100644
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
 
@@ -144,14 +153,15 @@ static void deadline_int_mask_test(void)
 
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
@@ -169,10 +179,134 @@ static void guest_code(void)
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
@@ -210,9 +344,17 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
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
@@ -222,7 +364,34 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
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
@@ -238,6 +407,9 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
 		offset = -rdtsc();
 		vcpu_device_attr_set(vcpu, KVM_VCPU_TSC_CTRL,
 				     KVM_VCPU_TSC_OFFSET, &offset);
+
+		/* Pick a non-zero value */
+		l2_tsc_offset = offset;
 	}
 
 	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_TSC_DEADLINE_TIMER);
@@ -246,10 +418,18 @@ static int test_tsc_deadline(bool tsc_offset, uint64_t guest_tsc_khz__)
 
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
 
@@ -286,6 +466,8 @@ static void test(void)
 int main(int argc, char *argv[])
 {
 	uint32_t eax_denominator, ebx_numerator, ecx_hz, edx;
+	union vmx_ctrl_msr ctls;
+	uint64_t ctls3;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_X2APIC));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SERIALIZE));
@@ -313,5 +495,16 @@ int main(int argc, char *argv[])
 
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


