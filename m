Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EA47CAF9B
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbjJPQgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbjJPQff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:35:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748CC4C19;
        Mon, 16 Oct 2023 09:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473265; x=1729009265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZkDrmhHprfLg9OVvz2l5tMQiZhG3zk7CJS4j8C0RO8E=;
  b=Qa4QmndUi3+J5+/BjfVoF11yuMnIGj7W0ni8xGdmCwvgj1ojWIVUyaj3
   adYxInVD+47diFl/yBnmSlRKieziyFJBFBbDukFSfFmtWbHqk+GsxK8Hf
   a1VDsR9f+G0QIZHGsXJNgE1f8e/WEODaslQ29LuGx/kYvwqkVUag0w8z9
   4EHqFMRlREWL77BiFXO/plAWIj/Bmf0li6nNo9dEyWOBWSsrlfaAyYRIV
   trJRpQHmNjY76if3mU5HrtRSS4k6iMt6VEZ1poenT635ynm6D09jXXR1a
   L39lKeS6KYmxdET7Er+FKPTHEWWKfGdiuHQZ+1/1XYZuFo3jXpiyNL1Id
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922055"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922055"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448310"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448310"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:05 -0700
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
Subject: [PATCH v16 093/116] KVM: TDX: Handle TDX PV port io hypercall
Date:   Mon, 16 Oct 2023 09:14:45 -0700
Message-Id: <1c3db2c798e25f6a144314785600fd07a4b0bf4e.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 2f8bb0e9394e..fd6907d5ba9d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1140,6 +1140,61 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
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
@@ -1150,6 +1205,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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

