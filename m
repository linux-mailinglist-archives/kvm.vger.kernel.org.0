Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D1B6A3D29
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjB0Ibl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjB0IaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:30:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6978C20D16;
        Mon, 27 Feb 2023 00:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486416; x=1709022416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3sz94AYFj+sDvvgjnAkjoG1G/WHdPHxZoFLnSh7r8a4=;
  b=CzlEy41afW+EPrItFljDwXTh8VEPh4hinPDxoDsVqMtouYPQQcI9m6/V
   1EDklLuA7APrWepxwmT4V8PXGDiYHdbPjZnei/JDyrK0Tz0Jf2dCCA+fY
   AbJqeT1QFwZ3RwuwarJeSlLAkSK7JO5TZd1gE0zWx3LovLwYGKaPoxTRe
   HSEQNjs4eWvSkLc96DL3se5mAn8+kNxQ8jboEGIF+rftGYZi7gg+yv0CG
   mjpu65Be2KqOeWaVJzshddvCmMiCzFB5gwA1KhKjr6+5rrFb7epE1eSLe
   oXpolAXk3dmz5u3vs5qlsmElAE5FjvgVE+LsteHCUoP5/cMcrSjB8oCep
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609090"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609090"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242432"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242432"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:20 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 096/106] KVM: TDX: Add methods to ignore guest instruction emulation
Date:   Mon, 27 Feb 2023 00:23:35 -0800
Message-Id: <bfe5d985783e63031ad354251c36b9fc7b953a3a.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX protects TDX guest state from VMM, instructions in guest memory
cannot be emulated.  Implement methods to ignore guest instruction
emulator.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4296e1e729b7..d15056666311 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -310,6 +310,30 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static bool vt_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+				       void *insn, int insn_len)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return vmx_can_emulate_instruction(vcpu, emul_type, insn, insn_len);
+}
+
+static int vt_check_intercept(struct kvm_vcpu *vcpu,
+				 struct x86_instruction_info *info,
+				 enum x86_intercept_stage stage,
+				 struct x86_exception *exception)
+{
+	/*
+	 * This call back is triggered by the x86 instruction emulator. TDX
+	 * doesn't allow guest memory inspection.
+	 */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return X86EMUL_UNHANDLEABLE;
+
+	return vmx_check_intercept(vcpu, info, stage, exception);
+}
+
 static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -918,7 +942,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-	.check_intercept = vmx_check_intercept,
+	.check_intercept = vt_check_intercept,
 	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
@@ -947,7 +971,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_smi_window = vt_enable_smi_window,
 #endif
 
-	.can_emulate_instruction = vmx_can_emulate_instruction,
+	.can_emulate_instruction = vt_can_emulate_instruction,
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-- 
2.25.1

