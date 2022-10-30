Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4CB612830
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJ3G2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiJ3G1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:27:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383F6286;
        Sat, 29 Oct 2022 23:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111062; x=1698647062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tg3ti5XASbFLYxgQdIxcPquIONUemSJw0hYO8oY7anU=;
  b=OWchnVj3PFC9l32zzftfaHkD4zUXNQN1c1YIN6DfAjWIt0qB26fhLWUF
   h2Jnm5PJGHJQ6Qchv7zuOeopteY3vjLnUIeIqZtftVlSFkc0xPbh2/n9B
   2QZNJj8Y+EcD9phlFvhs5YAhtXLbBy8ycz03j6TLLn2AX6dGeTxHgXuYL
   SeW2hLHLQQuOHP6D6n+g6D38NsKLQ5W8aGeYxBfSNEZ9O6Z+I7LTVBC7U
   gSxs9f9/isjhVpikA3BFr2RVPLpmu2tJ9AFs+PVFdj2v4labePzW9RLcQ
   oz00GT+xOqd7e6p5LUGI13IOY9EaeWGsbFwotddqHiRZu+dcYsjGGx/lk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="288435997"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="288435997"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393168"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393168"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 102/108] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date:   Sat, 29 Oct 2022 23:23:43 -0700
Message-Id: <ac362386d3a589f10e8f8353c89ad3e14522e12d.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 4db552b60271..8e8ac1081ce4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1068,6 +1068,20 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
@@ -1135,6 +1149,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

