Return-Path: <kvm+bounces-38739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCC1A3E1DF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CF747A48A7
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD20216381;
	Thu, 20 Feb 2025 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdZiZrxS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33152153CD
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071193; cv=none; b=tDTaeZSSlcFBYwLUzb0YrWM3Tab+XTQ3E1kXA+W7NAdtr9MtlkTsl1AXDBjE5iUEdeLlddmTXWmrfBjJknzL4yPuKC9Xn38KUFDFc3c8XA+V7/N5w6ihdOFmh53Odnjf1LFQUDUA86A71JAb2hzMscmO2LuFsBcZ5AGyfM4MOBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071193; c=relaxed/simple;
	bh=39q2NNpf7SneAFLKlSbxcFeKHe+A1MhvK9SOsd/CvlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufr/lZLpT7KWWmhWH+8TB9qQccY48ObSDRzsddO64u8maeThUVtpAAKPQgb7laZfBMklPTjz2o4b7Df5PupetyvadfUFdk4OLZa6IwczrqJ2HuY090OQkEWUD7v0MI0pYDkLzNy6mnk8kNm3plWGHTD4l3Pa4qbYIfllu3mOwg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdZiZrxS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwyfFAMMWaAGgPHYwrleuHn9hlLr32V8u+eWlGmJlJo=;
	b=BdZiZrxSsr8tpehVN3eLEU4TamRmWrTItqNRkbilTsDXElfEV7QcjDiSknizOyWThRtvNg
	FTsKNln87nvzcKUhKdRcH/Ft0u+7aPKdYvs42n1F7oVoVvwdQbqg2mSKC+MHaJUIVmptRe
	l6ERXPibVGdmCUAbIWmrlomsIYUZ9+M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-tBvkLz3DOAaRMmToqhm9HQ-1; Thu,
 20 Feb 2025 12:06:29 -0500
X-MC-Unique: tBvkLz3DOAaRMmToqhm9HQ-1
X-Mimecast-MFC-AGG-ID: tBvkLz3DOAaRMmToqhm9HQ_1740071187
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5B9A1903080;
	Thu, 20 Feb 2025 17:06:27 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CDF8A1800D9D;
	Thu, 20 Feb 2025 17:06:26 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 14/30] KVM: TDX: Add placeholders for TDX VM/vCPU structures
Date: Thu, 20 Feb 2025 12:05:48 -0500
Message-ID: <20250220170604.2279312-15-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 - Make to_kvm_tdx() and to_tdx() private to tdx.c (Francesco, Tony)
 - Add pragma poison for to_vmx() (Paolo)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 53 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c  | 14 ++++++++++-
 arch/x86/kvm/vmx/tdx.h  | 37 ++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 97c453187cc1..5c1acc88feef 100644
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
@@ -163,7 +196,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
@@ -180,6 +213,7 @@ module_exit(vt_exit);
 
 static int __init vt_init(void)
 {
+	unsigned vcpu_size, vcpu_align;
 	int r;
 
 	r = vmx_init();
@@ -191,12 +225,25 @@ static int __init vt_init(void)
 	if (r)
 		goto err_tdx_bringup;
 
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
index 761d3a9cd5c5..a830e9c42bf2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,16 +5,28 @@
 #include "capabilities.h"
 #include "tdx.h"
 
+#pragma GCC poison to_vmx
+
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-static bool enable_tdx __ro_after_init;
+bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
 static enum cpuhp_state tdx_cpuhp_state;
 
 static const struct tdx_sys_info *tdx_sysinfo;
 
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
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8aee938a968f..fc013c8816f1 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -5,9 +5,46 @@
 #ifdef CONFIG_INTEL_TDX_HOST
 int tdx_bringup(void);
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
 #else
 static inline int tdx_bringup(void) { return 0; }
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
+
 #endif
 
 #endif
-- 
2.43.5



