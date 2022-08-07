Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D0B58BDB0
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbiHGWJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241922AbiHGWHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE0BC95;
        Sun,  7 Aug 2022 15:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909804; x=1691445804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yaD3PvxIxKOnDWjz/hWKnKRcGz9zJ8gFng/fJPcKbfc=;
  b=bMCIvRWpzG5PVL01r0Iy5SlcvRcvxTMnRKzw3Wtfb0MTNpAmlEFvRs//
   hVlfSLnVhlN436+K6xoxQ+bg8NX6jLO65yUnGaGswrGDHvApMh4e36u6n
   VJyNRlr+Cw5azcMBcAILFIU6kaNbu63t7ATPRg1HFTr88TKcWiCwqzoV4
   IhQsiCwq6Jf57G0q5c+rMD7YMNzqWCkkGrxHSLEoqwKPc38tPuY1QGekX
   zLxXEXL+/gLN/UWOdnlMGlnpVXv7NA3P4B7zSdrdPvBP/4BMN+NDKMNVW
   9Umz3cHL7gbzhGj+ylM9nxJttDjeqD+s4mpw8IKZ7CSSg1tyXWcje19Sc
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224173"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224173"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682676"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:39 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 070/103] KVM: TDX: complete interrupts after tdexit
Date:   Sun,  7 Aug 2022 15:01:55 -0700
Message-Id: <ca3c6f55e36df176c39798360ac28e57ec8a1da9.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This corresponds to VMX __vmx_complete_interrupts().  Because TDX
virtualize vAPIC, KVM only needs to care NMI injection.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0aa52bf1c281..2c5fda9e213e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -580,6 +580,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
+{
+	/* Avoid costly SEAMCALL if no nmi was injected */
+	if (vcpu->arch.nmi_injected)
+		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
+							      TD_VCPU_PEND_NMI);
+}
+
 struct tdx_uret_msr {
 	u32 msr;
 	unsigned int slot;
@@ -648,6 +656,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
+	tdx_complete_interrupts(vcpu);
+
 	return EXIT_FASTPATH_NONE;
 }
 
-- 
2.25.1

