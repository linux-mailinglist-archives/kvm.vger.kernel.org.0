Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F203C18DA4F
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgCTVad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:30:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:20436 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727352AbgCTV2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:55 -0400
IronPort-SDR: +BpqFWyviprzZ06l/z8tgr7uz3waTPvzDGtcHHnm1heipNWlnt/8p1PXX05nJPUWXRD1Humz5g
 jdHsfhpIFbRQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:54 -0700
IronPort-SDR: I7Y0FONLyxvjWgE1d7kpt/ojXMQTH5/1zzFhPFEgd0jEE7Y0/w5SCOhRUovtNiDi1BSdJj7R7k
 ULfxMEkBH6hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224485"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:54 -0700
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
Subject: [PATCH v3 22/37] KVM: x86: Rename ->tlb_flush() to ->tlb_flush_all()
Date:   Fri, 20 Mar 2020 14:28:18 -0700
Message-Id: <20200320212833.3507-23-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename ->tlb_flush() to ->tlb_flush_all() in preparation for adding a
new hook to flush only the current ASID/context.

Opportunstically replace the comment in vmx_flush_tlb() that explains
why it flushes all EPTP/VPID contexts with a comment explaining why it
unconditionally uses INVEPT when EPT is enabled.  I.e. rely on the "all"
part of the name to clarify why it does global INVEPT/INVVPID.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 16 +++++++---------
 arch/x86/kvm/x86.c              |  6 +++---
 5 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a5dfab4642d6..0392a9db110d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1105,7 +1105,7 @@ struct kvm_x86_ops {
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
-	void (*tlb_flush)(struct kvm_vcpu *vcpu);
+	void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
 	int  (*tlb_remote_flush)(struct kvm *kvm);
 	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
 			struct kvm_tlb_range *range);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a87b8f9f3b1f..c357cc79f0f3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5177,7 +5177,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	kvm_mmu_load_pgd(vcpu);
-	kvm_x86_ops->tlb_flush(vcpu);
+	kvm_x86_ops->tlb_flush_all(vcpu);
 out:
 	return r;
 }
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8c3700b44eb4..10e5b8c4b515 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7405,7 +7405,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
 
-	.tlb_flush = svm_flush_tlb,
+	.tlb_flush_all = svm_flush_tlb,
 	.tlb_flush_gva = svm_flush_tlb_gva,
 	.tlb_flush_guest = svm_flush_tlb,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d0a8c7654d7..d6cf625b4011 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2849,18 +2849,16 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
-static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
+static void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	/*
-	 * Flush all EPTP/VPID contexts, as the TLB flush _may_ have been
-	 * invoked via kvm_flush_remote_tlbs().  Flushing remote TLBs requires
-	 * all contexts to be flushed, not just the active context.
-	 *
-	 * Note, this also ensures a deferred TLB flush with VPID enabled and
-	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
-	 * L2's VPIDs.
+	 * INVEPT must be issued when EPT is enabled, irrespective of VPID, as
+	 * the CPU is not required to invalidate guest-physical mappings on
+	 * VM-Entry, even if VPID is disabled.  Guest-physical mappings are
+	 * associated with the root EPT structure and not any particular VPID
+	 * (INVVPID also isn't required to invalidate guest-physical mappings).
 	 */
 	if (enable_ept) {
 		ept_sync_global();
@@ -7922,7 +7920,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
 
-	.tlb_flush = vmx_flush_tlb,
+	.tlb_flush_all = vmx_flush_tlb_all,
 	.tlb_flush_gva = vmx_flush_tlb_gva,
 	.tlb_flush_guest = vmx_flush_tlb_guest,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84cbd7ca1e18..333968e5ef3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2696,10 +2696,10 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.time = 0;
 }
 
-static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	kvm_x86_ops->tlb_flush(vcpu);
+	kvm_x86_ops->tlb_flush_all(vcpu);
 }
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
@@ -8223,7 +8223,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
 			kvm_mmu_load_pgd(vcpu);
 		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
-			kvm_vcpu_flush_tlb(vcpu);
+			kvm_vcpu_flush_tlb_all(vcpu);
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
 			r = 0;
-- 
2.24.1

