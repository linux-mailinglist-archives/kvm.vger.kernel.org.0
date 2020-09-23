Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9570D275F51
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgIWSEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:39920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgIWSEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:23 -0400
IronPort-SDR: XtbGJI6N11uV3ygixK7k2A8yjsUp7vYFK3WwsBfXlCPB/4aRMJjHgZSVtKlWh+nKXGbxG0o2Jx
 t6Rf57v4XnQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245808965"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245808965"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:12 -0700
IronPort-SDR: DuSpDFp3tBE1SbzAv/XVarxKcAor9MYjUx84Yn2vSxPZnS+VEwpaXyolBgfFIsWJSZo1Ir8Jgq
 BxfPlLxtnC1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670263"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/15] KVM: VMX: Rename "vmx_find_msr_index" to "vmx_find_loadstore_msr_slot"
Date:   Wed, 23 Sep 2020 11:03:57 -0700
Message-Id: <20200923180409.32255-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index f818a406302a..87e5d606582e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -938,11 +938,11 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
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
@@ -1031,12 +1031,12 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
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
@@ -1057,7 +1057,7 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 		autostore->val[last].index = msr_index;
 	} else if (!in_vmcs12_store_list && in_autostore_list) {
 		last = --autostore->nr;
-		autostore->val[msr_autostore_index] = autostore->val[last];
+		autostore->val[msr_autostore_slot] = autostore->val[last];
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e99f3bbfa6e9..35291fd90ca0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -824,7 +824,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_clearbit(vmx, exit);
 }
 
-int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
+int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;
 
@@ -858,7 +858,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 		}
 		break;
 	}
-	i = vmx_find_msr_index(&m->guest, msr);
+	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
 	if (i < 0)
 		goto skip_guest;
 	--m->guest.nr;
@@ -866,7 +866,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
 
 skip_guest:
-	i = vmx_find_msr_index(&m->host, msr);
+	i = vmx_find_loadstore_msr_slot(&m->host, msr);
 	if (i < 0)
 		return;
 
@@ -925,9 +925,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
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
index 9a418c274880..26887082118d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -353,7 +353,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
+int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
 #define POSTED_INTR_ON  0
-- 
2.28.0

