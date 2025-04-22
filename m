Return-Path: <kvm+bounces-43836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B868A97233
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41D9E401724
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09D8293B6E;
	Tue, 22 Apr 2025 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="geI162k1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2033A29346B
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 16:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338408; cv=none; b=eMuMRymqbfMRfmmYKGRzZXd/RSCIj+NeMl2V6E1gzX7EoBC0G/9eNOHhwMZrpkD9YwhjWjH3UP7UI2sJ2OGtrXrUByGjVjwTIZusE5uFxA0RwWQg8YQmaXUuVCtNSTQ3MAJxABN0HS3EQg1d433yVeVk8uGg19VWNJgR+jGJeJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338408; c=relaxed/simple;
	bh=wZyGnaU9VKPQKehMP8wf4K5Z9nGpXchW01UtloVdEQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0/Y24qI7nQ/Y2l3qbohMBdu8GMM2X5U22qOk3Erdb5dDHPbpcmbEbzxq607tjnMXBxBR9RcVg8xL9DPsUGngjAxHu4WyjZowRg+6CjVMVU4x7wNYnCU4aJshriaWswuegTNN8REKtAGJyKCeAnJNlVgw/ES9pQs4hSfxNb5pTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=geI162k1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227c7e57da2so47017825ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745338406; x=1745943206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYxBieSKIgS6H6yAXjPCIOcA2I5tG+O4lrtR0vcRYlI=;
        b=geI162k1MVLjh4QDInpGc1f8lQNB+NV/zNJg1HuthT2kp2Cv81LI5eXo9+QdWg7kWD
         cQymVafcb35itvBk7RCkOOQTCSqL65OYaHBPFea4YB1OQgPBoElIkXw8YTLOiM+qc4rp
         C894dQFYjWVLvn2KOELaLPlcQ9UFfzgEIxPjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745338406; x=1745943206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYxBieSKIgS6H6yAXjPCIOcA2I5tG+O4lrtR0vcRYlI=;
        b=YfjhD7R1mLsLp6zSwUvI5Hmb6YKRA+MkqR3zfry5CVxqtgqqXES0CQqk6NIMFS7aFN
         DPb1wnHedpsxMBNVoT2bxHLFBBvPCqWeb1ih9QK2vgZjJowj67JTInFqgt2r4E7JPxod
         Vc3+9E0OINRelgxy7HLvPlrNhW8NWfKgQtmX6jKZduOG2VD9OhYWo6BFyYQYEjlBvMXM
         H0ugUxbjrFq6zP6dnJjYrafDPYlIznBIk3nHEHtQwZZTCcj9YI6KXOtsaP9PFTgo1r6H
         DCuX+welb9kTQV+tk7UCNbQ7ru3y3loub8y3myupJyjE2R+GFOywhbYQFLldt0iBZtoT
         xvqg==
X-Forwarded-Encrypted: i=1; AJvYcCVE3xxnjWGei5Nx3sjCyYLt6hGoSvwmbt2tgESnPE8d1OKW+fLvAsrPHZVNYuQ8jKFtc5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsTtQkEVhpO0BMlItBrfsNbCZu9N/VWaSY70XV0H9wcS36q12H
	7IF8zY4HGNE5qQxL+AdQgL1ZEjzt6JhZFl254dauSCv7I424SxiA79ntgxlzsQ==
X-Gm-Gg: ASbGncs9PqdPWyRrDys1iv5qmJXxe84PDNn0MqZrgoI7D/jFUGqz9hGCSi8QGV/xKmu
	RQUb3WpLsXjGC6nQEujXFKMF0NagrDNgR40ujhTV9+sQ0dAH8tld7pXplwS2He+DiX+D19ZZ8hf
	/rtOAbbul94KYpS2CAhAIYszwKK7cF2enDX/S1hM8s6JPflw5fUMbqIs3TBMvX2WJ6uxRqVwuCF
	p9gudCIWJxvAxkGuCRlliEzBEYN6CIXcfn+ehlOTZ/JyNg9Ub/8jmfNpyQ+zIBT35xcLjYuX7N7
	wG/7r80hixflAzkTmw31RM6OZ3dA9ArGZ3sfWcfqunPIubEUaVkePpe+CpRTuST7yH9hFkAYIr1
	xV0Jy8PL/0Z5AGySeXwBkT3t2kTAn4h/v
X-Google-Smtp-Source: AGHT+IFUvWhafII9vCi70h93pyV2tLtAs4kKP+wr0pbhir/6F18FqckDEpBNWILkVgMQ+IyZlIqSWg==
X-Received: by 2002:a17:902:ce8c:b0:21f:4b01:b978 with SMTP id d9443c01a7336-22c53607c5bmr246637305ad.36.1745338406314;
        Tue, 22 Apr 2025 09:13:26 -0700 (PDT)
Received: from localhost.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net. [173.49.113.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb03d2sm87462375ad.142.2025.04.22.09.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:13:26 -0700 (PDT)
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
Subject: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors in nested setups
Date: Tue, 22 Apr 2025 12:12:23 -0400
Message-ID: <20250422161304.579394-5-zack.rusin@broadcom.com>
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

Allow handling VMware backdoors by the L0 monitor. This is required on
setups running Windows VBS, where the L1 will be running Hyper-V which
can't handle VMware backdoors. Thus on Windows VBS legacy VMware backdoor
calls issued by the userspace will end up in Hyper-V (L1) and endup
throwing an error.
Add a KVM cap that, in nested setups, allows the legacy VMware backdoor
to be handled by the L0 monitor. Thanks to this we can make sure that
VMware backdoor is always handled by the correct monitor.

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
 Documentation/virt/kvm/api.rst  | 14 +++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/kvm_vmware.h       | 42 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/nested.c       |  6 +++++
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/vmx/nested.c       |  6 +++++
 arch/x86/kvm/x86.c              |  8 +++++++
 include/uapi/linux/kvm.h        |  1 +
 9 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6d3d2a509848..55bd464ebf95 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8322,6 +8322,20 @@ userspace handling of hypercalls is discouraged. To implement
 such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO
 (all except s390).
 
+7.39 KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0
+------------------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether the feature should be enabled or not
+:Returns: 0 on success.
+
+Capability allows VMware backdoors to be handled by L0 when running
+on nested configurations. This is required when, for example
+running Windows guest with Hyper-V VBS enabled - in that configuration
+the VMware backdoor calls issued by VMware tools would endup in Hyper-V
+(L1) which doesn't handle VMware backdoor. Enable this option to have
+VMware backdoor sent to L0 monitor.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 86bacda2802e..2a806aa93a9e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1197,6 +1197,7 @@ struct kvm_xen {
 struct kvm_vmware {
 	bool backdoor_enabled;
 	bool hypercall_enabled;
+	bool nested_backdoor_l0_enabled;
 };
 #endif
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f817601924bd..8fefde6f2e78 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -190,6 +190,7 @@ config KVM_VMWARE
 	  formatted IN, OUT and RDPMC instructions which need to be
 	  intercepted.
 	  - VMware hypercall interface: VMware hypercalls exit to userspace
+	  - VMware legacy backdoor handling in L0
 
 	  If unsure, say "Y".
 
diff --git a/arch/x86/kvm/kvm_vmware.h b/arch/x86/kvm/kvm_vmware.h
index 846b90091a2a..d90bcf73bae4 100644
--- a/arch/x86/kvm/kvm_vmware.h
+++ b/arch/x86/kvm/kvm_vmware.h
@@ -9,6 +9,9 @@
 
 #include <linux/kvm_host.h>
 
+#include "asm/vmware.h"
+#include "x86.h"
+
 #ifdef CONFIG_KVM_VMWARE
 
 #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
@@ -98,6 +101,35 @@ static inline bool kvm_vmware_hypercall_enabled(struct kvm *kvm)
 	return kvm->arch.vmware.hypercall_enabled;
 }
 
+static inline bool kvm_vmware_nested_backdoor_l0_enabled(struct kvm *kvm)
+{
+	return kvm->arch.vmware.backdoor_enabled &&
+		kvm->arch.vmware.nested_backdoor_l0_enabled;
+}
+
+static inline bool kvm_vmware_wants_backdoor_to_l0(struct kvm_vcpu *vcpu, u32 cpl)
+{
+	/* We only care about the lower 32 bits */
+	const unsigned long mask = 0xffffffff;
+	const unsigned long port_mask = 0xffff;
+	unsigned long rax, rdx;
+
+	if (!kvm_vmware_nested_backdoor_l0_enabled(vcpu->kvm))
+		return false;
+
+	if (cpl != 3)
+		return false;
+
+	rax = kvm_rax_read(vcpu) & mask;
+	if (rax == VMWARE_HYPERVISOR_MAGIC) {
+		rdx = kvm_rdx_read(vcpu) & port_mask;
+		return (rdx == VMWARE_HYPERVISOR_PORT ||
+			rdx == VMWARE_HYPERVISOR_PORT_HB);
+	}
+
+	return false;
+}
+
 void kvm_vmware_init_vm(struct kvm *kvm);
 int kvm_vmware_hypercall(struct kvm_vcpu *vcpu);
 
@@ -142,6 +174,16 @@ static inline int kvm_vmware_hypercall(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline bool kvm_vmware_nested_backdoor_l0_enabled(struct kvm *kvm)
+{
+	return false;
+}
+
+static inline bool kvm_vmware_wants_backdoor_to_l0(struct kvm_vcpu *vcpu, u32 cpl)
+{
+	return false;
+}
+
 #endif /* CONFIG_KVM_VMWARE */
 
 #endif /* __ARCH_X86_KVM_VMWARE_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 04c375bf1ac2..74c472e51479 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -22,6 +22,7 @@
 #include <asm/debugreg.h>
 
 #include "kvm_emulate.h"
+#include "kvm_vmware.h"
 #include "trace.h"
 #include "mmu.h"
 #include "x86.h"
@@ -1517,6 +1518,11 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 			 svm->vcpu.arch.apf.host_apf_flags)
 			/* Trap async PF even if not shadowing */
 			return NESTED_EXIT_HOST;
+#ifdef CONFIG_KVM_VMWARE
+		else if ((exit_code == (SVM_EXIT_EXCP_BASE + GP_VECTOR)) &&
+			 kvm_vmware_wants_backdoor_to_l0(vcpu, to_svm(vcpu)->vmcb->save.cpl))
+			return NESTED_EXIT_HOST;
+#endif
 		break;
 	}
 	case SVM_EXIT_VMMCALL:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index be106bd60553..96996e7f9de4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2407,7 +2407,8 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 		 * VMware backdoor emulation on #GP interception only handles
 		 * IN{S}, OUT{S}, and RDPMC.
 		 */
-		if (!is_guest_mode(vcpu))
+		if (!is_guest_mode(vcpu)  ||
+		    kvm_vmware_wants_backdoor_to_l0(vcpu, svm_get_cpl(vcpu)))
 			return kvm_emulate_instruction(vcpu,
 				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
 	} else {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ed8a3cb53961..ff8a1dbbba01 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -10,6 +10,7 @@
 #include "x86.h"
 #include "cpuid.h"
 #include "hyperv.h"
+#include "kvm_vmware.h"
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
@@ -6386,6 +6387,11 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 			return true;
 		else if (is_ve_fault(intr_info))
 			return true;
+#ifdef CONFIG_KVM_VMWARE
+		else if (is_gp_fault(intr_info) &&
+			 kvm_vmware_wants_backdoor_to_l0(vcpu, vmx_get_cpl(vcpu)))
+			return true;
+#endif
 		return false;
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		return true;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 300cef9a37e2..5dc57bc57851 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4653,6 +4653,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 #ifdef CONFIG_KVM_VMWARE
 	case KVM_CAP_X86_VMWARE_BACKDOOR:
 	case KVM_CAP_X86_VMWARE_HYPERCALL:
+	case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
 #endif
 		r = 1;
 		break;
@@ -6754,6 +6755,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.vmware.hypercall_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
+		r = -EINVAL;
+		if (cap->args[0] & ~1)
+			break;
+		kvm->arch.vmware.nested_backdoor_l0_enabled = cap->args[0];
+		r = 0;
+		break;
 #endif
 	default:
 		r = -EINVAL;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index adf1a1449c06..f5d63c0c79f5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -955,6 +955,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_X86_VMWARE_BACKDOOR 239
 #define KVM_CAP_X86_VMWARE_HYPERCALL 240
+#define KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0 241
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.48.1


