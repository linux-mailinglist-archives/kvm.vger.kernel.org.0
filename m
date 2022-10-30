Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028DE61287C
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiJ3Gcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiJ3Gb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:31:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB92BBA4;
        Sat, 29 Oct 2022 23:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111102; x=1698647102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EWRhmPnmbBo5KrcXEgUQVLRg+/G51NCswzjBOF3vJSw=;
  b=GpsXxkqwZpIpWWwwbctVN92j9qoUrslSdQMWVGUPUH12b5N1WQkpzwTE
   K09dDw27R6+Tjh3g9ytxDODJxPCQpGOAFXSQTWUswlR2RcgUpLk1SJkDS
   tDvNys9nV7z42d6/ogVA2aQFT6Ul1D4kMxP+TK74b2tSk4GqlqKn3B1Ei
   bZmrjDRxWW4fWVFcwJhoQgducAYUXDoixzUKctxx6EervJtt69ynGGR86
   M3ZbWWN9/QmmhGwp5+h6cGQjnWpSLhPir+uoTarPrT0Wmdx3cX/ygXZrL
   xwtDNC041FnHMYJF6V6JGWu1XpYpt7eB0Fv7XYzxQ+apNCuvEazh3uR2t
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037212"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037212"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:13 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393143"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393143"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 094/108] KVM: TDX: Handle TDX PV CPUID hypercall
Date:   Sat, 29 Oct 2022 23:23:35 -0700
Message-Id: <450f6c2c56c08e0676fd0559876e8413502209ae.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV CPUID hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f6477d577001..4b83d7a81433 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -810,12 +810,34 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	/* EAX and ECX for cpuid is stored in R12 and R13. */
+	eax = tdvmcall_a0_read(vcpu);
+	ecx = tdvmcall_a1_read(vcpu);
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
+
+	tdvmcall_a0_write(vcpu, eax);
+	tdvmcall_a1_write(vcpu, ebx);
+	tdvmcall_a2_write(vcpu, ecx);
+	tdvmcall_a3_write(vcpu, edx);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
 		return tdx_emulate_vmcall(vcpu);
 
 	switch (tdvmcall_leaf(vcpu)) {
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

