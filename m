Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359C745D2C4
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbhKYCDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353054AbhKYCBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:11 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5490C0619E3
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:45 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id e9-20020a170902ed8900b00143a3f40299so1497192plj.20
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=A381KQolCCsHfRuwkY2i42DcKKlghmd39ZU2IuoWaYM=;
        b=mflywid/Fe7clpzGyQliGhAS9vWGRI09WUjkkblwTQ4iz12UATEb4wRdzbhTgre05k
         Gzw44WjSH0aMe6Hby5lI6pcHGAGSbOoIbhYsTxOMAKlaw9hzFfDFFGc8NbBi7Du4inXB
         DJdWyZJyv79sI4NH28OuiJvRpY9eA68hiAbikOMjsZeRELvxtoLgdqKfiavYZ3SEmjEv
         8FxsqajOg904H9VWnOabnBFfMWtvz7RKxZkVNyDw1AY9JqcY/iPW/2vy/adDb59xGGRM
         SqOVi6/6nc862Wl1UajtwBslpt95yD+Ev9l0UDlvUeAOpk03R9t92oCCK679yKJVw6rs
         PYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=A381KQolCCsHfRuwkY2i42DcKKlghmd39ZU2IuoWaYM=;
        b=quPHF6BwTVRImjTIl8iX8B0cm1szg6uTWbq0WA6fNVfy3y8nF7YWrY+Vv7E3lbItJX
         aSo/CUXdvQxRX7ui9eUua6smMXQJGNgzmMjpnlbyj2+m32EGuaHn63zQuAKrgmzRkgB4
         kgq5c3yCgD0xdxJx7eaqHLxvKcRHQ2CleySOAjUOEZ0zRQTpPuSXMO8J+C9qiXFpaTFi
         xDnGsh5N2cDzsQ74EIMeqrNZndvu9ixeXpnWIt3zflslvS9snSOMJCCSzZowSmju+PXH
         Rbq16A89OeSO+l4rq+m51KEkDhZbFk+BVVBma/EZaAwP8c3rzx7MqHztoqhnDD1Hyf4k
         ZX4w==
X-Gm-Message-State: AOAM532H5tncwgFlsQyEBBYbTXgHu+eKxnqq3i65ANF2opPQfC3tL9aB
        dw4G+UfPwJg/ZEW1U7mM0lvri8K7xnw=
X-Google-Smtp-Source: ABdhPJzLHxvtQJFqgrR5N1YDjERcJMALjUM+FTBB/tGCoa7iT6buxFjeHuz2cbcYlhBOYVQ5kDiGn9wO7EA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a9cb:b0:143:d9ad:d154 with SMTP id
 b11-20020a170902a9cb00b00143d9add154mr25051009plr.6.1637803785416; Wed, 24
 Nov 2021 17:29:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:46 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-29-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 28/39] nVMX: Remove "v1" version of INVVPID test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yank out the old INVVPID and drop the version info from the new test,
which is a complete superset.  That, and the old test was apparently
trying to win an obfuscated C contest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 91 ++-----------------------------------------------
 1 file changed, 2 insertions(+), 89 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 78a53e1..507e485 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1545,92 +1545,6 @@ static int eptad_exit_handler(union exit_reason exit_reason)
 	return ept_exit_handler_common(exit_reason, true);
 }
 
-static bool invvpid_test(int type, u16 vpid)
-{
-	bool ret, supported;
-
-	supported = ept_vpid.val &
-		(VPID_CAP_INVVPID_ADDR >> INVVPID_ADDR << type);
-	ret = __invvpid(type, vpid, 0);
-
-	if (ret == !supported)
-		return false;
-
-	if (!supported)
-		printf("WARNING: unsupported invvpid passed!\n");
-	else
-		printf("WARNING: invvpid failed!\n");
-
-	return true;
-}
-
-static int vpid_init(struct vmcs *vmcs)
-{
-	u32 ctrl_cpu1;
-
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
-		!(ctrl_cpu_rev[1].clr & CPU_VPID)) {
-		printf("\tVPID is not supported");
-		return VMX_TEST_EXIT;
-	}
-
-	ctrl_cpu1 = vmcs_read(CPU_EXEC_CTRL1);
-	ctrl_cpu1 |= CPU_VPID;
-	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu1);
-	return VMX_TEST_START;
-}
-
-static void vpid_main(void)
-{
-	vmx_set_test_stage(0);
-	vmcall();
-	report(vmx_get_test_stage() == 1, "INVVPID SINGLE ADDRESS");
-	vmx_set_test_stage(2);
-	vmcall();
-	report(vmx_get_test_stage() == 3, "INVVPID SINGLE");
-	vmx_set_test_stage(4);
-	vmcall();
-	report(vmx_get_test_stage() == 5, "INVVPID ALL");
-}
-
-static int vpid_exit_handler(union exit_reason exit_reason)
-{
-	u64 guest_rip;
-	u32 insn_len;
-
-	guest_rip = vmcs_read(GUEST_RIP);
-	insn_len = vmcs_read(EXI_INST_LEN);
-
-	switch (exit_reason.basic) {
-	case VMX_VMCALL:
-		switch(vmx_get_test_stage()) {
-		case 0:
-			if (!invvpid_test(INVVPID_ADDR, 1))
-				vmx_inc_test_stage();
-			break;
-		case 2:
-			if (!invvpid_test(INVVPID_CONTEXT_GLOBAL, 1))
-				vmx_inc_test_stage();
-			break;
-		case 4:
-			if (!invvpid_test(INVVPID_ALL, 1))
-				vmx_inc_test_stage();
-			break;
-		default:
-			report_fail("ERROR: unexpected stage, %d",
-					vmx_get_test_stage());
-			print_vmexit_info(exit_reason);
-			return VMX_TEST_VMEXIT;
-		}
-		vmcs_write(GUEST_RIP, guest_rip + insn_len);
-		return VMX_TEST_RESUME;
-	default:
-		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
-		print_vmexit_info(exit_reason);
-	}
-	return VMX_TEST_VMEXIT;
-}
-
 #define TIMER_VECTOR	222
 
 static volatile bool timer_fired;
@@ -3391,7 +3305,7 @@ static void invvpid_test_not_in_vmx_operation(void)
  * This does not test real-address mode, virtual-8086 mode, protected mode,
  * or CPL > 0.
  */
-static void invvpid_test_v2(void)
+static void invvpid_test(void)
 {
 	u64 msr;
 	int i;
@@ -10770,7 +10684,6 @@ struct vmx_test vmx_tests[] = {
 	{ "EPT A/D disabled", ept_init, ept_main, ept_exit_handler, NULL, {0} },
 	{ "EPT A/D enabled", eptad_init, eptad_main, eptad_exit_handler, NULL, {0} },
 	{ "PML", pml_init, pml_main, pml_exit_handler, NULL, {0} },
-	{ "VPID", vpid_init, vpid_main, vpid_exit_handler, NULL, {0} },
 	{ "interrupt", interrupt_init, interrupt_main,
 		interrupt_exit_handler, NULL, {0} },
 	{ "nmi_hlt", nmi_hlt_init, nmi_hlt_main,
@@ -10794,7 +10707,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(fixture_test_case1),
 	TEST(fixture_test_case2),
 	/* Opcode tests. */
-	TEST(invvpid_test_v2),
+	TEST(invvpid_test),
 	/* VM-entry tests */
 	TEST(vmx_controls_test),
 	TEST(vmx_host_state_area_test),
-- 
2.34.0.rc2.393.gf8c9666880-goog

