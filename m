Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6AB1878B9
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCQEyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:54:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:34117 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgCQExU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:20 -0400
IronPort-SDR: Y4/aPNuHRPM5qiAtvkwZI4EqkhrK7HbN7ebDARHPnnXjDjVxqVAs1TvLxymTS7LA1OcUn0N6gX
 AmMJa7z8AeJQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:20 -0700
IronPort-SDR: bQk3yQSuq6WzRbvEkRRY6WsZsnX4XkVv1x7xaiXeRuWZxO5TkhMjIFLH/N2F9+0v/GSNu5oP2E
 DonKKXtpShyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252809"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:20 -0700
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
Subject: [PATCH v2 23/32] KVM: nVMX: Add helper to handle TLB flushes on nested VM-Enter/VM-Exit
Date:   Mon, 16 Mar 2020 21:52:29 -0700
Message-Id: <20200317045238.30434-24-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
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

Skip the INVVPID if a TLB flush is pending, which mostly preserves the
existing logic, but also skips INVVPID in the unlikely event that a TLB
flush was requested for some other reason.

Remove the explicit enable_vpid from prepare_vmcs02() as its implied by
nested_cpu_has_vpid(), which can return true if and only if VPID is
enabled in KVM (L0).

Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 83 +++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 960ecbab5ebe..a7cc41e69948 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1154,6 +1154,31 @@ static bool nested_has_guest_tlb_tag(struct kvm_vcpu *vcpu)
 	       (nested_cpu_has_vpid(vmcs12) && to_vmx(vcpu)->nested.vpid02);
 }
 
+static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
+					    struct vmcs12 *vmcs12)
+{
+	/*
+	 * If VPID is disabled, linear and combined mappings are flushed on
+	 * VM-Enter/VM-Exit, and guest-physical mappings are valid only for
+	 * their associated EPTP.
+	 *
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
+	 */
+	if (enable_vpid &&
+	    (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu)))
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+}
+
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 {
 	superset &= mask;
@@ -2462,31 +2487,20 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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
+	nested_vmx_transition_tlb_flush(vcpu, vmcs12);
+
+	/*
+	 * There is no direct mapping between vpid02 and vpid12, vpid02 is
+	 * per-vCPU and reused for all nested vCPUs.  If vpid12 is changing
+	 * then the new "virtual" VPID will reuse the same "real" VPID,
+	 * vpid02, and so needs to be sync'd.  Skip the sync if a TLB flush
+	 * has already been requested, but always update the last used VPID.
+	 */
+	if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu) &&
+	    vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
+		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
+		if (!kvm_test_request(KVM_REQ_TLB_FLUSH, vcpu))
+			vpid_sync_context(nested_get_vpid02(vcpu));
 	}
 
 	if (nested_cpu_has_ept(vmcs12))
@@ -4054,24 +4068,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
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
+	nested_vmx_transition_tlb_flush(vcpu, vmcs12);
 
 	vmcs_write32(GUEST_SYSENTER_CS, vmcs12->host_ia32_sysenter_cs);
 	vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->host_ia32_sysenter_esp);
-- 
2.24.1

