Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287182043F1
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgFVWow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:44:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:27425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgFVWm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:57 -0400
IronPort-SDR: fl99ngNz9N+Bh2ZAITxTEmhPGF5t8EibazaOFrmohFs8ux4DFq6wlZEMfN52S4IG6LEfvqx9jV
 u3eYeE8flzRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303575"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303575"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:54 -0700
IronPort-SDR: gsjx3G/SzUdGeQYFuDLMKThH/xydo9m+BNi0W+4o3RqkZttYlTgp5kpL8BQiP/Y02gB55KQmXs
 OFbhXg7Bw0gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634930"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] KVM: VMX: Move uret MSR lookup into update_transition_efer()
Date:   Mon, 22 Jun 2020 15:42:44 -0700
Message-Id: <20200622224249.29562-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move checking for the existence of MSR_EFER in the uret MSR array into
update_transition_efer() so that the lookup and manipulation of the
array in setup_msrs() occur back-to-back.  This paves the way toward
adding a helper to wrap the lookup and manipulation.

To avoid unnecessary overhead, defer the lookup until the uret array
would actually be modified in update_transition_efer().  EFER obviously
exists on CPUs that support the dedicated VMCS fields for switching
EFER, and EFER must exist for the guest and host EFER.NX value to
diverge, i.e. there is no danger of attempting to read/write EFER when
it doesn't exist.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 954b9aa950f2..8731ca8ca2b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -955,10 +955,11 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	m->host.val[j].value = host_val;
 }
 
-static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
+static bool update_transition_efer(struct vcpu_vmx *vmx)
 {
 	u64 guest_efer = vmx->vcpu.arch.efer;
 	u64 ignore_bits = 0;
+	int i;
 
 	/* Shadow paging assumes NX to be available.  */
 	if (!enable_ept)
@@ -990,17 +991,21 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 		else
 			clear_atomic_switch_msr(vmx, MSR_EFER);
 		return false;
-	} else {
-		clear_atomic_switch_msr(vmx, MSR_EFER);
-
-		guest_efer &= ~ignore_bits;
-		guest_efer |= host_efer & ignore_bits;
-
-		vmx->guest_uret_msrs[efer_offset].data = guest_efer;
-		vmx->guest_uret_msrs[efer_offset].mask = ~ignore_bits;
-
-		return true;
 	}
+
+	i = __vmx_find_uret_msr(vmx, MSR_EFER);
+	if (i < 0)
+		return false;
+
+	clear_atomic_switch_msr(vmx, MSR_EFER);
+
+	guest_efer &= ~ignore_bits;
+	guest_efer |= host_efer & ignore_bits;
+
+	vmx->guest_uret_msrs[i].data = guest_efer;
+	vmx->guest_uret_msrs[i].mask = ~ignore_bits;
+
+	return true;
 }
 
 #ifdef CONFIG_X86_32
@@ -1748,9 +1753,11 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 			move_msr_up(vmx, index, nr_active_uret_msrs++);
 	}
 #endif
-	index = __vmx_find_uret_msr(vmx, MSR_EFER);
-	if (index >= 0 && update_transition_efer(vmx, index))
-		move_msr_up(vmx, index, nr_active_uret_msrs++);
+	if (update_transition_efer(vmx)) {
+		index = __vmx_find_uret_msr(vmx, MSR_EFER);
+		if (index >= 0)
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
+	}
 	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)) {
 		index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
 		if (index >= 0)
-- 
2.26.0

