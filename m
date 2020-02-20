Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628021668BF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgBTUo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgBTUoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:44:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:44:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237107"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:43:59 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
Date:   Thu, 20 Feb 2020 12:43:52 -0800
Message-Id: <20200220204356.8837-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a dedicated hook to handle flushing TLB entries on behalf of the
guest, i.e. for a paravirtualized TLB flush, and use it directly instead
of bouncing through kvm_vcpu_flush_tlb().  Change the effective VMX
implementation to never do INVEPT, i.e. to always flush via INVVPID.
The INVEPT performed by __vmx_flush_tlb() when @invalidate_gpa=false and
enable_vpid=0 is unnecessary, as it will only flush GPA->HPA mappings;
GVA->GPA and GVA->HPA translations are flushed by VM-Enter when VPID is
disabled, and changes in the guest pages tables only affect GVA->*PA
mappings.

When EPT and VPID are enabled, doing INVVPID is not required (by Intel's
architecture) to invalidate GPA mappings, i.e. TLB entries that cache
GPA->HPA translations can live across INVVPID as GPA->HPA mappings are
associated with an EPTP, not a VPID.  The intent of @invalidate_gpa is
to inform vmx_flush_tlb() that it needs to "invalidate gpa mappings",
i.e. do INVEPT and not simply INVVPID.  Other than nested VPID handling,
which now calls vpid_sync_context() directly, the only scenario where
KVM can safely do INVVPID instead of INVEPT (when EPT is enabled) is if
KVM is flushing TLB entries from the guest's perspective, i.e. is
invalidating GLA->GPA mappings.

Adding a dedicated ->tlb_flush_guest() paves the way toward removing
@invalidate_gpa, which is a potentially dangerous control flag as its
meaning is not exactly crystal clear, even for those who are familiar
with the subtleties of what mappings Intel CPUs are/aren't allowed to
keep across various invalidation scenarios.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          | 13 +++++++++++++
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..86aed64b9a88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1108,6 +1108,12 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
 
+	/*
+	 * Flush any TLB entries created by the guest.  Like tlb_flush_gva(),
+	 * does not need to flush GPA->HPA mappings.
+	 */
+	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
+
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a3e32d61d60c..e549811f51c6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5608,6 +5608,11 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 	invlpga(gva, svm->vmcb->control.asid);
 }
 
+static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	svm_flush_tlb(vcpu, true);
+}
+
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 }
@@ -7429,6 +7434,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.tlb_flush = svm_flush_tlb,
 	.tlb_flush_gva = svm_flush_tlb_gva,
+	.tlb_flush_guest = svm_flush_tlb_guest,
 
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 349a6e054e0e..5372a93e1727 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2835,6 +2835,18 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 	 */
 }
 
+static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * vpid_sync_context() is a nop if vmx->vpid==0, e.g. if enable_vpid==0
+	 * or a vpid couldn't be allocated for this vCPU.  VM-Enter and VM-Exit
+	 * are required to flush GVA->{G,H}PA mappings from the TLB if vpid is
+	 * disabled (VM-Enter with vpid enabled and vpid==0 is disallowed),
+	 * i.e. no explicit INVVPID is necessary.
+	 */
+	vpid_sync_context(to_vmx(vcpu)->vpid);
+}
+
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 {
 	ulong cr0_guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
@@ -7779,6 +7791,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.tlb_flush = vmx_flush_tlb,
 	.tlb_flush_gva = vmx_flush_tlb_gva,
+	.tlb_flush_guest = vmx_flush_tlb_guest,
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..72f7ca4baa6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2675,7 +2675,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
 		st->preempted & KVM_VCPU_FLUSH_TLB);
 	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
-		kvm_vcpu_flush_tlb(vcpu, false);
+		kvm_x86_ops->tlb_flush_guest(vcpu);
 
 	vcpu->arch.st.preempted = 0;
 
-- 
2.24.1

