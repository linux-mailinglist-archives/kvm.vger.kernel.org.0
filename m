Return-Path: <kvm+bounces-38748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B33CA3E231
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 298953B5772
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54892221D82;
	Thu, 20 Feb 2025 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RXCtUbyd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFDC21D5A9
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071208; cv=none; b=sDPno6IYRetdp/WTlXssaO5NxpYtijAF0MeCmRDHQjPjzeGIPMf8djatgGEsiBv82UexZ0A+tWL9LFMHO8M3mrhqcsmkymFh0vFraNl+lQoei8Jv6Xbe5ZqySQ6k8poQF2T6xNDlqBc9TiIemkNScFcPrKKnK0OROxfcchJTTHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071208; c=relaxed/simple;
	bh=3bbbPtfHcGDQsrY8sxyTOgmbyvMh9I+RviSMH3t2ZAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOHzAFHWTw4LOKmIdTYfjNtxzcE6R14xkoGNBvViSZEPE3ofGTOxuwEsM0mzZ+s5H8ZHZLfCkJ4O/f3kWTkE6DMjQ2btiixSGwmeR/mv6QEcA2BVOHO68VV5cZ6qSpZYR6zuDtP1BncceKkSHZNdyPyBwWsTGpipqXJVulV7o6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RXCtUbyd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeZoBHdL9jkJ4w73bjz9IXMkss9N9nVKm83Iytboi+M=;
	b=RXCtUbydOt86+dV0U3rEg/9PcWS6OnOskBm4NY42unzEgWycClBcve8hno8HR9idzQipFS
	P28qI+rOqJFil4HZp4texF/yrJCfduz8D7cVGduKQn0pH5G5Pf8LL/GExtrwawoBlDYNWz
	2fjbXx3172V1La4rqYyeILVV/osQR7U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-zkq8OD_XPyy2kF7vSkgrAg-1; Thu,
 20 Feb 2025 12:06:35 -0500
X-MC-Unique: zkq8OD_XPyy2kF7vSkgrAg-1
X-Mimecast-MFC-AGG-ID: zkq8OD_XPyy2kF7vSkgrAg_1740071193
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6CC7180087A;
	Thu, 20 Feb 2025 17:06:33 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 942691800359;
	Thu, 20 Feb 2025 17:06:32 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>
Subject: [PATCH 18/30] KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
Date: Thu, 20 Feb 2025 12:05:52 -0500
Message-ID: <20250220170604.2279312-19-pbonzini@redhat.com>
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

KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
guest state-protected VM.  It defined subcommands for technology-specific
operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
are not limited to memory encryption, but various technology-specific
operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
for TDX specific operations and define subcommands.

Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
TDX specific sub-commands will be added to retrieve/pass TDX specific
parameters.  Make mem_enc_ioctl non-optional as it's always filled.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 - Drop the misleading "defined for consistency" line. It's a copy-paste
   error introduced in the earlier patches. Earlier there was padding at
   the end to match struct kvm_sev_cmd size. (Tony)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/uapi/asm/kvm.h    | 23 +++++++++++++++++++++
 arch/x86/kvm/vmx/main.c            | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c             | 32 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  6 ++++++
 arch/x86/kvm/x86.c                 |  4 ----
 6 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 823c0434bbad..1eca04087cf4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,7 +125,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP_OPTIONAL(dev_get_attr)
-KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..2b0317b47e47 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -927,4 +927,27 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SNP_VM		4
 #define KVM_X86_TDX_VM		5
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 */
+	__u64 hw_error;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5c1acc88feef..69c65085f81a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -41,6 +41,14 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_ioctl(kvm, argp);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -193,6 +201,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
+
+	.mem_enc_ioctl = vt_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1f4875e5f7c9..08880ac9c77b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3,6 +3,7 @@
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
+#include "x86_ops.h"
 #include "tdx.h"
 
 #pragma GCC poison to_vmx
@@ -42,6 +43,37 @@ static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_tdx_cmd tdx_cmd;
+	int r;
+
+	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
+		return -EFAULT;
+
+	/*
+	 * Userspace should never set hw_error. It is used to fill
+	 * hardware-defined error by the kernel.
+	 */
+	if (tdx_cmd.hw_error)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	switch (tdx_cmd.id) {
+	default:
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
+		r = -EFAULT;
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 430773a5ef8e..2c87a8e7bddc 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -121,4 +121,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+#else
+static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02159c967d29..374d89e6663f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7277,10 +7277,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		goto out;
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
-		r = -ENOTTY;
-		if (!kvm_x86_ops.mem_enc_ioctl)
-			goto out;
-
 		r = kvm_x86_call(mem_enc_ioctl)(kvm, argp);
 		break;
 	}
-- 
2.43.5



