Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EBD275F60
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgIWSES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:16537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgIWSEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:15 -0400
IronPort-SDR: D3MvUxlGpKqITjjr/UZ8Hyvk7IGmvCJL5T1S1UXfobB8YhC8TkmnHmp4EUpi9k9xjZWVfO4ouj
 Y/o2XG4AVohg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148637135"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148637135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:12 -0700
IronPort-SDR: hn2IhBsiqZ6/ve4Vl08uJ9UaLC5XSC3y3IqSlpCx6+yKTe8VkZb14A9Cd2eO7X6CZzXWty8y74
 uz1AUnBc02ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670285"
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
Subject: [PATCH v2 08/15] KVM: VMX: Rename "__find_msr_index" to "__vmx_find_uret_msr"
Date:   Wed, 23 Sep 2020 11:04:02 -0700
Message-Id: <20200923180409.32255-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 4da4fc65d459..ca41ee8fac5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -623,7 +623,7 @@ static inline bool report_flexpriority(void)
 	return flexpriority_enabled;
 }
 
-static inline int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
+static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
@@ -637,7 +637,7 @@ struct vmx_uret_msr *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	i = __find_msr_index(vmx, msr);
+	i = __vmx_find_uret_msr(vmx, msr);
 	if (i >= 0)
 		return &vmx->guest_uret_msrs[i];
 	return NULL;
@@ -1708,24 +1708,24 @@ static void setup_msrs(struct vcpu_vmx *vmx)
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
2.28.0

