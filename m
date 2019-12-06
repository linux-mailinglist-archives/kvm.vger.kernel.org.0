Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C141159BF
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfLFXqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:46:48 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:56765 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLFXqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:46:48 -0500
Received: by mail-pf1-f202.google.com with SMTP id j7so4902318pfh.23
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 15:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=y+19aKtY4EbBtyHli0gL/tj0TPv6Yayq8480kA5pLQM=;
        b=Q/Bw9UGvsan3MQgEECqz5rz8WNiHQEfJ9kQVCGEQJqiYZdN7EDRRj2X9oq/NNxRUtr
         amcDCuTnkR0lUSzstsIOxo6y7T78WJy7hAaaQPu05YDA/fKXw82dswmVSKaBlnkKAGVe
         ozjXPj8xxtwL0hT62VcpZy35c4qnKsdgPi0UMxs/O2zPveISWYffhdL4QEhUQfiCNMUy
         wj4TZWZXDCebqRab7X9L0J4aQKWJPTezfu0gb7bU6FzEjKbZXkkBO10Tg42sopP6ZK/0
         oMpcc2oiGxodgrKgg+RxYiFJidXtD2PDpRBuILvyyMIMI3S2HMZuUGdQV8MFKADdQd8r
         D0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=y+19aKtY4EbBtyHli0gL/tj0TPv6Yayq8480kA5pLQM=;
        b=FSHe5SFUiE5JNC3J+3pzDaoQd9PXJGf8vwSoRwo01A+ZtvKwXgqJpp7mQaT5CEF9CM
         thr2k0UrgeBcF4jzVwJrtqtVZ27L0eL+uVk4MzvJ14AToxXGyUZP8xUuHha6aQomTR2s
         qd87t+bsktFgPiy2YEnlVSI/aYwVrDsygAS8OyMlpYzkMF8ZwrToYdMNYybQdr3g8XEj
         Y57Le7ydFhGpP3yyXAUXaD4JUai9fYRbcb7Fm0vqRzTRFgAO1gfsJneC8YGfmhaVM/Oc
         k7EOayJRDa4vRev1jgNtNDqfzM073Nb7clZaTyZj5Vd8gzGusVEXFhTQ8fZCOC5FTBkH
         ocJg==
X-Gm-Message-State: APjAAAX92URGL3KoBtwbnJjYrPWUs9o+neTJk959QW+siQ8+3mp70rgh
        m5W7WkCOR4OYK0+MBryZLAWfkin7BAeilvJnV8xYSvUH/BseZYQbwcz5CcsbGnvEevckvpcwbtP
        7pZvpDJhNSHNMreZ1Gj/5omfMn5kF8XjnYhxqeImHhuQqEn6QtfGkbxAHEUazSqQ=
X-Google-Smtp-Source: APXvYqw39BeYdk7jH0zVdelpeLBdC4zRpUvP8KvdtXmV8mrLSW6bHeCDxEGMuQ6TUkxHkClH+aJItPWkuaLCwQ==
X-Received: by 2002:a63:7311:: with SMTP id o17mr6103845pgc.29.1575676007030;
 Fri, 06 Dec 2019 15:46:47 -0800 (PST)
Date:   Fri,  6 Dec 2019 15:46:35 -0800
Message-Id: <20191206234637.237698-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v3 1/3] kvm: nVMX: VMWRITE checks VMCS-link pointer before
 VMCS field
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, a VMWRITE in VMX non-root operation with an
invalid VMCS-link pointer results in VMfailInvalid before the validity
of the VMCS field in the secondary source operand is checked.

For consistency, modify both handle_vmwrite and handle_vmread, even
though there was no problem with the latter.

Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
---
v1 -> v2:
 * Split the invalid VMCS-link pointer check from the conditional call to
   copy_vmcs02_to_vmcs12_rare.
 * Hoisted the assignment of vmcs12 to its declaration.
 * Modified handle_vmread to maintain consistency with handle_vmwrite.
v2 -> v3:
 * No changes

 arch/x86/kvm/vmx/nested.c | 59 +++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..ee1bf9710e86 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4753,32 +4753,28 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 {
 	unsigned long field;
 	u64 field_value;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	int len;
 	gva_t gva = 0;
-	struct vmcs12 *vmcs12;
+	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
+						    : get_vmcs12(vcpu);
 	struct x86_exception e;
 	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (to_vmx(vcpu)->nested.current_vmptr == -1ull)
+	/*
+	 * In VMX non-root operation, when the VMCS-link pointer is -1ull,
+	 * any VMREAD sets the ALU flags for VMfailInvalid.
+	 */
+	if (vmx->nested.current_vmptr == -1ull ||
+	    (is_guest_mode(vcpu) &&
+	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
-	if (!is_guest_mode(vcpu))
-		vmcs12 = get_vmcs12(vcpu);
-	else {
-		/*
-		 * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
-		 * to shadowed-field sets the ALU flags for VMfailInvalid.
-		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
-			return nested_vmx_failInvalid(vcpu);
-		vmcs12 = get_shadow_vmcs12(vcpu);
-	}
-
 	/* Decode instruction info and find the field to read */
 	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
@@ -4855,13 +4851,20 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 */
 	u64 field_value = 0;
 	struct x86_exception e;
-	struct vmcs12 *vmcs12;
+	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
+						    : get_vmcs12(vcpu);
 	short offset;
 
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
-	if (vmx->nested.current_vmptr == -1ull)
+	/*
+	 * In VMX non-root operation, when the VMCS-link pointer is -1ull,
+	 * any VMWRITE sets the ALU flags for VMfailInvalid.
+	 */
+	if (vmx->nested.current_vmptr == -1ull ||
+	    (is_guest_mode(vcpu) &&
+	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
 		return nested_vmx_failInvalid(vcpu);
 
 	if (vmx_instruction_info & (1u << 10))
@@ -4889,24 +4892,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
 
-	if (!is_guest_mode(vcpu)) {
-		vmcs12 = get_vmcs12(vcpu);
-
-		/*
-		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
-		 * vmcs12, else we may crush a field or consume a stale value.
-		 */
-		if (!is_shadow_field_rw(field))
-			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
-	} else {
-		/*
-		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
-		 * to shadowed-field sets the ALU flags for VMfailInvalid.
-		 */
-		if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
-			return nested_vmx_failInvalid(vcpu);
-		vmcs12 = get_shadow_vmcs12(vcpu);
-	}
+	/*
+	 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
+	 * vmcs12, else we may crush a field or consume a stale value.
+	 */
+	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
+		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
-- 
2.24.0.393.g34dc348eaf-goog

