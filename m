Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1982B4FCF
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388715AbgKPSdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:33:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:20622 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732868AbgKPS17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:59 -0500
IronPort-SDR: 4COCV9HSduLgv/IBaAnyEWhfOAZ7yClAqEa7OE+LJtrTabhfelbaFs8RQ7nzmSG9VJGG9qa7Yt
 B85LNRlkcm1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410010"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410010"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:58 -0800
IronPort-SDR: BJdytLI1SYiunGbzZUxtenGPWDbceua3LPbuOmDJb26Bg6JD2pypPnx5rsrgdG4FiId2q32aFt
 r/pVR/rrDz3w==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527859"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:58 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 13/67] KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd()
Date:   Mon, 16 Nov 2020 10:25:58 -0800
Message-Id: <96617e302a86ee0e4a263051b0cb7e51bf2ae4ed.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Explicitly check that kvm_x86_ops.tlb_remote_flush() points at Hyper-V's
implementation for PV flushing instead of assuming that a non-NULL
implemenation means running on Hyper-V.  Wrap the related logic in
ifdeffery as hv_remote_flush_tlb() is defined iff CONFIG_HYPERV!=n.

Short term, the explicit check makes it more obvious why a non-NULL
tlb_remote_flush() triggers EPTP shenanigans.  Long term, this will
allow TDX to define its own implementation of tlb_remote_flush() without
running afoul of Hyper-V.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 arch/x86/kvm/vmx/vmx.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c9ad3103c87..0703d82e7bad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3072,14 +3072,15 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		eptp = construct_eptp(vcpu, pgd, pgd_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		if (kvm_x86_ops.tlb_remote_flush) {
+#if IS_ENABLED(CONFIG_HYPERV)
+		if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
 			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 			to_vmx(vcpu)->ept_pointer = eptp;
 			to_kvm_vmx(kvm)->ept_pointers_match
 				= EPT_POINTERS_CHECK;
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
-
+#endif
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
 		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
@@ -6970,7 +6971,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_vm_init(struct kvm *kvm)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+#endif
 
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5c6510..e9cdb0fb7f56 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -301,8 +301,10 @@ struct kvm_vmx {
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
+#if IS_ENABLED(CONFIG_HYPERV)
 	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
+#endif
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-- 
2.17.1

