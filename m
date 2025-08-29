Return-Path: <kvm+bounces-56333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82864B3BF52
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EB9F1736A8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29594326D6C;
	Fri, 29 Aug 2025 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="kGvTbfQS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5031E51EA;
	Fri, 29 Aug 2025 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481589; cv=none; b=PrT7cD4r7I0Eg8tETnRWh5zRqBWbBSpTZwYs8BSrn6UICzKgHMBzKiVCw4uF9pkGdEvvYRe8/AFH+sKXRELz+M3eENnZ34T2pV3sMkMah/UV8GuSzLZamPiYPFTHFozIbw0vbuTysSrR7IegP5M4FeTP1tG29JDXmKlcC4zq8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481589; c=relaxed/simple;
	bh=aMXsgpQlnv45jhoNXLMvO9cje9ZsYmHtfH0RY9DDUkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glPosOujc5QixN+IJVhqXhiGYor45RlM4rUng6NOwvxyoflNAvFQzV9sXRYcGjR7YDhFUe1LBCW51O6+FeKG7xx9UFESSEitxketucxiaj58a7fiQK665JlPINEVc5xu3wEGsqBAqepEBcKSBpmz0msj6owkXX3C3QlQCF8dQwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=kGvTbfQS; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4J2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4J2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481544;
	bh=c6wxsXBnP8mbkfumGPxeJmrfebSvLd0IncKlKAY85Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGvTbfQSny86SK0QAnpEwLcZBePpVPRFkO38RENcaU8YVLXPHle6GE83jHYYhQoY1
	 smcXcKtkPqM3G2FnjdB0Ua36KbjbvoYnvv85u34kjJNcfyFNEzlI0R0NrJSK7b6FY8
	 ADaEerlRjtglx802hHHA66bSzJjdAy4lFMYOWlCVps5fBKzVxC6tgX80VCdr3LILi3
	 bZgpC2iNwS4FHCrm/ugGWe0lzDFhsUW64EGUbobCLwy1H4cpjHx4AmmS+QwKMsR/kT
	 1RsM2mcz5y9qH1zHZ2lYTSvtkAuYO9rm3zX1whdreDGrRxLZzCGKMRsiHmN6q4pvD3
	 7ENp4UFNKHVfg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 13/21] KVM: x86: Save/restore the nested flag of an exception
Date: Fri, 29 Aug 2025 08:31:41 -0700
Message-ID: <20250829153149.2871901-14-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
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
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v4:
* Add live migration support for exception nested flag (Chao Gao).
---
 Documentation/virt/kvm/api.rst  | 21 ++++++++++++++++++++-
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/kvm.h |  4 +++-
 arch/x86/kvm/x86.c              | 19 ++++++++++++++++++-
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..c496b0883a7f 100644
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
@@ -8651,7 +8659,7 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
-7.43 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
+7.44 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
 -------------------------------------------
 
 :Architectures: arm64
@@ -8662,6 +8670,17 @@ This capability indicate to the userspace whether a PFNMAP memory region
 can be safely mapped as cacheable. This relies on the presence of
 force write back (FWB) feature support on the hardware.
 
+7.45 KVM_CAP_EXCEPTION_NESTED_FLAG
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
index b5a1fef8d637..0a646305e9d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1489,6 +1489,7 @@ struct kvm_arch {
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool exception_nested_flag_enabled;
 
 	bool triple_fault_event;
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 478d9b63a9db..03ea8c46d8cf 100644
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
index 7598b8d72b07..c030c7c43346 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4958,6 +4958,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
 	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
@@ -5703,6 +5704,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->exception.error_code = ex->error_code;
 	events->exception_has_payload = ex->has_payload;
 	events->exception_payload = ex->payload;
+	events->exception_is_nested = ex->nested;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -5728,6 +5730,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 			 | KVM_VCPUEVENT_VALID_SMM);
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
+	if (vcpu->kvm->arch.exception_nested_flag_enabled)
+		events->flags |= KVM_VCPUEVENT_VALID_NESTED_FLAG;
 	if (vcpu->kvm->arch.triple_fault_event) {
 		events->triple_fault.pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
@@ -5742,7 +5746,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
 			      | KVM_VCPUEVENT_VALID_PAYLOAD
-			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+			      | KVM_VCPUEVENT_VALID_NESTED_FLAG))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5757,6 +5762,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
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
@@ -5782,6 +5794,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.exception.error_code = events->exception.error_code;
 	vcpu->arch.exception.has_payload = events->exception_has_payload;
 	vcpu->arch.exception.payload = events->exception_payload;
+	vcpu->arch.exception.nested = events->exception_is_nested;
 
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -6831,6 +6844,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index f0f0d49d2544..fe4a822b3c09 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -962,6 +962,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_EXCEPTION_NESTED_FLAG 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.51.0


