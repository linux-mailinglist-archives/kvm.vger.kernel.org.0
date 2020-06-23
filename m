Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27607204630
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgFWAvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:51:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:10120 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731750AbgFWAvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 20:51:38 -0400
IronPort-SDR: TwQ4rW+XOK1NTshp9+G8eOvNKtr7K6kZc9Jgu7nL6YJd29tV6PkLEhMe2ILDec54za4ctRdczw
 fiS5pBGfqjpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="141422602"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="141422602"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 17:51:37 -0700
IronPort-SDR: RXTycZaOvOOv96UEW80afRXTHI74G+J3g0EXw6R3mRJBzFpBV01mjP80zcCQbuOfjoMwPes/u+
 jAi8gMV7Q+sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="319007683"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 17:51:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>,
        Tao Xu <tao3.xu@intel.com>
Subject: [PATCH] KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
Date:   Mon, 22 Jun 2020 17:51:35 -0700
Message-Id: <20200623005135.10414-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove support for context switching between the guest's and host's
desired UMWAIT_CONTROL.  Propagating the guest's value to hardware isn't
required for correct functionality, e.g. KVM intercepts reads and writes
to the MSR, and the latency effects of the settings controlled by the
MSR are not architecturally visible.

As a general rule, KVM should not allow the guest to control power
management settings unless explicitly enabled by userspace, e.g. see
KVM_CAP_X86_DISABLE_EXITS.  E.g. Intel's SDM explicitly states that C0.2
can improve the performance of SMT siblings.  A devious guest could
disable C0.2 so as to improve the performance of their workloads at the
detriment to workloads running in the host or on other VMs.

Wholesale removal of UMWAIT_CONTROL context switching also fixes a race
condition where updates from the host may cause KVM to enter the guest
with the incorrect value.  Because updates are are propagated to all
CPUs via IPI (SMP function callback), the value in hardware may be
stale with respect to the cached value and KVM could enter the guest
with the wrong value in hardware.  As above, the guest can't observe the
bad value, but it's a weird and confusing wart in the implementation.

Removal also fixes the unnecessary usage of VMX's atomic load/store MSR
lists.  Using the lists is only necessary for MSRs that are required for
correct functionality immediately upon VM-Enter/VM-Exit, e.g. EFER on
old hardware, or for MSRs that need to-the-uop precision, e.g. perf
related MSRs.  For UMWAIT_CONTROL, the effects are only visible in the
kernel via TPAUSE/delay(), and KVM doesn't do any form of delay in
vcpu_vmx_run().  Using the atomic lists is undesirable as they are more
expensive than direct RDMSR/WRMSR.

Furthermore, even if giving the guest control of the MSR is legitimate,
e.g. in pass-through scenarios, it's not clear that the benefits would
outweigh the overhead.  E.g. saving and restoring an MSR across a VMX
roundtrip costs ~250 cycles, and if the guest diverged from the host
that cost would be paid on every run of the guest.  In other words, if
there is a legitimate use case then it should be enabled by a new
per-VM capability.

Note, KVM still needs to emulate MSR_IA32_UMWAIT_CONTROL so that it can
correctly expose other WAITPKG features to the guest, e.g. TPAUSE,
UMWAIT and UMONITOR.

Fixes: 6e3ba4abcea56 ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Cc: stable@vger.kernel.org
Cc: Jingqi Liu <jingqi.liu@intel.com>
Cc: Tao Xu <tao3.xu@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/mwait.h |  2 --
 arch/x86/kernel/cpu/umwait.c |  6 ------
 arch/x86/kvm/vmx/vmx.c       | 18 ------------------
 3 files changed, 26 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 73d997aa2966..e039a933aca3 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -25,8 +25,6 @@
 #define TPAUSE_C01_STATE		1
 #define TPAUSE_C02_STATE		0
 
-u32 get_umwait_control_msr(void);
-
 static inline void __monitor(const void *eax, unsigned long ecx,
 			     unsigned long edx)
 {
diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index 300e3fd5ade3..ec8064c0ae03 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -18,12 +18,6 @@
  */
 static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
 
-u32 get_umwait_control_msr(void)
-{
-	return umwait_control_cached;
-}
-EXPORT_SYMBOL_GPL(get_umwait_control_msr);
-
 /*
  * Cache the original IA32_UMWAIT_CONTROL MSR value which is configured by
  * hardware or BIOS before kernel boot.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08e26a9518c2..b2447c1ee362 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6606,23 +6606,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
-static void atomic_switch_umwait_control_msr(struct vcpu_vmx *vmx)
-{
-	u32 host_umwait_control;
-
-	if (!vmx_has_waitpkg(vmx))
-		return;
-
-	host_umwait_control = get_umwait_control_msr();
-
-	if (vmx->msr_ia32_umwait_control != host_umwait_control)
-		add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
-			vmx->msr_ia32_umwait_control,
-			host_umwait_control, false);
-	else
-		clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
-}
-
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6730,7 +6713,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (vcpu_to_pmu(vcpu)->version)
 		atomic_switch_perf_msrs(vmx);
-	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
-- 
2.26.0

