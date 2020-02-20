Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E791668B5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 21:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBTUoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 15:44:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:13654 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729139AbgBTUoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 15:44:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 12:44:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="349237117"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2020 12:44:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] KVM: VMX: Drop @invalidate_gpa from __vmx_flush_tlb()
Date:   Thu, 20 Feb 2020 12:43:55 -0800
Message-Id: <20200220204356.8837-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop @invalidate_gpa from __vmx_flush_tlb() now that it's sole caller
unconditionally passes %true, i.e. "(invalidate_gpa || !enable_vpid)"
will always evaluate true.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6e588d238318..6e0ca57cc41c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -501,10 +501,9 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
 
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
 
-static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
-				bool invalidate_gpa)
+static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid)
 {
-	if (enable_ept && (invalidate_gpa || !enable_vpid)) {
+	if (enable_ept) {
 		if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 			return;
 		ept_sync_context(construct_eptp(vcpu,
@@ -516,7 +515,7 @@ static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
 
 static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, true);
+	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid);
 }
 
 static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
-- 
2.24.1

