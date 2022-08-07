Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155BA58BDC3
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbiHGWJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241927AbiHGWHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE91BCAA;
        Sun,  7 Aug 2022 15:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909806; x=1691445806;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KjjdkEbtaTHZidy0zddkmh0o0n7UOg1kw17gRohVf1w=;
  b=R3jhY7S/hGBhNuEW/EhHC1mHxi+RsEmOWbUdJPulUsEO7daPAP099DwG
   ucc1jyodCHJ/Ik+UOdDwLAlyVev2nVzyC4+L3lZEN5XV9aVALFx7qA2+6
   YpwT7meUTeucTjJqHbwUjzvE/ztjmx+Qwy9U2nfEgysov3S8HNCBHFLSj
   lfN+euFiYZRa5cdkFVdcWl+8i/ohLHmvEQAvUcGZSXBWd+WOLb7GRlqMJ
   E5Gq2o77d7lhxQCTPwBs53ZTJkN8GuzjW0Pg26yvQM7wEplR6jdrbar2K
   2k8WMRlUevdm2EbLsAM4THk1KQ9FE2NxaqQ91IlOnAxfaLy6yJkgX4loY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240412"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240412"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682758"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:44 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 095/103] KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall
Date:   Sun,  7 Aug 2022 15:02:20 -0700
Message-Id: <ce183d47a93012c46472b32077e80dc8b56c88ed.1659854791.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 341c29385544..fdd0609bd01b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1157,6 +1157,41 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
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
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ) ||
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
@@ -1171,6 +1206,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

