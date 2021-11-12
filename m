Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1076544EA82
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhKLPlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:41:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:34487 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235485AbhKLPky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:40:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093182"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093182"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:37:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182094"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:37:53 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 05/11] KVM: x86: Disallow tsc manipulation for TDX
Date:   Fri, 12 Nov 2021 23:37:27 +0800
Message-Id: <20211112153733.2767561-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The TSC for TDX guest is fixed at TD creation time.

Introduce kvm_tsc_immutable() to tell if TSC is immutable or not.
If immutable, short circuit all paths that lead to one of the myriad TSC
adjustment flows.

Suggested-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 34 ++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.h |  5 +++++
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b21c5169f32..34dd93b29932 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2247,7 +2247,9 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 	u64 ratio;
 
 	/* Guest TSC same frequency as host TSC? */
-	if (!scale) {
+	if (!scale || kvm_tsc_immutable(vcpu)) {
+		if (scale)
+			pr_warn_ratelimited("Guest TSC immutable, scaling not supported\n");
 		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
 		return 0;
 	}
@@ -2534,6 +2536,9 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool matched = false;
 	bool synchronizing = false;
 
+	if (WARN_ON_ONCE(kvm_tsc_immutable(vcpu)))
+		return;
+
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = kvm_compute_l1_tsc_offset(vcpu, data);
 	ns = get_kvmclock_base_ns();
@@ -2960,6 +2965,10 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	u8 pvclock_flags;
 	bool use_master_clock;
 
+	/* Unable to update guest time if the TSC is immutable. */
+	if (kvm_tsc_immutable(v))
+		return 0;
+
 	kernel_ns = 0;
 	host_tsc = 0;
 
@@ -4332,7 +4341,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 
-		if (kvm_check_tsc_unstable()) {
+		if (kvm_check_tsc_unstable() && !kvm_tsc_immutable(vcpu)) {
 			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
@@ -4346,7 +4355,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * On a host with synchronized TSC, there is no need to update
 		 * kvmclock on vcpu->cpu migration
 		 */
-		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
+		if ((!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1) &&
+		    !kvm_tsc_immutable(vcpu))
 			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 		if (vcpu->cpu != cpu)
 			kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
@@ -5274,10 +5284,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_TSC_KHZ: {
-		u32 user_tsc_khz;
+		u32 user_tsc_khz = (u32)arg;
 
 		r = -EINVAL;
-		user_tsc_khz = (u32)arg;
+		if (kvm_tsc_immutable(vcpu))
+			goto out;
 
 		if (kvm_has_tsc_control &&
 		    user_tsc_khz >= kvm_max_guest_tsc_khz)
@@ -10857,9 +10868,12 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
-	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
-	vcpu_put(vcpu);
+
+	if (!kvm_tsc_immutable(vcpu)) {
+		vcpu_load(vcpu);
+		kvm_synchronize_tsc(vcpu, 0);
+		vcpu_put(vcpu);
+	}
 
 	/* poll control enabled by default */
 	vcpu->arch.msr_kvm_poll_control = 1;
@@ -11119,6 +11133,10 @@ int kvm_arch_hardware_enable(void)
 	if (backwards_tsc) {
 		u64 delta_cyc = max_tsc - local_tsc;
 		list_for_each_entry(kvm, &vm_list, vm_list) {
+			if (kvm_tsc_immutable(vcpu)) {
+				pr_warn_ratelimited("Backwards TSC observed and guest with immutable TSC active\n");
+				continue;
+			}
 			kvm->arch.backwards_tsc_observed = true;
 			kvm_for_each_vcpu(i, vcpu, kvm) {
 				vcpu->arch.tsc_offset_adjustment += delta_cyc;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 69c60297bef2..0d8435b32bf5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -446,6 +446,11 @@ static __always_inline bool kvm_guest_mce_disallowed(struct kvm *kvm)
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
+static __always_inline bool kvm_tsc_immutable(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.27.0

