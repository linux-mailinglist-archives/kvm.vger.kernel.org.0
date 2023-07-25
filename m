Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD976268E
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjGYWYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjGYWXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BA155AE;
        Tue, 25 Jul 2023 15:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323519; x=1721859519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ccMcBcc23AgnL9dY1KKhHHjOC35FCd6UT6pYEdXqS/4=;
  b=VrqdoaG/c9SSRnC1fXnESLE5GSATuKVV3Ia0CW1Cq1h7WxK2brY7FPp6
   BLuoiA8cBYqIef5eSJv29mQjqcR09V9ZHvgfcspM/OGXbvfWYdMIQ3Jk+
   Uc85EXoMAiEE+c5ZMyJW1JozsxYnQ66RwJhr9mwLtYGs9/+trWlQAMjvy
   GENHSCVLPjEl4ZISXniLFtJTVbp5xjyLfc8hMfPDshYkK/rzfEtbOHY4J
   asePxwZ0/EM+QouvyJLMrzEwpHiXEraQJVviKyN36c+xw2j574gI9g/ZP
   oJSKjxHC45qYidBfuPjbDeQ/ovVBlMmRWFqYcTht+lMMHSBIrx6bcQUD8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882723"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882723"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001920"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001920"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 097/115] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
Date:   Tue, 25 Jul 2023 15:14:48 -0700
Message-Id: <a7739962a9623822b12162b330c51a2d63bf5df9.1690322424.git.isaku.yamahata@intel.com>
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

Wire up TDX PV rdmsr/wrmsr hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dc31b052f6a7..98bdcfc06283 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1212,6 +1212,41 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
+{
+	u32 index = tdvmcall_a0_read(vcpu);
+	u64 data;
+
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
+	    kvm_get_msr(vcpu, index, &data)) {
+		trace_kvm_msr_read_ex(index);
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+	trace_kvm_msr_read(index, data);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	tdvmcall_set_return_val(vcpu, data);
+	return 1;
+}
+
+static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
+{
+	u32 index = tdvmcall_a0_read(vcpu);
+	u64 data = tdvmcall_a1_read(vcpu);
+
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE) ||
+	    kvm_set_msr(vcpu, index, data)) {
+		trace_kvm_msr_write_ex(index, data);
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	trace_kvm_msr_write(index, data);
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1226,6 +1261,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_io(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return tdx_emulate_mmio(vcpu);
+	case EXIT_REASON_MSR_READ:
+		return tdx_emulate_rdmsr(vcpu);
+	case EXIT_REASON_MSR_WRITE:
+		return tdx_emulate_wrmsr(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

