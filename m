Return-Path: <kvm+bounces-43394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F30A8AFE0
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA8616217A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 05:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB6522D4E6;
	Wed, 16 Apr 2025 05:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AV1eE/J/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC37822B8D7;
	Wed, 16 Apr 2025 05:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744782804; cv=none; b=r6a6zNHwOldDQKMvPyxpdffwNgROfIT7Vn+vrHUYaBiwRj0H5p2DnOXW1D5fnOjsiKxoUMp+hCyvxcGBhXq6Vo2kTdt/2wTqpEgLMaIvADAOWjgDfkxAZ6gRGQiKXNw51iPfMABaOzTvbl+6v7vxXJ0GFv+j4RaY9hNXahZI2V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744782804; c=relaxed/simple;
	bh=ejt+nS1wSG4vWxoe/PG5+T8CTmyW86TLrKcEjqB3uCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fijVkrQGD4KnFLhZ8Ng+zWE8oVD/V+pxMWbVmI6qqUfCt/4craTOTa3gOaUzrRQ1Qa7adlAM/dS3+BS+aD6Coj2nsc3xdONznVT1UW6p8uNMhZmPOdlLuqW1qJWAzLPyJIw+RsusKgNYl5jDFOorTN3P6KHF+mfXLX35Tdv9Spk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AV1eE/J/; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744782803; x=1776318803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ejt+nS1wSG4vWxoe/PG5+T8CTmyW86TLrKcEjqB3uCs=;
  b=AV1eE/J/O4Ulw4M0zlC/CfkEoQNvJ1QINWMC2OtIKtoB58Db7Tg1NGqr
   Q7fUX9HMN8YgSapuplvA3yYjAX9e318O9akkJiqnUArGjQDk2OvKFCfKT
   LeNNac5rsTer6W6+/OWMX0Y8IGYa7X1KlkBrCKBLfEn5eTW+BagfIi9YP
   wpTEFTouQartR+yuOO5RdikU1Fp+HrQdBROZVFelXYTDnphsCuyk9VfK9
   0w0THYoTc6/YdTQmsxyL0VENpxmE32hGx+D8tCPEC9KTQW3TwYlYzdfCE
   mYv6xO7L9DzN8MyQS0tk+QwmuZRIM1+U5a7kQLn8Dz9g+ZEcPkN96GiW/
   Q==;
X-CSE-ConnectionGUID: E6fdQzEMQpWHfHLPn33XHg==
X-CSE-MsgGUID: U4U78e6WQsi50j091u9xpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="45449743"
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="45449743"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 22:53:23 -0700
X-CSE-ConnectionGUID: izGk+V++QI6znKZzvNN9DQ==
X-CSE-MsgGUID: 971l92/lS0y5I68wKU73eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="130874828"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 22:53:19 -0700
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
Subject: [PATCH v2 1/1] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Date: Wed, 16 Apr 2025 13:54:32 +0800
Message-ID: <20250416055433.2980510-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250416055433.2980510-1-binbin.wu@linux.intel.com>
References: <20250416055433.2980510-1-binbin.wu@linux.intel.com>
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

KVM only checks the GPA from the TDX guest has the shared-bit set and drops
the shared-bit before exiting to userspace to avoid bleeding the shared-bit
into KVM's exit ABI.  KVM forwards the request to userspace VMM (e.g. QEMU)
and userspace VMM queues the operation asynchronously.  KVM sets the return
code according to the 'ret' field set by userspace to notify the TDX guest
whether the request has been queued successfully or not.  When the request
has been queued successfully, the TDX guest can poll the status field in
the shared-memory area to check whether the Quote generation is completed
or not.  When completed, the generated Quote is returned via the same
buffer.

Add KVM_EXIT_TDX_GET_QUOTE as a new exit reason to userspace.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Mikko Ylinen <mikko.ylinen@linux.intel.com>
---
v2:
- Skip sanity checks except for the check of the shared-bit. (Rick, Sean)
- Drop the shared-bit of the GPA before exiting to userspace. (Sean)
- Improve the description of 'ret' field in the document. (Kai)
- Use number 40 for KVM_EXIT_TDX_GET_QUOTE. (Xiaoyao, Rick)
- Update the changelog and the description of KVM_EXIT_TDX_GET_QUOTE in the
  document according to the code changes.
---
 Documentation/virt/kvm/api.rst | 25 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c         | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  7 +++++++
 3 files changed, 62 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ad1859f4699e..b2192d2983fe 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7162,6 +7162,31 @@ The valid value for 'flags' is:
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
+TDX guest passes a TD Report. KVM checks the GPA from the TDX guest has the
+shared-bit set and drops the shared-bit in 'gpa' field before exiting to
+userspace. KVM doesn't do other sanity checks. The 'ret' field represents the
+return value of the GetQuote request. KVM only bridges the request to the
+userspace VMM, and the userspace VMM is responsible for setting up the return
+value since only userspace knows whether the request has been queued
+successfully or not. KVM sets the return code according to the 'ret' field
+before returning back to the TDX guest. When the request has been queued
+successfully, the TDX guest can poll the status field in the shared-memory area
+to check whether the Quote generation is completed or not. When completed, the
+generated Quote is returned via the same buffer.
+
 ::
 
 		/* Fix the size of the union. */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..cd1e9a1c040e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1463,6 +1463,34 @@ static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
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
+	/* The gpa of buffer must have shared bit set. */
+	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX_GET_QUOTE;
+	vcpu->run->tdx_get_quote.gpa = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
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
@@ -1472,6 +1500,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_report_fatal_error(vcpu);
 	case TDVMCALL_GET_TD_VM_CALL_INFO:
 		return tdx_get_td_vm_call_info(vcpu);
+	case TDVMCALL_GET_QUOTE:
+		return tdx_get_quote(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c6988e2c68d5..4d7e8e88bcc3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX_GET_QUOTE    40
 
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


