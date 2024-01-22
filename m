Return-Path: <kvm+bounces-6671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 360CF83785A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9D5A1F23F7B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F4477631;
	Mon, 22 Jan 2024 23:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWvZdbVG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093BA6DD1C;
	Mon, 22 Jan 2024 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967764; cv=none; b=QQFX33nNkp/Iyvaid3eE8AnUFZeI4yYtNiMgaI38NtticTyCu4yUBYoxRPuHB6GnPq3B4nZrIZucIR4bhkS8fxBMYNlU/5SPIgbLyHoa4DY6OLF/P6DRM/Ue3SzK9EYQynViRr4w0F+PY9btT1dh/afq41LYpP+oJdcLKU8hlLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967764; c=relaxed/simple;
	bh=7mL7xnz9vwulESCO11rlmOjEDuZMNOvUZdFeDQ4Cjk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sM2CtkCHwWlsnN42p8lUEDHq0iSiY7q2A3lh18FxMOmRcl5nfWgiHJjiUTg+eJMjcbUA90U7Lv25B8RoBvS9x4GYV6ctntuRhEG2GfD7wOmZzBUV0Tf5VtnqoAxAVVUc3Yyk5aYsFasAHCLvoLBnzbKeN2gXJeiU07bB+hD0tjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWvZdbVG; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967762; x=1737503762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7mL7xnz9vwulESCO11rlmOjEDuZMNOvUZdFeDQ4Cjk0=;
  b=QWvZdbVGFYb6mNtnHPWR/EbXqxhj44tXAPuC6Gm0I3DVZB9YybfiwuRq
   KfsuEUfQpe0qmmwvh7GxF5uAidRe00/X9eh3ks547WsX+cL1b/LcNAVfu
   K4WZa/eu1efYayiqXPh4ib04bkQ6CbrVmUa7LonPlFFaRkFIiojILWww7
   xJvKK+1h856nhodlBbMXBz43l3vUxb2bLaIVusqzOuTiTMCse6hSeQ+nT
   Z2n7RqA7XPVXGRfpkVkq2CxpsaV9XF3twhOaPhmSQkAYRdqz7XNf95VqN
   7BHl9XlRpJO7YrcQOM2d3ERmtXU+JpS5lQPKVgKIAsgnm+JIRQsj0xRIy
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217863"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217863"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817980"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:51 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 098/121] KVM: TDX: Handle TDX PV port io hypercall
Date: Mon, 22 Jan 2024 15:54:14 -0800
Message-Id: <06a142259ea1d80ae54161e18e8d4983d4d11210.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
v18:
- Fix out case to set R10 and R11 correctly when user space handled port
  out.
---
 arch/x86/kvm/vmx/tdx.c | 67 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4628c7eb3002..71c444cfbc9e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1202,6 +1202,71 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
 	return kvm_emulate_halt_noskip(vcpu);
 }
 
+static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
+	tdvmcall_set_return_val(vcpu, 0);
+	return 1;
+}
+
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
+	} else
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+
+	if (ret)
+		tdvmcall_set_return_val(vcpu, val);
+	else {
+		if (write)
+			vcpu->arch.complete_userspace_io = tdx_complete_pio_out;
+		else
+			vcpu->arch.complete_userspace_io = tdx_complete_pio_in;
+	}
+
+	return ret;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1212,6 +1277,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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


