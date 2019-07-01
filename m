Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70AC4746E
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2019 14:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfFPMGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jun 2019 08:06:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfFPMGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jun 2019 08:06:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5GC3eSj071452;
        Sun, 16 Jun 2019 12:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=X5BLlRDKXxesc6S7lDaQlXpX1xLar59hH5fbK45ThRA=;
 b=wep0UUC+2w8gShJekL4i+lh1U5XZ0CwXl6GWKkum8yhP8yAzF0MNVKRBDN0Iawuj/RHP
 QdTjqb3d3cfBi3DbMNxwdwLjHdKmizkmL8WcjXR21cC07sQBZiB+y5Vn7vCWsVUvSa79
 Em0jNbc5EqGpq6CLn2srTXPY6JYOaXf5PJItncyZWj6f3EB26KqjNowknAKI/zCwiLz0
 BIcPdqP8XI35Cw1S4wx7pwtnlvXKF1fIu8gkSX3zeFwfrI+nnLN94v72UvWbbF2htJJ+
 bWcSFhazf0LMPNrGLlff/DtcpWnrlITiK09cEB16T0NzKBwnraEHbgHB3djig5yJl3ri Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t4r3tawmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jun 2019 12:05:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5GC390Q083861;
        Sun, 16 Jun 2019 12:03:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t5cpd3e15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jun 2019 12:03:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5GC3WBH012738;
        Sun, 16 Jun 2019 12:03:32 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Jun 2019 05:03:31 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     jmattson@google.com, maran.wilson@oracle.com,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH] KVM: x86: Modify struct kvm_nested_state to have explicit fields for data
Date:   Sun, 16 Jun 2019 15:03:10 +0300
Message-Id: <20190616120310.128373-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9289 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=529
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906160117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9289 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=569 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906160117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
* Add stub structs for AMD SVM.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 Documentation/virtual/kvm/api.txt | 44 +++++++++++------
 arch/x86/include/uapi/asm/kvm.h   | 41 +++++++++++-----
 arch/x86/kvm/vmx/nested.c         | 79 +++++++++++++++++--------------
 3 files changed, 103 insertions(+), 61 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ba6c42c576dd..082e33fbf606 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3857,43 +3857,57 @@ Type: vcpu ioctl
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
+
+#define KVM_STATE_NESTED_FORMAT_VMX		0
+#define KVM_STATE_NESTED_FORMAT_SVM		1
 
-#define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
-#define KVM_STATE_NESTED_SMM_VMXON	0x00000002
+#define KVM_STATE_NESTED_VMX_SMM_GUEST_MODE	0x00000001
+#define KVM_STATE_NESTED_VMX_SMM_VMXON		0x00000002
 
-struct kvm_vmx_nested_state {
+struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
-	__u64 vmcs_pa;
+	__u64 vmcs12_pa;
 
 	struct {
 		__u16 flags;
 	} smm;
 };
 
+struct kvm_vmx_nested_state_data {
+	__u8 vmcs12[0x1000];
+	__u8 shadow_vmcs12[0x1000];
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
 
@@ -3903,8 +3917,8 @@ Type: vcpu ioctl
 Parameters: struct kvm_nested_state (in)
 Returns: 0 on success, -1 on error
 
-This copies the vcpu's kvm_nested_state struct from userspace to the kernel.  For
-the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
+This copies the vcpu's kvm_nested_state struct from userspace to the kernel.
+For the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
 
 4.116 KVM_(UN)REGISTER_COALESCED_MMIO
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7a0e64ccd6ff..e655d108af19 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -383,6 +383,9 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
 
+#define KVM_STATE_NESTED_FORMAT_VMX	0
+#define KVM_STATE_NESTED_FORMAT_SVM	1
+
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
@@ -390,35 +393,51 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
-struct kvm_vmx_nested_state {
+struct kvm_vmx_nested_state_data {
+	__u8 vmcs12[0x1000];
+	__u8 shadow_vmcs12[0x1000];
+};
+
+struct kvm_vmx_nested_state_hdr {
 	__u64 vmxon_pa;
-	__u64 vmcs_pa;
+	__u64 vmcs12_pa;
 
 	struct {
 		__u16 flags;
 	} smm;
 };
 
+struct kvm_svm_nested_state_data {
+	/* TODO: Implement */
+};
+
+struct kvm_svm_nested_state_hdr {
+	/* TODO: Implement */
+};
+
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
+		struct kvm_svm_nested_state_hdr svm;
 
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
+		struct kvm_svm_nested_state_data svm[0];
+	} data;
 };
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1032f068f0b9..5c470db311f7 100644
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
-- 
2.20.1

