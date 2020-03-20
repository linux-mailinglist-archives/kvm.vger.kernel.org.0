Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1402318DA3B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgCTV3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:37248 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbgCTV26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:58 -0400
IronPort-SDR: loKqlfHEIS/HV8gVtscVGUMvnIP12bgfSd3KOI4spr8lw3CzAI6RHLOhEPX+kBknY2H0hYHY5L
 Ebd3I5q4fftw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:57 -0700
IronPort-SDR: t8PxrdRe/T6Yly0mSlEmDIx2VhQpOXdEMHQYz6cyrwkgzoQfbgxdOK+3frxerDllanquPW9fW8
 3+nxpSryUyuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224504"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:57 -0700
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
Subject: [PATCH v3 28/37] KVM: VMX: Retrieve APIC access page HPA only when necessary
Date:   Fri, 20 Mar 2020 14:28:24 -0700
Message-Id: <20200320212833.3507-29-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the retrieval of the HPA associated with L1's APIC access page into
VMX code to avoid unnecessarily calling gfn_to_page(), e.g. when the
vCPU is in guest mode (L2).  Alternatively, the optimization logic in
VMX could be mirrored into the common x86 code, but that will get ugly
fast when further optimizations are introduced.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++++++++--
 arch/x86/kvm/x86.c              | 13 +------------
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26fa52450569..31aa93088bf9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1154,7 +1154,7 @@ struct kvm_x86_ops {
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
-	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
+	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
 	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3155329bf844..e8d409b50afd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6136,16 +6136,28 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap(vcpu);
 }
 
-static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
+static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
+	struct page *page;
+
 	/* Defer reload until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
 		to_vmx(vcpu)->nested.reload_vmcs01_apic_access_page = true;
 		return;
 	}
 
-	vmcs_write64(APIC_ACCESS_ADDR, hpa);
+	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	if (is_error_page(page))
+		return;
+
+	vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
 	vmx_flush_tlb_current(vcpu);
+
+	/*
+	 * Do not pin apic access page in memory, the MMU notifier
+	 * will call us again if it is migrated or swapped out.
+	 */
+	put_page(page);
 }
 
 static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cccfcf612008..26c24af87cca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8157,24 +8157,13 @@ int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
-	struct page *page = NULL;
-
 	if (!lapic_in_kernel(vcpu))
 		return;
 
 	if (!kvm_x86_ops->set_apic_access_page_addr)
 		return;
 
-	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (is_error_page(page))
-		return;
-	kvm_x86_ops->set_apic_access_page_addr(vcpu, page_to_phys(page));
-
-	/*
-	 * Do not pin apic access page in memory, the MMU notifier
-	 * will call us again if it is migrated or swapped out.
-	 */
-	put_page(page);
+	kvm_x86_ops->set_apic_access_page_addr(vcpu);
 }
 
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
-- 
2.24.1

