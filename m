Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B721A8822
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503163AbgDNSAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 14:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729303AbgDNSAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 14:00:19 -0400
Received: from mail-vk1-xa4a.google.com (mail-vk1-xa4a.google.com [IPv6:2607:f8b0:4864:20::a4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A85C061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 11:00:17 -0700 (PDT)
Received: by mail-vk1-xa4a.google.com with SMTP id n7so514641vkf.9
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 11:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BMm6dGEKBlgf/q10PWtvycCciSc+yReyJKANE+LD6lA=;
        b=syOsEm8sjMKq4GreRebqgo5TLOe1guPJYXFxYFqGNePu0y3H6SmX8eyu+/sXyJdaVG
         MZ2mWII+HFMKLjZTtvnmo5UkF3JKtglPYWFGgMaW9cG2wrJ/Mk6Kk+gvaIpSvSiTLXAr
         Cv1YibImDH53RXmajM9WmUPeYnMVv/88gaHtDmy0u1QuAoSE0dDUIELllA9US2bIvZlh
         svGMX7C2wwQUjkpLkJW218wXHATrZPIb7t2m3b6KMRJNG/o8WrSpp8DAmBxIKc0kVli5
         z1i6sKGf70rXMSdVoDfcqepSY/6qlzJGHIUIrzxpWDWJjQkVLxSiIFEUgIwJjRXukuwJ
         gbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BMm6dGEKBlgf/q10PWtvycCciSc+yReyJKANE+LD6lA=;
        b=rgl+Ow3aK91/IUAVyQ06zCVuOyIokcmzvIxm+NteEzPA//4tiDVS34BC13i4U9mCEv
         zWHCRF7Lq3MaLN4Wrc0Zru7wYtOJdCYbSJSAaGdPptFrAtBeShWG4XRs8CxteJpXgbno
         jiUISeqIG+ZCUI/0Sks9f5ZSNrNei8YV8TE3UJPP8qfLIhzQ7asQFJaebVuKgXeRx+8d
         HZeLE/FeB0YcAZpVwtzJAeWHh7zwkhQyUI4RByrgzgZapsD/bP5ZPc5yUsoPMPyO3t7l
         QGHsY+CwqpKNJs2PgBIdZZyCvNbqOEobq5q7FK1HGZpXPbM0PX5+RPccobUAAirFPg/7
         WLTw==
X-Gm-Message-State: AGi0PubVfMDl4zeVTRKXaN+21LF4Ya0EFJG7m+M3wY37+3kuNMUhcYVJ
        DAs1G8oC5nluexEKJQ/BF+pD9XvD+4LxhqbuMQY8zCwmlXaHCnbKGvydgOxExcnkTfN2kkNZ2V9
        RKujuwhm4RAeo1Wo1oceAgdqbzoBnLoH+Z3p69MIB9eAH9fI1ZLvTEA3Ftbd8mFoZV09rDUI=
X-Google-Smtp-Source: APiQypItApa9hKodEsxRQO9GhOePkUOBXgOCyS9b4W8kTBOrInCm/CWPUO555cqUWNMoOw7MdRXxPsHiWmcsi6Z2og==
X-Received: by 2002:ac5:cd83:: with SMTP id i3mr15918224vka.58.1586887216395;
 Tue, 14 Apr 2020 11:00:16 -0700 (PDT)
Date:   Tue, 14 Apr 2020 10:59:59 -0700
Message-Id: <20200414175959.184053-1-brigidsmith@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [kvm-unit-tests PATCH] x86: nVMX: add new test for vmread/vmwrite
 flags preservation
From:   Simon Smith <brigidsmith@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Simon Smith <brigidsmith@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds new unit tests for commit a4d956b93904 ("KVM: nVMX:
vmread should not set rflags to specify success in case of #PF")

The two new tests force a vmread and a vmwrite on an unmapped
address to cause a #PF and verify that the low byte of %rflags is
preserved and that %rip is not advanced.  The commit fixed a
bug in vmread, but we include a test for vmwrite as well for
completeness.

Before the aforementioned commit, the ALU flags would be incorrectly
cleared and %rip would be advanced (for vmread).

v1: https://www.spinics.net/lists/kvm/msg212817.html

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Simon Smith <brigidsmith@google.com>
---
 x86/vmx.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index 647ab49408876..e9235ec4fcad9 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -32,6 +32,7 @@
 #include "processor.h"
 #include "alloc_page.h"
 #include "vm.h"
+#include "vmalloc.h"
 #include "desc.h"
 #include "vmx.h"
 #include "msr.h"
@@ -368,6 +369,122 @@ static void test_vmwrite_vmread(void)
 	free_page(vmcs);
 }
 
+ulong finish_fault;
+u8 sentinel;
+bool handler_called;
+static void pf_handler(struct ex_regs *regs)
+{
+	// check that RIP was not improperly advanced and that the
+	// flags value was preserved.
+	report("RIP has not been advanced!",
+		regs->rip < finish_fault);
+	report("The low byte of RFLAGS was preserved!",
+		((u8)regs->rflags == ((sentinel | 2) & 0xd7)));
+
+	regs->rip = finish_fault;
+	handler_called = true;
+
+}
+
+static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
+{
+	// get an unbacked address that will cause a #PF
+	*vpage = alloc_vpage();
+
+	// set up VMCS so we have something to read from
+	*vmcs = alloc_page();
+
+	memset(*vmcs, 0, PAGE_SIZE);
+	(*vmcs)->hdr.revision_id = basic.revision;
+	assert(!vmcs_clear(*vmcs));
+	assert(!make_vmcs_current(*vmcs));
+
+	*old = handle_exception(PF_VECTOR, &pf_handler);
+}
+
+static void test_read_sentinel(void)
+{
+	void *vpage;
+	struct vmcs *vmcs;
+	handler old;
+
+	prep_flags_test_env(&vpage, &vmcs, &old);
+
+	// set the proper label
+	extern char finish_read_fault;
+
+	finish_fault = (ulong)&finish_read_fault;
+
+	// execute the vmread instruction that will cause a #PF
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmread %[enc], %[val]; finish_read_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah"
+		      );
+	report("The #PF handler was invoked", handler_called);
+
+	// restore old #PF handler
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmread_flags_touch(void)
+{
+	// set up the sentinel value in the flags register. we
+	// choose these two values because they candy-stripe
+	// the 5 flags that sahf sets.
+	sentinel = 0x91;
+	test_read_sentinel();
+
+	sentinel = 0x45;
+	test_read_sentinel();
+}
+
+static void test_write_sentinel(void)
+{
+	void *vpage;
+	struct vmcs *vmcs;
+	handler old;
+
+	prep_flags_test_env(&vpage, &vmcs, &old);
+
+	// set the proper label
+	extern char finish_write_fault;
+
+	finish_fault = (ulong)&finish_write_fault;
+
+	// execute the vmwrite instruction that will cause a #PF
+	handler_called = false;
+	asm volatile ("movb %[byte], %%ah\n\t"
+		      "sahf\n\t"
+		      "vmwrite %[val], %[enc]; finish_write_fault:"
+		      : [val] "=m" (*(u64 *)vpage)
+		      : [byte] "Krm" (sentinel),
+		      [enc] "r" ((u64)GUEST_SEL_SS)
+		      : "cc", "ah"
+		      );
+	report("The #PF handler was invoked", handler_called);
+
+	// restore old #PF handler
+	handle_exception(PF_VECTOR, old);
+}
+
+static void test_vmwrite_flags_touch(void)
+{
+	// set up the sentinel value in the flags register. we
+	// choose these two values because they candy-stripe
+	// the 5 flags that sahf sets.
+	sentinel = 0x91;
+	test_write_sentinel();
+
+	sentinel = 0x45;
+	test_write_sentinel();
+}
+
+
 static void test_vmcs_high(void)
 {
 	struct vmcs *vmcs = alloc_page();
@@ -1994,6 +2111,10 @@ int main(int argc, const char *argv[])
 		test_vmcs_lifecycle();
 	if (test_wanted("test_vmx_caps", argv, argc))
 		test_vmx_caps();
+	if (test_wanted("test_vmread_flags_touch", argv, argc))
+		test_vmread_flags_touch();
+	if (test_wanted("test_vmwrite_flags_touch", argv, argc))
+		test_vmwrite_flags_touch();
 
 	/* Balance vmxon from test_vmxon. */
 	vmx_off();
-- 
2.26.0.110.g2183baf09c-goog

