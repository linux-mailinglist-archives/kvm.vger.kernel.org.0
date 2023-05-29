Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE81714315
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbjE2E3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjE2E2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:28:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A12122;
        Sun, 28 May 2023 21:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334299; x=1716870299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fnWz2jqLewwRrJVzywjrPrpxbqQ0Wf8CVCbICu6vj8Q=;
  b=en9h7oCKBBrQ06dkIXxvDDVhTAbiePgID8rceb8In1PocgFcJ3IE2juy
   Fe6pSNNYT0CClfcmf7YkAkQK4sljym8lWnIDPF9yPRwyt1j1nUXwDGOTJ
   zNOj0PcbH93AFqNHhonoPJWdFg+wotAHAfsNu8DAVjowBZypSCtiGR+Qe
   HmPSKe9ubcUKnB0PCA0mvZUNSoo6P7XCY7t1Iw4O4fVqid93uO2OyhXyk
   J+z/rS1axFq551ZaI7Z1Stp8H9Vp5APx3c28u7fi4i6i7+0eYXYxG/uJn
   x10FCHjt7QwNa5GxMAN85ScgaOpVYVmBh2QfhhN+jCmDWXuCS9bOVs5ez
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966158"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966158"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784437"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784437"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:27 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 070/113] KVM: TDX: complete interrupts after tdexit
Date:   Sun, 28 May 2023 21:19:52 -0700
Message-Id: <47f0e5cec0d930ad47f553388f14f25760f968e2.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/vmx/tdx.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 29aa53d530ca..3ca866d671df 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -484,6 +484,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
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
@@ -561,6 +569,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
+	tdx_complete_interrupts(vcpu);
+
 	return EXIT_FASTPATH_NONE;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 6ce362c70e26..5d428d724967 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -200,6 +200,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 
+TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+
 static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
 {
 	struct tdx_module_output out;
-- 
2.25.1

