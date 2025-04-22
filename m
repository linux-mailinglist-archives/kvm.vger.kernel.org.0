Return-Path: <kvm+bounces-43835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8692CA97230
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F4E93A72AE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA1629347D;
	Tue, 22 Apr 2025 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NmqZZoP4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAEA290BB2
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338406; cv=none; b=dnta92jQ0mikGXvaWqDd8YtE1UfutSiy5GH1cL4bLrfByXBfKtnc57QDQpZlBu670mYSK7ktqjwAW6DJvVRBO26MdnFWYVm/BPhw/u+CVwOEoGc1AWWszCxjJn/ys3C2IkTXqYo/rS2VTUp4TwMa+X85zGeigtMdC8UjHn5RXM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338406; c=relaxed/simple;
	bh=C/Hn9RDCmfZsJAIV3wy4YCYpeosbsx134ZEiLfGfFjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa+AkxyT6VUN151RoCWGr3XaqJyrMOm7clP0jKIL+VGQna5G5+x0aMmezLbL/ZLgcmrLOjthN+DYIlAAzPUSMoLEiATtD4j/WcywRzZjUc+vCA6v/H7FM8Fp9kkyNaE0nlsnDuVGcGPTtgZmUtPvaP1lCpozPZFHqqtIXi6cnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NmqZZoP4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224171d6826so75884705ad.3
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745338404; x=1745943204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+WR+ufwbSILxopcdBLjtH7jGhgDa1NwLi483QFhmDnk=;
        b=NmqZZoP4TrlfRu0lqV8wRqgTOaKJYJH3zp/OHnX79NDzgTQn7az6+9/zBXtl9vmQpE
         iEyFKX4wTaqmeBRE/NnoypsW/zvKCkBNIbxFYsfwfCi56VDLpicbT1NM24TFDYCqv0d5
         tp92844i0idgeguekj/AOMuyvnWZrLmn0MjQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745338404; x=1745943204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+WR+ufwbSILxopcdBLjtH7jGhgDa1NwLi483QFhmDnk=;
        b=oFkF8InnpzRHiKPchFcKeArFE7ZEHGQjB7qemR0sOcSpu+wM/CjxDyeYG2azrjk9vQ
         f3lLHbc+xVZfSPCvRlnJ5RSIf4l1qSwhYBX98EFozc6yruBzXMLAEfNpGrridYT+Uy15
         9vTcNITHyi9xCBhfRWZDKEDh8wTWiuxpcV7c5rJBuMaYesmb7eaQEUqiY2LoLPaUclia
         WdLuFE8R3AcZQmVGgxqEqGF8Ext3JUYeXZsVHpBWCwNooyI9XUNa9Sic8bWbjZ8154MU
         ylaFa96aT9B+x6WjPJXQ/Fqfw/saAnTjH6txbraQYfddGVIpAfrhb7LHM63wObOce/uS
         JGHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwtGS5cpJzGYb5ipF+6GbYUdtZfXp9gd999Xa4/+ZFbkCewDlcGVW9qaP5o7GppQjxKGg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3I2CFo5tRWjOk6eN2e0StoLxdr9jqDgdY12Ru4svuywA9HRIU
	JaQC/AEtp8CBkPeRtFrXcG/VaIC31rArY/y1CgRoeWKVz+jpocpF4pl6iaLBMw==
X-Gm-Gg: ASbGnctCQKu0CHGHOAaOmenxVf3EIZp6jNT8knbe+Hq/dKOCPDi1Re6K6iigj5DgO0z
	b+72zyFvwhJRNtcmX5VxakcfA4oLitTrzlIXM+mwYO2nOE6Y2Gt2c2RWTZTtfs844f4iV3FGCsp
	xclypTk15f/7P6FyZYqvNeEZBekPevk5TP3HK/XAnmASUj50v3ksHM/vkdgHw8LAgkWH9/ICF2q
	b+os1JwQxQPnh5zNK9zcNTrDxgt0f/IGCSSiYmdoxRAK2t1R6O+MOMZgmG3V76gONtZGUuJS2vG
	l3ikbEb9n1l7/B64dXN9iQhF5O8E8h3pQzdvgQySDgOdfpLxZPgj28yUNJR0fGgnKMBmMnKIIxi
	Ogc1+dO8ReBCr4T5/uKoP6WnUFZs9jVq3
X-Google-Smtp-Source: AGHT+IEKyzmNT//s4YzfBD+zTRRCqzS91zw7EACQIK35NQuHeyo2piWFvlw/YJ83ftPkUpG6izUuMw==
X-Received: by 2002:a17:902:ef02:b0:229:1717:8812 with SMTP id d9443c01a7336-22c530b5739mr247906595ad.0.1745338404055;
        Tue, 22 Apr 2025 09:13:24 -0700 (PDT)
Received: from localhost.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net. [173.49.113.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb03d2sm87462375ad.142.2025.04.22.09.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:13:23 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: linux-kernel@vger.kernel.org
Cc: Zack Rusin <zack.rusin@broadcom.com>,
	Doug Covelli <doug.covelli@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: x86: Add support for VMware guest specific hypercalls
Date: Tue, 22 Apr 2025 12:12:22 -0400
Message-ID: <20250422161304.579394-4-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250422161304.579394-1-zack.rusin@broadcom.com>
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

VMware products handle hypercalls in userspace. Give KVM the ability
to run VMware guests unmodified by fowarding all hypercalls to the
userspace.

Enabling of the KVM_CAP_X86_VMWARE_HYPERCALL_ENABLE capability turns
the feature on - it's off by default. This allows vmx's built on top
of KVM to support VMware specific hypercalls.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: Doug Covelli <doug.covelli@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/virt/kvm/api.rst  | 57 +++++++++++++++++++++++++--
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Kconfig            |  6 ++-
 arch/x86/kvm/kvm_vmware.c       | 69 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/kvm_vmware.h       | 16 ++++++++
 arch/x86/kvm/x86.c              | 11 ++++++
 include/uapi/linux/kvm.h        | 25 ++++++++++++
 7 files changed, 179 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 24bc80764fdc..6d3d2a509848 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6624,10 +6624,11 @@ to the byte array.
 .. note::
 
       For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN,
-      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR the corresponding
-      operations are complete (and guest state is consistent) only after userspace
-      has re-entered the kernel with KVM_RUN.  The kernel side will first finish
-      incomplete operations and then check for pending signals.
+      KVM_EXIT_EPR, KVM_EXIT_VMWARE, KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR
+      the corresponding operations are complete (and guest state is consistent)
+      only after userspace has re-entered the kernel with KVM_RUN. The kernel
+      side will first finish incomplete operations and then check for pending
+      signals.
 
       The pending state of the operation is not preserved in state which is
       visible to userspace, thus userspace should ensure that the operation is
@@ -8273,6 +8274,54 @@ default value for it is set via the kvm.enable_vmware_backdoor
 kernel parameter (false when not set). Must be set before any
 VCPUs have been created.
 
+7.38 KVM_CAP_X86_VMWARE_HYPERCALL
+---------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether the feature should be enabled or not
+:Returns: 0 on success.
+
+Capability allows userspace to handle hypercalls. When enabled
+whenever the vcpu has executed a VMCALL(Intel) or a VMMCALL(AMD)
+instruction kvm will exit to userspace with KVM_EXIT_VMWARE.
+
+On exit the vmware structure of the kvm_run structure will
+look as follows:
+
+::
+
+  struct kvm_vmware_exit {
+  #define KVM_EXIT_VMWARE_HCALL          1
+    __u32 type;
+    __u32 pad1;
+    union {
+      struct {
+        __u32 longmode;/* true if in long/64bit mode */
+        __u32 cpl;
+        __u64 rax, rbx, rcx, rdx, rsi, rdi, rbp;
+        __u64 result;  /* will be written to eax on return */
+        struct {
+          __u32 inject;
+          __u32 pad2;
+          __u32 vector;
+          __u32 error_code;
+          __u64 address;
+        } exception;
+      } hcall;
+    };
+  };
+
+The exception structure of the kvm_vmware_call.hcall member allows
+the monitor to inject an exception in the guest. On return if the
+exception.inject is set true the remaining members of the exception
+structure will be used to create and queue up an exception for the
+guest.
+
+Except when running in compatibility mode with VMware hypervisors
+userspace handling of hypercalls is discouraged. To implement
+such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO
+(all except s390).
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5670d7d02d1b..86bacda2802e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1196,6 +1196,7 @@ struct kvm_xen {
 /* VMware emulation context */
 struct kvm_vmware {
 	bool backdoor_enabled;
+	bool hypercall_enabled;
 };
 #endif
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9e3be87fc82b..f817601924bd 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -183,11 +183,13 @@ config KVM_VMWARE
 	depends on KVM
 	default y
 	help
-	  Provides KVM support for hosting VMware guests. Adds support for
-	  VMware legacy backdoor interface: VMware tools and various userspace
+	  Provides KVM support for hosting VMware guests. KVM features that can
+	  be turned on when this option is enabled include:
+	  - VMware legacy backdoor interface: VMware tools and various userspace
 	  utilities running in VMware guests sometimes utilize specially
 	  formatted IN, OUT and RDPMC instructions which need to be
 	  intercepted.
+	  - VMware hypercall interface: VMware hypercalls exit to userspace
 
 	  If unsure, say "Y".
 
diff --git a/arch/x86/kvm/kvm_vmware.c b/arch/x86/kvm/kvm_vmware.c
index b8ede454751f..096adb92ac60 100644
--- a/arch/x86/kvm/kvm_vmware.c
+++ b/arch/x86/kvm/kvm_vmware.c
@@ -6,6 +6,8 @@
 
  #include "kvm_vmware.h"
 
+ #include "x86.h"
+
 bool __read_mostly enable_vmware_backdoor;
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 module_param(enable_vmware_backdoor, bool, 0444);
@@ -14,3 +16,70 @@ void kvm_vmware_init_vm(struct kvm *kvm)
 {
 	kvm->arch.vmware.backdoor_enabled = enable_vmware_backdoor;
 }
+
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	u64 ret = vcpu->run->vmware.hcall.result;
+
+	if (!is_64_bit_hypercall(vcpu))
+		ret = (u32)ret;
+	kvm_rax_write(vcpu, ret);
+
+	if (vcpu->run->vmware.hcall.exception.inject) {
+		u32 vector = vcpu->run->vmware.hcall.exception.vector;
+		u32 error_code = vcpu->run->vmware.hcall.exception.error_code;
+		u32 address = vcpu->run->vmware.hcall.exception.address;
+		bool has_error_code = x86_exception_has_error_code(vector);
+
+		if (vector == PF_VECTOR) {
+			struct x86_exception fault = {0};
+
+			fault.vector = PF_VECTOR;
+			fault.error_code_valid = true;
+			fault.error_code = error_code;
+			fault.address = address;
+
+			kvm_inject_page_fault(vcpu, &fault);
+		} else if (has_error_code) {
+			kvm_queue_exception_e(vcpu, vector, error_code);
+		} else {
+			kvm_queue_exception(vcpu, vector);
+		}
+
+		/*
+		 * Don't skip the instruction to deliver the exception
+		 * at the backdoor call
+		 */
+		return 1;
+	}
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+int kvm_vmware_hypercall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+	bool is_64_bit = is_64_bit_hypercall(vcpu);
+	u64 mask = is_64_bit ? U64_MAX : U32_MAX;
+
+	run->exit_reason = KVM_EXIT_VMWARE;
+	run->vmware.type = KVM_EXIT_VMWARE_HCALL;
+	run->vmware.hcall.longmode = is_64_bit;
+	run->vmware.hcall.rax = kvm_rax_read(vcpu) & mask;
+	run->vmware.hcall.rbx = kvm_rbx_read(vcpu) & mask;
+	run->vmware.hcall.rcx = kvm_rcx_read(vcpu) & mask;
+	run->vmware.hcall.rdx = kvm_rdx_read(vcpu) & mask;
+	run->vmware.hcall.rsi = kvm_rsi_read(vcpu) & mask;
+	run->vmware.hcall.rdi = kvm_rdi_read(vcpu) & mask;
+	run->vmware.hcall.rbp = kvm_rbp_read(vcpu) & mask;
+	run->vmware.hcall.cpl = kvm_x86_call(get_cpl)(vcpu);
+	run->vmware.hcall.result = 0;
+	run->vmware.hcall.exception.inject = 0;
+	run->vmware.hcall.exception.vector = 0;
+	run->vmware.hcall.exception.error_code = 0;
+	run->vmware.hcall.exception.address = 0;
+
+	vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/kvm_vmware.h b/arch/x86/kvm/kvm_vmware.h
index de55c9ee7c0f..846b90091a2a 100644
--- a/arch/x86/kvm/kvm_vmware.h
+++ b/arch/x86/kvm/kvm_vmware.h
@@ -93,7 +93,13 @@ static inline bool kvm_vmware_is_backdoor_opcode(u8 opcode_len, u8 b)
 	return false;
 }
 
+static inline bool kvm_vmware_hypercall_enabled(struct kvm *kvm)
+{
+	return kvm->arch.vmware.hypercall_enabled;
+}
+
 void kvm_vmware_init_vm(struct kvm *kvm);
+int kvm_vmware_hypercall(struct kvm_vcpu *vcpu);
 
 #else /* !CONFIG_KVM_VMWARE */
 
@@ -126,6 +132,16 @@ static inline void kvm_vmware_init_vm(struct kvm *kvm)
 {
 }
 
+static inline bool kvm_vmware_hypercall_enabled(struct kvm *kvm)
+{
+	return false;
+}
+
+static inline int kvm_vmware_hypercall(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 #endif /* CONFIG_KVM_VMWARE */
 
 #endif /* __ARCH_X86_KVM_VMWARE_H__ */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a0b0830e5ece..300cef9a37e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4652,6 +4652,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_GUEST_MODE:
 #ifdef CONFIG_KVM_VMWARE
 	case KVM_CAP_X86_VMWARE_BACKDOOR:
+	case KVM_CAP_X86_VMWARE_HYPERCALL:
 #endif
 		r = 1;
 		break;
@@ -6746,6 +6747,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_VMWARE_HYPERCALL:
+		r = -EINVAL;
+		if (cap->args[0] & ~1)
+			break;
+		kvm->arch.vmware.hypercall_enabled = cap->args[0];
+		r = 0;
+		break;
 #endif
 	default:
 		r = -EINVAL;
@@ -10085,6 +10093,9 @@ EXPORT_SYMBOL_GPL(____kvm_emulate_hypercall);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
+	if (kvm_vmware_hypercall_enabled(vcpu->kvm))
+		return kvm_vmware_hypercall(vcpu);
+
 	if (kvm_xen_hypercall_enabled(vcpu->kvm))
 		return kvm_xen_hypercall(vcpu);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 793d0cf7ae3c..adf1a1449c06 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,27 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_vmware_exit {
+#define KVM_EXIT_VMWARE_HCALL          1
+	__u32 type;
+	__u32 pad1;
+	union {
+		struct {
+			__u32 longmode;
+			__u32 cpl;
+			__u64 rax, rbx, rcx, rdx, rsi, rdi, rbp;
+			__u64 result;
+			struct {
+				__u32 inject;
+				__u32 pad2;
+				__u32 vector;
+				__u32 error_code;
+				__u64 address;
+			} exception;
+		} hcall;
+	};
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +199,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_VMWARE           40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -420,6 +442,8 @@ struct kvm_run {
 		} msr;
 		/* KVM_EXIT_XEN */
 		struct kvm_xen_exit xen;
+		/* KVM_EXIT_VMWARE */
+		struct kvm_vmware_exit vmware;
 		/* KVM_EXIT_RISCV_SBI */
 		struct {
 			unsigned long extension_id;
@@ -930,6 +954,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_X86_VMWARE_BACKDOOR 239
+#define KVM_CAP_X86_VMWARE_HYPERCALL 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.48.1


