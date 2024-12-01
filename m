Return-Path: <kvm+bounces-32795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E3E9DF498
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 529BFB21FF4
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650DF482EB;
	Sun,  1 Dec 2024 03:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hv/RO5kv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66F4207F;
	Sun,  1 Dec 2024 03:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025137; cv=none; b=GG1tWzBZmI81q23F3VGmTW7J6WNyleIhXBYZ/HeIpKwtDMj0iIDw69Q/VFebFV4nhH1Y1omB+dCd1yckkZ/WZvomhJNmSmMmkQerMAv8neADS5C7+MX01RT74WDIK5yM21h7Strv/cpuVq4zLUfCh+jh2Q5vSUDcJTYGnEYb6Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025137; c=relaxed/simple;
	bh=4S8FG+ypR0Ue5mxpFrXQ+K7j574sBZ4M9ovBehlBhdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT5wC+Vz3XqHq0lKrwfnU0h7WB9vlSDKHdo7dR4+6AULEoUIWaIYUOSg5WTLOIACsLgncGKQLMuS9SAyFHIJtQjWr+FW82rEVa7d/bWZVPo2P8ms+4AqAho3yimzf4KQmKv2te8zSlzuZed3CqnevYUwPkW8C8nZWlJ2Wk1acr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hv/RO5kv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025135; x=1764561135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4S8FG+ypR0Ue5mxpFrXQ+K7j574sBZ4M9ovBehlBhdY=;
  b=hv/RO5kvn15+2vODfyggu2N+bF8CMdYpO4/UBRy6o/QPvVu1ydJ+AiGJ
   0tjyz618miUeO60iQkBS+8ae0wdWmurxFlNTLxw0/uvsnnx6vdpWos56M
   N8dTuqmHYUVUsCQXhsqCGNEhXCl5OXdhWvxaVg3GsMXopc7rM6MAdzdhr
   TpQxhPUP0/A4A22Xm6tb8PjznCKniVtB9kKhlacdh20LBJaJ2iA4qiTAQ
   jNHgoEG08b0+BirPiMw06827VAIyK0c9zOzBqg8la3RJf/XtTElHyx39B
   pGJBekNzlLIfGDdwlNfwvLQNABXYQwSqNhN5vKYIfjWjfTQEbpBmc8wos
   A==;
X-CSE-ConnectionGUID: N8ZoiI1SSZeNkFeKmVCJ3g==
X-CSE-MsgGUID: m9HUiSVVQ2m0fDEIt0xjog==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725115"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725115"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:15 -0800
X-CSE-ConnectionGUID: aQKE0rxWQGOtlw2ZxwcAGg==
X-CSE-MsgGUID: DAWP3CAcQSW/lKIjVfoffg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257502"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:12 -0800
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
Subject: [PATCH 5/7] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
Date: Sun,  1 Dec 2024 11:53:54 +0800
Message-ID: <20241201035358.2193078-6-binbin.wu@linux.intel.com>
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

Convert TDG.VP.VMCALL<ReportFatalError> to KVM_EXIT_SYSTEM_EVENT with
a new type KVM_SYSTEM_EVENT_TDX_FATAL and forward it to userspace for
handling.

TD guest can use TDG.VP.VMCALL<ReportFatalError> to report the fatal
error it has experienced.  This hypercall is special because TD guest
is requesting a termination with the error information, KVM needs to
forward the hypercall to userspace anyway, KVM doesn't do sanity checks
and let userspace decide what to do.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace breakout:
- New added.
  Implement one of the hypercalls need to exit to userspace for handling after
  reverting "KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL", which tries to resolve
  Sean's comment.
  https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 Documentation/virt/kvm/api.rst |  8 ++++++
 arch/x86/kvm/vmx/tdx.c         | 50 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 59 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index edc070c6e19b..bb39da72c647 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6815,6 +6815,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_WAKEUP         4
   #define KVM_SYSTEM_EVENT_SUSPEND        5
   #define KVM_SYSTEM_EVENT_SEV_TERM       6
+  #define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
                         __u32 ndata;
                         __u64 data[16];
@@ -6841,6 +6842,13 @@ Valid values for 'type' are:
    reset/shutdown of the VM.
  - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
    The guest physical address of the guest's GHCB is stored in `data[0]`.
+ - KVM_SYSTEM_EVENT_TDX_FATAL -- an TDX guest requested termination.
+   The error codes of the guest's GHCI is stored in `data[0]`.
+   If the bit 63 of `data[0]` is set, it indicates there is TD specified
+   additional information provided in a page, which is shared memory. The
+   guest physical address of the information page is stored in `data[1]`.
+   An optional error message is provided by `data[2]` ~ `data[9]`, which is
+   byte sequence, LSB filled first. Typically, ASCII code(0x20-0x7e) is filled.
  - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
    KVM has recognized a wakeup event. Userspace may honor this event by
    marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 553f4cbe0693..a79f9ca962d1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1093,6 +1093,54 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
+{
+	u64 reg_mask = kvm_rcx_read(vcpu);
+	u64* opt_regs;
+
+	/*
+	 * Skip sanity checks and let userspace decide what to do if sanity
+	 * checks fail.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX_FATAL;
+	vcpu->run->system_event.ndata = 10;
+	/* Error codes. */
+	vcpu->run->system_event.data[0] = tdvmcall_a0_read(vcpu);
+	/* GPA of additional information page. */
+	vcpu->run->system_event.data[1] = tdvmcall_a1_read(vcpu);
+	/* Information passed via registers (up to 64 bytes). */
+	opt_regs = &vcpu->run->system_event.data[2];
+
+#define COPY_REG(REG, MASK)						\
+	do {								\
+		if (reg_mask & MASK)					\
+			*opt_regs = kvm_ ## REG ## _read(vcpu);		\
+		else							\
+			*opt_regs = 0;					\
+		opt_regs++;						\
+	} while (0)
+
+	/* The order is defined in GHCI. */
+	COPY_REG(r14, BIT_ULL(14));
+	COPY_REG(r15, BIT_ULL(15));
+	COPY_REG(rbx, BIT_ULL(3));
+	COPY_REG(rdi, BIT_ULL(7));
+	COPY_REG(rsi, BIT_ULL(6));
+	COPY_REG(r8, BIT_ULL(8));
+	COPY_REG(r9, BIT_ULL(9));
+	COPY_REG(rdx, BIT_ULL(2));
+
+	/*
+	 * Set the status code according to GHCI spec, although the vCPU may
+	 * not return back to guest.
+	 */
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+
+	/* Forward request to userspace. */
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1101,6 +1149,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case TDVMCALL_MAP_GPA:
 		return tdx_map_gpa(vcpu);
+	case TDVMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..c173c8dfcf83 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -375,6 +375,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.46.0


