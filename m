Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F002C2B4FB6
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgKPSbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:31:47 -0500
Received: from mga06.intel.com ([134.134.136.31]:20636 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388104AbgKPS2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:07 -0500
IronPort-SDR: LyT4YNPKVF3BeXDaQa1ur2noX03aG+tv/L+Ztl3hWzZriUvbcQ6vMhQZne43mxFACzDKxdjZOW
 LFbldh9G5SLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410039"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410039"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:06 -0800
IronPort-SDR: ASwCFKCLy4OB4+gf56DduJlNArpGMnds+U8gtJMjxBGFNEsyjNPUrk1yfQiQe2DK7ACyGhmNp8
 k1mX1KP5X9Iw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528033"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:05 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 29/67] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date:   Mon, 16 Nov 2020 10:26:14 -0800
Message-Id: <df78c741300046037935c0f7ae763e302e66f639.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag, KVM_DEBUGREG_AUTO_SWITCHED, to skip saving/restoring DRs
irrespective of any other flags.  TDX-SEAM unconditionally saves and
restores host DRs, ergo there is nothing to do.

Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++---
 arch/x86/kvm/x86.c              | 6 ++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6c89666ec49..815469875445 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -464,9 +464,10 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
-	KVM_DEBUGREG_RELOAD = 4,
+	KVM_DEBUGREG_BP_ENABLED 	= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	KVM_DEBUGREG_RELOAD		= BIT(2),
+	KVM_DEBUGREG_AUTO_SWITCHED	= BIT(3),
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42bd24ba7fdd..098888edc3ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9009,7 +9009,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCHED)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -9029,6 +9029,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCHED);
 		kvm_x86_ops.sync_dirty_debug_regs(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
@@ -9042,7 +9043,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * care about the messed up debug address registers. But if
 	 * we have some of them active, restore the old state.
 	 */
-	if (hw_breakpoint_active())
+	if (hw_breakpoint_active() &&
+	    !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCHED))
 		hw_breakpoint_restore();
 
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
-- 
2.17.1

