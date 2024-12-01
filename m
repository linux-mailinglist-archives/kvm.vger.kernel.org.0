Return-Path: <kvm+bounces-32796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B443A9DF49B
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 746052828D2
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1F114F12F;
	Sun,  1 Dec 2024 03:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YUzSXC8G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706091465A0;
	Sun,  1 Dec 2024 03:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025141; cv=none; b=eZFiB9QR4MTrfLJH+Lj2h4wv9MY95ZKXNrEuJrob3GehIBs6kpmE3kfqQo3hseKfDURuTVBotNmrCqj8TenDlkVtMUMo5COXBI1tYF9I0ZxJfrSKg69sETjjeoLpDP+gPgQ6ulsZUzNJcWSBcruTpgjicwfaism4T0IwtyLAe6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025141; c=relaxed/simple;
	bh=b3wjXe6z8VDuBOGKCupN/4dLqZbbP9sG+mhG8jZ+nlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvp57J08rH8IiV3iHuIfx/5a8lQ4GYj607jhECH0bKJwrF+fFmfkeCy8BM0DriKtRcRPfXHjVRkf0lwb3Jn4zhJDSCBLoOH+3MuV6CxapENbGBHIJqfpsBtTaJR8mhJnQ86E4+nKzhChkOPMmo7+7T6DjJPVQ8WXIYKyEbwWBBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YUzSXC8G; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025139; x=1764561139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b3wjXe6z8VDuBOGKCupN/4dLqZbbP9sG+mhG8jZ+nlM=;
  b=YUzSXC8GbuuuL0ICq9KxT9CJ2eKHLMq+djIdWw/3K7bFhBpnrw6pGrsH
   xpsdVhdWayzJJoXrb5xhgbTEzoWNww59KpjqJ7LWaH1UbM/0hREvv8KxP
   GvIP+ZNmlglnqHplA2/hsnHh8tzp04vGQfrMJxqOy476uw+BE/QaF9HY5
   f8C653pYYCUYZd0h0XcMbTebeomP/LiWBVLJ4rS+Gv/sNGZp/AzrfIbTY
   Z+x23qtJoaG13IrXGCiFQYwDGoPK+GpWqRmPPVn/0k/daCxGewraeww8G
   scQDZYx3rLprwdfWJtwxInagSRrIkX/BASTFHMGJ+7IokWR7g6SgxhJ7g
   w==;
X-CSE-ConnectionGUID: LIjbDL0qRn2b5+0krBSaiQ==
X-CSE-MsgGUID: DWcdMBFDSruU+ZrpBT6lrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725120"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725120"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:19 -0800
X-CSE-ConnectionGUID: loy/5G7mRzajYPf+7efXGA==
X-CSE-MsgGUID: B2Qqfq5HTZe+ajZHINK2dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257518"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:16 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 6/7] KVM: TDX: Handle TDX PV port I/O hypercall
Date: Sun,  1 Dec 2024 11:53:55 +0800
Message-ID: <20241201035358.2193078-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Emulate port I/O requested by TDX guest via TDVMCALL with leaf
Instruction.IO (same value as EXIT_REASON_IO_INSTRUCTION) according to
TDX Guest Host Communication Interface (GHCI).

All port I/O instructions inside the TDX guest trigger the #VE exception.
On #VE triggered by I/O instructions, TDX guest can call TDVMCALL with
leaf Instruction.IO to request VMM to emulate I/O instructions.

Similar to normal port I/O emulation, try to handle the port I/O in kernel
first, if kernel can't support it, forward the request to userspace.

Note string I/O operations are not supported in TDX.  Guest should unroll them
before calling the TDVMCALL.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
Hypercalls exit to userspace breakout:
- Renamed from "KVM: TDX: Handle TDX PV port io hypercall" to
  "KVM: TDX: Handle TDX PV port I/O hypercall".
- Update changelog.
- Add missing curly brackets.
- Move reset of pio.count to tdx_complete_pio_out() and remove the stale
  comment. (binbin)
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
- Set status code to TDVMCALL_STATUS_SUCCESS when PIO is handled in kernel.
- Don't write to R11 when it is a write operation for output.

v18:
- Fix out case to set R10 and R11 correctly when user space handled port
  out.
---
 arch/x86/kvm/vmx/tdx.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a79f9ca962d1..495991407a95 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1141,6 +1141,70 @@ static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pio.count = 0;
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+	return 1;
+}
+
+static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	int ret;
+
+	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
+					 vcpu->arch.pio.port, &val, 1);
+
+	WARN_ON_ONCE(!ret);
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
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
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (write) {
+		val = tdvmcall_a3_read(vcpu);
+		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
+	} else {
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+	}
+
+	if (ret) {
+		if (!write)
+			tdvmcall_set_return_val(vcpu, val);
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+	} else {
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
@@ -1151,6 +1215,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_map_gpa(vcpu);
 	case TDVMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdx_emulate_io(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


