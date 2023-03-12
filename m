Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E572A6B649E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCLKAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjCLJ7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD9D55514
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615130; x=1710151130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zLJ4YTAZ1/fVLeFTlzNbqZl37fz73l53ha2XxDmlKQw=;
  b=ZwNxPayWFRM120FiTlyKAenvj1bqk0WThEc1IFi35FHP+nFoUVmSzqDb
   ANOI6MEcIA2ksiEPWSNF3fzXyGtp2dL7QULWKJxPTRUq/p/gFjRH6UCID
   sKMyQXaCG5yjxG6AED+DDJ9H5kNgrY5XJZmMFIHJFuaf3HHzyd+yhsyOp
   iSU7xFrym60TxvFnQqSHFep87JbXBcwFgOrrWwIOt0qDEfJAUl5LpWQuF
   sIBQNKUx1kXTRudx99VMUstEDvKHxtL0TLHkeyH1Zefap873jmTe05CHE
   t8Av6I91l8r0hkjMCtYRoKEmts2pnvBwBvpGqE/Gr76eO7P2Rb0ty95IU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344706"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344706"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627345"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627345"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:59 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-6 08/13] pkvm: x86: Add support for pKVM to handle the nested EPT violation
Date:   Mon, 13 Mar 2023 02:03:40 +0800
Message-Id: <20230312180345.1778588-9-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

Shadow EPT is used as EPTP for nested VMs and it's initialized with empty
entries. So when EPT violation happened, pKVM shall shadowing EPT
page table entry from guest vEPT under well-designed rules.

pKVM walks the guest vEPT to find out if the L2 GPA already has a
proper mapping in vEPT. If already has one, pKVM map it in the shadow
EPT - now just directly do the same mapping as vEPT, in the future,
pKVM shall follow some rules to do the mapping, like only after
confirming the page's ownership belong to this VM.

For other cases non-proper mapping in vEPT, they actually seek for the
handling from host VM (or more accurate from KVM-high):

- for the case vEPT is not present, it's actually a #PF and requesting
  page allocation from the host, so pKVM directly forward the
  violation back to the KVM-high for proper handling.

- and for the case that vEPT contains a misconfig mapping, such
  misconfig is set by KVM-high so it expected to handle it. pKVM modify
  VM_EXIT_REASON field to EPT_MISCONFIG if VMX support read-only field
  modification, then deliver back to KVM-high. Otherwise deliver
  EPT_VIOLATION to KVM-high directly as KVM handle EPT_MISCONFIG in its
  EPT_VIOLATION handler as well.

- another case is that if the EPT violation vmexit has pending event to be
  injected, such event also seeks for host handling to do further event
  injection, pKVM shall return back to the KVM-high with
  corresponding pending event vmexit info.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c    | 60 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h    |  8 ++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.c | 40 ++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h    |  6 +++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c  |  2 +
 5 files changed, 116 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 823e255de155..65f3a39210db 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -377,3 +377,63 @@ void pkvm_guest_ept_init(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp)
 	pkvm_pgtable_init(&shadow_vcpu->vept, &virtual_ept_mm_ops, &ept_ops, &cap, false);
 	shadow_vcpu->vept.root_pa = host_gpa2hpa(guest_eptp & SPTE_BASE_ADDR_MASK);
 }
+
+static bool is_access_violation(u64 ept_entry, u64 exit_qual)
+{
+	bool access_violation = false;
+
+	if (/* Caused by data read */
+	    (((exit_qual & 0x1UL) != 0UL) && ((ept_entry & VMX_EPT_READABLE_MASK) == 0)) ||
+	    /* Caused by data write */
+	    (((exit_qual & 0x2UL) != 0UL) && ((ept_entry & VMX_EPT_WRITABLE_MASK) == 0)) ||
+	    /* Caused by instruction fetch */
+	    (((exit_qual & 0x4UL) != 0UL) && ((ept_entry & VMX_EPT_EXECUTABLE_MASK) == 0))) {
+		access_violation = true;
+	}
+
+	return access_violation;
+}
+
+enum sept_handle_ret
+pkvm_handle_shadow_ept_violation(struct shadow_vcpu_state *shadow_vcpu, u64 l2_gpa, u64 exit_quali)
+{
+	struct pkvm_shadow_vm *vm = shadow_vcpu->vm;
+	struct shadow_ept_desc *desc = &vm->sept_desc;
+	struct pkvm_pgtable *sept = &desc->sept;
+	struct pkvm_pgtable_ops *pgt_ops = sept->pgt_ops;
+	struct pkvm_pgtable *vept = &shadow_vcpu->vept;
+	enum sept_handle_ret ret = PKVM_NOT_HANDLED;
+	unsigned long phys;
+	int level;
+	u64 gprot, rsvd_chk_gprot;
+
+	pkvm_spin_lock(&vm->lock);
+
+	pkvm_pgtable_lookup(vept, l2_gpa, &phys, &gprot, &level);
+	if (phys == INVALID_ADDR)
+		/* Geust EPT not valid, back to kvm-high */
+		goto out;
+
+	if (is_access_violation(gprot, exit_quali))
+		/* Guest EPT error, refuse to handle in shadow ept */
+		goto out;
+
+	rsvd_chk_gprot = gprot;
+	/* is_rsvd_spte() need based on PAGE_SIZE bit */
+	if (level != PG_LEVEL_4K)
+		pgt_ops->pgt_entry_mkhuge(&rsvd_chk_gprot);
+
+	if (is_rsvd_spte(&ept_zero_check, rsvd_chk_gprot, level)) {
+		ret = PKVM_INJECT_EPT_MISC;
+	} else {
+		unsigned long level_size = pgt_ops->pgt_level_to_size(level);
+		unsigned long gpa = ALIGN_DOWN(l2_gpa, level_size);
+		unsigned long hpa = ALIGN_DOWN(host_gpa2hpa(phys), level_size);
+
+		if (!pkvm_pgtable_map(sept, gpa, hpa, level_size, 0, gprot))
+			ret = PKVM_HANDLED;
+	}
+out:
+	pkvm_spin_unlock(&vm->lock);
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index 420c9c5816e9..92a4f18535ea 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -12,6 +12,12 @@
 #define HOST_EPT_DEF_MMIO_PROT	(VMX_EPT_RWX_MASK |				\
 				(MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT))
 
+enum sept_handle_ret {
+	PKVM_NOT_HANDLED,
+	PKVM_HANDLED,
+	PKVM_INJECT_EPT_MISC,
+};
+
 int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size, int pgsz_mask, u64 prot);
 int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
@@ -24,6 +30,8 @@ int pkvm_shadow_ept_init(struct shadow_ept_desc *desc);
 void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc);
 void pkvm_guest_ept_init(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp);
 void pkvm_guest_ept_deinit(struct shadow_vcpu_state *shadow_vcpu);
+enum sept_handle_ret
+pkvm_handle_shadow_ept_violation(struct shadow_vcpu_state *shadow_vcpu, u64 l2_gpa, u64 exit_quali);
 
 static inline bool is_valid_eptp(u64 eptp)
 {
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 68eddb459cfa..22c161100145 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -1007,6 +1007,39 @@ int handle_vmlaunch(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static bool nested_handle_ept_violation(struct shadow_vcpu_state *shadow_vcpu,
+					u64 l2_gpa, u64 exit_quali)
+{
+	enum sept_handle_ret ret = pkvm_handle_shadow_ept_violation(shadow_vcpu,
+								    l2_gpa, exit_quali);
+	bool handled = false;
+
+	switch (ret) {
+	case PKVM_INJECT_EPT_MISC: {
+		/*
+		 * Inject EPT_MISCONFIG vmexit reason if can directly modify
+		 * the read-only fields. Otherwise still deliver EPT_VIOLATION
+		 * for simplification.
+		 */
+		if (vmx_has_vmwrite_any_field())
+			vmcs_write32(VM_EXIT_REASON, EXIT_REASON_EPT_MISCONFIG);
+		break;
+	}
+	case PKVM_HANDLED:
+		handled = true;
+		break;
+	default:
+		break;
+	}
+
+	if (handled && (vmcs_read32(IDT_VECTORING_INFO_FIELD) &
+			VECTORING_INFO_VALID_MASK))
+		/* pending interrupt, back to kvm-high to inject */
+		handled = false;
+
+	return handled;
+}
+
 int nested_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1015,6 +1048,13 @@ int nested_vmexit(struct kvm_vcpu *vcpu)
 	struct vmcs *vmcs02 = (struct vmcs *)cur_shadow_vcpu->vmcs02;
 	struct vmcs12 *vmcs12 = (struct vmcs12 *)cur_shadow_vcpu->cached_vmcs12;
 
+	if ((vmx->exit_reason.full == EXIT_REASON_EPT_VIOLATION) &&
+		nested_handle_ept_violation(cur_shadow_vcpu,
+					    vmcs_read64(GUEST_PHYSICAL_ADDRESS),
+					    vmx->exit_qualification))
+		/* EPT violation can be handled by pkvm, no need back to kvm-high */
+		return 0;
+
 	/* clear guest mode if need switch back to host */
 	vcpu->arch.hflags &= ~HF_GUEST_MASK;
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index 3282f228964d..463780776666 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -40,6 +40,12 @@ static inline bool vmx_has_ept_execute_only(void)
 	return vmx_ept_capability_check(VMX_EPT_EXECUTE_ONLY_BIT);
 }
 
+static inline bool vmx_has_vmwrite_any_field(void)
+{
+	return !!(pkvm_hyp->vmcs_config.nested.misc_low &
+			MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS);
+}
+
 static inline u64 pkvm_construct_eptp(unsigned long root_hpa, int level)
 {
 	u64 eptp = 0;
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index e5eab94f3e5e..498e304cfb94 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -380,6 +380,8 @@ static __init void pkvm_host_setup_nested_vmx_cap(struct pkvm_hyp *pkvm)
 	rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
 		msrs->entry_ctls_low,
 		msrs->entry_ctls_high);
+
+	rdmsr(MSR_IA32_VMX_MISC, msrs->misc_low, msrs->misc_high);
 }
 
 static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
-- 
2.25.1

