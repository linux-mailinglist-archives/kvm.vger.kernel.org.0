Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3DF18DA6C
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgCTV2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48422 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCTV2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:44 -0400
IronPort-SDR: WZ3M7p7Pw+L5IFaElIQ6M0/G/r+wQOzsJuUrlUQelK8StVsWEmgvM+UKQyRE/SfjKywTBl5mp4
 zAdrr1SCaBlA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:43 -0700
IronPort-SDR: kRg8672Th143DJPmBX2VmGiCrlwhtjjkTJigxEvDm1JPKQi0yDQ8opP6TPhCTWf6MhrFKkyet6
 Pu7xCLHfsJkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224393"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 01/37] KVM: VMX: Flush all EPTP/VPID contexts on remote TLB flush
Date:   Fri, 20 Mar 2020 14:27:57 -0700
Message-Id: <20200320212833.3507-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Flush all EPTP/VPID contexts if a TLB flush _may_ have been triggered by
a remote or deferred TLB flush, i.e. by KVM_REQ_TLB_FLUSH.  Remote TLB
flushes require all contexts to be invalidated, not just the active
contexts, e.g. all mappings in all contexts for a given HVA need to be
invalidated on a mmu_notifier invalidation.  Similarly, the instigator
of the deferred TLB flush may be expecting all contexts to be flushed,
e.g. vmx_vcpu_load_vmcs().

Without nested VMX, flushing only the current EPTP/VPID context isn't
problematic because KVM uses a constant VPID for each vCPU, and
mmu_alloc_direct_roots() all but guarantees KVM will use a single EPTP
for L1.  In the rare case where a different EPTP is created or reused,
KVM (currently) unconditionally flushes the new EPTP context prior to
entering the guest.

With nested VMX, KVM conditionally uses a different VPID for L2, and
unconditionally uses a different EPTP for L2.  Because KVM doesn't
_intentionally_ guarantee L2's EPTP/VPID context is flushed on nested
VM-Enter, it'd be possible for a malicious L1 to attack the host and/or
different VMs by exploiting the lack of flushing for L2.

  1) Launch nested guest from malicious L1.

  2) Nested VM-Enter to L2.

  3) Access target GPA 'g'.  CPU inserts TLB entry tagged with L2's ASID
     mapping 'g' to host PFN 'x'.

  2) Nested VM-Exit to L1.

  3) L1 triggers kernel same-page merging (ksm) by duplicating/zeroing
     the page for PFN 'x'.

  4) Host kernel merges PFN 'x' with PFN 'y', i.e. unmaps PFN 'x' and
     remaps the page to PFN 'y'.  mmu_notifier sends invalidate command,
     KVM flushes TLB only for L1's ASID.

  4) Host kernel reallocates PFN 'x' to some other task/guest.

  5) Nested VM-Enter to L2.  KVM does not invalidate L2's EPTP or VPID.

  6) L2 accesses GPA 'g' and gains read/write access to PFN 'x' via its
     stale TLB entry.

However, current KVM unconditionally flushes L1's EPTP/VPID context on
nested VM-Exit.  But, that behavior is mostly unintentional, KVM doesn't
go out of its way to flush EPTP/VPID on nested VM-Enter/VM-Exit, rather
a TLB flush is guaranteed to occur prior to re-entering L1 due to
__kvm_mmu_new_cr3() always being called with skip_tlb_flush=false.  On
nested VM-Enter, this happens via kvm_init_shadow_ept_mmu() (nested EPT
enabled) or in nested_vmx_load_cr3() (nested EPT disabled).  On nested
VM-Exit it occurs via nested_vmx_load_cr3().

This also fixes a bug where a deferred TLB flush in the context of L2,
with EPT disabled, would flush L1's VPID instead of L2's VPID, as
vmx_flush_tlb() flushes L1's VPID regardless of is_guest_mode().

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Junaid Shahid <junaids@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: John Haxby <john.haxby@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Fixes: efebf0aaec3d ("KVM: nVMX: Do not flush TLB on L1<->L2 transitions if L1 uses VPID and EPT")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index be93d597306c..d6d67b816ebe 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -518,7 +518,33 @@ static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
 
 static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 {
-	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, invalidate_gpa);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * Flush all EPTP/VPID contexts if the TLB flush _may_ have been
+	 * invoked via kvm_flush_remote_tlbs(), which always passes %true for
+	 * @invalidate_gpa.  Flushing remote TLBs requires all contexts to be
+	 * flushed, not just the active context.
+	 *
+	 * Note, this also ensures a deferred TLB flush with VPID enabled and
+	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
+	 * L2's VPIDs.
+	 */
+	if (invalidate_gpa) {
+		if (enable_ept) {
+			ept_sync_global();
+		} else if (enable_vpid) {
+			if (cpu_has_vmx_invvpid_global()) {
+				vpid_sync_vcpu_global();
+			} else {
+				WARN_ON_ONCE(!cpu_has_vmx_invvpid_single());
+				vpid_sync_vcpu_single(vmx->vpid);
+				vpid_sync_vcpu_single(vmx->nested.vpid02);
+			}
+		}
+	} else {
+		__vmx_flush_tlb(vcpu, vmx->vpid, false);
+	}
 }
 
 static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
-- 
2.24.1

