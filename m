Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA68F3B0F44
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVVNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVVNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:13:47 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54AEC061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:11:30 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id d194-20020a3768cb0000b02903ad9d001bb6so19594516qkc.7
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LyoahROe7s0PwQZzg7N7rFGMMHa0y7gIr86IufuOH3g=;
        b=GKq0jyi3DyJ/X8MU2FGGm6khylxhbRfqITYJLHfQA2pMq6octcnhu42hJ24VczJk6s
         cF3msCGqyRa6kcvUpwuCc6qlZJfflGgiA5v0hEG7iCogvcj+Zf574KY2qLQa/3orEq+0
         KcG9dt05QRApIz1jtxCvuJflnYBLY3aJYm3iMpgBMBU3g30qbq9rFnydpPkfTCkYyRut
         xRoeDT5/hIJcKZqfhG1bZ2ZxNye3lyWBU97Xs2rTWdMUF9Y4gRivI8Y+H6TOKbJDY43p
         TA/baeoiJASTiID+CMYxF95OLYubkJ3zkHX7DPon6YOYSvjB0XF1eZdrW1waYC8LCWSG
         Ujkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=LyoahROe7s0PwQZzg7N7rFGMMHa0y7gIr86IufuOH3g=;
        b=pNDenUiBxjKB3b//c6N6E9N5kD1i7/fjkMERlkgBaeI28OZUBDPudLVgEYUGwGFcKo
         sbl/kxRTIcbQSpZy9/k0DL/SIpjwCifD/kKoZOJlQEd5NF5yXOcs9Z8uzpHO9xc38/Tr
         TAO+bSwgviSxBSxP4xqwqXyxvyWxoyXxtoDi625M/x5jmEMEIxReKXdhLq/jfez8D8yd
         iLh0GRpesu0pUayy/RIYUhebY0JcQ9VYajIGHf1BFdt6zVhLslV8LZLwod5/u0H9xO9Z
         NKvf4XI2vnD3vhUyBvgXe2S1v5f2VXxmTpWoPtN3AsBZF+rvTX/t91p4cRjXzD079Ogm
         Xtag==
X-Gm-Message-State: AOAM531vpQ5FK7uFr1zETkapCpM9G29uPCQcZV7LWFI5zWMZL+om43ed
        LP7q9kzTEdzDb/WFaJvNjcUTCWf+js0=
X-Google-Smtp-Source: ABdhPJwihT8wMCF06BTU6cov6wIVivM90tX1PAbotbUvKkwNXo2p89GNz0qr2Nm/efyzCbaOx0D0u50rHQE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:d1c5:: with SMTP id i188mr7425192ybg.419.1624396289286;
 Tue, 22 Jun 2021 14:11:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:11:24 -0700
Message-Id: <20210622211124.3698119-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH] nVMX: Add a test to toggle host (L1) CR4.LA57
 on VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expand vmx_cr_load_test() to verify that KVM correclty handles toggling
L1's CR4.LA57 on nested VM-Exit.  LA57 can only be toggled in isolation
via VM-Exit, i.e. be the lone bit the causes a MMU role change, because
MOV CR4 #GPs if LA57 is changed while long mode is active.

Test both nested EPT and shadow paging (for L2); the latter will also
toggle KVM's guest_mode bit in the MMU role due to L1 and L2 sharing an
MMU context, but it obviously shouldn't break.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 12 +++++++++
 x86/vmx_tests.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 2c534ca..ebd014c 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -783,6 +783,18 @@ static inline u64 vmcs_read(enum Encoding enc)
 	return val;
 }
 
+/*
+ * VMREAD with a guaranteed memory operand, used to test KVM's MMU by forcing
+ * KVM to translate GVA->GPA.
+ */
+static inline u64 vmcs_readm(enum Encoding enc)
+{
+	u64 val;
+
+	asm volatile ("vmread %1, %0" : "=m" (val) : "r" ((u64)enc) : "cc");
+	return val;
+}
+
 static inline int vmcs_read_checking(enum Encoding enc, u64 *value)
 {
 	u64 rflags = read_rflags() | X86_EFLAGS_CF | X86_EFLAGS_ZF;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5b9faa2..4f712eb 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8369,9 +8369,16 @@ static void vmentry_movss_shadow_test(void)
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 }
 
+static void vmx_single_vmcall_guest(void)
+{
+	vmcall();
+}
+
 static void vmx_cr_load_test(void)
 {
 	unsigned long cr3, cr4, orig_cr3, orig_cr4;
+	u32 ctrls[2] = {0};
+	pgd_t *pml5;
 
 	orig_cr4 = read_cr4();
 	orig_cr3 = read_cr3();
@@ -8393,7 +8400,7 @@ static void vmx_cr_load_test(void)
 	TEST_ASSERT(!write_cr4_checking(cr4));
 	write_cr3(cr3);
 
-	test_set_guest(v2_null_test_guest);
+	test_set_guest(vmx_single_vmcall_guest);
 	vmcs_write(HOST_CR4, cr4);
 	vmcs_write(HOST_CR3, cr3);
 	enter_guest();
@@ -8412,6 +8419,65 @@ static void vmx_cr_load_test(void)
 	/* Cleanup L1 state. */
 	write_cr3(orig_cr3);
 	TEST_ASSERT(!write_cr4_checking(orig_cr4));
+
+	if (!this_cpu_has(X86_FEATURE_LA57))
+		goto done;
+
+	/*
+	 * Allocate a full page for PML5 to guarantee alignment, though only
+	 * the first entry needs to be filled (the test's virtual addresses
+	 * most definitely do not have any of bits 56:48 set).
+	 */
+	pml5 = alloc_page();
+	*pml5 = orig_cr3 | PT_PRESENT_MASK | PT_WRITABLE_MASK;
+
+	/*
+	 * Transition to/from 5-level paging in the host via VM-Exit.  CR4.LA57
+	 * can't be toggled while long is active via MOV CR4, but there are no
+	 * such restrictions on VM-Exit.
+	 */
+lol_5level:
+	vmcs_write(HOST_CR4, orig_cr4 | X86_CR4_LA57);
+	vmcs_write(HOST_CR3, virt_to_phys(pml5));
+	enter_guest();
+
+	/*
+	 * VMREAD with a memory operand to verify KVM detects the LA57 change,
+	 * e.g. uses the correct guest root level in gva_to_gpa().
+	 */
+	TEST_ASSERT(vmcs_readm(HOST_CR3) == virt_to_phys(pml5));
+	TEST_ASSERT(vmcs_readm(HOST_CR4) == (orig_cr4 | X86_CR4_LA57));
+
+	vmcs_write(HOST_CR4, orig_cr4);
+	vmcs_write(HOST_CR3, orig_cr3);
+	enter_guest();
+
+	TEST_ASSERT(vmcs_readm(HOST_CR3) == orig_cr3);
+	TEST_ASSERT(vmcs_readm(HOST_CR4) == orig_cr4);
+
+	/*
+	 * And now do the same LA57 shenanigans with EPT enabled.  KVM uses
+	 * two separate MMUs when L1 uses TDP, whereas the above shadow paging
+	 * version shares an MMU between L1 and L2.
+	 *
+	 * If the saved execution controls are non-zero then the EPT version
+	 * has already run.  In that case, restore the old controls.  If EPT
+	 * setup fails, e.g. EPT isn't supported, fall through and finish up.
+	 */
+	if (ctrls[0]) {
+		vmcs_write(CPU_EXEC_CTRL0, ctrls[0]);
+		vmcs_write(CPU_EXEC_CTRL1, ctrls[1]);
+	} else if (!setup_ept(false)) {
+		ctrls[0] = vmcs_read(CPU_EXEC_CTRL0);
+		ctrls[1]  = vmcs_read(CPU_EXEC_CTRL1);
+		goto lol_5level;
+	}
+
+	free_page(pml5);
+
+done:
+	skip_exit_vmcall();
+	enter_guest();
 }
 
 static void vmx_cr4_osxsave_test_guest(void)
-- 
2.32.0.288.g62a8d224e6-goog

