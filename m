Return-Path: <kvm+bounces-30089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E29519B6CA0
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C641B23A83
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D37A21A4B2;
	Wed, 30 Oct 2024 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXvHha86"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D889D1D12ED;
	Wed, 30 Oct 2024 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314869; cv=none; b=JDW3vuddDsW9hfPjqkf1yvRNLRk3SqOXze3cHSGDmRxqm9F560Sf0iOGL97JZHh5US8sIzcz2BEjPNqmwMh/TTBJwDSFcRAamDIJw2Iy3iBldpSvznu8afEn8DiXa4GqOJIs1aNJA7oS7dWElkY35nHAbDfjx1AERN35br/jbzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314869; c=relaxed/simple;
	bh=m++ly584oN13pAwPwRJbz1ZBL5ddHyfpuukLAk6SSdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDQ7FxQh6NQpHslC0EEdgkCYQBSp+vMYZJJfuJuRmKQDMCHCviaDc0kHRUkyA5gLQbs8aSrGki8Fc4OgchEw9rlNwrBBjfDoD4LML3eFpheZHBX85Iz0JTX2pBGmzfkcNyblXQnDMUIvYim58Q15zoJ2mf6f32JqbW2BR9nejLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hXvHha86; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314867; x=1761850867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m++ly584oN13pAwPwRJbz1ZBL5ddHyfpuukLAk6SSdY=;
  b=hXvHha86cTyfqTmznqSXL/qHsBqY2ZIvZegmIyUumWGg1YUXKlKCmL/y
   hU3EfQ9wT1pGxa2eZFJv3nLVamYbX/ZBiV/gAk0ByMzxh9vHrBgBCbaY1
   zQey/uLXtvwX2f8eEVX+rtWVbB8Nfkh0NbWfUPqIMO9nb4qafnP3ZyQAr
   Iyau9q/qgLUTc3bKT7hhna6Eo46P//LkpO5qZ1YEnyvNKMi0kERZARXf9
   RxwQBUJHiY97mYDZxc94f1MLkPdozb6fLfhf2bcqzFBDSz103GvbP966s
   y8IqulBnPMsY+csiQ90pzKadGNFoqN5Q6MAByh7ZNIu7fXMk9aCVFl4nh
   A==;
X-CSE-ConnectionGUID: CyDMbqk5RryCLZhUNpJoxw==
X-CSE-MsgGUID: NKQzmycIR223nXrxItlTPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678772"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678772"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:01 -0700
X-CSE-ConnectionGUID: 3u2dExyDT1yrk7PU0vcPDg==
X-CSE-MsgGUID: 7dH3aA+NRuCOesXmhBVSgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499381"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:00 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 11/25] KVM: TDX: Add placeholders for TDX VM/vCPU structures
Date: Wed, 30 Oct 2024 12:00:24 -0700
Message-ID: <20241030190039.77971-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add TDX's own VM and vCPU structures as placeholder to manage and run
TDX guests.  Also add helper functions to check whether a VM/vCPU is
TDX or normal VMX one, and add helpers to convert between TDX VM/vCPU
and KVM VM/vCPU.

TDX protects guest VMs from malicious host.  Unlike VMX guests, TDX
guests are crypto-protected.  KVM cannot access TDX guests' memory and
vCPU states directly.  Instead, TDX requires KVM to use a set of TDX
architecture-defined firmware APIs (a.k.a TDX module SEAMCALLs) to
manage and run TDX guests.

In fact, the way to manage and run TDX guests and normal VMX guests are
quite different.  Because of that, the current structures
('struct kvm_vmx' and 'struct vcpu_vmx') to manage VMX guests are not
quite suitable for TDX guests.  E.g., the majority of the members of
'struct vcpu_vmx' don't apply to TDX guests.

Introduce TDX's own VM and vCPU structures ('struct kvm_tdx' and 'struct
vcpu_tdx' respectively) for KVM to manage and run TDX guests.  And
instead of building TDX's VM and vCPU structures based on VMX's, build
them directly based on 'struct kvm'.

As a result, TDX and VMX guests will have different VM size and vCPU
size/alignment.

Currently, kvm_arch_alloc_vm() uses 'kvm_x86_ops::vm_size' to allocate
enough space for the VM structure when creating guest.  With TDX guests,
ideally, KVM should allocate the VM structure based on the VM type so
that the precise size can be allocated for VMX and TDX guests.  But this
requires more extensive code change.  For now, simply choose the maximum
size of 'struct kvm_tdx' and 'struct kvm_vmx' for VM structure
allocation for both VMX and TDX guests.  This would result in small
memory waste for each VM which has smaller VM structure size but this is
acceptable.

For simplicity, use the same way for vCPU allocation too.  Otherwise KVM
would need to maintain a separate 'kvm_vcpu_cache' for each VM type.

Note, updating the 'vt_x86_ops::vm_size' needs to be done before calling
kvm_ops_update(), which copies vt_x86_ops to kvm_x86_ops.  However this
happens before TDX module initialization.  Therefore theoretically it is
possible that 'kvm_x86_ops::vm_size' is set to size of 'struct kvm_tdx'
(when it's larger) but TDX actually fails to initialize at a later time.

Again the worst case of this is wasting couple of bytes memory for each
VM.  KVM could choose to update 'kvm_x86_ops::vm_size' at a later time
depending on TDX's status but that would require base KVM module to
export either kvm_x86_ops or kvm_ops_update().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Correct typo for update (Tony)

uAPI breakout v1:
 - Re-add __always_inline to to_kvm_tdx(), to_tdx(). (Sean)
 - Fix bisectability issues in headers (Kai)
 - Add a comment around updating vt_x86_ops.vm_size.
 - Update the comment around updating vcpu_size/align:
   https://lore.kernel.org/kvm/25d2bf93854ae7410d82119227be3cb2ce47c4f2.camel@intel.com/
 - Refine changelog:
   https://lore.kernel.org/kvm/9c592801471a137c51f583065764fbfc3081c016.camel@intel.com/

v19:
 - correctly update ops.vm_size, vcpu_size and, vcpu_align by Xiaoyao

v14 -> v15:
 - use KVM_X86_TDX_VM
---
 arch/x86/kvm/vmx/main.c | 53 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c  |  2 +-
 arch/x86/kvm/vmx/tdx.h  | 49 +++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 053294939eb1..245f7d1f1bd4 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -8,6 +8,39 @@
 #include "posted_intr.h"
 #include "tdx.h"
 
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = vmx_hardware_setup();
+	if (ret)
+		return ret;
+
+	/*
+	 * Update vt_x86_ops::vm_size here so it is ready before
+	 * kvm_ops_update() is called in kvm_x86_vendor_init().
+	 *
+	 * Note, the actual bringing up of TDX must be done after
+	 * kvm_ops_update() because enabling TDX requires enabling
+	 * hardware virtualization first, i.e., all online CPUs must
+	 * be in post-VMXON state.  This means the @vm_size here
+	 * may be updated to TDX's size but TDX may fail to enable
+	 * at later time.
+	 *
+	 * The VMX/VT code could update kvm_x86_ops::vm_size again
+	 * after bringing up TDX, but this would require exporting
+	 * either kvm_x86_ops or kvm_ops_update() from the base KVM
+	 * module, which looks overkill.  Anyway, the worst case here
+	 * is KVM may allocate couple of more bytes than needed for
+	 * each VM.
+	 */
+	if (enable_tdx)
+		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
+				sizeof(struct kvm_tdx));
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -161,7 +194,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
@@ -178,6 +211,7 @@ module_exit(vt_exit);
 
 static int __init vt_init(void)
 {
+	unsigned vcpu_size, vcpu_align;
 	int r;
 
 	r = vmx_init();
@@ -187,12 +221,25 @@ static int __init vt_init(void)
 	/* tdx_init() has been taken */
 	tdx_bringup();
 
+	/*
+	 * TDX and VMX have different vCPU structures.  Calculate the
+	 * maximum size/align so that kvm_init() can use the larger
+	 * values to create the kmem_vcpu_cache.
+	 */
+	vcpu_size = sizeof(struct vcpu_vmx);
+	vcpu_align = __alignof__(struct vcpu_vmx);
+	if (enable_tdx) {
+		vcpu_size = max_t(unsigned, vcpu_size,
+				sizeof(struct vcpu_tdx));
+		vcpu_align = max_t(unsigned, vcpu_align,
+				__alignof__(struct vcpu_tdx));
+	}
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
 	 */
-	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
-		     THIS_MODULE);
+	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f95a4dbcaf4a..f2830ff2af1d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,7 +7,7 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-static bool enable_tdx __ro_after_init;
+bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
 static enum cpuhp_state tdx_cpuhp_state;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 766a6121f670..e6a232d58e6a 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -4,9 +4,58 @@
 #ifdef CONFIG_INTEL_TDX_HOST
 void tdx_bringup(void);
 void tdx_cleanup(void);
+
+extern bool enable_tdx;
+
+struct kvm_tdx {
+	struct kvm kvm;
+	/* TDX specific members follow. */
+};
+
+struct vcpu_tdx {
+	struct kvm_vcpu	vcpu;
+	/* TDX specific members follow. */
+};
+
+static inline bool is_td(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
+{
+	return is_td(vcpu->kvm);
+}
+
+static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
+{
+	return container_of(kvm, struct kvm_tdx, kvm);
+}
+
+static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
+{
+	return container_of(vcpu, struct vcpu_tdx, vcpu);
+}
+
 #else
 static inline void tdx_bringup(void) {}
 static inline void tdx_cleanup(void) {}
+
+#define enable_tdx	0
+
+struct kvm_tdx {
+	struct kvm kvm;
+};
+
+struct vcpu_tdx {
+	struct kvm_vcpu	vcpu;
+};
+
+static inline bool is_td(struct kvm *kvm) { return false; }
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
+static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
+
 #endif
 
 #endif
-- 
2.47.0


