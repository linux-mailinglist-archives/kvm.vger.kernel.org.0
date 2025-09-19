Return-Path: <kvm+bounces-58232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0B3B8B7B1
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F02AA01CE1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B82F2D9EFF;
	Fri, 19 Sep 2025 22:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y1al3ZqI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA33D2D8DC3
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321192; cv=none; b=rixKr+6DmJm7voO6kQOZsONYWhQQdW1rKfQ8pFl+uBAkHK3vhfgIdRQU1SutZivfPh/xe4cImfJW6iXeVFpOwsXEBsrXzBA/40XLc52VSFrVh764vi+97Z5rxmz073xlVJwPCjm2276sVe6QWWoWmMvneOzB3FwUeNSAK1ruKRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321192; c=relaxed/simple;
	bh=enmPjhM/d54x63EfajDrrNyPeLQbHVtmoiyg/AZqYog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M8TZ+jMzRFIQajphKrevfXm4c5pdALvYySKpTKteQled4XgZMduuJpfAQzlC4xCX57wcU2nmiRHg17V2DhLveKyNZbPPr//R2V4qhREL1qBGBAWm8W1sNsleYFUwW7UoVM6eghi2EZkNqDYaLWcdHL8a1ueKgsOwD9f015n+lPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y1al3ZqI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so2481716a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321190; x=1758925990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k+zz4k5YFJKSRkaVFyKdZddNO84kd++aDqeVUsMIWyw=;
        b=Y1al3ZqI1If6UQ7MyeR7pETklAKssKwkUESL8GXEDaQEuIMpgTr0CZrjOQ8zS5qd7J
         jmFTfm2w3FpztyTqSDmx1HGEgmCerxoKVdupyeiJNywyvbHc3Wk8YWaJn92KMDDTKOjr
         3YUl7QOSs9rfVVvxj31J+6Cwxn4AfIbq2uXB6GpoJpQO8biTISyj8e1+jMtLTkEV0YVb
         7+btNpiBGoKdM9WbhMvf8n+9tyXITIWgzvyrJUvse7t2kd2JiuDgbAh1HdE2tbRqrTDZ
         /dXhEKVxPXBIHpDktQ523t0BRa4zxIpJBPylQTnVrvjHGsTGqqwphaNtR+XBQFCAGh1D
         n8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321190; x=1758925990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k+zz4k5YFJKSRkaVFyKdZddNO84kd++aDqeVUsMIWyw=;
        b=Xf4Y+rrpP5e92RUbgsZv2urhlqV83ZgEBZ2KXdAahZR+zTd3uoByJ2FNNV0wfQwnCn
         IWhvPqpRwZxMAYteV2EgfuVFpAKQ+oPdeD0H3MLMJAFbm/gA9gQrNN5tPHucBQyc7Fkw
         sQiBpLmprka/+9pyD0PQjlycn6W4HktH2irh8qpt1sjQksDpV6JQbVoDX/QeeErsJSvF
         ZFdXqVjJoHfFH29XFFE4F+jKGfrwvm+Ri5TQRt6BHv8s5KpfgG2Xjoep1qJOcAdbw5rz
         CCLwjvbV044UWs36Kk5qYSfbqJo3x1GOTIpZafQCjbUYr5fZRf5cZbPz0w7S9nd9jS+3
         +6BA==
X-Gm-Message-State: AOJu0Yxc898hZNOkoxZHer2rOC4MdiOpcffbgne/tuTlS1T9jXADO+dN
	x9SIhkQz9t4baWe1TwPvQvc9rNGU4TRNPc3zvuo463fMcNTUgHTP8AAyiX7D5AYMGLp1/y0q4D8
	Lc8u8FA==
X-Google-Smtp-Source: AGHT+IHTK4ESE4/S5on3UUyBg9i8YRh5AGKe1diRriWTnVQvCFgstr/DxS8BA8AyWdtfTzPHp6R8dOo0HZY=
X-Received: from pjxx6.prod.google.com ([2002:a17:90b:58c6:b0:32d:a4d4:bb17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e86:b0:32b:cafc:e339
 with SMTP id 98e67ed59e1d1-33098398714mr5461812a91.36.1758321190133; Fri, 19
 Sep 2025 15:33:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:11 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-5-seanjc@google.com>
Subject: [PATCH v16 04/51] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access MSRs and
other non-MSR registers through them, along with support for
KVM_GET_REG_LIST to enumerate support for KVM-defined registers.

This is in preparation for allowing userspace to read/write the guest SSP
register, which is needed for the upcoming CET virtualization support.

Currently, two types of registers are supported: KVM_X86_REG_TYPE_MSR and
KVM_X86_REG_TYPE_KVM. All MSRs are in the former type; the latter type is
added for registers that lack existing KVM uAPIs to access them. The "KVM"
in the name is intended to be vague to give KVM flexibility to include
other potential registers.  More precise names like "SYNTHETIC" and
"SYNTHETIC_MSR" were considered, but were deemed too confusing (e.g. can
be conflated with synthetic guest-visible MSRs) and may put KVM into a
corner (e.g. if KVM wants to change how a KVM-defined register is modeled
internally).

Enumerate only KVM-defined registers in KVM_GET_REG_LIST to avoid
duplicating KVM_GET_MSR_INDEX_LIST, and so that KVM can return _only_
registers that are fully supported (KVM_GET_REG_LIST is vCPU-scoped, i.e.
can be precise, whereas KVM_GET_MSR_INDEX_LIST is system-scoped).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com [1]
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  |   6 +-
 arch/x86/include/uapi/asm/kvm.h |  26 +++++++++
 arch/x86/kvm/x86.c              | 100 ++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ffc350b649ad..abd02675a24d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2908,6 +2908,8 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 
   0x9030 0000 0002 <reg:16>
 
+x86 MSR registers have the following id bit patterns::
+  0x2030 0002 <msr number:32>
 
 4.69 KVM_GET_ONE_REG
 --------------------
@@ -3588,7 +3590,7 @@ VCPU matching underlying host.
 ---------------------
 
 :Capability: basic
-:Architectures: arm64, mips, riscv
+:Architectures: arm64, mips, riscv, x86 (if KVM_CAP_ONE_REG)
 :Type: vcpu ioctl
 :Parameters: struct kvm_reg_list (in/out)
 :Returns: 0 on success; -1 on error
@@ -3631,6 +3633,8 @@ Note that s390 does not support KVM_GET_REG_LIST for historical reasons
 
 - KVM_REG_S390_GBEA
 
+Note, for x86, all MSRs enumerated by KVM_GET_MSR_INDEX_LIST are supported as
+type KVM_X86_REG_TYPE_MSR, but are NOT enumerated via KVM_GET_REG_LIST.
 
 4.85 KVM_ARM_SET_DEVICE_ADDR (deprecated)
 -----------------------------------------
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..aae1033c8afa 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -411,6 +411,32 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_KVM		3
+
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
+({										\
+	__u64 type_size = (__u64)type << 32;					\
+										\
+	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ID(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_KVM, index)
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55044d6680c8..4ed25d33aaee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4735,6 +4735,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
 	case KVM_CAP_X86_GUEST_MODE:
+	case KVM_CAP_ONE_REG:
 		r = 1;
 		break;
 	case KVM_CAP_PRE_FAULT_MEMORY:
@@ -5913,6 +5914,98 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	}
 }
 
+struct kvm_x86_reg_id {
+	__u32 index;
+	__u8  type;
+	__u8  rsvd1;
+	__u8  rsvd2:4;
+	__u8  size:4;
+	__u8  x86;
+};
+
+static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
+{
+	return -EINVAL;
+}
+
+static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
+{
+	u64 val;
+
+	if (do_get_msr(vcpu, msr, &val))
+		return -EINVAL;
+
+	if (put_user(val, user_val))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
+{
+	u64 val;
+
+	if (get_user(val, user_val))
+		return -EFAULT;
+
+	if (do_set_msr(vcpu, msr, &val))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
+			       void __user *argp)
+{
+	struct kvm_one_reg one_reg;
+	struct kvm_x86_reg_id *reg;
+	u64 __user *user_val;
+	int r;
+
+	if (copy_from_user(&one_reg, argp, sizeof(one_reg)))
+		return -EFAULT;
+
+	if ((one_reg.id & KVM_REG_ARCH_MASK) != KVM_REG_X86)
+		return -EINVAL;
+
+	reg = (struct kvm_x86_reg_id *)&one_reg.id;
+	if (reg->rsvd1 || reg->rsvd2)
+		return -EINVAL;
+
+	if (reg->type == KVM_X86_REG_TYPE_KVM) {
+		r = kvm_translate_kvm_reg(reg);
+		if (r)
+			return r;
+	}
+
+	if (reg->type != KVM_X86_REG_TYPE_MSR)
+		return -EINVAL;
+
+	if ((one_reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
+		return -EINVAL;
+
+	guard(srcu)(&vcpu->kvm->srcu);
+
+	user_val = u64_to_user_ptr(one_reg.addr);
+	if (ioctl == KVM_GET_ONE_REG)
+		r = kvm_get_one_msr(vcpu, reg->index, user_val);
+	else
+		r = kvm_set_one_msr(vcpu, reg->index, user_val);
+
+	return r;
+}
+
+static int kvm_get_reg_list(struct kvm_vcpu *vcpu,
+			    struct kvm_reg_list __user *user_list)
+{
+	u64 nr_regs = 0;
+
+	if (put_user(nr_regs, &user_list->n))
+		return -EFAULT;
+
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -6029,6 +6122,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
+	case KVM_GET_ONE_REG:
+	case KVM_SET_ONE_REG:
+		r = kvm_get_set_one_reg(vcpu, ioctl, argp);
+		break;
+	case KVM_GET_REG_LIST:
+		r = kvm_get_reg_list(vcpu, argp);
+		break;
 	case KVM_TPR_ACCESS_REPORTING: {
 		struct kvm_tpr_access_ctl tac;
 
-- 
2.51.0.470.ga7dc726c21-goog


