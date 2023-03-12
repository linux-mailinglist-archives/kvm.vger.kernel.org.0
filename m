Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095756B69C5
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjCLSG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjCLSFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC26515D2;
        Sun, 12 Mar 2023 11:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644066; x=1710180066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZeL5f4tujGKGIY1QCsDr0rFWgQyYSgAkIh+FoL39n4c=;
  b=Gwk3/7nym6n7D03dyrhQY/9gvuLKi1ENadLfV+uKQYU+N3OkBfvl/f7c
   cnFNfFkK46abMhdNlBKT2H0xYK5bzTzbRLAwOjCj/A5Ga7mgWJXejLz6Z
   vxTJH7vV2XIX9vh7nzHGCmNzelm1yVf/8vGCTzyWnwD8UOxvxxVKi6q/X
   FrFM7U/yAwvd0gSLgF84dsz3gCyz8lWWPVqvesB0fkT6YxzgubDVrKWqp
   HjP7/c6+Z6kE4gbuEo36wmDNDKhLZQisIoOEq8zm1TR+ba8kxqqjOzO+/
   eNKNyj8/kvg2MVw8fUAkw/XAdz2bNpFLL64wY9UMZjdkG+2n/wsvqeg+3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660115"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660115"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596845"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596845"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:16 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 103/113] KVM: TDX: Add methods to ignore guest instruction emulation
Date:   Sun, 12 Mar 2023 10:57:07 -0700
Message-Id: <50b95161cb5e63965a830d6a2727a3ce3a5b7f7c.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 07dfbf9a8b23..59fa63146c8d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -332,6 +332,30 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
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
@@ -940,7 +964,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-	.check_intercept = vmx_check_intercept,
+	.check_intercept = vt_check_intercept,
 	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
@@ -969,7 +993,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_smi_window = vt_enable_smi_window,
 #endif
 
-	.can_emulate_instruction = vmx_can_emulate_instruction,
+	.can_emulate_instruction = vt_can_emulate_instruction,
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-- 
2.25.1

