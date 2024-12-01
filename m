Return-Path: <kvm+bounces-32792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 660269DF493
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A29516311E
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EEB70835;
	Sun,  1 Dec 2024 03:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqbevA0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDE5DF42;
	Sun,  1 Dec 2024 03:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025126; cv=none; b=qoFmQ14xc0LYloO8+CgRCZbF54629R1R7oBM9fRieAzEsNuKr0tc9DS1THzvLpXrfUQ8qt2i0cQ+zD+TPUNbxnbJNh5QsP2sJJmjJivnczwWXNC3XZMEiUUOweQr3+h4PdDiN/dI/wODNhRoJSynQbCuxphCQ9mRw99Dw9OVE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025126; c=relaxed/simple;
	bh=tYJ6iEY5/6H5eegsNo+KnyVIV+yMoWZ7KNPYBExv3AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF8CSxNqYTJjPPECWmfuvKPpIGAlktZ+T9Xno2u1e8nHnFfbgEmzvxBJXhewb7m+a1RYOWinOiYXWDnWkaE5BVTvmkhUpEdp+/o9h+RBiB82zd1jFqtNxGlrMqCV2fhJp2JiTaZUf1aRO9qXWnO9yZSo7IYOb/eKNEChSuFmdrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqbevA0Q; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025125; x=1764561125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tYJ6iEY5/6H5eegsNo+KnyVIV+yMoWZ7KNPYBExv3AM=;
  b=UqbevA0QPby00DdUp2VBWCAqAgWIzlyH0peOotQq0l2/c9BeOH3psDap
   war5wdkgxWpIH1Rblbb6iiI8cW43JUmmAeWIehfYhp4sVu4cU1VG45xu7
   f/aZKbDJBBf0KPXhKT4V/CclShAsU892ro67m6f1/NKraw0eXwMXrSciE
   NanajWUlWDMsmNCW/9cc/G78zvqWcW9U0NOrZCDWgl166NULzFzsUQ2BL
   71Jn5C9SUqQu2mBa4yiO+p9gXoAPZzIdqk76YG78tuBAP2oktiGLF8qXx
   7LehZ2WKuWE0oxuqNBw26HCu3dePkv2JhSwWYyFmnOLy6b9KDwhE4mhGW
   A==;
X-CSE-ConnectionGUID: 9lgVy8jcQUax/aWTguDM6Q==
X-CSE-MsgGUID: uaNBXAzIQF+LXJHIi6TYoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725101"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725101"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:04 -0800
X-CSE-ConnectionGUID: AMJl2am2TKCBjTdRM1IBkg==
X-CSE-MsgGUID: 0QDAGGB7TgaTmgBjAamxkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257485"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:01 -0800
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
Subject: [PATCH 2/7] KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)
Date: Sun,  1 Dec 2024 11:53:51 +0800
Message-ID: <20241201035358.2193078-3-binbin.wu@linux.intel.com>
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

Add a place holder and related helper functions for preparation of
TDG.VP.VMCALL handling.

The TDX module specification defines TDG.VP.VMCALL API (TDVMCALL for short)
for the guest TD to call hypercall to VMM.  When the guest TD issues a
TDVMCALL, the guest TD exits to VMM with a new exit reason.  The arguments
from the guest TD and returned values from the VMM are passed in the guest
registers.  The guest RCX register indicates which registers are used.
Define helper functions to access those registers.

A new VMX exit reason TDCALL is added to indicate the exit is due to TDVMCALL
from the guest TD.  Define the TDCALL exit reason and add a place holder to
handle such exit.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace breakout:
- Update changelog.
- Drop the unused tdx->tdvmcall. (Chao)
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)
---
 arch/x86/include/uapi/asm/vmx.h |  4 ++-
 arch/x86/kvm/vmx/tdx.c          | 48 +++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index a5faf6d88f1b..6a9f268a2d2c 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -92,6 +92,7 @@
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
 #define EXIT_REASON_NOTIFY              75
+#define EXIT_REASON_TDCALL              77
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -155,7 +156,8 @@
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
 	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
-	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
+	{ EXIT_REASON_NOTIFY,                "NOTIFY" }, \
+	{ EXIT_REASON_TDCALL,                "TDCALL" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3dcbdb5a7bf8..19fd8a5dabd0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -234,6 +234,41 @@ static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
 	return kvm_r9_read(vcpu);
 }
 
+#define BUILD_TDVMCALL_ACCESSORS(param, gpr)				\
+static __always_inline							\
+unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)		\
+{									\
+	return kvm_##gpr##_read(vcpu);					\
+}									\
+static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu, \
+						     unsigned long val)  \
+{									\
+	kvm_##gpr##_write(vcpu, val);					\
+}
+BUILD_TDVMCALL_ACCESSORS(a0, r12);
+BUILD_TDVMCALL_ACCESSORS(a1, r13);
+BUILD_TDVMCALL_ACCESSORS(a2, r14);
+BUILD_TDVMCALL_ACCESSORS(a3, r15);
+
+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
+{
+	return kvm_r10_read(vcpu);
+}
+static __always_inline unsigned long tdvmcall_leaf(struct kvm_vcpu *vcpu)
+{
+	return kvm_r11_read(vcpu);
+}
+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
+						     long val)
+{
+	kvm_r10_write(vcpu, val);
+}
+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
+						    unsigned long val)
+{
+	kvm_r11_write(vcpu, val);
+}
+
 static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
@@ -922,6 +957,17 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_tdvmcall(struct kvm_vcpu *vcpu)
+{
+	switch (tdvmcall_leaf(vcpu)) {
+	default:
+		break;
+	}
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	return 1;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	u64 shared_bit = (pgd_level == 5) ? TDX_SHARED_BIT_PWL_5 :
@@ -1253,6 +1299,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	exit_reason = tdexit_exit_reason(vcpu);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_TDCALL:
+		return handle_tdvmcall(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


