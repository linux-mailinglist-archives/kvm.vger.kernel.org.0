Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE392043E6
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgFVWm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:42:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:27426 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731183AbgFVWm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:57 -0400
IronPort-SDR: EFiwWeqnrDAYsrX0ZXcuXBv4IIW+t+1g+0nfqUow2U/eKdtd49gK4g2dXnz9dpYreePZLmvPx+
 OWVrMcZcp5Yw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303569"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303569"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:53 -0700
IronPort-SDR: td+YW2MCcggCsxMjiLuIZRvkuADvVlfCJJtwDbLS0kKY6unhhjRFmbFKdjXmLkC/4NJ6SZ++Q1
 GgniBR6b50oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634918"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/15] KVM: VMX: Rename vcpu_vmx's "save_nmsrs" to "nr_active_uret_msrs"
Date:   Mon, 22 Jun 2020 15:42:40 -0700
Message-Id: <20200622224249.29562-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "uret" into the name of "save_nmsrs" to explicitly associate it with
the guest_uret_msrs array, and replace "save" with "active" (for lack of
a better word) to better describe what is being tracked.  While "save"
is more or less accurate when viewed as a literal description of the
field, e.g. it holds the number of MSRs that were saved into the array
the last time setup_msrs() was invoked, it can easily be misinterpreted
by the reader, e.g. as meaning the number of MSRs that were saved from
hardware at some point in the past, or as the number of MSRs that need
to be saved at some point in the future, both of which are wrong.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++-----------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d957f9d2e351..baf425fa7089 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -651,7 +651,7 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct vmx_uret_msr *msr, u64
 
 	u64 old_msr_data = msr->data;
 	msr->data = data;
-	if (msr - vmx->guest_uret_msrs < vmx->save_nmsrs) {
+	if (msr - vmx->guest_uret_msrs < vmx->nr_active_uret_msrs) {
 		preempt_disable();
 		ret = kvm_set_user_return_msr(msr->index, msr->data, msr->mask);
 		preempt_enable();
@@ -1144,7 +1144,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (!vmx->guest_msrs_ready) {
 		vmx->guest_msrs_ready = true;
-		for (i = 0; i < vmx->save_nmsrs; ++i)
+		for (i = 0; i < vmx->nr_active_uret_msrs; ++i)
 			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].index,
 						vmx->guest_uret_msrs[i].data,
 						vmx->guest_uret_msrs[i].mask);
@@ -1728,9 +1728,9 @@ static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
  */
 static void setup_msrs(struct vcpu_vmx *vmx)
 {
-	int save_nmsrs, index;
+	int nr_active_uret_msrs, index;
 
-	save_nmsrs = 0;
+	nr_active_uret_msrs = 0;
 #ifdef CONFIG_X86_64
 	/*
 	 * The SYSCALL MSRs are only needed on long mode guests, and only
@@ -1739,26 +1739,26 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
 		index = __find_msr_index(vmx, MSR_STAR);
 		if (index >= 0)
-			move_msr_up(vmx, index, save_nmsrs++);
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
 		index = __find_msr_index(vmx, MSR_LSTAR);
 		if (index >= 0)
-			move_msr_up(vmx, index, save_nmsrs++);
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
 		index = __find_msr_index(vmx, MSR_SYSCALL_MASK);
 		if (index >= 0)
-			move_msr_up(vmx, index, save_nmsrs++);
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
 	}
 #endif
 	index = __find_msr_index(vmx, MSR_EFER);
 	if (index >= 0 && update_transition_efer(vmx, index))
-		move_msr_up(vmx, index, save_nmsrs++);
+		move_msr_up(vmx, index, nr_active_uret_msrs++);
 	index = __find_msr_index(vmx, MSR_TSC_AUX);
 	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
-		move_msr_up(vmx, index, save_nmsrs++);
+		move_msr_up(vmx, index, nr_active_uret_msrs++);
 	index = __find_msr_index(vmx, MSR_IA32_TSX_CTRL);
 	if (index >= 0)
-		move_msr_up(vmx, index, save_nmsrs++);
+		move_msr_up(vmx, index, nr_active_uret_msrs++);
 
-	vmx->save_nmsrs = save_nmsrs;
+	vmx->nr_active_uret_msrs = nr_active_uret_msrs;
 	vmx->guest_msrs_ready = false;
 
 	if (cpu_has_vmx_msr_bitmap())
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 16450f85ddcb..55257195cb27 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -219,7 +219,7 @@ struct vcpu_vmx {
 
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
 	int                   nr_uret_msrs;
-	int                   save_nmsrs;
+	int                   nr_active_uret_msrs;
 	bool                  guest_msrs_ready;
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
-- 
2.26.0

