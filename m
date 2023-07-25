Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AE4762657
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjGYWVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjGYWUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:20:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70DE49E4;
        Tue, 25 Jul 2023 15:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323432; x=1721859432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=65Yp9gjr+VOS3oG1MmqhhW7LdPrD4JIpNsaIlvC0Zdc=;
  b=ZqqY2xzks87Z7Y1eKYiqzgkXLih9Cg0VTEPql9SXeWJKekfPmn0iWaQA
   zcEuX3SKEzp9hnR6yA0qUDk81mXSN7LOg5Hr0BNSBfl8iQgAi1Bnn8U2n
   QOAuMKNK7phZLJhKAnn0twNiIeVNKVWig4bVwnYqGKn2Qak+xurycZ886
   rxu6uXJ/Nbk4yFWEAdxQHI0yU+saU8M7mXfwNc3IeGfUcRbwFgzYSmkr9
   3GFm0/OQNVPejoXEVS6bIIACbGNERNNqzdF6RDttb8XpzAE0MprrKSLmw
   yE7zQozAcXNvhmMulIN245huOKHGO/Fck65L1KiiW5bfOJy31Br9b00iz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882590"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882590"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001820"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001820"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v15 073/115] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date:   Tue, 25 Jul 2023 15:14:24 -0700
Message-Id: <746afca0a586868d0b5074c462d35df28d818775.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

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
 arch/x86/kvm/vmx/tdx.c          |  1 +
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 95c2ed8fdcd6..42ddf087fe60 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -603,8 +603,14 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
+	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	/*
+	 * Guest debug registers (DR0-3 and DR6) are saved/restored by hardware
+	 * on exit from or enter to guest. KVM needn't switch them. Because DR7
+	 * is cleared on exit from guest, DR7 need to be saved/restored.
+	 */
+	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 259139abb8ba..7465074a919d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -523,6 +523,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
+	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7805987d891d..c7d34b04ccdf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10769,7 +10769,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -10815,6 +10815,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
 		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
@@ -10827,8 +10828,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * care about the messed up debug address registers. But if
 	 * we have some of them active, restore the old state.
 	 */
-	if (hw_breakpoint_active())
-		hw_breakpoint_restore();
+	if (hw_breakpoint_active()) {
+		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
+			hw_breakpoint_restore();
+		else
+			set_debugreg(__this_cpu_read(cpu_dr7), 7);
+	}
 
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-- 
2.25.1

