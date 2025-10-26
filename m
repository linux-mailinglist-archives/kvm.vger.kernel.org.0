Return-Path: <kvm+bounces-61101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C1005C0B24E
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A01F84E9876
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227432FF677;
	Sun, 26 Oct 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AQX1g/sF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A0426E6F0;
	Sun, 26 Oct 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510029; cv=none; b=EGhLmgwnE7xF6oaGf3pMCe4zVT+XkBiRWqSq00vubRDXX6RgKHFK+fVRU2oUBS/0vHv7goYPblgp1y6nv0gqy4Ff5t6R1R5rHe7Vc8nexSDqnZAMeOyBR/hfdti2NLfD95mIZJRydTgQr1dorMDULs2P9oHVXzspBsB7OLX+i/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510029; c=relaxed/simple;
	bh=1fVVLH1JSBf3gwBSPD/b5pCR25gYHCy06jtZQz2NdV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHANiGNtyyYrb1turPkM2n7vF8LzL1n+PBCLY4/FmyWMRouhXbF3XLIFDjlXBEOa+oqz/yk6O9pZpSpKhz4XeG0CvJaJdxBgW6rw6A0UOap+lQ4XJsC3PhPmnT7G2iD6DinNPP/WzvG7Xkx8r0APoKDbPqLOp6tR4Lv6Ro7kGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AQX1g/sF; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkV505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkV505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509973;
	bh=caCGWNqxXNkgdZUZjLMjRPZUaVDq79YvY2IYgFyw0js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQX1g/sFVAVLcEm8ipjQUXacJqOihnIj1jMDMt7jaDboEDhJMc1lBKz/H+lJoTOc7
	 xwUqLs/HGswcKEHbq3SVvAD7ncys8KXZlyXhu2b49jc2Bpu5rkUizvdjNVG0Zi+Kir
	 F1gz3GkrkwZwDbTeBrPGzK5wMb2Dn2hWdekMVYs3B11KWK4CPlZfbF0bExykUgKe1M
	 BCSQq7g/9zqpt1qm4NvXkqgDeZozGpOC6a4QG8LYOtnr7p3etb44ws1YYtK6I0SycA
	 bxmQmEXX04o+RoQ9DrfOW9zvLxdnTb+rf4nkmkLvrvAP5UspB8UJjktZI/HgH1oHp5
	 FovJrjPLK5kIg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 14/22] KVM: x86: Save/restore the nested flag of an exception
Date: Sun, 26 Oct 2025 13:19:02 -0700
Message-ID: <20251026201911.505204-15-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
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

Change in v8:
* Update KVM_CAP_EXCEPTION_NESTED_FLAG, as the number in v7 is used
  by another new cap.

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
index 06d79e2cf7bf..4e9678adf661 100644
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
@@ -1286,6 +1290,10 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
+If KVM_CAP_EXCEPTION_NESTED_FLAG is enabled, KVM_VCPUEVENT_VALID_NESTED_FLAG
+can be set in the flags field to inform that the exception is a nested
+exception and exception_is_nested shall be written into the VCPU.
+
 If KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled, KVM_VCPUEVENT_VALID_TRIPLE_FAULT
 can be set in flags field to signal that the triple_fault field contains
 a valid state and shall be written into the VCPU.
@@ -8692,7 +8700,7 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
-7.43 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
+7.44 KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED
 -------------------------------------------
 
 :Architectures: arm64
@@ -8703,6 +8711,17 @@ This capability indicate to the userspace whether a PFNMAP memory region
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
index 3b6dadf368eb..5fff22d837aa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1491,6 +1491,7 @@ struct kvm_arch {
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool exception_nested_flag_enabled;
 
 	bool triple_fault_event;
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..fbeeea236fc2 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -331,6 +331,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
 #define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
+#define KVM_VCPUEVENT_VALID_NESTED_FLAG	0x00000040
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -368,7 +369,8 @@ struct kvm_vcpu_events {
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
index 554442c07f27..6762f5564341 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4968,6 +4968,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
 	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
@@ -5713,6 +5714,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->exception.error_code = ex->error_code;
 	events->exception_has_payload = ex->has_payload;
 	events->exception_payload = ex->payload;
+	events->exception_is_nested = ex->nested;
 
 	events->interrupt.injected =
 		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -5738,6 +5740,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 			 | KVM_VCPUEVENT_VALID_SMM);
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
+	if (vcpu->kvm->arch.exception_nested_flag_enabled)
+		events->flags |= KVM_VCPUEVENT_VALID_NESTED_FLAG;
 	if (vcpu->kvm->arch.triple_fault_event) {
 		events->triple_fault.pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
@@ -5752,7 +5756,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
 			      | KVM_VCPUEVENT_VALID_PAYLOAD
-			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+			      | KVM_VCPUEVENT_VALID_NESTED_FLAG))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5767,6 +5772,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
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
@@ -5792,6 +5804,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.exception.error_code = events->exception.error_code;
 	vcpu->arch.exception.has_payload = events->exception_has_payload;
 	vcpu->arch.exception.payload = events->exception_payload;
+	vcpu->arch.exception.nested = events->exception_is_nested;
 
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -6912,6 +6925,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index 52f6000ab020..ec3cc37b9373 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_EXCEPTION_NESTED_FLAG 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.51.0


