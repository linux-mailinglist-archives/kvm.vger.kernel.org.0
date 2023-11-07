Return-Path: <kvm+bounces-990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD657E42C2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F80F1C212C3
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DED3987D;
	Tue,  7 Nov 2023 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G6PTnK2a"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDBC37168
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:01 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C08D5BAE;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EPNprmGuFhh/sQO8wdZDHPrOD09e7Q+Ic4/9R8xrsqY=;
  b=G6PTnK2a6ttYIqG/zQ4G9oFLLSOR4Sx8Bjux/bejmlCg4Q+gCnxFDmr6
   3nrlpVBHXluyPRDSDR2ekjvJrHgpEw2eoWm/LdPHkQLwFoPtShHm0e3Wo
   gcz22Z8AyEdkvOxdBBOwSVe7H/L19w9ixG0NK0XU7foqqSiqhtVk4o/un
   6xmiHFOzaLY4yMSco26rGBip3lDCb1JRwF0sWWPGlc8u7xHULdDW3auvQ
   Ke+445jdukPlkTm5M7n81ipJ7TFbWPaArc4pfKejcGxZLxYXMzwzM9Lme
   2gZXIvKFFD6K8anarL2lxEyp0Ui5qzu49dqt/8OSXBIZxfIYD5Fnb+7qE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462588"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462588"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851585"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:24 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 093/116] KVM: TDX: Handle TDX PV port io hypercall
Date: Tue,  7 Nov 2023 06:56:59 -0800
Message-Id: <d8b438b6be78b4dbeea5c2a0ecaddfc06bfea43c.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV port IO hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4e48989d364f..d4b09255ad32 100644
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


