Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BE245D1AA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353141AbhKYAYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352892AbhKYAYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649707"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649707"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:12 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042203"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:12 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [RFC PATCH v3 27/59] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date:   Wed, 24 Nov 2021 16:20:10 -0800
Message-Id: <28dd5933479012c6b4551d5502b51fbdac328de5.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
irrespective of any other flags.  TDX-SEAM unconditionally saves and
restores guest DRs and reset to architectural INIT state on TD exit.
So, KVM needs to save host DRs before TD enter without restoring guest DRs
and restore host DRs after TD exit.

Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().

Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++--
 arch/x86/kvm/x86.c              |  3 ++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc5417f94ec..a2bc4d9caaef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -526,8 +526,14 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
+	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	KVM_DEBUGREG_RELOAD		= BIT(2),
+	/*
+	 * Guest debug registers are saved/restored by hardware on exit from
+	 * or enter guest. KVM needn't switch them.
+	 */
+	KVM_DEBUGREG_AUTO_SWITCH	= BIT(3),
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88b55ddb22a7..8161475082a7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9910,7 +9910,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -9950,6 +9950,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
 		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
-- 
2.25.1

