Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621863BA56B
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhGBWIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:50200 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhGBWH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472733"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472733"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:24 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814759"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:24 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [RFC PATCH v2 27/69] KVM: x86: Add flag to mark TSC as immutable (for TDX)
Date:   Fri,  2 Jul 2021 15:04:33 -0700
Message-Id: <dd88a183a55c1702b73a03a2af32e4bcf55dd01b.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The TSC for TDX1 guests is fixed at TD creation time.  Add tsc_immutable
to reflect that the TSC of the guest cannot be changed in any way, and
use it to short circuit all paths that lead to one of the myriad TSC
adjustment flows.

Suggested-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 35 +++++++++++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09e51c5e86b3..5d6143643cd1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1044,6 +1044,7 @@ struct kvm_arch {
 	int audit_point;
 	#endif
 
+	bool tsc_immutable;
 	bool backwards_tsc_observed;
 	bool boot_vcpu_runs_old_kvmclock;
 	u32 bsp_vcpu_id;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 681fc3be2b2b..cd9407982366 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2184,7 +2184,9 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 	u64 ratio;
 
 	/* Guest TSC same frequency as host TSC? */
-	if (!scale) {
+	if (!scale || vcpu->kvm->arch.tsc_immutable) {
+		if (scale)
+			pr_warn_ratelimited("Guest TSC immutable, scaling not supported\n");
 		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
 		return 0;
 	}
@@ -2360,6 +2362,9 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	bool already_matched;
 	bool synchronizing = false;
 
+	if (WARN_ON_ONCE(vcpu->kvm->arch.tsc_immutable))
+		return;
+
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = kvm_compute_tsc_offset(vcpu, data);
 	ns = get_kvmclock_base_ns();
@@ -2791,6 +2796,10 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	u8 pvclock_flags;
 	bool use_master_clock;
 
+	/* Unable to update guest time if the TSC is immutable. */
+	if (ka->tsc_immutable)
+		return 0;
+
 	kernel_ns = 0;
 	host_tsc = 0;
 
@@ -4142,7 +4151,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 
-		if (kvm_check_tsc_unstable()) {
+		if (kvm_check_tsc_unstable() &&
+		    !vcpu->kvm->arch.tsc_immutable) {
 			u64 offset = kvm_compute_tsc_offset(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);
@@ -4156,7 +4166,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * On a host with synchronized TSC, there is no need to update
 		 * kvmclock on vcpu->cpu migration
 		 */
-		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
+		if ((!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1) &&
+		    !vcpu->kvm->arch.tsc_immutable)
 			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 		if (vcpu->cpu != cpu)
 			kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
@@ -5126,10 +5137,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_TSC_KHZ: {
-		u32 user_tsc_khz;
+		u32 user_tsc_khz = (u32)arg;
 
 		r = -EINVAL;
-		user_tsc_khz = (u32)arg;
+		if (vcpu->kvm->arch.tsc_immutable)
+			goto out;
 
 		if (kvm_has_tsc_control &&
 		    user_tsc_khz >= kvm_max_guest_tsc_khz)
@@ -10499,9 +10511,12 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 	if (mutex_lock_killable(&vcpu->mutex))
 		return;
-	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
-	vcpu_put(vcpu);
+
+	if (!kvm->arch.tsc_immutable) {
+		vcpu_load(vcpu);
+		kvm_synchronize_tsc(vcpu, 0);
+		vcpu_put(vcpu);
+	}
 
 	/* poll control enabled by default */
 	vcpu->arch.msr_kvm_poll_control = 1;
@@ -10696,6 +10711,10 @@ int kvm_arch_hardware_enable(void)
 	if (backwards_tsc) {
 		u64 delta_cyc = max_tsc - local_tsc;
 		list_for_each_entry(kvm, &vm_list, vm_list) {
+			if (vcpu->kvm->arch.tsc_immutable) {
+				pr_warn_ratelimited("Backwards TSC observed and guest with immutable TSC active\n");
+				continue;
+			}
 			kvm->arch.backwards_tsc_observed = true;
 			kvm_for_each_vcpu(i, vcpu, kvm) {
 				vcpu->arch.tsc_offset_adjustment += delta_cyc;
-- 
2.25.1

