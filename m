Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7932F17DB9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfEHQIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:08:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:13961 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfEHQIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:08:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 09:08:24 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 09:08:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU"
Date:   Wed,  8 May 2019 09:08:19 -0700
Message-Id: <20190508160819.19603-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RDPMC-exiting control is dependent on the existence of the RDPMC
instruction itself, i.e. is not tied to the "Architectural Performance
Monitoring" feature.  For all intents and purposes, the control exists
on all CPUs with VMX support since RDPMC also exists on all VCPUs with
VMX supported.  Per Intel's SDM:

  The RDPMC instruction was introduced into the IA-32 Architecture in
  the Pentium Pro processor and the Pentium processor with MMX technology.
  The earlier Pentium processors have performance-monitoring counters, but
  they must be read with the RDMSR instruction.

Because RDPMC-exiting always exists, KVM requires the control and refuses
to load if it's not available.  As a result, hiding the PMU from a guest
breaks nested virtualization if the guest attemts to use KVM.

While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
check for RDPMC-exiting follows standard fault vs. VM-Exit prioritization
for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
checks, but before the counter referenced in ECX is checked for validity.

In other words, the original KVM behavior of injecting a #GP was correct,
and the KVM unit test needs to be adjusted accordingly, e.g. eat the #GP
when the unit test guest (L3 in this case) executes RDPMC without
RDPMC-exiting set in the unit test host (L2).

This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.

Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU")
Reported-by: David Hill <hilld@binarystorm.net>
Cc: Saar Amar <saaramar@microsoft.com>
Cc: Mihai Carabas <mihai.carabas@oracle.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60306f19105d..0db7ded18951 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6866,30 +6866,6 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool guest_cpuid_has_pmu(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *entry;
-	union cpuid10_eax eax;
-
-	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry)
-		return false;
-
-	eax.full = entry->eax;
-	return (eax.split.version_id > 0);
-}
-
-static void nested_vmx_procbased_ctls_update(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	bool pmu_enabled = guest_cpuid_has_pmu(vcpu);
-
-	if (pmu_enabled)
-		vmx->nested.msrs.procbased_ctls_high |= CPU_BASED_RDPMC_EXITING;
-	else
-		vmx->nested.msrs.procbased_ctls_high &= ~CPU_BASED_RDPMC_EXITING;
-}
-
 static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6978,7 +6954,6 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	if (nested_vmx_allowed(vcpu)) {
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 		nested_vmx_entry_exit_ctls_update(vcpu);
-		nested_vmx_procbased_ctls_update(vcpu);
 	}
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-- 
2.21.0

