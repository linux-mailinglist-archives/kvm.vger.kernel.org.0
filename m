Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5754722032B
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgGOEGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:03 -0400
Received: from mga17.intel.com ([192.55.52.151]:16670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgGOEGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:02 -0400
IronPort-SDR: WEP/xs9huEb771/CYLVstow7nnrwcI0V19U3EW98Z/MNIfRIrqXwWsY0NWyReTYHSOA9BQWvcW
 9SDzAToH5y2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167482"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167482"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:02 -0700
IronPort-SDR: dwTjIZzEyrANaCF4WHn26lOxGI30xrCnmKWGWEUKv6bulHMuQf6Yls6GZl/jMWMBE9tvOecMbO
 1UT/2EgXjPag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587016"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 3/7] KVM: nVMX: Explicitly check for valid guest state for !unrestricted guest
Date:   Tue, 14 Jul 2020 21:05:53 -0700
Message-Id: <20200715040557.5889-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call guest_state_valid() directly instead of querying emulation_required
when checking if L1 is attempting VM-Enter with invalid guest state.
If emulate_invalid_guest_state is false, KVM will fixup segment regs to
avoid emulation and will never set emulation_required, i.e. KVM will
incorrectly miss the associated consistency checks because the nested
path stuffs segments directly into vmcs02.

Opportunsitically add Consistency Check tracing to make future debug
suck a little less.

Fixes: 2bb8cafea80bf ("KVM: vVMX: signal failure for nested VMEntry if emulation_required")
Fixes: 3184a995f782c ("KVM: nVMX: fix vmentry failure code when L2 state would require emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  8 ++------
 arch/x86/kvm/vmx/vmx.h    | 10 ++++++++++
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8cbf7bd3a7aa3..7d4457aaab2ef 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2572,7 +2572,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * which means L1 attempted VMEntry to L2 with invalid state.
 	 * Fail the VMEntry.
 	 */
-	if (vmx->emulation_required) {
+	if (CC(!vmx_guest_state_valid(vcpu))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1bb59ae5016dc..92c5f7cbf2389 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -340,7 +340,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 };
 module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
-static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
 static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
 							  u32 msr, int type);
@@ -1414,7 +1413,7 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 
 static bool emulation_required(struct kvm_vcpu *vcpu)
 {
-	return emulate_invalid_guest_state && !guest_state_valid(vcpu);
+	return emulate_invalid_guest_state && !vmx_guest_state_valid(vcpu);
 }
 
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -3501,11 +3500,8 @@ static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
  * not.
  * We assume that registers are always usable
  */
-static bool guest_state_valid(struct kvm_vcpu *vcpu)
+bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 {
-	if (enable_unrestricted_guest)
-		return true;
-
 	/* real mode guest state checks */
 	if (!is_protmode(vcpu) || (vmx_get_rflags(vcpu) & X86_EFLAGS_VM)) {
 		if (!rmode_segment_valid(vcpu, VCPU_SREG_CS))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0d06951e607ce..467716e61292d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -342,6 +342,16 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+
+bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu);
+static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
+{
+	if (enable_unrestricted_guest)
+		return true;
+
+	return __vmx_guest_state_valid(vcpu);
+}
+
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
 void update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
-- 
2.26.0

