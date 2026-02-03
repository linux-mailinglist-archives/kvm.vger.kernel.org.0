Return-Path: <kvm+bounces-70058-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJ4cCwc+gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70058-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:27:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CACDD8FC
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F5403069A40
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2AB3EDAC7;
	Tue,  3 Feb 2026 18:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gG6GKDB0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892F3ECBD7;
	Tue,  3 Feb 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142673; cv=none; b=PYPdhuirZqj8SYHU0chCZJ3pR4F5HN6r/ydQHWgcjba7r7kg6DVWlzB8xdUpRAW8x5s1Hw92FKV6u+Y/Z5JsU2TRpQc/l5zU8/jaSx697XFZdi9jjzC2uTqEjeftbva4xRgBgGDBYk+8oDsOQEsxsql2WtPdSFcYqUYe79ZCv7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142673; c=relaxed/simple;
	bh=hDRCEcsCvNNOTbuhPMcR+uWFWLbjO9Z+jIj4RLnNVC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2fwHkkwMUSLwbC1UnnMKdC3ySg0+l5heHyLE9RPFWd5qdjexQCjqMaxZg1j8sfSzavg6gptj4gpIi2DhPc3rLrYZRjZfyG97mh2tczwjgWvzmiO+AZXY6HANMuTi8rZAKms8BZ9S1/fbQbLDave/J/2S6jKSCLrNpe8wh1ojaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gG6GKDB0; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142672; x=1801678672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hDRCEcsCvNNOTbuhPMcR+uWFWLbjO9Z+jIj4RLnNVC8=;
  b=gG6GKDB0UP9FZhu/HL5yD5vRSHwgaNsYbM8MIbOED0hVkYYOZA7K+FiU
   rEbmD5ZRTSF2PgFWSH902FcJIgn5reTfyb+WmMVYoPcXm2zJhzFh2x9uX
   wnrHlQamj9wi2V9qRuv1BnHW4Y5nmJ77+ME1As3RzGIouuo5O0bJE5Wgw
   0/YmKXuCBJVhM4pqKEFyVQeRZEJ1orpw92OYopDtlm0MFYinodWFci5rP
   lErArthF6vDVtUk+zrjWI3gh5b5cgVyCtBwO7S2LA9JAofY+vKFpus3RQ
   DsaC1CfRPiJIPz5nDZZRYCelh+/gFRmuKiLaoube3rcagHIy9wPRhf/I4
   g==;
X-CSE-ConnectionGUID: A0BQXIWGRDueiQmfaQDhiA==
X-CSE-MsgGUID: 6Sw1t81QTmyKhT2LA6QEWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745858"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745858"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:47 -0800
X-CSE-ConnectionGUID: VxUYhekMSdCohXPUz3ur9g==
X-CSE-MsgGUID: ARJin5auT3efKdbSxjPAig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605530"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:46 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 25/32] KVM: selftests: Add nVMX support to timer_latency test case
Date: Tue,  3 Feb 2026 10:17:08 -0800
Message-ID: <18f54797d5a705719a8fb8dfce74fc4cfb5d1e18.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70058-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 46CACDD8FC
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support nVMX for the timer_latency test case to exercise the nVMX APIC
timer virtualization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h |  10 ++
 .../testing/selftests/kvm/x86/timer_latency.c | 132 +++++++++++++++++-
 2 files changed, 139 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 96e2b4c630a9..304892500089 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -24,6 +24,7 @@
 #define CPU_BASED_RDTSC_EXITING			0x00001000
 #define CPU_BASED_CR3_LOAD_EXITING		0x00008000
 #define CPU_BASED_CR3_STORE_EXITING		0x00010000
+#define CPU_BASED_ACTIVATE_TERTIARY_CONTROLS	0x00020000
 #define CPU_BASED_CR8_LOAD_EXITING		0x00080000
 #define CPU_BASED_CR8_STORE_EXITING		0x00100000
 #define CPU_BASED_TPR_SHADOW			0x00200000
@@ -63,6 +64,12 @@
 #define SECONDARY_ENABLE_XSAV_RESTORE		0x00100000
 #define SECONDARY_EXEC_TSC_SCALING		0x02000000
 
+/*
+ * Definitions of Tertiary Processor-Based VM-Execution Controls.
+ * It's 64 bit unlike primary/secondary processor based vm-execution controls.
+ */
+#define TERTIARY_EXEC_GUEST_APIC_TIMER		0x0000000000000100ULL
+
 #define PIN_BASED_EXT_INTR_MASK			0x00000001
 #define PIN_BASED_NMI_EXITING			0x00000008
 #define PIN_BASED_VIRTUAL_NMIS			0x00000020
@@ -104,6 +111,7 @@
 enum vmcs_field {
 	VIRTUAL_PROCESSOR_ID		= 0x00000000,
 	POSTED_INTR_NV			= 0x00000002,
+	GUEST_APIC_TIMER_VECTOR         = 0x0000000a,
 	GUEST_ES_SELECTOR		= 0x00000800,
 	GUEST_CS_SELECTOR		= 0x00000802,
 	GUEST_SS_SELECTOR		= 0x00000804,
@@ -163,6 +171,8 @@ enum vmcs_field {
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
 	TSC_MULTIPLIER			= 0x00002032,
 	TSC_MULTIPLIER_HIGH		= 0x00002033,
+	TERTIARY_VM_EXEC_CONTROL        = 0x00002034,
+	TERTIARY_VM_EXEC_CONTROL_HIGH   = 0x00002035,
 	GUEST_PHYSICAL_ADDRESS		= 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH	= 0x00002401,
 	VMCS_LINK_POINTER		= 0x00002800,
diff --git a/tools/testing/selftests/kvm/x86/timer_latency.c b/tools/testing/selftests/kvm/x86/timer_latency.c
index a87a744330c8..9d96b7d18dd5 100644
--- a/tools/testing/selftests/kvm/x86/timer_latency.c
+++ b/tools/testing/selftests/kvm/x86/timer_latency.c
@@ -15,6 +15,10 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "apic.h"
+#include "vmx.h"
+
+#define L2_GUEST_STACK_SIZE 256
+static unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
 #define LOCAL_TIMER_VECTOR	0xec
 
@@ -30,6 +34,7 @@ struct options {
 	bool use_oneshot_timer;
 	bool use_x2apic;
 	bool use_poll;
+	bool nested;
 
 	uint64_t timer_inc_ns;
 	uint64_t allowed_timer_latency_ns;
@@ -304,6 +309,65 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+	union vmx_ctrl_msr ctls_msr, ctls2_msr;
+	uint64_t pin, ctls, ctls2, ctls3;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	prepare_vmcs(vmx_pages, guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* Check prerequisites */
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS, &ctls_msr.val));
+	GUEST_ASSERT(ctls_msr.clr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
+	GUEST_ASSERT(ctls_msr.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS);
+
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ctls2_msr.val));
+	GUEST_ASSERT(ctls2_msr.clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+
+	GUEST_ASSERT(!rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ctls3));
+	GUEST_ASSERT(ctls3 & TERTIARY_EXEC_GUEST_APIC_TIMER);
+
+	/*
+	 * SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY requires
+	 * PIN_BASED_EXT_INTR_MASK
+	 */
+	pin = vmreadz(PIN_BASED_VM_EXEC_CONTROL);
+	pin |= PIN_BASED_EXT_INTR_MASK;
+	GUEST_ASSERT(!vmwrite(PIN_BASED_VM_EXEC_CONTROL, pin));
+
+	ctls = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	ctls |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_TPR_SHADOW |
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
+	GUEST_ASSERT(!vmwrite(GUEST_APIC_TIMER_VECTOR, LOCAL_TIMER_VECTOR));
+
+	/* launch L2 */
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	GUEST_DONE();
+}
+
 static void __run_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
@@ -408,12 +472,40 @@ static void setup_timer_freq(struct kvm_vm *vm,
 		ns_to_tsc(data, options.allowed_timer_latency_ns);
 }
 
+static void clear_msr_bitmap(struct vmx_pages *vmx, int msr)
+{
+	clear_bit(msr, vmx->msr_hva);
+	clear_bit(msr, vmx->msr_hva + 2048);
+}
+
 static void setup(struct kvm_vm **vm__, struct kvm_vcpu **vcpu__)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	if (options.nested) {
+		vm_vaddr_t vmx_pages_gva = 0;
+		struct vmx_pages *vmx;
+
+		vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+
+		vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+		memset(vmx->msr_hva, 0xff, 4096);
+
+		/* Allow nested apic timer virtualization. */
+		clear_msr_bitmap(vmx, MSR_IA32_TSC_DEADLINE);
+
+		/*  Rely on x2apic virtualization. */
+		clear_msr_bitmap(vmx, MSR_IA32_APICBASE);
+		clear_msr_bitmap(vmx, APIC_BASE_MSR + (APIC_TDCR >> 4));
+		clear_msr_bitmap(vmx, APIC_BASE_MSR + (APIC_LVTT >> 4));
+		clear_msr_bitmap(vmx, APIC_BASE_MSR + (APIC_SPIV >> 4));
+		clear_msr_bitmap(vmx, APIC_BASE_MSR + (APIC_EOI >> 4));
+
+		vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	} else
+		vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
 	vm_install_exception_handler(vm, LOCAL_TIMER_VECTOR,
 				     guest_timer_interrupt_handler);
 	setup_timer_freq(vm, &shared_data);
@@ -505,6 +597,8 @@ static void help(const char *name)
 	printf("-P: print result stat\n");
 	printf("-x: use xAPIC mode\n");
 	printf("-X: use x2APIC mode (default)\n");
+	printf("-n: Only measure nested VM (L2)\n");
+	printf("-N: Don't measure nested VM (L2)\n");
 	puts("");
 
 	exit(EXIT_SUCCESS);
@@ -514,8 +608,10 @@ int main(int argc, char **argv)
 {
 	int opt;
 	unsigned int duration = TEST_DURATION_DEFAULT_IN_SEC;
+	bool nested_only = false;
+	bool no_nest = false;
 
-	while ((opt = getopt(argc, argv, "hld:p:a:otxXP")) != -1) {
+	while ((opt = getopt(argc, argv, "hld:p:a:otxXPnN")) != -1) {
 		switch (opt) {
 		case 'l':
 			options.use_poll = true;
@@ -553,6 +649,15 @@ int main(int argc, char **argv)
 			options.print_result = true;
 			break;
 
+		case 'n':
+			nested_only = true;
+			no_nest = false;
+			break;
+		case 'N':
+			nested_only = false;
+			no_nest = true;
+			break;
+
 		case 'h':
 		default:
 			help(argv[0]);
@@ -568,7 +673,28 @@ int main(int argc, char **argv)
 	if (options.use_x2apic)
 		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_X2APIC));
 
-	run_test(duration);
+	if (!nested_only) {
+		options.nested = false;
+		run_test(duration);
+	}
+
+	if (!no_nest) {
+		union vmx_ctrl_msr ctls;
+		uint64_t ctls3;
+
+		ctls.val = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+		TEST_REQUIRE(ctls.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS);
+
+		ctls3 = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS3);
+		TEST_REQUIRE(ctls3 & TERTIARY_EXEC_GUEST_APIC_TIMER);
+
+		/* L1 doesn't emulate HLT and memory-mapped APIC. */
+		options.use_poll = true;
+		options.use_oneshot_timer = false;
+
+		options.nested = true;
+		run_test(duration);
+	}
 
 	return 0;
 }
-- 
2.45.2


