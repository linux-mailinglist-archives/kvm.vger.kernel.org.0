Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CA4667B27
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbjALQj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbjALQh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CEC12A92;
        Thu, 12 Jan 2023 08:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541227; x=1705077227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8sgh5LVThyz19ct5D24wjqu+zfNYK4knhiAU3u6blFI=;
  b=PLwLx6Cu1IlEBYKRvaWOe32lrX5zcYsjll7oiKBTLOVU8SRSQrrlz3Mr
   24DnrssAfSRHWLdVVnnSnhP7292joNuaguKfhfB2NEZjRN+XelcnVu2LW
   71Ce9N8wdPTateZLM/yz6+4P9Y7erxPHsErg3usDFWtx6QCDsGHEn+oQ8
   1kaCCW2fvAHJepvVsp7GXzBPkMOaGsV2MQb8aCUdAQrXT0e/r9ZgjD0b+
   3C7JnPIWcK/vZWHpYatgkWytav285Ubm6XP0HOV9Xg+r4aam+LWHZS77q
   wCRUqUdS6BzBHK6Aihi4dOfv5SxXFXzvewLP714FUsM8SkSgw2+WoAYvQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089770"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089770"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372589"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372589"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 100/113] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date:   Thu, 12 Jan 2023 08:32:48 -0800
Message-Id: <e0d459ed29e549fa7534a2d07a12b691eaac5a65.1673539699.git.isaku.yamahata@intel.com>
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
index 486d0f0c6dd1..2f3206551c48 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1181,6 +1181,20 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
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
 static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1250,6 +1264,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDG_VP_VMCALL_GET_TD_VM_CALL_INFO:
+		return tdx_get_td_vm_call_info(vcpu);
 	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
 		/*
 		 * Exit to userspace device model for tear down.
-- 
2.25.1

