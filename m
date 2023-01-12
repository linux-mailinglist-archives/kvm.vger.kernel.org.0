Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF59667B1C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240130AbjALQjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjALQhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:25 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498FFDEB1;
        Thu, 12 Jan 2023 08:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541225; x=1705077225;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UP1WpdheYeJvVdvirp+Vpfoecm7bqXd9sD8L7PqyirY=;
  b=YLScHOjSc7C6dMAQixuafQnIpGh0tWRqaIGj7ITxlpWqljJ4AXtA+yxF
   MmU69M/ZrTvVSu2lOt2ihb1YAOdAx1STwmxxkXMRhdHMF2SD559jXoqd5
   ySdJsp4qodzgRu/WCJw0KaiEyrRjo7m2sknOnw1UaIsfOdYa1LkeOoXja
   HFh9z52BWsmfXiFZNJV3jrMuhJqN0+d+lfT/4Yl+1+C806pcRANMX6jHe
   H+4Sc+Od5DrTg3aGIY1DhK7Sf4n0dTGBf3ay/ifFpgtBPDycJ+Iy2vZrw
   Dwx93t93CRRO9CxeG3YTGNITzkhzRc0Jpu5hYuklSPhAU66Bw5qUv1xiJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089734"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089734"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372565"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372565"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:36 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 094/113] KVM: TDX: Handle TDX PV port io hypercall
Date:   Thu, 12 Jan 2023 08:32:42 -0800
Message-Id: <97ba08e8c45eec34d9b283f4a5f8de3767397422.1673539699.git.isaku.yamahata@intel.com>
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

Wire up TDX PV port IO hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3dcfbdd37579..88318a80e6de 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -979,6 +979,61 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
 	return kvm_emulate_halt_noskip(vcpu);
 }
 
+static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	int ret;
+
+	WARN_ON_ONCE(vcpu->arch.pio.count != 1);
+
+	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
+					 vcpu->arch.pio.port, &val, 1);
+	WARN_ON_ONCE(!ret);
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
+	bool write;
+
+	++vcpu->stat.io_exits;
+
+	size = tdvmcall_a0_read(vcpu);
+	write = tdvmcall_a1_read(vcpu);
+	port = tdvmcall_a2_read(vcpu);
+
+	if (size != 1 && size != 2 && size != 4) {
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (write) {
+		val = tdvmcall_a3_read(vcpu);
+		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
+
+		/* No need for a complete_userspace_io callback. */
+		vcpu->arch.pio.count = 0;
+	} else {
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+		if (!ret)
+			vcpu->arch.complete_userspace_io = tdx_complete_pio_in;
+		else
+			tdvmcall_set_return_val(vcpu, val);
+	}
+	if (ret)
+		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	return ret;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -989,6 +1044,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

