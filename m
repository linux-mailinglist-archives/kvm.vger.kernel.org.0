Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3B4A6BB
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbfFRQYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:24:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33868 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbfFRQYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:24:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so2670423wmd.1;
        Tue, 18 Jun 2019 09:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=wn45yGyWBpJFF3B090t6OikuTRS2L3LXbBdazf0GkxA=;
        b=f+JBiuuMSVvN0aQNttQh9lYGHA9WvDu7dZu9jY44p/nH56yQWEa1DGNTBUyZWy0yQE
         CHHvJRVXZ9y4tzxg99FU4dJMByisTZ3EEotgLLahaLiPexkYxUy7h36aaw1MpyRSLoP0
         e5+NQ7DPsyWjRwe5+ZDnm/MSmDt7YlKKEj3j/Et6WeQFaRYlGmeiOUHbHx0ulji1etNC
         FwnYaDDtQikB8RZj5hWCRQV76P/EBIROTQu0d4vv9WUHQLZIM3d0E3n3TosQnBj2XoDs
         6uwBqj/OPm8lc9IIxf8rmWClI0bRHBcvhoFabnGHl08l/CPhUy39sg7Clh+Pce/+rEjo
         yj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=wn45yGyWBpJFF3B090t6OikuTRS2L3LXbBdazf0GkxA=;
        b=JnQjTCYOqsp1xn4Rm0gV1YQQlELMjdZcscW2qYwv6FkwuHxoccgP2tdSaS18ZCcFAe
         fcVDzKXouyNPJDNbFf/PLUQeQBGfoGM4jY6KmMlPhnEdwzqRNLJdH7181GviU6JHqa3Y
         uWXE+g9kXvTVSVrIW5AYSO/mUU8UCzgpN+5pMAPJhFvMiHuWp/m+cOOXPpvVbDgnA8kl
         MlsuHb23t1smT+o1eqUi2DkTc7GYtX/xRiNk24LJUlbPDVUGD0JHhB3tzXBpw53IGojJ
         p0tj+aKx1ZuMBtXZkvPEsEU2egeWJd82lh8O29kDlo3QqBTG0loYzZ5GipCsEvOtsFpX
         OmYQ==
X-Gm-Message-State: APjAAAVJ0jYpFS4eJ3WrpWcP3P+ItxGZqmEa3Y5iONiNJlq/PndL/eru
        Oykpa2r4+3bSrBZ0VbLlRC9eM4TS
X-Google-Smtp-Source: APXvYqzpHqoM9jBTY2GtPkWH8+tgZYvY/6t57+WI55PVv7XQ+Bc+aaNymgYu5cYmeIU1ZM4y6ehPVQ==
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr4582379wme.81.1560875049122;
        Tue, 18 Jun 2019 09:24:09 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r3sm18026157wrr.61.2019.06.18.09.24.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:24:08 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2] KVM: x86: Modify struct kvm_nested_state to have explicit fields for data
Date:   Tue, 18 Jun 2019 18:24:06 +0200
Message-Id: <1560875046-26279-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Improve the KVM_{GET,SET}_NESTED_STATE structs by detailing the format
of VMX nested state data in a struct.

In order to avoid changing the ioctl values of
KVM_{GET,SET}_NESTED_STATE, there is a need to preserve
sizeof(struct kvm_nested_state). This is done by defining the data
struct as "data.vmx[0]". It was the most elegant way I found to
preserve struct size while still keeping struct readable and easy to
maintain. It does have a misfortunate side-effect that now it has to be
accessed as "data.vmx[0]" rather than just "data.vmx".

Because we are already modifying these structs, I also modified the
following:
* Define the "format" field values as macros.
* Rename vmcs_pa to vmcs12_pa for better readability.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
[Remove SVM stubs, add KVM_STATE_NESTED_VMX_VMCS12_SIZE. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virtual/kvm/api.txt     | 46 +++++++++++++-------
 arch/x86/include/uapi/asm/kvm.h       | 33 ++++++++++-----
 arch/x86/kvm/vmx/nested.c             | 79 +++++++++++++++++++----------------
 arch/x86/kvm/vmx/vmcs12.h             |  5 ++-
 tools/arch/x86/include/uapi/asm/kvm.h |  2 +-
 5 files changed, 101 insertions(+), 64 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index f5616b441af8..2a4531bb06bd 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3857,43 +3857,59 @@ Type: vcpu ioctl
 Parameters: struct kvm_nested_state (in/out)
 Returns: 0 on success, -1 on error
 Errors:
-  E2BIG:     the total state size (including the fixed-size part of struct
-             kvm_nested_state) exceeds the value of 'size' specified by
+  E2BIG:     the total state size exceeds the value of 'size' specified by
              the user; the size required will be written into size.
 
 struct kvm_nested_state {
 	__u16 flags;
 	__u16 format;
 	__u32 size;
+
 	union {
-		struct kvm_vmx_nested_state vmx;
-		struct kvm_svm_nested_state svm;
+		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
+
+		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
-	};
-	__u8 data[0];
+	} hdr;
+
+	union {
+		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
+	} data;
 };
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
+#define KVM_STATE_NESTED_EVMCS		0x00000004
 
-#define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
-#define KVM_STATE_NESTED_SMM_VMXON	0x00000002
+#define KVM_STATE_NESTED_FORMAT_VMX		0
+#define KVM_STATE_NESTED_FORMAT_SVM		1
 
-struct kvm_vmx_nested_state {
+#define KVM_STATE_NESTED_VMX_VMCS_SIZE		0x1000
+
+#define KVM_STATE_NESTED_VMX_SMM_GUEST_MODE	0x00000001
+#define KVM_STATE_NESTED_VMX_SMM_VMXON		0x00000002
+
+struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
-	__u64 vmcs_pa;
+	__u64 vmcs12_pa;
 
 	struct {
 		__u16 flags;
 	} smm;
 };
 
+struct kvm_vmx_nested_state_data {
+	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+};
+
 This ioctl copies the vcpu's nested virtualization state from the kernel to
 userspace.
 
-The maximum size of the state, including the fixed-size part of struct
-kvm_nested_state, can be retrieved by passing KVM_CAP_NESTED_STATE to
-the KVM_CHECK_EXTENSION ioctl().
+The maximum size of the state can be retrieved by passing KVM_CAP_NESTED_STATE
+to the KVM_CHECK_EXTENSION ioctl().
 
 4.115 KVM_SET_NESTED_STATE
 
@@ -3903,8 +3919,8 @@ Type: vcpu ioctl
 Parameters: struct kvm_nested_state (in)
 Returns: 0 on success, -1 on error
 
-This copies the vcpu's kvm_nested_state struct from userspace to the kernel.  For
-the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
+This copies the vcpu's kvm_nested_state struct from userspace to the kernel.
+For the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
 
 4.116 KVM_(UN)REGISTER_COALESCED_MMIO
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7a0e64ccd6ff..d6ab5b4d15e5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -383,6 +383,9 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
 
+#define KVM_STATE_NESTED_FORMAT_VMX	0
+#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
@@ -390,9 +393,16 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
-struct kvm_vmx_nested_state {
+#define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
+
+struct kvm_vmx_nested_state_data {
+	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+};
+
+struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
-	__u64 vmcs_pa;
+	__u64 vmcs12_pa;
 
 	struct {
 		__u16 flags;
@@ -401,24 +411,25 @@ struct kvm_vmx_nested_state {
 
 /* for KVM_CAP_NESTED_STATE */
 struct kvm_nested_state {
-	/* KVM_STATE_* flags */
 	__u16 flags;
-
-	/* 0 for VMX, 1 for SVM.  */
 	__u16 format;
-
-	/* 128 for SVM, 128 + VMCS size for VMX.  */
 	__u32 size;
 
 	union {
-		/* VMXON, VMCS */
-		struct kvm_vmx_nested_state vmx;
+		struct kvm_vmx_nested_state_hdr vmx;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
-	};
+	} hdr;
 
-	__u8 data[0];
+	/*
+	 * Define data region as 0 bytes to preserve backwards-compatability
+	 * to old definition of kvm_nested_state in order to avoid changing
+	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
+	 */
+	union {
+		struct kvm_vmx_nested_state_data vmx[0];
+	} data;
 };
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d3940da3d435..fb6d1f7b43f3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5226,14 +5226,16 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	struct vmcs12 *vmcs12;
 	struct kvm_nested_state kvm_state = {
 		.flags = 0,
-		.format = 0,
+		.format = KVM_STATE_NESTED_FORMAT_VMX,
 		.size = sizeof(kvm_state),
-		.vmx.vmxon_pa = -1ull,
-		.vmx.vmcs_pa = -1ull,
+		.hdr.vmx.vmxon_pa = -1ull,
+		.hdr.vmx.vmcs12_pa = -1ull,
 	};
+	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
+		&user_kvm_nested_state->data.vmx[0];
 
 	if (!vcpu)
-		return kvm_state.size + 2 * VMCS12_SIZE;
+		return kvm_state.size + sizeof(*user_vmx_nested_state);
 
 	vmx = to_vmx(vcpu);
 	vmcs12 = get_vmcs12(vcpu);
@@ -5243,23 +5245,23 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 	if (nested_vmx_allowed(vcpu) &&
 	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
-		kvm_state.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
-		kvm_state.vmx.vmcs_pa = vmx->nested.current_vmptr;
+		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
+		kvm_state.hdr.vmx.vmcs12_pa = vmx->nested.current_vmptr;
 
 		if (vmx_has_valid_vmcs12(vcpu)) {
-			kvm_state.size += VMCS12_SIZE;
+			kvm_state.size += sizeof(user_vmx_nested_state->vmcs12);
 
 			if (is_guest_mode(vcpu) &&
 			    nested_cpu_has_shadow_vmcs(vmcs12) &&
 			    vmcs12->vmcs_link_pointer != -1ull)
-				kvm_state.size += VMCS12_SIZE;
+				kvm_state.size += sizeof(user_vmx_nested_state->shadow_vmcs12);
 		}
 
 		if (vmx->nested.smm.vmxon)
-			kvm_state.vmx.smm.flags |= KVM_STATE_NESTED_SMM_VMXON;
+			kvm_state.hdr.vmx.smm.flags |= KVM_STATE_NESTED_SMM_VMXON;
 
 		if (vmx->nested.smm.guest_mode)
-			kvm_state.vmx.smm.flags |= KVM_STATE_NESTED_SMM_GUEST_MODE;
+			kvm_state.hdr.vmx.smm.flags |= KVM_STATE_NESTED_SMM_GUEST_MODE;
 
 		if (is_guest_mode(vcpu)) {
 			kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
@@ -5294,16 +5296,19 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 			copy_shadow_to_vmcs12(vmx);
 	}
 
+	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);
+	BUILD_BUG_ON(sizeof(user_vmx_nested_state->shadow_vmcs12) < VMCS12_SIZE);
+
 	/*
 	 * Copy over the full allocated size of vmcs12 rather than just the size
 	 * of the struct.
 	 */
-	if (copy_to_user(user_kvm_nested_state->data, vmcs12, VMCS12_SIZE))
+	if (copy_to_user(user_vmx_nested_state->vmcs12, vmcs12, VMCS12_SIZE))
 		return -EFAULT;
 
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
 	    vmcs12->vmcs_link_pointer != -1ull) {
-		if (copy_to_user(user_kvm_nested_state->data + VMCS12_SIZE,
+		if (copy_to_user(user_vmx_nested_state->shadow_vmcs12,
 				 get_shadow_vmcs12(vcpu), VMCS12_SIZE))
 			return -EFAULT;
 	}
@@ -5331,33 +5336,35 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12;
 	u32 exit_qual;
+	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
+		&user_kvm_nested_state->data.vmx[0];
 	int ret;
 
-	if (kvm_state->format != 0)
+	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_VMX)
 		return -EINVAL;
 
 	if (!nested_vmx_allowed(vcpu))
-		return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
+		return kvm_state->hdr.vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
 
-	if (kvm_state->vmx.vmxon_pa == -1ull) {
-		if (kvm_state->vmx.smm.flags)
+	if (kvm_state->hdr.vmx.vmxon_pa == -1ull) {
+		if (kvm_state->hdr.vmx.smm.flags)
 			return -EINVAL;
 
-		if (kvm_state->vmx.vmcs_pa != -1ull)
+		if (kvm_state->hdr.vmx.vmcs12_pa != -1ull)
 			return -EINVAL;
 
 		vmx_leave_nested(vcpu);
 		return 0;
 	}
 
-	if (!page_address_valid(vcpu, kvm_state->vmx.vmxon_pa))
+	if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
 		return -EINVAL;
 
-	if ((kvm_state->vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
+	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
 	    (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return -EINVAL;
 
-	if (kvm_state->vmx.smm.flags &
+	if (kvm_state->hdr.vmx.smm.flags &
 	    ~(KVM_STATE_NESTED_SMM_GUEST_MODE | KVM_STATE_NESTED_SMM_VMXON))
 		return -EINVAL;
 
@@ -5366,21 +5373,21 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	 * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
 	 * must be zero.
 	 */
-	if (is_smm(vcpu) ? kvm_state->flags : kvm_state->vmx.smm.flags)
+	if (is_smm(vcpu) ? kvm_state->flags : kvm_state->hdr.vmx.smm.flags)
 		return -EINVAL;
 
-	if ((kvm_state->vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
-	    !(kvm_state->vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON))
+	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
+	    !(kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON))
 		return -EINVAL;
 
 	vmx_leave_nested(vcpu);
-	if (kvm_state->vmx.vmxon_pa == -1ull)
+	if (kvm_state->hdr.vmx.vmxon_pa == -1ull)
 		return 0;
 
 	if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
 		nested_enable_evmcs(vcpu, NULL);
 
-	vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
+	vmx->nested.vmxon_ptr = kvm_state->hdr.vmx.vmxon_pa;
 	ret = enter_vmx_operation(vcpu);
 	if (ret)
 		return ret;
@@ -5389,12 +5396,12 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->size < sizeof(*kvm_state) + sizeof(*vmcs12))
 		return 0;
 
-	if (kvm_state->vmx.vmcs_pa != -1ull) {
-		if (kvm_state->vmx.vmcs_pa == kvm_state->vmx.vmxon_pa ||
-		    !page_address_valid(vcpu, kvm_state->vmx.vmcs_pa))
+	if (kvm_state->hdr.vmx.vmcs12_pa != -1ull) {
+		if (kvm_state->hdr.vmx.vmcs12_pa == kvm_state->hdr.vmx.vmxon_pa ||
+		    !page_address_valid(vcpu, kvm_state->hdr.vmx.vmcs12_pa))
 			return -EINVAL;
 
-		set_current_vmptr(vmx, kvm_state->vmx.vmcs_pa);
+		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
 	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
 		/*
 		 * Sync eVMCS upon entry as we may not have
@@ -5405,16 +5412,16 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
-	if (kvm_state->vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON) {
+	if (kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON) {
 		vmx->nested.smm.vmxon = true;
 		vmx->nested.vmxon = false;
 
-		if (kvm_state->vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE)
+		if (kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE)
 			vmx->nested.smm.guest_mode = true;
 	}
 
 	vmcs12 = get_vmcs12(vcpu);
-	if (copy_from_user(vmcs12, user_kvm_nested_state->data, sizeof(*vmcs12)))
+	if (copy_from_user(vmcs12, user_vmx_nested_state->vmcs12, sizeof(*vmcs12)))
 		return -EFAULT;
 
 	if (vmcs12->hdr.revision_id != VMCS12_REVISION)
@@ -5431,12 +5438,14 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	    vmcs12->vmcs_link_pointer != -1ull) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
 
-		if (kvm_state->size < sizeof(*kvm_state) + VMCS12_SIZE + sizeof(*vmcs12))
+		if (kvm_state->size <
+		    sizeof(*kvm_state) +
+		    sizeof(user_vmx_nested_state->vmcs12) + sizeof(*shadow_vmcs12))
 			goto error_guest_mode;
 
 		if (copy_from_user(shadow_vmcs12,
-				   user_kvm_nested_state->data + VMCS12_SIZE,
-				   sizeof(*vmcs12))) {
+				   user_vmx_nested_state->shadow_vmcs12,
+				   sizeof(*shadow_vmcs12))) {
 			ret = -EFAULT;
 			goto error_guest_mode;
 		}
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 3a742428ad17..337718fc8a36 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -201,9 +201,10 @@ struct __packed vmcs12 {
 /*
  * VMCS12_SIZE is the number of bytes L1 should allocate for the VMXON region
  * and any VMCS region. Although only sizeof(struct vmcs12) are used by the
- * current implementation, 4K are reserved to avoid future complications.
+ * current implementation, 4K are reserved to avoid future complications and
+ * to preserve userspace ABI.
  */
-#define VMCS12_SIZE 0x1000
+#define VMCS12_SIZE		KVM_STATE_NESTED_VMX_VMCS_SIZE
 
 /*
  * VMCS12_MAX_FIELD_INDEX is the highest index value used in any
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 7a0e64ccd6ff..24a8cd229df6 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -392,7 +392,7 @@ struct kvm_sync_regs {
 
 struct kvm_vmx_nested_state {
 	__u64 vmxon_pa;
-	__u64 vmcs_pa;
+	__u64 vmcs12_pa;
 
 	struct {
 		__u16 flags;
-- 
1.8.3.1

