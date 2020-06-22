Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB62D2043F3
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbgFVWpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:45:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:27425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731185AbgFVWm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:57 -0400
IronPort-SDR: cbP3cgSTgmaE/7kRgzxfcnKWjL3hxQzRf0l+3ygT14M2bwKy9jF7sZZNQBiQ0hDL0VDz2D4zI5
 1HpObJW+gJqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303573"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303573"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:54 -0700
IronPort-SDR: CnezVRDlmv/faYZTE5hV5sWU9cmoLdiae+a8ia+x+HZKDasfglgHe4tKY21wobHkTzrRjA3Ngd
 GY/6JGkzvsag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634924"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] KVM: VMX: Rename "__find_msr_index" to "__vmx_find_uret_msr"
Date:   Mon, 22 Jun 2020 15:42:42 -0700
Message-Id: <20200622224249.29562-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "__find_msr_index" to scope it to VMX, associate it with
guest_uret_msrs, and to avoid conflating "MSR's ECX index" with "MSR's
array index".  Similarly, don't use "slot" in the name so as to avoid
colliding the common x86's half of "user_return_msrs" (the slot in
kvm_user_return_msrs is not the same slot in guest_uret_msrs).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cebd68ea50ba..a0f4049d956f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -625,7 +625,7 @@ static inline bool report_flexpriority(void)
 	return flexpriority_enabled;
 }
 
-static inline int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
+static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
@@ -639,7 +639,7 @@ struct vmx_uret_msr *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	i = __find_msr_index(vmx, msr);
+	i = __vmx_find_uret_msr(vmx, msr);
 	if (i >= 0)
 		return &vmx->guest_uret_msrs[i];
 	return NULL;
@@ -1737,24 +1737,24 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	 * when EFER.SCE is set.
 	 */
 	if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
-		index = __find_msr_index(vmx, MSR_STAR);
+		index = __vmx_find_uret_msr(vmx, MSR_STAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, nr_active_uret_msrs++);
-		index = __find_msr_index(vmx, MSR_LSTAR);
+		index = __vmx_find_uret_msr(vmx, MSR_LSTAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, nr_active_uret_msrs++);
-		index = __find_msr_index(vmx, MSR_SYSCALL_MASK);
+		index = __vmx_find_uret_msr(vmx, MSR_SYSCALL_MASK);
 		if (index >= 0)
 			move_msr_up(vmx, index, nr_active_uret_msrs++);
 	}
 #endif
-	index = __find_msr_index(vmx, MSR_EFER);
+	index = __vmx_find_uret_msr(vmx, MSR_EFER);
 	if (index >= 0 && update_transition_efer(vmx, index))
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
-	index = __find_msr_index(vmx, MSR_TSC_AUX);
+	index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
 	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
-	index = __find_msr_index(vmx, MSR_IA32_TSX_CTRL);
+	index = __vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 	if (index >= 0)
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
 
-- 
2.26.0

