Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FCB5F16A2
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiI3XZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiI3XZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:25:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6D1B5155
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e187-20020a6369c4000000b0041c8dfb8447so3630247pgc.23
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=fDi8wRV5SYMy1Kx1OwJz2AhmwqAhK5Jw4Z8aN6lk0xw=;
        b=DXOb1tqXD1MXLtiY7E0MQLySkHHMBY7V3Zjvrs5hSrPSVmF815V9ThN0uPA5+/PQOi
         nCqsohNxn/4CONToKnQQj4u1AaJhaWhhTtONmWozpG09vsgtBZ3ioTKFnXTOISmWEWmp
         g04hAw+1T+Fih7homeaRtbYC0WnoPUFa6u6GJzzJ9t8BP6PLCvrlbLBwGIYJiXOyp+m2
         bJ4CBz928oldwDpP7p6Zor8I26XxcOo6UCa6AQ99oW62UsQloNkj021zVKuye909LMif
         u0c4JkyduLA0W2Oz6zlwqWF4D5tp9Sz8kQFy7GhQ3r7imth4ptg3JEC41xSDmoQ85UQC
         x0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=fDi8wRV5SYMy1Kx1OwJz2AhmwqAhK5Jw4Z8aN6lk0xw=;
        b=76fiorOKcMCBno5BmpClYPfA7f6xT7TA8sZDPP3x3DNTJHbfsKXYHibM9q78j1u0/j
         elR1zHc6zjJgFDDbzsQchWNUnVEDrYYt1z+o3PJpSzMBrm/Qa5FdO14b4R/jg64Rhb4v
         qWhuQ9Md4pWFZJvi9bePbVdRFlzHENldSrhbX78/IU2QFz8kV053Ju+s+qnXWhw2UFsY
         Xf81QFHqwwzN5WLuQJrSKHRCwWXikBbbPCkKziTmq6RnQYDXrmER4wiJ1K1y62cd42q8
         ZdYy8pkFvyLpDIp9kEqLXTMsv9K78myhycESTr5H3PqZYCywmYrEua53ipGmEiooO4+x
         vIpg==
X-Gm-Message-State: ACrzQf2Gvr3QUCUiTO6vMrAZIK9UI+2EWtXid8BZt5Rx/LBSTuA7cqyJ
        xQCHTLKLYOumpM/ayXYUDEaqEt8PJiA=
X-Google-Smtp-Source: AMsMyM5UM5FlGsfK/ElTxcIVbDjEzTKejYM5HR0E3cnlamT80xwO7FYN41le1luPq6dziW2d1Gq4XNjihOM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5fc4:0:b0:43d:c6cc:ef59 with SMTP id
 t187-20020a635fc4000000b0043dc6ccef59mr9369015pgb.585.1664580295217; Fri, 30
 Sep 2022 16:24:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:24:49 +0000
In-Reply-To: <20220930232450.1677811-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220930232450.1677811-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930232450.1677811-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/3] nVMX: Use ASM_TRY() for VMREAD and VMWRITE
 page fault tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use ASM_TRY() in the VMREAD and VMWRITE page fault tests to fix a bug
where gcc-12 completely optimizes out handler_called.  Because the flag
isn't tagged volatile and the compiler is unaware that an exception may
occur, gcc-12 thinks the value can only ever be 0.

Note, exception fixup effectively performs an exact RIP check, and using
LAHF to save RFLAGS drops the fixed RFLAGS bit.

Opportunistically drop the 'noinline' as removing the global label makes
the functions safe to inline/duplicate.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 135 ++++++++++++++++++++----------------------------------
 1 file changed, 49 insertions(+), 86 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index a13f2c9..0ae134d 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -387,25 +387,7 @@ static void test_vmwrite_vmread(void)
 	free_page(vmcs);
 }
 
-ulong finish_fault;
-u8 sentinel;
-bool handler_called;
-
-static void pf_handler(struct ex_regs *regs)
-{
-	/*
-	 * check that RIP was not improperly advanced and that the
-	 * flags value was preserved.
-	 */
-	report(regs->rip < finish_fault, "RIP has not been advanced!");
-	report(((u8)regs->rflags == ((sentinel | 2) & 0xd7)),
-	       "The low byte of RFLAGS was preserved!");
-	regs->rip = finish_fault;
-	handler_called = true;
-
-}
-
-static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
+static void prep_flags_test_env(void **vpage, struct vmcs **vmcs)
 {
 	/*
 	 * get an unbacked address that will cause a #PF
@@ -421,107 +403,88 @@ static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
 	(*vmcs)->hdr.revision_id = basic.revision;
 	assert(!vmcs_clear(*vmcs));
 	assert(!make_vmcs_current(*vmcs));
-
-	*old = handle_exception(PF_VECTOR, &pf_handler);
 }
 
-static noinline void test_read_sentinel(void)
+static void test_read_sentinel(u8 sentinel)
 {
-	void *vpage;
+	unsigned long flags = sentinel;
+	unsigned int vector;
 	struct vmcs *vmcs;
-	handler old;
+	void *vpage;
 
-	prep_flags_test_env(&vpage, &vmcs, &old);
+	prep_flags_test_env(&vpage, &vmcs);
 
 	/*
-	 * set the proper label
+	 * Execute VMREAD with a not-PRESENT memory operand, and verify a #PF
+	 * occurred and RFLAGS were not modified.
 	 */
-	extern char finish_read_fault;
+	asm volatile ("sahf\n\t"
+		      ASM_TRY("1f")
+		      "vmread %[enc], %[val]\n\t"
+		      "1: lahf"
+		      : [val] "=m" (*(u64 *)vpage),
+			[flags] "+a" (flags)
+		      : [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc");
 
-	finish_fault = (ulong)&finish_read_fault;
+	vector = exception_vector();
+	report(vector == PF_VECTOR,
+	       "Expected #PF on VMREAD, got exception 0x%x", vector);
 
-	/*
-	 * execute the vmread instruction that will cause a #PF
-	 */
-	handler_called = false;
-	asm volatile ("movb %[byte], %%ah\n\t"
-		      "sahf\n\t"
-		      "vmread %[enc], %[val]; finish_read_fault:"
-		      : [val] "=m" (*(u64 *)vpage)
-		      : [byte] "Krm" (sentinel),
-		      [enc] "r" ((u64)GUEST_SEL_SS)
-		      : "cc", "ah");
-	report(handler_called, "The #PF handler was invoked");
-
-	/*
-	 * restore the old #PF handler
-	 */
-	handle_exception(PF_VECTOR, old);
+	report((u8)flags == sentinel,
+	       "Expected RFLAGS 0x%x, got 0x%x", sentinel, (u8)flags);
 }
 
 static void test_vmread_flags_touch(void)
 {
 	/*
-	 * set up the sentinel value in the flags register. we
-	 * choose these two values because they candy-stripe
-	 * the 5 flags that sahf sets.
+	 * Test with two values to candy-stripe the 5 flags stored/loaded by
+	 * SAHF/LAHF.
 	 */
-	sentinel = 0x91;
-	test_read_sentinel();
-
-	sentinel = 0x45;
-	test_read_sentinel();
+	test_read_sentinel(0x91);
+	test_read_sentinel(0x45);
 }
 
-static noinline void test_write_sentinel(void)
+static void test_write_sentinel(u8 sentinel)
 {
-	void *vpage;
+	unsigned long flags = sentinel;
+	unsigned int vector;
 	struct vmcs *vmcs;
-	handler old;
+	void *vpage;
 
-	prep_flags_test_env(&vpage, &vmcs, &old);
+	prep_flags_test_env(&vpage, &vmcs);
 
 	/*
-	 * set the proper label
+	 * Execute VMWRITE with a not-PRESENT memory operand, and verify a #PF
+	 * occurred and RFLAGS were not modified.
 	 */
-	extern char finish_write_fault;
+	asm volatile ("sahf\n\t"
+		      ASM_TRY("1f")
+		      "vmwrite %[val], %[enc]\n\t"
+		      "1: lahf"
+		      : [val] "=m" (*(u64 *)vpage),
+			[flags] "+a" (flags)
+		      : [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc");
 
-	finish_fault = (ulong)&finish_write_fault;
+	vector = exception_vector();
+	report(vector == PF_VECTOR,
+	       "Expected #PF on VMWRITE, got exception '0x%x'\n", vector);
 
-	/*
-	 * execute the vmwrite instruction that will cause a #PF
-	 */
-	handler_called = false;
-	asm volatile ("movb %[byte], %%ah\n\t"
-		      "sahf\n\t"
-		      "vmwrite %[val], %[enc]; finish_write_fault:"
-		      : [val] "=m" (*(u64 *)vpage)
-		      : [byte] "Krm" (sentinel),
-		      [enc] "r" ((u64)GUEST_SEL_SS)
-		      : "cc", "ah");
-	report(handler_called, "The #PF handler was invoked");
-
-	/*
-	 * restore the old #PF handler
-	 */
-	handle_exception(PF_VECTOR, old);
+	report((u8)flags == sentinel,
+	       "Expected RFLAGS 0x%x, got 0x%x", sentinel, (u8)flags);
 }
 
 static void test_vmwrite_flags_touch(void)
 {
 	/*
-	 * set up the sentinel value in the flags register. we
-	 * choose these two values because they candy-stripe
-	 * the 5 flags that sahf sets.
+	 * Test with two values to candy-stripe the 5 flags stored/loaded by
+	 * SAHF/LAHF.
 	 */
-	sentinel = 0x91;
-	test_write_sentinel();
-
-	sentinel = 0x45;
-	test_write_sentinel();
+	test_write_sentinel(0x91);
+	test_write_sentinel(0x45);
 }
 
-
 static void test_vmcs_high(void)
 {
 	struct vmcs *vmcs = alloc_page();
-- 
2.38.0.rc1.362.ged0d419d3c-goog

