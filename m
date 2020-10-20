Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD52944D0
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438912AbgJTV4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:61050 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438835AbgJTV4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:18 -0400
IronPort-SDR: V1WR6X1X1zdkAn4kWqr2JWh37BioRmncKP7DPiiL12UFBoA9CJzhzGnAdvvUHCbzS2eSRqC/Em
 khD89sA1j5Lg==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576330"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576330"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:16 -0700
IronPort-SDR: uUuRNBFEJiQvcxbn/QTE5bqkPIENKJP8/ma0A8DgXar7PSddqn6gT/WigETR2s7Zz3nEW/1Icz
 WkfgdY27XJrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827749"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/10] KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
Date:   Tue, 20 Oct 2020 14:56:10 -0700
Message-Id: <20201020215613.8972-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6569bafacdc..55d6b699d8e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -560,6 +560,21 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
+static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+
+	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
+		spin_lock(&kvm_vmx->ept_pointer_lock);
+		to_vmx(vcpu)->ept_pointer = eptp;
+		if (eptp != kvm_vmx->hv_tlb_eptp)
+			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+		spin_unlock(&kvm_vmx->ept_pointer_lock);
+	}
+#endif
+}
+
 /*
  * Comment's format: document - errata name - stepping - processor name.
  * Refer from
@@ -3040,13 +3055,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		eptp = construct_eptp(vcpu, pgd, pgd_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		if (kvm_x86_ops.tlb_remote_flush) {
-			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-			to_vmx(vcpu)->ept_pointer = eptp;
-			if (eptp != to_kvm_vmx(kvm)->hv_tlb_eptp)
-				to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
-			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-		}
+		hv_load_mmu_eptp(vcpu, eptp);
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
-- 
2.28.0

