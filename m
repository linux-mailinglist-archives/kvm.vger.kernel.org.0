Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4B2043EC
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbgFVWod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:44:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:27425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731216AbgFVWm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:59 -0400
IronPort-SDR: W+GLFBTdaAA2iShFAzuJ92DCv7/3eNsTqS5Jbqd2TnJXakM2w9hsFh0kTnL+G+xHNC1aYHaNji
 obqZ3lcLQh1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303577"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303577"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:55 -0700
IronPort-SDR: iGJxrDCabt5mvEY4Hp8VgDNM8w1b8SmwoFpj7ihxRTWXi1ZjeTgTUI+ERMLK1TgHmAj3HZmQBe
 kJbtgT1j6zSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634936"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] KVM: VMX: Rename "find_msr_entry" to "vmx_find_uret_msr"
Date:   Mon, 22 Jun 2020 15:42:46 -0700
Message-Id: <20200622224249.29562-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "find_msr_entry" to scope it to VMX and to associate it with
guest_uret_msrs.  Drop the "entry" so that the function name pairs with
the existing __vmx_find_uret_msr(), which intentionally uses a double
underscore prefix instead of appending "index" or "slot" as those names
are already claimed by other pieces of the user return MSR stack.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 10 +++++-----
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 52de3e03fcdc..39a65df619e6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4223,7 +4223,7 @@ static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
 			return vmx->msr_autoload.guest.val[i].value;
 	}
 
-	efer_msr = find_msr_entry(vmx, MSR_EFER);
+	efer_msr = vmx_find_uret_msr(vmx, MSR_EFER);
 	if (efer_msr)
 		return efer_msr->data;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f3cd1de7b0ff..6662c1aab9b2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -635,7 +635,7 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	return -1;
 }
 
-struct vmx_uret_msr *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
+struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
@@ -1956,7 +1956,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		goto find_uret_msr;
 	default:
 	find_uret_msr:
-		msr = find_msr_entry(vmx, msr_info->index);
+		msr = vmx_find_uret_msr(vmx, msr_info->index);
 		if (msr) {
 			msr_info->data = msr->data;
 			break;
@@ -2230,7 +2230,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	default:
 	find_uret_msr:
-		msr = find_msr_entry(vmx, msr_index);
+		msr = vmx_find_uret_msr(vmx, msr_index);
 		if (msr)
 			ret = vmx_set_guest_msr(vmx, msr, data);
 		else
@@ -2862,7 +2862,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct vmx_uret_msr *msr = find_msr_entry(vmx, MSR_EFER);
+	struct vmx_uret_msr *msr = vmx_find_uret_msr(vmx, MSR_EFER);
 
 	if (!msr)
 		return;
@@ -7279,7 +7279,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
 		struct vmx_uret_msr *msr;
-		msr = find_msr_entry(vmx, MSR_IA32_TSX_CTRL);
+		msr = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (msr) {
 			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
 			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a0237ff6c4e0..338469fcd8cf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -351,7 +351,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
-struct vmx_uret_msr *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
+struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
-- 
2.26.0

