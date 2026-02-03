Return-Path: <kvm+bounces-70061-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGiPKF0+gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70061-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:28:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6375DD93D
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:28:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3EAD23017755
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914613EFD09;
	Tue,  3 Feb 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YymRuExU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5550E3C1995;
	Tue,  3 Feb 2026 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142675; cv=none; b=ebZVKaITlQGTCRLPWpxLRpYrziqRPRkK8hl5Z2T+KElEj0l3TeFAjUdbrQXVRdTI+KS96qV23ioeURdaNklOlIsZvAu4/aJhCwzv8B6kFxgsHlxjZQEmrvE16QCF7B/aolyaVsy+CFNOLOryjQNOCMgxzsH5bM+96amQqWu7sFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142675; c=relaxed/simple;
	bh=zn2LCIv7iXyBsSK01o7/GmoZjwISSXR6b33kXBbRNZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+P9yS4YNhRaEayzSGvEpE6zFk9/ZrdMr4gYp+OtV2PDD5QhqFrnqoqVcHEJ2Jx0aqizORfUsbgZFhNXiK6RlzYD/vhX82HTo8XQHlRpZZUCVCHFP8cwFHK1c+mBqcuX9r7Gk5AVCQLoW6qxP69fg0CJINVijrrtXhpGrekrXY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YymRuExU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142674; x=1801678674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zn2LCIv7iXyBsSK01o7/GmoZjwISSXR6b33kXBbRNZ8=;
  b=YymRuExUcgZH8bIo9VXZP+NwR+a9Bn1EnoFkNkRionQtkWJf78FH0fFh
   NbEnmmTpw5UZzckl+Pn5rvTWqBKIh2+RaNO7b+VvgWYDZunInKFOBmbZ1
   M3fvHASEys2jNEFPaipaBItaRKZy8LfJ0J/KXKaBVybEsTaZPpMST6r9o
   Cpas2SEz6yCRAWiOa5HRX2sRzPq3ZK8SCyGXykvmJTFcIDIp7AQtZOtCa
   MItKrTrDnCMda4RSP8cxMyFx2553s5Dc4n2jn/JRprIDjEm64GJY2/v+I
   X6M5aNOYvj8Vqs4LpxGzIcY9wWfEkvWmIBJMavjzh9roXVhA+jmVF0tqz
   g==;
X-CSE-ConnectionGUID: X0OPC3S5SJau5Y9H4v5ZIA==
X-CSE-MsgGUID: SlICvL42QOOoDoJSUws34A==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745872"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745872"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:48 -0800
X-CSE-ConnectionGUID: 1P8CqZaCQFejvo0ij7GrGg==
X-CSE-MsgGUID: nZrZKHDqSEKk5EfMMg255w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605544"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:47 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 28/32] KVM: selftests: Add tests nested state of APIC timer virtualization
Date: Tue,  3 Feb 2026 10:17:11 -0800
Message-ID: <1cd17fc2aedaa11b2d104dc28ec7e0884267edd6.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70061-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B6375DD93D
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Test vmread/vmwrite for the following VMCS fields related to apic timer
virtualization in vmx_set_nested_state_test.
- TERTIARY_EXEC_GUEST_APIC_TIMER bit in TERTIARY_VM_EXEC_CONTROL
- VIRTUAL_TIMER_VECTOR_OFFSET
- GUEST_DEADLINE_OFFSET
- GUEST_DEADLINE_SHADOW_OFFSET

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h |   4 +
 .../kvm/x86/vmx_set_nested_state_test.c       | 237 ++++++++++++++++++
 2 files changed, 241 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 304892500089..a46346ce92cb 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -173,6 +173,8 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH		= 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL        = 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH   = 0x00002035,
+	GUEST_DEADLINE_VIR              = 0x0000204e,
+	GUEST_DEADLINE_VIR_HIGH         = 0x0000204f,
 	GUEST_PHYSICAL_ADDRESS		= 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH	= 0x00002401,
 	VMCS_LINK_POINTER		= 0x00002800,
@@ -195,6 +197,8 @@ enum vmcs_field {
 	GUEST_PDPTR3_HIGH		= 0x00002811,
 	GUEST_BNDCFGS			= 0x00002812,
 	GUEST_BNDCFGS_HIGH		= 0x00002813,
+	GUEST_DEADLINE_PHY              = 0x00002830,
+	GUEST_DEADLINE_PHY_HIGH         = 0x00002831,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
index cbf6a8ff626e..e4c0e6c49e55 100644
--- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
@@ -25,6 +25,8 @@
 #define VMCS12_REVISION 0x11e57ed0
 
 bool have_evmcs;
+bool have_procbased_tertiary_ctls;
+bool have_apic_timer_virtualization;
 
 void test_nested_state(struct kvm_vcpu *vcpu, struct kvm_nested_state *state)
 {
@@ -85,6 +87,233 @@ void set_default_vmx_state(struct kvm_nested_state *state, int size)
 	set_revision_id_for_vmcs12(state, VMCS12_REVISION);
 }
 
+/* Those values are taken from arch/x86/kvm/vmx/vmcs12.h */
+#define VMCS_LINK_POINTER_OFFSET		176
+#define TERTIARY_VM_EXEC_CONTROL_OFFSET		336
+#define GUEST_CR0_OFFSET			424
+#define GUEST_CR4_OFFSET			440
+#define HOST_CR0_OFFSET				584
+#define HOST_CR4_OFFSET				600
+#define PIN_BASED_VM_EXEC_CONTROL_OFFSET	744
+#define CPU_BASED_VM_EXEC_CONTROL_OFFSET	748
+#define VM_EXIT_CONTROLS_OFFSET			768
+#define VM_ENTRY_CONTROLS_OFFSET		780
+#define SECONDARY_VM_EXEC_CONTROL_OFFSET	804
+#define HOST_CS_SELECTOR_OFFSET			984
+#define HOST_SS_SELECTOR_OFFSET			986
+#define HOST_TR_SELECTOR_OFFSET			994
+#define VIRTUAL_TIMER_VECTOR_OFFSET		998
+#define GUEST_DEADLINE_OFFSET			1000
+#define GUEST_DEADLINE_SHADOW_OFFSET		1008
+
+#define KERNEL_CS       0x8
+#define KERNEL_DS       0x10
+#define KERNEL_TSS      0x18
+
+/* vcpu with vmxon=false is needed to be able to set VMX MSRs. */
+static void nested_vmxoff(struct kvm_vcpu *vcpu, struct kvm_nested_state *state,
+			int state_sz)
+{
+	set_default_vmx_state(state, state_sz);
+	state->flags = 0;
+	state->hdr.vmx.vmxon_pa = -1ull;
+	state->hdr.vmx.vmcs12_pa = -1ull;
+	test_nested_state(vcpu, state);
+}
+
+static void get_control(struct kvm_vcpu *vcpu, uint32_t msr_index,
+			uint32_t *fixed0, uint32_t *fixed1)
+{
+	uint64_t ctls;
+
+	ctls = vcpu_get_msr(vcpu, msr_index);
+
+	*fixed0 = ctls & 0xffffffff;
+	*fixed1 = ctls >> 32;
+}
+
+static uint32_t *init_control(struct kvm_vcpu *vcpu,
+			      struct kvm_nested_state *state,
+			      uint32_t msr_index, size_t offset)
+{
+	uint32_t fixed0, fixed1, *vmcs32;
+
+	get_control(vcpu, msr_index, &fixed0, &fixed1);
+	vmcs32 = (uint32_t *)&state->data.vmx->vmcs12[offset];
+
+	*vmcs32 = fixed0;
+	*vmcs32 &= fixed1;
+
+	return vmcs32;
+}
+
+void set_guest_vmx_state(struct kvm_vcpu *vcpu, struct kvm_nested_state *state,
+			 int size)
+{
+	unsigned long cr0, cr4;
+	uint32_t *vmcs32;
+	uint64_t *vmcs64;
+
+	set_default_vmx_state(state, size);
+	state->flags |= KVM_STATE_NESTED_GUEST_MODE;
+
+	/* control */
+	init_control(vcpu, state, MSR_IA32_VMX_TRUE_PINBASED_CTLS,
+		     PIN_BASED_VM_EXEC_CONTROL_OFFSET);
+
+	vmcs32 = init_control(vcpu, state, MSR_IA32_VMX_TRUE_PROCBASED_CTLS,
+			      CPU_BASED_VM_EXEC_CONTROL_OFFSET);
+	*vmcs32 |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	*vmcs32 &= ~CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+
+	init_control(vcpu, state, MSR_IA32_VMX_PROCBASED_CTLS2,
+		     SECONDARY_VM_EXEC_CONTROL_OFFSET);
+
+	vmcs32 = init_control(vcpu, state, MSR_IA32_VMX_TRUE_EXIT_CTLS,
+			      VM_EXIT_CONTROLS_OFFSET);
+	*vmcs32 |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
+
+	init_control(vcpu, state, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
+		     VM_ENTRY_CONTROLS_OFFSET);
+
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[VMCS_LINK_POINTER_OFFSET];
+	*vmcs64 = -1ull;
+
+	/* host state */
+	cr0 = vcpu_get_msr(vcpu, MSR_IA32_VMX_CR0_FIXED0);
+	cr0 &= vcpu_get_msr(vcpu, MSR_IA32_VMX_CR0_FIXED1);
+	cr0 |= X86_CR0_PG;
+	*(unsigned long*)&state->data.vmx->vmcs12[HOST_CR0_OFFSET] = cr0;
+
+	cr4 = vcpu_get_msr(vcpu, MSR_IA32_VMX_CR4_FIXED0);
+	cr4 &= vcpu_get_msr(vcpu, MSR_IA32_VMX_CR4_FIXED1);
+	cr4 |=X86_CR4_PAE | X86_CR4_VMXE;
+	*(unsigned long *)&state->data.vmx->vmcs12[HOST_CR4_OFFSET] = cr4;
+
+	*(unsigned long *)&state->data.vmx->vmcs12[HOST_CS_SELECTOR_OFFSET] = KERNEL_CS;
+	*(unsigned long *)&state->data.vmx->vmcs12[HOST_TR_SELECTOR_OFFSET] = KERNEL_TSS;
+	*(unsigned long *)&state->data.vmx->vmcs12[HOST_SS_SELECTOR_OFFSET] = KERNEL_DS;
+
+	/* guest state */
+	cr0 = vcpu_get_msr(vcpu, MSR_IA32_VMX_CR0_FIXED0);
+	cr0 &= vcpu_get_msr(vcpu, MSR_IA32_VMX_CR0_FIXED1);
+	*(unsigned long*)&state->data.vmx->vmcs12[GUEST_CR0_OFFSET] = cr0;
+
+	cr4 = vcpu_get_msr(vcpu, MSR_IA32_VMX_CR4_FIXED0);
+	cr4 &= vcpu_get_msr(vcpu, MSR_IA32_VMX_CR4_FIXED1);
+	*(unsigned long *)&state->data.vmx->vmcs12[GUEST_CR4_OFFSET] = cr4;
+
+}
+
+static void test_tertiary_ctls(struct kvm_vcpu *vcpu,
+			       struct kvm_nested_state *state,
+			       int state_sz)
+{
+	union vmx_ctrl_msr msr;
+	uint16_t *vmcs16;
+	uint32_t *vmcs32;
+	uint64_t *vmcs64;
+	uint64_t ctls;
+
+	nested_vmxoff(vcpu, state, state_sz);
+
+	msr.val = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	msr.clr |= CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	msr.clr |= CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS, msr.val);
+
+	ctls = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3);
+	ctls |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+	vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls);
+
+	set_default_vmx_state(state, state_sz);
+	test_nested_state(vcpu, state);
+
+	vmcs32 = (uint32_t *)&state->data.vmx->vmcs12[PIN_BASED_VM_EXEC_CONTROL_OFFSET];
+	*vmcs32 |= PIN_BASED_EXT_INTR_MASK;
+
+	vmcs32 = (uint32_t *)&state->data.vmx->vmcs12[CPU_BASED_VM_EXEC_CONTROL_OFFSET];
+	*vmcs32 |= CPU_BASED_TPR_SHADOW | CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+
+	vmcs32 = (uint32_t *)&state->data.vmx->vmcs12[SECONDARY_VM_EXEC_CONTROL_OFFSET];
+	*vmcs32 |= SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[TERTIARY_VM_EXEC_CONTROL_OFFSET];
+	*vmcs64 |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+
+	vmcs16 = (uint16_t *)&state->data.vmx->vmcs12[VIRTUAL_TIMER_VECTOR_OFFSET];
+	*vmcs16 = 128;
+
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[GUEST_DEADLINE_OFFSET];
+	/* random non-zero value */
+	*vmcs64 = 0xffff;
+
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[GUEST_DEADLINE_SHADOW_OFFSET];
+	*vmcs64 = 0xffff;
+
+	test_nested_state(vcpu, state);
+}
+
+static void test_tertiary_ctls_disabled(struct kvm_vcpu *vcpu,
+					struct kvm_nested_state *state,
+					int state_sz)
+{
+	union vmx_ctrl_msr msr;
+	uint16_t *vmcs16;
+	uint32_t *vmcs32;
+	uint64_t *vmcs64;
+
+	nested_vmxoff(vcpu, state, state_sz);
+
+	msr.val = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	if (msr.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
+		msr.val = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+		msr.clr &= ~CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS, msr.val);
+		vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, 0);
+	}
+
+	set_guest_vmx_state(vcpu, state, state_sz);
+	test_nested_state(vcpu, state);
+
+	set_guest_vmx_state(vcpu, state, state_sz);
+	vmcs32 = (uint32_t *)&state->data.vmx->vmcs12[CPU_BASED_VM_EXEC_CONTROL_OFFSET];
+	*vmcs32 |= CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	test_nested_state_expect_einval(vcpu, state);
+
+	set_guest_vmx_state(vcpu, state, state_sz);
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[TERTIARY_VM_EXEC_CONTROL_OFFSET];
+	*vmcs64 |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+	test_nested_state_expect_einval(vcpu, state);
+
+	set_guest_vmx_state(vcpu, state, state_sz);
+	vmcs16 = (uint16_t *)&state->data.vmx->vmcs12[VIRTUAL_TIMER_VECTOR_OFFSET];
+	*vmcs16 = 128;
+	test_nested_state_expect_einval(vcpu, state);
+
+	set_guest_vmx_state(vcpu, state, state_sz);
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[GUEST_DEADLINE_OFFSET];
+	*vmcs64 = 0xffff;
+	test_nested_state_expect_einval(vcpu, state);
+
+	set_guest_vmx_state(vcpu, state, state_sz);
+	vmcs64 = (uint64_t *)&state->data.vmx->vmcs12[GUEST_DEADLINE_SHADOW_OFFSET];
+	*vmcs64 = 0xffff;
+	test_nested_state_expect_einval(vcpu, state);
+}
+
+static void test_vmx_tertiary_ctls(struct kvm_vcpu *vcpu,
+				   struct kvm_nested_state *state,
+				   int state_sz)
+{
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_VMX);
+
+	if (have_procbased_tertiary_ctls)
+		test_tertiary_ctls(vcpu, state, state_sz);
+
+	test_tertiary_ctls_disabled(vcpu, state, state_sz);
+}
+
 void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 {
 	/* Add a page for VMCS12. */
@@ -244,6 +473,8 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
 	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull, "vmcs_pa must be -1ull.");
 
+	test_vmx_tertiary_ctls(vcpu, state, state_sz);
+
 	free(state);
 }
 
@@ -254,6 +485,12 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 
 	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
+	have_procbased_tertiary_ctls =
+		(kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32) &
+		CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	have_apic_timer_virtualization = have_procbased_tertiary_ctls &&
+		(kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS3) &
+		 TERTIARY_EXEC_GUEST_APIC_TIMER);
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 
-- 
2.45.2


