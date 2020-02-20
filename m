Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621141668B1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgBTUoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:06 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgBTUoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:44:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:44:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237122"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:44:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] KVM: VMX: Fold __vmx_flush_tlb() into vmx_flush_tlb()
Date:   Thu, 20 Feb 2020 12:43:56 -0800
Message-Id: <20200220204356.8837-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold __vmx_flush_tlb() into its sole caller, vmx_flush_tlb(), now that
all call sites that previously bounced through __vmx_flush_tlb() to
force the INVVPID path instead call vpid_sync_context() directly.

Opportunistically add a comment to explain why INVEPT is necessary when
EPT is enabled, even if VPID is disabled.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6e0ca57cc41c..6204fa5897bb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -501,23 +501,25 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
 
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
 
-static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid)
+static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * INVEPT must be issued when EPT is enabled, irrespective of VPID, as
+	 * the CPU is not required to invalidate GPA->HPA mappings on VM-Entry,
+	 * even if VPID is disabled.  GPA->HPA mappings are associated with the
+	 * root EPT structure and not any particular VPID (INVVPID is also not
+	 * required to invalidate GPA->HPA mappings).
+	 */
 	if (enable_ept) {
 		if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 			return;
 		ept_sync_context(construct_eptp(vcpu,
 						vcpu->arch.mmu->root_hpa));
 	} else {
-		vpid_sync_context(vpid);
+		vpid_sync_context(to_vmx(vcpu)->vpid);
 	}
 }
 
-static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
-{
-	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid);
-}
-
 static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
 {
 	vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
-- 
2.24.1

