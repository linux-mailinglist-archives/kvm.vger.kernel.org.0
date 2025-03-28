Return-Path: <kvm+bounces-42203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F87A74F16
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 397FC177B78
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBF61F09BA;
	Fri, 28 Mar 2025 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LylFpn+b"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47A81E0DE2;
	Fri, 28 Mar 2025 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181998; cv=none; b=ixjipihNwu8P7/+q2HgnV94B4QtN5Ch23mQ1eSYoNUDDT/jGp9adSNwnfJT9TI4oBx8lY6qdTnJruD/y5aqQ+Y3FRY3yYxB9t5G+UFGtRNcfG27rvua3/JiAyJ4a09rhkuVkSvf9ookq+2Wup6Gq2M7cu+NzJTngYTu1/vuvxRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181998; c=relaxed/simple;
	bh=sORkSZIXkdOTUrIEh48zIdJe0yhkLLYsXztU7eYPrPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIF1GKp+6nLcZAbfyFn86r0R7Ga1w/wIFfTYLNGT3vnNlZOFeyaqzCagYR02UkB3vFLAo5iplWxBLop4dDiS6FWfaGCNhU5nFMfWcyxOKmsYxP2lnCLdmh1Z39OUNY2jV2ZiqT96Tc8jzhHlYHCbimeVrze3ggqaCbUF1ahIIYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LylFpn+b; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vi2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vi2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181945;
	bh=mzkjBiaEYOeYYghsQnvYoR2QI96dNfDwMXS5aEW6BXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LylFpn+blP+nd+Y8z95On+RLPS56AkPmrDsbMswc/QqBEXR3MM1HW5/GcpdE/P5MQ
	 wwZ+KeKUwgiffdgRoWwXT8AtRk6cVms2AFYp0bGpJFx+Ap7ShSZ+/rIDFGu0K+h/Z6
	 9F02hk+KHpJqDRCQNMCI/Y38M1n6RxDYo35pIYQAhVeQ8dA8mv7d4I8Rqmhuabsr1Q
	 D6YKYLUpW+NXFOEA1LYvML2Oc3EHECt/ZcmAxwejLMgkd6fsTQo7+URhYoywh7f6nV
	 072uX0IVHHwBzyaTQmGtI0LqTMp/3f8pTgiXTNHk/r/vpnck1G1OmXcoWuaHFfqdwV
	 BVB0xB0G6RULA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 12/19] KVM: x86: Save/restore the nested flag of an exception
Date: Fri, 28 Mar 2025 10:11:58 -0700
Message-ID: <20250328171205.2029296-13-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save/restore the nested flag of an exception during VM save/restore
and live migration to ensure a correct event stack level is chosen
when a nested exception is injected through FRED event delivery.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change in v4:
* Add live migration support for exception nested flag (Chao Gao).
---
 Documentation/virt/kvm/api.rst  | 19 +++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/kvm.h |  4 +++-
 arch/x86/kvm/x86.c              | 19 ++++++++++++++++++-
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1f8625b7646a..32c00b07bcf1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1184,6 +1184,10 @@ The following bits are defined in the flags field:
   fields contain a valid state. This bit will be set whenever
   KVM_CAP_EXCEPTION_PAYLOAD is enabled.
 
+- KVM_VCPUEVENT_VALID_NESTED_FLAG may be set to inform that the
+  exception is a nested exception. This bit will be set whenever
+  KVM_CAP_EXCEPTION_NESTED_FLAG is enabled.
+
 - KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
   triple_fault_pending field contains a valid state. This bit will
   be set whenever KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled.
@@ -1283,6 +1287,10 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
+If KVM_CAP_EXCEPTION_NESTED_FLAG is enabled, KVM_VCPUEVENT_VALID_NESTED_FLAG
+can be set in the flags field to inform that the exception is a nested
+exception and exception_is_nested shall be written into the VCPU.
+
 If KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled, KVM_VCPUEVENT_VALID_TRIPLE_FAULT
 can be set in flags field to signal that the triple_fault field contains
 a valid state and shall be written into the VCPU.
@@ -8280,6 +8288,17 @@ aforementioned registers before the first KVM_RUN. These registers are VM
 scoped, meaning that the same set of values are presented on all vCPUs in a
 given VM.
 
+7.38 KVM_CAP_EXCEPTION_NESTED_FLAG
+----------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether feature should be enabled or not
+
+With this capability enabled, an exception is save/restored with the
+additional information of whether it was nested or not. FRED event
+delivery uses this information to ensure a correct event stack level
+is chosen when a VM entry injects a nested exception.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c5f92a1befc0..f8b9834f2f37 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1444,6 +1444,7 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool exception_nested_flag_enabled;
 
 	bool triple_fault_event;
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 460306b35a4b..6a3a39d04843 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -326,6 +326,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
 #define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
+#define KVM_VCPUEVENT_VALID_NESTED_FLAG	0x00000040
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -363,7 +364,8 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 pending;
 	} triple_fault;
-	__u8 reserved[26];
+	__u8 reserved[25];
+	__u8 exception_is_nested;
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f013ff97067..17b5a799f65d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4710,6 +4710,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
 	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
@@ -5437,6 +5438,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->exception.error_code = ex->error_code;
 	events->exception_has_payload = ex->has_payload;
 	events->exception_payload = ex->payload;
+	events->exception_is_nested = ex->nested;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -5462,6 +5464,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 			 | KVM_VCPUEVENT_VALID_SMM);
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
+	if (vcpu->kvm->arch.exception_nested_flag_enabled)
+		events->flags |= KVM_VCPUEVENT_VALID_NESTED_FLAG;
 	if (vcpu->kvm->arch.triple_fault_event) {
 		events->triple_fault.pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
@@ -5476,7 +5480,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
 			      | KVM_VCPUEVENT_VALID_PAYLOAD
-			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+			      | KVM_VCPUEVENT_VALID_NESTED_FLAG))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5491,6 +5496,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		events->exception_has_payload = 0;
 	}
 
+	if (events->flags & KVM_VCPUEVENT_VALID_NESTED_FLAG) {
+		if (!vcpu->kvm->arch.exception_nested_flag_enabled)
+			return -EINVAL;
+	} else {
+		events->exception_is_nested = 0;
+	}
+
 	if ((events->exception.injected || events->exception.pending) &&
 	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
 		return -EINVAL;
@@ -5522,6 +5534,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.exception.error_code = events->exception.error_code;
 	vcpu->arch.exception.has_payload = events->exception_has_payload;
 	vcpu->arch.exception.payload = events->exception_payload;
+	vcpu->arch.exception.nested = events->exception_is_nested;
 
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -6644,6 +6657,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
+		kvm->arch.exception_nested_flag_enabled = cap->args[0];
+		r = 0;
+		break;
 	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
 		kvm->arch.triple_fault_event = cap->args[0];
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b6ae8ad8934b..5ef33256858f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -930,6 +930,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_EXCEPTION_NESTED_FLAG 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.48.1


