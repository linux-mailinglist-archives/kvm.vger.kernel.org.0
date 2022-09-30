Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DF55F0913
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiI3K1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiI3KZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:25:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A134303E4;
        Fri, 30 Sep 2022 03:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533200; x=1696069200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lqtsfa9QSpgZx+LEDtJSZlEH4s57QdJiMhJe7CAgFSg=;
  b=XcDbQYKzqHAZ269X5UzQ9sWrZutjqOVYaDX/mFR7SlwCBAS9TntoiPAQ
   trKnBuEglvxzXo/k5H7LWFn5MVEsyOhR27qqmL5gPlx1DTUYZ4V0bTxHE
   MbyCG0HHNW/t9pSH8B3SKrx+uBB1x7Zwv8x2r09fvuHQBfo1DJxk1Aphw
   TsOvOgp8PdY0SKHLw9jUAJ1e++CzBSmsmdFPrQ9mWkA/Dbrpmkn2EsiR9
   Y6RBtet39dMW2JZl+IckARZ7pn6e4GaBWk57doNCI6jg60Pg9LAM/mCrh
   pcwztVlhneiNk/Btu87q0jdyFcDHyWzgdUqnT4mx74Q8/nGf/BbRJIW78
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540181"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540181"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807836"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807836"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 099/105] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date:   Fri, 30 Sep 2022 03:18:33 -0700
Message-Id: <ada57a7cdb75a0fddd1d35cc62ad80233059c329.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement TDG.VP.VMCALL<GetTdVmCallInfo> hypercall.  If the input value is
zero, return success code and zero in output registers.

TDG.VP.VMCALL<GetTdVmCallInfo> hypercall is a subleaf of TDG.VP.VMCALL to
enumerate which TDG.VP.VMCALL sub leaves are supported.  This hypercall is
for future enhancement of the Guest-Host-Communication Interface (GHCI)
specification.  The GHCI version of 344426-001US defines it to require
input R12 to be zero and to return zero in output registers, R11, R12, R13,
and R14 so that guest TD enumerates no enhancement.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6318c0c09c0d..e5337fb24e82 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1060,6 +1060,20 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
+{
+	if (tdvmcall_a0_read(vcpu))
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+	else {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+		kvm_r11_write(vcpu, 0);
+		tdvmcall_a0_write(vcpu, 0);
+		tdvmcall_a1_write(vcpu, 0);
+		tdvmcall_a2_write(vcpu, 0);
+	}
+	return 1;
+}
+
 static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -1127,6 +1141,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_GET_TD_VM_CALL_INFO:
+		return tdx_get_td_vm_call_info(vcpu);
 	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
 	case TDG_VP_VMCALL_MAP_GPA:
-- 
2.25.1

