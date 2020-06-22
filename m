Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102782043E4
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbgFVWoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:44:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:27423 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbgFVWnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:43:05 -0400
IronPort-SDR: PWRYlzgxCsEwLRWO//V+LDjLP7t9Dxs6lQC6IvDcCrBWxOxJVLPFWx3woQYNoAonJ7wf1cK2wK
 f7r1nU8RbVaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303565"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:52 -0700
IronPort-SDR: bqeRcXtP29SFcPkMsg282ep03hiD5bkpfhOukYtljcMJNaKzaRW7bOnfHuL3o5xvUhbGYHcMdA
 owVlwXju1GcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634911"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] KVM: VMX: Rename the "shared_msr_entry" struct to "vmx_uret_msr"
Date:   Mon, 22 Jun 2020 15:42:38 -0700
Message-Id: <20200622224249.29562-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename struct "shared_msr_entry" to "vmx_uret_msr" to align with x86's
rename of "shared_msrs" to "user_return_msrs", and to call out that the
struct is specific to VMX, i.e. not part of the generic "shared_msrs"
framework.  Abbreviate "user_return" as "uret" to keep line lengths
marginally sane and code more or less readable.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 58 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h    | 10 +++----
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index afc8e7e9ef24..52de3e03fcdc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4209,7 +4209,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 
 static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
 {
-	struct shared_msr_entry *efer_msr;
+	struct vmx_uret_msr *efer_msr;
 	unsigned int i;
 
 	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_EFER)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba9af25b34e4..9cd40a7e9b47 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -630,28 +630,28 @@ static inline int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 	int i;
 
 	for (i = 0; i < vmx->nmsrs; ++i)
-		if (vmx_msr_index[vmx->guest_msrs[i].index] == msr)
+		if (vmx_msr_index[vmx->guest_uret_msrs[i].index] == msr)
 			return i;
 	return -1;
 }
 
-struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
+struct vmx_uret_msr *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
 	i = __find_msr_index(vmx, msr);
 	if (i >= 0)
-		return &vmx->guest_msrs[i];
+		return &vmx->guest_uret_msrs[i];
 	return NULL;
 }
 
-static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr, u64 data)
+static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct vmx_uret_msr *msr, u64 data)
 {
 	int ret = 0;
 
 	u64 old_msr_data = msr->data;
 	msr->data = data;
-	if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
+	if (msr - vmx->guest_uret_msrs < vmx->save_nmsrs) {
 		preempt_disable();
 		ret = kvm_set_user_return_msr(msr->index, msr->data, msr->mask);
 		preempt_enable();
@@ -996,8 +996,8 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 		guest_efer &= ~ignore_bits;
 		guest_efer |= host_efer & ignore_bits;
 
-		vmx->guest_msrs[efer_offset].data = guest_efer;
-		vmx->guest_msrs[efer_offset].mask = ~ignore_bits;
+		vmx->guest_uret_msrs[efer_offset].data = guest_efer;
+		vmx->guest_uret_msrs[efer_offset].mask = ~ignore_bits;
 
 		return true;
 	}
@@ -1145,9 +1145,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!vmx->guest_msrs_ready) {
 		vmx->guest_msrs_ready = true;
 		for (i = 0; i < vmx->save_nmsrs; ++i)
-			kvm_set_user_return_msr(vmx->guest_msrs[i].index,
-						vmx->guest_msrs[i].data,
-						vmx->guest_msrs[i].mask);
+			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].index,
+						vmx->guest_uret_msrs[i].data,
+						vmx->guest_uret_msrs[i].mask);
 
 	}
 
@@ -1714,11 +1714,11 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
  */
 static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 {
-	struct shared_msr_entry tmp;
+	struct vmx_uret_msr tmp;
 
-	tmp = vmx->guest_msrs[to];
-	vmx->guest_msrs[to] = vmx->guest_msrs[from];
-	vmx->guest_msrs[from] = tmp;
+	tmp = vmx->guest_uret_msrs[to];
+	vmx->guest_uret_msrs[to] = vmx->guest_uret_msrs[from];
+	vmx->guest_uret_msrs[from] = tmp;
 }
 
 /*
@@ -1829,7 +1829,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct shared_msr_entry *msr;
+	struct vmx_uret_msr *msr;
 	u32 index;
 
 	switch (msr_info->index) {
@@ -1850,7 +1850,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !(vcpu->arch.arch_capabilities & ARCH_CAP_TSX_CTRL_MSR))
 			return 1;
-		goto find_shared_msr;
+		goto find_uret_msr;
 	case MSR_IA32_UMWAIT_CONTROL:
 		if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
 			return 1;
@@ -1957,9 +1957,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
-		goto find_shared_msr;
+		goto find_uret_msr;
 	default:
-	find_shared_msr:
+	find_uret_msr:
 		msr = find_msr_entry(vmx, msr_info->index);
 		if (msr) {
 			msr_info->data = msr->data;
@@ -1989,7 +1989,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct shared_msr_entry *msr;
+	struct vmx_uret_msr *msr;
 	int ret = 0;
 	u32 msr_index = msr_info->index;
 	u64 data = msr_info->data;
@@ -2093,7 +2093,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
 			return 1;
-		goto find_shared_msr;
+		goto find_uret_msr;
 	case MSR_IA32_PRED_CMD:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -2230,10 +2230,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		/* Check reserved bit, higher 32 bits should be zero */
 		if ((data >> 32) != 0)
 			return 1;
-		goto find_shared_msr;
+		goto find_uret_msr;
 
 	default:
-	find_shared_msr:
+	find_uret_msr:
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr)
 			ret = vmx_set_guest_msr(vmx, msr, data);
@@ -2866,7 +2866,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct shared_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
+	struct vmx_uret_msr *msr = find_msr_entry(vmx, MSR_EFER);
 
 	if (!msr)
 		return;
@@ -6891,7 +6891,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != MAX_NR_SHARED_MSRS);
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) != MAX_NR_USER_RETURN_MSRS);
 
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
@@ -6903,8 +6903,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;
 
-		vmx->guest_msrs[j].index = i;
-		vmx->guest_msrs[j].data = 0;
+		vmx->guest_uret_msrs[j].index = i;
+		vmx->guest_uret_msrs[j].data = 0;
 		switch (index) {
 		case MSR_IA32_TSX_CTRL:
 			/*
@@ -6912,10 +6912,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			 * let's avoid changing CPUID bits under the host
 			 * kernel's feet.
 			 */
-			vmx->guest_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 			break;
 		default:
-			vmx->guest_msrs[j].mask = -1ull;
+			vmx->guest_uret_msrs[j].mask = -1ull;
 			break;
 		}
 		++vmx->nmsrs;
@@ -7282,7 +7282,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 		update_intel_pt_cfg(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
-		struct shared_msr_entry *msr;
+		struct vmx_uret_msr *msr;
 		msr = find_msr_entry(vmx, MSR_IA32_TSX_CTRL);
 		if (msr) {
 			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 12a845209088..256e3e4776f8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -21,9 +21,9 @@ extern const u32 vmx_msr_index[];
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
 #ifdef CONFIG_X86_64
-#define MAX_NR_SHARED_MSRS	7
+#define MAX_NR_USER_RETURN_MSRS	7
 #else
-#define MAX_NR_SHARED_MSRS	4
+#define MAX_NR_USER_RETURN_MSRS	4
 #endif
 
 #define MAX_NR_LOADSTORE_MSRS	8
@@ -33,7 +33,7 @@ struct vmx_msrs {
 	struct vmx_msr_entry	val[MAX_NR_LOADSTORE_MSRS];
 };
 
-struct shared_msr_entry {
+struct vmx_uret_msr {
 	unsigned index;
 	u64 data;
 	u64 mask;
@@ -217,7 +217,7 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
-	struct shared_msr_entry guest_msrs[MAX_NR_SHARED_MSRS];
+	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
 	int                   nmsrs;
 	int                   save_nmsrs;
 	bool                  guest_msrs_ready;
@@ -351,7 +351,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
+struct vmx_uret_msr *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
-- 
2.26.0

