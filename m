Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEEC6B69B9
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjCLSGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjCLSFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBCE515CC;
        Sun, 12 Mar 2023 11:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644058; x=1710180058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oNQQUbOhAH5GQzpF02E7uJXnri4Bs5jC3Z/Jc1Uusu0=;
  b=nkJLFOWaPi/hDBnghRdFJ33FOvPNKJdZ0LjorLPeDrgde26hk9BxIJuq
   WVpmZrEPeb+Jc4y7/4nI1wUxkEvwm0IbwoZOTNR4XGA17ag7BkPsTKL0D
   +dDZGehmQCR8NFc8NeLHxCHmApZNql4f4Cwr7S8u8PjncJSGDUsRhtGeA
   oNS0uFqdUHIn/SzXKm4+eFxXINdhjZnLvmBFy+5W8JBdElgt7RWvfhL9t
   JRY2Atsdre3KxEdl9D8qgDiriw93Gc8DOIoVSsmo7U2E438Ic+ddry7oW
   y2ZgiEPmi0mnW1jXIQWWkg9F0vjAWJ2bRPtv5MAU4PrF+aBC1PDFgIVeG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660086"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660086"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596818"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596818"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:15 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 096/113] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
Date:   Sun, 12 Mar 2023 10:57:00 -0700
Message-Id: <4af2532d69a9367799661bafe882b656633a2b74.1678643052.git.isaku.yamahata@intel.com>
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

Wire up TDX PV rdmsr/wrmsr hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bb86b850889b..25332290c268 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1181,6 +1181,41 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
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
@@ -1195,6 +1230,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

