Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1301C22F4
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgEBEcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:55783 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726058AbgEBEci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:38 -0400
IronPort-SDR: gc6Godd/p1nzJby0DmhrQQPkI6AlRi2eyZLb1IRDhThfCJFP7sKKHR/c/zFG4B6sD/wtPcrMVx
 Ufj+NaQC8i4w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: s3SItXf8FI90I6c37wagDESUOHL5GVAE2rxu3biDT6VwsjSDLuVtjNGRVeC7Ba+HaUHZii854K
 OuhDlfk5tXug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516114"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 01 May 2020 21:32:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] KVM: x86: Save L1 TSC offset in 'struct kvm_vcpu_arch'
Date:   Fri,  1 May 2020 21:32:25 -0700
Message-Id: <20200502043234.12481-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save L1's TSC offset in 'struct kvm_vcpu_arch' and drop the kvm_x86_ops
hook read_l1_tsc_offset().  This avoids a retpoline (when configured)
when reading L1's effective TSC, which is done at least once on every
VM-Exit.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 11 -----------
 arch/x86/kvm/vmx/vmx.c          | 12 ------------
 arch/x86/kvm/x86.c              |  9 ++++-----
 4 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd68d1d0627..d71d1f38b7a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -707,6 +707,7 @@ struct kvm_vcpu_arch {
 		struct gfn_to_pfn_cache cache;
 	} st;
 
+	u64 l1_tsc_offset;
 	u64 tsc_offset;
 	u64 last_guest_tsc;
 	u64 last_host_tsc;
@@ -1166,7 +1167,6 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
-	u64 (*read_l1_tsc_offset)(struct kvm_vcpu *vcpu);
 	/* Returns actual tsc_offset set in active VMCS */
 	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8fc65bfa3e..f40a43a288b9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -954,16 +954,6 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
 	seg->base = 0;
 }
 
-static u64 svm_read_l1_tsc_offset(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (is_guest_mode(vcpu))
-		return svm->nested.hsave->control.tsc_offset;
-
-	return vcpu->arch.tsc_offset;
-}
-
 static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4068,7 +4058,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
-	.read_l1_tsc_offset = svm_read_l1_tsc_offset,
 	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
 
 	.load_mmu_pgd = svm_load_mmu_pgd,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d3d57b7a67bd..de18cd386bb1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1723,17 +1723,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		vmx_update_msr_bitmap(&vmx->vcpu);
 }
 
-static u64 vmx_read_l1_tsc_offset(struct kvm_vcpu *vcpu)
-{
-	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-
-	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
-		return vcpu->arch.tsc_offset - vmcs12->tsc_offset;
-
-	return vcpu->arch.tsc_offset;
-}
-
 static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -7865,7 +7854,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.read_l1_tsc_offset = vmx_read_l1_tsc_offset,
 	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
 
 	.load_mmu_pgd = vmx_load_mmu_pgd,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 856b6fc2c2ba..8ec356ac1e6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1918,7 +1918,7 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 
 static void update_ia32_tsc_adjust_msr(struct kvm_vcpu *vcpu, s64 offset)
 {
-	u64 curr_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
+	u64 curr_offset = vcpu->arch.l1_tsc_offset;
 	vcpu->arch.ia32_tsc_adjust_msr += offset - curr_offset;
 }
 
@@ -1960,14 +1960,13 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 {
-	u64 tsc_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
-
-	return tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
+	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
+	vcpu->arch.l1_tsc_offset = offset;
 	vcpu->arch.tsc_offset = kvm_x86_ops.write_l1_tsc_offset(vcpu, offset);
 }
 
@@ -2092,7 +2091,7 @@ EXPORT_SYMBOL_GPL(kvm_write_tsc);
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 					   s64 adjustment)
 {
-	u64 tsc_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
+	u64 tsc_offset = vcpu->arch.l1_tsc_offset;
 	kvm_vcpu_write_tsc_offset(vcpu, tsc_offset + adjustment);
 }
 
-- 
2.26.0

