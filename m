Return-Path: <kvm+bounces-55433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A76B30977
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EC5B1CE50CF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668CC3128A9;
	Thu, 21 Aug 2025 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TISyPjtl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20AB2EA755;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815883; cv=none; b=S4iDKXxMFE/qXRZHwGBeiOCTZY6UyjLi0wuvDYMFGxu6vrGFWk8zvXOeDcl2GqUBl8GP6YimW2FcLuV26aA3nTRZdzcuq/yJiO2nCkfUFJC3c9hgUbToClHjb4DXKlvI3Qebo/yTrdGIRb2x7y72YJDWJso2gb+D7KxanThhKZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815883; c=relaxed/simple;
	bh=sZ6RTt0wSOPylrUTjGFWzJhEP8sSj7ng279rDrMsHno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okTzy1sgGma+MqP45n0pF78DYiZB7xA+0rSOZPDru84T4g5EpRQG7F5eoUixZOowssVFkCdwIm8dibN5SdgeNT4KpQGuE6+nqvtoAqBPohCxAbKXgnRF/Ir0hP32noOF5LH7hpFsNuZmpdo6A0QnGKoIDGit6cF8QEcAXn+gM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TISyPjtl; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOa984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOa984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815813;
	bh=V+FNm9J78AlgzbddQ1AfclYQnIWo5NKtIhcMQnHAn8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TISyPjtlZfM7mDrvuw02OxnY570owVix2eDKL0evmnmxJGd9xXedrSplwibaYUQ6p
	 1wHfOCD8Ec4OOrWLU1aFA2LcZU1sq4EvQ3LWxgiw7ZR79+zAmF+SSTv8cyS6wYZ21W
	 wERGWL+AtrSrfHAykvrvDzHtrC4eQV1DXzZjtqO6frG85Rt3rVRYhFE9f0zHsudniD
	 LKG3xUlsP7yotCMnXcHqojUiUFABZ0gz6OJdJDtUcL7DboArk16QjqQW2MU0nc349d
	 MVlDX/poRPoGMMjIdc2YV/A3jxpQbgEEAtrIhAi7eypEx6JKh1Jn+jakLEy+ooLvUZ
	 8uxyjPaJtpxJA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 12/20] KVM: x86: Save/restore the nested flag of an exception
Date: Thu, 21 Aug 2025 15:36:21 -0700
Message-ID: <20250821223630.984383-13-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
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
index 6299c43dfbee..7549e5143249 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1484,6 +1484,7 @@ struct kvm_arch {
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
index fbbfa600e2c2..7103eedb13e8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4927,6 +4927,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
 	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
@@ -5672,6 +5673,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->exception.error_code = ex->error_code;
 	events->exception_has_payload = ex->has_payload;
 	events->exception_payload = ex->payload;
+	events->exception_is_nested = ex->nested;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -5697,6 +5699,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 			 | KVM_VCPUEVENT_VALID_SMM);
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
+	if (vcpu->kvm->arch.exception_nested_flag_enabled)
+		events->flags |= KVM_VCPUEVENT_VALID_NESTED_FLAG;
 	if (vcpu->kvm->arch.triple_fault_event) {
 		events->triple_fault.pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
@@ -5711,7 +5715,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
 			      | KVM_VCPUEVENT_VALID_PAYLOAD
-			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+			      | KVM_VCPUEVENT_VALID_NESTED_FLAG))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5726,6 +5731,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
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
@@ -5751,6 +5763,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.exception.error_code = events->exception.error_code;
 	vcpu->arch.exception.has_payload = events->exception_has_payload;
 	vcpu->arch.exception.payload = events->exception_payload;
+	vcpu->arch.exception.nested = events->exception_is_nested;
 
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -6800,6 +6813,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
2.50.1


