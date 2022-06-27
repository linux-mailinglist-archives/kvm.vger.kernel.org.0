Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0874155D64A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbiF0V5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241538AbiF0Vzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828CEF5B6;
        Mon, 27 Jun 2022 14:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366903; x=1687902903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ok0044DbrsgcuNJNzGhk84qOYw5k5tS/LDbhV8oGjXY=;
  b=NAnLHUxLIjGqZOX+iy1Wz3s6+eSA/qkys5GzAMqRuT10FEDslMNPsUGT
   /P3kJL0Ds0UcelsL6ViO6AeAo9WYgzo7HvsMX/4l+LUOAFMiZfzUyvfA8
   Zze0e84m8Ck90E8PY0rcCG5H/HSJHUCdM4DOjj8c94CmjTYKj4sByHYuj
   l0kIAyIMcVAv1xGVC1FPwE16TPf0+OrSHRIYlBmrl6CDPMs6Rm7w3FoWZ
   we1oqMm/rXUzdQTsN7MZYloAKJJwwHQ2j9J6syF+bXS/j0GxBVh5hEGAN
   +LFsioUscRXA0DDrIVy60MvwPpNgI+T09l28sc6eKceAovTydphMZ9KOX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116116"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116116"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863675"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v7 073/102] KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched behavior
Date:   Mon, 27 Jun 2022 14:54:05 -0700
Message-Id: <105e8d5126bb9a4bedb4e8668ed04e30861a568f.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm_host.h |  9 +++++++--
 arch/x86/kvm/vmx/tdx.c          |  1 +
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a1d186190287..1f5be98b7630 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -556,8 +556,13 @@ struct kvm_pmu {
 struct kvm_pmu_ops;
 
 enum {
-	KVM_DEBUGREG_BP_ENABLED = 1,
-	KVM_DEBUGREG_WONT_EXIT = 2,
+	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
+	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
+	/*
+	 * Guest debug registers are saved/restored by hardware on exit from
+	 * or enter guest. KVM needn't switch them.
+	 */
+	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
 };
 
 struct kvm_mtrr_range {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4db9bfe2c534..c256853efed5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -545,6 +545,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
+	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
 	vcpu->arch.cr4_guest_owned_bits = -1ul;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce0ef32c2619..39473b561e27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10326,7 +10326,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 
-	if (unlikely(vcpu->arch.switch_db_regs)) {
+	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
@@ -10368,6 +10368,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
 		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
+		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
 		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
@@ -10380,8 +10381,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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

