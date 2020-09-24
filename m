Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8ED277838
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgIXSEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 14:04:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:45606 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgIXSEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 14:04:31 -0400
IronPort-SDR: EYQcTzeuJxdi0LyKEH6vU8EYlXbRcqmSNTIi8+6MR4ilgEfnQaI+K4f5AYP6Xac/70Nzb8GuYl
 Xi4lEGSGfO4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="161365971"
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="161365971"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 11:04:30 -0700
IronPort-SDR: FVWvApzr7I7krFoC4sTcxfib8ECY6LWic7dQfyRAgWsZsGuvkFQSuor72shP+nk5Ou7PhJmV3u
 MaZgTlXFREbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="487023894"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga005.jf.intel.com with ESMTP; 24 Sep 2020 11:04:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd()
Date:   Thu, 24 Sep 2020 11:04:29 -0700
Message-Id: <20200924180429.10016-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check that kvm_x86_ops.tlb_remote_flush() points at Hyper-V's
implementation for PV flushing instead of assuming that a non-NULL
implementation means running on Hyper-V.  Wrap the related logic in
ifdeffery as hv_remote_flush_tlb() is defined iff CONFIG_HYPERV!=n.

Short term, the explicit check makes it more obvious why a non-NULL
tlb_remote_flush() triggers EPTP shenanigans.  Long term, this will
allow TDX to define its own implementation of tlb_remote_flush() without
running afoul of Hyper-V.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 arch/x86/kvm/vmx/vmx.h | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f9a0c6d5dc5..a56fa9451b84 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3073,14 +3073,15 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
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
@@ -6956,7 +6957,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_vm_init(struct kvm *kvm)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+#endif
 
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d7ec66db5eb8..51107b7309bc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -316,8 +316,10 @@ struct kvm_vmx {
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
 
+#if IS_ENABLED(CONFIG_HYPERV)
 	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
+#endif
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-- 
2.28.0

