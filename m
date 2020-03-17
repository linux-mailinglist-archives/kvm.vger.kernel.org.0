Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC91878AB
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgCQExY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:53:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:34126 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbgCQExX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:23 -0400
IronPort-SDR: C3MPFO1vQYfiEdJ3GD/EbwDKZ6IJcdVjxboZSjQvA8mi2gXcAJTderY+CuRX8Fphhe6OJcsmxm
 7rnQq8vzU5kA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:22 -0700
IronPort-SDR: rDH3iAmDJc0zU3ociC8voHWM+TnzrY7x0lPDZE2EuYkKqhS2maCO2Y2VIv/OyascB6Z0nmPJGb
 FDUf69ptlkYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252824"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:22 -0700
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
Subject: [PATCH v2 27/32] KVM: nVMX: Reload APIC access page on nested VM-Exit only if necessary
Date:   Mon, 16 Mar 2020 21:52:33 -0700
Message-Id: <20200317045238.30434-28-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defer reloading L1's APIC page by logging the need for a reload and
processing it during nested VM-Exit instead of unconditionally reloading
the APIC page on nested VM-Exit.  This eliminates a TLB flush on the
majority of VM-Exits as the APIC page rarely needs to be reloaded.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  9 ++++-----
 arch/x86/kvm/vmx/vmx.c    | 10 +++++++---
 arch/x86/kvm/vmx/vmx.h    |  1 +
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 04cdf7ded1d3..d816f1366943 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4365,11 +4365,10 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc = NULL;
 
-	/*
-	 * We are now running in L2, mmu_notifier will force to reload the
-	 * page's hpa for L2 vmcs. Need to reload it for L1 before entering L1.
-	 */
-	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
+	if (vmx->nested.reload_vmcs01_apic_access_page) {
+		vmx->nested.reload_vmcs01_apic_access_page = false;
+		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
+	}
 
 	if ((exit_reason != -1) && (enable_shadow_vmcs || vmx->nested.hv_evmcs))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ae7279802652..3155329bf844 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6138,10 +6138,14 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
 {
-	if (!is_guest_mode(vcpu)) {
-		vmcs_write64(APIC_ACCESS_ADDR, hpa);
-		vmx_flush_tlb_current(vcpu);
+	/* Defer reload until vmcs01 is the current VMCS. */
+	if (is_guest_mode(vcpu)) {
+		to_vmx(vcpu)->nested.reload_vmcs01_apic_access_page = true;
+		return;
 	}
+
+	vmcs_write64(APIC_ACCESS_ADDR, hpa);
+	vmx_flush_tlb_current(vcpu);
 }
 
 static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 571249e18bb6..66cc9f639e4b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -138,6 +138,7 @@ struct nested_vmx {
 	bool vmcs02_initialized;
 
 	bool change_vmcs01_virtual_apic_mode;
+	bool reload_vmcs01_apic_access_page;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-- 
2.24.1

