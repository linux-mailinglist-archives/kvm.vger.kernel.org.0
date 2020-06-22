Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4762043C7
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbgFVWmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:42:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:27423 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730954AbgFVWmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:53 -0400
IronPort-SDR: EHRXotRI3e1/NCq5v0gTctS8l3QC/B/XYDxA+spvk8uxMd2NZswQnSWHQZp+zBvfAbAbuKTIwS
 ZFTcaAiLo6Wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303563"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:52 -0700
IronPort-SDR: WP3dye+OydUpPYb9M0MXpQ3M2QZqt9UnGl1txNfqFYoOAH/kJTFFC1g7V5fOftHlnRGLHvXoqi
 vpz3VEASddnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634908"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] KVM: VMX: Rename "vmx_find_msr_index" to "vmx_find_loadstore_msr_slot"
Date:   Mon, 22 Jun 2020 15:42:37 -0700
Message-Id: <20200622224249.29562-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "loadstore" to vmx_find_msr_index() to differentiate it from the so
called shared MSRs helpers (which will soon be renamed), and replace
"index" with "slot" to better convey that the helper returns slot in the
array, not the MSR index (the value that gets stuffed into ECX).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 16 ++++++++--------
 arch/x86/kvm/vmx/vmx.c    | 10 +++++-----
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index df33878ff612..afc8e7e9ef24 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -933,11 +933,11 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 	 * VM-exit in L0, use the more accurate value.
 	 */
 	if (msr_index == MSR_IA32_TSC) {
-		int index = vmx_find_msr_index(&vmx->msr_autostore.guest,
-					       MSR_IA32_TSC);
+		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore.guest,
+						    MSR_IA32_TSC);
 
-		if (index >= 0) {
-			u64 val = vmx->msr_autostore.guest.val[index].value;
+		if (i >= 0) {
+			u64 val = vmx->msr_autostore.guest.val[i].value;
 
 			*data = kvm_read_l1_tsc(vcpu, val);
 			return true;
@@ -1026,12 +1026,12 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
 	bool in_vmcs12_store_list;
-	int msr_autostore_index;
+	int msr_autostore_slot;
 	bool in_autostore_list;
 	int last;
 
-	msr_autostore_index = vmx_find_msr_index(autostore, msr_index);
-	in_autostore_list = msr_autostore_index >= 0;
+	msr_autostore_slot = vmx_find_loadstore_msr_slot(autostore, msr_index);
+	in_autostore_list = msr_autostore_slot >= 0;
 	in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
 
 	if (in_vmcs12_store_list && !in_autostore_list) {
@@ -1052,7 +1052,7 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 		autostore->val[last].index = msr_index;
 	} else if (!in_vmcs12_store_list && in_autostore_list) {
 		last = --autostore->nr;
-		autostore->val[msr_autostore_index] = autostore->val[last];
+		autostore->val[msr_autostore_slot] = autostore->val[last];
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 19e6f697affb..ba9af25b34e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -826,7 +826,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_clearbit(vmx, exit);
 }
 
-int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
+int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;
 
@@ -860,7 +860,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 		}
 		break;
 	}
-	i = vmx_find_msr_index(&m->guest, msr);
+	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
 	if (i < 0)
 		goto skip_guest;
 	--m->guest.nr;
@@ -868,7 +868,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
 
 skip_guest:
-	i = vmx_find_msr_index(&m->host, msr);
+	i = vmx_find_loadstore_msr_slot(&m->host, msr);
 	if (i < 0)
 		return;
 
@@ -927,9 +927,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 	}
 
-	i = vmx_find_msr_index(&m->guest, msr);
+	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
 	if (!entry_only)
-		j = vmx_find_msr_index(&m->host, msr);
+		j = vmx_find_loadstore_msr_slot(&m->host, msr);
 
 	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
 	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4c053d204bea..12a845209088 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -354,7 +354,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
+int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 
-- 
2.26.0

