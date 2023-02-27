Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DB16A3D39
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjB0Ib7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjB0I3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:23 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE921CAF9;
        Mon, 27 Feb 2023 00:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486359; x=1709022359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=02E5upieJWsSkdv0u3zu+nn8onJ2BcXYRIZhkNViwvM=;
  b=D1o1mIIUzH+0fbAlsoTK3dKUbB1ZM+jVqqWRm0PvhtbGAFH1MHJC0Hmy
   QxSV6HgCmxOtRuchng7CUccRyuaXtazx+Op5Cx941QW7kT+J20WFSTVtf
   Mf8PsUumPN2+86pqSlRYF3PbCCzdIMrRInMNkV/elDopnflrWNRbx79Qg
   hMaLrOHq1h+rh9t/UkNJbiEVNONGomLUIN70AYRwfS9iWVS2IM6WEaNWM
   UnPg3XFF+dgWfafBRVwtx53r7BXKfS0dNM1w2aqWi9nyj1I43LR7t3LNM
   2/1iijP1Tk1ODY2/EQVWzgzJOarjedmVcNiZ9+qG15GUim32mZs1dNC2Z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609030"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609030"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242377"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242377"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:17 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 082/106] KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
Date:   Mon, 27 Feb 2023 00:23:21 -0800
Message-Id: <1bf33cd9de03976825361bbe27a7ec5440d7910e.1677484918.git.isaku.yamahata@intel.com>
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

The TDX Guest-Host communication interface (GHCI) specification defines
the ABI for the guest TD to issue hypercall.   It reserves vendor specific
arguments for VMM specific use.  Use it as KVM hypercall and handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 553fa5b431bc..7f8431c95b83 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -853,8 +853,39 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+
+	/*
+	 * ABI for KVM tdvmcall argument:
+	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
+	 * Non-zero leaf number (R10 != 0) is defined to indicate
+	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
+	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
+	 * number.
+	 *
+	 * R10: KVM hypercall number
+	 * arguments: R11, R12, R13, R14.
+	 */
+	nr = kvm_r10_read(vcpu);
+	a0 = kvm_r11_read(vcpu);
+	a1 = kvm_r12_read(vcpu);
+	a2 = kvm_r13_read(vcpu);
+	a3 = kvm_r14_read(vcpu);
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true);
+
+	tdvmcall_set_return_code(vcpu, ret);
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
+	if (tdvmcall_exit_type(vcpu))
+		return tdx_emulate_vmcall(vcpu);
+
 	switch (tdvmcall_leaf(vcpu)) {
 	default:
 		break;
-- 
2.25.1

