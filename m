Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595051157CC
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 20:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLFTcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 14:32:08 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:35998 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfLFTcH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 14:32:07 -0500
Received: by mail-pj1-f73.google.com with SMTP id h6so788176pju.3
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 11:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=j4XRHZCw0G2Q9oTbXX5ca2bK+8yfDz21ed70QhN9JTs=;
        b=RRvSp2mJGwiPRXJINZ0d820tblpaR+vgxnDgRXYJ37hlvL+LDcNMD3idv+oMM5CeYW
         9ftVgLfbCH5tXV/lu5zWDBFDlQlYG4oi5gNNEmBzMy/CjTgiuGG8ZEZy3yWR9JAPn5g5
         CCPkN4FJ1B16fE2+aNjtImSXc/qUouGnn9Nkp8fDyGEDMBlGkHnlWRMCz5zO13ejE5vm
         8lKZaowfg1W4gq6bbabcGihDfGrMff3v62RDM1IYS42rfk3PIAk1/i79xipFIDy9OWtg
         mosBge7FW6dkeoMS/pHwo0YcVVam4Z1QSH8+UWiipb7HKaGc2v5gZ+7TUn5UgFjuKOVK
         Xx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=j4XRHZCw0G2Q9oTbXX5ca2bK+8yfDz21ed70QhN9JTs=;
        b=Wz9XodCmUG7zzglCSDj5ioDtCyVvyee+fcrp1xWQf1dtGr7YjSd/Bf7xQCSSVBJfe1
         NzWsUhhgO6Tu7Nd1HU/UT0PO5zHBVCGLVlaQD5yaqzedrP9AHTrD6JoLKxwpnLQSGHX4
         3ps67vbOsqYwVJMXoDmK4boHMXdTdzxFOiOdkhcRpLtu5X79jivDkExKNeJkAh0TPPi2
         k6rdHHaw8cJwKn/yghOlSP+UzHkHZxmOOG14bFvV5c3bY7kyhUy3YCcnjwhHweBTLiUI
         yxSAlAa8SUAwVzZnpmJhoD8pZ7tTmQ2bBYAo7rzR3B/BREeF3Vh9FQl61RQV+nzfqr+f
         /W/w==
X-Gm-Message-State: APjAAAWVjVSDrZJJ/yE7IBSJvVeAcVE6ZNhGab+x8JbRM1e9SWJf8zgh
        jreiayYUmLSjRev0A2sOmHZC7Kbm1MCRbGbjktEyaAQYJjgwfejEPnrvy1O5xQKHJZuMCEWV0pD
        6jLB7Z3D7GrSZ2d/OnrOEVWgc8GqQVjUrf2s8JpCnoOrcVegUc5PGBaz59UGvdPw=
X-Google-Smtp-Source: APXvYqxdez10mu0I4p1MtnMG/cWtZiGAnGVGCCJ1MOJqdhnLTC4izjs6+s8F/hnISExGQip6H+TRsw5ABwG7Iw==
X-Received: by 2002:a65:6451:: with SMTP id s17mr5345865pgv.188.1575660726256;
 Fri, 06 Dec 2019 11:32:06 -0800 (PST)
Date:   Fri,  6 Dec 2019 11:31:42 -0800
Message-Id: <20191206193144.33209-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v2 1/3] kvm: nVMX: VMWRITE checks VMCS-link pointer before
 VMCS field
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jon Cargille <jcargill@google.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
---
v1 -> v2:
 * Split the invalid VMCS-link pointer check from the conditional call to
   copy_vmcs02_to_vmcs12_rare.
 * Hoisted the assignment of vmcs12 to its declaration.
 * Modified handle_vmread to maintain consistency with handle_vmwrite.

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

