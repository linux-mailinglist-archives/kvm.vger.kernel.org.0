Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F2667B37
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240462AbjALQjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjALQh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681AFC74B;
        Thu, 12 Jan 2023 08:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541226; x=1705077226;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VkEtMXOs1uY9rmNV2MPiIbRwiuHxp5oFXsKNHFcu5OI=;
  b=hqpdr1gWyyBoMdL04Zp5uaLXuZ5KOwANCSTw/xOFqOBRaj34VyCpB65u
   SzA44CO/KYemcAnUQvI5MPOQoNIBu4rXYtwoysKkjIGuZLYwM/eSA2Axu
   1KPEApr4ti4o7Voirqf/M+uQkN2mOGUjEnBLGQr+nn6o+lBcSsHC0nT0i
   T/EUCH+9noqMLZqN249+Q/Xa6gk59Oii87A1irMhgjjq2u5hbgc0uOsPj
   gX89dPHEouBO65MH/cB/sFCo2hAHMN1UzZG4x0Et2krDfdbojXriINCEY
   uQda2B1c47130f+VN5wHa143lRBKzUq59gdbl9uvQVzjK9ae4qvmpkmTU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089756"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089756"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372579"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372579"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:36 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 097/113] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
Date:   Thu, 12 Jan 2023 08:32:45 -0800
Message-Id: <e059d36cb674275b66746769a7079f1a50d77070.1673539699.git.isaku.yamahata@intel.com>
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

Wire up TDX PV rdmsr/wrmsr hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5d8894899055..5dc7dae55c57 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1146,6 +1146,41 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
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
@@ -1160,6 +1195,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

