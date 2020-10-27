Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C745029CB45
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373890AbgJ0VZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:25:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:56183 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373801AbgJ0VXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:54 -0400
IronPort-SDR: YX31yzWvscM+zfv2stnSstE6ELyuXIZLCra4Oa4LILjEtI6rlnOY6xFFV8oWAbzf55WZ6qdkXG
 17Nlg5o9oSQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133711"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133711"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:51 -0700
IronPort-SDR: s0znNbddgf/mtuuNyzmf4ASexGiHxXWFgmyLO1I/TAAz2/tq5x7O+1mWfz2bAYSM4xFy09wut3
 fCQv/9SqPsug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886399"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2020 14:23:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/11] KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
Date:   Tue, 27 Oct 2020 14:23:43 -0700
Message-Id: <20201027212346.23409-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4d9bc0d3a929..b684f45d6a78 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -576,6 +576,21 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 
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
@@ -3069,13 +3084,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		eptp = construct_eptp(vcpu, root_hpa, root_level);
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

