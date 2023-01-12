Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA9667AF1
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbjALQhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjALQhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:11 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D06B1D5;
        Thu, 12 Jan 2023 08:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541214; x=1705077214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MPWl4F7wroh7Y9p+NdgHiJYHNEUl+NXfnFsRhRHUtb8=;
  b=fBJmsYhtXoZ3eJvqzK5zNgu4HOyrmnFZ3ywDfiJ03iVUK9cni4XH6Nm3
   P//DCfQWmACDZagd/5gBzjsAsltEJRv6yKfWIUGJXUwL69KDURYfjKG0y
   xXvBtvk//JoCAKacvl4aCpeGjgQpTVO0sjAM16l2XjS0xErzIji8zJA+/
   px7J5Y+30n6rnvP7KDkteXI5bccvfV0aG05imh/RaisK3LWDS5zRY4t92
   7YErXGV3ocpqbLAFo+f+XhDr+F/QRXDkP7cPbhH5tDhbMddDjJeVqqlmf
   tgDnna9AVMKgrcRZi1TxXX00hcVzUDVgPHGPKNFmpBermyq2oXRlr+I4p
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089615"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089615"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372469"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372469"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:32 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 071/113] KVM: TDX: complete interrupts after tdexit
Date:   Thu, 12 Jan 2023 08:32:19 -0800
Message-Id: <c6fd6347f9d3bab267386e02ed3c9d7e907ccd20.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4bd651b31172..40546e692222 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -461,6 +461,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -529,6 +537,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
+	tdx_complete_interrupts(vcpu);
+
 	return EXIT_FASTPATH_NONE;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 63916388fdcf..e97cb19a7a50 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -192,6 +192,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 
+TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+
 static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
 {
 	struct tdx_module_output out;
-- 
2.25.1

