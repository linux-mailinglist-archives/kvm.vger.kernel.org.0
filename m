Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3878E4CDD86
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiCDT7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8512325E3;
        Fri,  4 Mar 2022 11:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423445; x=1677959445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ekR0I15xgmA0Cz5BhJ6W6Iq8JErAl1vPeK4d4L8pkK4=;
  b=Zum0t4QKwRbK7k5qoCulkV4TxE0upTpOgOamH0VLhStrQ6f1sl+E/yPZ
   mO0wrapP4K69WGrNPg5JmfKPySPn+BLIaM5IpFipPSrDOb+Es3gTO9bCD
   7tBsB9LXWBP3oY5ig9dH3uOaeqrEJCrJAYdX9ug3HQ9o2sWMqMqkJ1bBn
   103luav3T71ndaqagXiPs/PK7mWuLdP/sGg/RHCO21ye9pyBwK3NBM/gq
   0FsitxDWVCQkRdXskm4R8Yt4vqYV+p7AP1y4P7S39VmMICbm+sQ7yHQiq
   8xBgF1fcpqUxH1uAoNAbDn4sbfUbyQMAkRg3a12hB256OQaZpKrSK1XNZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779657"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779657"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344565"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:44 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 093/104] KVM: TDX: Handle TDX PV port io hypercall
Date:   Fri,  4 Mar 2022 11:49:49 -0800
Message-Id: <a3c8c71d6d02896754632cf741c38efb60978215.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV port IO hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b0dcc2421649..c900347d0bc7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -959,6 +959,59 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
 	return kvm_emulate_halt_noskip(vcpu);
 }
 
+static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	int ret;
+
+	WARN_ON(vcpu->arch.pio.count != 1);
+
+	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
+					 vcpu->arch.pio.port, &val, 1);
+	WARN_ON(!ret);
+
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	tdvmcall_set_return_val(vcpu, val);
+
+	return 1;
+}
+
+static int tdx_emulate_io(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	unsigned int port;
+	int size, ret;
+
+	++vcpu->stat.io_exits;
+
+	size = tdvmcall_p1_read(vcpu);
+	port = tdvmcall_p3_read(vcpu);
+
+	if (size != 1 && size != 2 && size != 4) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (!tdvmcall_p2_read(vcpu)) {
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+		if (!ret)
+			vcpu->arch.complete_userspace_io = tdx_complete_pio_in;
+		else
+			tdvmcall_set_return_val(vcpu, val);
+	} else {
+		val = tdvmcall_p4_read(vcpu);
+		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
+
+		/* No need for a complete_userspace_io callback. */
+		vcpu->arch.pio.count = 0;
+	}
+	if (ret)
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	return ret;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -974,6 +1027,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_cpuid(vcpu);
 	case EXIT_REASON_HLT:
 		return tdx_emulate_hlt(vcpu);
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdx_emulate_io(vcpu);
 	default:
 		break;
 	}
-- 
2.25.1

