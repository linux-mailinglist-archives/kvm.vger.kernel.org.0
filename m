Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F7C275F61
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgIWSFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:05:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:16542 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgIWSES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:18 -0400
IronPort-SDR: N3xT52LoHp3+YrUbBrrmb7WrbQ6gTPJr0vcbFtT0fK5r2DAx7x3KH5yykNa8AR5QeikOke5eI8
 hhklw01fV+AA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148637141"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148637141"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:13 -0700
IronPort-SDR: ptTciUjFNC8LbQJHbh4fHN8YaAsy7tTHmCRp9Atur5VpCOPj5pq+OxctDJi4w8DbUK8Ag5oLQg
 m8rr9WBKptlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670295"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/15] KVM: VMX: Add vmx_setup_uret_msr() to handle lookup and swap
Date:   Wed, 23 Sep 2020 11:04:05 -0700
Message-Id: <20200923180409.32255-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmx_setup_uret_msr() to wrap the lookup and manipulation of the uret
MSRs array during setup_msrs().  In addition to consolidating code, this
eliminates move_msr_up(), which while being a very literally description
of the function, isn't exacly helpful in understanding the net effect of
the code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 49 ++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f3192855f0fb..93cf86672764 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1685,12 +1685,15 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmx_clear_hlt(vcpu);
 }
 
-/*
- * Swap MSR entry in host/guest MSR entry array.
- */
-static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
+static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
 {
 	struct vmx_uret_msr tmp;
+	int from, to;
+
+	from = __vmx_find_uret_msr(vmx, msr);
+	if (from < 0)
+		return;
+	to = vmx->nr_active_uret_msrs++;
 
 	tmp = vmx->guest_uret_msrs[to];
 	vmx->guest_uret_msrs[to] = vmx->guest_uret_msrs[from];
@@ -1704,42 +1707,26 @@ static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
  */
 static void setup_msrs(struct vcpu_vmx *vmx)
 {
-	int nr_active_uret_msrs, index;
-
-	nr_active_uret_msrs = 0;
+	vmx->guest_uret_msrs_loaded = false;
+	vmx->nr_active_uret_msrs = 0;
 #ifdef CONFIG_X86_64
 	/*
 	 * The SYSCALL MSRs are only needed on long mode guests, and only
 	 * when EFER.SCE is set.
 	 */
 	if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
-		index = __vmx_find_uret_msr(vmx, MSR_STAR);
-		if (index >= 0)
-			move_msr_up(vmx, index, nr_active_uret_msrs++);
-		index = __vmx_find_uret_msr(vmx, MSR_LSTAR);
-		if (index >= 0)
-			move_msr_up(vmx, index, nr_active_uret_msrs++);
-		index = __vmx_find_uret_msr(vmx, MSR_SYSCALL_MASK);
-		if (index >= 0)
-			move_msr_up(vmx, index, nr_active_uret_msrs++);
+		vmx_setup_uret_msr(vmx, MSR_STAR);
+		vmx_setup_uret_msr(vmx, MSR_LSTAR);
+		vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK);
 	}
 #endif
-	if (update_transition_efer(vmx)) {
-		index = __vmx_find_uret_msr(vmx, MSR_EFER);
-		if (index >= 0)
-			move_msr_up(vmx, index, nr_active_uret_msrs++);
-	}
-	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)) {
-		index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
-		if (index >= 0)
-			move_msr_up(vmx, index, nr_active_uret_msrs++);
-	}
-	index = __vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
-	if (index >= 0)
-		move_msr_up(vmx, index, nr_active_uret_msrs++);
+	if (update_transition_efer(vmx))
+		vmx_setup_uret_msr(vmx, MSR_EFER);
 
-	vmx->nr_active_uret_msrs = nr_active_uret_msrs;
-	vmx->guest_uret_msrs_loaded = false;
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
+		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
+
+	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
-- 
2.28.0

