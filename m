Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E318DA24
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgCTV24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:28:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:20437 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgCTV24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:56 -0400
IronPort-SDR: Nub8Aq4wYem5FWWiiyNKCeRXXnp5zGBLHdzEFPM0UFaxwm+Im8h29vasnJLlN4s3pEiPxoZ2OA
 CkxdKtB7v8Fg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:55 -0700
IronPort-SDR: EfZtbXSKUdYlWXWfNfF5mH3KaZRw+fzRyEDETlB1bxrwIe0upPZU6RJrHNBPCn4I1a5wt8cG1K
 CwT0jm5bp5oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224488"
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
Subject: [PATCH v3 23/37] KVM: nVMX: Add helper to handle TLB flushes on nested VM-Enter/VM-Exit
Date:   Fri, 20 Mar 2020 14:28:19 -0700
Message-Id: <20200320212833.3507-24-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to determine whether or not a full TLB flush needs to be
performed on nested VM-Enter/VM-Exit, as the logic is identical for both
flows and needs a fairly beefy comment to boot.  This also provides a
common point to make future adjustments to the logic.

Handle vpid12 changes the new helper as well even though it is specific
to VM-Enter.  The vpid12 logic is an extension of the flushing logic,
and it's worth the extra bool parameter to provide a single location for
the flushing logic.

Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 88 +++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 77819d890088..580d5c98352f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1154,6 +1154,48 @@ static bool nested_has_guest_tlb_tag(struct kvm_vcpu *vcpu)
 	       (nested_cpu_has_vpid(vmcs12) && to_vmx(vcpu)->nested.vpid02);
 }
 
+static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
+					    struct vmcs12 *vmcs12,
+					    bool is_vmenter)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * If VPID is disabled, linear and combined mappings are flushed on
+	 * VM-Enter/VM-Exit, and guest-physical mappings are valid only for
+	 * their associated EPTP.
+	 */
+	if (!enable_vpid)
+		return;
+
+	/*
+	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
+	 * for *all* contexts to be flushed on VM-Enter/VM-Exit.
+	 *
+	 * If VPID is enabled and used by vmc12, but L2 does not have a unique
+	 * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
+	 * a VPID for L2, flush the TLB as the effective ASID is common to both
+	 * L1 and L2.
+	 *
+	 * Defer the flush so that it runs after vmcs02.EPTP has been set by
+	 * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
+	 * redundant flushes further down the nested pipeline.
+	 *
+	 * If a TLB flush isn't required due to any of the above, and vpid12 is
+	 * changing then the new "virtual" VPID (vpid12) will reuse the same
+	 * "real" VPID (vpid02), and so needs to be sync'd.  There is no direct
+	 * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
+	 * all nested vCPUs.
+	 */
+	if (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu)) {
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+	} else if (is_vmenter &&
+		   vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
+		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
+		vpid_sync_context(nested_get_vpid02(vcpu));
+	}
+}
+
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 {
 	superset &= mask;
@@ -2462,32 +2504,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_has_tsc_control)
 		decache_tsc_multiplier(vmx);
 
-	if (enable_vpid) {
-		/*
-		 * There is no direct mapping between vpid02 and vpid12, the
-		 * vpid02 is per-vCPU for L0 and reused while the value of
-		 * vpid12 is changed w/ one invvpid during nested vmentry.
-		 * The vpid12 is allocated by L1 for L2, so it will not
-		 * influence global bitmap(for vpid01 and vpid02 allocation)
-		 * even if spawn a lot of nested vCPUs.
-		 */
-		if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu)) {
-			if (vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
-				vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-				vpid_sync_context(nested_get_vpid02(vcpu));
-			}
-		} else {
-			/*
-			 * If L1 use EPT, then L0 needs to execute INVEPT on
-			 * EPTP02 instead of EPTP01. Therefore, delay TLB
-			 * flush until vmcs02->eptp is fully updated by
-			 * KVM_REQ_LOAD_MMU_PGD. Note that this assumes
-			 * KVM_REQ_TLB_FLUSH is evaluated after
-			 * KVM_REQ_LOAD_MMU_PGD in vcpu_enter_guest().
-			 */
-			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-		}
-	}
+	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
 
 	if (nested_cpu_has_ept(vmcs12))
 		nested_ept_init_mmu_context(vcpu);
@@ -4054,24 +4071,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	if (!enable_ept)
 		vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;
 
-	/*
-	 * If vmcs01 doesn't use VPID, CPU flushes TLB on every
-	 * VMEntry/VMExit. Thus, no need to flush TLB.
-	 *
-	 * If vmcs12 doesn't use VPID, L1 expects TLB to be
-	 * flushed on every VMEntry/VMExit.
-	 *
-	 * Otherwise, we can preserve TLB entries as long as we are
-	 * able to tag L1 TLB entries differently than L2 TLB entries.
-	 *
-	 * If vmcs12 uses EPT, we need to execute this flush on EPTP01
-	 * and therefore we request the TLB flush to happen only after VMCS EPTP
-	 * has been set by KVM_REQ_LOAD_MMU_PGD.
-	 */
-	if (enable_vpid &&
-	    (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu))) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	}
+	nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);
 
 	vmcs_write32(GUEST_SYSENTER_CS, vmcs12->host_ia32_sysenter_cs);
 	vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->host_ia32_sysenter_esp);
-- 
2.24.1

