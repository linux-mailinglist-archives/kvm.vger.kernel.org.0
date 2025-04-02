Return-Path: <kvm+bounces-42421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2140A78579
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BB107A48C1
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0011946C;
	Wed,  2 Apr 2025 00:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MP04YOaj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF973139D;
	Wed,  2 Apr 2025 00:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743552883; cv=none; b=pattspKOzWNWpFc0Teyudktfm9Lo0rlrnxfkSpGqvlCOkXTmeu3ifBMkMwvQpsf188f2rL5yqAP9tk0yxcjRqamQgUWBWd9/8iUh8+J4HjPUtOZV+GilNfW+Lc5LWf1ohDCagKx8aExCISQa+L4FZE5ysbgprf/6ihIZeRUrLzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743552883; c=relaxed/simple;
	bh=p+4FVlWEFQn53CfRn7gmeoZY7Bhc62fqghSpPI1bH1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qada3t0JE3GnpEbRJZUh6LrjWY0YGK3QZmjqW9QYuS96+pO/2AhRdYmx0F0V9bplCNa3++6Gf9DWB6Fui2FVAtVx36P4BRMvCSm89TkKN6pZ6rXj01eK620AUYt3wc6GCO3lj0+tXnao0pdcF0zRcR2IALNk9uHOIY/G4OfsNH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MP04YOaj; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743552881; x=1775088881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p+4FVlWEFQn53CfRn7gmeoZY7Bhc62fqghSpPI1bH1Y=;
  b=MP04YOajbT/HfPXgJTsva1xFRNQL1Wf2QjMTRJ1YD+o6hLLXvC4vb20v
   qIqrZuFhjcpDTSl9/knSiPLou46mI8eN7kBOvtA9spmCJa/mkuWhOIX0X
   s5vpfzEvFupt074L1tnyp8StFS9/xHgr8UKZr8jkhjSFJXNavaHOZweDu
   HwSfXnrtYlAs9YkOq7GuiVxUQjcHzBMOpalxbalLp8CBSjnW3rdaQnkOh
   6Ti9QUmX1rLv03/YcGbCkhKYyCW14nrhG1C+YpfsURaGxbxibphhnXORE
   sSuAmsJyMaN74lS4uHTG1Oq3gUJOSLUt9+gaegfti0cupOGg+jq8qr9dA
   A==;
X-CSE-ConnectionGUID: ap3wMS+ORFWFtohbmXa2BA==
X-CSE-MsgGUID: NacCOcVCRtufCAs3AsaZoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="44148830"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="44148830"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:40 -0700
X-CSE-ConnectionGUID: 6bIMjO6ZRDK8g2UDLwiy9g==
X-CSE-MsgGUID: UnPrJeJBS+WU0pS877SmrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="131673941"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:14:37 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	mikko.ylinen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Date: Wed,  2 Apr 2025 08:15:56 +0800
Message-ID: <20250402001557.173586-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250402001557.173586-1-binbin.wu@linux.intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Handle TDVMCALL for GetQuote to generate a TD-Quote.

GetQuote is a doorbell-like interface used by TDX guests to request VMM
to generate a TD-Quote signed by a service hosting TD-Quoting Enclave
operating on the host.  A TDX guest passes a TD Report (TDREPORT_STRUCT) in
a shared-memory area as parameter.  Host VMM can access it and queue the
operation for a service hosting TD-Quoting enclave.  When completed, the
Quote is returned via the same shared-memory area.

KVM forwards the request to userspace VMM (e.g., QEMU) and userspace VMM
queues the operation asynchronously.  After the TDVMCALL is returned and
back to TDX guest, TDX guest can poll the status field of the shared-memory
area.

Add KVM_EXIT_TDX_GET_QUOTE as a new exit reason to userspace and forward
the request after some sanity checks.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Mikko Ylinen <mikko.ylinen@linux.intel.com>
---
 Documentation/virt/kvm/api.rst | 19 ++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c         | 35 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  7 +++++++
 3 files changed, 61 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b61371f45e78..90aa7a328dc8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7162,6 +7162,25 @@ The valid value for 'flags' is:
   - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
     in VMCS. It would run into unknown result if resume the target VM.
 
+::
+
+		/* KVM_EXIT_TDX_GET_QUOTE */
+		struct tdx_get_quote {
+			__u64 ret;
+			__u64 gpa;
+			__u64 size;
+		};
+
+If the exit reason is KVM_EXIT_TDX_GET_QUOTE, then it indicates that a TDX
+guest has requested to generate a TD-Quote signed by a service hosting
+TD-Quoting Enclave operating on the host. The 'gpa' field and 'size' specify
+the guest physical address and size of a shared-memory buffer, in which the
+TDX guest passes a TD report. When completed, the generated quote is returned
+via the same buffer. The 'ret' field represents the return value. The userspace
+should update the return value before resuming the vCPU according to TDX GHCI
+spec. It's an asynchronous request. After the TDVMCALL is returned and back to
+TDX guest, TDX guest can poll the status field of the shared-memory area.
+
 ::
 
 		/* Fix the size of the union. */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..535200446c21 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1463,6 +1463,39 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_get_quote(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, vcpu->run->tdx_get_quote.ret);
+	return 1;
+}
+
+static int tdx_get_quote(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	u64 gpa = tdx->vp_enter_args.r12;
+	u64 size = tdx->vp_enter_args.r13;
+
+	/* The buffer must be shared memory. */
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) || size == 0) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_ALIGN_ERROR);
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX_GET_QUOTE;
+	vcpu->run->tdx_get_quote.gpa = gpa;
+	vcpu->run->tdx_get_quote.size = size;
+
+	vcpu->arch.complete_userspace_io = tdx_complete_get_quote;
+
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1472,6 +1505,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_report_fatal_error(vcpu);
 	case TDVMCALL_GET_TD_VM_CALL_INFO:
 		return tdx_get_td_vm_call_info(vcpu);
+	case TDVMCALL_GET_QUOTE:
+		return tdx_get_quote(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c6988e2c68d5..eca86b7f0cbc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX_GET_QUOTE    41
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -447,6 +448,12 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX_GET_QUOTE */
+		struct {
+			__u64 ret;
+			__u64 gpa;
+			__u64 size;
+		} tdx_get_quote;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.46.0


