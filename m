Return-Path: <kvm+bounces-23896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED37994F9D5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C0372825CB
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089AE19B3D3;
	Mon, 12 Aug 2024 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aH/d8Nv1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A819A291;
	Mon, 12 Aug 2024 22:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502913; cv=none; b=SzZ8lJSfXLZQZSNYegrf6Oohab+yIivdlGd9HfLxjg1TcMcIK4jZKd5AWdPf3cGNbHqO0T2Uike4hzxfTwQ39dk13JGBh2zgxdDMYN+LKXfxDqvxBU76iF5DkxQiuXjYqMGnwKLtJMxv30S16FCkxOy58KC+chXNAA0BMl4Qa+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502913; c=relaxed/simple;
	bh=HapUNVoQDT6ekuC8wHs7cr8duUHphe9+reyMXgpmruA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tLjndkP1UL13/K/eK8pDt8Khog5m+5hQRASCs8Kpx5JZ+mycUGvFaJlhKZ3mfh9EBoQbov2bFMeR9CjdilUK6pu+S+B/L2jEeWYfqSmnGUQ+9H3UGNcSZT/ErFtqVW16+zYunOKGlMA+FiDu9dGfvCJtmB6tmOXIuX0mmFGmMo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aH/d8Nv1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502911; x=1755038911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HapUNVoQDT6ekuC8wHs7cr8duUHphe9+reyMXgpmruA=;
  b=aH/d8Nv1a69/TjSIKzL/1wfyctYqVLAFlsozjyMoRX+JXiIQ0xjqCETM
   VCHU6iMY6GGBRVx0UtZPEi2xvoZY7k1tKLYpY/48hkLT3Kc05T8zzcn25
   tykJTWPPYWZS7qiyWwF9wVtOJ2BnX8M1noP6ZyEdjRA5ReGRjEhOVfsrV
   lUcCKda34dkNoUdTgETWR/Vt8y46G654fc0ihn9Kq87/EDSY+3Q4Ej3ZV
   gt+7X3SqvJzqhrItAFa+Bgb38TnfQP619Iq4+xLdoO9mklj8FIqrFsTg/
   HWe7vUH7GgGxc3cesWEzlr5l/Gy4AaN/MLnP1UhelraRERDSRPn/hZ7TN
   A==;
X-CSE-ConnectionGUID: 43LzXiSQTbOnm5fpKeRd6A==
X-CSE-MsgGUID: 87o8BpusReuXa7LNTg9/GQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041325"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041325"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:26 -0700
X-CSE-ConnectionGUID: UcIuhQ/ITguTCCZowqT3Gw==
X-CSE-MsgGUID: g+TDSVwgSpuxKe9vToTPTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008333"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:26 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 01/25] KVM: TDX: Add placeholders for TDX VM/vCPU structures
Date: Mon, 12 Aug 2024 15:47:56 -0700
Message-Id: <20240812224820.34826-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
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
index d1f821539910..21fae631c775 100644
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
+	 * Undate vt_x86_ops::vm_size here so it is ready before
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
@@ -159,7 +192,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
@@ -176,6 +209,7 @@ module_exit(vt_exit);
 
 static int __init vt_init(void)
 {
+	unsigned vcpu_size, vcpu_align;
 	int r;
 
 	r = vmx_init();
@@ -185,12 +219,25 @@ static int __init vt_init(void)
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
index 99f579329de9..dbcc1ed80efa 100644
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
2.34.1


